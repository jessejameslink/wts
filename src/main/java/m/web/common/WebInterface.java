package m.web.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.security.Principal;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import m.action.ActionException;
import m.action.IConstants;
import m.action.TRExecuter;
import m.common.tool.tool;
import m.data.hash;
import m.json.JSONArray;
import m.json.JSONObject;
import m.security.AccountCipher;

/**
 * Web의 Request, Response를 관리하기 위한 표준 class이다.
 * WebInterface는 abstract class로 표준 처리를 위한 함수 등을 제공한다.
 * Get/Post방식 등은 WebParam, 첨부파일등 MultipartRequest의 활용형태는 MultiParam, XML 형태로 data를 주고받을때에는 XmlParam을 사용한다.
 * 각 Param class는 WebInterface를 extends받아서 abstract method와 추가적으로 필요한 method를 제공한다.
 * @author poemlife
 */
public abstract class WebInterface implements IConstants{

	//---------------------------------------- 공통 부분 ---------------------------------

	protected HttpServletRequest 	req;
	protected HttpServletResponse 	res;
	protected HttpSession 			session;

	private int 					type;

	public WebInterface(HttpServletRequest req, HttpServletResponse res){
		set(req, res);
	}//end of WebInterface();

	/**
	 * req, res를 setting한다.
	 * @param req HttpServletRequest, request object
	 * @param res HttpServletResponse, response object
	 */
	public void set(HttpServletRequest req, HttpServletResponse res){
		this.req 		= req;
		this.res 		= res;
		this.session	= this.req.getSession(true);
		this.res.setHeader("Pragma","No-cache");
		this.res.setDateHeader ("Expires", 0);
		this.res.setHeader ("Cache-Control", "no-cache");
	}//end of set();

	/**
	 * HttpServletRequest를 return한다.
	 * @return
	 */
	public HttpServletRequest getRequest(){
		return this.req;
	}//end of getRequest();

	/**
	 * HttpServletResponse를 return한다.
	 * @return
	 */
	public HttpServletResponse getResponse(){
		return this.res;
	}//end of getResponse();


	/**
	 * HttpSession return한다.
	 * @return
	 */
	public HttpSession getSession() {
		return this.session;
	}

	/**
	 * HttpSession invalidate
	 * @return
	 */
	public void invalidate() {
		if(this.session != null)	this.session.invalidate();
	}

	/**
	 * HttpSession invalidate(로그인)
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public void loginSessionInvalidate() {
		if(this.session != null){
	    	Enumeration en = this.session.getAttributeNames();
	    	while(en.hasMoreElements()){
	    		Object obj = en.nextElement();
	    		if(!"mediaCode".equals((String)obj) && !"login.pcinfo".equals((String)obj)&& !"common.targetId".equals((String)obj)&& !"common.menuTitle".equals((String)obj)){
	    			req.getSession().removeAttribute((String)obj);
	    		}
	    	}
	    	//req.getSession().invalidate();
	    }
	}

	/**
	 * 이 WebInterface의 type을 Setting한다.
	 * @param type JSP, MULTI, XML 셋 중 하나를 선택한다.
	 */
	public void setType(int type){
		this.type = type;
	}//end of setType();

	/**
	 * 이 WebInterface의 type을 반화한다.
	 * @param
	 */
	public int getType(){
		return this.type;
	}//end of getType();

	/**
	 * 로그인 상태 반환
	 * @return
	 */
	public int getLoginState(){
		String userID 	= getUsid();
		String cert 	= getCertlogin();

		if (userID.equals(""))								return 0;
		else if(cert.equals(String.valueOf(LOGIN_ID)))		return 1;
		else if(cert.equals(String.valueOf(LOGIN_CERT)))	return 2;
		else if(cert.equals(String.valueOf(LOGIN_IDCERT)))	return 3;
		else												return 0;
	}

	/**
	 * 퇴직연금 로그인 상태 반환
	 * @return
	 */
	public int getRetireLoginState(){
		String userID 	= getUsid();
		String cert 	= getRetireCertlogin();

		if(cert.equals("3")){
			return RETIRE_LOGIN_CERT;
		}else{
			if (userID.equals(""))		return RETIRE_LOGIN_NONE;
			else if(cert.equals("2"))	return RETIRE_LOGIN_ID;
			else if(cert.equals("4"))	return RETIRE_LOGIN_IDCERT;
			else						return RETIRE_LOGIN_NONE;
		}
	}

	/**
	 * Native 유무 체크
	 * @return
	 */
    public boolean isNative(){
		Cookie[] cookies = req.getCookies();

	 	for(int i=0 ; i < cookies.length; i++)
	 	{
            Cookie cookie = cookies[i];
            if("cookieNative".equals(cookie.getName()))
            {
                return true;
            }
        }

	 	return false;
    }// end of isNative();

	/**
	 * -------------------------- session information get/set start--------------------------
	 * login.loginok				= 로그인 상태
	 * login.clevel					= 고객 서비스 코드
	 * login.stime					= 최종접속시간
	 * login.media					= 매체구분코드
	 * login.ssn					= 사용자인증코드
	 * login.certlogin				= 로그인 검증 여부
	 * login.accountno				= 계좌리스트(계좌번호, 고객명, 계좌구분)
	 * login.accountcheck			= 계좌 체크 여부
	 * login.username				= 고객명
	 * login.usid					= ID
	 * login.pkey					= 개인키
	 * login.xchk					= 비상여부
	 * login.dninfo					= 사용자인증정보
	 * login.ip						= 사용자IP
	 * login.reconfirmCert			= 주문시 인증비밀 번호 확인
	 * login.homhp					= 전화번호
	 * login.email					= Email
	 * login.vald					= 회원 등급
	 * login.Login_signedData 		= 로그인 서명 데이터
	 * login.isPwChk 				= 취약패스워드 판별여부
	 * login.csClssCd 				= 고객등급코드
	 * login.ishsm 					= hsm 사용여부
	 * login.keyb 					= 키보드 보안 사용 여부
	 * login.popup 					= 팝업 사용여부
	 * login.firw 					= 개인 방화벽 사용여부
	 * login.popup 					= 팝업 사용 여부
	 * login.retireloginok 			= 로그인 여부
	 * login.retireCertlogin 		= 로그인 검증 여부
	 * login.level					= 로그인 레벨
	 * login.memdiv					= 정회원, 준회원여부
	 * isNative 					=  native 연결 여부
	 * mediaCode 					= 매체 구분 코드(index.jsp set)
	 * acsw1000v 					= 계좌 리스트 instance(JSON)
	 * keyPadSKey 					= 보안 키패드 키
	 * ------- 로그인 step1 사용 -------
	 * login.step1.dninfo			= 사용자인증정보
	 * login.step1.usid				= ID
	 * login.step1.pkey				= 개인키
	 * login.step1.ishsm			= hsm 사용여부
	 * login.step1.reconfirmCert	= reconfirmCert
	 * login.step1.keyb				= 키보드 보안 사용 여부
	 * login.step1.firw				= 개인 방화벽 사용여부
	*/

    /**
     * 로그인 상태 return
     * @return 로그인 상태. 로그인 한 상태면 Y, 로그인 안한 상태면 N
     */
	public String getLoginOK() {
		String loginok = (String)session.getAttribute("login.loginok");
		if(loginok == null){
			return "N";
		}
		return loginok;
	}//end of getLoginOK();

	/**
	 * 로그인 상태 set
	 * @param loginok 로그인 한 상태면 Y, 로그인 안한 상태면 N
	 */
	public void setLoginOK(String loginok){
		session.setAttribute("login.loginok", loginok);
	}//end of setLoginOK();

	/**
	 * 고객 서비스 코드 return
	 * @return
	 */
	public String getClevel() {
		String clevel = (String)session.getAttribute("login.clevel");
		if(clevel == null){
			return "";
		}
		return clevel;
	}//end of getClevel();

	/**
	 * 고객 서비스 코드 set
	 * @param clevel
	 */
	public void setClevel(String clevel){
		session.setAttribute("login.clevel", clevel);
	}//end of setClevel();

	/**
	 * 최종접속시간 return
	 * @return
	 */
	public String getStime() {
		String stime = (String)session.getAttribute("login.stime");
		if(stime == null){
			return "";
		}
		return stime;
	}//end of getStime();

	/**
	 * 최종접속시간 set
	 * @param stime
	 */
	public void setStime(String stime){
		session.setAttribute("login.stime", stime);
	}//end of setStime();


	/**
	 * 사용자 인증 코드 return
	 * @return
	 */
	public String getSsn() {
		String ssn = (String)session.getAttribute("login.ssn");
		if(ssn == null){
			return "";
		}
		return ssn;
	}//end of getSsn();

	/**
	 * 사용자 인증코드 set
	 * @param ssn
	 */
	public void setSsn(String ssn){
		session.setAttribute("login.ssn", ssn);
	}//end of setSsn();

	/**
	 * 로그인 검증 여부 return
	 * @return
	 */
	public String getCertlogin() {
		String certlogin = (String)session.getAttribute("login.certlogin");
		if(certlogin == null){
			return "";
		}
		return certlogin;
	}//end of getCertlogin();

	/**
	 * 로그인 검증 여부 set
	 * @param certlogin
	 */
	public void setCertlogin(int certlogin){
		setCertlogin(String.valueOf(certlogin));
	}//end of setCertlogin();

	/**
	 * 로그인 검증 여부 set
	 * @param certlogin
	 */
	public void setCertlogin(String certlogin){
		session.setAttribute("login.certlogin", certlogin);
	}//end of setCertlogin();

	/**
	 * 계좌 리스트 return
	 * @return
	 */
	public String getAccountno() {
		String accountno = (String)session.getAttribute("login.accountno");
		if(accountno == null){
			return "";
		}
		return accountno;
	}//end of getAccountno();

	/**
	 * 계좌 리스트 set
	 * @param accountno
	 */
	public void setAccountno(String accountno){
		session.setAttribute("login.accountno", accountno);
	}//end of setAccountno();

	/**
	 * 고객명 return
	 * @return
	 */
	public String getUserName() {
		String username = (String)session.getAttribute("login.username");
		if(username == null){
			return "";
		}
		return username;
	}//end of getUserName();

	/**
	 * 고객명 set
	 * @param username
	 */
	public void setUserName(String username){
		session.setAttribute("login.username", username);
	}//end of setUserName();

	/**
	 * 고객 ID return
	 * @return
	 */
	public String getUsid() {
		String usid = (String)session.getAttribute("login.usid");
		if(usid == null){
			return "";
		}
		return usid;
	}//end of getUsid();

	/**
	 * 고객 ID set
	 * @param usid
	 */
	public void setUsid(String usid){
		session.setAttribute("login.usid", usid);
		this.setIp(this.getClientIP());
	}//end of setUsid();

	/**
	 * 고객등급코드 return
	 * @return
	 */
	public String getCsClssCd() {
		String csClssCd = (String)session.getAttribute("login.csClssCd");
		if(csClssCd == null){
			return "";
		}
		return csClssCd;
	}//end of getCsClssCd();

	/**
	 * 고객등급코드 set
	 * @param usid
	 */
	public void setCsClssCd(String csClssCd){
		session.setAttribute("login.csClssCd", csClssCd);
	}//end of setCsClssCd();

	/**
	 * 고객 ID return(로그인 step1)
	 * @return
	 */
	public String getStep1Usid() {
		String usid = (String)session.getAttribute("login.step1.usid");
		if(usid == null){
			return "";
		}
		return usid;
	}//end of getUsid();

	/**
	 * 고객 ID set(로그인 step1)
	 * @param usid
	 */
	public void setStep1Usid(String usid){
		session.setAttribute("login.step1.usid", usid);
	}//end of setUsid();

	/**
	 * 고객 ID return(로그인 step1)
	 * @return
	 */
	public String getStep1Pwd() {
		String usid = (String)session.getAttribute("login.step1.Pwd");
		if(usid == null){
			return "";
		}
		return usid;
	}//end of getStep1Pwd();

