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
import org.apache.http.message.BasicNameValuePair;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.commons.VNSend;
import com.vn.app.commons.VNUtil;
import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;

import m.action.TRExecuter;
import m.config.SystemConfig;
import m.web.common.WebInterface;
import m.web.common.WebParam;

@Controller
public class AccMngController {
	
	private static final Logger logger = LoggerFactory.getLogger(AccMngController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
//	private HttpClient httpClient;
	
	@Resource(name="homeServiceImpl")
	private HomeService homeService;
	
	@Resource(name="homeServiceImpl2")
	private HomeService2 homeService2;
	
	@RequestMapping(value = "/wts/view/account.do", method = RequestMethod.GET)
	public String acc_mng(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		logger.info("account.");
		model.addAttribute("TAB_INFO", "ACC_TAB" );
		return "/acc_mng/account";
	}
	
	/*
	 *	
	 */
	@RequestMapping(value = "/accInfo/accInfo.do", method = RequestMethod.GET)
	public String AccInfo(Locale locale, Model model) {
		//System.out.println("##ACC INFO CONTROLLER##");
		return "/acc_mng/acc_info";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/getAccInfo.do", method = RequestMethod.GET)
	public ModelAndView GetAccInfo(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {	
		String accUrl = server + "services/eqt/getclientdetail";		
		JSONObject outputResult		=	new JSONObject();		
		JSONObject jsonData = new JSONObject();
		jsonData.put("clientID", req.getParameter("mvClientID"));
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(accUrl, jsonData, req);
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/chgPwd.do", method = RequestMethod.GET)
	public ModelAndView ChgPwd(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String accUrl = server + "services/eqt/changepassword";		
		JSONObject outputResult		=	new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("password", req.getParameter("password"));
		jsonData.put("oldPassword", req.getParameter("oldPassword"));
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(accUrl, jsonData, req);
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/chgPIN.do", method = RequestMethod.GET)
	public ModelAndView ChgPIN(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String accUrl = server + "services/eqt/changePin";		
		JSONObject outputResult		=	new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("clientID", req.getParameter("clientID"));
		jsonData.put("oldPin", req.getParameter("oldPin"));
		jsonData.put("newPin", req.getParameter("newPin"));
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(accUrl, jsonData, req);
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/getStockSearch.do", method = RequestMethod.GET)
	public ModelAndView GetStockSearch(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/stockSearch";		
		JSONObject outputResult		=	new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("type", req.getParameter("type"));
		jsonData.put("value", req.getParameter("value"));
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(url, jsonData, req);
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	

	@RequestMapping(value = "/accInfo/ordHist.do", method = RequestMethod.GET)
	public String OrdHist(Locale locale, Model model) {
		VNUtil vn	=	new VNUtil();
		model.addAttribute("serverTime", vn.getCalDate());
		return "/acc_mng/ord_hist";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/getOrdHist.do", method = RequestMethod.GET)
	public ModelAndView GetOrdHist1(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String accUrl = server + "services/eqt/enquiryhistoryorder";		
		JSONObject outputResult		=	new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("mvStartTime", req.getParameter("mvStartTime"));
		jsonData.put("mvEndTime", req.getParameter("mvEndTime"));
		jsonData.put("mvBS", req.getParameter("mvBS"));
		jsonData.put("mvInstrumentID", req.getParameter("mvInstrumentID"));
		jsonData.put("start", req.getParameter("start"));
		jsonData.put("limit", req.getParameter("limit"));
		jsonData.put("page", req.getParameter("page"));
		
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(accUrl, jsonData, req);
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	@RequestMapping(value = "/accInfo/view/assetMargin.do", method = RequestMethod.GET)
	public String assetMargin(Locale locale, Model model) throws UnsupportedEncodingException {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/acc_mng/assetMargin";
	}
	
	@RequestMapping(value = "/accInfo/view/cashTransactionHistory.do", method = RequestMethod.GET)
	public String cashTransactionHistory(Locale locale, Model model) throws UnsupportedEncodingException {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/acc_mng/cashTransactionHistory";
	}
	
	@RequestMapping(value = "/accInfo/view/cashStatements.do", method = RequestMethod.GET)
	public String cashStatements(Locale locale, Model model) throws UnsupportedEncodingException {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/acc_mng/cashStatements";
	}
	
	@RequestMapping(value = "/accInfo/view/stockStatements.do", method = RequestMethod.GET)
	public String stockStatements(Locale locale, Model model) throws UnsupportedEncodingException {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/acc_mng/stockStatements";
	}
	
	@RequestMapping(value = "/accInfo/view/marginLoanStatements.do", method = RequestMethod.GET)
	public String marginLoanStatement(Locale locale, Model model) throws UnsupportedEncodingException {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/acc_mng/marginLoanStatements";
	}
	
	@RequestMapping(value = "/accInfo/view/marginLoanHistory.do", method = RequestMethod.GET)
	public String marginLoanHistory(Locale locale, Model model) throws UnsupportedEncodingException {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/acc_mng/marginLoanHistory";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/data/queryCashTranHistory.do", method = RequestMethod.GET)
	public ModelAndView queryCashTranHistory(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/queryCashTranHistory";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("tradeType", request.getParameter("tradeType"));
		jsonData.put("mvStartDate", request.getParameter("mvStartDate"));
		jsonData.put("mvEndDate", request.getParameter("mvEndDate"));	
		
		if(request.getParameter("start") != null){
			jsonData.put("start", request.getParameter("start"));
		} else {
			jsonData.put("start", "0");
		}
	
		if(request.getParameter("limit") != null){
			jsonData.put("limit", request.getParameter("limit"));
		} else {
			jsonData.put("limit", "15");
		}
	
		if(request.getParameter("page") != null){
			jsonData.put("page", request.getParameter("page"));
		} else {
			jsonData.put("page", "1");
		}
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/data/queryCashTranHisReport.do", method = RequestMethod.GET)
	public ModelAndView queryCashTranHisReport(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/queryCashTranHisReport";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("timePeriod", request.getParameter("timePeriod"));
		jsonData.put("mvStartDate", request.getParameter("mvStartDate"));
		jsonData.put("mvEndDate", request.getParameter("mvEndDate"));
		jsonData.put("tradeType", request.getParameter("tradeType"));
		
		if(request.getParameter("start") != null){
			jsonData.put("start", request.getParameter("start"));
		} else {
			jsonData.put("start", "0");
		}
		
		if(request.getParameter("limit") != null){
			jsonData.put("limit", request.getParameter("limit"));
		} else {
			jsonData.put("limit", "15");
		}
		
		if(request.getParameter("page") != null){
			jsonData.put("page", request.getParameter("page"));
		} else {
			jsonData.put("page", "1");
		}
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/data/hksStockTransactionHistory.do", method = RequestMethod.GET)
	public ModelAndView hksStockTransactionHistory(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/hksStockTransactionHistory";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("timePeriod", request.getParameter("timePeriod"));
		jsonData.put("mvStartDate", request.getParameter("mvStartDate"));
		jsonData.put("mvEndDate", request.getParameter("mvEndDate"));
		
		if(request.getParameter("start") != null){
			jsonData.put("start", request.getParameter("start"));
		} else {
			jsonData.put("start", "0");
		}
		
		if(request.getParameter("limit") != null){
			jsonData.put("limit", request.getParameter("limit"));
		} else {
			jsonData.put("limit", "15");
		}
		
		if(request.getParameter("page") != null){
			jsonData.put("page", request.getParameter("page"));
		} else {
			jsonData.put("page", "1");
		}
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/data/marginLoan.do", method = RequestMethod.GET)
	public ModelAndView marginLoan(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/marginLoan";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvStartDate", request.getParameter("mvStartDate"));
		jsonData.put("mvEndDate", request.getParameter("mvEndDate"));
		
		if(request.getParameter("start") != null){
			jsonData.put("start", request.getParameter("start"));
		} else {
			jsonData.put("start", "0");
		}
		
		if(request.getParameter("limit") != null){
			jsonData.put("limit", request.getParameter("limit"));
		} else {
			jsonData.put("limit", "15");
		}
		
		if(request.getParameter("page") != null){
			jsonData.put("page", request.getParameter("page"));
		} else {
			jsonData.put("page", "1");
		}
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/data/overduedebt.do", method = RequestMethod.GET)
	public ModelAndView overduedebt(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/overduedebt";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/accInfo/data/upcomingdebt.do", method = RequestMethod.GET)
	public ModelAndView upcomingdebt(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/upcomingdebt";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/accInfo/data/marginLoanHistory.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView marginLoanHistory(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		req.setCharacterEncoding("utf-8");
		
		req.setAttribute("client_id", req.getParameter("client_id"));
		req.setAttribute("user_id", req.getParameter("user_id"));
		req.setAttribute("skey", req.getParameter("skey"));
		req.setAttribute("from_date", req.getParameter("from_date"));
		req.setAttribute("to_date", req.getParameter("to_date"));
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibomagn").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
		
	}
	
}
