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
	SqlSession sqlSession;	// ���̺�Ƽ���� ����ϱ����� ��ü
	private Gson gson = new Gson(); // List������ ��ȯ�� �Խñ۵��� json���� ��ȯ ��Ŵ
	
	
	public String getSearchPostList_S(String content, Authentication authentication) {
		try 
		{
			String auth_S = null;// ������� ������ ����� ����
			Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator(); // �α��ε� ������� ���Ѹ�ϵ��� ����ȭ��
			Map<String, String> param = new HashMap<String, String>();
			
			param.put("ID",authentication.getName());
			param.put("CONTENT", content);
			
			System.out.println("����: " + nowmethod.getName());
			System.out.println("������̸� : " + authentication.getName());
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("����ڱ��� : " + auth_S);
					return "{\"result\":" + gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getSearchPostList_U", param)) + "}";						// ����id�� �ۼ��ڸ� ���Ѵ�.
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("����ڱ��� : " + auth_S);
					return "{\"result\":" + gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getSearchPostList_A", content)) + "}";					// ���� �����Ͻ� ������ �ʰ� ��� �Խù��� ã�´�.
				}
				
			}
			
			System.out.println();	
		} 
		
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		
		
		
		return "{\"error\":\"noAuthority}";// ���Ѿ��� �����Ұ�� ���� �޼��� ����
		
	}
	
//	public void getBoardListTest(Principal pri, Model model) {// �ۼ����� ����Ʈ�� �����ִ� �޼��� �׽�Ʈ������ �ʿ��ѱ��
//		IDAO dao = sqlSession.getMapper(IDAO.class);	
//		model.addAttribute("name", pri.getName());
//		model.addAttribute("list", dao.getPostList_A());
//		
//	}
	

	public void getPost_S(String bid, Model model, Authentication authentication) {// �ۼ����� ����Ʈ�� �����ִ� �޼���
		
		String auth_S = null;// ������� ������ ����� ����
		Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
		
		System.out.println("����: " + nowmethod.getName());
		System.out.println("������̸� : " + authentication.getName());
		try 
		{
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// �α��ε� ������� ���Ѹ�ϵ��� ����ȭ��
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
		
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("����ڱ��� : " + auth_S);
					IDAO dao = sqlSession.getMapper(IDAO.class);
					BoardDTO dto = dao.getPost_U(bid, authentication.getName());
					model.addAttribute("dto", dto);
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("����ڱ��� : " + auth_S);
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
	
	public String writePost_S(String title, String content, Authentication authentication) {// �ۼ����� ����Ʈ�� �����ִ� �޼���
		
		String auth_S = null;// ������� ������ ����� ����
		Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
		Date date = new Date();
		SimpleDateFormat sDate = new SimpleDateFormat("yyyy-MM-dd");
		
		System.out.println("����: " + nowmethod.getName());
		System.out.println("������̸� : " + authentication.getName());
		
		try 
		{
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// �α��ε� ������� ���Ѹ�ϵ��� ����ȭ��
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
		
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("����ڱ��� : " + auth_S);
					sqlSession.getMapper(IDAO.class).writePost(authentication.getName(), content, title, sDate.format(date));
					return "1";
					
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("����ڱ��� : " + auth_S);
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
		
		return "0"; //���� ���н� 0 ����
	}
	
	public String deletePost_S(String bid, Authentication authentication) {// �ۼ����� ����Ʈ�� �����ִ� �޼���
			
			String auth_S = null;// ������� ������ ����� ����
			Method nowmethod = new Object(){}.getClass().getEnclosingMethod();
			
			System.out.println("����: " + nowmethod.getName());
			System.out.println("������̸� : " + authentication.getName());
			
			try 
			{
				Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// �α��ε� ������� ���Ѹ�ϵ��� ����ȭ��
				
				while(auth.hasNext()) 
				{
					auth_S = auth.next().getAuthority();
			
					
					if(auth_S.equals("ROLE_USER")) {
						System.out.println("����ڱ��� : " + auth_S);
						sqlSession.getMapper(IDAO.class).deletePost_U(bid, authentication.getName());
						return "1";
						
					}
					else if(auth_S.equals("ROLE_ADMIN")) {
						System.out.println("����ڱ��� : " + auth_S);
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
			
			return "0"; //���� ���н� 0 ����
		}
}
