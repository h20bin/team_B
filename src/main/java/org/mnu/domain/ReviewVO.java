package org.mnu.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReviewVO {
	
	private Long rno;
	private Long bno;
	
	private String userid;
	private int rating;
	private String content;
	
	private Date regdate;
	private Date updatedate;

}
