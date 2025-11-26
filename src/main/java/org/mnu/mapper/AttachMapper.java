package org.mnu.mapper;

import java.util.List;
import org.mnu.domain.AttachVO;

public interface AttachMapper {
	
	public void insert(AttachVO vo);
	
	public void deleteAll(Long bno);
	
	public List<AttachVO> findByBno(Long bno);

}
