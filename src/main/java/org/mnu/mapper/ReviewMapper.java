package org.mnu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.mnu.domain.Criteria;
import org.mnu.domain.ReviewVO;

public interface ReviewMapper {
	
	public int insert(ReviewVO vo);
	
	public ReviewVO read(Long rno);
	
	public int delete(Long rno);
	
	public int update(ReviewVO review);
	
	public List<ReviewVO> getListWithPaging(
			@Param("bno") Long bno,
			@Param("cri") Criteria cri);
	
	public int getCountByBno(Long bno);
	
	public List<Map<String, Object>> getRatingDistribution(Long bno);

}
