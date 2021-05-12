package com.vn.app.webmain.mssqlweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.webmain.mssqlweb.home.service.InfoService;
import com.vn.app.webmain.mssqlweb.home.service.InfoVO;
import com.vn.app.webmain.mssqlweb.home.service.SearchVO;

import m.action.TRExecuter;
import m.web.common.WebInterface;
import m.web.common.WebParam;

@Controller
public class InfoController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Resource(name="infoServiceImpl")
	private InfoService InfoService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/info/data/getInfo.do", method={org.springframework.web.bind.annotation.RequestMethod.GET, org.springframework.web.bind.annotation.RequestMethod.POST}, produces={"application/json"})
	@ResponseBody
	public ModelAndView getInfo(HttpServletRequest req, HttpServletResponse res) throws Exception {
		SearchVO	sch	=	new SearchVO();
		ModelAndView mav          = new ModelAndView();
		
		sch.setSchItem(req.getParameter("symb"));
				
	    InfoVO info		=	InfoService.getInfo(sch);
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			JSONObject sObj = new JSONObject();
			sObj.put("symb", 		info.getSymbol());
			sObj.put("marketId",	info.getMarketId());
			sObj.put("name",info.getName());
			sObj.put("nameEN",info.getNameEN());
			sObj.put("mktcap", 	info.getMktCap());
			sObj.put("low52w", 	info.getLow52w());
			sObj.put("high52w", 	info.getHigh52w());
			sObj.put("avg52w", 	info.getAvg52w());
			sObj.put("fbuy", 	info.getFBuy());
			sObj.put("fowned", 	info.getFOwned());
			sObj.put("dividend", 	info.getDividend());
			sObj.put("dividendyield", 	info.getDividendYield());
			sObj.put("beta", 	info.getBeta());
			sObj.put("eps", 	info.getEPS());
			sObj.put("pe", 	info.getPE());
			sObj.put("fpe", 	info.getFPE());
			sObj.put("bvps", 	info.getBVPS());
			sObj.put("pb", 	info.getPB());
			sObj.put("lstshare", 	info.getListShare());
			sObj.put("shareoutstanding", 	info.getShareOutstanding());
			jArr.add(sObj);				
			jObj.put("list", jArr);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/info/data/getPiboInfo.do", method = RequestMethod.GET)
	public ModelAndView getPiboInfo(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piboinfo").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("piboinfo", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/info/data/getPiboInfoCW.do", method = RequestMethod.GET)
	public ModelAndView getPiboInfoCW(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibocw01").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		mav.addObject("pibocw01", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
}
