package com.vn.app.webmain.oraweb.home.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.NameValuePair;
//import org.apache.http.client.HttpClient;
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
import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;
import com.vn.app.webmain.oraweb.home.service.HomeVO;
import com.vn.app.webmain.oraweb.home.service.ResearchService;

import m.action.TRExecuter;
import m.config.SystemConfig;
import m.web.common.WebInterface;
import m.web.common.WebParam;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
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
	
	@Resource(name="researchServiceImpl")
	private ResearchService researchService;
	
	/*	HOME ACTION Define	*/
	/*
	 *	HOME PAGE init Connect Page 
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/home.do", method = RequestMethod.GET)
	public String homeChk(Locale locale, Model model) throws IOException {
		HomeVO homeVO = homeService.getDBTime();
		String	serverPath	=	SystemConfig.get("FILE_DOWN");
		String	downPath	=	"";
		model.addAttribute("serverTime", homeVO.getTimeStr() );
		return "home";
	}
	/*
	@RequestMapping(value = "/researchDown.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView ResearchDown(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		ResearchVO	researchVO		=	researchService.getResearchData();
		ModelAndView mav			=	new ModelAndView();
		
		String	fileData	=	researchVO.getData();
		String	fileName	=	researchVO.getName();
		String	serverPath	=	SystemConfig.get("FILE_DOWN");
		String	downPath	=	"";
		String 	content 	= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content				=	content.replace("<Content>", "");
		content				=	content.replace("</Content>", "");
		DecodeFileUtil	deFile	=	new DecodeFileUtil();
		
		downPath			=	serverPath	+fileName;
		deFile.decodeStringtoFile(content, downPath);
				
		byte[] decoded = Base64.decodeBase64(content);
		//File file = new File(outputFileName);;
		//FileOutputStream fop = new FileOutputStream(file);
		//fop.write(decoded);
		
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
		
		mav.addObject("pdfCon", content);
		mav.addObject("downPath", downPath);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		
		return mav;
	}
	*/
	/*
	@RequestMapping(value = "/researchDown2.do", method = RequestMethod.GET)
    @ResponseBody
    public void researchDown2(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("RESEARCH FILE DOWN CALL");
		String ids	=	req.getParameter("ids");
		
		ResearchVO	researchVO		=	researchService.getResearchData(ids);
		String	fileData	=	researchVO.getData();
		String	fileName	=	researchVO.getName();
		String	serverPath	=	SystemConfig.get("FILE_DOWN");
		String	downPath	=	"";
		String 	content 	= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content				=	content.replace("<Content>", "");
		content				=	content.replace("</Content>", "");
		DecodeFileUtil	deFile	=	new DecodeFileUtil();
		
		byte[] decoded = Base64.decodeBase64(content);
		
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
        
    }
	*/
	@RequestMapping(value = "/home/include/header.do", method = RequestMethod.GET)
	public String HomeHeader(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String rtPage	=	"/US/home/include/home_header";
		//	챘짤�씳モ�걔늘ぢ닳궗챘혻짢 챙짼�쑦ヂ┑�챘째占� 챘징흹챗쨌쨍챙占승� 챙짼�쑦ヂ┑� 챙짼쨈챠占승�
		//	Cookie or Session 챙�뷂옙챙�왙� 챙�벬맡р�벬� 챙�쑣돤р�┡� 챗째�궗챙혻쨍챙�꽓�궗 챘짝짭챠�왖� 챠탐�쑦э옙쨈챙짠�궗 챘쨀�궗챗짼쩍챗째�궗챘힋짜챠�▦쑦ワ옙�왗ヂ∽옙 챠�◈늘р�◈셌��◈�
		return rtPage;
	}
	
	@RequestMapping(value = "/home/include/footer.do", method = RequestMethod.GET)
	public String HomeFooter(Locale locale, Model model) {
		String rtPage	=	"/US/home/include/home_footer";
		//	챘짤�씳モ�걔늘ぢ닳궗챘혻짢 챙짼�쑦ヂ┑�챘째占� 챘징흹챗쨌쨍챙占승� 챙짼�쑦ヂ┑� 챙짼쨈챠占승�
		//	Cookie or Session 챙�뷂옙챙�왙� 챙�벬맡р�벬� 챙�쑣돤р�┡� 챗째�궗챙혻쨍챙�꽓�궗 챘짝짭챠�왖� 챠탐�쑦э옙쨈챙짠�궗 챘쨀�궗챗짼쩍챗째�궗챘힋짜챠�▦쑦ワ옙�왗ヂ∽옙 챠�◈늘р�◈셌��◈�
		return rtPage;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/home/changelanguage.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView ChangeLanguage(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		ModelAndView mav			=	new ModelAndView();
		HttpSession session 		=	req.getSession();
		VNSend	vn					=	new VNSend();
		
		String loginUrl = server + "changelanguage";
		JSONObject jsonData = new JSONObject();
		jsonData.put("mvCurrentLanguage", req.getParameter("mvCurrentLanguage"));
		
		if(session.getAttribute("ttlJsession") != null){
			outputResult	=	 vn.SendPostNew(loginUrl, jsonData,req);
		}
		
		session.setAttribute("LanguageCookie", req.getParameter("mvCurrentLanguage"));
		session.setAttribute("TAB_IDX1", req.getParameter("TAB_IDX1"));
		session.setAttribute("TAB_IDX2", req.getParameter("TAB_IDX2"));
		session.setAttribute("TAB_IDX3", req.getParameter("TAB_IDX3"));
		Cookie cookie	=	new Cookie("LanguageCookie", req.getParameter("mvCurrentLanguage"));
		cookie.setMaxAge(60*10);								//Cookie setting Time 10 minute
		res.addCookie(cookie);
		mav.addObject("ttl", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/data/getClientDetail.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView ClientInfo(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		ModelAndView mav			=	new ModelAndView();
		HttpSession session 		=	req.getSession();
		VNSend	vn					=	new VNSend();
		
		String url = server + "getclientdetail.action";
		Date nTime = new Date();
		long tt = nTime.getTime();
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		paramList.add(new BasicNameValuePair("mvClientId",  (String) session.getAttribute("ClientV")));
		paramList.add(new BasicNameValuePair("key",  String.valueOf(tt)));
		outputResult	=	vn.SendPost(url, paramList,req);
		
		mav.addObject("ttl", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/data/getQueryAccountSummary.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView QueryAccountSummary(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		JSONObject outputResult		=	new JSONObject();
		ModelAndView mav			=	new ModelAndView();
		VNSend	vn					=	new VNSend();
		
		String url = server + "queryAccountSummary.action";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		outputResult	=	 vn.SendPost(url, paramList,req);
		
		mav.addObject("ttl", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	
	@RequestMapping(value = "/home/homeJisu.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView HomeJisu(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult		=	new JSONObject();
		ModelAndView mav			=	new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibohidx").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		mav.addObject("homejisu", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/home/homeNews.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView HomeNews(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult		=	new JSONObject();
		ModelAndView mav			=	new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "pibotitl").execute();
		} catch(Throwable e) {
			logger.info("~~~~~~~~~~~#ERROR#~~~~~~~~~~");
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		logger.info(outputResult.toJSONString());
		mav.addObject("homenews", outputResult);
		mav.addObject("trResult", "success");
		mav.addObject("trMsg", "success");
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/common/popup/authConfirm.do", method = RequestMethod.POST)
	public String AuthConfirm(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/popup/authConfirm";
	}
	
	@RequestMapping(value = "/common/popup/otpConfirm.do", method = RequestMethod.POST)
	public String OtpConfirm(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		return "/popup/otpConfirm";
	}
	
	@RequestMapping(value = "/home/setLanguageCookie.do", method = RequestMethod.GET)
	public ModelAndView setLanguageCookie(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		ModelAndView mav       = new ModelAndView();		
		//Set default language
		HttpSession session 		=	req.getSession();
		session.setAttribute("LanguageCookie", req.getParameter("mvCurrentLanguage"));
		mav.addObject("trResult", true);
		mav.setViewName("jsonView");		
		return mav;
	}
}
