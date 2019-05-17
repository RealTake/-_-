package com.finotek.board.service;

import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.finotek.board.dto.BoardDTO;
import com.google.gson.Gson;

@Service
public class BoardService {
	
	@Autowired
	SqlSession sqlSession;	// 마이베티스를 사용하기위한 객체
	private Gson gson = new Gson(); // List형식의 반환된 게시글들을 json으로 변환 시킴
	
	
	public String getSearchPostList_S(String content, Authentication authentication) {
		try 
		{
			String auth_S = null;// 사용자의 권한이 저장될 변수
			Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator(); // 로그인된 사용자의 권한목록들을 직렬화함
			Map<String, String> param = new HashMap<String, String>();
			
			param.put("ID",authentication.getName());
			param.put("CONTENT", content);
			
			System.out.println("정보: " + nowmethod.getName());
			System.out.println("사용자이름 : " + authentication.getName());
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("사용자권한 : " + auth_S);
					return "{\"result\":" + gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getSearchPostList_U", param)) + "}";						// 유저id와 작성자를 비교한다.
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("사용자권한 : " + auth_S);
					return "{\"result\":" + gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getSearchPostList_A", content)) + "}";					// 어드민 계정일시 비교하지 않고 모든 게시물을 찾는다.
				}
				
			}
			
			System.out.println();	
		} 
		
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		
		
		
		return "{\"error\":\"noAuthority}";// 권한없이 접근할경우 오류 메세지 전달
		
	}
	
//	public void getBoardListTest(Principal pri, Model model) {// 작성글의 리스트를 보여주는 메서도 테스트과정에 필요한기능
//		IDAO dao = sqlSession.getMapper(IDAO.class);	
//		model.addAttribute("name", pri.getName());
//		model.addAttribute("list", dao.getPostList_A());
//		
//	}
	

	public void getPost_S(String bid, Model model, Authentication authentication) {// 작성글의 리스트를 보여주는 메서드
		
		String auth_S = null;// 사용자의 권한이 저장될 변수
		Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
		
		System.out.println("정보: " + nowmethod.getName());
		System.out.println("사용자이름 : " + authentication.getName());
		try 
		{
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
		
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("사용자권한 : " + auth_S);
					IDAO dao = sqlSession.getMapper(IDAO.class);
					BoardDTO dto = dao.getPost_U(bid, authentication.getName());
					model.addAttribute("dto", dto);
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("사용자권한 : " + auth_S);
					IDAO dao = sqlSession.getMapper(IDAO.class);
					BoardDTO dto = dao.getPost_A(bid);
					model.addAttribute("dto", dto);	
				}
			
			}
			
			System.out.println();
		}
		
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		
	}
	
	public String writePost_S(String title, String content, Authentication authentication) {// 작성글의 리스트를 보여주는 메서드
		
		String auth_S = null;// 사용자의 권한이 저장될 변수
		Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
		Date date = new Date();
		SimpleDateFormat sDate = new SimpleDateFormat("yyyy-MM-dd");
		
		System.out.println("정보: " + nowmethod.getName());
		System.out.println("사용자이름 : " + authentication.getName());
		
		try 
		{
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
		
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("사용자권한 : " + auth_S);
					sqlSession.getMapper(IDAO.class).writePost(authentication.getName(), content, title, sDate.format(date));
					return "1";
					
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("사용자권한 : " + auth_S);
					sqlSession.getMapper(IDAO.class).writePost(authentication.getName(), content, title, sDate.format(date));
					return "1";
	
				}
			
			}
			
			System.out.println();
		}
		
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		
		return "0"; //삭제 실패시 0 리턴
	}
	
	public String deletePost_S(String bid, Authentication authentication) {// 작성글의 리스트를 보여주는 메서드
			
			String auth_S = null;// 사용자의 권한이 저장될 변수
			Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
			
			System.out.println("정보: " + nowmethod.getName());
			System.out.println("사용자이름 : " + authentication.getName());
			
			try 
			{
				Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함
				
				while(auth.hasNext()) 
				{
					auth_S = auth.next().getAuthority();
			
					
					if(auth_S.equals("ROLE_USER")) {
						System.out.println("사용자권한 : " + auth_S);
						sqlSession.getMapper(IDAO.class).deletePost_U(bid, authentication.getName());
						return "1";
						
					}
					else if(auth_S.equals("ROLE_ADMIN")) {
						System.out.println("사용자권한 : " + auth_S);
						sqlSession.getMapper(IDAO.class).deletePost_A(bid);
						return "1";
		
					}
				
				}
				
				System.out.println();
			}
			
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			
			return "0"; //삭제 실패시 0 리턴
		}
}
