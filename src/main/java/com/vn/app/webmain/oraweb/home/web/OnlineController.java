package com.vn.app.webmain.oraweb.home.web;

import java.util.Locale;
import java.util.List;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.commons.VNSend;

import m.common.tool.tool;
import m.config.SystemConfig;

@Controller
public class OnlineController {
	
	private static final Logger logger = LoggerFactory.getLogger(OnlineController.class);
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
	  
	@RequestMapping(value = "/wts/view/online.do", method = RequestMethod.GET)
	public String online(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		model.addAttribute("TAB_INFO", "ONS_TAB" );
		return "/online/online";
	}
	
	@RequestMapping(value = "/online/view/cashAdvance.do", method = RequestMethod.GET)
	public String cashAdvance(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/online/cashAdvance";
	}
	
	@RequestMapping(value = "/online/view/cashAdvanceBank.do", method = RequestMethod.GET)
	public String cashAdvanceBank(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/online/cashAdvanceBank";
	}
	
	@RequestMapping(value = "/online/view/oddLotOrder.do", method = RequestMethod.GET)
	public String oddLotOrder(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/online/oddLotOrder";
	}
	
	@RequestMapping(value = "/online/view/entitlementOnline.do", method = RequestMethod.GET)
	public String entitlementOnline(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/online/entitlementOnline";
	}
	
	@RequestMapping(value = "/online/view/loanRefund.do", method = RequestMethod.GET)
	public String loanRefund(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/online/loanRefund";
	}
	
	@RequestMapping(value = "/online/view/onlineSignOrder.do", method = RequestMethod.GET)
	public String onlineSignOrder(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/online/onlineSignOrder";
	}
	
	@RequestMapping(value = "/online/view/otpServices.do", method = RequestMethod.GET)
	public String OtpServices(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/online/otpServices";
	}
	
