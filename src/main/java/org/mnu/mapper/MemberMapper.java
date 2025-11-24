package org.mnu.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Mapper;
import org.mnu.domain.MemberVO;

@Mapper
public interface MemberMapper {

    // 회원가입 (기존 코드)
    @Insert("INSERT INTO member(userid, password, email, name) VALUES(#{userid}, #{password}, #{email}, #{name})")
    public void insert(MemberVO member);

    // ★ 로그인 (이 부분이 없어서 추가했습니다!)
    // 아이디와 비밀번호가 일치하는 회원을 찾아 정보를 가져오는 쿼리입니다.
    @Select("SELECT * FROM member WHERE userid = #{userid} AND password = #{password}")
    public MemberVO login(MemberVO member);

}