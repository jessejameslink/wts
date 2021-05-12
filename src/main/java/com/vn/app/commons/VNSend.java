package com.vn.app.commons;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import m.common.tool.tool;
import m.config.SystemConfig;
import m.log.Log;

/**
 * 
 * </pre>
 */
@SuppressWarnings("deprecation")
public class VNSend {

	/*
	 * @Value("#{prop['SYSTEM.USER.AGENT']}") private String USER_AGENT;
	 * 
	 * @Value("#{prop['SYSTEM.TTL.SERVER.IP']}") private String host;
	 * 
	 * @Value("#{prop['SYSTEM.TTL.SERVER']}") private String server;
	 */
	private String USER_AGENT = SystemConfig.get("SYSTEM.USER.AGENT");
	private String host = SystemConfig.get("SYSTEM.TTL.SERVER.IP");

	private long startTime = System.currentTimeMillis();

	/**
	 * HttpClient에 close 기능을 사용하기 위해 DefaultHttpClient로 변경한다.
	 */
	private DefaultHttpClient httpClient;

	/**
	 * DefaultHttpClient를 return한다.
	 */
	public DefaultHttpClient getHttpClient() {
		return this.httpClient;
	}// end of getHttpClient();

	public long getStartTime() {
		return this.startTime;
	}// end of getStartTime();

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

	@SuppressWarnings("unused")
	private JSONObject CKPOST(final String url, final List<NameValuePair> postParams, final HttpServletRequest request)	throws Exception {
		JSONObject jsonObject = new JSONObject();
		return jsonObject;
	}

