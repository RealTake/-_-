package com.finotek.board.controller;


import java.io.File;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;


@Controller
public class DownloadController {

    //  파일 다운로드 하는 메소드
//	    @RequestMapping(value = "/test/fileDownload")
//	    public ModelAndView reDocumentDown(@RequestParam("bid") String bid) {
//
//	    	String path = dao.getPath(bid);
//
//	    	//전체 경로를 인자로 넣어 파일 객체를 생성
//	    	File downFile = new File("E:/code_WC/" + path);
//
//	        return new ModelAndView("downloadView", "downloadFile", downFile);
//	    }

    @GetMapping(value = "/fileDownload/{Fname:.+}")
    public ModelAndView reDocumentDown(@PathVariable("Fname") String Fname, HttpSession session) {
        String rootPath = session.getServletContext().getRealPath("/");
        String savePath = rootPath + "UpLoadFiles" + File.separator;

        Fname = Fname.replaceAll("\\|/", "");
        System.out.println("다운로드될 파일 : " + Fname);
        //전체 경로를 인자로 넣어 파일 객체를 생성
        File downFile = new File(savePath + Fname);

        return new ModelAndView("downloadView", "downloadFile", downFile);
    }

}