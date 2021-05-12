package com.vn.app.webmain.oraweb.home.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
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

import com.vn.app.webmain.oraweb.home.service.MarginListService;
import com.vn.app.webmain.oraweb.home.service.MarginListVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

import m.common.tool.tool;
import m.config.SystemConfig;

@Controller
public class SupportController {
	
	private static final Logger logger = LoggerFactory.getLogger(SupportController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	@Resource(name="marginListServiceImpl")
	private MarginListService marginListService;
	
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
	
	@RequestMapping(value = "/downloadFile.do", method = RequestMethod.GET)
    @ResponseBody
    public void downloadFile(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("DOWNLOAD FILE COM CALL");
		String docKind = req.getParameter("ids");
		String lang = req.getParameter("lang");
		
		String fileName = "";
		String location = "doc/";
		if (docKind.equals("1")) {
			fileName = "01LK.doc";
		} else if (docKind.equals("2")) {
			if (lang.equals("en")) {
				fileName = "Mi-trade_user_guide.pdf";
			} else if (lang.equals("vi")) {
				fileName = "Mi-trade_Huong_dan_su_dung.pdf";
			}
		} else if (docKind.equals("3")) {
			if (lang.equals("en")) {
				fileName = "MAS-Published_Risk.pdf";
			} else if (lang.equals("vi")) {
				fileName = "MAS-Ban_cong_bo_Rui_Ro.pdf";
			}
		} else if (docKind.equals("4")) {
			fileName = "";
		} else if (docKind.equals("5")) {
			fileName = "Request.pdf";
		} else if (docKind.equals("6")) {
			fileName = "Account_Individual.pdf";
		} else if (docKind.equals("7")) {
			fileName = "Account_Institutional.pdf";
		} else if (docKind.equals("8")) {
			fileName = "MyAsset.apk";
		} else if (docKind.equals("9")) {
			fileName = "MyAsset-dev.apk";
		} else if (docKind.equals("10")) {
			if (lang.equals("en")) {
				fileName = "User_guide.pdf";
			} else if (lang.equals("vi")) {
				fileName = "Huong_dan_su_dung.pdf";
			}
		} /*else if (docKind.equals("11")) {
			fileName = "";
		} else if (docKind.equals("12")) {
			fileName = "";
		} else if (docKind.equals("13")) {
			fileName = "";
		} else if (docKind.equals("14")) {
			fileName = "";
		} else if (docKind.equals("15")) {
			fileName = "";
		} else if (docKind.equals("16")) {
			fileName = "";
		}*/
		
		if (lang != null) {
			if (lang.equals("en")) {
				location += "en/";
			} else if (lang.equals("vi")) {
				location += "vi/";
			}
		}
		location += fileName;
		
		//System.out.println(location);
		
        ClassLoader classLoader = getClass().getClassLoader();
        File file = new File(classLoader.getResource(location).getFile());
        
        byte[] decoded = FileUtils.readFileToByteArray(file);
        
        res.setContentType("application/x-download");
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
    }
	
	@RequestMapping(value = "/home/support/account.do", method = RequestMethod.GET)
	public String account(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/account" : "/vn_home/support/account");
	}
	
	@RequestMapping(value = "/home/support/wooriAccount.do", method = RequestMethod.GET)
	public String WooriAccount(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/wooriAccount" : "/vn_home/support/wooriAccount");
	}
	
	@RequestMapping(value = "/home/support/cashAdvance.do", method = RequestMethod.GET)
	public String cashAdvance(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/cashAdvance" : "/vn_home/support/cashAdvance");
	}
	
	@RequestMapping(value = "/home/support/cashTransfer.do", method = RequestMethod.GET)
	public String cashTransfer(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/cashTransfer" : "/vn_home/support/cashTransfer");
	}
	
	@RequestMapping(value = "/home/support/depositCash.do", method = RequestMethod.GET)
	public String depositCash(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/depositCash" : "/vn_home/support/depositCash");
	}
	
	@RequestMapping(value = "/home/support/depositStock.do", method = RequestMethod.GET)
	public String depositStock(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/depositStock" : "/vn_home/support/depositStock");
	}
	
	@RequestMapping(value = "/home/support/fee.do", method = RequestMethod.GET)
	public String fee(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/fee" : "/vn_home/support/fee");
	}
	
	@RequestMapping(value = "/home/support/marginGuideline.do", method = RequestMethod.GET)
	public String marginGuideline(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/marginGuideline" : "/vn_home/support/marginGuideline");
	}
	
	@RequestMapping(value = "/home/support/marginList.do", method = RequestMethod.GET)
	public String marginList(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/marginList" : "/vn_home/support/marginList");
	}
	
	@RequestMapping(value = "/home/support/mobile.do", method = RequestMethod.GET)
	public String mobile(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/mobile" : "/vn_home/support/mobile");
	}
	
	@RequestMapping(value = "/home/support/mobile1.do", method = RequestMethod.GET)
	public String mobile1(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/mobile1" : "/vn_home/support/mobile1");
	}
	
	@RequestMapping(value = "/home/support/mobileinstall.do", method = RequestMethod.GET)
	public String mobileinstall(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/mobileinstall" : "/vn_home/support/mobileinstall");
	}
	
	@RequestMapping(value = "/home/support/question.do", method = RequestMethod.GET)
	public String questions(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/question" : "/vn_home/support/question");
	}
	
	@RequestMapping(value = "/home/support/question.do", method = RequestMethod.POST)
	public ModelAndView questionpost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		ModelAndView mav = new ModelAndView();
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("page", req.getParameter("page"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/question" : "/vn_home/support/question"));
		return mav;
	}
	
	@RequestMapping(value = "/home/support/question_view.do", method = RequestMethod.GET)
	public String question_view(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		String lang = req.getParameter("lang");
		if (lang.equals("vi")) {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "redirect:/home/support/question.do" : "/vn_home/support/question_view");
		} else {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/question_view" : "redirect:/home/support/question.do");
		}
	}
	
	@RequestMapping(value = "/home/support/securities.do", method = RequestMethod.GET)
	public String securities(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/securities" : "/vn_home/support/securities");
	}
	
	@RequestMapping(value = "/home/support/sms.do", method = RequestMethod.GET)
	public String sms(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/sms" : "/vn_home/support/sms");
	}
	
	@RequestMapping(value = "/home/support/motp.do", method = RequestMethod.GET)
	public String motp(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/motp" : "/vn_home/support/motp");
	}
	
	@RequestMapping(value = "/home/support/web.do", method = RequestMethod.GET)
	public String web(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/web" : "/vn_home/support/web");
	}
	
	@RequestMapping(value = "/home/support/openaccountguide.do", method = RequestMethod.GET)
	public String openaccountguide(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/openaccountguide" : "/vn_home/support/openaccountguide");
	}
	
	@RequestMapping(value = "/home/support/hometrading.do", method = RequestMethod.GET)
	public String HomeTrading(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/support/hometrading" : "/vn_home/support/hometrading");
	}
	
	@RequestMapping(value = "/marginListDown.do", method = RequestMethod.GET)
    @ResponseBody
    public void marginListDown(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("MARGIN LIST DOWN CALL");
		
		MarginListVO	maginListVO		=	marginListService.getMarginListData(req.getParameter("ids"));
		String	fileData	=	maginListVO.getData();
		String	fileName	=	maginListVO.getName();
		String 	content 	= 	fileData.substring(fileData.indexOf("<Content>"), fileData.indexOf("</Content>"));
		content				=	content.replace("<Content>", "");
		content				=	content.replace("</Content>", "");
		
		byte[] decoded = Base64.decodeBase64(content);
		
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "");
        res.getOutputStream().write(decoded);
        res.flushBuffer();
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/marginListRead.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView marginListRead(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Margin List Load...");
		
		SearchVO searchVO = new SearchVO();
		
		if(req.getParameter("page") != null){
			searchVO.setPage(req.getParameter("page"));
		} else {
			searchVO.setPage("1");
		}
		
		List<MarginListVO> marginVO		=	marginListService.getMarginList(searchVO);
		List<MarginListVO> marginCntVO		=	marginListService.getMarginListCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<marginVO.size(); i++){
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		marginVO.get(i).getId());
				sObj.put("created",	marginVO.get(i).getCreated());
				sObj.put("name", 	marginVO.get(i).getName());
				sObj.put("title", 	marginVO.get(i).getTitle());
				sObj.put("data", 	marginVO.get(i).getData());
				jArr.add(sObj);
				
				jObj.put("list", jArr);
			}
			jObj.put("listSize", marginCntVO.get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@RequestMapping(value = "/home/support/downloadCounter.do", method = RequestMethod.GET)
	public ModelAndView DownloadCounter(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav       = new ModelAndView();		
		//Save Recommend
		HttpSession session 		=	req.getSession();

		String str = "\r\n";	    
	    //String filepath = "/opt/apache-tomcat-8.0.38/webapps/docs/htsdownload/htsdown.txt";	    
	    String filepath = SystemConfig.get("HTSDOWN_PATH");
		//System.out.println("HTSDOWN_PATH");
		//System.out.println(filepath);
		
		File theDir = new File(filepath);

		// if the directory does not exist, create it
		if (!theDir.exists()) {
		    //System.out.println("creating directory: " + theDir.getName());
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
		
		String filepathlocal = "D:/htsdown.txt";
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "htsdown.txt", true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }
	    
	    writer.append("TIME: " + tool.getCurrentFormatedTime() + " - 1 User Downloeded HTS." + " IP: " + getClientIpAddr(req));
	    writer.append(str);
	    writer.close();
		
		mav.addObject("trResult", true);
		mav.setViewName("jsonView");		
		return mav;
	}
}
