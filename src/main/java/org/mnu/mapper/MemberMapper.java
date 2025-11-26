package org.mnu.mapper;

import org.mnu.domain.MemberVO;

public interface MemberMapper {

	public MemberVO read(String userid);
	
	public void insert(MemberVO member);
	
}