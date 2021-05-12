package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.commons.VNSend;
import com.vn.app.commons.VNUtil;
import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;

import m.config.SystemConfig;

@Controller
public class ChartController {
	
	private static final Logger logger = LoggerFactory.getLogger(AccMngController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	private HttpClient httpClient;
	
	@Resource(name="homeServiceImpl")
	private HomeService homeService;
	
	@Resource(name="homeServiceImpl2")
	private HomeService2 homeService2;
	
	@RequestMapping(value = "/wts/view/chart.do", method = RequestMethod.GET)
	public String chartMain(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		model.addAttribute("TAB_INFO", "CHT_TAB" );
		return "/chart/chart";
	}
	
	@RequestMapping(value = "/chart/chart.do", method = RequestMethod.GET)
	public String chart(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		model.addAttribute("TAB_INFO", "CHT_TAB" );
		return "/chart/chart";
	}
	
	
	
	
	
	
	
	
	
	
	
	
}
