package org.mnu.controller;

import java.security.Principal;
import java.util.List;

import org.mnu.domain.ReservationVO;
import org.mnu.service.ReservationService;
import org.mnu.service.WaitingService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/reservation")
@RequiredArgsConstructor
public class ReservationController {

    private final ReservationService reservationService;
    private final WaitingService waitingService;   // ★ 대기 관련 서비스 주입

    // ================== 예약 폼 ==================
    @GetMapping("/form")
    public String form(@RequestParam("bno") Long bno, Model model) {
        model.addAttribute("bno", bno);
        return "reservation/form";   // /WEB-INF/views/reservation/form.jsp
    }

    // ================== 예약 처리 ==================
    @PostMapping("/do")
    public String doReserve(ReservationVO vo,
                            Principal principal,
                            RedirectAttributes rttr,
                            Model model) {

        // 로그인 안 되어 있으면 로그인 페이지로
        if (principal == null) {
            rttr.addFlashAttribute("msg", "로그인 후 예약이 가능합니다.");
            return "redirect:/member/login";
        }

        String loginId = principal.getName(); // 아이디
        vo.setUserid(loginId);

        boolean ok = reservationService.reserve(vo);

        // ====== 겹치는 예약이 있을 때 : 대기예약으로 등록 ======
        if (!ok) {
            // 대기 테이블에 한 줄 추가
            waitingService.addWaiting(vo.getBno(), loginId, vo.getResDate());

            rttr.addFlashAttribute("msg",
                    "이미 해당 시간에 예약이 있어, 대기 예약으로 등록되었습니다.");
            // 내 대기예약 현황으로 이동
            return "redirect:/reservation/wait";
        }

        // ====== 정상 예약일 때 ======
        rttr.addFlashAttribute("msg", "예약이 완료되었습니다.");
        return "redirect:/reservation/my";
    }

    // ================== 내 예약 목록 ==================
    @GetMapping("/my")
    public String myReservations(Principal principal, Model model) {

        if (principal == null) {
            return "redirect:/member/login";
        }

        String loginId = principal.getName();
        List<ReservationVO> list = reservationService.getMyList(loginId);

        model.addAttribute("list", list);
        return "reservation/my";     // /WEB-INF/views/reservation/my.jsp
    }

    // ================== 내 대기 목록 ==================
    @GetMapping("/wait")
    public String myWaiting(Principal principal, Model model) {

        if (principal == null) {
            return "redirect:/member/login";
        }

        String loginId = principal.getName();

        // 로그인한 회원의 대기 목록
        model.addAttribute("waitList", waitingService.getMyWaiting(loginId));

        return "reservation/wait";   // /WEB-INF/views/reservation/wait.jsp
    }

    // ================== 예약 취소 ==================
    @PostMapping("/cancel")
    public String cancel(@RequestParam("resId") Long resId,
                         Principal principal,
                         RedirectAttributes rttr) {

        if (principal == null) {
            return "redirect:/member/login";
        }

        String loginId = principal.getName();

        // 자신의 예약이고, 상태가 RESERVED 인 건만 취소
        boolean ok = reservationService.cancel(resId, loginId);

        if (ok) {
            rttr.addFlashAttribute("msg", "예약이 취소되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "취소할 수 있는 예약이 아닙니다. (본인 예약인지 / 상태 확인)");
        }

        return "redirect:/reservation/my";
    }
}
