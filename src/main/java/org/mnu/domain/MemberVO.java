package org.mnu.domain;

import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	
	private String userid;
	private String password;
	private String email;
	private String name;
	
	private List<AuthVO> authList;

}
