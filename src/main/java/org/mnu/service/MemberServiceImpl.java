package org.mnu.service;

import org.mnu.domain.MemberVO;
import org.mnu.mapper.MemberMapper;
import org.springframework.stereotype.Service;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class MemberServiceImpl implements MemberService {

    private MemberMapper mapper;

    @Override
    public void register(MemberVO member) {
        mapper.insert(member);
    }

    // ★★★ 여기가 비어있거나 return null; 로 되어 있으면 로그인이 안 됩니다!
    @Override
    public MemberVO login(MemberVO member) {
        System.out.println("서비스 로그인 호출됨: " + member.getUserid()); // 디버깅용 로그
        
        // 매퍼에게 일 시키기
        return mapper.login(member);
    }
}