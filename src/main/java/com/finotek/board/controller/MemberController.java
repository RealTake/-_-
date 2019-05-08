package com.finotek.board.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class MemberController {
	
	
	@RequestMapping(value="/Login")
	public String login(Model mod, Principal pri) {
		mod.addAttribute("name", pri.getName());
		return "loginSucces";
	}
	@RequestMapping(value="/loginForm.html")
	public String loginForm() {
		return "loginForm";
	}
}
