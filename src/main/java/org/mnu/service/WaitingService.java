package org.mnu.service;

import java.util.Date;
import java.util.List;

import org.mnu.domain.WaitingVO;
import org.mnu.mapper.WaitingMapper;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WaitingService {

    private final WaitingMapper waitingMapper;

    /** 대기 신청 등록 (우선순위 자동 계산) */
    public void addWaiting(Long bno, String userid, Date resDate) {
        Integer maxPriority = waitingMapper.getMaxPriority(bno, resDate);
        int nextPriority = (maxPriority == null ? 0 : maxPriority) + 1;

        WaitingVO vo = new WaitingVO();
        vo.setBno(bno);
        vo.setUserid(userid);
        vo.setResDate(resDate);
        vo.setPriority(nextPriority);
        vo.setStatus("WAIT");

        waitingMapper.insert(vo);
    }

    /** 취소된 예약에 대해, 대기자 1명을 자동 승계 */
    public WaitingVO promoteNext(Long bno, Date resDate) {
        WaitingVO next = waitingMapper.findNext(bno, resDate);
        if (next == null) return null;

        waitingMapper.updateStatus(next.getWaitId(), "MOVED");
        return next;
    }

    public List<WaitingVO> getMyWaiting(String userid) {
        return waitingMapper.getMyWaiting(userid);
    }
}
