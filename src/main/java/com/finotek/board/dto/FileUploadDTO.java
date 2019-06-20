package com.finotek.board.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Getter @Setter
public class FileUploadDTO {
	private MultipartFile upload;
	private List<MultipartFile> fileList;
	private String CKEditorFuncNum;
}
