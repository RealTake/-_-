package com.finotek.board.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.finotek.board.dto.BoardDTO;

@Controller
public class BoardController {
	
	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	
	@RequestMapping(value="/write")
	public String write(BoardDTO dto) {
		
		System.out.println(authentication.getName());
		
		return "";
	}

}
