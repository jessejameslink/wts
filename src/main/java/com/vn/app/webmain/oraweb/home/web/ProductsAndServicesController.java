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

import com.vn.app.webmain.oraweb.home.service.FundInfoService;
import com.vn.app.webmain.oraweb.home.service.FundInfoVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

import m.config.SystemConfig;

@Controller
public class ProductsAndServicesController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProductsAndServicesController.class);
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
	
	@Resource(name="fundInfoServiceImpl")
	private FundInfoService fundInfoService;
	
	public String getSession(){
		return this.JSESSIONID;
	}
	
	public void setSession(String JSESSIONID){
		this.JSESSIONID = JSESSIONID;
	}
	
	public void setplusSession(String JSESSIONID){
		this.JSESSIONID += JSESSIONID;
	}
	
	@RequestMapping(value = "/home/productsAndServices/individual.do", method = RequestMethod.GET)
	public String individual(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/individual" : "/vn_home/productsAndServices/individual");
	}
	
	@RequestMapping(value = "/home/productsAndServices/institutional.do", method = RequestMethod.GET)
	public String institutional(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/institutional" : "/vn_home/productsAndServices/institutional");
	}
	
	@RequestMapping(value = "/home/productsAndServices/investment.do", method = RequestMethod.GET)
	public String investment(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/investment" : "/vn_home/productsAndServices/investment");
	}
	
	@RequestMapping(value = "/home/productsAndServices/wealth.do", method = RequestMethod.GET)
	public String wealth(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/wealth" : "/vn_home/productsAndServices/wealth");
	}
	
	/*
	 * Open fund : START
	 */
	@RequestMapping(value = "/home/productsAndServices/ofIntroduction.do", method = RequestMethod.GET)
	public String ofIntroduction(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/ofIntroduction" : "/vn_home/productsAndServices/ofIntroduction");
	}
	
	@RequestMapping(value = "/home/productsAndServices/ofInvesInstruction.do", method = RequestMethod.GET)
	public String ofInvesInstruction(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/ofInvesInstruction" : "/vn_home/productsAndServices/ofInvesInstruction");
	}
	
	@RequestMapping(value = "/home/productsAndServices/ofInfoDisclosures.do", method = RequestMethod.GET)
	public String ofInfoDisclosures(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/ofInfoDisclosures" : "/vn_home/productsAndServices/ofInfoDisclosures");
	}
	
	///////////////////////////////////////
	@RequestMapping(value = "/home/productsAndServices/ofInfoDisclosures.do", method = RequestMethod.POST)
	public ModelAndView ofInfoDisclosuresPost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		ModelAndView mav = new ModelAndView();
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("page", req.getParameter("page"));
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/ofInfoDisclosures" : "/vn_home/productsAndServices/ofInfoDisclosures"));
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/home/productsAndServices/getAllFundInfo.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getAllFundInfo(HttpServletRequest req, HttpServletResponse res) throws Exception {
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
		
		List<FundInfoVO> fundinfoVO		=	fundInfoService.getAllFundInfo(searchVO);
		List<FundInfoVO> investorCntVO		=	fundInfoService.getFundInfoCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<fundinfoVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		fundinfoVO.get(i).getId());
				sObj.put("created",	fundinfoVO.get(i).getCreated());
				sObj.put("title", 	fundinfoVO.get(i).getTitle());
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
	@RequestMapping(value = "/home/productsAndServices/getFundInfoDetail.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getFundInfoDetail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String sid = req.getParameter("sid");		
		FundInfoVO fundinfoVO		=	fundInfoService.getFundInfoDetail(sid);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			JSONObject sObj = new JSONObject();
			sObj.put("id", 		fundinfoVO.getId());
			sObj.put("created",	fundinfoVO.getCreated());
			sObj.put("title", 	fundinfoVO.getTitle());
			sObj.put("data", 	fundinfoVO.getData());
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
	
	@RequestMapping(value = "/home/productsAndServices/ofInfoDisclosures_view.do", method = RequestMethod.GET)
	public String investor_view(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();		
		String lang = req.getParameter("lang");		
		if (lang.equals("vi")) {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "redirect:/home/productsAndServices/ofInfoDisclosures.do" : "/vn_home/productsAndServices/ofInfoDisclosures_view");
		} else {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/productsAndServices/ofInfoDisclosures_view" : "redirect:/home/productsAndServices/ofInfoDisclosures.do");
		}
	}
	
	@RequestMapping(value = "/fundInfoDown.do", method = RequestMethod.GET)
    @ResponseBody
    public void fundInfoDown(HttpServletRequest req, HttpServletResponse res) throws Exception {		
		FundInfoVO	fundinfoVO		=	fundInfoService.getFundInfoDetail(req.getParameter("ids"));
		String	fileData	=	fundinfoVO.getData();
		String	fileName	=	fundinfoVO.getFileName();
		String 	content 	= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content				=	content.replace("<Content>", "");
		content				=	content.replace("</Content>", "");
		
		byte[] decoded = Base64.decodeBase64(content);
		
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
    }
	/*
	 * Open fund : END
	 */
}
