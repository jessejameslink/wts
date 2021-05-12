package com.vn.app.commons;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class SessionInterceptor extends HandlerInterceptorAdapter {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		//System.out.println("Interceptor : PreHandle");
		
		HttpSession session = 	request.getSession();
		String userid 		= 	(String) session.getAttribute("ClientV");
		
		if(null==userid || "".equals(userid)) {
			//System.out.println("Interceptor : Session Check Fail");
			response.sendRedirect("/login.do?redirect="+request.getRequestURI());
			return false;
		} else { 
			String chkPwd	= (String)session.getAttribute("chkPwd");
			if("Y".equals(chkPwd)) {
				response.sendRedirect("/home/account/changePw.do");
			}
			//System.out.println("Interceptor : Session Check true");
			return super.preHandle(request, response, handler);
		}
	}
	
	
	
	
	public void postHandle(
			HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)
			throws Exception {
		//System.out.println("#########################################");
		//System.out.println("#     postHandle						#");
		//System.out.println("#########################################");
	}

	/**
	 * This implementation is empty.
	 */
	@Override
	public void afterCompletion(
			HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		//System.out.println("#########################################");
		//System.out.println("#     afterCompletion						#");
		//System.out.println("#########################################");
	}

	/**
	 * This implementation is empty.
	 */
	@Override
	public void afterConcurrentHandlingStarted(
			HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//System.out.println("#########################################");
		//System.out.println("#     afterConcurrentHandlingStarted						#");
		//System.out.println("#########################################");
		
	}
	
	
	
	
	
	
	
	
	
	
	
 }