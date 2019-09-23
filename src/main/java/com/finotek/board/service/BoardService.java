package com.finotek.board.service;

import java.io.File;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.ListUtils;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.finotek.board.dao.IDAO;
import com.finotek.board.dto.BoardDTO;
import com.finotek.board.dto.MemberDTO;
import com.google.gson.Gson;

@Service
public class BoardService {
	
	@Autowired
	SqlSession sqlSession;	// 마이베티스를 사용하기위한 객체
    @Autowired
    ServletContext context;


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
                    return "{\"result\":" + gson.toJson(sqlSession.getMapper(IDAO.class).getSearchPostList_A(param)) + "}";						// 유저id와 작성자를 비교한다.
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
                    BoardDTO dto = dao.getPost_A(bid);
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
                    BoardDTO dto = dao.getPost_A(bid);
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

            
            if(dto.getTEMP_IMGS() != null)
            	moveFile(dto.getTEMP_IMGS());

            Date date = new Date();// 글이 작성된 시점을 기록한다
            SimpleDateFormat sDate = new SimpleDateFormat("yyyy.MM.dd");
            Iterator<? extends GrantedAuthority> auth = authentication.getAuthorities().iterator();// 로그인된 사용자의 권한목록들을 직렬화함
            
            String temp = Arrays.toString(dto.getTEMP_IMGS());
            dto.setIMGS_LIST(temp.substring(1, temp.length() - 1));
            dto.setWRITER(authentication.getName());
            dto.setWDATE(sDate.format(date));
            String content = dto.getCONTENT();
            int cnt = 0;
            System.out.println(content);
            while((content.contains("</script>") || content.contains("<script>")) && cnt < 8) {
            	content = content.replaceAll("<script>", "");
            	content = content.replaceAll("</script>", "");
            	System.out.println("실행");
            	cnt++;
            }
            
            dto.setCONTENT(content);
            
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

        deleteFiles(bid);
        deleteHeader(bid);
        deleteImgs(bid);
        
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
        String[] temp = dto.getTEMP_IMGS();
        String[] original = dto.getIMGS();
        
        BoardDTO oldDto = sqlSession.getMapper(IDAO.class).getPost_A(bid);
        String oldFile = oldDto.getFILE_LIST();// 원래 저장되어 있던 파일 목록
        String oldHeader = oldDto.getHEADER_IMG();// 원래 저장되어 있던 헤더 이미지
        String oldImgs = oldDto.getIMGS_LIST();
        
//        System.out.println("is null?? : " + original == null);
//        System.out.println("size : " + original.length);
//        System.out.println("data[0] : " + original[0]);
        
        if(oldImgs != null)// 불필요한 이미지 파일들을 삭제한다.
        	deleteImgs(oldImgs.split(","), original);
        
        if(oldFile != null && !oldFile.equals(dto.getFILE_LIST()))// 업로드한 파일이 기존 내용과 다르면 기존 파일 삭제
        	deleteFiles(bid);
        
        if(oldHeader != null && !oldHeader.equals(dto.getHEADER_IMG()))// 업로드한 헤더 이미지가 기존 내용과 다르면 기존 헤더이미지 삭제
        	deleteHeader(bid);
        
        if(temp.length > 0)
        	moveFile(dto.getTEMP_IMGS());
        
        if(temp.length <= 0 && original.length > 0) {
        	String org = Arrays.toString(original);
        	dto.setIMGS_LIST(org.substring(1, org.length() - 1));
        	System.out.println("추가된것 없이 original있음");
        }
        else if(temp.length > 0 && original.length <= 0) {
        	String org = Arrays.toString(temp);
        	System.out.println("삭제된것 없이 temp 새로 추가된것이 있다.");
        	dto.setIMGS_LIST(org.substring(1, org.length() - 1));
        }
        else if(temp.length > 0 && original.length > 0){
        	System.out.println("모두 변화됨");
        	String[] imgs = new String[temp.length + original.length];
        	System.arraycopy(temp, 0, imgs, 0, temp.length);
        	System.arraycopy(original, 0, imgs, temp.length, original.length);
        	dto.setIMGS_LIST(Arrays.toString(imgs));
        }
        
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
                    board_count = sqlSession.getMapper(IDAO.class).getCount_A(content);
//                    board_count = sqlSession.getMapper(IDAO.class).getCount_U(content, approach);
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



