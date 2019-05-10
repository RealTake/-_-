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
	SqlSession sqlSession;	// ���̺�Ƽ���� ����ϱ����� ��ü
	private Gson gson = new Gson(); // List������ ��ȯ�� �Խñ۵��� json���� ��ȯ ��Ŵ
	
	
	public String getSearchPostList_S(String content, Authentication authentication) {
		
		try 
		{
			String auth_S = null;																	// ������� ������ ����� ����
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator(); // �α��ε� ������� ���Ѹ�ϵ��� ����ȭ��
			Map<String, String> param = new HashMap<String, String>();
			param.put("ID",authentication.getName());
			param.put("CONTENT", content);
			System.out.println("������̸� : " + authentication.getName());
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("����ڱ��� : " + auth_S);
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getSearchPostList_U", param));// ����id�� �ۼ��ڸ� ���Ѵ�.
				}
				else if(auth_S.equals("ROLE_ADMIN")) {
					System.out.println("����ڱ��� : " + auth_S);
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_A", content));					// ���� �����Ͻ� ������ �ʰ� ��� �Խù��� ã�´�.
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
	
	public void getBoardListTest(Principal pri, Model model) {// �ۼ����� ����Ʈ�� �����ִ� �޼��� �׽�Ʈ������ �ʿ��ѱ��
		IDAO dao = sqlSession.getMapper(IDAO.class);	
		model.addAttribute("name", pri.getName());
		model.addAttribute("list", dao.getPostList_A());
		
	}
	

	public String getBoardList_S(Authentication authentication) {// �ۼ����� ����Ʈ�� �����ִ� �޼���
		
		String auth_S = null;// ������� ������ ����� ����
		
		System.out.println("������̸� : " + authentication.getName());
		try 
		{
			Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// �α��ε� ������� ���Ѹ�ϵ��� ����ȭ��
			
			while(auth.hasNext()) 
			{
				auth_S = auth.next().getAuthority();
		
				
				if(auth_S.equals("ROLE_USER")) {
					System.out.println("����ڱ��� : " + auth_S);
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_U", authentication.getName()));// ����id�� �ۼ��ڸ� ���Ѵ�.
					
				}
					else if(auth_S.equals("ROLE_ADMIN"))	
					return gson.toJson(sqlSession.selectList("com.finotek.board.dao.IDAO.getPostList_A"));					// ���� �����Ͻ� ������ �ʰ� ��� �Խù��� ã�´�.
				
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
