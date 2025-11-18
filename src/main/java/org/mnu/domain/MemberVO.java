package org.mnu.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberVO {
    private String userid;
    private String password;
    private String email;
    private String name;
}
