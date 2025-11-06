package org.mnu.service;

import java.util.List;
import org.mnu.domain.BoardVO;
import org.mnu.domain.Criteria;

public interface BoardService {

	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	public List<BoardVO> getList(Criteria cri);
	public int getTotal();	
}
