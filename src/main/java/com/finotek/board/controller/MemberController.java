package com.finotek.board.controller;

import com.finotek.board.dto.MemberDTO;
import com.finotek.board.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;


@Controller
public class MemberController {

	@Autowired
	public MemberService service; 	// MemberService 객체 바인딩

    @RequestMapping("/joinMember")
    public String joinPage() { return "member/joinMember"; }

    @RequestMapping(value = "/join", method = RequestMethod.POST)
	public String joinMember(MemberDTO dto) { service.joinMember_S(dto); return "redirect:/Login"; }

	@ResponseBody
	@GetMapping("/checkOverlap/{value}")
    public String checkOverlap(@PathVariable("value") String value){
    	return service.checkOverlap_S(value);}


	@RequestMapping("/Login")
	public String loginPage() {
		return "member/loginForm";
	}

	@RequestMapping("/loginSucces")
	public String loginSuccesPage() {
		
		return "member/loginSucces";
	}
}
