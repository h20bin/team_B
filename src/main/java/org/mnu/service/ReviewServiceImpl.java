package org.mnu.service;

import java.util.List;

import org.mnu.domain.Criteria;
import org.mnu.domain.ReviewVO;
import org.mnu.mapper.BoardMapper;
import org.mnu.mapper.ReviewMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class ReviewServiceImpl implements ReviewService {
	
	@Setter(onMethod_ = @Autowired)
	private ReviewMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;

	@Transactional
	@Override
	public int register(ReviewVO vo) {
		log.info("register......" + vo);
		
		int result = 0;
		
		try {
			// 1. 리뷰 등록 시도
			result = mapper.insert(vo);
			log.info("리뷰 등록 성공, 결과: " + result);
		} catch (Exception e) {
			log.error("!!!!!!!!!! 리뷰 등록(mapper.insert) 실패 !!!!!!!!!!", e);
			// 예외를 다시 던져서 트랜잭션이 롤백되도록 함
			throw new RuntimeException("리뷰 등록 실패", e);
		}
		
		try {
			// 2. 게시판 통계 업데이트 시도
			boardMapper.updateReviewStats(vo.getBno());
			log.info("게시판 통계 업데이트 성공, bno: " + vo.getBno());
		} catch (Exception e) {
			log.error("!!!!!!!!!! 게시판 통계 업데이트(boardMapper.updateReviewStats) 실패 !!!!!!!!!!", e);
			// 이 예외는 트랜잭션을 롤백시킴
			throw new RuntimeException("게시판 통계 업데이트 실패", e);
		}
		
		return result;
	}

	@Override
	public ReviewVO get(Long rno) {
		log.info("get......." + rno);
		return mapper.read(rno);
	}

	@Transactional
	@Override
	public int modify(ReviewVO vo) {
		log.info("modify......" + vo);
		// 리뷰 수정
		int result = mapper.update(vo);
		// 평균 평점/리뷰 수 업데이트
		boardMapper.updateReviewStats(vo.getBno());
		return result;
	}

	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("remove......" + rno);
		// bno를 먼저 확보
		ReviewVO vo = mapper.read(rno);
		// 리뷰 삭제
		int result = mapper.delete(rno);
		// 평균 평점/리뷰 수 업데이트
		if (vo != null) {
			boardMapper.updateReviewStats(vo.getBno());
		}
		return result;
	}

	@Override
	public List<ReviewVO> getList(Criteria cri, Long bno) {
		log.info("get review list of a board " + bno);
		return mapper.getListWithPaging(bno, cri);
	}

	@Override
	public int getTotal(Long bno) {
		log.info("get total review count of board " + bno);
		return mapper.getCountByBno(bno);
	}

	@Override
	public List<java.util.Map<String, Object>> getRatingDistribution(Long bno) {
		log.info("get rating distribution of board " + bno);
		return mapper.getRatingDistribution(bno);
	}

}
