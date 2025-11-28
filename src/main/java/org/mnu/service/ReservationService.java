package org.mnu.service;

import java.util.List;

import org.mnu.domain.ReservationVO;
import org.mnu.mapper.ReservationMapper;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReservationService {

    private final ReservationMapper reservationMapper;

    // 예약 시도 (겹치면 false)
    public boolean reserve(ReservationVO vo) {

        int cnt = reservationMapper.countOverlap(vo);
        if (cnt > 0) {
            return false; // 이미 예약 있음
        }

        reservationMapper.insert(vo);
        return true;
    }

    // 내 예약 목록
    public List<ReservationVO> getMyList(String userid) {
        return reservationMapper.getMyList(userid);
    }
}