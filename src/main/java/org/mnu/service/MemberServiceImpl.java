package org.mnu.service;

import org.mnu.domain.MemberVO;
import org.mnu.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;

@Service
public class MemberServiceImpl implements MemberService {

    @Setter(onMethod_ = @Autowired)
    private MemberMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private PasswordEncoder passwordEncoder;

    @Transactional
    @Override
    public void register(MemberVO member) {
        // 비밀번호 암호화
        member.setPassword(passwordEncoder.encode(member.getPassword()));
        
        // 기본 권한 설정
        member.setAuth("ROLE_USER");
        
        // 회원 정보 저장 (권한 포함)
        mapper.insert(member);
    }

    @Override
    public MemberVO login(MemberVO member) {
        // Spring Security로 대체될 예정이므로 지금은 중요하지 않음
        return null;
    }
}