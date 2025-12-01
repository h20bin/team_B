package org.mnu.controller;

import java.security.Principal;

import org.mnu.domain.Criteria;
import org.mnu.domain.PageDTO;
import org.mnu.service.BoardService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/admin/*")
@Log4j2
@AllArgsConstructor
public class AdminController {
	
	private BoardService boardService;
	
	@GetMapping("/main")
	public void adminMain(Criteria cri, Model model, Principal principal) {
		log.info("관리자 페이지 - 게시물 목록");
		String writer = principal.getName(); // 로그인한 사용자 ID (예: admin)
		log.info("접속한 관리자 ID: " + writer);
		
		// 본인이 작성한 글만 가져오도록 변경
		model.addAttribute("list", boardService.getListByWriter(cri, writer));
        model.addAttribute("pageMaker", new PageDTO(cri, boardService.getTotalByWriter(writer)));
	}
	
	@GetMapping("/reservation/list")
	public String adminReservationList(Model model) {
	    model.addAttribute("list", reservationService.getAll());
	    return "admin/reservationList";
	}
	
	@GetMapping("/reservation")
	public String reservationManage(Model model) {

	    // 시설/용품별 통계
	    model.addAttribute("statList", reservationService.getStatsByBno());

	    // 전체 예약 목록
	    model.addAttribute("resList", reservationService.getAll());

	    return "admin/reservationList";   // /WEB-INF/views/admin/reservationList.jsp
	}



}
