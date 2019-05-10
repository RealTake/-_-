package com.finotek.board.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.finotek.board.service.BoardService;

@Controller
public class BoardController {
	
	@Autowired
	BoardService service; 	// ������ ������ ��ü
	
	
	@RequestMapping(value="/board.test")
	public String write(Principal pri, Model model) {// �ۼ����� ����Ʈ�� �����ִ� �޼��� �׽�Ʈ������ �ʿ��ѱ��
		
		service.getBoardListTest(pri, model);
		
		return "board";
	}
	
	@ResponseBody
	@RequestMapping(value="/board.json")
	public String boardList(Authentication authentication) {// �ۼ����� ����Ʈ�� ������
		
		return service.getBoardList_S(authentication);
		
	}
	
	@ResponseBody
	@RequestMapping(value="/searchPost.json")
	public String searchPost(@RequestParam String content, Authentication authenticatio) {// �ۼ����� ã����
		
		return service.getSearchPostList_S(content, authenticatio);
	}
	
//	@RequestMapping(value="/board")
//	public String write(Principal pri, Model model) {// �ۼ����� ����Ʈ�� �����ִ� �޼��� �׽�Ʈ������ �ʿ��ѱ��
//		IDAO dao = sqlSession.getMapper(IDAO.class);	
//		model.addAttribute("name", pri.getName());
//		model.addAttribute("list", dao.getPostList_A());
//		
//		return "board";
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
