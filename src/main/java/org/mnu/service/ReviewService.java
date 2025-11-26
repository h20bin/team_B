package org.mnu.service;

import java.util.List;

import org.mnu.domain.Criteria;
import org.mnu.domain.ReviewVO;

public interface ReviewService {
	
	public int register(ReviewVO vo);
	
	public ReviewVO get(Long rno);
	
	public int modify(ReviewVO vo);
	
	public int remove(Long rno);
	
	public List<ReviewVO> getList(Criteria cri, Long bno);
	
	public int getTotal(Long bno);
	
	public List<java.util.Map<String, Object>> getRatingDistribution(Long bno);

}
