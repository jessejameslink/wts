package com.vn.app.commons;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;  
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class LanguageInterceptor extends HandlerInterceptorAdapter {
	private static final Logger logger = LoggerFactory.getLogger(LanguageInterceptor.class);
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();
		String userid 	= 	(String) session.getAttribute("ClientV");
		String language	= (String) session.getAttribute("LanguageCookie");
		if(null == language || "".equals(language)) {
			try {
				Cookie[] cookies	=	request.getCookies();
				Cookie cookie	=	null;
				boolean	languageFlag	=	true;
				if(cookies != null) {
					for(int i = 0; i < cookies.length; i++) {
						//System.out.println("$Cookies==>" + cookies[i].getName() + ", VALUE SET=>" + cookies[i].getValue());
						if(cookies[i].getName().equals("LanguageCookie")) {
							language	=	cookies[i].getValue();
							if(null == language || "".equals(language)) {
								/*	Modify : 2017/02/23	JinWoo Request modify vi_VN 
								language	=	"en_US";
								cookie	=	new Cookie("LanguageCookie","en_US");
								session.setAttribute("LanguageCookie","en_US");
								*/
								language	=	"vi_VN";
								cookie	=	new Cookie("LanguageCookie","vi_VN");
								session.setAttribute("LanguageCookie","vi_VN");
							} else {
								cookie	=	new Cookie("LanguageCookie", language);
								session.setAttribute("LanguageCookie",language);
							}
							languageFlag	=	false;
						}
					}
					
					if(languageFlag) {
						//cookie	=	new Cookie("LanguageCookie","en_US");
						cookie	=	new Cookie("LanguageCookie","vi_VN");
					}
					cookie.setMaxAge(60*10);								//Cookie setting Time 10 minute
				}
				response.addCookie(cookie);
			
			} catch(Exception e) {
				logger.error("Error Code : " + e);
				return super.preHandle(request, response, handler);
			}
		}
		return super.preHandle(request, response, handler);
	}
	
	public void postHandle(
			HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)
			throws Exception {
	}

	/**
	 * This implementation is empty.
	 */
	@Override
	public void afterCompletion(
			HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

	/**
	 * This implementation is empty.
	 */
	@Override
	public void afterConcurrentHandlingStarted(
			HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
	}
 }