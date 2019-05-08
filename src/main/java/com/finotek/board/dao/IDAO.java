package com.finotek.board.dao;

import java.util.ArrayList;

import com.finotek.board.dto.BoardDTO;

public interface IDAO {
	public ArrayList<BoardDTO> getPostList_A();
	public ArrayList<BoardDTO> getPostList_U(String id);
	public void writePost(String P_writer, String P_content, String P_title, String P_date);
	public BoardDTO viewPost(int Pid);
	public void deletePost(int Pid);

}
	