package com.finotek.board.service;

import com.finotek.board.dao.IDAO;
import com.finotek.board.dto.MemberDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;

@Service
public class MemberService {

    @Autowired
    SqlSession sqlSession;	// 마이베티스를 사용하기위한 객체

    public String joinMember_S(MemberDTO dto){
        String auth_S = null;   //권한이 임시로 저장될 변수
        String approach = "가입";// 접근 주체의 이름을 가지는 변수;

        Date date = new Date();// 가입한 시점을 기록한다
        SimpleDateFormat sDate = new SimpleDateFormat("yyyy.MM.dd");

        int NAME_L = dto.getNAME().length();
        int ID_L = dto.getID().length();
        int PASSWORD_L = dto.getPASSWORD().length();

        if((NAME_L < 1 || NAME_L > 10) || (ID_L < 5 || ID_L > 16) || (PASSWORD_L < 8 || PASSWORD_L > 16))
            return "0";

        dto.setJOINDATE(sDate.format(date)); // 가입날짜 등록
        dto.setENABLED(1); //활성화 여부는 기본값으로 활성화 값을 준다.
        dto.setUSER_AUTHORITY("ROLE_USER");
        dto.setSEX('n');

        try {
            sqlSession.getMapper(IDAO.class).joinMember(dto);
            return "1";
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    public String checkOverlap_S(String value){
        String result = sqlSession.getMapper(IDAO.class).checkOverlap(value);

        if(result == null || result.isEmpty())
            return "1";
        else
            return  "0";
    }
}
