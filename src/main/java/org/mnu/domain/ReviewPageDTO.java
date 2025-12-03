package org.mnu.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ReviewPageDTO {

    private int reviewCnt;           // 총 리뷰 개수
    private List<ReviewVO> list;     // 현재 페이지 리뷰 목록
}
