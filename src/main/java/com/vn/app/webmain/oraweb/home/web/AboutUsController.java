package com.vn.app.webmain.oraweb.home.web;

import java.awt.FileDialog;
import java.awt.Frame;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileSystemView;

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

import com.vn.app.webmain.oraweb.home.service.JobTitleService;
import com.vn.app.webmain.oraweb.home.service.JobTitleVO;
import com.vn.app.webmain.oraweb.home.service.SearchVO;

import m.config.SystemConfig;
import m.email.JavaEmail;

@Controller
public class AboutUsController {
	
	private static final Logger logger = LoggerFactory.getLogger(AboutUsController.class);
	/*
	@Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	@Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	@Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	*/
	private String USER_AGENT	=	SystemConfig.get("SYSTEM.USER.AGENT");
	private String host			=	SystemConfig.get("SYSTEM.TTL.SERVER.IP");
	private String server		=	SystemConfig.get("SYSTEM.TTL.SERVER");
	
	@Resource(name="jobTitleServiceImpl")
	private JobTitleService jobTitleService;
	
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
	
	@RequestMapping(value = "/home/aboutUs/history.do", method = RequestMethod.GET)
	public String history(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/history" : "/vn_home/aboutUs/history");
	}
	
	@RequestMapping(value = "/home/aboutUs/philosophy.do", method = RequestMethod.GET)
	public String philosophy(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/philosophy" : "/vn_home/aboutUs/philosophy");
	}
	
	@RequestMapping(value = "/home/aboutUs/twentythanniversaryspeech.do", method = RequestMethod.GET)
	public String twentythanniversaryspeech(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/twentythanniversaryspeech" : "/vn_home/aboutUs/twentythanniversaryspeech");
	}
	
	@RequestMapping(value = "/home/aboutUs/whyCore.do", method = RequestMethod.GET)
	public String why_core(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/whyCore" : "/vn_home/aboutUs/whyCore");
	}
	
	@RequestMapping(value = "/home/aboutUs/whyCulture.do", method = RequestMethod.GET)
	public String why_culture(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/whyCulture" : "/vn_home/aboutUs/whyCulture");
	}
	
	@RequestMapping(value = "/home/aboutUs/whyInvestment.do", method = RequestMethod.GET)
	public String why_investment(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/whyInvestment" : "/vn_home/aboutUs/whyInvestment");
	}
	
	@RequestMapping(value = "/home/aboutUs/why.do", method = RequestMethod.GET)
	public String why(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/why" : "/vn_home/aboutUs/why");
	}
	
	@RequestMapping(value = "/home/aboutUs/career.do", method = RequestMethod.GET)
	public String career(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/career" : "/vn_home/aboutUs/career");
	}
	
	@RequestMapping(value = "/home/aboutUs/vacancies.do", method = RequestMethod.GET)
	public String vacancies(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/vacancies" : "/vn_home/aboutUs/vacancies");
	}
	
