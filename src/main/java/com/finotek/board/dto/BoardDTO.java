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
	String[] TEMP_IMAGES;	// 게시글 안에 담겨있는 이미지 이름들
}
