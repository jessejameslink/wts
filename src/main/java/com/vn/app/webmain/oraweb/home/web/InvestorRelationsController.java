package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
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

import com.vn.app.webmain.oraweb.home.service.InvestorService;
import com.vn.app.webmain.oraweb.home.service.InvestorVO;
import com.vn.app.webmain.oraweb.home.service.MiraeAssetNewsVO;
import com.vn.app.webmain.oraweb.home.service.ResearchVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

import m.config.SystemConfig;

@Controller
public class InvestorRelationsController {
	
	private static final Logger logger = LoggerFactory.getLogger(InvestorRelationsController.class);
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
	
	@Resource(name="investorServiceImpl")
	private InvestorService investorService;
	
	public String getSession(){
		return this.JSESSIONID;
	}
	
	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}
	
	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}
	
	@RequestMapping(value = "/home/investorRelations/company.do", method = RequestMethod.GET)
	public String company(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/investorRelations/company" : "/vn_home/investorRelations/company");
	}
	
	@RequestMapping(value = "/home/investorRelations/financial.do", method = RequestMethod.GET)
	public String financial(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/investorRelations/financial" : "/vn_home/investorRelations/financial");
	}
	
	@RequestMapping(value = "/home/investorRelations/information.do", method = RequestMethod.GET)
	public String information(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/investorRelations/information" : "/vn_home/investorRelations/information");
	}
	
	@RequestMapping(value = "/home/investorRelations/information.do", method = RequestMethod.POST)
	public ModelAndView informationpost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		ModelAndView mav = new ModelAndView();
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("page", req.getParameter("page"));
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/investorRelations/information" : "/vn_home/investorRelations/information"));
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/home/investorRelations/getAllInvestor.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getAllInvestor(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Investor List Load...");
		//System.out.println(req.getParameter("lang"));
		
		SearchVO searchVO = new SearchVO();
		
		searchVO.setStartDate(req.getParameter("startDate"));
		searchVO.setEndDate(req.getParameter("endDate"));
		searchVO.setPage(req.getParameter("page"));
		searchVO.setType(req.getParameter("nType"));
		
		if(req.getParameter("lang") != null){
			searchVO.setLang(req.getParameter("lang"));
		} else {
			searchVO.setLang("vi_VN");
		}
		
		if(req.getParameter("page") != null){
			searchVO.setPage(req.getParameter("page"));
		} else {
			searchVO.setPage("1");
		}
		
		//System.out.println("### startDate : " + searchVO.getStartDate());
		//System.out.println("### endDate  : " + searchVO.getEndDate());
		
		List<InvestorVO> investorVO		=	investorService.getAllInvestor(searchVO);
		List<InvestorVO> investorCntVO		=	investorService.getInvestorCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<investorVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		investorVO.get(i).getId());
				sObj.put("created",	investorVO.get(i).getCreated());
				sObj.put("docsize", investorVO.get(i).getDocSize());
				sObj.put("title", 	investorVO.get(i).getTitle());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
			jObj.put("listSize", investorCntVO.get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/home/investorRelations/getInvestorDetail.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getInvestorDetail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Investor Detail Load...");
		
		String sid = req.getParameter("sid");
		
		InvestorVO investorVO		=	investorService.getInvestorDetail(sid);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			JSONObject sObj = new JSONObject();
			sObj.put("id", 		investorVO.getId());
			sObj.put("created",	investorVO.getCreated());
			sObj.put("title", 	investorVO.getTitle());
			sObj.put("data", 	investorVO.getData());
			jArr.add(sObj);				
			jObj.put("list", jArr);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@RequestMapping(value = "/home/investorRelations/information_view.do", method = RequestMethod.GET)
	public String investor_view(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();		
		String lang = req.getParameter("lang");		
		if (lang.equals("vi")) {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "redirect:/home/investorRelations/information.do" : "/vn_home/investorRelations/information_view");
		} else {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/investorRelations/information_view" : "redirect:/home/investorRelations/information.do");
		}
	}
	
	@RequestMapping(value = "/investorDown.do", method = RequestMethod.GET)
    @ResponseBody
    public void investorDown(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("INVESTOR FILE DOWN CALL");
		
		InvestorVO	investorVO		=	investorService.getInvestorDetail(req.getParameter("ids"));
		String	fileData	=	investorVO.getData();
		String	fileName	=	investorVO.getFileName();
		String 	content 	= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content				=	content.replace("<Content>", "");
		content				=	content.replace("</Content>", "");
		
		byte[] decoded = Base64.decodeBase64(content);
		
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
    }
}
