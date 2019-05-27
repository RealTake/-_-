package com.finotek.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.finotek.board.dto.BoardDTO;
import com.finotek.board.service.BoardService;

@Controller
public class BoardController {

	@Autowired
	public BoardService service; 	// BoardService 객체 바인딩
	
	//  포스팅된 글을 불러올 메소드
	@GetMapping(value="/viewPost/{bid}")
	public String boardList(@PathVariable(value = "bid") String bid, Authentication authentication, Model model)
	{ service.getPost_S(bid, model, authentication);	return "board/postView"; }
	
	// 작성된 글을 저장하는 메소드
	@ResponseBody
	@RequestMapping(value="/writePost", method = RequestMethod.POST)
	public String writePost(BoardDTO dto, Authentication authentication)
	{ return service.writePost_S(dto, authentication); }
	
	// 작성글을 삭제하는 메소드
	@ResponseBody
	@GetMapping(value="/deletePost/{bid}")
	public String deletePost(@PathVariable(value = "bid") String bid, Authentication authentication)
	{ return service.deletePost_S(bid, authentication); }
	
	// 작성글들을 찾아주는 메소드
	@ResponseBody
	@RequestMapping(value="/searchPost.json", produces = "application/json; charset=utf8")
	public String searchPost(@RequestParam String content, Authentication authenticatio)
	{ return service.getSearchPostList_S(content, authenticatio); }

	// 매인페이지를 불러오는 메소드
	@RequestMapping(value="/board")
	public String boardPage() { return "board/boardList"; }
	
	// 위와 같은 기능을 하지만 루트 주소로 메인 페이지를 불러온다.
	@RequestMapping(value="/")
	public String mainPage() { return "board/boardList"; }
	
	@GetMapping(value="/modifyPage/{bid}")
	public String modifyPage(@ModelAttribute @PathVariable(value = "bid") String bid, Authentication authentication)
	{ return "board/modifyPage"; }
	
	@GetMapping(value="/modifyPost/{bid}")
	public String modifyPost(@PathVariable(value = "bid") String bid, Authentication authentication)
	{ return "redirect:board/viewPost/" + bid; }
}
