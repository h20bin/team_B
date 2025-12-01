package org.mnu.domain;   // 

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

public class ReservationVO {

    private Long resId;
    private Long bno;
    private String userid;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date resDate;      // DATE 타입
    
    private String startTime;  // '09:00' 이런 문자열
    private String endTime;
    private String status;
    private Date regdate;

    // getter / setter
    public Long getResId() { return resId; }
    public void setResId(Long resId) { this.resId = resId; }

    public Long getBno() { return bno; }
    public void setBno(Long bno) { this.bno = bno; }

    public String getUserid() { return userid; }
    public void setUserid(String userid) { this.userid = userid; }

    public Date getResDate() { return resDate; }
    public void setResDate(Date resDate) { this.resDate = resDate; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }
}
