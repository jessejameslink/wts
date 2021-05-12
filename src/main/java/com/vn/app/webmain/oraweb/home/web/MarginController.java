package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.NameValuePair;
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

import m.config.SystemConfig;

@Controller
public class MarginController {
	private static final Logger logger = LoggerFactory.getLogger(MarginController.class);
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
	
	@RequestMapping(value = "/wts/view/margin.do", method = RequestMethod.GET)
	public String portfolio(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("margin.");
		model.addAttribute("TAB_INFO", "MSL_TAB" );
		return "/margin/margin";
	}
	
	@RequestMapping(value = "/margin/popup/placeOrder.do", method = RequestMethod.POST)
	public ModelAndView placeOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav= new ModelAndView();
		mav.addObject("symbol", req.getParameter("symbol"));
		mav.addObject("marketID", req.getParameter("marketID"));
		mav.addObject("divId", req.getParameter("divId"));
		mav.setViewName("/popup/placeOrder");
		
		return mav;
	}
	
	@RequestMapping(value = "/margin/popup/portfolioOrder.do", method = RequestMethod.POST)
	public ModelAndView portfolioOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav= new ModelAndView();
		mav.addObject("symbol", req.getParameter("symbol"));
		mav.addObject("marketID", req.getParameter("marketID"));
		mav.addObject("divId", req.getParameter("divId"));
		mav.setViewName("/popup/portfolioOrder");
		
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/margin/data/accountbalance.do", method = RequestMethod.GET)
	public ModelAndView accountbalance(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/accountbalance";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		
		if(req.getParameter("bankId") != null){
			jsonData.put("bankId", req.getParameter("bankId"));
		}
		
		if(req.getParameter("bankAcId") != null){
			jsonData.put("bankAcId", req.getParameter("bankAcId"));
		}
		
		if(req.getParameter("loadBank") != null){
			jsonData.put("loadBank", Boolean.parseBoolean(req.getParameter("loadBank")));
		}
		
		if(req.getParameter("isFO") != null){
			jsonData.put("isFO", Boolean.parseBoolean(req.getParameter("isFO")));
		}
		
		VNSend   vn    = new VNSend();
		logger.info(System.currentTimeMillis() + "*** Execute Function request accountbalance: " + req.getQueryString());
		outputResult   = vn.SendPostNew(url, jsonData, req);
		logger.info(System.currentTimeMillis() + "*** Execute Function respone accountbalance: " + outputResult.toJSONString());
		ModelAndView mav= new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/margin/data/queryMarketStatusInfo.do", method = RequestMethod.GET)
	public ModelAndView queryMarketStatusInfo(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/queryMarketStatusInfo";			
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("mvMarketID", req.getParameter("mvMarketID"));
		
		VNSend   vn    = new VNSend();
		logger.info(System.currentTimeMillis() + "*** Execute Function request queryMarketStatusInfo: " + req.getQueryString());
		outputResult   = vn.SendPostNew(url, jsonData, req);
		logger.info(System.currentTimeMillis() + "*** Execute Function respone queryMarketStatusInfo: " + outputResult.toJSONString());
		ModelAndView mav= new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/margin/data/avaiablemarginlist.do", method = RequestMethod.GET)
	public ModelAndView avaiablemarginlist(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/avaiablemarginlist";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("mvInstrumentID", req.getParameter("mvInstrumentID"));
		jsonData.put("mvMarketID", req.getParameter("mvMarketID"));
		jsonData.put("mvLending", req.getParameter("mvLending"));		
		
		if(req.getParameter("start") != null){
			jsonData.put("start", req.getParameter("start"));
		} else {
			jsonData.put("start", "0");
		}
		
		if(req.getParameter("limit") != null){
			jsonData.put("limit", req.getParameter("limit"));
		} else {
			jsonData.put("limit", "15");
		}
		
		if(req.getParameter("page") != null){
			jsonData.put("page", req.getParameter("page"));
		} else {
			jsonData.put("page", "0");
		}
		
		//System.out.println(jsonData);
		
		VNSend   vn    = new VNSend();
		outputResult   = vn.SendPostNew(url, jsonData, req);
		ModelAndView mav= new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
}
