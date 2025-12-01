package org.mnu.controller;

import java.util.List;
import java.util.Map;

import org.mnu.domain.ReservationVO;
import org.mnu.service.ReservationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/reservation")
@RequiredArgsConstructor
public class AdminReservationController {

    private final ReservationService reservationService;

    // 시설/용품별 예약현황 + 선택된 bno의 예약목록
    @GetMapping("/status")
    public String status(@RequestParam(name = "bno", required = false) Long bno,
                         Model model) {

        List<Map<String, Object>> stats = reservationService.getStatsByBno();
        model.addAttribute("stats", stats);

        if (bno != null) {
            List<ReservationVO> list = reservationService.getListByBno(bno);
            model.addAttribute("list", list);
            model.addAttribute("selectedBno", bno);
        }

        return "admin/reservationStatus";   // /WEB-INF/views/admin/reservationStatus.jsp
    }
}
