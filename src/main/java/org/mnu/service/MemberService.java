package org.mnu.service;

import org.mnu.domain.MemberVO;

public interface MemberService {
    
    // 회원가입
    void register(MemberVO member);

    //  로그인 메서드 선언
    MemberVO login(MemberVO member);
}