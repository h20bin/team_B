package org.mnu.domain;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import lombok.Data;

@Data
public class WaitingVO {

    private Long waitId;
    private Long bno;
    private String userid;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date resDate;

    private Integer priority;
    private String status;
    private Date regdate;
}
