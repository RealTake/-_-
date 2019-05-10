package com.finotek.board.dao;

import java.util.ArrayList;
import java.util.Map;

import com.finotek.board.dto.BoardDTO;

public interface IDAO {
//	public ArrayList<Map<String, String>> getPostList_A();
//	public ArrayList<Map<String, String>> getPostList_U(String id);
	public void writePost(String P_writer, String P_content, String P_title, String P_date);
	public BoardDTO viewPost(int Pid);// INT형도 자동으로 문자열로 인식하는것 같다.
	public void deletePost(int Pid);  //
	public ArrayList<BoardDTO> getPostList_A();
	public ArrayList<BoardDTO> getPostList_U(String id);
	public ArrayList<BoardDTO> getSearchPostList_A(String content);
	public ArrayList<BoardDTO> getSearchPostList_U(Map<String, String> map);


}