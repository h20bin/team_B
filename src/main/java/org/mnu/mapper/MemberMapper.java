package org.mnu.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Mapper;
import org.mnu.domain.MemberVO;

@Mapper
public interface MemberMapper {

    @Insert("INSERT INTO member(userid, password, email, name) VALUES(#{userid}, #{password}, #{email}, #{name})")
    public void insert(MemberVO member);

    @Select("SELECT userid, password, email, name FROM member WHERE userid = #{userid} AND password = #{password}")
    public MemberVO login(MemberVO member);
}