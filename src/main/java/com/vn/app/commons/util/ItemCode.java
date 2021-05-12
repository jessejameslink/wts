package com.vn.app.commons.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.Enumeration;
import java.util.Scanner;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;

import com.vn.app.webmain.mssqlweb.home.service.MarketNewsService;

import m.config.SystemConfig;

@Configurable
public class ItemCode  
{ 
	//@Value("#{prop['VN.WTS.ITEM.CODE']}") private String WTS_CODE_FILE;
	String WTS_CODE_FILE		= 	SystemConfig.get("VN.WTS.ITEM.CODE");
	String SERVERDOMAIN		=	SystemConfig.get("SERVERDOMAIN");
	@SuppressWarnings("unchecked")
	public JSONArray getItemCode(String str) throws IOException {
		Scanner scan = new Scanner(new File(this.getClass().getResource("/").getPath() + "vn/conf/vncode.cod"));
		JSONArray   jary    = new JSONArray();
		while (scan.hasNext()) { 
	         String codeLine	=	scan.nextLine(); 
	         String code[]		=	codeLine.split("\t");
	         JSONObject	jo		=	new JSONObject();
	         if(code[0].indexOf(str) > -1 ) {
	        	 jo.put("synm", code[0]);
		         jo.put("marketId", code[1]);
		         jo.put("snum", code[2]);
		         if(code.length >= 4) {
		        	 jo.put("secNm_en", code[3]);
		         } else {
		        	 jo.put("secNm_en", "");
		         }
		         if(code.length >= 5) {
		        	 jo.put("secNm_vn", code[4]);
		         } else {
		        	 jo.put("secNm_vn", "");
		         }
		         jary.add(jo);
	         }
		}
		scan.close();
		return jary;
	}
	
	@SuppressWarnings("unchecked")
	public JSONArray getMarketItemCode(String market, String str) throws IOException {
		if(market == null) {
			market	=	"";
		}
		if(str == null) {
			str		=	"";
		}
		market	=	market.toUpperCase();
		str		=	str.toUpperCase();
		Scanner scan = new Scanner(new File(this.getClass().getResource("/").getPath() + "vn/conf/vncode.cod"));
		JSONArray   jary    = new JSONArray();
		while (scan.hasNext()) { 
	         String codeLine	=	scan.nextLine(); 
	         String code[]		=	codeLine.split("\t");
	         JSONObject	jo		=	new JSONObject();
	         if("ALL".equals(market) || market.equals(code[1]) || "".equals(market)) {
	        	 if(code[0].indexOf(str) == 0 || "".equals(str)) {
	        		 jo.put("synm", code[0]);
			         jo.put("marketId", code[1]);
			         if(code.length >= 3) {
			        	 jo.put("snum", code[2]);
			         } else {
			        	 jo.put("snum", "");
			         }
			         if(code.length >= 4) {
			        	 jo.put("secNm_en", code[3]);
			         } else {
			        	 jo.put("secNm_en", "");
			         }
			         if(code.length >= 5) {
			        	 jo.put("secNm_vn", code[4]);
			         } else {
			        	 jo.put("secNm_vn", "");
			         }
			         jary.add(jo);
	        	 }
	         }
		}
		scan.close();
		return jary;
	}

	public static String getIp() throws SocketException {
		String ip	=	"";
		
		boolean	isLoopBack	=	true;
		Enumeration<NetworkInterface>	en;
		en	=	NetworkInterface.getNetworkInterfaces();
		
		while(en.hasMoreElements()) {
			NetworkInterface ni	=	en.nextElement();
			if(ni.isLoopback())
				continue;
			
			Enumeration<InetAddress> inetAddresses	=	ni.getInetAddresses();
			while(inetAddresses.hasMoreElements()) {
				InetAddress ia	=	inetAddresses.nextElement();
				if(ia.getHostAddress() != null && ia.getHostAddress().indexOf(".") != -1) {
					ip	=	ia.getHostAddress();
					isLoopBack	=	false;
					break;
				}
			}
			if(!isLoopBack)
				break;
		}
		return ip;
	}
	
	public static String getDomainName() throws SocketException {
		String ip	=	"";
		
		boolean	isLoopBack	=	true;
		Enumeration<NetworkInterface>	en;
		en	=	NetworkInterface.getNetworkInterfaces();
		
		while(en.hasMoreElements()) {
			NetworkInterface ni	=	en.nextElement();
			if(ni.isLoopback())
				continue;
			
			Enumeration<InetAddress> inetAddresses	=	ni.getInetAddresses();
			while(inetAddresses.hasMoreElements()) {
				try {
					if(InetAddress.getLocalHost().getHostName() != null) {
						ip	=	InetAddress.getLocalHost().getHostName();
						isLoopBack	=	false;
						break;
					}
				} catch (UnknownHostException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(!isLoopBack)
				break;
		}
		return ip;
	}
	
	/*
	@Resource(name="itemServiceImpl")
	private ItemService itemService;
	
	@Resource(name="marketNewsServiceImpl")
	private MarketNewsService marketNewsService;
	*/
	
	
	@Autowired
	@Resource(name="marketNewsServiceImpl")
	private MarketNewsService marketNewsService;
	
	public String getRcodContent() throws Exception {
		//System.out.println("스케줄 확인");
		String content				=	"";
		String requesturl	=	SERVERDOMAIN + "/setUpdateRcod.do";
		URL url = null;

		String requestMsg = "";
		String line="";
		BufferedReader input = null;
	     
		try {
 
         // Request
         url = new URL(requesturl);
         // Response
         input = new BufferedReader(new InputStreamReader(url.openStream()));

	        while((line=input.readLine()) != null){
	        	 requestMsg += line;
	        }
		} catch (Exception e) {
			e.printStackTrace();
		}
	    
		//System.out.println("========출력결과==========");
		//System.out.println(requestMsg);
		//System.out.println("=======================");
		
		return content;
	}
	
	
	public void setUpdateMadw() throws Exception {
		//System.out.println("스케줄 확인");
		String requesturl	=	SERVERDOMAIN + "/setUpdateMadw.do";
		URL url = null;
		BufferedReader input = null;
		try {
			// Request
			url = new URL(requesturl);
			// Response
			input = new BufferedReader(new InputStreamReader(url.openStream()));
		} catch (Exception e) {
			e.printStackTrace();
			input.close();
		} finally {
			input.close();
		}
	}
	
	
	
	
} 