package org.mnu.controller;

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
	public void adminMain(Criteria cri, Model model) {
		log.info("관리자 페이지 - 게시물 목록");
		model.addAttribute("list", boardService.getList(cri));
        model.addAttribute("pageMaker", new PageDTO(cri, boardService.getTotal()));
	}

}
