package com.finotek.board.dto;

public class BoardDTO {
	String WDATE;	// 게시글 작성일 변수
	String TITLE;	// 게시글제목 변수
	String CONTENT; // 게시글 내용 변수
	String TYPE;	// 게시글 카테고리 변수
	String BID;		// 게시글 고유번호
	String WRITER;
	public String getWDATE() {
		return WDATE;
	}
	public void setWDATE(String wDATE) {
		WDATE = wDATE;
	}
	public String getTITLE() {
		return TITLE;
	}
	public void setTITLE(String tITLE) {
		TITLE = tITLE;
	}
	public String getCONTENT() {
		return CONTENT;
	}
	public void setCONTENT(String cONTENT) {
		CONTENT = cONTENT;
	}
	public String getTYPE() {
		return TYPE;
	}
	public void setTYPE(String tYPE) {
		TYPE = tYPE;
	}
	public String getBID() {
		return BID;
	}
	public void setBID(String bID) {
		BID = bID;
	}
	public String getWRITER() {
		return WRITER;
	}
	public void setWRITER(String wRITER) {
		WRITER = wRITER;
	}
	
	
	
	
	
}
