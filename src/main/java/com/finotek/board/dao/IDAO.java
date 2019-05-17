package com.finotek.board.dao;

import java.util.ArrayList;
import java.util.Map;

import com.finotek.board.dto.BoardDTO;

public interface IDAO {
//	public ArrayList<Map<String, String>> getPostList_A();
//	public ArrayList<Map<String, String>> getPostList_U(String id);
	public void writePost(String P_writer, String P_content, String P_title, String P_date);
	public void deletePost_A(String bid);													// 관리자, 작성자와 상관없이 게시글 삭제 가능
	public void deletePost_U(String bid, String id);										// 일반유저용, 일반유저는 작성자와 접근주체가 맞아야함
	public BoardDTO getPost_A(String bid);
	public BoardDTO getPost_U(String bid, String id);
	public ArrayList<BoardDTO> getSearchPostList_A(String content);
	public ArrayList<BoardDTO> getSearchPostList_U(Map<String, String> map);


}