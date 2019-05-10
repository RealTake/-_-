package com.finotek.board.service;

import java.security.Principal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.finotek.board.dao.IDAO;
import com.google.gson.Gson;

@Service
public class BoardService {
	
	@Autowired
	SqlSession sqlSession;	// 마이베티스를 사용하기위한 객체
	private Gson gson = new Gson(); // List형식의 반환된 게시글들을 json으로 변환 시킴
	
	
	public String getSearchPostList_S(String content, Authentication authentication) {
		
		try 
		{
			String auth_S = null;																	// 사용자의 권한이 저장될 변수
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator(); // 로그인된 사용자의 권한목록들을 직렬화함
			Map<String, String> param = new HashMap<String, String>();
			param.put("ID",authentication.getName());
			param.put("CONTENT", content);
			System.out.println("사용자이름 : " + authentication.getName());
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("사용자권한 : " + auth_S);
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getSearchPostList_U", param));// 유저id와 작성자를 비교한다.
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("사용자권한 : " + auth_S);
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_A", content));					// 어드민 계정일시 비교하지 않고 모든 게시물을 찾는다.
				}
				
			}
			
		} 
		
		catch (Exception e) 
		{
			e.printStackTrace();
			return "{\"error\":\"noAuthority}";
		}
		
		
		
		return "null";
		
	}
	
	public void getBoardListTest(Principal pri, Model model) {// 작성글의 리스트를 보여주는 메서도 테스트과정에 필요한기능
		IDAO dao = sqlSession.getMapper(IDAO.class);	
		model.addAttribute("name", pri.getName());
		model.addAttribute("list", dao.getPostList_A());
		
	}
	

	public String getBoardList_S(Authentication authentication) {// 작성글의 리스트를 보여주는 메서드
		
		String auth_S = null;// 사용자의 권한이 저장될 변수
		
		System.out.println("사용자이름 : " + authentication.getName());
		try 
		{
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
		
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("사용자권한 : " + auth_S);
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_U", authentication.getName()));// 유저id와 작성자를 비교한다.
					
				}
					else if(auth_S.equals("ROLE_ADMIN"))	
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_A"));					// 어드민 계정일시 비교하지 않고 모든 게시물을 찾는다.
				
			}
			
		} 
		
		catch (Exception e) 
		{
			e.printStackTrace();
			return "{\"error\":\"noAuthority}";
		}
		
		
		
		return "null";
		
	}
}
