package org.mnu.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mnu.domain.MemberVO;
import org.mnu.service.MemberService;
import org.springframework.dao.DuplicateKeyException; // 이 import가 꼭 필요합니다!
import org.springframework.stereotype.Controller;
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

    // [기존 코드] 회원가입 페이지 이동
    @GetMapping("/member/register")
    public void register() {
    }

    // [수정된 코드] 회원가입 처리 (중복 아이디 예외 처리 추가)
    @PostMapping("/member/register")
    public String register(MemberVO member, RedirectAttributes rttr) {
        log.info("register: " + member);

        // 1. 비밀번호 유효성 검사
        if (!member.getPassword().matches("^(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]).{8,}$")) {
            rttr.addFlashAttribute("error", "비밀번호는 8자리 이상, 특수문자를 포함해야 합니다.");
            return "redirect:/member/register";
        }

        // 2. 회원가입 시도 (중복 아이디 체크)
        try {
            service.register(member);
        } catch (DuplicateKeyException e) {
            // DB에 이미 같은 아이디가 있을 때 여기로 옴
            log.info("아이디 중복 발생: " + member.getUserid());
            rttr.addFlashAttribute("error", "이미 사용 중인 아이디입니다. 다른 아이디를 사용해주세요.");
            return "redirect:/member/register";
        } catch (Exception e) {
            // 그 외 알 수 없는 오류
            log.error("회원가입 에러 발생", e);
            rttr.addFlashAttribute("error", "회원가입 중 문제가 발생했습니다.");
            return "redirect:/member/register";
        }

        rttr.addFlashAttribute("result", "회원가입 성공!");
        return "redirect:/";
    }
    
    // ... 아래 로그인, 로그아웃 메서드는 그대로 두세요 ...
    
    @GetMapping("/member/login")
    public void loginInput(String error, String logout) {
        log.info("login page inputs: " + error + ", " + logout);
    }
}