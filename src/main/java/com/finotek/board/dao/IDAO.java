package com.finotek.board.dao;

import java.util.ArrayList;
import java.util.Map;

import com.finotek.board.dto.BoardDTO;
import com.finotek.board.dto.MemberDTO;

public interface IDAO {
	public String checkOverlap(String value);
	public MemberDTO getAccountInfo(String value);
	public void deleteAccount(String value);

	public void joinMember(MemberDTO dto);
	public void writePost(BoardDTO dto);
	public int getCount_A(String content, String category);
	public int getCount_U(String content, String category, String approach);
	public void modifyPost_A(BoardDTO dto);
	public void modifyPost_U(BoardDTO dto);
	public void deletePost_A(int bid, String category);
	public void deletePost_U(int bid,  String category, String id);
	public BoardDTO getPost_A(int bid, String category);
	public BoardDTO getPost_U(int bid, String category, String id);
	public ArrayList<BoardDTO> getSearchPostList_A(Map<String, String> map);
	public ArrayList<BoardDTO> getSearchPostList_U(Map<String, String> map);
}