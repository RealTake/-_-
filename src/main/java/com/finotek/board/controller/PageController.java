package com.finotek.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PageController {
	
	@RequestMapping(value="/loginSucces")
	public String loginSuccesPage() {
		
		return "loginSucces";
	}

	@RequestMapping(value="/board")
	public String boardPage() {
		
		return "board";
	}

}
