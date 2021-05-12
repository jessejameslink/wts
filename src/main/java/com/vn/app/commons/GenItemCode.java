package com.vn.app.commons;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;

import com.vn.app.commons.util.ItemCode;

public class GenItemCode implements ApplicationListener{

	//변수와 setter를 선언하여 bean xml 로부터 값을 넘겨받을 수 있다.
	String var1;

	public void setVar1(String var1) {
		this.var1 = var1;
	}

	//스프링 시스템 기동시 수행
	public void onApplicationEvent(ApplicationEvent applicationevent) {
		//System.out.println("************************************************************");
		//System.out.println("*                                                          *");
		//System.out.println("*                                                          *");
		//System.out.println("서버 스타트 확인");
		//System.out.println("************************************************************");
		//System.out.println("### Test.onApplicationEvent() > var1 : "+ var1 +"###");
		try {
			//ItemCode	item	=	new ItemCode();
			//item.getRcodContent();
		} catch(Exception e) {
			//System.out.println("@Schedule CHKINFO Error@");
			//System.out.println(e.getMessage());
			e.getMessage();
		}
	}
}
