package org.mnu.mapper;

import java.util.List;
import java.util.Map;  

import org.apache.ibatis.annotations.Param;
import org.mnu.domain.ReservationVO;

public interface ReservationMapper {

    // 해당 시간에 이미 예약이 있는지 확인
    int countOverlap(ReservationVO vo);

    // 예약 등록
    int insert(ReservationVO vo);

    // 내 예약 목록
    List<ReservationVO> getMyList(String userid);

    // 예약 단건 조회
    ReservationVO read(Long resId);

    // 예약 상태를 CANCELLED 로 변경
    int cancel(@Param("resId") Long resId,
               @Param("userid") String userid);
    
    // 모든 예약 목록 (관리자) //
    List<ReservationVO> getAll();

    // 시설/용품별 예약 통계 (bno 기준) //
    List<Map<String, Object>> getStatsByBno();
}