	/**
	 * 고객 ID set(로그인 step1)
	 * @param usid
	 */
	public void setStep1Pwd(String pwd){
		session.setAttribute("login.step1.Pwd", pwd);
	}//end of setStep1Pwd();

	/**
	 * 고객 ssn return(로그인 step1)
	 * @return
	 */
	public String getStep1SSN() {
		String ssn = (String)session.getAttribute("login.step1.ssn");
		if(ssn == null){
			return "";
		}
		return ssn;
	}//end of getStep1SSN();

	/**
	 * 고객 ssn set(로그인 step1)
	 * @param ssn
	 */
	public void setStep1SSN(String ssn){
		session.setAttribute("login.step1.ssn", ssn);
	}//end of setStep1SSN();

	/**
	 * 공인인증 등록 여부(rksz9060u)
	 * 퇴직연금 미등록 공인인증서 로그인에서 사용
	 * @return
	 */
	public String getConsentYn() {
		String consentYn = (String)session.getAttribute("login.step1.consent_yn");
		if(consentYn == null){
			return "";
		}
		return consentYn;
	}//end of getConsentYn();

	/**
	 * 공인인증 등록 여부(rksz9060u)
	 * @param consentYn
	 */
	public void setConsentYn(String consentYn){
		session.setAttribute("login.step1.consent_yn", consentYn);
	}//end of setConsentYn();

	/**
	 * 공개키 return
	 * @return
	 */
	public String getPkey() {
		String pkey = (String)session.getAttribute("login.pkey");
		if(pkey == null){
			return "";
		}
		return pkey;
	}//end of getPkey();

	/**
	 * 공개키 유뮤 return
	 * @return
	 */
	public String isPkey() {
		String pkey = (String)session.getAttribute("login.pkey");
		if(pkey == null){
			return "";
		}
		return "Y";
	}//end of isPkey();

	/**
	 * 공개키 set
	 * @param pkey
	 */
	public void setPkey(String pkey){
		session.setAttribute("login.pkey", pkey);
	}//end of setPkey();

	/**
	 * 공개키 return
	 * @return
	 */
	public String getStep1Pkey() {
		String pkey = (String)session.getAttribute("login.step1.pkey");
		if(pkey == null){
			return "";
		}
		return pkey;
	}//end of getStep1Pkey();

	/**
	 * 공개키 set
	 * @param pkey
	 */
	public void setStep1Pkey(String pkey){
		session.setAttribute("login.step1.pkey", pkey);
	}//end of setStep1Pkey();


	/**
	 * HSM사용여부 return
	 * @return
	 */
	public String getIshsm() {
		String ishsm = (String)session.getAttribute("login.ishsm");
		if(ishsm == null){
			return "";
		}
		return ishsm;
	}//end of getIshsm();

	/**
	 * HSM사용여부 set
	 * @param ishsm
	 */
	public void setIshsm(String ishsm){
		session.setAttribute("login.ishsm", ishsm);
	}//end of setIshsm();

	/**
	 * HSM사용여부 return
	 * @return
	 */
	public String getStep1Ishsm() {
		String ishsm = (String)session.getAttribute("login.step1.ishsm");
		if(ishsm == null){
			return "";
		}
		return ishsm;
	}//end of getStep1Ishsm();

	/**
	 * HSM사용여부 set
	 * @param ishsm
	 */
	public void setStep1Ishsm(String ishsm){
		session.setAttribute("login.step1.ishsm", ishsm);
	}//end of setStep1Ishsm();

	/*
	 * 2015.05.07 김종명 추가.
	 * 퇴직연금로그인과 일반고객 로그인 통합 위해 함수 4개 생성
	 * getVayn/setVayn, getAcyn/setAcyn, getPsyn/setPsyn, getBsyn/setBsyn 함수 각각 추가.
	 */

	/**
	 * 유효계좌여부 return.
	 * @return 1 : 유효계좌 있음. 나머지 : 유효계좌 없음.
	 */
	public String getVayn() {
		String vayn = (String)session.getAttribute("login.vayn");
		if(vayn == null){
			return "";
		}
		return vayn;
	}//end of getVayn();

	/**
	 * 유효계좌여부 Setting.
	 * @param vayn 1 : 유효계좌 있음. 나머지 : 없음.
	 */
	public void setVayn(String vayn){
		session.setAttribute("login.vayn", vayn);
	}//end of setVayn();

	/**
	 * 계좌여부 return.
	 * @return 1 : 계좌 있음. 나머지 : 계좌 없음.
	 */
	public String getAcyn() {
		String acyn = (String)session.getAttribute("login.acyn");
		if(acyn == null){
			return "";
		}
		return acyn;
	}//end of getAcyn();

	/**
	 * 계좌여부 Setting.
	 * @param acyn 1 : 유효계좌 있음. 나머지 : 없음.
	 */
	public void setAcyn(String acyn){
		session.setAttribute("login.acyn", acyn);
	}//end of setAcyn();

	/**
	 * 퇴직연금고객여부 return.
	 * @return 1 : 퇴직연금고객. 나머지 : 퇴직연금고객 아님.
	 */
	public String getPysn() {
		String pysn = (String)session.getAttribute("login.pysn");
		if(pysn == null){
			return "";
		}
		return pysn;
	}//end of getPysn();

	/**
	 * 퇴직연금고객여부 Setting.
	 * @param pysn 1 : 퇴직연금고객. 나머지 : 퇴직연금고객 아님.
	 */
	public void setPysn(String pysn){
		session.setAttribute("login.pysn", pysn);
	}//end of setPysn();

	/**
	 * 방카고객여부 return.
	 * @return 1 : 방카고객. 나머지 : 방카고객 아님.
	 */
	public String getBysn() {
		String pysn = (String)session.getAttribute("login.pysn");
		if(pysn == null){
			return "";
		}
		return pysn;
	}//end of getPysn();

	/**
	 * 방카고객여부 Setting.
	 * @param bysn 1 : 방카고객. 나머지 : 방카고객 아님.
	 */
	public void setBysn(String bysn){
		session.setAttribute("login.bysn", bysn);
	}//end of setBysn();

	/**
	 * 비상여부 return
	 * @return
	 */
	public String getXchk() {
		String xchk = (String)session.getAttribute("login.xchk");
		if(xchk == null){
			return "";
		}
		return xchk;
	}//end of getXchk();

	/**
	 * 비상여부 set
	 * @param xchk
	 */
	public void setXchk(String xchk){
		session.setAttribute("login.xchk", xchk);
	}//end of setXchk();

	/*
	 * 2015.08.04 김종명 수정
	 * 로그인시 최근로그인정보 팝업을 Slide 형태로 바꾸기 위해 setLastLoginInfo/getLastLoginInfo Method 추가
	 */

	/**
	 * 최근 접속정보를 Setting한다.
	 * @param lastLoginInfo
	 */
	public void setLastLoginInfo(JSONObject lastLoginInfo){
		session.setAttribute("login.lastLoginInfo", lastLoginInfo);
	}//end of setLastLoginInfo();

	/**
	 * 최근 접속정보를 가져온다.
	 * @return
	 */
	public JSONObject getLastLoginInfo(){
		return (JSONObject)session.getAttribute("login.lastLoginInfo");
	}//end of getLastLoginInfo();

	/*
	 * 2015.12.16 김종명 수정
	 * 로그인시 SSO 서버에서 SSO Key를 받아와서 Session에 Set/Get할 함수 추가
	 */

	/**
	 * Session에 SSO Key를 Setting한다.
	 */
	public void setSsoKey(String ssokey){
		if(ssokey==null)		session.removeAttribute("login.ssokey");
		else					session.setAttribute("login.ssokey", ssokey.trim());
	}//end of setSsoKey();

	/**
	 * SSO Key를 return한다.
	 * @return
	 */
	public String getSsoKey(){
		return (String)session.getAttribute("login.ssokey");
	}//end of getSsoKey();

