package org.mnu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.mnu.domain.ReservationVO;

public interface ReservationMapper {

    // 1. 중복 예약 체크
    int countOverlap(ReservationVO vo);

    // 2. 예약 등록
    void insert(ReservationVO vo);

    // 3. 내 예약 목록
    List<ReservationVO> getMyList(@Param("userid") String userid);

    // 4. 예약 단건 조회
    ReservationVO read(@Param("resId") Long resId);

    // 5. 예약 상태 CANCELLED 로 변경
    int cancel(@Param("resId") Long resId,
               @Param("userid") String userid);

    // ===== 관리자용 =====

    // 전체 예약 목록
    List<ReservationVO> getAll();

    // 시설/용품별 예약 수 집계
    List<Map<String, Object>> countByBno();

    // 특정 bno 의 예약 목록
    List<ReservationVO> getByBno(@Param("bno") Long bno);
}
