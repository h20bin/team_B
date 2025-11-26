package org.mnu.domain;

import java.io.Serializable;
import lombok.Data;

@Data
public class MemberVO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String userid;
	private String password;
	private String email;
	private String name;
	
	private String auth;

}
