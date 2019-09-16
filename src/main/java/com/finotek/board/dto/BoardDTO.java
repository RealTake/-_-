package com.finotek.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class BoardDTO {
	String WDATE;	        // 작성날
	String TITLE;	        // 제목
	String CONTENT;         // 내용
	String TYPE;	        // 카테고리
	int BID;		        // 게시판 고유 번호
	String WRITER;	        // 작성자
	String FILE_LIST;       // 파일리스트 String 형
	String HEADER_IMG;		// 헤더 이미지
    String[] FILE_ARRAY; 	// 파일리스트 List 형
	String AUTHORITY;		// 사용자 권환
	String[] TEMP_IMGS;		// 받을때 게시글 안에 담겨있는 이미지 이름들
	String TEMP_IMGS_LIST;	// 디비에 저장할 때 게시글 안에 담겨있는 이미지 String형
	String[] IMGS;			// 받을때 기존 게시글의 이미지
	String IMGS_LIST;		// 디비에 저장할 때 게시글의 이미지
}
