package org.mnu.service;

import java.util.List;
import java.util.Map;

import org.mnu.domain.Criteria;
import org.mnu.domain.ReviewVO;
import org.mnu.mapper.BoardMapper;
import org.mnu.mapper.ReviewMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewMapper mapper;
    private final BoardMapper boardMapper;

    // ================== 리뷰 등록 ==================
    @Transactional
    @Override
    public int register(ReviewVO vo) {
        log.info("register...... {}", vo);

        // 1. 리뷰 등록
        int result = mapper.insert(vo);
        log.info("리뷰 등록 성공, result = {}", result);

        // 2. 게시판 통계 업데이트 (평균 평점 / 리뷰 수 등)
        boardMapper.updateReviewStats(vo.getBno());
        log.info("게시판 통계 업데이트 성공, bno = {}", vo.getBno());

        return result;
    }

    // ================== 단건 조회 ==================
    @Override
    public ReviewVO get(Long rno) {
        log.info("get...... rno={}", rno);
        return mapper.read(rno);
    }

    // ================== 수정 ==================
    @Transactional
    @Override
    public int modify(ReviewVO vo) {
        log.info("modify...... {}", vo);

        int result = mapper.update(vo);
        // 리뷰 수정 후 통계 갱신
        boardMapper.updateReviewStats(vo.getBno());

        return result;
    }

    // ================== 삭제 ==================
    @Transactional
    @Override
    public int remove(Long rno) {
        log.info("remove...... rno={}", rno);

        // 삭제 전에 bno 확보
        ReviewVO vo = mapper.read(rno);

        int result = mapper.delete(rno);

        if (vo != null) {
            // 리뷰 삭제 후 통계 갱신
            boardMapper.updateReviewStats(vo.getBno());
        }

        return result;
    }

    // ================== 목록/통계 ==================
    @Override
    public List<ReviewVO> getList(Criteria cri, Long bno) {
        log.info("get review list of board bno={}", bno);
        return mapper.getListWithPaging(bno, cri);
    }

    @Override
    public int getTotal(Long bno) {
        log.info("get total review count of board bno={}", bno);
        return mapper.getCountByBno(bno);
    }

    @Override
    public List<Map<String, Object>> getRatingDistribution(Long bno) {
        log.info("get rating distribution of board bno={}", bno);
        return mapper.getRatingDistribution(bno);
    }
}
