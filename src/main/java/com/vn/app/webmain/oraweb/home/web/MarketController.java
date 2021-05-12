package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import m.config.SystemConfig;

@Controller
public class MarketController {
	
	private static final Logger logger = LoggerFactory.getLogger(MarketController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	public String JSESSIONID = "";
	
	public String getSession(){
		return this.JSESSIONID;
	}
	
	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}
	
	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}
	
	@RequestMapping(value = "/wts/view/market.do", method = RequestMethod.GET)
	public String market(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("market==========================market");
		model.addAttribute("TAB_INFO", "MIF_TAB" );
		return "/market/market";
	}
	
	@RequestMapping(value = "/market/view/marketOverview.do", method = RequestMethod.GET)
	public String marketOverview(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/market/marketOverview";
	}
	
	@RequestMapping(value = "/market/view/priceHistory.do", method = RequestMethod.GET)
	public String priceHistory(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/market/priceHistory";
	}
	
	@RequestMapping(value = "/market/view/tradingResults.do", method = RequestMethod.GET)
	public String tradingResults(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/market/tradingResults";
	}
	
	@RequestMapping(value = "/market/view/foreignerTransaction.do", method = RequestMethod.GET)
	public String foreignerTransaction(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/market/foreignerTransaction";
	}
}
