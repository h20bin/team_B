package org.mnu.mapper;

import java.util.List;
import org.mnu.domain.AttachVO;
import org.mnu.domain.BoardVO;
import org.mnu.domain.Criteria;

public interface BoardMapper {
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int getTotalCount();
	
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
}