    public void moveFile(String[] tempImgs){
        String rootPath = context.getRealPath("/resources/");
        if(tempImgs.length > 0) {
            //임시폴더에 저장되어있던 이미지 파일들을 옮긴다
            for (String name : tempImgs) {
                String beforeFilePath = rootPath + "tempFile" + File.separator; //옮길 대상 경로
                String afterFilePath = rootPath + "uploadImage" + File.separator;//옮겨질 경로

                beforeFilePath += name;
                afterFilePath += name;

                System.out.println("beforeFilePath: " + beforeFilePath);
                System.out.println("afterFilePath: " + afterFilePath);

                File oldFile = new File(beforeFilePath.toString());

                if (oldFile.renameTo(new File(afterFilePath.toString())))
                    System.out.println("임시파일 이동성공");
                else
                    System.out.println("임시파일 이동 실패");
            }

            System.out.println();
        }
    }

    public boolean deleteFiles(int bid) {
    	boolean result = true;
        try {
        	String rootPath = context.getRealPath("/resources/uploadFile/");
            String tempList = sqlSession.getMapper(IDAO.class).getPost_A(bid).getFILE_LIST();
            if(tempList == null || tempList.equals("null"))
            	return false;
            String temp = tempList.substring(1, tempList.length() - 1);
            String[] tempArray = temp.split(", ");
            String[] fileList = null;
            
            if(tempArray == null) {
    	        fileList = new String[1];
    	        fileList[0] = temp;
            }
            else
            	fileList = tempArray;
        	
            for (String fileName : fileList) {
            	File deleteFile = new File(rootPath + fileName);
                if (!deleteFile.delete()) {
                	result = false;
                	System.out.println(fileName + ":안지워짐");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        return result;
    }

    public boolean deleteHeader(int bid) {
        try {
        	String rootPath = context.getRealPath("/resources/uploadImage/");
            String temp = sqlSession.getMapper(IDAO.class).getPost_A(bid).getHEADER_IMG();
            if(temp == null || temp.equals("null"))
            	return false;
            File deleteFile = new File(rootPath + temp);
            
            if (deleteFile.delete())
                return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        return false;// 삭제가 되지 않으면 false 반환
    }
    
    public boolean deleteImgs(int bid) {
    	boolean result = true;
        try {
        	String rootPath = context.getRealPath("/resources/uploadImage/");
            String tempList = sqlSession.getMapper(IDAO.class).getPost_A(bid).getIMGS_LIST();
            if(tempList == null || tempList.equals("null"))
            	return false;
            String[] tempArray = tempList.split(", ");
            String[] fileList = null;
            File deleteFile = null;
            
            if(tempArray == null) {
    	        fileList = new String[1];
    	        fileList[0] = tempList;
            }
            else
            	fileList = tempArray;
        	
            for (String fileName : fileList) {
                deleteFile = new File(rootPath + fileName);
                if (!deleteFile.delete()) ;
                result = false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        return result;
    }
    
    public boolean deleteImgs(String[] unchaneIMGS, String[] chaneIMGS) {
    	String rootPath = context.getRealPath("/resources/uploadImage/");
    	List temp = ListUtils.subtract(Arrays.asList(unchaneIMGS), Arrays.asList(chaneIMGS));
    	Object[] deletFiles = temp.toArray();
    	System.out.println("삭제할 목록: " + Arrays.toString(deletFiles));
    	File deleteFile = null;
    	boolean result = true;

    	for(Object fileName : deletFiles) {
    		deleteFile = new File(rootPath + (String)fileName);
            if (!deleteFile.delete()) {
            	System.out.println(fileName + " 삭제 실패");
            	result = false;
            }
    	}
    	
    	return result;
    }
}
