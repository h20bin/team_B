package org.mnu.domain;

import lombok.ToString;

@ToString
public class Criteria {

    private int page;
    private int perPageNum;
    
    private String type;
    private String keyword;
    
    // 필터링 조건 추가
    private String category;
    private String sido;
    private String gugun;

    public Criteria() {
        this.page = 1;
        this.perPageNum = 9;
    }

    public void setPage(int page) {
        if (page <= 0) {
            this.page = 1;
            return;
        }
        this.page = page;
    }

    public void setPerPageNum(int perPageNum) {
        if (perPageNum <= 0 || perPageNum > 100) {
            this.perPageNum = 10;
            return;
        }
        this.perPageNum = perPageNum;
    }

    public int getPage() {
        return page;
    }

    // method for MyBatis SQL Mapper
    public int getPageStart() {
        return (this.page - 1) * perPageNum;
    }

    public int getPerPageNum() {
        return perPageNum;
    }
    
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
    
    public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getSido() {
		return sido;
	}

	public void setSido(String sido) {
		this.sido = sido;
	}

	public String getGugun() {
		return gugun;
	}

	public void setGugun(String gugun) {
		this.gugun = gugun;
	}

	public String[] getTypeArr() {
        return type == null ? new String[] {} : type.split("");
    }
}
