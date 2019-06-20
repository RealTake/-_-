package com.finotek.board.dao;

import java.util.ArrayList;
import java.util.Map;

import com.finotek.board.dto.BoardDTO;
import com.finotek.board.dto.MemberDTO;

public interface IDAO {
	public String checkOverlap(String value);
	public void joinMember(MemberDTO dto);
	public void writePost(BoardDTO dto);
	public void modifyPost_A(BoardDTO dto);
	public void modifyPost_U(BoardDTO dto);
	public void deletePost_A(int bid);
	public void deletePost_U(int bid, String id);
	public BoardDTO getPost_A(int bid);
	public BoardDTO getPost_U(int bid, String id);
	public ArrayList<BoardDTO> getSearchPostList_A(Map<String, String> map);
	public ArrayList<BoardDTO> getSearchPostList_U(Map<String, String> map);
}