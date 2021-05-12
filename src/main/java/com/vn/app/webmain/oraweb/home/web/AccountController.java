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
public class AccountController {
	
	private static final Logger logger = LoggerFactory.getLogger(AccountController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	/*
	@RequestMapping(value = "/home/account/myasset.do", method = RequestMethod.GET)
	public String myasset(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================myasset");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/account/myasset" : "/vn_home/account/myasset");
	}
	*/
	@RequestMapping(value = "/home/account/changePw.do", method = RequestMethod.GET)
	public String changePw(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================myasset");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/account/change_pw" : "/vn_home/account/change_pw");
	}
	
	@RequestMapping(value = "/home/account/resetpassword.do", method = RequestMethod.GET)
	public String resetpassword(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("home==========================reset password");
		return ("/home/account/resetpassword");
	}
}
