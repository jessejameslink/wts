package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.Locale;

import javax.mail.MessagingException;
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
import org.springframework.web.servlet.ModelAndView;

import m.config.SystemConfig;
import m.email.JavaEmail;

@Controller
public class SubPageController {
	
	private static final Logger logger = LoggerFactory.getLogger(SubPageController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	@RequestMapping(value = "/home/subpage/research.do", method = RequestMethod.GET)
	public String research(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================research");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/subpage/research" : "/vn_home/subpage/research");
	}
	
	@RequestMapping(value = "/home/subpage/sector.do", method = RequestMethod.GET)
	public String sector(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================research");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/subpage/sector" : "/vn_home/subpage/sector");
	}
	
	@RequestMapping(value = "/home/subpage/macro.do", method = RequestMethod.GET)
	public String macro(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================research");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/subpage/macro" : "/vn_home/subpage/macro");
	}
	
	@RequestMapping(value = "/home/subpage/contact.do", method = RequestMethod.GET)
	public String contact(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================contact");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/subpage/contact" : "/vn_home/subpage/contact");
	}
	
	@RequestMapping(value = "/home/subpage/sitemap.do", method = RequestMethod.GET)
	public String sitemap(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================sitemap");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/subpage/sitemap" : "/vn_home/subpage/sitemap");
	}
	
	@RequestMapping(value = "/home/subpage/private.do", method = RequestMethod.GET)
	public String private_(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================private");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/subpage/private" : "/vn_home/subpage/private");
	}

	@RequestMapping(value = "/home/subpage/terms.do", method = RequestMethod.GET)
	public String terms(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("home==========================terms");
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/subpage/terms" : "/vn_home/subpage/terms");
	}
	
	@RequestMapping(value = "/home/subpage/openAccount.do", method = RequestMethod.GET)
	public String openaccount(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		logger.info("home==========================openaccount");
		return ("/home/subpage/openAccount");
	}
	
	@RequestMapping(value = "/home/subpage/contact.do", method = RequestMethod.POST)
	public ModelAndView miraepost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		ModelAndView mav = new ModelAndView();
		String status = null;
		String emailSubject = "Contact Form submit from Customer!";
		String emailBody = "";
		
		if (req.getParameter("name") != null) {
			emailBody = "Sender Name: " + req.getParameter("name")
					+ "<br>";
		}
		if (req.getParameter("email") != null) {
			emailBody = emailBody + "Sender Email: "
					+ req.getParameter("email") + "<br>";
		}
		if (req.getParameter("phone") != null) {
			emailBody = emailBody + "Sender Phone: "
					+ req.getParameter("phone") + "<br>";
		}
		if (req.getParameter("content") != null) {
			emailBody = emailBody + "Message: " + req.getParameter("content")
					+ "<br>";
		}
		
		JavaEmail javaEmail = new JavaEmail();
		javaEmail.setMailServerProperties();
		try {
			javaEmail.createEmailMessage(emailSubject, emailBody);
			javaEmail.sendEmail();
			status = "success";
		} catch (MessagingException me) {
			status = "error";
		}			
		
		mav.addObject("trResult", status);
		mav.setViewName("jsonView");
		return mav;
	}
}
