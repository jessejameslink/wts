package com.vn.app.webmain.oranews.home.web;

import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.vn.app.webmain.oranews.home.service.HomeService2;
import com.vn.app.webmain.oraweb.home.service.HomeService;

@Controller
public class HomeController2 {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController2.class);
	
	@Resource(name="homeServiceImpl")
	private HomeService homeService;
	
	@Resource(name="homeServiceImpl2")
	private HomeService2 homeService2;

	@RequestMapping(value = "/home2", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home2! The client locale is {}.", locale);
		
		List<com.vn.app.webmain.oraweb.home.service.TablesVO> list1 = homeService.getTables();
		List<com.vn.app.webmain.oranews.home.service.TablesVO> list2 = homeService2.getTables();

		model.addAttribute("list1", list1 );
		model.addAttribute("list2", list2 );
		
		return "home2";
	}	
}
