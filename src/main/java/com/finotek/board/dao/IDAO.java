package com.finotek.board.dao;

import java.util.ArrayList;
import java.util.Map;

import com.finotek.board.dto.BoardDTO;

public interface IDAO {
//	public ArrayList<Map<String, String>> getPostList_A();
//	public ArrayList<Map<String, String>> getPostList_U(String id);
	public void writePost(String P_writer, String P_content, String P_title, String P_date);
	public void deletePost(String bid);  //
	public BoardDTO getPost_A(String bid);
	public BoardDTO getPost_U(String bid, String user);
	public ArrayList<BoardDTO> getSearchPostList_A(String content);
	public ArrayList<BoardDTO> getSearchPostList_U(Map<String, String> map);


}