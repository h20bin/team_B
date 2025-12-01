package org.mnu.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.mnu.domain.AttachVO;
import org.mnu.domain.BoardVO;
import org.mnu.domain.Criteria;

public interface BoardMapper {
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int getTotalCount(Criteria cri);
	
	public void insert(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public void updateViewCnt(Long bno);
	
	public void updateReviewStats(Long bno);

	// Attachments
	public List<AttachVO> findByBno(Long bno);
	
	public void insertAttach(AttachVO vo);
	
	public void deleteAllAttach(Long bno);
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
	
	// 작성자별 목록 조회 (관리자용)
	public List<BoardVO> getListByWriter(@Param("cri") Criteria cri, @Param("writer") String writer);
	
	// 작성자별 게시물 총 개수 (관리자용)
	public int getTotalCountByWriter(@Param("writer") String writer);
	
	// 지역 목록 조회 (필터용)
	public List<String> getLocations();
}
