package com.finotek.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.finotek.board.dto.BoardDTO;

@Controller
public class BoardController {
	
	@RequestMapping(value="/write")
	public String write(BoardDTO dto) {
		
		return "";
	}

}
