package com.finotek.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class MemberController {
	
	@RequestMapping(value="/Login")
	public String login() {
		return "forms/loginForm";
	}
	
	@RequestMapping(value="/loginSucces")
	public String loginSuccesPage() {
		
		return "member/loginSucces";
	}
}
