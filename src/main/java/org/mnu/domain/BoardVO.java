package org.mnu.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private Long bno;
    private String title;
    private String content;
    private String writer;
    private Date regdate;
    private Date updateDate;
    private int viewcnt;
    private String location;
    
    // 카테고리 (facility: 시설, goods: 용품)
    private String category;
    
    // 리뷰 기능 추가
    private int reviewCnt;
    private double ratingAvg;
    
    // 썸네일용 필드 (DB 컬럼 없음, 매핑용)
    private String uuid;
    private String uploadPath;
    private String fileName;
    private boolean fileType;
    
    private List<AttachVO> attachList;
}

