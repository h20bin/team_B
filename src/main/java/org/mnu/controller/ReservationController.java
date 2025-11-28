package org.mnu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.mnu.domain.ReservationVO;
import org.mnu.service.ReservationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/reservation")
@RequiredArgsConstructor
public class ReservationController {

    private final ReservationService reservationService;

    // 예약 폼 화면
    @GetMapping("/form")
    public String form(@RequestParam("bno") Long bno, Model model) {
        model.addAttribute("bno", bno);
        return "reservation/form";  // /WEB-INF/views/reservation/form.jsp
    }

    // 예약 처리
    @PostMapping("/do")
    public String doReserve(ReservationVO vo,
                            HttpSession session,
                            Model model) {

        String loginId = (String) session.getAttribute("loginId"); 
        vo.setUserid(loginId);

        boolean ok = reservationService.reserve(vo);

        if (!ok) {
            model.addAttribute("msg", "이미 해당 시간에 예약이 있습니다.");
            model.addAttribute("bno", vo.getBno());
            return "reservation/form";
        }

        return "redirect:/reservation/my";
    }

    // 내 예약 목록
    @GetMapping("/my")
    public String myReservations(HttpSession session, Model model) {

        String loginId = (String) session.getAttribute("loginId");
        List<ReservationVO> list = reservationService.getMyList(loginId);

        model.addAttribute("list", list);
        return "reservation/my";
    }
}
