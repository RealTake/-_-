package com.finotek.board.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.finotek.board.dto.FileUploadDTO;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FileController {

	@Autowired
	ServletContext context;

	@ResponseBody
	@PostMapping(value = "/imageUpload.do/{mode}", produces = "application/json; charset=utf8")
	public String imageUpload(@PathVariable(value = "mode") String mode, FileUploadDTO dto, HttpSession session, Authentication authentication) {
		JSONObject data = new JSONObject();// 클라이언트(ckeditor)에게 json 형태 정보전달을 위한 변수
		MultipartFile upload = dto.getUpload();// 업로드된 파일
		String name = authentication.getName();// 업로드하려는 유저의 이름
		String rootPath = session.getServletContext().getRealPath("/");// 프로젝트 경로
		String filename = getDate() + "_" + name + "_" + upload.getOriginalFilename();// 업로드된 파일의 실제 이름
//		String filePath = rootPath + "resources" + File.separator + "ckeditor" + File.separator + "editorImg" + File.separator;// 파일이 저장될 위치
		String filePath = rootPath + "resources" + File.separator + (mode.equals("header") ? "uploadImage" : "tempFile") + File.separator;// 업로드된 이미지가 임시로 저장될 위치

		if (upload != null) {
			System.out.println("이미지 임시 저장 위치: " + filePath + '\n');
			File file = new File(filePath + filename);
			try {
				upload.transferTo(file);
			} catch (IOException e) {
				e.printStackTrace();
				data.put("uploaded", 0);
				data.put("error", "");
			}

			data.put("uploaded", 1);
			data.put("fileName", filename);
			data.put("url", session.getServletContext().getContextPath() + (mode.equals("header") ? "/uploadImage/" : "/temp/") + filename);
		} else {
			data.put("uploaded", 0);
			data.put("error", "");
		}

		return data.toString();
	}

	@ResponseBody
	@PostMapping(value = "/fileUpload.do", produces = "application/json; charset=utf-8")
	public String fileUpload(FileUploadDTO dto, HttpSession session, Authentication authentication) {
		List<MultipartFile> fileList = dto.getFileList();// 클라이언트로 부터 받은 파일리스트
		List<String> fileListDB = new ArrayList<String>();// DB에 저장될 파일들의 이름을 리스트로 관리하기 위한 변수
		String rootPath = session.getServletContext().getRealPath("/");// 프로젝트 경로
		String name = authentication.getName();// 업로드하려는 유저의 이름
		JSONObject jsonData = new JSONObject();// 응답 내용을 담을 객체

		for (MultipartFile mf : fileList) {
			if(!mf.isEmpty()) {
                try {
                    String filename = getDate() + "_" + name + "_" + new String(mf.getOriginalFilename().getBytes("UTF-8"),"UTF-8");// 업로드된 파일의 실제 이름
                    fileListDB.add(filename);// 파일 이름을 리스트에 저장한다.
                    String filePath = rootPath + "resources" + File.separator + "uploadFile" + File.separator;// 파일들이 저장될 위치
                    System.out.println("저장될 파일의 위치: " + filePath + filename + '\n');
                    File file = new File(filePath + filename);// 저장될 위치에 파일을 만든다.
                    mf.transferTo(file);// file의 경로에 업로드된 파일을 쓴다.
				} catch (IOException e) {
					e.printStackTrace();
					System.out.println("업로드 파일 쓰기 실패" + '\n');
					jsonData.put("result", "write_error: " + e.getMessage());
					return jsonData.toString();
				}
			}
			else{
				jsonData.put("result", "null_files");
				return jsonData.toString();
			}
		}

		jsonData.put("fileName",fileListDB.toString());
		System.out.println(jsonData.toString());
		return jsonData.toString();
	}

	@GetMapping(value = "/fileDownload/{Fname:.+}")
	public ModelAndView reDocumentDown(@PathVariable("Fname") String Fname, HttpSession session) {
		String rootPath = session.getServletContext().getRealPath("/");
		String savePath = rootPath + "resources" + File.separator + "uploadFile" + File.separator;
		System.out.println("루트 패쓰: " + savePath);
		Fname = Fname.replaceAll("\\|/", "");
		System.out.println("다운로드될 파일 : " + Fname + '\n');
		//전체 경로를 인자로 넣어 파일 객체를 생성
		File downFile = new File(savePath + Fname);

		return new ModelAndView("downloadView", "downloadFile", downFile);
	}

	@Scheduled(cron = "0 0 0 * * *") // 마지막 7번째 자리는 연도로써 옵션이기 때문에 꼭 적을 필요는 없다
	public void clearTempDirectory(){
		try {
			String path = context.getRealPath("/resources/tempFile/");
			File folder = new File(path);

			if(folder.exists()) {
				File[] folder_list = folder.listFiles(); //파일리스트 얻어오기
				for (File temp : folder_list) {
					System.out.println("삭제될 파일 이름: " + temp.getName());
					temp.delete(); //파일 삭제
					System.out.println("파일이 삭제되었습니다.");
				}
				System.out.println();
			}
		} catch (Exception e) {
			e.getStackTrace();
		}
	}

//	@RequestMapping("/uploadP")
//	public String page(){
//		return "page";
//	}

	public String getDate(){
		Date date = new Date();// 글이 작성된 시점을 기록한다
		SimpleDateFormat sDate = new SimpleDateFormat("yyyy.MM.dd.ss");
		return sDate.format(date);
	}

}
