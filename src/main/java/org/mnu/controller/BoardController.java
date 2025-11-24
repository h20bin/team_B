package org.mnu.controller;

import org.mnu.domain.AuthVO;
import org.mnu.domain.BoardVO;
import org.mnu.domain.Criteria;
import org.mnu.domain.MemberVO;
import org.mnu.domain.PageDTO;
import org.mnu.security.domain.CustomUser;
import org.mnu.service.BoardService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

    private BoardService service;

    // 현재 로그인한 사용자의 MemberVO를 가져오는 private 헬퍼 메서드
    private MemberVO getLoginUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUser) {
            return ((CustomUser) authentication.getPrincipal()).getMember();
        }
        return null;
    }
    
    // 현재 로그인한 사용자가 관리자인지 확인하는 private 헬퍼 메서드
    private boolean isLoginUserAdmin() {
    	MemberVO loginUser = getLoginUser();
    	if (loginUser == null) {
    		return false;
    	}
    	for (AuthVO auth : loginUser.getAuthList()) {
    		if ("ROLE_ADMIN".equals(auth.getAuth())) {
    			return true;
    		}
    	}
    	return false;
    }

    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list: " + cri);
        model.addAttribute("list", service.getList(cri));
        model.addAttribute("pageMaker", new PageDTO(cri, service.getTotal()));
        model.addAttribute("loginUser", getLoginUser());
    }

    @GetMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public void register() {
    }

    @PostMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public String register(BoardVO board, RedirectAttributes rttr) {
        MemberVO loginUser = getLoginUser();
        
        log.info("register: " + board);
        board.setWriter(loginUser.getUserid());
        service.register(board);
        
        rttr.addFlashAttribute("result", board.getBno());
        return "redirect:/board/list";
    }

    @GetMapping("/get")
    public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
        log.info("/get");
        model.addAttribute("board", service.get(bno));
        model.addAttribute("loginUser", getLoginUser());
    }

    @GetMapping("/modify")
    public String modify(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model, RedirectAttributes rttr) {
        BoardVO board = service.get(bno);
        MemberVO loginUser = getLoginUser();

        // 관리자가 아니고, 작성자도 아닌 경우
        if (!isLoginUserAdmin() && (loginUser == null || !loginUser.getUserid().equals(board.getWriter()))) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return "redirect:/board/list";
        }

        log.info("/modify page");
        model.addAttribute("board", board);
        return "/board/modify";
    }

    @PostMapping("/modify")
    public String modify(BoardVO board, Criteria cri, RedirectAttributes rttr) {
        log.info("modify:" + board);
        
        BoardVO originalBoard = service.get(board.getBno());
        MemberVO loginUser = getLoginUser();

        // 관리자가 아니고, 작성자도 아닌 경우
        if (!isLoginUserAdmin() && (loginUser == null || !loginUser.getUserid().equals(originalBoard.getWriter()))) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return "redirect:/board/list";
        }

        if (service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }
        rttr.addAttribute("page", cri.getPage());
        rttr.addAttribute("perPageNum", cri.getPerPageNum());
        return "redirect:/board/list";
    }

    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr) {
        log.info("remove..." + bno);
        
        BoardVO board = service.get(bno);
        MemberVO loginUser = getLoginUser();

        // 관리자가 아니고, 작성자도 아닌 경우
        if (!isLoginUserAdmin() && (loginUser == null || !loginUser.getUserid().equals(board.getWriter()))) {
            rttr.addFlashAttribute("msg", "삭제 권한이 없습니다.");
            return "redirect:/board/list";
        }
        
        if (service.remove(bno)) {
            rttr.addFlashAttribute("result", "success");
        }
        rttr.addAttribute("page", cri.getPage());
        rttr.addAttribute("perPageNum", cri.getPerPageNum());
        return "redirect:/board/list";
    }
}

