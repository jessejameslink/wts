package com.vn.app.webmain.oraweb.home.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.commons.VNSend;
import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;

import m.config.SystemConfig;

@Controller
public class TTLController {
	
	private static final Logger logger = LoggerFactory.getLogger(TTLController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	public String JSESSIONID = "";
	private HttpClient httpClient;

	
	@Resource(name="homeServiceImpl")
	private HomeService homeService;
	
	@Resource(name="homeServiceImpl2")
	private HomeService2 homeService2;
	
	@RequestMapping(value = "/ttl/ttlcomet.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView ttlcomet(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "ttlcomet/comet.ttl";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		JSONObject outputResult		=	new JSONObject();
		ModelAndView mav= new ModelAndView();
		
		Date nTime = new Date();
	    long tt = nTime.getTime();

		if("ordercheck".equals(req.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "register"));
			paramList.add(new BasicNameValuePair("xtype", "dynOrderList"));
		} else if("ttlInit".equals(req.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "init"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("nowPricecheck".equals(req.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", req.getParameter("action")));
			paramList.add(new BasicNameValuePair("symbol", req.getParameter("symbol")));
			paramList.add(new BasicNameValuePair("marketId", req.getParameter("marketId")));
			paramList.add(new BasicNameValuePair("stockWatchID", req.getParameter("stockWatchID")+"-1234"));
			paramList.add(new BasicNameValuePair("xtype", req.getParameter("xtype")));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("orderlistUpdate".equals(req.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "register"));
			paramList.add(new BasicNameValuePair("xtype", "dynOrderList"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("unregister".equals(req.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "register"));
			paramList.add(new BasicNameValuePair("xtype", "dynOrderList"));
			paramList.add(new BasicNameValuePair("stockWatchID", req.getParameter("stockWatchID")));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("registerStock".equals(req.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "register"));
			paramList.add(new BasicNameValuePair("symbol", req.getParameter("symbol")));
			paramList.add(new BasicNameValuePair("marketId", req.getParameter("marketId")));
			paramList.add(new BasicNameValuePair("stockWatchID", req.getParameter("stockWatchID")+"stockmarketprice-1219"));
			paramList.add(new BasicNameValuePair("xtype", "dynStockWatch"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else if("unregisterStock".equals(req.getParameter("chk"))){
			paramList.add(new BasicNameValuePair("action", "unregister"));
			paramList.add(new BasicNameValuePair("xtype", "dynStockWatch"));
			paramList.add(new BasicNameValuePair("stockWatchID", req.getParameter("stockWatchID")+"|STOCK_WATCH"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		} else {
			paramList.add(new BasicNameValuePair("action", "update"));
			paramList.add(new BasicNameValuePair("_dc",  String.valueOf(tt)));
		}
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPost(url, paramList, req);
		
		mav.addObject("ttl", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/ttl/checkSession.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView checkSession(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		/*
		System.out.println("#############################################");
		System.out.println("#CHECK SESSION CALL");
		System.out.println("#chk===>" + req.getParameter("chk"));
		System.out.println("#############################################");
		*/
		JSONObject outputResult		=	new JSONObject();
		ModelAndView mav= new ModelAndView();
		
		String url = server + "checkSession";
		JSONObject jsonData = new JSONObject();
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(url, jsonData, req);
		mav.addObject("chkSession", outputResult);
		//System.out.println(outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
		
}
