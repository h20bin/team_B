package org.mnu.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.mnu.domain.WaitingVO;

public interface WaitingMapper {

    // 대기 신청 등록
    int insert(WaitingVO vo);

    // 해당 bno+날짜의 최대 priority 구하기
    Integer getMaxPriority(@Param("bno") Long bno,
                           @Param("resDate") java.util.Date resDate);

    // 자동 승계용: 가장 먼저 신청한 대기자 1명
    WaitingVO findNext(@Param("bno") Long bno,
                       @Param("resDate") java.util.Date resDate);

    // 대기 상태 변경 (WAIT → MOVED / CANCELLED 등)
    int updateStatus(@Param("waitId") Long waitId,
                     @Param("status") String status);

    // 내 대기 예약 목록
    List<WaitingVO> getMyWaiting(String userid);
}
