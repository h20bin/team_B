package org.mnu.service;

import java.util.List;
import java.util.Map;

import org.mnu.domain.ReservationVO;
import org.mnu.domain.WaitingVO;
import org.mnu.mapper.ReservationMapper;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReservationService {

    private final ReservationMapper reservationMapper;
    private final WaitingService waitingService;   // 대기 서비스

    // ================== 예약 등록 ==================

    /**
     * 예약 시도 (겹치면 false, 성공하면 true)
     */
    public boolean reserve(ReservationVO vo) {

        // status 가 비어 있으면 기본값 RESERVED
        if (vo.getStatus() == null || vo.getStatus().isEmpty()) {
            vo.setStatus("RESERVED");
        }

        // 시간 겹침 여부 체크
        int cnt = reservationMapper.countOverlap(vo);
        if (cnt > 0) {
            // 이미 겹치는 예약이 존재
            return false;
        }

        reservationMapper.insert(vo);
        return true;
    }

    // ================== 사용자용 조회 ==================

    /** 내 예약 목록 */
    public List<ReservationVO> getMyList(String userid) {
        return reservationMapper.getMyList(userid);
    }

    /** 예약 단건 조회 */
    public ReservationVO read(Long resId) {
        return reservationMapper.read(resId);
    }

    // ================== 예약 취소 + 대기자 자동 승계 ==================

    /**
     * 예약 취소 + 대기자 자동 승계
     *
     * @param resId   취소할 예약 번호
     * @param loginId 현재 로그인한 사용자 아이디
     * @return 성공 true, 실패 false
     */
    public boolean cancel(Long resId, String loginId) {

        // 1. 예약 정보 조회
        ReservationVO origin = reservationMapper.read(resId);
        if (origin == null) {
            return false;   // 그런 예약 없음
        }

        // 2. 본인 예약인지 확인
        if (!loginId.equals(origin.getUserid())) {
            return false;
        }

        // 3. 상태가 RESERVED 인 것만 취소 허용
        if (!"RESERVED".equals(origin.getStatus())) {
            return false;
        }

        // 4. DB 에서 상태를 CANCELLED 로 변경
        int updated = reservationMapper.cancel(resId, loginId);
        if (updated == 0) {
            // where 조건에 안 걸린 경우(이미 취소됐거나, 아이디가 다르거나)
            return false;
        }

        // 5. 대기자 자동 승계 처리
        //    - 동일 bno / resDate 기준으로 1순위 대기자 조회
        WaitingVO next = waitingService.promoteNext(origin.getBno(), origin.getResDate());

        if (next != null) {
            // 5-1. 대기자 정보를 이용해 새로운 예약 생성
            ReservationVO newRes = new ReservationVO();
            newRes.setBno(origin.getBno());
            newRes.setUserid(next.getUserid());
            newRes.setResDate(origin.getResDate());
            newRes.setStartTime(origin.getStartTime());
            newRes.setEndTime(origin.getEndTime());
            newRes.setStatus("RESERVED");

            // 기존 예약은 이미 CANCELLED 이라 중복 문제 없음
            reservationMapper.insert(newRes);

            // 5-2. (선택) 알림 전송은 나중에 구현
            System.out.println("[대기 자동 승계] " + next.getUserid()
                    + " 님에게 예약이 승계되었습니다.");
        }

        return true;
    }

    // ================== 관리자용 기능 ==================

    /** 전체 예약 목록 (관리자용) */
    public List<ReservationVO> getAll() {
        return reservationMapper.getAll();
    }

    /** 시설/용품별 예약 통계 (bno 기준, 관리자용) */
    public List<Map<String, Object>> getStatsByBno() {
        // ReservationMapper.xml 에서 <select id="countByBno"> 로 구현한 쿼리 호출
        return reservationMapper.countByBno();
    }

    /** 특정 bno 의 예약 목록 (관리자용) */
    public List<ReservationVO> getListByBno(Long bno) {
        return reservationMapper.getByBno(bno);
    }
}