	public JSONObject SendPost(final String url, final List<NameValuePair> postParams, final HttpServletRequest request) throws Exception {
		long startTime = System.currentTimeMillis();
		BufferedReader rd = null;
		JSONObject jsonObject = null;
		char success = 'N';
		boolean logFlag = true;
		try {
			httpClient = new DefaultHttpClient();
			HttpPost post = new HttpPost(url);
			HttpSession session = request.getSession();

			// add header
			post.setHeader("Host", host);
			post.setHeader("User-Agent", USER_AGENT);
			post.setHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
			post.setHeader("Accept-Language", "en-US,en;q=0.5");
			post.setHeader("Accept-Encoding", "UTF-8");
			if (url.indexOf("resetPassword") < 0 && url.indexOf("validateClientInfo") < 0) {
				if (session.getAttribute("ttlJsession") != null){
					post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
				}
				//post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
			}
			if (url.indexOf("confirmresetpassword") < 0 && url.indexOf("forgotpassword") < 0) {
				if (session.getAttribute("ttlJsession") != null){
					post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
				}
				//post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
			}
			post.setHeader("Connection", "keep-alive");
			post.setHeader("Content-Type", "application/x-www-form-urlencoded");
			post.setEntity(new UrlEncodedFormEntity(postParams, "UTF-8"));

			HttpResponse response = httpClient.execute(post);

			int responseCode = response.getStatusLine().getStatusCode();
			// System.out.println("ULR==>" + url + ", INDEX OF=>" +
			// url.indexOf("comet.ttl"));
			if (url.indexOf("checkSession") > 0 || url.indexOf("comet.ttl") > 0) { // ttl
																					// &
																					// checksession
																					// ttl
																					// no
																					// write
																					// Log
				logFlag = false;
			}

			if (logFlag) {
				//System.out.println("\nSending 'POST' request to URL : " + url);
				//System.out.println("[" + tool.getCurrentFormatedTime() + "] " + session.getAttribute("ClientV") + " "+ getClientIpAddr(request));
				//System.out.println("Post parameters : " + postParams);
				//System.out.println("Response Code : " + responseCode);
				if (url.indexOf("resetPassword") < 0 && url.indexOf("validateClientInfo") < 0) {
					//System.out.println("JSESSIONID : " + session.getAttribute("ttlJsession").toString());
					try {
						//System.out.println("USER SESSOIN ID=>" + session.getAttribute("ClientV"));
					} catch (Exception e) {
						//System.out.println("User Session Error : " + e);
					}
				}
				if (url.indexOf("confirmresetpassword") < 0 && url.indexOf("forgotpassword") < 0) {
					//System.out.println("JSESSIONID : " + session.getAttribute("ttlJsession").toString());
					try {
						//System.out.println("USER SESSOIN ID=>" + session.getAttribute("ClientV"));
					} catch (Exception e) {
						//System.out.println("User Session Error : " + e);
					}
				}
			}
			rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

			StringBuffer result = new StringBuffer();
			String line = "";
			while ((line = rd.readLine()) != null) {
				result.append(line);
			}

			rd.close();
			if (logFlag) {
				//System.out.println("---------------------");
				//System.out.println(result.toString());
				//System.out.println("---------------------");
				//System.out.println(result.toString().replaceAll("<!--", ""));
			}
			jsonObject = (JSONObject) JSONValue.parse(result.toString());
			// return result.toString().replaceAll( "<!--", "" ) ;
			success = 'Y';
			return jsonObject;
		} catch (Exception e) {
			success = 'N';
			throw e;
		} finally {
			try {
				if (rd != null) {
					rd.close();
					rd = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			long endTime = System.currentTimeMillis();
			if (logFlag) {
				//System.out.println("VNSend.sendPost.TTLLog : [" + request.getRemoteAddr() + "][" + url + "][" + success+ "][" + (endTime - startTime) + "]");
				//Log.println("VNSend.sendPost.IN : [" + request.getRemoteAddr() + "]["+ request.getSession(true).getAttribute("ttlJsession") + "][" + url + "][" + success + "]["+ (endTime - startTime) + "][" + postParams + "]");
				//Log.println("VNSend.sendPost.OUT : [" + request.getRemoteAddr() + "]["+ request.getSession(true).getAttribute("ttlJsession") + "][" + url + "][" + success + "]["+ (endTime - startTime) + "][" + jsonObject + "]");
			}
		}
	}

	public JSONObject SendPostNew(final String url, final JSONObject jsonData, final HttpServletRequest request) throws Exception {
		long startTime = System.currentTimeMillis();
		BufferedReader rd = null;
		JSONObject jsonObject = null;
		char success = 'N';
		boolean logFlag = true;
		
		//String userAgent = "";
		//System.out.println("vao roi0");
		try {
			//System.out.println("vao roi5");
			httpClient = new DefaultHttpClient();
			//System.out.println("vao roi6");
			HttpPost post = new HttpPost(url);
			//System.out.println("vao roi7");
			HttpSession session = request.getSession();
			//System.out.println("vao roi8");
			// add header
			post.setHeader("Host", host);
			//System.out.println("vao roi9");
			post.setHeader("User-Agent", USER_AGENT);
			//System.out.println("vao roi10");
			post.setHeader("Accept", "text/html, application/xhtml+xml, application/json, application/xml, text/javascript; q=0.9, */*; q=0.8 ; q=0.01");
			//System.out.println("vao roi11");
			post.setHeader("Accept-Language", "en-US, en; q=0.5");
			//System.out.println("vao roi12");
			post.setHeader("Accept-Encoding", "UTF-8");
			//System.out.println("vao roi13");
			post.setHeader("X-Forwarded-For", getClientIpAddr(request));
			//System.out.println("vao roi14");
			//System.out.println("vao roi16 " + url);
			if (url.indexOf("resetPassword") < 0 && url.indexOf("validateClientInfo") < 0) {
				//System.out.println("vao roi17 " + url);
				if (session.getAttribute("ttlJsession") != null){
					post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
				}				
				//System.out.println("vao roi18 " + url);
			}
			//System.out.println("vao roi15");
			//System.out.println("vao roi1");
			if (url.indexOf("confirmresetpassword") < 0 && url.indexOf("forgotpassword") < 0) {
				//System.out.println("vao roi2");
				if (session.getAttribute("ttlJsession") != null){
					post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
				}
				//post.setHeader("Cookie", session.getAttribute("ttlJsession").toString());
			}
			post.setHeader("Connection", "keep-alive");
			post.setHeader("Content-Type", "application/json");
			
			//userAgent = request.getHeader("user-agent");
			//System.out.println("userAgent: " + request.getHeader("Cookie"));
			//System.out.println("Cookie Code out: " + request.getHeader("Cookie"));
			
			//if (userAgent.contains("Trident/7") && userAgent.contains("rv:11")) {
				//post.setHeader("Cookie", request.getHeader("Cookie"));
				//System.out.println("userAgent Code : " + session.getAttribute("ttlJsession").toString());
			//}
			
			StringEntity params = new StringEntity(jsonData.toString(),"UTF-8");
			params.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
			post.setEntity(params);
			//System.out.println("vao roi3" + params);
			HttpResponse response = httpClient.execute(post);
			//System.out.println("vao roi4" + post);
			int responseCode = response.getStatusLine().getStatusCode();

			if (url.indexOf("checkSession") > 0 || url.indexOf("comet.ttl") > 0) {
				//System.out.println("vao roi");
				logFlag = false;
			}

			if (logFlag) {
				//System.out.println("\nSending 'POST' request to URL : " + url);
				//System.out.println("[" + tool.getCurrentFormatedTime() + "] " + session.getAttribute("ClientV") + " " + getClientIpAddr(request));
				//System.out.println("Response Code : " + responseCode);
				//System.out.println("INPUT : [" + jsonData.toString() + "]");
				if (url.indexOf("resetPassword") < 0 && url.indexOf("validateClientInfo") < 0) {
					//System.out.println("JSESSIONID : " + session.getAttribute("ttlJsession").toString());
					try {
						//System.out.println("USER SESSOIN ID=>" + session.getAttribute("ClientV"));
					} catch (Exception e) {
						//System.out.println("User Session Error : " + e);
					}
				}
				if (url.indexOf("confirmresetpassword") < 0 && url.indexOf("forgotpassword") < 0) {
					//System.out.println("JSESSIONID : " + session.getAttribute("ttlJsession").toString());
					try {
						//System.out.println("USER SESSOIN ID=>" + session.getAttribute("ClientV"));
					} catch (Exception e) {
						//System.out.println("User Session Error : " + e);
					}
				}
			}
			rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

			StringBuffer result = new StringBuffer();
			String line = "";
			while ((line = rd.readLine()) != null) {
				result.append(line);
			}

			rd.close();
			if (logFlag) {
				//System.out.println("---------------------");
				//System.out.println(result.toString());
				//System.out.println("---------------------");
				//System.out.println(result.toString().replaceAll("<!--", ""));
			}
			jsonObject = (JSONObject) JSONValue.parse(result.toString());
			// return result.toString().replaceAll( "<!--", "" ) ;
			success = 'Y';
			return jsonObject;
		} catch (Exception e) {
			success = 'N';
			throw e;
		} finally {
			try {
				if (rd != null) {
					rd.close();
					rd = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			long endTime = System.currentTimeMillis();
			if (logFlag) {
				//System.out.println("VNSend.SendPostNew.TTLLog : [" + request.getRemoteAddr() + "][" + url + "][" + success + "][" + (endTime - startTime) + "]");
				//Log.println("VNSend.SendPostNew.IN : [" + request.getRemoteAddr() + "]["+ request.getSession(true).getAttribute("ttlJsession") + "][" + url + "][" + success + "]["+ (endTime - startTime) + "][" + jsonObject + "]");
				//Log.println("VNSend.SendPostNew.OUT : [" + request.getRemoteAddr() + "]["+ request.getSession(true).getAttribute("ttlJsession") + "][" + url + "][" + success + "]["+ (endTime - startTime) + "][" + jsonObject + "]");
			}
		}
	}
}