package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import m.config.SystemConfig;

@Controller
public class GlobalNetworkController {
	
	private static final Logger logger = LoggerFactory.getLogger(GlobalNetworkController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
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
	
	@RequestMapping(value = "/home/globalNetwork/globalAmerica01.do", method = RequestMethod.GET)
	public String globalAmerica01(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAmerica01" : "/vn_home/globalNetwork/globalAmerica01");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAmerica02.do", method = RequestMethod.GET)
	public String globalAmerica02(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAmerica02" : "/vn_home/globalNetwork/globalAmerica02");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAmerica03.do", method = RequestMethod.GET)
	public String globalAmerica03(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAmerica03" : "/vn_home/globalNetwork/globalAmerica03");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAmerica04.do", method = RequestMethod.GET)
	public String globalAmerica04(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAmerica04" : "/vn_home/globalNetwork/globalAmerica04");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAsia01.do", method = RequestMethod.GET)
	public String globalAsia01(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAsia01" : "/vn_home/globalNetwork/globalAsia01");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAsia02.do", method = RequestMethod.GET)
	public String globalAsia02(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAsia02" : "/vn_home/globalNetwork/globalAsia02");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAsia03.do", method = RequestMethod.GET)
	public String globalAsia03(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAsia03" : "/vn_home/globalNetwork/globalAsia03");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAsia04.do", method = RequestMethod.GET)
	public String globalAsia04(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAsia04" : "/vn_home/globalNetwork/globalAsia04");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAsia05.do", method = RequestMethod.GET)
	public String globalAsia05(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAsia05" : "/vn_home/globalNetwork/globalAsia05");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAsia06.do", method = RequestMethod.GET)
	public String globalAsia06(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAsia06" : "/vn_home/globalNetwork/globalAsia06");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalAsia07.do", method = RequestMethod.GET)
	public String globalAsia07(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalAsia07" : "/vn_home/globalNetwork/globalAsia07");
	}
	
	@RequestMapping(value = "/home/globalNetwork/globalEu01.do", method = RequestMethod.GET)
	public String globalEu01(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/globalEu01" : "/vn_home/globalNetwork/globalEu01");
	}
	
	@RequestMapping(value = "/home/globalNetwork/global.do", method = RequestMethod.GET)
	public String global(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/globalNetwork/global" : "/vn_home/globalNetwork/global");
	}
}
