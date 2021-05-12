package com.vn.app.webmain.oraweb.home.web;

import java.io.UnsupportedEncodingException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import m.config.SystemConfig;

@Controller
public class NewsAndEventsController {
	
	private static final Logger logger = LoggerFactory.getLogger(NewsAndEventsController.class);
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
	
	@RequestMapping(value = "/home/newsAndEvents/events.do", method = RequestMethod.GET)
	public String events(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/events" : "/vn_home/newsAndEvents/events");
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market.do", method = RequestMethod.GET)
	public String market(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market" : "/vn_home/newsAndEvents/market");
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_hose.do", method = RequestMethod.GET)
	public String market_hose(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_hose" : "/vn_home/newsAndEvents/market_hose");
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_upcom.do", method = RequestMethod.GET)
	public String market_upcom(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_upcom" : "/vn_home/newsAndEvents/market_upcom");
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_hnx.do", method = RequestMethod.GET)
	public String market_hnx(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_hnx" : "/vn_home/newsAndEvents/market_hnx");
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_vsd.do", method = RequestMethod.GET)
	public String market_vsd(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		logger.info("Welcome home! The client locale is {}.", locale);
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_vsd" : "/vn_home/newsAndEvents/market_vsd");
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_hnx.do", method = RequestMethod.POST)
	public ModelAndView market_hnx_post(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();

		ModelAndView mav = new ModelAndView();
		
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.addObject("trPage", req.getParameter("trPage"));
		
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_hnx" : "/vn_home/newsAndEvents/market_hnx"));
		return mav;
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_hose.do", method = RequestMethod.POST)
	public ModelAndView market_hose_post(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();

		ModelAndView mav = new ModelAndView();
		
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.addObject("trPage", req.getParameter("trPage"));
		
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_hose" : "/vn_home/newsAndEvents/market_hose"));
		return mav;
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_upcom.do", method = RequestMethod.POST)
	public ModelAndView market_upcom_post(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();

		ModelAndView mav = new ModelAndView();
		
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.addObject("trPage", req.getParameter("trPage"));
		
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_upcom" : "/vn_home/newsAndEvents/market_upcom"));
		return mav;
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_vsd.do", method = RequestMethod.POST)
	public ModelAndView market_vsd_post(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();

		ModelAndView mav = new ModelAndView();
		
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.addObject("trPage", req.getParameter("trPage"));
		
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_vsd" : "/vn_home/newsAndEvents/market_vsd"));
		return mav;
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market.do", method = RequestMethod.POST)
	public ModelAndView marketpost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.addObject("trPage", req.getParameter("trPage"));
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market" : "/vn_home/newsAndEvents/market"));
		return mav;
	}
	
	@RequestMapping(value = "/home/newsAndEvents/market_view.do", method = RequestMethod.GET)
	public String market_view(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		String lang = req.getParameter("lang");
		if (lang.equals("vi")) {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "redirect:/home/newsAndEvents/market.do" : "/vn_home/newsAndEvents/market_view");
		} else {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/market_view" : "redirect:/home/newsAndEvents/market.do");
		}
	}
	
	@RequestMapping(value = "/home/newsAndEvents/mirae_view.do", method = RequestMethod.GET)
	public String mirae_view(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		String lang = req.getParameter("lang");
		if (lang.equals("vi")) {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "redirect:/home/newsAndEvents/mirae.do" : "/vn_home/newsAndEvents/mirae_view");
		} else {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/mirae_view" : "redirect:/home/newsAndEvents/mirae.do");
		}
	}
	
	@RequestMapping(value = "/home/newsAndEvents/investmentedu_view.do", method = RequestMethod.GET)
	public String investmentedu_view(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		String lang = req.getParameter("lang");
		if (lang.equals("vi")) {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "redirect:/home/newsAndEvents/investmentedu.do" : "/vn_home/newsAndEvents/investmentedu_view");
		} else {
			return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/investmentedu_view" : "redirect:/home/newsAndEvents/investmentedu.do");
		}
	}
	
	@RequestMapping(value = "/home/newsAndEvents/mirae.do", method = RequestMethod.GET)
	public String mirae(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/mirae" : "/vn_home/newsAndEvents/mirae");
	}
	
	@RequestMapping(value = "/home/newsAndEvents/investmentedu.do", method = RequestMethod.GET)
	public String investmentedu(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		return "/vn_home/newsAndEvents/investmentedu";
	}
	
	@RequestMapping(value = "/home/newsAndEvents/mirae.do", method = RequestMethod.POST)
	public ModelAndView miraepost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		ModelAndView mav = new ModelAndView();
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("page", req.getParameter("page"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.setViewName(("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/newsAndEvents/mirae" : "/vn_home/newsAndEvents/mirae"));
		return mav;
	}
	
	@RequestMapping(value = "/home/newsAndEvents/investmentedu.do", method = RequestMethod.POST)
	public ModelAndView investmentedupost(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();
		ModelAndView mav = new ModelAndView();
		mav.addObject("type", req.getParameter("type"));
		mav.addObject("sid", req.getParameter("sid"));
		mav.addObject("from", req.getParameter("from"));
		mav.addObject("to", req.getParameter("to"));
		mav.addObject("page", req.getParameter("page"));
		mav.addObject("searchkey", req.getParameter("searchkey"));
		mav.setViewName("/vn_home/newsAndEvents/investmentedu");
		return mav;
	}
	
	@RequestMapping(value = "/newsAndEvents/popup/marketView.do", method = RequestMethod.POST)
	public String marketView(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();

		model.addAttribute("newsSeqn", req.getParameter("seqn"));
		model.addAttribute("newsDivId", req.getParameter("divId"));
		
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/popup/marketView" : "/vn_home/popup/marketView");
	}
	
	@RequestMapping(value = "/newsAndEvents/popup/miraeView.do", method = RequestMethod.POST)
	public String miraeView(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
		HttpSession session = req.getSession();

		model.addAttribute("newsSeqn", req.getParameter("sid"));
		model.addAttribute("newsDivId", req.getParameter("divId"));
		
		return ("en_US".equals(session.getAttribute("LanguageCookie")) ? "/home/popup/miraeView" : "/vn_home/popup/miraeView");
	}
}
