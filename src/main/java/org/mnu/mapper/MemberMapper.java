package org.mnu.mapper;

import org.mnu.domain.AuthVO;
import org.mnu.domain.MemberVO;

public interface MemberMapper {

	public MemberVO read(String userid);
	
	public void insert(MemberVO member);
	
	public void insertAuth(AuthVO auth);
	
}