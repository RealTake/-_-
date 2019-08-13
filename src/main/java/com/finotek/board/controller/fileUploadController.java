package com.finotek.board.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.finotek.board.dto.FileUploadDTO;

@Controller
public class fileUploadController {

	@ResponseBody
	@PostMapping(value = "/imageUpload.do", produces = "application/json; charset=utf8")
	public String imageUpload(FileUploadDTO dto, HttpSession session, Authentication authentication) {
		JSONObject data = new JSONObject();// 클라이언트(ckeditor)에게 json 형태 정보전달을 위한 변수
		MultipartFile upload = dto.getUpload();// 업로드된 파일
		String name = authentication.getName();// 업로드하려는 유저의 이름
		String rootPath = session.getServletContext().getRealPath("/");// 프로젝트 경로
		String filename = getDate() + "_" + name + "_" + upload.getOriginalFilename();// 업로드된 파일의 실제 이름
		String filePath = rootPath + "resources" + File.separator + "ckeditor" + File.separator + "editorImg" + File.separator;// 파일이 저장될 위치

		if (upload != null) {
			System.out.println(filePath);
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
			data.put("url", session.getServletContext().getContextPath() + "/editorImg/" + filename);
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

		for (MultipartFile mf : fileList) {
			if(!mf.isEmpty()) {
                try {
                    String filename = getDate() + "_" + name + "_" + new String(mf.getOriginalFilename().getBytes("UTF-8"),"UTF-8");// 업로드된 파일의 실제 이름
                    fileListDB.add(filename);// 파일 이름을 리스트에 저장한다.
                    String filePath = rootPath + "UpLoadFiles" + File.separator;// 파일들이 저장될 위치
                    System.out.println(filePath+filename);
                    File file = new File(filePath + filename);// 저장될 위치에 파일을 만든다.
                    mf.transferTo(file);// file의 경로에 업로드된 파일을 쓴다.
				} catch (IOException e) {
					e.printStackTrace();
					System.out.println("업로드 실패!!!");

					JSONObject jsonData = new JSONObject();
					jsonData.put("result", "write_error");
					return jsonData.toString();
				}
			}
			else{
				JSONObject jsonData = new JSONObject();
				jsonData.put("result", "null_files");
				return jsonData.toString();
			}
		}
		JSONObject jsonData = new JSONObject();
		jsonData.put("fileName",fileListDB.toString());
		return jsonData.toString();
	}

	@RequestMapping("/uploadP")
	public String page(){
		return "page";
	}

	public String getDate(){
		Date date = new Date();// 글이 작성된 시점을 기록한다
		SimpleDateFormat sDate = new SimpleDateFormat("yyyy.MM.dd.ss");
		return sDate.format(date);
	}

}
