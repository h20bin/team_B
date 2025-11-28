package org.mnu.mapper;

import java.util.List;

import org.mnu.domain.ReservationVO;

public interface ReservationMapper {

    // 해당 시간에 이미 예약이 있는지 확인
    public int countOverlap(ReservationVO vo);

    // 예약 등록
    public int insert(ReservationVO vo);

    // 내 예약 목록
    public List<ReservationVO> getMyList(String userid);
}
