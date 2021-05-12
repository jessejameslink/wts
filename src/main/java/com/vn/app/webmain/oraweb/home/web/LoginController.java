package com.vn.app.webmain.oraweb.home.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.lang.management.ManagementFactory;
import java.util.Date;
import java.util.Locale;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.management.AttributeNotFoundException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanException;
import javax.management.MBeanServer;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.ReflectionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.vn.app.commons.VNSend;
import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oranews.home.service.HomeVO2;
import com.vn.app.webmain.oraweb.home.service.HomeService;
import com.vn.app.webmain.oraweb.home.service.HomeVO;

import m.action.TRExecuter;
import m.common.tool.tool;
import m.config.SystemConfig;
import m.email.JavaEmail;
import m.web.common.WebInterface;
import m.web.common.WebParam;




@Controller
public class LoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
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

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/login/login.do", method = RequestMethod.POST, produces={"application/json"})
	public ModelAndView login(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
//		String filepath = "/opt/apache-tomcat-8.0.38/webapps/docs/logindata/logindata.txt";
		String filepath = SystemConfig.get("LOGINDATA_PATH");
					
		//System.out.println("LOGINDATA_PATH  logindata");
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
		
		String filepathlocal = "D:/logindata.txt";
		
		String loginUrl = server + "login";
		
		JSONObject jsonData = new JSONObject();
		jsonData.put("mvClientID", req.getParameter("mvClientID").trim());
		jsonData.put("mvPassword", req.getParameter("mvPassword"));
		jsonData.put("securitycode", req.getParameter("securitycode").trim());
		
		String ip = getClientIpAddr(req);
		
		HttpSession session = req.getSession();
		
		if(session.getAttribute("ClientV") != null && "".equals(session.getAttribute("ClientV"))) {
			session.invalidate();
		}
		
		setSession("");
		JSONObject arr = sendPostlogin(loginUrl, jsonData, ip, req.getParameter("mvClientID"));
		
		//System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
		//System.out.println(arr);
		//System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
		
		//write data to login log file
		String  browserDetails  =   req.getHeader("User-Agent");
        String  userAgent       =   browserDetails;
        String os = "";
        if (userAgent.toLowerCase().indexOf("windows") >= 0 ) {
            os = "Windows";
        } else if(userAgent.toLowerCase().indexOf("mac") >= 0) {
            os = "Mac";
        } else if(userAgent.toLowerCase().indexOf("x11") >= 0) {
            os = "Unix";
        } else if(userAgent.toLowerCase().indexOf("android") >= 0) {
            os = "Android";
        } else if(userAgent.toLowerCase().indexOf("iphone") >= 0) {
            os = "IPhone";
        }else{
            os = "UnKnown, More-Info: "+userAgent;
        }
		String str = "\r\n";

		
		BufferedWriter writer;
	    try {
	    	writer = new BufferedWriter(new FileWriter(filepath + "logindata.txt" , true));
	    } catch (Exception e) {
	    	writer = new BufferedWriter(new FileWriter(filepathlocal, true));
	    }
	    writer.append("[IN] " + tool.getCurrentFormatedTime() + " ");
	    writer.append(req.getParameter("mvClientID").trim() + " OS: " + os + " IP Address: " + ip);
	    writer.append(str);
	    writer.append("[OUT] " + tool.getCurrentFormatedTime() + " " + req.getParameter("mvClientID") + " ");
	    writer.append(arr.toJSONString());
	    
	    writer.append(str);
	    writer.close();
	    
		
		if((Boolean) arr.get("success")){			
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>> Session OK <<<<<<<<<<<<<<<<<<<<<<" + arr.get("success"));
			JSONObject mainResult = (JSONObject) arr.get("mainResult");
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>> Main Result <<<<<<<<<<<<<<<<<<<<<<" + mainResult);
			JSONObject login = (JSONObject) mainResult.get("login");
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>> Login <<<<<<<<<<<<<<<<<<<<<<" + login);
			JSONArray subAccount = (JSONArray) mainResult.get("subAccount");
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>> Sub Account <<<<<<<<<<<<<<<<<<<<<<" + subAccount);
			JSONObject subAccount0 = (JSONObject)(subAccount.get(0));
			
			//parse def subaccount
			
			try {
                for (int i = 0; i < subAccount.size(); i++) {
                	JSONObject jsonObj = (JSONObject)(subAccount.get(i));   
                	
                    if ((Boolean)jsonObj.get("defaultSubAccount")) {
                    	session.setAttribute("defaultSubAccount", jsonObj.get("tradingAccSeq"));
                    	session.setAttribute("subAccountID", jsonObj.get("subAccountID"));
                    	session.setAttribute("tradingAccSeq", jsonObj.get("tradingAccSeq"));
                    	session.setAttribute("popupversion6", jsonObj.get("subAccountID"));
                    	break;
                    }
                    else{
                    	session.setAttribute("defaultSubAccount", jsonObj.get("tradingAccSeq"));
                    	session.setAttribute("subAccountID", jsonObj.get("subAccountID"));
                    	session.setAttribute("tradingAccSeq", jsonObj.get("tradingAccSeq"));
                    	session.setAttribute("popupversion6", jsonObj.get("subAccountID"));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
			// end parse def subaccount
			
			
			session.setAttribute("ClientV", login.get("loginID"));
			session.setAttribute("ClientName", login.get("name"));
			session.setAttribute("clientID", login.get("loginID"));
			
			//session.setAttribute("subAccountID", subAccount0.get("subAccountID"));			
			//session.setAttribute("tradingAccSeq", subAccount0.get("tradingAccSeq"));
			
			session.setAttribute("login", "login");
			session.setAttribute("recom", "recom");
			session.setAttribute("ttlJsession", getSession());
			
			String	retrieve 	= 	server + "auth/eqt/retrieveClientAuthen";
			VNSend  vn   	= 	new VNSend();
			JSONObject jsonDataR = new JSONObject();
			jsonDataR.put("clientID", req.getParameter("mvClientID"));
			JSONObject	retObj = vn.SendPostNew(retrieve, jsonDataR, req);
			
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>> retrieveClientAuthen code <<<<<<<<<<<<<<<<<<<<<<"+retObj.get("errorCode")+ req.getParameter("mvClientID"));
			JSONObject objR		=	(JSONObject) retObj.get("clientAuthen");
			String authenMethod = (String)objR.get("authenMethod");
			if (authenMethod.indexOf("HW OTP") >=0) {
				session.setAttribute("authenMethod", "hwotp");
			} else if (authenMethod.indexOf("SW OTP") >= 0) {
				session.setAttribute("authenMethod", "swotp");
			} else {
				session.setAttribute("authenMethod", "matrix");
			}
			
		}else{
			ModelAndView mav= new ModelAndView();
		    mav.addObject("jsonObj", arr);
		    mav.setViewName("jsonView");
		    return mav;
		}
		
		
		ModelAndView mav= new ModelAndView();
	    mav.addObject("jsonObj", arr);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/login/logout.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView logout(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String logoutUrl	=	server + "logout";
		HttpSession session = req.getSession();
		JSONObject jsonData = new JSONObject();
		ModelAndView mav= new ModelAndView();
			
		try {
			jsonData.put("loginID", session.getAttribute("ClientV").toString());
			
		} catch (Exception e) {
			session.invalidate();
			setSession("");
		    mav.setViewName("/logout");
		    return mav;
		}
		JSONObject arr = sendPostlogin(logoutUrl, jsonData, "", "");		
		session.invalidate();
		setSession("");
	    mav.addObject("jsonObj", arr);
	    mav.setViewName("/logout");
	    return mav;
	}
	
	private JSONObject sendPostlogin(String url, JSONObject jsonData, String ip, String sClientID) throws Exception {
		httpClient = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		// add header
		post.setHeader("Host", host);
		post.setHeader("User-Agent", USER_AGENT);
		post.setHeader("Origin", "*");
		post.setHeader("Accept", "application/json");
		post.setHeader("Accept-Language", "en-US,en;q=0.5");		
		post.setHeader("Connection", "keep-alive");
		post.setHeader("X-Forwarded-For", ip);
		post.setHeader("Content-Type", "application/json");
		
		StringEntity params = new StringEntity(jsonData.toString());
		params.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
		post.setEntity(params);
		HttpResponse response = httpClient.execute(post);
		int responseCode = response.getStatusLine().getStatusCode();
		
		//Get client ID
		
		String allSessionID = "";
		setSession("");
		for (Header header : response.getAllHeaders()) {
			if("Set-Cookie".equals(header.getName())){
				allSessionID += header.getValue();
				//setplusSession(header.getValue());
			}
		}
		setSession(allSessionID);
		
		allSessionID = getSession();
		String[] arrSession = allSessionID.split("JSESSIONID");
		//System.out.println("Number of Session : " + arrSession.length);
		if (arrSession.length > 2) {
			setSession("");
			for (int i = 1; i < arrSession.length; i++) {
				if (arrSession[i].indexOf(sClientID) >= 0) {
					setSession("JSESSIONID" + arrSession[i]);
					break;
				}
			}
		}

		BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
		StringBuffer result = new StringBuffer();
		String line = "";
		while ((line = rd.readLine()) != null) {
			result.append(line);
		}
		rd.close();
		//System.out.println(result.toString().replaceAll( "<!--", "" ));
		
		//System.out.println("###########################1");
		
		//JSONObject jsonObject = (JSONObject) JSONValue.parse(result.toString());
		//System.out.println(JSONValue.parse(result.toString()));
		JSONObject jsonObject = (JSONObject) JSONValue.parse(result.toString());
		//System.out.println("###########################2");
		//return result.toString().replaceAll( "<!--", "" ) ;
		
		return jsonObject;
	}
	
	@RequestMapping(value = "/login/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		HomeVO homeVO = homeService.getDBTime();
		HomeVO2 homeVO2 = homeService2.getDBTime2();
		model.addAttribute("serverTime", homeVO.getTimeStr() );
		model.addAttribute("serverTime2", homeVO2.getTimeStr() );
		return "home";
	}
	
	/*
	 * http://blog.naver.com/tlsdlf5/220691369780	ũ�ν� ������, �ٱ��� ���� Example
	 */
	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	public String login(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		logger.info("Welcome home! The client locale is {}.", locale);
		HttpSession session 		=	req.getSession();
		String lang = (String)session.getAttribute("LanguageCookie");
		if (lang == "" || lang == null) {
			return "prelogin";
		} else {
			Date nTime = new Date();
			long tt = nTime.getTime();
		    
			String chkpath		= SystemConfig.get("ABSOLUTE_PATH");
			//System.out.println("CHK PATH==>" + chkpath);
			
			//System.out.println("@@LOCAL ADDR1=>" + req.getLocalAddr());
			//System.out.println("@@LOCAL ADDR2=>" + req.getContextPath());
			//System.out.println("@@LOCAL ADDR3=>" + req.getRequestURI());
			//System.out.println("@@LOCAL ADDR4=>" + req.getHeader("referer"));
			
			String old_url	=	"";
			
			if(null != req.getParameter("redirect")) {
				old_url	=	req.getParameter("redirect");
			} else {
				old_url = 	req.getHeader("referer");
			}
			model.addAttribute("ttl", server);
			model.addAttribute("key",  String.valueOf(tt));
			model.addAttribute("old_url", old_url);
			return "login";
		}
	}
	
	@RequestMapping(value = "/login/setLanguageDefault.do", method = RequestMethod.GET)
	public ModelAndView SetLanguageDefault(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		ModelAndView mav       = new ModelAndView();		
		//Set default language
		HttpSession session 		=	req.getSession();
		session.setAttribute("LanguageCookie", req.getParameter("mvCurrentLanguage"));
		mav.addObject("trResult", true);
		mav.setViewName("jsonView");		
		return mav;
	}
	
	@RequestMapping(value = "/data/gettime.do", method = RequestMethod.GET, produces={"application/json"})
	public ModelAndView get(Locale locale, ModelMap model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav= new ModelAndView();
		Date nTime = new Date();
	    long tt = nTime.getTime();
		mav.addObject("rtdate", tt);
	    mav.setViewName("jsonView");
	    return mav;
	}
	
	
	@RequestMapping(value = "/loginpop.do", method = RequestMethod.GET)
	public String loginpop(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
		logger.info("Welcome home! The client locale is {}.", locale);
		Date nTime = new Date();
		long tt = nTime.getTime();
		String chkpath		= SystemConfig.get("ABSOLUTE_PATH");
		String old_url	=	"";
		
		if(null != req.getParameter("redirect")) {
			old_url	=	req.getParameter("redirect");
		} else {
			old_url = 	req.getHeader("referer");
		}
		model.addAttribute("ttl", server);
		model.addAttribute("key",  String.valueOf(tt));
		model.addAttribute("old_url", old_url);
		
		return "/popup/loginPopup";
	}
	
	@RequestMapping(value = "/login/popup/forgetPassword.do", method = RequestMethod.POST)
	public ModelAndView ForgetPassword(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav = new ModelAndView();
		mav.addObject("newsDivId", req.getParameter("divId"));
		mav.setViewName("/popup/forgetPassword");		
		return mav;
	}
	
	@RequestMapping(value = "/login/resetPassword.do", method = RequestMethod.GET)
	public ModelAndView resetPassword(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		ModelAndView mav       = new ModelAndView();
		String emailSubject = req.getParameter("mvEmailSubject");
		String emailBody  = req.getParameter("mvEmailBody");
		String emailTo  = req.getParameter("mvEmailTo");		
		String status = null;
		
		JavaEmail javaEmail = new JavaEmail();
		javaEmail.setMailServerProperties();
		try {
			javaEmail.createResetPwdEmailMessage(emailSubject, emailBody, emailTo);
			javaEmail.sendEmail();
			status = "success";
		} catch (MessagingException me) {
			status = "error";
		}			
		
		mav.addObject("trResult", status);
		mav.setViewName("jsonView");		
		return mav;
	}
	
	@RequestMapping(value = "/login/getClientIPAddress.do", method = RequestMethod.GET)
	public ModelAndView getClientIPAddress(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav       = new ModelAndView();		
		String ip = "";					
		ip = getClientIpAddr(req);
		mav.addObject("trResult", ip);
		mav.setViewName("jsonView");		
		return mav;
	}
	
	@RequestMapping(value = "/login/saveResetPwdHis.do", method = RequestMethod.GET)
	public ModelAndView saveResetPwdHis(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		ModelAndView mav          = new ModelAndView();
		
		try {
			outputResult = new TRExecuter(webInterface, "piborspw").execute();
		} catch(Throwable e) {
			e.printStackTrace();
			mav.addObject("trResult", "error");
			mav.addObject("trMsg", e.getMessage());
			return mav;
		}
		
		logger.info(outputResult.toJSONString());
		mav.addObject("trResult", outputResult);
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@RequestMapping(value = "/login/activeSession.do", method = RequestMethod.GET)
	public ModelAndView activeSession(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException, AttributeNotFoundException, InstanceNotFoundException, MBeanException, ReflectionException {		
		ModelAndView mav       = new ModelAndView();		
		int status = 0;
		
		MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
		ObjectName objectName;
		try {
			objectName = new ObjectName("Catalina:type=Manager,context=/,host=localhost");
			status = (Integer) mBeanServer.getAttribute(objectName, "activeSessions");
		} catch (MalformedObjectNameException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
					
		
		mav.addObject("trResult", status);
		mav.setViewName("jsonView");		
		return mav;
	}
	
	
	public String wLoginLog(String clientID, String info, String rsl, String lRet, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		req.setCharacterEncoding("utf-8");
		req.setAttribute("usid", clientID);
		req.setAttribute("info", info);
		req.setAttribute("rsl", rsl);
		req.setAttribute("error", lRet);
		
		WebInterface webInterface = new WebParam(req, res);
		JSONObject outputResult   = new JSONObject();
		
		
		try {
			outputResult = new TRExecuter(webInterface, "pibolgon").execute();
		} catch(Throwable e) {
			e.printStackTrace();			
		}
		
		logger.info(outputResult.toJSONString());
		return (String)outputResult.get("rcod");
	}
}