	@RequestMapping(value = "/home/aboutUs/vacancies.do", method = RequestMethod.POST)
	public ModelAndView vacanciespost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		ModelAndView mav = new ModelAndView();
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("page", req.getParameter("page"));
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/vacancies" : "/vn_home/aboutUs/vacancies"));
		return mav;
	}
	
	@RequestMapping(value = "/home/aboutUs/applyonline.do", method = RequestMethod.GET)
	public String applyonline(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/applyonline" : "/vn_home/aboutUs/applyonline");
	}
	
	@RequestMapping(value = "/home/aboutUs/openaccountonline.do", method = RequestMethod.GET)
	public String openaccountonline(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/openaccountonline" : "/vn_home/aboutUs/openaccountonline");
	}
	
	/* Add Page	2020/08/04 * EKYC */
	@RequestMapping(value = "/home/aboutUs/openaccountonlineekyc.do", method = RequestMethod.GET)
	public String openaccountonlineekyc(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/openaccountonlineekyc" : "/vn_home/aboutUs/openaccountonlineekyc");
	}
	
	/* Add Page	2016/02/28 */

	@RequestMapping(value = "/home/aboutUs/what_trading.do", method = RequestMethod.GET)
	public String what_trading(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		//return "/home/aboutUs/what_trading";
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/what_trading" : "/vn_home/aboutUs/what_trading");
	}
	
	@RequestMapping(value = "/home/aboutUs/what_digitalfinance.do", method = RequestMethod.GET)
	public String what_digitalfinance(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		//return "/home/aboutUs/what_digitalfinance";
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/what_digitalfinance" : "/vn_home/aboutUs/what_digitalfinance");
	}

	@RequestMapping(value = "/home/aboutUs/what_wholesale.do", method = RequestMethod.GET)
	public String what_wholesale(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		//return "/home/aboutUs/what_wholesale";
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/what_wholesale" : "/vn_home/aboutUs/what_wholesale");
	}

	@RequestMapping(value = "/home/aboutUs/what_global.do", method = RequestMethod.GET)
	public String what_global(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		//return "/home/aboutUs/what_global";
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/what_global" : "/vn_home/aboutUs/what_global");
	}
	
	@RequestMapping(value = "/home/aboutUs/what_ivbanking.do", method = RequestMethod.GET)
	public String what_ivbanking(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		//return "/home/aboutUs/what_ivbanking";
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/what_ivbanking" : "/vn_home/aboutUs/what_ivbanking");
	}
	
	@RequestMapping(value = "/home/aboutUs/what_iwc.do", method = RequestMethod.GET)
	public String what_iwc(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		//return "/home/aboutUs/what_iwc";
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/what_iwc" : "/vn_home/aboutUs/what_iwc");
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/home/aboutUs/getAllJobTitle.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getAllJobTitle(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Job Title List Load...");
		//System.out.println(req.getParameter("lang"));
		
		SearchVO searchVO = new SearchVO();
		
		searchVO.setStartDate(req.getParameter("startDate"));
		searchVO.setEndDate(req.getParameter("endDate"));
		searchVO.setPage(req.getParameter("page"));
		
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
		
		List<JobTitleVO> jobtileVO		=	jobTitleService.getAllJobTitle(searchVO);
		List<JobTitleVO> jobtitlecntVO		=	jobTitleService.getJobTitleCnt(searchVO);
		
		JSONObject jObj = new JSONObject();
		
		try{
			JSONArray jArr = new JSONArray();
			for(int i=0; i<jobtileVO.size(); i++){
				
				//Check expire date
				String sLD = jobtileVO.get(i).getLastDate();
				String sTitle = jobtileVO.get(i).getTitle();
				String currDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S").format(new Date());
				
				//System.out.println("### lase date  : " + sLD);
				//System.out.println("### current date  : " + currDate);
				
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				
			    Date date1 = format.parse(sLD);
			    Date date2 = format.parse(currDate);
			    if (date2.compareTo(date1) > 0) {
			        sTitle += " - (Closed)";
			    }
			    
				JSONObject sObj = new JSONObject();
				sObj.put("id", 		jobtileVO.get(i).getId());
				sObj.put("created",	jobtileVO.get(i).getCreated());
				sObj.put("lastdate",jobtileVO.get(i).getLastDate());
				sObj.put("location",jobtileVO.get(i).getLocation());
				sObj.put("title", 	sTitle);
				sObj.put("data", 	jobtileVO.get(i).getData());
				jArr.add(sObj);
				jObj.put("list", jArr);
			}
			jObj.put("listSize", jobtitlecntVO.get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("jsonObj", jObj);
		mav.setViewName("jsonView");
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/home/aboutUs/getJobTitleDetail.do", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView getJobTitleDetail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//System.out.println("Job Title Detail Load...");
		
		String sid = req.getParameter("sid");
		
		JobTitleVO jobTitleVO		=	jobTitleService.getJobTitleDetail(sid);
		
		JSONObject jObj = new JSONObject();
		
		try{
			//Check expire date
			String sLD = jobTitleVO.getLastDate();
			String sTitle = jobTitleVO.getTitle();
			String currDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S").format(new Date());
			
			//System.out.println("### lase date  : " + sLD);
			//System.out.println("### current date  : " + currDate);
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
		    Date date1 = format.parse(sLD);
		    Date date2 = format.parse(currDate);
		    if (date2.compareTo(date1) > 0) {
		        sTitle += " - (Closed)";
		    }
			
			JSONArray jArr = new JSONArray();
			JSONObject sObj = new JSONObject();
			sObj.put("id", 		jobTitleVO.getId());
			sObj.put("created",	jobTitleVO.getCreated());
			sObj.put("lastdate",jobTitleVO.getLastDate());
			sObj.put("location",jobTitleVO.getLocation());
			sObj.put("title", 	sTitle);
			sObj.put("data", 	jobTitleVO.getData());
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
	
	@RequestMapping(value = "/home/aboutUs/jobtitle_view.do", method = RequestMethod.GET)
	public String jobtitle_view(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		String lang = req.getParameter("lang");
		if (lang.equals("vi")) {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "redirect:/home/aboutUs/vacancies.do" : "/vn_home/aboutUs/jobtitle_view");
		} else {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/aboutUs/jobtitle_view" : "redirect:/home/aboutUs/vacancies.do");
		}
	}
	
	@RequestMapping(value = "/home/aboutUs/applyonline.do", method = RequestMethod.POST)
	public ModelAndView miraepost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		ModelAndView mav = new ModelAndView();
		String status = null;
		String emailSubject = "Vacancies";
		String emailBody = "";
		String fileName1 = "";
		String fileName2 = "";
		if (req.getParameter("txtFullName") != null) {
			emailBody = "Full name: " + req.getParameter("txtFullName")
					+ "<br>";
		}
		if (req.getParameter("txtDateofBirth") != null) {
			emailBody = emailBody + "Date of Birth: "
					+ req.getParameter("txtDateofBirth") + "<br>";
		}
		if (req.getParameter("txtEmail") != null) {
			emailBody = emailBody + "Email Address: "
					+ req.getParameter("txtEmail") + "<br>";
		}
		if (req.getParameter("txtDesiredLocation") != null) {
			emailBody = emailBody + "Desired Job: " + req.getParameter("txtDesiredLocation")
					+ "<br>";
		}
		
		if (req.getParameter("slsYearsOfExperience") != null) {
			emailBody = emailBody + "Year Experience: " + req.getParameter("slsYearsOfExperience")
					+ "<br>";
		}
		
		if (req.getParameter("txtSalaryDesiredFinalWorking") != null) {
			emailBody = emailBody + "Salary (Gross): " + req.getParameter("txtSalaryDesiredFinalWorking")
					+ "<br>";
		}
		
		if (req.getParameter("txtCompanyName") != null) {
			emailBody = emailBody + "Company name: " + req.getParameter("txtCompanyName")
					+ "<br>";
		}
		
		if (req.getParameter("txtsWork") != null) {
			emailBody = emailBody + "Job title: " + req.getParameter("txtsWork")
					+ "<br>";
		}
		
		if (req.getParameter("txtMainTasks") != null) {
			emailBody = emailBody + "Main tasks: " + req.getParameter("txtMainTasks")
					+ "<br>";
		}
		
		if (req.getParameter("txtOtherInformation") != null) {
			emailBody = emailBody + "Order infomation: " + req.getParameter("txtOtherInformation")
					+ "<br>";
		}
		
		if (req.getParameter("JobApplication") != null) {
			fileName1 = req.getParameter("JobApplication");
		}
		
		if (req.getParameter("Resumes") != null) {
			fileName2 = req.getParameter("Resumes");
		}
		
		JavaEmail javaEmail = new JavaEmail();
		javaEmail.setMailServerProperties();
		try {
			javaEmail.createVacancyEmailMessage(emailSubject, emailBody, fileName1, fileName2);
			javaEmail.sendEmail();
			status = "success";
		} catch (MessagingException me) {
			status = "error";
		}			
		
		mav.addObject("trResult", status);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping(value = "/home/aboutUs/openaccountonlinepost.do", method = RequestMethod.POST)
	public ModelAndView openaccountonlinepost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {		
		ModelAndView mav = new ModelAndView();
		String status = null;
		String emailSubject = "Open Account Online";
		String emailBody = "";
		String fileName = "";
		String fileContent = "";
		Boolean isValidEmailR = true;
		Boolean isValidPhoneR = true;
		
		emailBody = "THÔNG TIN CƠ BẢN" + "<br><br>";
		if (req.getParameter("txtFullName") != null) {
			emailBody = emailBody + "Họ và tên: " + req.getParameter("txtFullName") + "<br>";
		}
		if (req.getParameter("txtDateofBirth") != null) {
			emailBody = emailBody + "Ngày sinh: " + req.getParameter("txtDateofBirth") + "<br>";
		}
		if (req.getParameter("txtPlaceofBirth") != null) {
			emailBody = emailBody + "Nơi sinh: " + req.getParameter("txtPlaceofBirth") + "<br>";
		}
		if (req.getParameter("txtCMND") != null) {
			emailBody = emailBody + "Số CMND / Hộ chiếu: " + req.getParameter("txtCMND") + "<br>";
		}
		if (req.getParameter("txtDateIssue") != null) {
			emailBody = emailBody + "Ngày cấp: " + req.getParameter("txtDateIssue") + "<br>";
		}
		if (req.getParameter("txtPlaceIssue") != null) {
			emailBody = emailBody + "Nơi cấp: " + req.getParameter("txtPlaceIssue") + "<br>";
		}
		if (req.getParameter("txtPermanentAddress") != null) {
			emailBody = emailBody + "Địa chỉ thường trú: " + req.getParameter("txtPermanentAddress") + "<br>";
		}
		if (req.getParameter("txtCorrespondenceAddress") != null) {
			emailBody = emailBody + "Địa chỉ liên hệ: " + req.getParameter("txtCorrespondenceAddress") + "<br>";
		}
		if (req.getParameter("txtTelephone") != null) {
			emailBody = emailBody + "Số điện thoại: " + req.getParameter("txtTelephone") + "<br>";
		}
		if (req.getParameter("txtEmail") != null) {
			emailBody = emailBody + "Email: " + req.getParameter("txtEmail") + "<br><br>";
		}
		
		emailBody = emailBody + "ĐĂNG KÝ DỊCH VỤ <br><br>"; 
		if (req.getParameter("isWebTrading") != null) {
			emailBody = emailBody + "1. Giao dịch trực tuyến: " + req.getParameter("isWebTrading") + "<br>";
		}
		if (req.getParameter("txtEmailR") != null) {
			 if (validateEmailAddress(req.getParameter("txtEmailR"))) {
				 emailBody = emailBody + "Email: " + req.getParameter("txtEmailR") + "<br>"; 
			 } else {
				 isValidEmailR = false;
			 }
		} else {
			isValidEmailR = false;
		}
		if (req.getParameter("txtPhoneR") != null) {
			if (validateMobileNumber(req.getParameter("txtPhoneR"))) {
				emailBody = emailBody + "SMS: " + req.getParameter("txtPhoneR") + "<br>";
			} else {
				isValidPhoneR = false;
			}
		} else {
			isValidPhoneR = false;
		}
		
		if (req.getParameter("isPhoneTrading") != null) {
			emailBody = emailBody + "2. Giao dịch qua điện thoại: " + req.getParameter("isPhoneTrading") + "<br>";
		}
		if (req.getParameter("txtPassword") != null) {
			emailBody = emailBody + "Mật khẩu (4 số, khác số liên tiếp): Khách hàng tự ghi: " + req.getParameter("txtPassword") + "<br>";
		}
		
		emailBody = emailBody + "3. Nhận thông báo kết quả giao dịch qua SMS <br>";
		
		if (req.getParameter("txtPhoneOrder") != null) {
			emailBody = emailBody + "Số điện thoại đăng ký: " + req.getParameter("txtPhoneOrder") + "<br>";
		}
		
		if (req.getParameter("isAdvance") != null) {
			emailBody = emailBody + "4. Dịch vụ ứng trước tiền bán chứng khoán tự động: " + req.getParameter("isAdvance") + "<br><br>";
		}
		
		emailBody = emailBody + "ĐĂNG KÝ TÀI KHOẢN GIAO DỊCH TIỀN <br><br>";
		emailBody = emailBody + "1. Ngân hàng thứ 1 <br>";
		
		if (req.getParameter("txtBank1Number") != null) {
			emailBody = emailBody + "Số tài khoản: " + req.getParameter("txtBank1Number") + "<br>";
		}
		if (req.getParameter("txtBank1Name") != null) {
			emailBody = emailBody + "Tên tài khoản: " + req.getParameter("txtBank1Name") + "<br>";
		}
		if (req.getParameter("txtBank1Branch") != null) {
			emailBody = emailBody + "Tại ngân hàng: " + req.getParameter("txtBank1Branch") + "<br>";
		}
		emailBody = emailBody + "2. Ngân hàng thứ 2 <br>";
		if (req.getParameter("txtBank2Number") != null) {
			emailBody = emailBody + "Số tài khoản: " + req.getParameter("txtBank2Number") + "<br>";
		}
		if (req.getParameter("txtBank2Name") != null) {
			emailBody = emailBody + "Tên tài khoản: " + req.getParameter("txtBank2Name") + "<br>";
		}
		if (req.getParameter("txtBank2Branch") != null) {
			emailBody = emailBody + "Tại ngân hàng: " + req.getParameter("txtBank2Branch") + "<br>";
		}
		emailBody = emailBody + "3. Ngân hàng thứ 3 <br>";
		if (req.getParameter("txtBank3Number") != null) {
			emailBody = emailBody + "Số tài khoản: " + req.getParameter("txtBank3Number") + "<br>";
		}
		if (req.getParameter("txtBank3Name") != null) {
			emailBody = emailBody + "Tên tài khoản: " + req.getParameter("txtBank3Name") + "<br>";
		}
		if (req.getParameter("txtBank3Branch") != null) {
			emailBody = emailBody + "Tại ngân hàng: " + req.getParameter("txtBank3Branch") + "<br>";
		}
		
		if (req.getParameter("txtCMNDAtt") != null) {
			fileName = req.getParameter("txtCMNDAtt");
		}
		
		if (req.getParameter("txtFileContent") != null) {
			fileContent = req.getParameter("txtFileContent");
		}
		
		if (!isValidEmailR || !isValidPhoneR) {
			mav.addObject("trResult", "error");
			mav.setViewName("jsonView");
			return mav;
		}
		//System.out.println("File CMND path  : " + fileName);
		
		JavaEmail javaEmail = new JavaEmail();
		javaEmail.setMailServerProperties();
		try {
			javaEmail.createOpenOnlineEmailMessage(emailSubject, emailBody, fileName, fileContent);
			javaEmail.sendEmail();
			status = "success";
		} catch (MessagingException me) {
			status = "error";
		}			
		
		mav.addObject("trResult", status);
		mav.setViewName("jsonView");
		return mav;
	}
	
	public Boolean validateEmailAddress(String emailAddress) {
		Pattern regexPattern;
	    Matcher regMatcher;
        //regexPattern = Pattern.compile("^[(a-zA-Z-0-9-\\_\\+\\.)]+@[(a-z-A-z)]+\\.[(a-zA-z)]{2,3}$");
	    regexPattern = Pattern.compile("^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$");
        regMatcher   = regexPattern.matcher(emailAddress);
        if(regMatcher.matches()) {
            return true;
        } else {
            return false;
        }
    }

    public Boolean validateMobileNumber(String mobileNumber) {
    	Pattern regexPattern;
        Matcher regMatcher;
        regexPattern = Pattern.compile("\\d{8,10}");
        regMatcher   = regexPattern.matcher(mobileNumber);
        if(regMatcher.matches()) {
            return true;
        } else {
            return false;
        }
    }
	
	@RequestMapping(value = "/home/aboutUs/selectFileUpload.do", method = RequestMethod.POST)
	public ModelAndView selectFileUpload(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		ModelAndView mav = new ModelAndView();
		
		FileDialog dialog = new FileDialog((Frame)null, "Select File to Open");
		dialog.setDirectory("C:\\");
	    dialog.setMode(FileDialog.LOAD);	    
	    dialog.setAlwaysOnTop(true);
	    dialog.setFocusable(true);
	    dialog.setVisible(true);
	    String path = dialog.getDirectory() + dialog.getFile();
				
		mav.addObject("trPath", path);
		mav.setViewName("jsonView");
		return mav;
		
	}
}
