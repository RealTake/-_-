package com.finotek.board.dto;

public class BoardDTO {
	String date;	// 게시글 작성일 변수
	String title;	// 게시글제목 변수
	String content; // 게시글 내용 변수
	String type;	// 게시글 카테고리 변수
	String bid;		// 게시글 고유번호
	
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getBid() {
		return bid;
	}
	public void setBid(String bid) {
		this.bid = bid;
	}
	
	
}
