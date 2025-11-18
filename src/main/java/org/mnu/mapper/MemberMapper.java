package org.mnu.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.mnu.domain.MemberVO;

@Mapper
public interface MemberMapper {

    @Insert("INSERT INTO member(userid, password, email, name) VALUES(#{userid}, #{password}, #{email}, #{name})")
    void insert(MemberVO member);

}
