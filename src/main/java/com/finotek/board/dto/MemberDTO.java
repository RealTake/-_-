package com.finotek.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class MemberDTO {
	String NAME;			// 사용자 이름
	String ID;				// 아이디
	String EMAIL;			// 이메일
	String PASSWORD;		// 비밀번호
	char SEX;				// 성별
	String USER_AUTHORITY;	// 가지고있는 권한
	String JOINDATE;		// 가입날짜
	int ENABLED;			// 계정 활성화 여부 1: 활성화, 0: 비활성화

}
