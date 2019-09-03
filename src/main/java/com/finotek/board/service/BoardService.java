package com.finotek.board.service;

import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.*;

import com.finotek.board.dto.MemberDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.finotek.board.dao.IDAO;
import com.finotek.board.dto.BoardDTO;
import com.google.gson.Gson;

@Service
public class BoardService {
	
	@Autowired
	SqlSession sqlSession;	// 마이베티스를 사용하기위한 객체
	private Gson gson = new Gson(); // List형식의 반환된 게시글들을 json으로 변환 시킴

	// 게시글들을 검색해주는 매소드
	public String getSearchPostList_S(String content, int pageNum, Authentication authentication) {
	    int start = (pageNum - 1) * 10 + 1; // 가져올 글 목록들의 시작 인덱스를 계산
	    int end = pageNum * 10 + 1;// 가져올 글 목록들의 끝 인덱스를 계산

	    String auth_S = null;// 사용자의 권한이 저장될 변수
        String approach = authentication.getName();// 접근 주체의 이름을 가지는 변수;
        Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator(); // 로그인된 사용자의 권한목록들을 직렬화함

        Map<String, String> param = new HashMap<String, String>();
        param.put("ID",authentication.getName());
        param.put("CONTENT", content);
        param.put("start", String.valueOf(start));
        param.put("end", String.valueOf(end));

        try {
            while(auth.hasNext())
            {
                auth_S = auth.next().getAuthority();

                if(auth_S.equals("ROLE_USER")) {
                    System.out.println("사용자권한 : " + auth_S);
                    return "{\"result\":" + gson.toJson(sqlSession.getMapper(IDAO.class).getSearchPostList_U(param)) + "}";						// 유저id와 작성자를 비교한다.
                }
                else if(auth_S.equals("ROLE_ADMIN")) {
                    System.out.println("사용자 권한 : " + auth_S);
                    return "{\"result\":" + gson.toJson(sqlSession.getMapper(IDAO.class).getSearchPostList_A(param)) + "}";					// 어드민 계정일시 비교하지 않고 모든 게시물을 찾는다.
                }

            }
        }
        catch (Exception e) { e.printStackTrace(); }
        finally { printInfo(new Object(){}.getClass().getEnclosingMethod(), approach, auth_S); }// 실행중인 메소드 정보 호출

        return "{\"error\":\"noAuthority}";// 권한없이 접근할경우 오류 메세지 전달
	}

    // 작성글을 보여주는 메서드
	public void getPost_S(int bid, Model model, Authentication authentication) {
	    String auth_S = null;// 사용자의 권한이 저장될 변수
        String approach = authentication.getName();// 접근 주체의 이름을 가지는 변수;

		Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함

        try {
            while(auth.hasNext())
            {
                auth_S = auth.next().getAuthority();

                if(auth_S.equals("ROLE_USER")) {
                    IDAO dao = sqlSession.getMapper(IDAO.class);
                    BoardDTO dto = dao.getPost_U(bid, authentication.getName());
                    dto.setBID(bid);
                    String list = dto.getFILE_LIST();
                    if(list != null) {
                        dto.setFILE_ARRAY(list.substring(1, list.length() - 1).split(", "));
                    }
                    model.addAttribute("dto", dto);
                    model.addAttribute("possibility", true);
                }
                else if(auth_S.equals("ROLE_ADMIN")) {
                    IDAO dao = sqlSession.getMapper(IDAO.class);
                    BoardDTO dto = dao.getPost_A(Integer.valueOf(bid));
                    dto.setBID(bid);
                    String list = dto.getFILE_LIST();
                    if(list != null) {
                        dto.setFILE_ARRAY(list.substring(1, list.length() - 1).split(", "));
                    }
                    model.addAttribute("dto", dto);
                    model.addAttribute("possibility", true);
                }
            }
        }
        catch (Exception e) { e.printStackTrace(); model.addAttribute("possibility", false);}
        finally { printInfo(new Object(){}.getClass().getEnclosingMethod(), approach, auth_S); }// 실행중인 메소드 정보 호출
	}

    // 작성글을 JSON으로 보여주는 메서드
    public BoardDTO getPostA_S(int bid, Authentication authentication) {
        String auth_S = null;// 사용자의 권한이 저장될 변수
        String approach = authentication.getName();// 접근 주체의 이름을 가지는 변수;

        Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함

        try {
            while(auth.hasNext())
            {
                auth_S = auth.next().getAuthority();

                if(auth_S.equals("ROLE_USER")) {
                    IDAO dao = sqlSession.getMapper(IDAO.class);
                    BoardDTO dto = dao.getPost_U(bid, authentication.getName());
                   return dto;
                }
                else if(auth_S.equals("ROLE_ADMIN")) {
                    IDAO dao = sqlSession.getMapper(IDAO.class);
                    BoardDTO dto = dao.getPost_A(bid);
                    return dto;
                }
            }
        }
        catch (Exception e) { e.printStackTrace(); return null;}
        finally { printInfo(new Object(){}.getClass().getEnclosingMethod(), approach, auth_S); }// 실행중인 메소드 정보 호출
        return null;
    }

