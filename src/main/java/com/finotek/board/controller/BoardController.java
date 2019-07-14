package com.finotek.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.finotek.board.dto.BoardDTO;
import com.finotek.board.service.BoardService;

@Controller
public class BoardController {

	@Autowired
	public BoardService service; 	// BoardService 객체 바인딩

    // 매인페이지를 불러오는 메소드
    @RequestMapping(value="/board")
    public String boardPage() { return "board/boardList"; }

	// 매인페이지를 불러오는 메소드
	@RequestMapping(value="/board2")
	public String boardPage2(Model model, Authentication authentication) {
    	model.addAttribute("AccountInfo", service.getAccountInfo_S(authentication));
    	return "board/boardList2";
    }

    // 위와 같은 기능을 하지만 루트 주소로 메인 페이지를 불러온다.
    @RequestMapping(value="/")
    public String mainPage() { return "board/boardList"; }

	//  포스팅된 글을 불러올 메소드
	@GetMapping(value="/viewPost/{bid}")
	public String boardList(@PathVariable(value = "bid") String bid, Authentication authentication, Model model)
	{ service.getPost_S(bid, model, authentication);	return "board/postView"; }

	//  포스팅된 글을 불러올 메소드
	@GetMapping(value="/viewPost2/{bid}")
	public String boardList2(@PathVariable(value = "bid") String bid, Authentication authentication, Model model)
	{
		model.addAttribute("AccountInfo", service.getAccountInfo_S(authentication));
		service.getPost_S(bid, model, authentication);
		return "board/postView2";
	}

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
	@GetMapping(value="/searchPost.json/{pageNum}", produces = "application/json; charset=utf8")
	public String searchPost(@RequestParam String content, @PathVariable(value = "pageNum") int pageNum, Authentication authenticatio)
	{ return service.getSearchPostList_S(content, pageNum, authenticatio); }

	// 글 수정 페이지를 반환
	@GetMapping(value="/modifyPage/{bid}")
	public String modifyPage(@ModelAttribute @PathVariable(value = "bid") String bid, Model model, Authentication authentication)
	{ service.getPost_S(bid, model, authentication);    return "board/modifyPage"; }

	// 글 수정 메소드
	@ResponseBody
	@PostMapping(value="/modifyPost/{bid}")
	public String modifyPost(@PathVariable(value = "bid") String bid, BoardDTO dto, Authentication authentication)
	{
	    return service.modifyPost_S(bid, dto, authentication);
    }

}