	/**
	 * Sso Key가 정상인지 여부를 체크한다.
	 * @return 세션 점검 결과.
	 *          ecod : error code. 0000이 정상.
	 *          emsg : error message
	 */
	@SuppressWarnings("unchecked")
	public JSONObject checkSsoKey(){
		JSONObject obj = null;
		try {
			this.setString("sflg"	, "Q"				);		//flag Setting
			this.setString("usid"	, this.getUsid()	);		//usid Setting(Session에서 가져옴)
			this.setString("ssok"	, this.getSsoKey()	);		//Session에서 SSO Key를 가져와서 Setting
			TRExecuter executer = new TRExecuter(this, "piiowsso");
			obj = executer.execute();
			if(obj==null){
				obj = new JSONObject();
				obj.put("ecod", SSO_KEY_ERR_MSG);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			if(obj==null){
				obj = new JSONObject();
				obj.put("ecod", SSO_KEY_ERR_MSG);
			}
		}
		return obj;
	}//end of checkSsoKey();

	/*
	 * 2016.02.16 김종명 수정.
	 * dupa, dupc 함수 추가 : 멀티로그인 차단 관련
	 */

	/**
	 * 중복접속 허용여부를 Setting한다.
	 * @param ducp 0 : 중복접속차단, 1 : 중복접속허용
	 */
	public void setDucp(String ducp){
		if(this.session==null)		this.session = req.getSession(true);
		if(tool.isNull(ducp))		this.session.removeAttribute("login.ducp");
		else						this.session.setAttribute("login.ducp", ducp.trim());
	}//end of setDucp();

	/**
	 * 중복접속허용여부를 return한다.
	 * @return 0 : 중복접속차단, 1 : 중복접속허용
	 */
	public String getDucp(){
		if(this.session==null)		return "";
		String ducp = (String)this.session.getAttribute("login.ducp");
		if(tool.isNull(ducp))		return "";
		else						return ducp.trim();
	}//end of getDucp();

	/**
	 * 중복접속 알람여부를 Setting한다.
	 * @param dupa 0 : 중복접속알람안함, 1 : 중복접속알람
	 */
	public void setDupa(String dupa){
		if(this.session==null)		this.session = req.getSession(true);
		if(tool.isNull(dupa))		this.session.removeAttribute("login.dupa");
		else						this.session.setAttribute("login.dupa", dupa.trim());
	}//end of setDupa();

	/**
	 * 중복접속 알람여부를 return한다.
	 * @return 0 : 중복접속알람안함, 1 : 중복접속알람
	 */
	public String getDupa(){
		if(this.session==null)		return "";
		String dupa = (String)this.session.getAttribute("login.dupa");
		if(tool.isNull(dupa))		return "";
		else						return dupa.trim();
	}//end of getDupa();

	/**
	 * 취약패스워드 판별여부 return
	 * @return
	 */
	public String getIsPwChk() {
		String isPwChk = (String)session.getAttribute("login.isPwChk");
		if(isPwChk == null){
			return "";
		}
		return isPwChk;
	}//end of getIsPwChk();

	/**
	 * 취약패스워드 판별여부 set
	 * @param isPwChk
	 */
	public void setIsPwChk(String isPwChk){
		session.setAttribute("login.isPwChk", isPwChk);
	}//end of setIsPwChk();

	/**
	 * 로그인 서명 데이터 return
	 * @return
	 */
	public String getLoginSignedData() {
		String loginSignedData = (String)session.getAttribute("login.Login_signedData");
		if(loginSignedData == null){
			return "";
		}
		return loginSignedData;
	}//end of getLoginSignedData();

	/**
	 * 로그인 서명 데이터 set
	 * @param loginSignedData
	 */
	public void setLoginSignedData(String loginSignedData){
		session.setAttribute("login.Login_signedData", loginSignedData);
	}//end of setLoginSignedData();

	/**
	 * DN return
	 * @return
	 */
	public String getDninfo() {
		String dninfo = (String)session.getAttribute("login.dninfo");
		if(dninfo == null){
			return "";
		}
		return dninfo;
	}//end of getDninfo();

	/**
	 * DN set
	 * @param dninfo
	 */
	public void setDninfo(String dninfo){
		session.setAttribute("login.dninfo", dninfo);
	}//end of setDninfo();

	/**
	 * DN return
	 * @return
	 */
	public String getStep1Dninfo() {
		String dninfo = (String)session.getAttribute("login.step1.dninfo");
		if(dninfo == null){
			return "";
		}
		return dninfo;
	}//end of getDninfo();

	/**
	 * DN set
	 * @param dninfo
	 */
	public void setStep1Dninfo(String dninfo){
		session.setAttribute("login.step1.dninfo", dninfo);
	}//end of setDninfo();

	/**
	 * user ip return
	 * @return
	 */
	public String getIp() {
		String ip = (String)session.getAttribute("login.ip");
		if(ip == null){
			return "";
		}
		return ip;
	}//end of getIp();

	/**
	 * user ip set
	 * @param ip
	 */
	public void setIp(String ip){
		session.setAttribute("login.ip", ip);
	}//end of setIp();

	/**
	 * 주문시 인증비밀번호 확인 return
	 * @return
	 */
	public String getReconfirmCert() {
		String reconfirmCert = (String)session.getAttribute("login.reconfirmCert");
		if(reconfirmCert == null){
			return "";
		}
		return reconfirmCert;
	}//end of getReconfirmCert();

	/**
	 * 주문시 인증비밀번호 확인 set
	 * @param reconfirmCert
	 */
	public void setReconfirmCert(String reconfirmCert){
		session.setAttribute("login.reconfirmCert", reconfirmCert);
	}//end of setReconfirmCert();

	/**
	 * 주문시 인증비밀번호 확인 return(정회원 로그인 step1)
	 * @return
	 */
	public String getStep1ReconfirmCert() {
		String reconfirmCert = (String)session.getAttribute("login.step1.reconfirmCert");
		if(reconfirmCert == null){
			return "";
		}
		return reconfirmCert;
	}//end of getReconfirmCert();

	/**
	 * 주문시 인증비밀번호 확인 set(정회원 로그인 step1)
	 * @param reconfirmCert
	 */
	public void setStep1ReconfirmCert(String reconfirmCert){
		session.setAttribute("login.step1.reconfirmCert", reconfirmCert);
	}//end of setReconfirmCert();

	/**
	 * 전화번호 return
	 * @return
	 */
	public String getHomhp() {
		String homhp = (String)session.getAttribute("login.homhp");
		if(homhp == null){
			return "";
		}
		return homhp;
	}//end of getHomhp();

	/**
	 * 전화번호 set
	 * @param homhp
	 */
	public void setHomhp(String homhp){
		session.setAttribute("login.homhp", homhp);
	}//end of setHomhp();

	/**
	 * E-Mail return
	 * @return
	 */
	public String getEmail() {
		String email = (String)session.getAttribute("login.email");
		if(email == null){
			return "";
		}
		return email;
	}//end of getEmail();

	/**
	 * E-Mail set
	 * @param email
	 */
	public void setEmail(String email){
		session.setAttribute("login.email", email);
	}//end of setEmail();

	/**
	 * 회원 등급 return
	 * @return
	 */
	public String getVald() {
		String vald = (String)session.getAttribute("login.vald");
		if(vald == null){
			return "";
		}
		return vald;
	}//end of getVald();

	/**
	 * 회원 등급 set
	 * @param vald
	 */
	public void setVald(String vald){
		session.setAttribute("login.vald", vald);
	}//end of setVald();

	/**
	 * 키보드 보안 사용여부 return
	 * @return
	 */
	public String getKeyb() {
		String keyb = (String)session.getAttribute("login.keyb");
		if(keyb == null){
			return "";
		}
		return keyb;
	}//end of getKeyb();

	/**
	 * 키보드 보안 사용여부 set
	 * @param keyb
	 */
	public void setKeyb(String keyb){
		session.setAttribute("login.keyb", keyb);
	}//end of setKeyb();

	/**
	 * 키보드 보안 사용여부 return(로그인 step1)
	 * @return
	 */
	public String getStep1Keyb() {
		String keyb = (String)session.getAttribute("login.step1.keyb");
		if(keyb == null){
			return "";
		}
		return keyb;
	}//end of getStep1Keyb();

	/**
	 * 키보드 보안 사용여부 set(로그인 step1)
	 * @param keyb
	 */
	public void setStep1Keyb(String keyb){
		session.setAttribute("login.step1.keyb", keyb);
	}//end of setStep1Keyb();

	/**
	 * 개인 방화벽 사용여부 return
	 * @return
	 */
	public String getFirw() {
		String firw = (String)session.getAttribute("login.firw");
		if(firw == null){
			return "";
		}
		return firw;
	}//end of getFirw();

	/**
	 * 개인 방화벽 사용여부  set
	 * @param firw
	 */
	public void setFirw(String firw){
		session.setAttribute("login.firw", firw);
	}//end of setFirw();

	/**
	 * 개인 방화벽 사용여부 return(로그인 step1)
	 * @return
	 */
	public String getStep1Firw() {
		String firw = (String)session.getAttribute("login.step1.firw");
		if(firw == null){
			return "";
		}
		return firw;
	}//end of getStep1Firw();

	/**
	 * 개인 방화벽 사용여부  set(로그인 step1)
	 * @param firw
	 */
	public void setStep1Firw(String firw){
		session.setAttribute("login.step1.firw", firw);
	}//end of setStep1Firw();

	/**
	 * 각 Step별로 필수 체크포인트를 입력하고, 체크포인트에 대한 결과값을 저장한다.
	 * @param workgubn
	 * @param Step
	 * @param data
	 */
	public void setStep(String workgubn, int Step, hash<String> data){
		if(data==null){
			session.removeAttribute("workgubn."+workgubn+".Step"+Step);
			session.removeAttribute("workgubn."+workgubn+".Step"+Step+"_time");
		}else{
			if(session==null)		session = req.getSession(true);
			Enumeration<String> names = data.keys();
			while(names.hasMoreElements()){
				String name = names.nextElement();
				session.setAttribute("workgubn."+workgubn+".Step"+Step+"."+name, data.getString(name));
			}
			session.setAttribute("workgubn."+workgubn+".Step"+Step+"_time", String.valueOf(System.currentTimeMillis()));
		}
	}//end of setStep();

	/**
	 * 각 Step별로 필수 체크포인트 처리에 대한 결과값을 가져온다.
	 * @param workgubn
	 * @param Step
	 * @return
	 */
	public hash<String> getStep(String workgubn, int Step){
		hash<String> data = new hash<String>();
		java.util.Enumeration<String> names = session.getAttributeNames();
		String skey = "workgubn."+workgubn+".Step"+Step;
		while(names.hasMoreElements()){
			String name = names.nextElement();
			if(name.startsWith(skey)){
				data.put(name.substring(skey.length()+1), (String)session.getAttribute(name));
			}
		}
		return data;
//		hash<String> data = (hash<String>)session.getAttribute("workgubn."+workgubn+".Step"+Step);
//		if(data==null)		return new hash<String>();
//		else				return data;
	}//end of getStep();

	public long getStepTime(String workgubn, int Step){
		long currentTime = System.currentTimeMillis();
		String prevTime = (String)session.getAttribute("workgubn."+workgubn+".Step"+Step+"_time");
		if(tool.isNull(prevTime)){
			return -1l;
		}else{
			try{
				return currentTime - Long.parseLong(prevTime);
			}catch(NumberFormatException e){
				e.printStackTrace();
				return -1l;
			}catch(Exception e){
				e.printStackTrace();
				return -1l;
			}
		}
	}//end of getStepTime();

	/**
	 * 팝업 사용 여부 return
	 * @return
	 */
	public String getPopup() {
		String popup = (String)session.getAttribute("login.popup");
		if(popup == null){
			return "";
		}
		return popup;
	}//end of getFirw();

	/**
	 * 팝업 사용 여부 set
	 * @param popup
	 */
	public void setPopup(String popup){
		session.setAttribute("login.popup", popup);
	}//end of setPopup();

	/**
	 *
	 * @return
	 */
	public String getMedia() {
		String media = (String)session.getAttribute("login.media");
		if(media == null){
			return "";
		}
		return media;
	}//end of getMedia();

	/**
	 *
	 * @param vald
	 */
	public void setLevel(String level){
		session.setAttribute("login.level", level);
	}//end of setLevel();

	/**
	 *
	 * @return
	 */
	public String getLevel() {
		String level = (String)session.getAttribute("login.level");
		if(level == null){
			return "";
		}
		return level;
	}//end of getLevel();

	/**
	 *
	 * @param vald
	 */
	public void setRetireLevel(String level){
		session.setAttribute("login.retirelevel", level);
	}//end of setLevel();

	/**
	 *
	 * @return
	 */
	public String getRetireLevel() {
		String level = (String)session.getAttribute("login.retirelevel");
		if(level == null){
			return "";
		}
		return level;
	}//end of getLevel();

	/**
	 *
	 * @param vald
	 */
	public void setMemdiv(String memdiv){
		session.setAttribute("login.memdiv", memdiv);
	}//end of setMemdiv();

	/**
	 *
	 * @return
	 */
	public String getMemdiv() {
		String memdiv = (String)session.getAttribute("login.memdiv");
		if(memdiv == null){
			return "";
		}
		return memdiv;
	}//end of getMemdiv();

	/**
	 *
	 * @param vald
	 */
	public void setMedia(String media){
		session.setAttribute("login.media", media);
	}//end of setMedia();

	/**
	 * native 연결 여부 get
	 * @return
	 */
	public String getIsNative() {
		String isNative = (String)session.getAttribute("isNative");
		if(isNative == null){
			return "";
		}
		return isNative;
	}//end of getIsNative();

	/**
	 * native 연결 여부 set
	 * @param isNative
	 */
	public void setIsNative(String isNative){
		session.setAttribute("isNative", isNative);
	}//end of setIsNative();

	/**
	 * MTS 연결 여부 get
	 * @return
	 */
	public String getIsMTS() {
		String isMTS = (String)session.getAttribute("isMTS");
		if(isMTS == null){
			return "";
		}
		return isMTS;
	}//end of getIsMTS();

	/**
	 * MTS 연결 여부 set
	 * @param isMTS
	 */
	public void setIsMTS(String isMTS){
		session.setAttribute("isMTS", isMTS);
	}//end of setIsMTS();

	/**
	 * MTS lite 연결 여부 get
	 * @return
	 */
	public String getMTSLite() {
		String MTSLite = (String)session.getAttribute("MTSLite");
		if(MTSLite == null){
			return "";
		}
		return MTSLite;
	}//end of getMTSLite();

	/**
	 * MTS lite 연결 여부 set
	 * @param MTSLite
	 */
	public void setMTSLite(String MTSLite){
		session.setAttribute("MTSLite", MTSLite);
	}//end of setMTSLite();

	/**
	 * virus check 여부 get
	 * @return
	 */
	public String getVirus() {
		String virus = (String)session.getAttribute("virus");
		if(virus == null){
			return "";
		}
		return virus;
	}//end of getVirus();

	/**
	 * virus check 여부 set
	 * @param virus
	 */
	public void setVirus(String virus){
		session.setAttribute("virus", virus);
	}//end of setVirus();


	/**
	 *
	 * @return
	 */
	public String getMediaCode() {
		String mediaCode = (String)session.getAttribute("mediaCode");
		if(mediaCode == null){
			return "13";
		}
		return mediaCode;
	}//end of getMediaCode();

	/**
	 *
	 * @param mediaCode
	 */
	public void setMediaCode(String mediaCode){
		session.setAttribute("mediaCode", mediaCode);
	}//end of setMediaCode();

	/**
	 *
	 * @return
	 */
	public String getMacAddr() {
		Object mac = session.getAttribute("login.pcinfo");
		if(mac==null){
			return "000000000000";
		}else if(mac instanceof String){
			return ((String)mac).toUpperCase();
		}else{
			return "000000000000";
		}
	}//end of getMacAddr();

	/**
	 *
	 * @param macAddr
	 */
	public void setMacAddr(String macAddr){
		String mediaDiv = getMediaDiv();

		if(!"1".equals(mediaDiv) && !"4".equals(mediaDiv)){
			macAddr = macAddr.replaceAll(":", "");
		}

		session.setAttribute("login.pcinfo", macAddr);
	}//end of setMacAddr();

	/**
	 * piwmsign certloginyn 값 세팅
	 * @return
	 */
	public String getMediaDiv(){
		String certloginyn = getMediaCode();
		if("13".equals(certloginyn)) 		return "0";
		else if("84".equals(certloginyn)) 	return "1";		//iphone
		else if("85".equals(certloginyn)) 	return "2";		//android phone
		else if("87".equals(certloginyn)) 	return "4";		//iPad
		else if("88".equals(certloginyn)) 	return "5";		//android tab
		else return "3";									//ETC Phone 으로 처리
	}//end of getMediaDiv();

	/**
	 * 매체코드 텍스트 값 리턴
	 * @return
	 */
	public String getMediaDivTxt(){
		String certloginyn = getMediaDiv();
		if("0".equals(certloginyn)) 		return SET_PC;
		else if("1".equals(certloginyn)) 	return SET_IPHONE;
		else if("2".equals(certloginyn)) 	return SET_ANDROIDPHONE;
		else if("4".equals(certloginyn)) 	return SET_IPAD;
		else if("5".equals(certloginyn)) 	return SET_ANDROIDPAD;
		else return SET_ETC;

	}//end of getMediaDivTxt();

	/**
	 * acsw1000v에 대한 object를 return
	 * @return
	 */
	public JSONObject getAcsw1000v() {
		JSONObject acsw1000v = (JSONObject)session.getAttribute("acsw1000v");
		if(acsw1000v == null){
			return null;
		}
		return acsw1000v;
	}//end of getAcsw1000v();

	/**
	 * acsw1000v에 대한 object를 set
	 * @param acsw1000v
	 */
	public void setAcsw1000v(JSONObject acsw1000v){
		session.setAttribute("acsw1000v", acsw1000v);
	}//end of setAcsw1000v();

	/**
	 * 보안키패드 암호화키 return
	 * @return
	 */
	public byte[] getKeyPadSKey() {
		byte[] skey;
		try{
			skey = (byte[])session.getAttribute("keyPadSKey");

		}catch(Exception e){
			return null;
		}

		return skey;
	}//end of getKeyPadSKey();

	/**
	 * session으로 부터 String을 return
	 * @param key
	 * @param defValue
	 * @return
	 */
	public String getSessionString(String key, String defValue){
		Object obj = this.session.getAttribute(key);
		if(obj == null)		return defValue;
		else				return obj.toString();
	}

	/**
	 * session으로 부터 String을 return
	 * @param key
	 * @param defValue
	 * @return
	 */
	public String getSessionString(String key){
		Object obj = this.session.getAttribute(key);
		if(obj == null)		return new String();
		else				return obj.toString();
	}

	/**
	 * 고객이 마지막으로 처리한 TR명을 설정한다
	 * @param trName
	 */
	public void setFinalTrExName(String trName){
		this.session.setAttribute("final.trExName", trName);
	}

	public String getFinalTrExName(){
		Object obj = this.session.getAttribute("final.trExName");
		if(obj == null)		return new String();
		else				return obj.toString();
	}

	/**
	 * 고객이 마지막으로 처리한 TR시간을 설정한다
	 * @param trTime
	 */
	public void setFinalTrExTime(){
		this.session.setAttribute("final.trExTime", System.currentTimeMillis());
	}

	public Long getFinalTrExTime(){
		return (Long)this.session.getAttribute("final.trExTime");
	}

	/**
	 * 고유번호 채번 여부 return
	 * @return
	 */
	public String getUqeNoNogYn() {
		String uqeNoNogYn = (String)session.getAttribute("tbst2401u.uqeNoNogYn");
		if(uqeNoNogYn == null){
			return "";
		}
		return uqeNoNogYn;
	}//end of getUqeNoNogYn();

	/**
	 * 고유번호 채번 여부 set
	 * @param uqeNoNogYn
	 */
	public void setUqeNoNogYn(String uqeNoNogYn){
		session.setAttribute("tbst2401u.uqeNoNogYn", uqeNoNogYn);
	}//end of setUqeNoNogYn();

	/**
	 * 이체고유번호 return
	 * @return
	 */
	public String getTrnsUqeNo(){
		String trnsUqeNo = (String)session.getAttribute("tbst2401u.trnsUqeNo");
		if(trnsUqeNo == null){
			return "";
		}
		return trnsUqeNo;
	}//end of getTrnsUqeNo();

	/**
	 * 이체고유번호 set
	 * @param trnsUqeNo
	 */
	public void setTrnsUqeNo(String trnsUqeNo){
		session.setAttribute("tbst2401u.trnsUqeNo", trnsUqeNo);
	}//end of setTrnsUqeNo();

	/**
	 * 추천포트폴리오코드를 세션에 저장한다.
	 * @param rcmd_ptfl_cd
	 */
	public void setRcmdPtflCd(String rcmd_ptfl_cd){
		session.setAttribute("user.rcmd_ptfl_cd", rcmd_ptfl_cd);
	}//end of set

	/**
	 * 추천포트폴리오코드를 세션에서 읽어서 return한다.
	 * @return
	 */
	public String getRcmdPtflCd(){
		return (String)session.getAttribute("user.rcmd_ptfl_cd");
	}//end of getRcmdPtflCd();

	/**
	 * 추천포트폴리오코드명를 세션에 저장한다.
	 * @param rcmd_ptfl_cd_nm
	 */
	public void setRcmdPtflCdNM(String rcmd_ptfl_cd_nm){
		session.setAttribute("user.rcmd_ptfl_cd_nm", rcmd_ptfl_cd_nm);
	}//end of setRcmdPtflCdNM

	/**
	 * 추천포트폴리오코드명를 세션에서 읽어서 return한다.
	 * @return
	 */
	public String getRcmdPtflCdNM(){
		return (String)session.getAttribute("user.rcmd_ptfl_cd_nm");
	}//end of getRcmdPtflCdNM();

	/**
	 * targetId를 세션에 저장한다.
	 * @param targetId
	 */
	public void setTargetId(String targetId){
		session.setAttribute("common.targetId", targetId);
	}//end of setTargetId

	/**
	 * targetId를 세션에서 읽어서 return한다.
	 * @return
	 */
	public String getTargetId(){
		String targetId = getSessionString("common.targetId");
		if(targetId == null){
			return "";
		}
		return targetId;
	}//end of getTargetId();

	/**
	 * 메뉴명을 세션에 저장한다.
	 * @param targetId
	 */
	public void setMenuTitle(String menuTitle){
		session.setAttribute("common.menuTitle", menuTitle);
	}//end of setMenuTitle

	/**
	 * 메뉴명을 세션에서 읽어서 return한다.
	 * @return
	 */
	public String getMenuTitle(){
		String menuTitle = getSessionString("common.menuTitle");
		if(menuTitle == null){
			return "";
		}
		return menuTitle;
	}//end of getMenuTitle();

	/**
	 * 마이자산 상품별 잔고 탭에서 필요한 보유상품리스트
	 * @return
	 */
	public JSONObject getSash0012v(){
		return (JSONObject) session.getAttribute("myBalance.sash0012v");
	}// end of getSash0012v();

	/**
	 * 마이자산 상품별 잔고 탭에서 필요한 보유상품리스트
	 * @param sash0012v
	 */
	public void setSash0012v(JSONObject sash0012v) {
		session.setAttribute("myBalance.sash0012v", sash0012v);
	}// end of setSash0012v();

//-------------- 퇴직연금 관련 세션 start --------------
	/**
     * 퇴직연금 로그인 상태 return
     */
	public String getRetireLoginOK() {
		String loginok = (String)session.getAttribute("login.retireloginok");
		if(loginok == null){
			return "N";
		}
		return loginok;
	}//end of getRetireLoginOK();

	/**
	 * 퇴직연금 로그인 상태 set
	 * @param loginok
	 */
	public void setRetireLoginOK(String loginok){
		session.setAttribute("login.retireloginok", loginok);
	}//end of setRetireLoginOK();

	/**
     * 퇴직연금 팝업창 사용 여부 return
     */
	public String getRetirePopupCk() {
		String popupCk = (String)session.getAttribute("retire.popupCk");
		if(popupCk == null){
			return "";
		}
		return popupCk;
	}//end of getRetirePopupCk();

	/**
	 * 퇴직연금 팝업창 사용 여부 set
	 * @param loginok
	 */
	public void setRetirePopupCk(String popupCk){
		session.setAttribute("retire.popupCk", popupCk);
	}//end of setRetirePopupCk();


	/**
	 * 퇴직연금 로그인 검증 여부 return
	 * @return
	 */
	public String getRetireCertlogin() {
		String certlogin = (String)session.getAttribute("login.retireCertlogin");
		if(certlogin == null){
			return "";
		}
		return certlogin;
	}//end of getRetireCertlogin();

	/**
	 * 퇴직연금 로그인 검증 여부 set
	 * @param certlogin
	 */
	public void setRetireCertlogin(int certlogin){
		setRetireCertlogin(String.valueOf(certlogin));
	}//end of setRetireCertlogin();

	/**
	 * 퇴직연금 로그인 검증 여부 set
	 * @param certlogin
	 */
	public void setRetireCertlogin(String certlogin){
		session.setAttribute("login.retireCertlogin", certlogin);
	}//end of setRetireCertlogin();

	/**
	 *
	 * @return
	 */
	public String getRetireWsUserTc() {
		String wsUserTc = (String) session.getAttribute("retire.wsUserTc");
		if (wsUserTc == null) {
			return new String();
		}
		return wsUserTc;
	}// end of getRetireWsUserTc();

	/**
	 *
	 * @param wsUserTc
	 */
	public void setRetireWsUserTc(String wsUserTc) {
		session.setAttribute("retire.wsUserTc", wsUserTc);
	}// end of setRetireWsUserTc();

	/**
	 *
	 * @return
	 */
	public String getRetireWsUserCertYn() {
		String wsUserCertYn = (String) session
				.getAttribute("retire.wsUserCertYn");
		if (wsUserCertYn == null) {
			return new String();
		}
		return wsUserCertYn;
	}// end of getRetireWsUserCertYn();

	/**
	 *
	 * @param wsUserCertYn
	 */
	public void setRetireWsUserCertYn(boolean wsUserCertYn) {
		session.setAttribute("retire.wsUserCertYn", wsUserCertYn);
	}// end of setRetireWsUserCertYn();

	/**
	 *
	 * @return
	 */
	public boolean isRetireWsUserDnVal() {
		Boolean wsUserDnVal = (Boolean) session.getAttribute("retire.wsUserDnVal");
		if (wsUserDnVal == null) {
			return false;
		}
		return wsUserDnVal;
	}// end of getRetireWsUserDnVal();

	/**
	 *
	 * @param wsUserDnVal
	 */
	public void setRetireWsUserDnVal(String wsUserDnVal) {
		session.setAttribute("retire.wsUserDnVal", wsUserDnVal);
	}// end of setRetireWsUserDnVal();

	/**
	 *
	 * @return
	 */
	public String getRetireWsUserGrade() {
		String wsUserGrade = (String) session.getAttribute("retire.wsUserGrade");
		if (wsUserGrade == null) {
			return new String();
		}
		return wsUserGrade;
	}// end of getRetireWsUserGrade();

	/**
	 *
	 * @param wsUserGrade
	 */
	public void setRetireWsUserGrade(String wsUserGrade) {
		session.setAttribute("retire.wsUserGrade", wsUserGrade);
	}// end of setRetireWsUserGrade();

	/**
	 *
	 * @return
	 */
	public String getRetireWsXChk() {
		String wsXChk = (String) session.getAttribute("retire.wsXChk");
		if (wsXChk == null) {
			return new String();
		}
		return wsXChk;
	}// end of getRetireWsXChk();

	/**
	 *
	 * @param wsXChk
	 */
	public void setRetireWsXChk(String wsXChk) {
		session.setAttribute("retire.wsXChk", wsXChk);
	}// end of setRetireWsXChk();

	/**
	 *
	 * @return
	 */
	public String getRetireWsCorpYn() {
		String wsCorpYn = (String) session.getAttribute("retire.wsCorpYn");
		if (wsCorpYn == null) {
			return new String();
		}
		return wsCorpYn;
	}// end of getRetireWsCorpYn();

	/**
	 *
	 * @param wsCorpYn
	 */
	public void setRetireWsCorpYn(String wsCorpYn) {
		session.setAttribute("retire.wsCorpYn", wsCorpYn);
	}// end of setRetireWsCorpYn();

	/**
	 *
	 * @return
	 */
	public String getRetirePart() {
		String part = (String) session.getAttribute("retire.part");
		if (part == null) {
			return new String();
		}
		return part;
	}// end of getRetirePart();

	/**
	 *
	 * @param part
	 */
	public void setRetirePart(String part) {
		session.setAttribute("retire.part", part);
	}// end of setRetirePart();

	/**
	 *
	 * @return
	 */
	public String getRetireAuthGrpId() {
		String authGrpId = (String) session.getAttribute("retire.authGrpId");
		if (authGrpId == null) {
			return new String();
		}
		return authGrpId;
	}// end of getRetireAuthGrpId();

	/**
	 *
	 * @param authGrpId
	 */
	public void setRetireAuthGrpId(String authGrpId) {
		session.setAttribute("retire.authGrpId", authGrpId);
	}// end of setRetireAuthGrpId();

	/**
	 *
	 * @return
	 */
	public String getRetireOpEmpName() {
		String opEmpName = (String) session.getAttribute("retire.opEmpName");
		if (opEmpName == null) {
			return new String();
		}
		return opEmpName;
	}// end of getRetireOpEmpName();

	/**
	 *
	 * @param opEmpName
	 */
	public void setRetireOpEmpName(String opEmpName) {
		session.setAttribute("retire.opEmpName", opEmpName);
	}// end of setRetireOpEmpName();

	/**
	 *
	 * @return
	 */
	public String getRetireOpDeptName() {
		String opDeptName = (String) session.getAttribute("retire.opDeptName");
		if (opDeptName == null) {
			return new String();
		}
		return opDeptName;
	}// end of getRetireOpDeptName();

	/**
	 *
	 * @param opDeptName
	 */
	public void setRetireOpDeptName(String opDeptName) {
		session.setAttribute("retire.opDeptName", opDeptName);
	}// end of setRetireOpDeptName();

	/**
	 *
	 * @return
	 */
	public String getRetireOpEmpNo() {
		String opEmpNo = (String) session.getAttribute("retire.opEmpNo");
		if (opEmpNo == null) {
			return new String();
		}
		return opEmpNo;
	}// end of getRetireOpEmpNo();

	/**
	 *
	 * @param opEmpNo
	 */
	public void setRetireOpEmpNo(String opEmpNo) {
		session.setAttribute("retire.opEmpNo", opEmpNo);
	}// end of setRetireOpEmpNo();

	/**
	 *
	 * @return
	 */
	public String getRetireWsUserJuminNo() {
		String wsUserJuminNo = (String) session
				.getAttribute("retire.wsUserJuminNo");
		if (wsUserJuminNo == null) {
			return new String();
		}
		return wsUserJuminNo;
	}// end of getRetireWsUserJuminNo();

	/**
	 *
	 * @param wsUserJuminNo
	 */
	public void setRetireWsUserJuminNo(String wsUserJuminNo) {
		session.setAttribute("retire.wsUserJuminNo", wsUserJuminNo);
	}// end of setRetireWsUserJuminNo();

	/**
	 *
	 * @return
	 */
	public String getRetireWsUserContNo() {
		String wsUserContNo = (String) session
				.getAttribute("retire.wsUserContNo");
		if (wsUserContNo == null) {
			return new String();
		}
		return wsUserContNo;
	}// end of getRetireWsUserContNo();

	/**
	 *
	 * @param wsUserContNo
	 */
	public void setRetireWsUserContNo(String wsUserContNo) {
		session.setAttribute("retire.wsUserContNo", wsUserContNo);
	}// end of setRetireWsUserContNo();

	/**
	 *
	 * @return
	 */
	public String getRetireWsUserPlanTc() {
		String wsUserPlanTc = (String) session
				.getAttribute("retire.wsUserPlanTc");
		if (wsUserPlanTc == null) {
			return new String();
		}
		return wsUserPlanTc;
	}// end of getRetireWsUserPlanTc();

	/**
	 *
	 * @param wsUserPlanTc
	 */
	public void setRetireWsUserPlanTc(String wsUserPlanTc) {
		session.setAttribute("retire.wsUserPlanTc", wsUserPlanTc);
	}// end of setRetireWsUserPlanTc();

	/**
	 *
	 * @return
	 */
	public String getRetireWsSubContNo() {
		String wsSubContNo = (String) session.getAttribute("retire.wsSubContNo");
		if (wsSubContNo == null) {
			return new String();
		}
		return wsSubContNo;
	}// end of getRetireWsSubContNo();

	/**
	 *
	 * @param wsSubContNo
	 */
	public void setRetireWsSubContNo(String wsSubContNo) {
		session.setAttribute("retire.wsSubContNo", wsSubContNo);
	}// end of setRetireWsSubContNo();

	/**
	 *
	 * @return
	 */
	public String getRetireWsEnmnCno() {
		String wsEnmnCno = (String) session.getAttribute("retire.wsEnmnCno");
		if (wsEnmnCno == null) {
			return new String();
		}
		return wsEnmnCno;
	}// end of getRetireWsEnmnCno();

	/**
	 *
	 * @param wsEnmnCno
	 */
	public void setRetireWsEnmnCno(String wsEnmnCno) {
		session.setAttribute("retire.wsEnmnCno", wsEnmnCno);
	}// end of setRetireWsEnmnCno();

	/**
	 *
	 * @return
	 */
	public String getRetireRbno() {
		String rbno = (String) session.getAttribute("retire.rbno");
		if (rbno == null) {
			return new String();
		}
		return rbno;
	}// end of getRetireRbno();

	/**
	 *
	 * @param rbno
	 */
	public void setRetireRbno(String rbno) {
		session.setAttribute("retire.rbno", rbno);
	}// end of setRetireRbno();

	/**
	 *
	 * @return
	 */
	public String getRetireContractYmd() {
		String contractYmd = (String) session.getAttribute("retire.contractYmd");
		if (contractYmd == null) {
			return new String();
		}
		return contractYmd;
	}// end of getRetireContractYmd();

	/**
	 *
	 * @param contractYmd
	 */
	public void setRetireContractYmd(String contractYmd) {
		session.setAttribute("retire.contractYmd", contractYmd);
	}// end of setRetireContractYmd();

	/**
	 *
	 * @return
	 */
	public String getRetirePlanKindC() {
		String planKindC = (String) session.getAttribute("retire.planKindC");
		if (planKindC == null) {
			return new String();
		}
		return planKindC;
	}// end of getRetirePlanKindC();

	/**
	 *
	 * @param planKindC
	 */
	public void setRetirePlanKindC(String planKindC) {
		session.setAttribute("retire.planKindC", planKindC);
	}// end of setRetirePlanKindC();

	/**
	 *
	 * @return
	 */
	public String getRetireMpWrapYn() {
		String mpWrapYn = (String) session.getAttribute("retire.mpWrapYn");
		if (mpWrapYn == null) {
			return new String();
		}
		return mpWrapYn;
	}// end of getRetireMpWrapYn();

	/**
	 *
	 * @param mpWrapYn
	 */
	public void setRetireMpWrapYn(String mpWrapYn) {
		session.setAttribute("retire.mpWrapYn", mpWrapYn);
	}// end of setRetireMpWrapYn();

	/**
	 *
	 * @return
	 */
	public JSONObject getRetirePlanList() {
		JSONObject planList = (JSONObject) session.getAttribute("retire.planList");
		if (planList == null) {
			return new JSONObject();
		}
		return planList;
	}// end of getRetirePlanList();

	/**
	 *
	 * @param planList
	 */
	public void setRetirePlanList(JSONObject planList) {
		session.setAttribute("retire.planList", planList);
	}// end of setRetirePlanList();

	/**
	 *
	 * @return rksz1300u
	 */
	public JSONObject getRksz1300u() {
		return getRetirePlanList();
	}// end of getRksz1300u();

	public String getRksz1300uList0Data(String fieldNM){
		if(tool.isNull(fieldNM))	return "";

		JSONObject obj = this.getRetirePlanList();
		try{
			if(obj.get("list1")==null) return "";

			return  ((JSONObject)((JSONArray)obj.get("list1")).get(0)).getString(fieldNM);
		}catch(Exception e){
			return "";
		}
	}

	/**
	 *
	 * @return
	 */
	public String getRksz1300uMpYnAndPKC(){
		try{
			String mp_yn 		= getRetireMpWrapYn();
			String plan_kind_c 	= getRetirePlanKindC();

			if(tool.isNull(mp_yn)||tool.isNull(plan_kind_c)){
				return "N";
			}

			if("N".equals(mp_yn)){
				if("1".equals(plan_kind_c))	return RETIRE_LOGIN_N1;
				if("2".equals(plan_kind_c))	return RETIRE_LOGIN_N2;
				if("3".equals(plan_kind_c))	return RETIRE_LOGIN_N3;
				if("4".equals(plan_kind_c))	return RETIRE_LOGIN_N4;

				return "N";
			}else if("Y".equals(mp_yn)){
				if("2".equals(plan_kind_c))	return RETIRE_LOGIN_Y2;
				if("3".equals(plan_kind_c))	return RETIRE_LOGIN_Y3;
				if("4".equals(plan_kind_c))	return RETIRE_LOGIN_Y4;

				return "N";
			}
		}catch(Exception e){
			return "";
		}

		return "";
	}//end of getRksz1300uMpYnAndPKC();

	/**
	 *
	 * @return
	 */
	public String getRetireCertYn() {
		String certYn = (String) session.getAttribute("retire.certYn");
		if (certYn == null) {
			return new String();
		}
		return certYn;
	}// end of getRetireCertYn();

	/**
	 *
	 * @param plan_kind_list
	 */
	public void setPlan_kind_list(String plan_kind_list) {
		session.setAttribute("retire.plan_kind_list", plan_kind_list);
	}// end of setPlan_kind_list();

	/**
	 *
	 * @return
	 */
	public String getPlan_kind_list() {
		String plan_kind_list = (String) session.getAttribute("retire.plan_kind_list");
		if (plan_kind_list == null) {
			return new String();
		}
		return plan_kind_list;
	}// end of getPlan_kind_list();

	/**
	 *
	 * @return
	 */
	public String getAprc_abl_yn() {
		String aprc_abl_yn = (String) session.getAttribute("retire.aprc_abl_yn");
		if (aprc_abl_yn == null) {
			return new String();
		}
		return aprc_abl_yn;
	}// end of getPlan_kind_list();

	/**
	 *
	 * @param certYn
	 */
	public void setAprc_abl_yn(String aprc_abl_yn) {
		session.setAttribute("retire.aprc_abl_yn", aprc_abl_yn);
	}// end of setRetireCertYn();

	/**
	 *
	 * @param certYn
	 */
	public void setRetireCertYn(String certYn) {
		session.setAttribute("retire.certYn", certYn);
	}// end of setRetireCertYn();

//-------------- 퇴직연금 관련 세션 end --------------
	/**
	 * 고객핸드폰번호 return
	 * @return
	 */
	public String getPhoneNumber() {
		String stime = (String)session.getAttribute("userPhoneNum");
		if(stime == null){
			return "";
		}
		return stime;
	}//end of getPhoneNumber();

	/**
	 * 고객핸드폰번호 set
	 * @param stime
	 */
	public void setPhoneNumber(String phoneNum){
		session.setAttribute("userPhoneNum", phoneNum);
	}//end of setPhoneNumber();
	//-------------------------- session information get/set end--------------------------



	//-------------------------- request로부터 특별한 패턴의 값 추출 start--------------------------

	/**
	 * 공인인증 로그를 남기기위해 고객 id를 추출
	 * 공인인증 페이지로 부터 넘어오는 param 패턴(usid, userid, hts_id)
	 */
	public String getCertIssueUsid(){
		String returnId = "";
		if(!tool.isNull(getString("usid")))	return getString("usid");
		else if(!tool.isNull(getString("userid")))	return getString("userid");
		else if(!tool.isNull(getString("hts_id")))	return getString("hts_id");

		return returnId;
	}

	//-------------------------- request로부터 특별한 패턴의 값 추출 end--------------------------

	/**
	 * request
	 */
	public void setValue(){

	}

	/**
	 * 주어진 url로 이동한다.
	 * @param url
	 */
	public void forward(String url){
		if(tool.isNull(url))	url = "/index.jsp";
		try{
			req.getRequestDispatcher(url).forward(req, res);
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of forward();

	/**
	 * 주어진 url로 이동한다.
	 * @param url
	 */
	public void redirect(String url){
		if(tool.isNull(url))	url = "/index.jsp";
		try{
			res.sendRedirect(url);
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of forward();

	/**
	 * Parameter를 찾아서 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public abstract String getParameter(String key, String defaultValue);

	/**
	 * Parameter를 찾아서 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public String getParameter(String key){
		return this.getParameter(key, new String());
	}//end of getParameter();

	/**
	 * Parameter Name을 String Array type으로 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public Enumeration<String> getParameterNames(){
		return req.getParameterNames();
	}

	/**
	 * Parameter를 String Array type으로 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public abstract String[] getParameterValues(String key, String[] defaultValue);

	/**
	 * Parameter를 String Array type으로 return한다.
	 * @param key
	 * @return
	 */
	public String[] getParameterValues(String key){
		return this.getParameterValues(key, null);
	}//end of getParameterValues();

	/**
	 * Attribute에 값이 있으면 Attribute에 있는 값을, 없으면 Parameter에서 찾아서 return한다.
	 */
	public String getString(String key, String defaultValue) {
		if(tool.isNull(key))		return defaultValue;
		String attribute = this.getAttValue(key, null);
		if(attribute==null)			return this.getParameter(key, defaultValue);
		else						return attribute;
	}//end of getString();

	/**
	 * 값이
	 * @param key
	 * @return
	 */
	public boolean isNull(String key){
		String[] val = this.getParameterValues(key);
		if(val==null)		return true;
		else				return false;
	}//end of isNull();

	/**
	 * key에 해당하는 value를 찾아서 String type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public String getString(String key){
		return this.getString(key, new String());
	}//end of getString();

	/**
	 * key에 해당하는 value를 찾아서 int type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public int getInt(String key, int defaultValue){
		try{
			return Integer.parseInt(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getInt();

	/**
	 * key에 해당하는 value를 찾아서 int type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public int getInt(String key){
		return this.getInt(key, 0);
	}//end of getInt();

	/**
	 * key에 해당하는 value를 찾아서 byte type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public byte getByte(String key, byte defaultValue){
		try{
			return Byte.parseByte(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getInt();

	/**
	 * key에 해당하는 value를 찾아서 byte type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public byte getByte(String key){
		return this.getByte(key, (byte)0);
	}//end of getInt();

	/**
	 * key에 해당하는 value를 찾아서 long type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public long getLong(String key, long defaultValue){
		try{
			return Long.parseLong(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getLong();


	/**
	 * key에 해당하는 value를 찾아서 long type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public long getLong(String key){
		return this.getLong(key, 0l);
	}//end of getLong();

	/**
	 * key에 해당하는 value를 찾아서 boolean type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public boolean getBoolean(String key, boolean defaultValue){
		try{
			return Boolean.parseBoolean(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getLong();


	/**
	 * key에 해당하는 value를 찾아서 boolean type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public boolean getBoolean(String key){
		return this.getBoolean(key, true);
	}//end of getLong();

	/**
	 * key에 해당하는 value를 찾아서 float type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public float getFloat(String key, float defaultValue){
		try{
			return Float.parseFloat(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getFloat();

	/**
	 * key에 해당하는 value를 찾아서 int type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public float getFloat(String key){
		return this.getFloat(key, 0f);
	}//end of getFloat();

	/**
	 * key에 해당하는 value를 찾아서 double type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public double getDouble(String key, double defaultValue){
		try{
			return Double.parseDouble(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getDouble();

	/**
	 * key에 해당하는 value를 찾아서 double type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public double getDouble(String key){
		return this.getDouble(key, 0d);
	}//end of getDouble();

	/**
	 * key에 해당하는 value를 찾아서 byte[] type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public byte[] getBytes(String key, byte[] defaultValue){
		String value = this.getString(key, null);
		if(value==null)		return defaultValue;
		else				return value.getBytes();
	}//end of getBytes();

	/**
	 * key에 해당하는 value를 찾아서 byte[] type으로 return한다.
	 * 유형에 따라 parameter, MultipartRequest, Xml의 value를 return한다.
	 * @param key
	 * @param enc Encoding Type
	 * @param defaultValue
	 * @return
	 */
	public byte[] getBytes(String key, String enc, byte[] defaultValue){
		String value = this.getString(key, null);
		try{
			if(value==null)		return defaultValue;
			else				return value.getBytes(enc);
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getBytes();

	/**
	 * Client PC의 공인IP를 000000000000 형태로 가져온다.
	 * @return
	 */
	public String getClientIP(){
		String ip = this.req.getRemoteAddr();
		if(ip.indexOf(".")<0){
			return ip;
		}else{
			StringBuffer usip = new StringBuffer();
			StringTokenizer st = new StringTokenizer(ip, ".");
			while(st.hasMoreTokens()){
				usip.append(tool.fillChar(st.nextToken(), 3, '0', tool.LEFT));
			}
			return usip.toString();
		}
	}//end of getClientIP();

	/**
	 * key에 해당하는 Attribute를 get한다.
	 */
	public Object getAttribute(String key) {
		return this.getAttribute(key, null);
	}//end of getAttribute();

	/**
	 * key에 해당하는 Attribute를 get한다.
	 */
	public Object getAttribute(String key, Object defaultValue) {
		if(tool.isNull(key))		return defaultValue;
		Object obj = this.req.getAttribute(key);
		if(obj==null)		return defaultValue;
		else				return obj;
	}//end of getAttribute();

	/**
	 * key에 해당하는 Attribute를 remove시킨다.
	 */
	public void removeAttribute(String key) {
		if(!tool.isNull(key)){
			this.req.removeAttribute(key);
		}
	}//end of removeAttribute();

	/**
	 * key에 해당하는 Object를 set한다.
	 * @param key
	 * @param value
	 */
	public void setAttribute(String key, Object value) {
		if(tool.isNull(key))		return;
		if(value==null)				this.req.removeAttribute(key);
		else						this.req.setAttribute(key, value);
	}//end of setAttribute();

	/**
	 * key에 해당하는 String을 set한다.
	 * @param key
	 * @param value
	 */
	public void setString(String key, String value) {
		if(tool.isNull(key))		return;
		if(value==null)				this.req.removeAttribute(key);
		else						this.req.setAttribute(key, value);
	}//end of setString();

	/**
	 * Attribute Name을 return한다.
	 * @return
	 */
	public Enumeration<String> getAttributeNames() {
		return this.req.getAttributeNames();
	}//end of getAttributeNames();

	/**
	 * Attribute를 String type으로 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public String getAttValue(String key, String defaultValue){
		if(tool.isNull(key))		return defaultValue;
		Object value = this.getAttribute(key);
		if(value==null||!(value instanceof String)){
			return defaultValue;
		}else{
			return (String)value;
		}
	}//end of getAttValue();

	/**
	 * Attribute를 String type으로 return한다.
	 * @param key
	 * @return
	 */
	public String getAttValue(String key){
		return this.getAttValue(key, new String());
	}//end of getAttValue();

	/**
	 * Attribute를 String Array type으로 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public String[] getAttValues(String key, String[] defaultValue){
		if(tool.isNull(key))		return defaultValue;
		Object value = this.getAttribute(key);
		if(value==null||!(value instanceof String[])){
			return defaultValue;
		}else{
			return (String[])value;
		}
	}//end of getAttValues();

	/**
	 * Attribute를 String Array type으로 return한다.
	 * @param key
	 * @return
	 */
	public String[] getAttValues(String key){
		return this.getAttValues(key, null);
	}//end of getAttValues();

	/**
	 * Attribute를 String Array type으로 return한다.
	 * @param key
	 * @return
	 */
	public Map<String, String[]> getParameterMap(){
		Map<String, String[]> map = req.getParameterMap();
		return map;
	}//end of getAttValues();

	/**
	 * request에 cross-site-script관련캐릭터(<,>,",')가 있으면 true, 없으면 false
	 */
	public boolean isRequestXSS(String key){
		try{
			if(tool.isNull(key))	return false;

			String param = this.getString(key);
			return isXSS(param);
		}catch(Exception e){
			return false;
		}
	}//end of isRequestXSS();

	/**
	 * param에 cross-site-script관련캐릭터(<,>,",')가 있으면 true, 없으면 false
	 */
	public boolean isXSS(String param){
		try{
			if(tool.isNull(param))	return false;

			Pattern p = Pattern.compile("(<|>|\"|\')");
			Matcher m = p.matcher(param);

			if(m.find())	return true;
		}catch(Exception e){
			return false;
		}

		return false;
	}//end of isXSS();

	/**
	 * request에 cross-site-script관련캐릭터(<,>,",')가 있으면 html code로 변환해서 반환
	 * replaceNull이 true인 경우는 공백으로 변환후 반환
	 */
	public String getStringXSS(String key){
		return getStringXSS(key, false);
	}//end of getStringXSS();

	public String getStringXSS(String key, boolean replaceNull){
		try{
			String param = this.getString(key);
			return replaceStringXSS(param, replaceNull);
		}catch(Exception e){
			return "";
		}
	}//end of getStringXSS();

	public String getStringXSS(String key, String defaultValue){
		String val = this.getStringXSS(key);
		if(tool.isNull(val))		return defaultValue;
		else						return val;
	}//end of getStringXSS();

	/**
	 * param에 cross-site-script관련캐릭터(<,>,",')가 있으면 html code로 변환해서 반환
	 */
	public String replaceStringXSS(String param){
		return replaceStringXSS(param, false);
	}//end of replaceStringXSS();

	public String replaceStringXSS(String param, boolean replaceNull){
		try{
			if(tool.isNull(param))	return "";

			if(replaceNull){
				param = param.replaceAll("<", "");
				param = param.replaceAll(">", "");
				param = param.replaceAll("\"", "");
				param = param.replaceAll("\'", "");
			}else{
				param = param.replaceAll("<", "&lt;");
				param = param.replaceAll(">", "&gt;");
				param = param.replaceAll("\"", "&quot;");
				param = param.replaceAll("\'", "&#39;");
			}

			return param;
		}catch(Exception e){
			return "";
		}
	}//end of replaceStringXSS();
	//--------------------------------- HttpServletRequest 관련 Method ------------------------------

	/**
	 * HttpServletRequest의 getCharacterEncoding Method.
	 * @return
	 */
	public String getCharacterEncoding() {
		return this.req.getCharacterEncoding();
	}//end of getCharacterEncoding();

	/**
	 * HttpServletRequest의 getCharacterEncoding Method.
	 * @return
	 */
	public int getContentLength() {
		return this.req.getContentLength();
	}//end of getContentLength();

	/**
	 * HttpServletRequest의 getContentType Method
	 * @return
	 */
	public String getContentType() {
		return this.req.getContentType();
	}//end of getContentType();

	/**
	 * HttpServletRequest의 getInputStream Method
	 * @return
	 * @throws IOException
	 */
	public ServletInputStream getInputStream() throws IOException {
		return this.req.getInputStream();
	}//end of getInputStream();

	/**
	 * HttpServletRequest의 getLocale Method
	 * @return
	 */
	public Locale getLocale() {
		return this.req.getLocale();
	}//end of getLocale();

	/**
	 * HttpServletRequest의 getLocales Method
	 * @return
	 */
	public Enumeration<Locale> getLocales() {
		return this.req.getLocales();
	}//end of getLocales();

	/**
	 * HttpServletRequest의 getProtocol Method
	 * @return
	 */
	public String getProtocol() {
		return this.req.getProtocol();
	}//end of getProtocol();

	/**
	 * HttpServletRequest의 getReader Method
	 * @return
	 * @throws IOException
	 */
	public BufferedReader getReader() throws IOException {
		return this.req.getReader();
	}//end of getReader();

	/**
	 * HttpServletRequest의 getRealPath Method
	 * @return
	 * @throws IOException
	 * @deprecated
	 */
	public String getRealPath(String arg0) {
		return this.req.getRealPath(arg0);
	}//end of getRealPath();

	/**
	 * HttpServletRequest의 getRemoteAddr Method
	 * @return
	 * @throws IOException
	 */
	public String getRemoteAddr() {
		return this.req.getRemoteAddr();
	}//end of getRemoteAddr();

	/**
	 * 1호기/2호기 접속 구분을 return한다.
	 * PC IP가 짝수이면 1호기, 홀수이면 2호기로 분배한다.
	 */
	public char getBranch(){
		String usip = this.getRemoteAddr();
		char idx = usip.charAt(usip.length()-1);
		switch(idx){
			case '0' :
			case '2' :
			case '4' :
			case '6' :
			case '8' :
				return '1';
			default :
				return '2';
		}
	}//end of getBranch();

	/**
	 * next branch return
	 * @return
	 */
	public char getNextBranch(){
		if(this.getBranch()=='1')		return '2';
		else							return '1';
	}//end of getNextBranch();

	/**
	 * HttpServletRequest의 getRemoteHost Method
	 * @return
	 */
	public String getRemoteHost() {
		return this.req.getRemoteHost();
	}//end of getRemoteHost();

	/**
	 * 접속 유형 코드 반환
	 * PC : 0, 모바일 : 1
	 * @return
	 */
	public int getConnectCode(){
		String userAgent = req.getHeader("user-agent");
		if((userAgent.indexOf("iPhone") > -1) ||(userAgent.indexOf("iPod") > -1) ||(userAgent.indexOf("iPad") > -1)
				||(userAgent.indexOf("BlackBerry") > -1) ||(userAgent.indexOf("Android") > -1)
				||(userAgent.indexOf("Windows CE") > -1) ||(userAgent.indexOf("LG") > -1&&userAgent.indexOf("MALGJS")<0)
				||(userAgent.indexOf("MOT") > -1) ||(userAgent.indexOf("SAMSUNG") > -1) ||(userAgent.indexOf("SonyEricsson") > -1)){
			return CONN_MOBILE;
		}

		return CONN_PC;
	}

	/**
	 * 단말 코드 반환
	 * iphone : 0, ipad : 1, android phone : 2, android pad : 3, etcphone : 4, pc : 5
	 * @return
	 */
	public int getTerminalCode(){
		String userAgent = req.getHeader("user-agent").toLowerCase();

		if(userAgent.indexOf("iphone") != -1 || userAgent.indexOf("ipod") != -1){
			return T_IPHONE;
		}else if(userAgent.indexOf("ipad") != -1){
			return T_IPAD;
		}else if(userAgent.indexOf("android") != -1){
			if(userAgent.indexOf("mobile") != -1 || userAgent.indexOf("gt-i9200") != -1 ){
				return T_ANDROIDPHONE;
			}else{
				return T_ANDROIDPAD;
			}
		}else if(userAgent.indexOf("nexus 7") != -1 ||
				userAgent.indexOf("blackberry") != -1 ||
				userAgent.indexOf("windows ce") != -1 ||
				userAgent.indexOf("iemoblie") != -1 ||
				userAgent.indexOf("windows phone") != -1){
				return T_ETCPHONE;
		}else{
			return T_PC;
		}
	}

	/**
	 * browser 코드 반환
	 * ie : 0, chrome : 1, safari : 2, firefox : 3, opera : 4
	 * @return
	 */
	public int getBrowserCode(){
		String userAgent = req.getHeader("user-agent").toLowerCase();
		if(userAgent.indexOf("msie") > -1)			return	BROWSER_IE;
		else if(userAgent.indexOf("chrome") > -1)	return	BROWSER_CHROME;
		else if(userAgent.indexOf("safari") > -1)	return	BROWSER_SAFARI;
		else if(userAgent.indexOf("firefox") > -1)	return	BROWSER_FIREFOX;
		else if(userAgent.indexOf("opera") > -1)	return	BROWSER_OPERA;

		return BROWSER_IE;
	}

	/**
	 * HttpServletRequest의 getRequestDispathcer Method
	 * @param arg0
	 * @return
	 */
	public RequestDispatcher getRequestDispatcher(String arg0) {
		return this.req.getRequestDispatcher(arg0);
	}//end of getRequestDispatcher();

	/**
	 * HttpServletRequest의 getScheme Method
	 * @return
	 */
	public String getScheme() {
		return this.req.getScheme();
	}//end of getScheme();

	/**
	 * HttpServletRequest의 getServerName Method
	 * @return
	 */
	public String getServerName() {
		return this.req.getServerName();
	}//end of getServerName();

	/**
	 * HttpServletRequest의 getServerPort Method
	 * @return
	 */
	public int getServerPort() {
		return this.req.getServerPort();
	}//end of getServerPort();

	/**
	 * HttpServletRequest의 isSecure Method
	 * @return
	 */
	public boolean isSecure() {
		return this.req.isSecure();
	}//end of isSecure();

	/**
	 * HttpServletRequest의 setCharacterEncoding Method
	 * @param arg0
	 * @throws UnsupportedEncodingException
	 */
	public void setCharacterEncoding(String arg0) throws UnsupportedEncodingException {
		this.req.setCharacterEncoding(arg0);
	}//end of setCharacterEncoding();

	/**
	 * HttpServletRequest의 getAuthType method
	 * @return
	 */
	public String getAuthType() {
		return this.req.getAuthType();
	}//end of getAuthType();

	/**
	 * HttpServletRequest의 getContextPath Method
	 * @return
	 */
	public String getContextPath() {
		return this.req.getContextPath();
	}//end of getContenxtPath();

	/**
	 * HttpServletRequest의 getCookies Method
	 * @return
	 */
	public Cookie[] getCookies() {
		return this.req.getCookies();
	}//end of getCookies();

	/**
	 * HttpServletRequest의 getDateHeader Method
	 * @param arg0
	 * @return
	 */
	public long getDateHeader(String arg0) {
		return this.req.getDateHeader(arg0);
	}//end of getDateHeader();

	/**
	 * HttpServletRequest의 getHeader Method
	 * @param arg0
	 * @return
	 */
	public String getHeader(String arg0) {
		return this.req.getHeader(arg0);
	}//end of getHeader();

	/**
	 * HttpServletRequest의 getHeaderNames Method
	 * @return
	 */
	public Enumeration<String> getHeaderNames() {
		return this.req.getHeaderNames();
	}//end of getHeaderNames();

	/**
	 * HttpServletRequest의 getHeaders Method
	 * @param arg0
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public Enumeration getHeaders(String arg0) {
		return this.req.getHeaders(arg0);
	}//end of getHeaders();

	/**
	 * HttpServletRequest의 getIntHeader Method
	 * @param arg0
	 * @return
	 */
	public int getIntHeader(String arg0) {
		return this.req.getIntHeader(arg0);
	}//end of getIntHeader();

	/**
	 * HttpServletRequest의 getMethod Method
	 * @return
	 */
	public String getMethod() {
		return this.req.getMethod();
	}//end of getMethod();

	/**
	 * HttpServletRequest의 getPathInfo Method
	 * @return
	 */
	public String getPathInfo() {
		return this.req.getPathInfo();
	}//end of getPathInfo();

	/**
	 * HttpServletRequest의 getPathTranslated Method
	 * @return
	 */
	public String getPathTranslated() {
		return this.req.getPathTranslated();
	}//end of getPathTranslated();

	/**
	 * HttpServletRequest의 getQueryString Method
	 * @return
	 */
	public String getQueryString() {
		return this.req.getQueryString();
	}//end of getQueryString();

	/**
	 * HttpServletRequest의 getRemoteUser Method
	 * @return
	 */
	public String getRemoteUser() {
		return this.req.getRemoteUser();
	}//end of getRemoteUser();

	/**
	 * HttpServletRequest의 getRequestURI Method
	 * @return
	 */
	public String getRequestURI() {
		return this.req.getRequestURI();
	}//end of getRequestURI();

	/**
	 * HttpServletRequest의 getRequestURL Method
	 * @return
	 */
	public StringBuffer getRequestURL() {
		return this.req.getRequestURL();
	}//end of getRequestURL();

	/**
	 * HttpServletRequest의 getRequestedSessionId Method
	 * @param arg0
	 * @return
	 */
	public String getRequestedSessionId() {
		return this.req.getRequestedSessionId();
	}//end of getRequestedSessionId();

	/**
	 * HttpServletRequest의 getDateHeader Method
	 * @return
	 */
	public String getServletPath() {
		return this.req.getServletPath();
	}//end of getServletPath();

	/**
	 * HttpServletRequest의 getSession Method
	 * @param arg0
	 * @return
	 */
	public HttpSession getSession(boolean arg0) {
		return this.req.getSession(arg0);
	}//end of getSession();

	/**
	 * HttpServletRequest의 getUserPrincipal Method
	 * @return
	 */
	public Principal getUserPrincipal() {
		return this.req.getUserPrincipal();
	}//end of getUserPrincipal();

	/**
	 * HttpServletRequest의 isRequestedSessionIdFromCookie Method
	 * @return
	 */
	public boolean isRequestedSessionIdFromCookie() {
		return this.req.isRequestedSessionIdFromCookie();
	}//end of isRequestedSessionIdFromCookie();

	/**
	 * HttpServletRequest의 isRequestedSessionIdFromCookie Method
	 * @return
	 */
	public boolean isRequestedSessionIdFromURL() {
		return this.req.isRequestedSessionIdFromCookie();
	}//end of isRequestedSessionIdFromCookie();

	/**
	 * HttpServletRequest의 isRequestedSessionIdFromUrl Method
	 * @return
	 * @deprecated
	 */
	public boolean isRequestedSessionIdFromUrl() {
		return this.req.isRequestedSessionIdFromUrl();
	}//end of isRequestedSessionIdFromUrl();

	/**
	 * HttpServletRequest의 isRequestedSessionIdValid Method
	 * @return
	 */
	public boolean isRequestedSessionIdValid() {
		return this.req.isRequestedSessionIdValid();
	}//end of isRequestedSessionIdValid();

	/**
	 * HttpServletRequest의 isUserInRole Method
	 * @param arg0
	 * @return
	 */
	public boolean isUserInRole(String arg0) {
		return this.req.isUserInRole(arg0);
	}//en dof isUserInRole();

	//--------------------------------- HttpServletResponse 관련 Method ------------------------------

	/**
	 * HttpServletResponse의 flushBuffer Method
	 */
	public void flushBuffer() throws IOException {
		this.res.flushBuffer();
	}//end of flushBuffer();

	/**
	 * HttpServletResponse의 getBufferSize Method
	 * @param arg0
	 * @return
	 */
	public int getBufferSize() {
		return this.res.getBufferSize();
	}//end of getBufferSize();

	/**
	 * HttpServletResponse의 getOutputStream Method
	 * @param arg0
	 * @return
	 */
	public ServletOutputStream getOutputStream() throws IOException {
		return this.res.getOutputStream();
	}//end of getOutputStream();

	/**
	 * HttpServletResponse의 getWriter Method
	 * @param arg0
	 * @return
	 */
	public PrintWriter getWriter() throws IOException {
		return this.res.getWriter();
	}//end of getWriter();

	/**
	 * HttpServletResponse의 isCommitted Method
	 * @param arg0
	 * @return
	 */
	public boolean isCommitted() {
		return this.res.isCommitted();
	}//end of isCommitted();

	/**
	 * HttpServletResponse의 reset Method
	 * @param arg0
	 * @return
	 */
	public void reset() {
		this.res.reset();
	}//end of reset();

	/**
	 * HttpServletResponse의 resetBuffer Method
	 * @param arg0
	 * @return
	 */
	public void resetBuffer() {
		this.res.resetBuffer();
	}//end of resetBuffer();

	/**
	 * HttpServletResponse의 setBufferSize Method
	 * @param arg0
	 */
	public void setBufferSize(int arg0) {
		this.res.setBufferSize(arg0);
	}//end of setBufferSize();

	/**
	 * HttpServletResponse의 setContentLength Method
	 * @param arg0
	 */
	public void setContentLength(int arg0) {
		this.res.setContentLength(arg0);
	}//end of setContentLength();

	/**
	 * HttpServletResponse의 setContentType Method
	 * @param arg0
	 */
	public void setContentType(String arg0) {
		this.res.setContentType(arg0);
	}//end of setContentType();

	/**
	 * HttpServletResponse의 setLocale Method
	 * @param arg0
	 */
	public void setLocale(Locale arg0) {
		this.res.setLocale(arg0);
	}//end of setLocale();

	/**
	 * HttpServletResponse의 addCookie Method
	 * @param arg0
	 * @return
	 */
	public void addCookie(Cookie arg0) {
		this.res.addCookie(arg0);
	}//end of addCookie();

	/**
	 * HttpServletResponse의 addDateHeader Method
	 * @param arg0
	 * @param arg1
	 * @return
	 */

	public void addDateHeader(String arg0, long arg1) {
		this.res.addDateHeader(arg0, arg1);
	}//end of addDateHeader();

	/**
	 * HttpServletResponse의 addHeader Method
	 * @param arg0
	 * @param arg1
	 * @return
	 */

	public void addHeader(String arg0, String arg1) {
		this.res.addHeader(arg0, arg1);
	}//end of addHeader();

	/**
	 * HttpServletResponse의 addIntHeader Method
	 * @param arg0
	 * @return
	 */
	public void addIntHeader(String arg0, int arg1) {
		this.res.addIntHeader(arg0, arg1);
	}//end of addIntHeader();

	/**
	 * HttpServletResponse의 containsHeader Method
	 * @param arg0
	 * @return
	 */
	public boolean containsHeader(String arg0) {
		return this.res.containsHeader(arg0);
	}//end of containsHeader();

	/**
	 * HttpServletResponse의 encodeRedirectURL Method
	 * @param arg0
	 * @return
	 */
	public String encodeRedirectURL(String arg0) {
		return this.res.encodeRedirectURL(arg0);
	}//end of encodeRedirectURL();

	/**
	 * HttpServletResponse의 encodeRedirectUrl Method
	 * @param arg0
	 * @return
	 * @deprecated
	 */
	public String encodeRedirectUrl(String arg0) {
		return this.res.encodeRedirectUrl(arg0);
	}//end of encodeRedirectUrl();

	/**
	 * HttpServletResponse의 encodeURL Method
	 * @param arg0
	 * @return
	 */
	public String encodeURL(String arg0) {
		return this.res.encodeURL(arg0);
	}//end of encodeURL();

	/**
	 * HttpServletResponse의 encodeUrl Method
	 * @param arg0
	 * @return
	 * @deprecated
	 */
	public String encodeUrl(String arg0) {
		return this.res.encodeUrl(arg0);
	}//end of encodeUrl();

	/**
	 * HttpServletResponse의 sendError Method
	 * @param arg0
	 * @return
	 */
	public void sendError(int arg0) throws IOException {
		this.res.sendError(arg0);
	}//end of sendError();

	/**
	 * HttpServletResponse의 sendError Method
	 * @param arg0
	 * @return
	 */
	public void sendError(int arg0, String arg1) throws IOException {
		this.res.sendError(arg0, arg1);
	}//end of sendError();

	/**
	 * HttpServletResponse의 sendRedirect Method
	 * @param arg0
	 * @return
	 */
	public void sendRedirect(String arg0) throws IOException {
		this.res.sendRedirect(arg0);
	}//end of sendRedirect();

	/**
	 * HttpServletResponse의 setDateHeader Method
	 * @param arg0
	 * @return
	 */
	public void setDateHeader(String arg0, long arg1) {
		this.res.setDateHeader(arg0, arg1);
	}//end of setDateHeader();

	/**
	 * HttpServletResponse의 setHeader Method
	 * @param arg0
	 * @return
	 */
	public void setHeader(String arg0, String arg1) {
		this.res.setHeader(arg0, arg1);
	}//end of setHeader();

	/**
	 * HttpServletResponse의 setIntHeader Method
	 * @param arg0
	 * @return
	 */
	public void setIntHeader(String arg0, int arg1) {
		this.res.setIntHeader(arg0, arg1);
	}//end of setIntHeader();

	/**
	 * HttpServletResponse의 setStatus Method
	 * @param arg0
	 * @return
	 */
	public void setStatus(int arg0) {
		this.res.setStatus(arg0);
	}//end of setStatus();

	/**
	 * HttpServletResponse의 setStatus Method
	 * @param arg0
	 * @return
	 * @deprecated
	 */
	public void setStatus(int arg0, String arg1) {
		this.res.setStatus(arg0, arg1);
	}//end of setStatus();

	//----------------------------------------------- 2014.05.22 김종명 추가  시작 -----------------------------------------------------------------

	//LogUtil 파일에서 로그를 남길때 Action Name을 남기기 위해 사용.
	private String actionName;

	/**
	 * Action.java 파일에서 호출.
	 * new Action() 함수에서 req.setActionName(this.getClass().getName()); 형태로 호출.
	 * Action Name을 delivery하기 위해 사용.
	 * @param actionName Action의 Name
	 */
	public void setActionName(String actionName){
		this.actionName = actionName;
	}//end of setActionName();

	/**
	 * LogUtil.java 파일에서 사용.
	 * m.log.LogUtil 파일에서 사용.
	 * mirae.common.tool.LogUtil 파일에서는 packet을 사용하고 Packet class를 이미 argument로 전달하고 있으므로, 이 함수를 사용하지 않음.
	 * @return
	 */
	public String getActionName(){
		return this.actionName;
	}//end of getActionName();
	//----------------------------------------------- 2014.05.22 김종명 추가  끝 -----------------------------------------------------------------

	//------------------------------------------------2016.03.16 김종명 추가 시작. 세션 관련 함수 추가 -------------------------------------------------

	/**
	 * WTS 설정 관련 함수 추가
	 * @param wtsconfig
	 */
	public void setWTSConfig(String key, String config){
		if(tool.isNull(key))		return;
		if(config==null){
			this.req.getSession(true).removeAttribute("WTSConfig."+key);
		}else{
			this.req.getSession(true).setAttribute("WTSConfig."+key, config);
		}
	}//end of setWTSConfig();

	/**
	 * WTS 설정 관련 함수 추가
	 * @param wtsconfig
	 */
	public String getWTSConfig(String key, String defaultValue){
		if(tool.isNull(key))		return defaultValue;
		String config = (String)this.req.getSession(true).getAttribute("WTSConfig."+key);
		if(config==null){
			return defaultValue;
		}else{
			return config;
		}
	}//end of setWTSConfig();

	/**
	 * WTS 설정 관련 함수 추가
	 * @param wtsconfig
	 */
	public String getWTSConfig(String key){
		return this.getWTSConfig(key, "");
	}//end of setWTSConfig();

	/**
	 * 계좌비번을 암호화시켜서 Session에 저장한다.
	 * @param AccountNo 계좌번호
	 * @param AccountPwd 계좌비번
	 */
	public String setAccountPwd(String AccountNo, String AccountPwd) throws Exception{
		if(tool.isNull(AccountNo)){
			throw new ActionException("[ACS001]", "계좌번호를 입력해주십시오.");
		}
		if(tool.isNull(AccountPwd)||AccountPwd.length()<4){
			throw new ActionException("[AC0002]", "계좌비밀번호를 입력해주십시오.");
		}
		
		String time = String.valueOf(System.currentTimeMillis()).substring(11);
		String enc_pwd = AccountCipher.encrypt(time+"::"+tool.fillChar(AccountPwd, 8, ' ', tool.RIGHT)+"::"+time);
		this.getSession(true).setAttribute("WI.PWDINFO."+AccountNo, enc_pwd);
		return enc_pwd.substring(0, AccountPwd.length());
	}//end of setAccountPwd();
	
	/**
	 * WTS 계좌비밀번호 저장에서 사용할 기능.
	 * 저장된 계좌비밀번호를 복호화하여 return한다.
	 * @param AccountNo 계좌번호(평문)
	 * @param enc_pwd 암호화된 계좌비밀번호 일부(앞.. 몇자리... )
	 * @return
	 * @throws ActionException
	 */
	public String getAccountPwd(String AccountNo, String enc_pwd) throws Exception{
		if(tool.isNull(AccountNo)){
			throw new ActionException("[ACG001]", "계좌번호를 입력해주십시오.");
		}
		String pwd = (String)this.getSession(true).getAttribute("WI.PWDINFO."+AccountNo);
		if(tool.isNull(pwd)){
//			throw new ActionException("[ACG002]", "입력된 계좌비밀번호가 없습니다.");
			return enc_pwd;
		}
		if(!pwd.startsWith(enc_pwd)){
			return enc_pwd;
		}else{
			String AccountPwd = AccountCipher.decrypt(pwd);
			if(tool.isNull(AccountPwd)||AccountPwd.length()!=16){
				throw new ActionException("[ACG004]", "계좌비밀번호 복호화에 실패하였습니다.");
			}
			return AccountPwd.substring(4,12).trim();
		}
	}//end of getAccountpwd();
	
	/**
	 * 계좌비밀번호가 저장된 내용을 clear시킨다.
	 * 계좌비밀번호는 "WI.PWDINFO.계좌번호"라는 이름으로 저장이 되는데, 
	 * WI.PWDINFO.으로 시작되는 세션을 전부 삭제한다.
	 */
	public void clearAccountPwd(){
		Enumeration<String> names = this.getSession(true).getAttributeNames();
		while(names.hasMoreElements()){
			String name = names.nextElement();
			if(name.startsWith("WI.PWDINFO.")){
				this.getSession(true).removeAttribute(name);
			}
		}
	}//end of clearAccountPwd();

	
	//------------------------------------------------2016.03.16 김종명 추가 끝. 세션 관련 함수 추가 -------------------------------------------------

}//end of WebInterface