    // 글을 작성하는 메서드
	public String writePost_S(BoardDTO dto, Authentication authentication) {
	    if(!dto.getCONTENT().isEmpty() && !dto.getTITLE().isEmpty()){   //제목이나 내용이 비어있는 경우 글을 저장 하지 않는다.
            String auth_S = null;// 사용자의 권한이 저장될 변수
            String approach = authentication.getName();// 접근 주체의 이름을 가지는 변수

            Date date = new Date();// 글이 작성된 시점을 기록한다
            SimpleDateFormat sDate = new SimpleDateFormat("yyyy.MM.dd");
            Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함

            dto.setWRITER(authentication.getName());
            dto.setWDATE(sDate.format(date));

            try {
                while (auth.hasNext()) {
                    auth_S = auth.next().getAuthority();

                    if (auth_S.equals("ROLE_USER")) {
                        sqlSession.getMapper(IDAO.class).writePost(dto);
                        return "1";

                    } else if (auth_S.equals("ROLE_ADMIN")) {
                        sqlSession.getMapper(IDAO.class).writePost(dto);
                        return "1";
                    }
                }
            }
            catch (Exception e) { e.printStackTrace(); }
            finally { printInfo(new Object(){}.getClass().getEnclosingMethod(), approach, auth_S); }// 실행중인 메소드 정보 호출
	    }
        return "0"; //삭제 실패시 0 리턴
	}

    // 작성글을 지워주는 메소드
	public String deletePost_S(int bid, Authentication authentication) {
	    String auth_S = null;// 사용자의 권한이 저장될 변수
        String approach = authentication.getName();// 접근 주체의 이름을 가지는 변수;
        Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함

        try {
            while(auth.hasNext())
            {
                auth_S = auth.next().getAuthority();

                if(auth_S.equals("ROLE_USER")) {
                    sqlSession.getMapper(IDAO.class).deletePost_U(bid, authentication.getName());
                    return "1";
                }
                else if(auth_S.equals("ROLE_ADMIN")) {
                    sqlSession.getMapper(IDAO.class).deletePost_A(bid);
                    return "1";
                }

            }
        }
        catch (Exception e) { e.printStackTrace(); }
        finally { printInfo(new Object(){}.getClass().getEnclosingMethod(), approach, auth_S); }// 실행중인 메소드 정보 호출
			
			return "0"; //삭제 실패시 0 리턴
		}

	// 작성한 글을 수정하는 메소드
    public String modifyPost_S(int bid, BoardDTO dto, Authentication authentication) {
        String auth_S = null;// 사용자의 권한이 저장될 변수
        String approach = authentication.getName();// 접근 주체의 이름을 가지는 변수;

        dto.setBID(bid);// 수정할 게시물의 bid를 dto에 담는다
        dto.setWRITER(approach);// 접근 주체의 이름을 dto로 한번에 보내기 위해 WRITER에 저장한다

        Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함

        try {
            while (auth.hasNext()) {
                auth_S = auth.next().getAuthority();

                if (auth_S.equals("ROLE_USER")) {
                    sqlSession.getMapper(IDAO.class).modifyPost_U(dto);
                    return "1";
                } else if (auth_S.equals("ROLE_ADMIN")) {
                    sqlSession.getMapper(IDAO.class).modifyPost_A(dto);
                    return "1";
                }
            }
        }
        catch (Exception e) { e.printStackTrace(); }
        finally { printInfo(new Object(){}.getClass().getEnclosingMethod(), approach, auth_S); }// 실행중인 메소드 정보 호출

        return "0"; //삭제 실패시 0 리턴
    }

    // 게시물의 개수를 가져온다.
    public int getCount_S(String content, Authentication authentication) {
        String auth_S = null; //사용자의 권한이 저장될 변수
        String approach = authentication.getName(); // 접근자의 아이디(이름)
        Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함

	    int board_count = 0; // 게시물 개수
	    int quotient; // 게시물 몫
	    int remainder;// 게시물 나머지

        try {
            while(auth.hasNext())
            {
                auth_S = auth.next().getAuthority();

                if(auth_S.equals("ROLE_USER")) {
                    board_count = sqlSession.getMapper(IDAO.class).getCount_U(content, approach);
                    break;
                }
                else if(auth_S.equals("ROLE_ADMIN")) {
                    board_count = sqlSession.getMapper(IDAO.class).getCount_A(content);
                    break;
                }
            }
            quotient = board_count/10;
            remainder = board_count%10;

            if(remainder > 0)
                return quotient+1;
            else
                return quotient;

        }
        catch (Exception e) { e.printStackTrace(); return 0;}

        finally { printInfo(new Object(){}.getClass().getEnclosingMethod(), approach, auth_S); }// 실행중인 메소드 정보 호출
    }


    // 사용자 정보 가져오기
    public MemberDTO getAccountInfo_S(Authentication authentication){
	    return sqlSession.getMapper(IDAO.class).getAccountInfo(authentication.getName());
    }

    // 서비스 메소드 정보 호출
    public void printInfo(Method nowmethod, String name, String auth)
    {
        System.out.println("정보1: " + nowmethod.getName());
        System.out.println("접근주체 권한: " + auth);
        System.out.println("접근주체 이름 : " + name);
        System.out.println();
    }
}
