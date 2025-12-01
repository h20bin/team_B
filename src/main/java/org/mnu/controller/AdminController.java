package org.mnu.controller;

import java.security.Principal;

import org.mnu.domain.Criteria;
import org.mnu.domain.PageDTO;
import org.mnu.service.BoardService;
import org.mnu.service.ReservationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/admin")   // <-- /admin으로 고정
@Log4j2
@AllArgsConstructor
public class AdminController {
	
    private final BoardService boardService;
    private final ReservationService reservationService;   // ★ 추가

    // ================== 관리자 메인 (게시글) ==================
	@GetMapping("/main")
	public void adminMain(Criteria cri, Model model, Principal principal) {
		log.info("관리자 페이지 - 게시물 목록");

		String writer = principal.getName(); // 로그인한 관리자 ID (예: admin)
		log.info("접속한 관리자 ID: " + writer);
		
		// 본인이 작성한 글만
		model.addAttribute("list", boardService.getListByWriter(cri, writer));
        model.addAttribute("pageMaker",
                new PageDTO(cri, boardService.getTotalByWriter(writer)));
	}

    // ================== 시설/용품 예약 현황 ==================
	@GetMapping("/reservation")
	public String reservationManage(Model model) {

	    // 1) 시설/용품별 예약 통계
	    model.addAttribute("statList", reservationService.getStatsByBno());

	    // 2) 전체 예약 목록
	    model.addAttribute("resList", reservationService.getAll());

	    // /WEB-INF/views/admin/reservationList.jsp
	    return "admin/reservationList";
	}
}
