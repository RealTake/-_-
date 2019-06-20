package com.finotek.board.service;

import java.io.File;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.FileUtils;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.view.AbstractView;

@Component
public class downloadView extends AbstractView{

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
                                           HttpServletResponse response) throws Exception {

        setContentType("application/octet-stream");
        File file = (File) model.get("downloadFile");
        byte[] fileByte = FileUtils.readFileToByteArray(file);

        response.setContentType(getContentType());
        response.setContentLength((int) fileByte.length);

        response.setHeader("Content-Disposition", "attachment; filename=\"" +  URLEncoder.encode(file.getName(), "UTF-8") + "\";");
        response.setHeader("Content-Tranfer-Encoding", "binary");
        response.getOutputStream().write(fileByte);

        response.getOutputStream().flush();
        response.getOutputStream().close();
    }

}
