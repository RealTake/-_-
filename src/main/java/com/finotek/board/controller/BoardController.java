package com.finotek.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.finotek.board.service.BoardService;

@Controller
public class BoardController {
	
	@Autowired
	BoardService service; 	// ������ ������ ��ü
	
	
//	@RequestMapping(value="/board.test")
//	public String write(Principal pri, Model model) {// �ۼ����� ����Ʈ�� �����ִ� �޼��� �׽�Ʈ������ �ʿ��ѱ��
//		service.getBoardListTest(pri, model);
//		return "board";
//	}
	
	// �ۼ����� ������ �����ش�
	@GetMapping(value="/viewPost/{bid}")
	public String boardList(@PathVariable(value = "bid") String bid, Authentication authentication, Model model) {
		service.getPost_S(bid, model, authentication);
		
		return "board/view";
	}
	
	// ���� �ۼ��Ѵ�
	@ResponseBody
	@RequestMapping(value="/writePost", method = RequestMethod.POST)
	public String writePost(@RequestParam(value="TITLE") String TITLE, @RequestParam(value="CONTENT") String CONTENT, Authentication authentication) {
		
		return service.writePost_S(TITLE, CONTENT, authentication);
	}
	
	// �ۼ����� �����Ѵ�
	@ResponseBody
	@GetMapping(value="/deletePost/{bid}")
	public String deletePost(@PathVariable(value = "bid") String bid, Authentication authentication) {
		return service.deletePost_S(bid, authentication);
	}
	
	// �ۼ����� �˻��ؼ� ã���ش�
	@ResponseBody
	@RequestMapping(value="/searchPost.json", produces = "application/json; charset=utf8")
	public String searchPost(@RequestParam String content, Authentication authenticatio) {
		return service.getSearchPostList_S(content, authenticatio);
	}
	
	
	
	// ����ȭ������ �ۼ����� ����� ������ ȭ��
	@RequestMapping(value="/board")
	public String boardPage() {
		
		return "board/boardList";
	}
	
	
	
	
	
	
//	@RequestMapping(value="/board")
//	public String write(Principal pri, Model model) {// �ۼ����� ����Ʈ�� �����ִ� �޼��� �׽�Ʈ������ �ʿ��ѱ��
//		IDAO dao = sqlSession.getMapper(IDAO.class);	
//		model.addAttribute("name", pri.getName());
//		model.addAttribute("list", dao.getPostList_A());
//		
//		return "board/board";
//	}
//	
//	@ResponseBody
//	@RequestMapping(value="/boardAjax")
//	public String boardList(Authentication authentication, Model model) {// �ۼ����� ����Ʈ�� �����ִ� �޼���
//		
//		String auth_S = null;
//		try {
//			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();
//			
//			while(auth.hasNext()) 
//			{
//				auth_S = auth.next().getAuthority();
//				
//				System.out.println("������̸� : " + authentication.getName());
//				System.out.println("����ڱ��� : " + authentication.getName());
//				
//				if(auth_S.equals("ROLE_USER"))
//					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_U", authentication.getName()));
//				else if(auth_S.equals("ROLE_ADMIN"))
//					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_A"));
//			}
//			
//		} catch (Exception e) {
//			return "{\"error\":\"noAuthority}";
//		}
//		
//		return "null";
//		
//	}
	

}
