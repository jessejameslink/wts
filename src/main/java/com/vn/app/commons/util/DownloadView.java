package	com.vn.app.commons.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;
 
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;
 
@Controller // BeanNameViewResolver 이용
public class DownloadView extends AbstractView {
 
    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
 
        // 파라미터 Map은 컨트롤러에서 Model에 저장된 값을 받는다!!
        File file = (File) model.get("downfile"); // DownloadController에서 model로 보낸거임
 
        // view페이지 설정
        response.setContentType(super.getContentType());
        response.setContentLength((int) file.length());// 파일의 크기
 
        // 웹브라우저의 종류를 얻어와야함
        // 크롬에서 F12 누르고, Network에서 Request Headers에서 얻어옴
        String filename = null;
        String userAgent = request.getHeader("User-Agent");
 
        // boolean chrome = userAgent.indexOf("Chrome") > -1; //크롬이 어디에 있는지 찾는거
        boolean ie = userAgent.indexOf("Trident") > -1;
        // 웹 브라우저마다 한글 체계가 다르기 때문에 이렇게 해줘야 함
        if (ie) {
            filename = URLEncoder.encode(file.getName(), "UTF-8");
        } else {
            filename = new String(file.getName().getBytes("UTF-8"), "iso-8859-1");
        }
        
        // " 이거 하기위해서 \" 이걸로 대체한거임 "" 이렇게 못하니까
        response.setHeader("Content-Disposition", "attachment;filename=\""+ filename +"\";");
        response.setHeader("Content-Transger-Encoding", "binary");
        
        OutputStream out = response.getOutputStream();
        FileInputStream fis = null;
        
        try{
            fis = new FileInputStream(file); //file객체가 와야함
            FileCopyUtils.copy(fis, out); 
        }finally{
            //무조건 수행
            if(fis!=null) fis.close();
        }
        
        out.flush(); //input할 수 있게 outputStream 비우는 것
        
    }
 
}

