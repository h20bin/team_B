package org.mnu.controller;

import org.mnu.domain.MemberVO;
import org.mnu.service.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@AllArgsConstructor
public class MemberController {

    private MemberService service;

    @GetMapping("/member/register")
    public void register() {
        // 회원가입 페이지 보여주기
    }

    @PostMapping("/member/register")
    public String register(MemberVO member, RedirectAttributes rttr) {
        log.info("register: " + member);

        // 비밀번호 검증: 8자리 이상, 특수문자 포함
        if (!member.getPassword().matches("^(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]).{8,}$")) {
            rttr.addFlashAttribute("error", "비밀번호는 8자리 이상, 특수문자를 포함해야 합니다.");
            return "redirect:/member/register";
        }

        service.register(member);
        rttr.addFlashAttribute("result", "회원가입 성공!");
        return "redirect:/member/register";
    }
}
