package com.vn.app.webmain.oraweb.home.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.vn.app.webmain.oraweb.home.service.LinkService;
import com.vn.app.webmain.oraweb.home.service.LinkVO;

import m.config.SystemConfig;

@Controller
public class LinkController {
	
	private static final Logger logger = LoggerFactory.getLogger(LinkController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	public String JSESSIONID = "";
	
	@Resource(name="linkServiceImpl")
	private LinkService linkService;
	
	public String getSession(){
		return this.JSESSIONID;
	}
	
	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}
	
	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}
	
	
	
	@RequestMapping(value = "/linkDown.do", method = RequestMethod.GET)
    @ResponseBody
    public void linkDown(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("LINK FILE DOWN CALL");
		
		LinkVO	linkVO		=	linkService.getLinkDetail(req.getParameter("ids"));
		
		String	fileData	=	linkVO.getData();
		String	fileName	=	linkVO.getFileName();
		
		String 	content 	= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content				=	content.replace("<Content>", "");
		content				=	content.replace("</Content>", "");
		
		byte[] decoded = Base64.decodeBase64(content);
		
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
    }
}
