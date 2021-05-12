package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.HttpClient;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;

import m.action.ChartExecuter;
import m.action.TRExecuter;
import m.config.SystemConfig;
import m.web.common.WebInterface;
import m.web.common.WebParam;
//import net.sf.json.JSONObject;

@Controller
public class TrTestController {
	
	private static final Logger logger = LoggerFactory.getLogger(TradingController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	@Resource(name="homeServiceImpl")
	private HomeService homeService;
	
	@Resource(name="homeServiceImpl2")
	private HomeService2 homeService2;
	
	public String JSESSIONID = "";
	private HttpClient httpClient;
	
	public String getSession(){
		return this.JSESSIONID;
	}
	
	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}
	
	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}

	
	@RequestMapping(value = "/trading/view/trtest.do", method = RequestMethod.GET)
	public String Hobby(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/trtest";
	}
	
	@RequestMapping(value = "/trading/data/pibosday.do", method = RequestMethod.GET)
	public ModelAndView pobosdayCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibosday").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/pibomati.do", method = RequestMethod.GET)
	public ModelAndView pobomatiCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibomati").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	@RequestMapping(value = "/trading/data/pibotopm.do", method = RequestMethod.GET)
	public ModelAndView pibotopmCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibotopm").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/pibomost.do", method = RequestMethod.GET)
	public ModelAndView pibomostCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibomost").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	@RequestMapping(value = "/trading/data/pibonewh.do", method = RequestMethod.GET)
	public ModelAndView pibonewhCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibonewh").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	@RequestMapping(value = "/trading/data/piboaccn.do", method = RequestMethod.GET)
	public ModelAndView piboaccnCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piboaccn").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/trading/data/pibochart1.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView piboChartCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		String	_count	=	req.getParameter("count");
		String	_dummy	=	"";
		String	_dataKind	=	req.getParameter("dataKind");
		String	_dataKey	=	req.getParameter("dataKey");
		String	_date		=	req.getParameter("date");
		String	_unit		=	req.getParameter("unit");			//	1:종목, 2:업종, 3:선물
		String	_dataIndex	=	req.getParameter("dataIndex");			//	1:일봉, 2:주봉, 3:월봉, 4:년봉, 5:분, 틱
		String	_gap		=	req.getParameter("gap");			//	n분, n틱
		
		req.setCharacterEncoding("utf-8");
		req.setAttribute("1301", req.getParameter("rcod"));
		
		req.setAttribute("count", _count);
		req.setAttribute("dataKind", _dataKind);
		req.setAttribute("dataKey", _dataKey);
		req.setAttribute("date", _date);
		req.setAttribute("unit", _unit);
		req.setAttribute("dataIndex", _dataIndex);
		req.setAttribute("gap", _gap);
		req.setAttribute("lastTickCount", "0");
		req.setAttribute("page", "1");
		
		req.setAttribute("option1", "");
		req.setAttribute("option2", "");
		
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new ChartExecuter(webInterface, "pibochart1").execute();
			//outputResult = new TRExecuter(webInterface, "pibochart1").execute();
			//System.out.println(outputResult);
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	

	@RequestMapping(value = "/trading/data/pibochart2.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView piboChartCall2(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		String	_count	=	req.getParameter("count");
		String	_dummy	=	"";
		String	_dataKind	=	req.getParameter("dataKind");
		String	_dataKey	=	req.getParameter("dataKey");
		String	_date		=	req.getParameter("date");
		String	_unit		=	req.getParameter("unit");			//	1:종목, 2:업종, 3:선물
		String	_dataIndex	=	req.getParameter("dataIndex");			//	1:일봉, 2:주봉, 3:월봉, 4:년봉, 5:분, 틱
		String	_gap		=	req.getParameter("gap");			//	n분, n틱
		
		req.setCharacterEncoding("utf-8");
		req.setAttribute("1301", req.getParameter("rcod"));
		
		req.setAttribute("count", _count);
		req.setAttribute("dataKind", _dataKind);
		req.setAttribute("dataKey", _dataKey);
		req.setAttribute("date", _date);
		req.setAttribute("unit", _unit);
		req.setAttribute("dataIndex", _dataIndex);
		req.setAttribute("gap", _gap);
		req.setAttribute("lastTickCount", "0");
		req.setAttribute("page", "1");
		
		req.setAttribute("option1", "");
		req.setAttribute("option2", "");
		
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new ChartExecuter(webInterface, "pibochart2").execute();
			//outputResult = new TRExecuter(webInterface, "pibochart1").execute();
			//System.out.println(outputResult);
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	
	
	
	
	
	
	
	@RequestMapping(value = "/trading/data/piborsch.do", method = RequestMethod.GET)
	public ModelAndView piborschCall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piborsch").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	@RequestMapping(value = "/chart.do", method = RequestMethod.GET)
	public String Chart(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/chart/chart";
	}
	
	@RequestMapping(value = "/chart2.do", method = RequestMethod.GET)
	public String Chart2(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/chart/chart2";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@RequestMapping(value = "/trading/data/pibochart3.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView piboChartCall3(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		String	_count	=	req.getParameter("count");
		String	_dummy	=	"";
		String	_dataKind	=	req.getParameter("dataKind");
		String	_dataKey	=	req.getParameter("dataKey");
		String	_date		=	req.getParameter("date");
		String	_unit		=	req.getParameter("unit");			//	1:종목, 2:업종, 3:선물
		String	_dataIndex	=	req.getParameter("dataIndex");			//	1:일봉, 2:주봉, 3:월봉, 4:년봉, 5:분, 틱
		String	_gap		=	req.getParameter("gap");			//	n분, n틱
		
		req.setCharacterEncoding("utf-8");
		req.setAttribute("1301", req.getParameter("rcod"));
		
		req.setAttribute("count", _count);
		req.setAttribute("dataKind", _dataKind);
		req.setAttribute("dataKey", _dataKey);
		req.setAttribute("date", _date);
		req.setAttribute("unit", _unit);
		req.setAttribute("dataIndex", _dataIndex);
		req.setAttribute("gap", _gap);
		req.setAttribute("lastTickCount", "0");
		req.setAttribute("page", "1");
		
		req.setAttribute("option1", "");
		req.setAttribute("option2", "");
		
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new ChartExecuter(webInterface, "pibochart3").execute();
			//outputResult = new TRExecuter(webInterface, "pibochart1").execute();
			//System.out.println(outputResult);
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	

	@RequestMapping(value = "/trading/data/pibochart4.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView piboChartCall4(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		String	_count	=	req.getParameter("count");
		String	_dummy	=	"";
		String	_dataKind	=	req.getParameter("dataKind");
		String	_dataKey	=	req.getParameter("dataKey");
		String	_date		=	req.getParameter("date");
		String	_unit		=	req.getParameter("unit");			//	1:종목, 2:업종, 3:선물
		String	_dataIndex	=	req.getParameter("dataIndex");			//	1:일봉, 2:주봉, 3:월봉, 4:년봉, 5:분, 틱
		String	_gap		=	req.getParameter("gap");			//	n분, n틱
		
		req.setCharacterEncoding("utf-8");
		req.setAttribute("1301", req.getParameter("rcod"));
		
		req.setAttribute("count", _count);
		req.setAttribute("dataKind", _dataKind);
		req.setAttribute("dataKey", _dataKey);
		req.setAttribute("date", _date);
		req.setAttribute("unit", _unit);
		req.setAttribute("dataIndex", _dataIndex);
		req.setAttribute("gap", _gap);
		req.setAttribute("lastTickCount", "0");
		req.setAttribute("page", "1");
		
		req.setAttribute("option1", "");
		req.setAttribute("option2", "");
		
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new ChartExecuter(webInterface, "pibochart4").execute();
			//outputResult = new TRExecuter(webInterface, "pibochart1").execute();
			//System.out.println(outputResult);
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("list", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	
	
	
}
