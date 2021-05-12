package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.webmain.oraweb.home.service.JobTitleService;
import com.vn.app.webmain.oraweb.home.service.JobTitleVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

import m.config.SystemConfig;
import m.email.JavaEmail;

@Controller
public class DerivatiesController {
	
	private static final Logger logger = LoggerFactory.getLogger(DerivatiesController.class);
	
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	@Resource(name="jobTitleServiceImpl")
	private JobTitleService jobTitleService;
	
	public String JSESSIONID = "";
//	private HttpClient httpClient;
	
	public String getSession(){
		return this.JSESSIONID;
	}
	
	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}
	
	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}
	
	@RequestMapping(value = "/home/derivaties/basicconcept.do", method = RequestMethod.GET)
	public String basicconcept(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/basicconcept" : "/vn_home/derivaties/basicconcept");
	}
	
	@RequestMapping(value = "/home/derivaties/indexseries.do", method = RequestMethod.GET)
	public String indexseries(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/indexseries" : "/vn_home/derivaties/indexseries");
	}
	
	@RequestMapping(value = "/home/derivaties/bondseries.do", method = RequestMethod.GET)
	public String bondseries(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/bondseries" : "/vn_home/derivaties/bondseries");
	}
	
	@RequestMapping(value = "/home/derivaties/feetable.do", method = RequestMethod.GET)
	public String feetable(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/feetable" : "/vn_home/derivaties/feetable");
	}
	
	@RequestMapping(value = "/home/derivaties/tradeguide.do", method = RequestMethod.GET)
	public String tradeguide(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/tradeguide" : "/vn_home/derivaties/tradeguide");
	}
	
	@RequestMapping(value = "/home/derivaties/derinews.do", method = RequestMethod.GET)
	public String derinews(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/derinews" : "/vn_home/derivaties/derinews");
	}
	
	@RequestMapping(value = "/home/derivaties/registernews.do", method = RequestMethod.GET)
	public String registernews(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/registernews" : "/vn_home/derivaties/registernews");
	}
	
	@RequestMapping(value = "/home/derivaties/endow.do", method = RequestMethod.GET)
	public String Endow(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/derivaties/endow" : "/vn_home/derivaties/endow");
	}
}
