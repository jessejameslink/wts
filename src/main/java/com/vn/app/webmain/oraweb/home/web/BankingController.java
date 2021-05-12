package com.vn.app.webmain.oraweb.home.web;

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
public class BankingController {
	
	private static final Logger logger = LoggerFactory.getLogger(BankingController.class);
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
	
	@RequestMapping(value = "/wts/view/banking.do", method = RequestMethod.GET)
	public String online(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		model.addAttribute("TAB_INFO", "BNK_TAB" );
		return "/banking/banking";
	}
	
	@RequestMapping(value = "/banking/view/cashTransfer.do", method = RequestMethod.GET)
	public String cashTransfer(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/banking/cashTransfer";
	}
	
	@RequestMapping(value = "/banking/view/cashTransferInternal.do", method = RequestMethod.GET)
	public String cashTransferInternal(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/banking/cashTransferInternal";
	}
	
	@RequestMapping(value = "/banking/view/stockTransferInternal.do", method = RequestMethod.GET)
	public String stockTransferInternal(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/banking/stockTransferInternal";
	}
	
	@RequestMapping(value = "/banking/view/cashDepositOnilne.do", method = RequestMethod.GET)
	public String cashDepositOnilne(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		return "/banking/cashDepositOnilne";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/banking/data/genfundtransfer.do", method = RequestMethod.GET)
	public ModelAndView genfundtransfer(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/genfundtransfer";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvTransactionType", request.getParameter("mvTransactionType"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/banking/data/hksCashTransactionHistory.do", method = RequestMethod.GET)
	public ModelAndView hksCashTransactionHistory(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/hksCashTransactionHistory";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("tradeType", request.getParameter("tradeType"));
		jsonData.put("mvStartDate", request.getParameter("mvStartDate"));
		jsonData.put("mvEndDate", request.getParameter("mvEndDate"));
		jsonData.put("mvStatus", request.getParameter("mvStatus"));
		jsonData.put("mvTransferType", request.getParameter("mvTransferType"));
		
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
	@RequestMapping(value = "/banking/data/enquiryInstrumentDW.do", method = RequestMethod.GET)
	public ModelAndView enquiryInstrumentDW(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/enquiryInstrumentDW";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("tranType", request.getParameter("mvTranType"));
		jsonData.put("startDate", request.getParameter("mvStartDate"));
		jsonData.put("endDate", request.getParameter("mvEndDate"));
		
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
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/banking/data/listInstrumenPortfolio.do", method = RequestMethod.GET)
	public ModelAndView listInstrumenPortfolio(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/listInstrumenPortfolio";
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));		
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/banking/data/cancelFundTransfer.do", method = RequestMethod.GET)
	public ModelAndView cancelFundTransfer(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/cancelFundTransfer";
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvTranID", request.getParameter("mvTranID"));
		jsonData.put("mvStatus", request.getParameter("mvStatus"));
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/banking/data/dofundtransfer.do", method = RequestMethod.GET)
	public ModelAndView dofundtransfer(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/dofundtransfer";
		request.setCharacterEncoding("UTF-8");
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("mvBankId", request.getParameter("mvBankId"));
		jsonData.put("mvDestClientID", request.getParameter("mvDestClientID"));
		jsonData.put("mvDestBankID", request.getParameter("mvDestBankID"));
		jsonData.put("inputBankName", request.getParameter("inputBankName"));
		jsonData.put("inputBankBranch", request.getParameter("inputBankBranch"));
		jsonData.put("mvDestAccountName", request.getParameter("mvDestAccountName"));
		jsonData.put("mvDestSubAccountID", request.getParameter("mvDestSubAccountID"));
		jsonData.put("mvAmount", request.getParameter("mvAmount"));
		jsonData.put("mvTransferType", request.getParameter("mvTransferType"));
		jsonData.put("mvRemark", request.getParameter("mvRemark"));
		jsonData.put("mvPersonCharged", request.getParameter("mvPersonCharged"));
		jsonData.put("mvWithdrawAmt", request.getParameter("mvWithdrawAmt"));
		jsonData.put("mvAvaiableAmt", request.getParameter("mvAvaiableAmt"));
		jsonData.put("mvTransferFee", request.getParameter("mvTransferFee"));
		jsonData.put("clientName", request.getParameter("mvClientName"));
		jsonData.put("mvDestBankAccountID", request.getParameter("mvDestBankAccountID"));
		jsonData.put("mvDestTradingAccSeq", request.getParameter("mvDestTradingAccSeq"));
		jsonData.put("base64", request.getParameter("mvBase64"));
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/banking/data/dofundtransferStockIn.do", method = RequestMethod.GET)
	public ModelAndView DofundtransferStockIn(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/instrumentDW";
		request.setCharacterEncoding("UTF-8");
		
		JSONObject outputResult       = new JSONObject();
		JSONObject jsonData = new JSONObject();
		jsonData.put("subAccountID", request.getParameter("mvSubAccountID"));
		jsonData.put("destTradingAccSeq", Integer.parseInt(request.getParameter("mvDestTradingAccSeq")));
		jsonData.put("destSubAccountID", request.getParameter("mvDestSubAccountID"));
		
		jsonData.put("marketID", request.getParameter("mvMarketID"));
		jsonData.put("instrumentID", request.getParameter("mvInstrumentID"));
		jsonData.put("remark", request.getParameter("mvRemark"));
		jsonData.put("qty", Long.parseLong(request.getParameter("mvQty")));
		jsonData.put("base64", request.getParameter("mvBase64"));
		
		//System.out.println(jsonData);
		
		VNSend   vn      = new VNSend();
		outputResult     = vn.SendPostNew(url, jsonData, request);
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", outputResult);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/banking/data/checkFundTransferTime.do", method = RequestMethod.GET)
	public ModelAndView checkFundTransferTime(Locale locale, Model model, HttpServletRequest request, HttpServletResponse res) throws Exception {
		String url = server + "services/eqt/checkFundTransferTime";
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
}
