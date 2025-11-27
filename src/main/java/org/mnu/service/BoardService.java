package org.mnu.service;

import java.util.List;
import org.mnu.domain.AttachVO;
import org.mnu.domain.BoardVO;
import org.mnu.domain.Criteria;

public interface BoardService {

	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
		public List<BoardVO> getList(Criteria cri);
		
		public int getTotal(Criteria cri);
		
		public List<AttachVO> getAttachList(Long bno);
	// 리뷰 통계 업데이트
	public void updateReviewStats(Long bno);
	
	// 관리자용: 내 게시글만 보기
	public List<BoardVO> getListByWriter(Criteria cri, String writer);
	public int getTotalByWriter(String writer);
	
	// 지역 목록
	public List<String> getLocations();
}
