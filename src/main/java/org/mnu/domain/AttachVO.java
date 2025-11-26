package org.mnu.domain;

import java.io.Serializable;
import lombok.Data;

@Data
public class AttachVO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	
	private Long bno;

}
