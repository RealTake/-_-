package com.finotek.board.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.finotek.board.dto.FileUploadDTO;

@Controller
public class fileUploadController {
		
		@ResponseBody
	    @RequestMapping(value = "/fileUpload.do", method = RequestMethod.POST, produces = "application/json; charset=utf8")
	    public String fileUpload(@ModelAttribute("fileUploadVO") FileUploadDTO dto , HttpServletRequest request) {
	        JSONObject data = new JSONObject();
	    	HttpSession session = request.getSession();
	        
	        MultipartFile upload = dto.getUpload();
	        
	        String rootPath = session.getServletContext().getRealPath("/");
	        String filename = upload.getOriginalFilename();
	        String filePath = "";

	        if(upload != null)
	        {
	
	 	        filePath = rootPath + "resources" + File.separator + "ckeditor" + File.separator + "editorImg" + File.separator;
	 	        
	 	        System.out.println(filePath);
	            File file = new File(filePath + filename);
	            try {
					upload.transferTo(file);
				} catch (IllegalStateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}    
	            
	            data.put("uploaded", 1);
		        data.put("fileName", filename);
		        data.put("url", session.getServletContext().getContextPath() + "/editorImg/" + filename);
	        }
	        else
	        {
			    data.put("uploaded", 0);
			    data.put("error", "");
	        }
	        return data.toString();
	    }
	    
	}
