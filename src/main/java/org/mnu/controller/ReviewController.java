package org.mnu.controller;

import java.util.List;
import java.util.Map;

import org.mnu.domain.Criteria;
import org.mnu.domain.ReviewPageDTO;
import org.mnu.domain.ReviewVO;
import org.mnu.service.ReviewService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@RequestMapping("/reviews/")
@RestController
@Log4j2
@AllArgsConstructor
public class ReviewController {

    private ReviewService service;
    
    @PostMapping(value="/new",
            consumes = "application/json",
            produces = {MediaType.TEXT_PLAIN_VALUE})
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> create(@RequestBody ReviewVO vo) {
        log.info("ReviewVO: " + vo);
        
        try {
            int insertCount = service.register(vo);
            log.info("Review INSERT COUNT: " + insertCount);
            
            return insertCount == 1
                    ? new ResponseEntity<>("success", HttpStatus.OK)
                    : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            log.error("Review registration failed: ", e);
            return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping(value = "/pages/{bno}/{page}",
            produces = { MediaType.APPLICATION_JSON_VALUE })
    public ResponseEntity<ReviewPageDTO> getList(
            @PathVariable("page") int page,
            @PathVariable("bno") Long bno) {
        
        log.info("getList...........");
        Criteria cri = new Criteria();
        cri.setPage(page);
        cri.setPerPageNum(10);
        
        return new ResponseEntity<>(new ReviewPageDTO(
                service.getTotal(bno),
                service.getList(cri, bno)), HttpStatus.OK);
    }
    
    @GetMapping(value = "/{rno}",
            produces= { MediaType.APPLICATION_JSON_VALUE })
    public ResponseEntity<ReviewVO> get(@PathVariable("rno") Long rno) {
        log.info("get: " + rno);
        return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
    }
    
    @PreAuthorize("principal.username == #vo.userid or hasRole('ROLE_ADMIN')")
    @DeleteMapping(value="/{rno}")
    public ResponseEntity<String> remove(@RequestBody ReviewVO vo, @PathVariable("rno") Long rno) {
        log.info("remove: " + rno);
        return service.remove(rno) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @PreAuthorize("principal.username == #vo.userid")
    @RequestMapping(method= {RequestMethod.PUT, RequestMethod.PATCH},
            value="/{rno}",
            consumes="application/json")
    public ResponseEntity<String> modify(@RequestBody ReviewVO vo, @PathVariable("rno") Long rno) {
        vo.setRno(rno);
        return service.modify(vo) == 1
            ? new ResponseEntity<>("success", HttpStatus.OK)
            : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    @GetMapping(value = "/stats/{bno}",
            produces = { MediaType.APPLICATION_JSON_VALUE })
    public ResponseEntity<List<Map<String, Object>>> getRatingStats(@PathVariable("bno") Long bno) {
        log.info("getRatingStats for bno: " + bno);
        return new ResponseEntity<>(service.getRatingDistribution(bno), HttpStatus.OK); 
    }
}