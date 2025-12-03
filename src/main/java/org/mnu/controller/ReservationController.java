package org.mnu.controller;

import java.security.Principal;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
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
    private final WaitingService waitingService;

    // ================== 예약 폼 ==================
    @GetMapping("/form")
    public String form(@RequestParam("bno") Long bno, Model model) {
        model.addAttribute("bno", bno);
        return "reservation/form";
    }

    // ================== 예약 처리 ==================
    @PostMapping("/do")
    public String doReserve(ReservationVO vo,
                            Principal principal,
                            RedirectAttributes rttr,
                            Model model) {

        // 로그인 체크
        if (principal == null) {
            rttr.addFlashAttribute("msg", "로그인 후 예약이 가능합니다.");
            return "redirect:/member/login";
        }

        String loginId = principal.getName();
        vo.setUserid(loginId);

        // ------------ 🔥 시간 포맷 통일 (팀원 문제 해결 핵심) ------------
        // "9:00" → "09:00" 으로 보정
        if (vo.getStartTime() != null && vo.getStartTime().length() == 4) {
            vo.setStartTime("0" + vo.getStartTime());
        }
        if (vo.getEndTime() != null && vo.getEndTime().length() == 4) {
            vo.setEndTime("0" + vo.getEndTime());
        }
        // -----------------------------------------------------------------

        // ---------- 1. 시작/종료 시간 유효성 검사 ----------
        try {
            LocalTime start = LocalTime.parse(vo.getStartTime()); 
            LocalTime end   = LocalTime.parse(vo.getEndTime());   

            if (!start.isBefore(end)) {
                model.addAttribute("msg", "시작 시간은 종료 시간보다 빨라야 합니다.");
                model.addAttribute("bno", vo.getBno());
                model.addAttribute("overlap", false);
                model.addAttribute("prevStart", vo.getStartTime());
                model.addAttribute("prevEnd", vo.getEndTime());
                model.addAttribute("prevDate", vo.getResDate());
                return "reservation/form";
            }

        } catch (DateTimeParseException e) {
            model.addAttribute("msg", "시간 형식이 올바르지 않습니다. (예: 09:00)");
            model.addAttribute("bno", vo.getBno());
            model.addAttribute("overlap", false);
            model.addAttribute("prevStart", vo.getStartTime());
            model.addAttribute("prevEnd", vo.getEndTime());
            model.addAttribute("prevDate", vo.getResDate());
            return "reservation/form";
        }
        // ---------- 유효성 검사 끝 ----------

        // ---------- 2. 예약 시도 (시간 겹침 방지) ----------
        boolean ok = reservationService.reserve(vo);

        if (!ok) {
            model.addAttribute("msg", "이미 해당 시간에 예약이 있습니다. 대기 예약 하시겠습니까?");
            model.addAttribute("bno", vo.getBno());
            model.addAttribute("overlap", true);
            model.addAttribute("prevStart", vo.getStartTime());
            model.addAttribute("prevEnd", vo.getEndTime());
            model.addAttribute("prevDate", vo.getResDate());
            return "reservation/form";
        }

        rttr.addFlashAttribute("msg", "예약이 완료되었습니다.");
        return "redirect:/reservation/my";
    }

    // ================== 대기 예약 ==================
    @PostMapping("/wait")
    public String waitReserve(ReservationVO vo,
                              Principal principal,
                              RedirectAttributes rttr,
                              Model model) {

        if (principal == null) {
            rttr.addFlashAttribute("msg", "로그인 후 대기 예약이 가능합니다.");
            return "redirect:/member/login";
        }

        String loginId = principal.getName();
        vo.setUserid(loginId);

        if (vo.getResDate() == null) {
            model.addAttribute("msg", "예약 날짜를 다시 선택해주세요.");
            model.addAttribute("bno", vo.getBno());
            return "reservation/form";
        }

        waitingService.addWaiting(vo.getBno(), loginId, vo.getResDate());

        rttr.addFlashAttribute("msg", "대기 예약이 등록되었습니다.");
        return "redirect:/reservation/wait";
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

        return "reservation/my";
    }

    // ================== 내 대기 목록 ==================
    @GetMapping("/wait")
    public String myWaiting(Principal principal, Model model) {

        if (principal == null) {
            return "redirect:/member/login";
        }

        String loginId = principal.getName();
        model.addAttribute("waitList", waitingService.getMyWaiting(loginId));

        return "reservation/wait";
    }

    // ================== 예약 취소 (+ 자동 승계) ==================
    @PostMapping("/cancel")
    public String cancel(@RequestParam("resId") Long resId,
                         Principal principal,
                         RedirectAttributes rttr) {

        if (principal == null) {
            return "redirect:/member/login";
        }

        String loginId = principal.getName();

        boolean ok = reservationService.cancel(resId, loginId);

        if (ok) {
            rttr.addFlashAttribute("msg", "예약이 취소되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "취소할 수 없는 예약입니다.");
        }

        return "redirect:/reservation/my";
    }
}