	/* action - in Controller */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/submitLoanRefundCreation.do", method = RequestMethod.GET)
	public ModelAndView submitLoanRefundCreation(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "services/eqt/submitLoanRefundCreation";
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("lvLoanPay", request.getParameter("lvLoanPay"));
		jsonData.put("lvAmount", request.getParameter("lvAmount"));
		jsonData.put("lvRemark", request.getParameter("lvRemark"));
		jsonData.put("lvRemark", request.getParameter("lvRemark"));
		jsonData.put("base64", request.getParameter("mvBase64"));
		
		//System.out.println(jsonData);
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(url, jsonData, request);
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/checkLoanRefundTime.do", method = RequestMethod.GET)
	public ModelAndView checkLoanRefundTime(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "services/eqt/checkLoanRefundTime";
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		
		VNSend	vn		=	new VNSend();
		outputResult	=	vn.SendPostNew(url, jsonData, request);
		ModelAndView mav= new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/querySoldOrders.do", method = RequestMethod.GET)
	public ModelAndView querySoldOrders(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/querySoldOrders";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("settlement", "3T");
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/online/data/queryAdvancePaymentInfo.do", method = RequestMethod.GET)
	public ModelAndView queryAdvancePaymentInfo(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/queryAdvancePaymentInfo";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvBankID", request.getParameter("mvBankID"));
		jsonData.put("mvSettlement", request.getParameter("mvSettlement"));
		
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getCashAdvanceHistory.do", method = RequestMethod.GET)
	public ModelAndView getCashAdvanceHistory(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getCashAdvanceHistory";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		
		if(request.getParameter("queryBank") != null){
			jsonData.put("queryBank", Boolean.parseBoolean(request.getParameter("queryBank")));
		}
		
		if(request.getParameter("start") != null){
			jsonData.put("start", request.getParameter("start"));
		} else {
			jsonData.put("start", "0");
		}
		
		if(request.getParameter("limit") != null){
			jsonData.put("limit", request.getParameter("limit"));
		} else {
			jsonData.put("limit", "1000");
		}
		
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getLoanRefundData.do", method = RequestMethod.GET)
	public ModelAndView getLoanRefundData(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "services/eqt/getLoanRefundData";
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		
		if(request.getParameter("start") != null){
			jsonData.put("start", request.getParameter("start"));
		} else {
			jsonData.put("start", "0");
		}
		
		if(request.getParameter("limit") != null){
			jsonData.put("limit", request.getParameter("limit"));
		} else {
			jsonData.put("limit", "100");
		}

		VNSend   vn      = new VNSend();						
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getLocalLoanRefundCreation.do", method = RequestMethod.GET)
	public ModelAndView getLocalLoanRefundCreation(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "services/eqt/getLocalLoanRefundCreation";
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
	@RequestMapping(value = "/online/data/getAnnouncement.do", method = RequestMethod.GET)
	public ModelAndView getAnnouncement(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "services/eqt/getAnnouncement";
		
		JSONObject jsonData = new JSONObject();
		jsonData.put("clientID", request.getParameter("mvClientID"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/queryBankInfo.do", method = RequestMethod.GET)
	public ModelAndView queryBankInfo(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "services/eqt/queryBankInfo";
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
	@RequestMapping(value = "/online/data/getLoanRefundHistory.do", method = RequestMethod.GET)
	public ModelAndView getLoanRefundHistory(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "services/eqt/getLoanRefundHistory";
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
			jsonData.put("limit", "100");
		}
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getLocalAdvanceCreation.do", method = RequestMethod.GET)
	public ModelAndView getLocalAdvanceCreation(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getLocalAdvanceCreation";
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
	@RequestMapping(value = "/online/data/submitAdvancePaymentCreation.do", method = RequestMethod.GET)
	public ModelAndView submitAdvancePaymentCreation(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/submitAdvancePaymentCreation";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", req.getParameter("mvSubAccountID"));
		jsonData.put("clientName", req.getParameter("mvClientName"));
		jsonData.put("lvAmount", req.getParameter("lvAmount"));		
		jsonData.put("mvAdvAvai", req.getParameter("lvAdvAvaiable"));
		jsonData.put("mvAdvReq", req.getParameter("lvAdvRequest"));
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, req);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/checkAdvancePaymentTime.do", method = RequestMethod.GET)
	public ModelAndView checkAdvancePaymentTime(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/checkAdvancePaymentTime";
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
	@RequestMapping(value = "/online/data/enquiryOddLot.do", method = RequestMethod.GET)
	public ModelAndView enquiryOddLot(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/enquiryOddLot";
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
	@RequestMapping(value = "/online/data/oddLotHistoryEnquiry.do", method = RequestMethod.GET)
	public ModelAndView oddLotHistoryEnquiry(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/oddLotHistoryEnquiry";
		
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
	@RequestMapping(value = "/online/data/getEntitlementStockList.do", method = RequestMethod.GET)
	public ModelAndView getEntitlementStockList(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getEntitlementStockList";
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
	@RequestMapping(value = "/online/data/getAllRightList.do", method = RequestMethod.GET)
	public ModelAndView getAllRightList(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getAllRightList";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvActionType", request.getParameter("mvActionType"));
		jsonData.put("mvStockId", request.getParameter("mvStockId"));
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
			jsonData.put("limit", "100");
		}
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getAdditionIssueShareInfo.do", method = RequestMethod.GET)
	public ModelAndView getAdditionIssueShareInfo(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getAdditionIssueShareInfo";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));		

		if(request.getParameter("start") != null){
			jsonData.put("start", request.getParameter("start"));	
		} else {
			jsonData.put("start", "0");	
		}
		
		if(request.getParameter("limit") != null){
			jsonData.put("limit", request.getParameter("limit"));	
		} else {
			jsonData.put("limit", "100");	
		}	
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getEntitlementHistory.do", method = RequestMethod.GET)
	public ModelAndView getEntitlementHistory(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getEntitlementHistory";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvStockID", request.getParameter("mvStockId"));
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
			jsonData.put("limit", "100");	
		}
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getEntitlementData.do", method = RequestMethod.GET)
	public ModelAndView getEntitlementData(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/getEntitlementData";
		JSONObject outputResult       = new JSONObject();

		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvStockId", request.getParameter("mvStockId"));
		jsonData.put("mvMarketId", request.getParameter("mvMarketId"));
		jsonData.put("mvEntitlementId", request.getParameter("mvEntitlementId"));
		jsonData.put("mvLocationId", request.getParameter("mvLocationId"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/setRegisterExercise.do", method = {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView setRegisterExercise(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/doRegisterExercise";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvStockId", request.getParameter("mvStockId"));
		jsonData.put("mvMarketId", request.getParameter("mvMarketId"));
		jsonData.put("mvLocationId", request.getParameter("mvLocationId"));
		jsonData.put("mvQuantity", request.getParameter("mvQuantity"));
		jsonData.put("mvInterfaceSeq", request.getParameter("mvInterfaceSeq"));
		jsonData.put("mvEntitlementId", request.getParameter("mvEntitlementId"));
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/online/popup/oddLotOrder.do", method = RequestMethod.POST)
	public String oddLotOrder(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/popup/oddLotOrderConfirm";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/submitOddLot.do", method = {RequestMethod.GET, RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView submitOddLot(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/submitOddLot";
		JSONObject outputResult       = new JSONObject();
		
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvOddList", request.getParameter("mvOddList"));

		jsonData.put("announcementID", request.getParameter("annoucementId"));
		jsonData.put("mvInterfaceSeq", request.getParameter("mvInterfaceSeq"));
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/calculateInterestAmt.do", method = RequestMethod.GET)
	public ModelAndView calculateInterestAmt(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/calculateInterestAmt";
		JSONObject outputResult       = new JSONObject();

		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvSettlement", request.getParameter("mvSettlement"));
		jsonData.put("mvAmount", request.getParameter("mvAmount"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/submitBankAdvancePayment.do", method = RequestMethod.GET)
	public ModelAndView submitBankAdvancePayment(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/submitBankAdvancePayment";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvOrderIDStrArray", request.getParameter("mvOrderIDStrArray"));
		jsonData.put("mvContractIDStrArray", request.getParameter("mvContractIDStrArray"));
		jsonData.put("mvBankID", request.getParameter("mvBankID"));
		jsonData.put("mvTPLUSX", request.getParameter("mvTPLUSX"));
		jsonData.put("mvAmount", request.getParameter("mvAmount"));
		jsonData.put("mvTotalAmt", request.getParameter("mvTotalAmt"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/getOnlineSignOrderList.do", method = RequestMethod.GET)
	public ModelAndView getOnlineSignOrderList(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/enquirysignorder";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		
		jsonData.put("mvOrderType", request.getParameter("mvOrderType"));
		jsonData.put("mvMarketID", request.getParameter("mvMarketID"));
		jsonData.put("mvStartTime", request.getParameter("mvStartTime"));
		jsonData.put("mvEndTime", request.getParameter("mvEndTime"));
		jsonData.put("mvBS", request.getParameter("mvBS"));
		jsonData.put("mvStatus", request.getParameter("mvStatus"));
		jsonData.put("mvSorting", request.getParameter("mvSorting"));
		jsonData.put("mvInstrumentID", request.getParameter("mvInstrumentID"));
							
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
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/submitSignOrder.do", method = RequestMethod.GET)
	public ModelAndView submitSignOrder(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {

		String filepath = SystemConfig.get("SIGNDATA_PATH");	
		File theDir = new File(filepath);

		if (!theDir.exists()) {
		    boolean result = false;
		    try{
		        theDir.mkdir();
		        result = true;
		    } 
		    catch(SecurityException se){
		        //handle it
		    }        
		    if(result) {    
		        //System.out.println("DIR created");  
		    }
		}
		
		String filepathlocal = "D:/signdata.txt";
		
		String url = server + "services/eqt/submitSignOrder";		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		
		//log Sign order
		//add mvRemark
		String remarks = "";
		HttpSession session = request.getSession();
		String jSes = (String)session.getAttribute("ttlJsession");
		int idx = jSes.indexOf(';');
		String ss = jSes.substring(0, idx);
		remarks += getClientIpAddr(request) + " *** " + ss;
		String sAuth = (String)session.getAttribute("saveAuth");
		String tk1 = (String)session.getAttribute("txtKey1");
		String tk2 = (String)session.getAttribute("txtKey2");
		String vk1 = (String)session.getAttribute("valKey1");
		String vk2 = (String)session.getAttribute("valKey2");
		
		//add OTP
		String datamvUserID = (String)session.getAttribute("datamvUserID");
		String dataauthenTime = (String)session.getAttribute("dataauthenTime");
		String dataSaveOTP = (String)session.getAttribute("dataSaveOTP");
		String datadvid = (String)session.getAttribute("datadvid");
		String datauszCustomerNo = (String)session.getAttribute("datauszCustomerNo");
		String datauszOTP = (String)session.getAttribute("datauszOTP");
		
		
		String authenMethod = (String)session.getAttribute("authenMethod");
		
		if (authenMethod == "matrix") {
			remarks += " *** Verify method: Matrix, " + sAuth + ",[" + tk1 + "]:" + vk1 + ",[" + tk2 + "]:" + vk2;
			jsonData.put("mvRemark", getClientIpAddr(request) + " *** Verify method: Matrix");
		} else {
			remarks += " *** Verify method: " + authenMethod + ",datamvUserID " + datamvUserID + ",dataauthenTime " + dataauthenTime + ",dataSaveOTP " + dataSaveOTP + ",datadvid " + datadvid + ",datauszCustomerNo " + datauszCustomerNo + ",datauszOTP " + datauszOTP;
			jsonData.put("mvRemark", getClientIpAddr(request) + " *** Verify method: " + authenMethod);
		}
		//
		
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(request.getParameter("mvOrderList"));
		jsonData.put("mvOrderList",obj);
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		
		//write Sign log
		String str = "\r\n";	    
		
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "signdata.txt", true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }
	    writer.append("[IN] " + tool.getCurrentFormatedTime() + " ");
	    writer.append(request.getSession().getAttribute("ClientV") + " IP Address: " + remarks + "|" + request.getParameter("mvSubAccountID") + "|" + request.getParameter("mvOrderList"));
	    writer.append(str);
	    writer.append("[OUT] " + tool.getCurrentFormatedTime() + " " + request.getSession().getAttribute("ClientV") + "|" + outputResult + "|" + request.getParameter("mvOrderList"));	  
	    
	    writer.append(str);
	    writer.close();
			    
			    
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		
		
		
		return mav;
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/genOTP.do", method = RequestMethod.GET)
	public ModelAndView genOTP(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "otp/newotp";
		
		//List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		//paramList.add(new BasicNameValuePair("action", request.getParameter("mvAction")));
		//paramList.add(new BasicNameValuePair("destination", request.getParameter("mvDestination")));
		//paramList.add(new BasicNameValuePair("language", request.getParameter("mvLanguage")));
		
		//VNSend	vn		=	new VNSend();
		//outputResult	=	vn.SendPost(url, paramList, request);
		
		JSONObject jsonData = new JSONObject();
		jsonData.put("action", request.getParameter("mvAction"));
		jsonData.put("destination", request.getParameter("mvDestination"));
		jsonData.put("language", request.getParameter("mvLanguage"));
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/online/data/verifyOTP.do", method = RequestMethod.GET)
	public ModelAndView verifyOTP(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		String url = server + "otp/verify";
		
		//List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		
		//paramList.add(new BasicNameValuePair("key", request.getParameter("mvSecretKey")));
		//paramList.add(new BasicNameValuePair("otp", request.getParameter("mvOtp")));
		
		//VNSend	vn		=	new VNSend();
		//outputResult	=	vn.SendPost(url, paramList, request);
		
		JSONObject jsonData = new JSONObject();
		jsonData.put("clientID", request.getParameter("mvClientID"));		
		jsonData.put("key", request.getParameter("mvSecretKey"));
		jsonData.put("otp", request.getParameter("mvOtp"));
		jsonData.put("language",request.getParameter("mvLanguage"));
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		
		
		
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", outputResult);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	private static final String[] IP_HEADER_CANDIDATES = { 
		    "X-Forwarded-For",
		    "Proxy-Client-IP",
		    "WL-Proxy-Client-IP",
		    "HTTP_X_FORWARDED_FOR",
		    "HTTP_X_FORWARDED",
		    "HTTP_X_CLUSTER_CLIENT_IP",
		    "HTTP_CLIENT_IP",
		    "HTTP_FORWARDED_FOR",
		    "HTTP_FORWARDED",
		    "HTTP_VIA",
		    "REMOTE_ADDR" };
	
	public String getClientIpAddr(HttpServletRequest request) {  
		for (String header : IP_HEADER_CANDIDATES) {
	        String ip = request.getHeader(header);
	        if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
	            return ip;
	        }
	    }
	    return request.getRemoteAddr();  
	}
}
