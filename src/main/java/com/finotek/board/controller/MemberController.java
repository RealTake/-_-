package com.finotek.board.controller;

import com.finotek.board.dto.MemberDTO;
import com.finotek.board.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


@Controller
public class MemberController {

    @Autowired
    public MemberService service; 	// MemberService 객체 바인딩

    //가입 페이지
    @RequestMapping("/joinMember")
    public String joinPage() { return "member/joinMember"; }

    //가입 서비스
    @PostMapping("/join")
    public String joinMember(MemberDTO dto) { service.joinMember_S(dto); return "redirect:/Login"; }

    //중복검사
    @ResponseBody
    @RequestMapping("/checkOverlap/{value}")
    public String checkOverlap(@PathVariable("value") String value){
        return service.checkOverlap_S(value);}

    //회원 탈퇴
    @ResponseBody
    @PostMapping("/withdrawal")
    public String deleteAccount(Authentication authentication){
        return service.deleteAccount_S(authentication);
    }

    //로그인 페이지
    @RequestMapping("/Login")
    public String loginPage() {
        return "member/loginForm";
    }
    
    // 마이 페이지로 이동
    @RequestMapping("/myAccount")
    public String myAccount(Authentication authentication, Model model) {
    	model.addAttribute("AccountInfo", service.getAccountInfo_S(authentication.getName()));
    	return "member/myPage";
    }
}
