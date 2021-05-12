package m.action;

/**
 * 상수정의 클래스
 * @author 김대원
 * 
 */
public interface IConstants {
 
	//login lever
	public static final int 	LOGIN_NONE 			= -1;			//비로그인
	public static final int 	LOGIN_ID			= 0;			//준회원로그인
	public static final int 	LOGIN_CERT 			= 2;			//인증서로그인
	public static final int 	LOGIN_IDCERT 		= 1;			//정회원로그인
	public static final int 	AUTO_CERT 			= 9;			//자동로그인
	
	//login lever(퇴직연금)
	public static final int 	RETIRE_LOGIN_NONE	= -1;			//로그인 필요없는 컨텐츠
	public static final int 	RETIRE_LOGIN_ID		= 2;			//준회원 로그인컨텐츠
	public static final int 	RETIRE_LOGIN_CERT 	= 3;			//주민번호+인증서로그인 필요
	public static final int 	RETIRE_LOGIN_IDCERT = 4;			//정회원로그인 필요
	
	/*login level(퇴직연금 가입자 유형별)
	 * mp_yn, plan_kind_c
	*/
	public static final String 	RETIRE_LOGIN_N1		= "0";			//N,1
	public static final String 	RETIRE_LOGIN_N2		= "1";			//N,2
	public static final String 	RETIRE_LOGIN_N3		= "2";			//N,3
	public static final String 	RETIRE_LOGIN_N4		= "3";			//N,4
	public static final String 	RETIRE_LOGIN_Y2		= "4";			//Y,2
	public static final String 	RETIRE_LOGIN_Y3		= "5";			//Y,3
	public static final String 	RETIRE_LOGIN_Y4		= "6";			//Y,4
	public static final String 	FULL_RETIRE_LOGIN	= "0123456";	//모든 가입자 유형 OK
	
	//param type code
	//
	public static final int 	JSP 				= 1;
	public static final int 	MULTI 				= 2;
	public static final int 	XML 				= 3;
	public static final int 	COMM				= 4;
	
	//media type
	public static final int 	MEDIA_WEB 			= 13;			//매체구분코드 : WEB
	public static final int 	MEDIA_MINI 			= 67;			//매체구분코드 : MINI
	public static final String 	MEDIA_MP 			= "45";			//매체구분코드 : MP주문시 사용
		
	// Packet 정의단의 XML 
	public static final int 	DISABLED			= -1;
	public static final int 	UNKNOWN				= 0;
	public static final int 	DATABASE 			= 1;
	public static final int 	HTSBP				= 2;
	public static final int 	WEBT				= 3;
	public static final int 	OOP					= 4;
	public static final int 	CHART				= 5;
	public static final int		ORIGIN				= 6;
	
	//TR/DB 등의 상태에 대한 키워드
	public static final char 	NORMAL 				= 'N';			//정상 상태
	public static final char 	BISANG 				= 'B';			//비상 상태
	public static final char 	PASS 				= 'P';			//우회 상태
	
	// DB Field에 대한 속성 정보 
	public static final char 	IN					= 'I';
	public static final char 	OUT					= 'O';
	
	// DB File의 data type에 대한 속성명
	public static final int 	STRING 				= 100;
	public static final int 	INT					= 200;
	public static final int 	FLOAT				= 300;
	public static final int 	DATE				= 400;
	public static final int 	CLOB				= 500;
	
	//Log Level
	public static final int 	ACCESSLOG 			= 1;			//access log. 접근로그
	public static final int 	LOGINLOG 			= 2;			//접속로그. 로그인한 로그.
	public static final int 	TRLOG				= 3;			//TR 로그. 모든 TR 사용시 남김.
	public static final int 	DBLOG				= 4;			//DB 로그. 모든 DB 관련 처리시 남김.
	public static final int 	CERTLOG				= 5; 			//전자서명검증 및 주문 로그. 전자서명검증 후 주문시 남김.
	public static final int 	FILELOG				= 6; 			//파일전송로그. IDC 서버로 파일전송시 남김
	
	//oop grid header
	public static final byte 	DEL					= 0x7f;
	public static final byte 	TAB					= 0x09;
	public static final byte 	LF					= 0x0a;
	public static final byte 	CR					= 0x0d;
	public static final byte 	SPACE				= 0x20;
	public static final byte	VN13				= 0x13;	
	
	//chart grid header
	public static final byte 	GU_CODE 			= 1;	// 종목	
	public static final byte 	GU_INDEX 			= 2;	// 업종
	public static final byte 	GU_FUTURE 			= 3;	// 선물
	public static final byte 	GU_OPTION 			= 4;	// 옵션
	public static final byte 	GU_FOREIGN 			= 5;	// 해외시세
	public static final byte 	GU_KQFUT 			= 6;	// KOFEX, Kosdaq 선물
	public static final byte 	GU_KQOPT 			= 7;	// Kosdaq 옵션
	public static final byte 	GU_STOCKOPTION 		= 8;	// 주식옵션
	public static final byte 	GU_STOCKFUTURE 		= 10;	// 주식선물
	public static final byte 	GU_PRODUCT			= 11;	// 상품선물
	
	public static final byte 	GI_DAY				= 1;	// 일봉
	public static final byte 	GI_WEEK				= 2;	// 주봉
	public static final byte 	GI_MONTH			= 3;	// 월봉
	public static final byte 	GI_MINUTE			= 4;	// 분봉
	public static final byte 	GI_TICK				= 5;	// 틱

	public static final byte 	GUI_MOD				= 0x21;	// 수정주가
	public static final byte 	GUI_TODAY			= 0x22;	// 당일데이터(분,틱)
	
	public static final char 	HOST_TRANSACTION	= '0';	// 호스트구분-업무계
	public static final char 	HOST_INFORMATION	= '1';	// 호스트구분-정보계
	
	//데이터 타입
	public static final int 	TRANSACTION 		= 100;	//TR
	
	//계좌 리스트 타입
	
	public static final int 	AUTO 				= 1;	//자동 (01, 99)
	public static final int 	REPAY 				= 2;	//상환 (77, 99)
	public static final int 	REPAY2 				= 3;	//상환 (01, 99, 44, 45, 46)
	public static final int 	CUSTOMER1			= 4;	//상환 (01, 99, 31)
	public static final int 	CUSTOMER2			= 5;	//상환 (51, 55)
	public static final int 	FUNDTRADE 			= 6;	//펀드매매 (99, 44, 45, 46)
	public static final int 	ACCOUNTRIGHTS 		= 7;	//펀드매매 (01, 99, 31, 45)
	public static final int 	ACCOUNTRETIRE 		= 8;	//퇴직연금 (99, 46)
	public static final int 	ACCOUNSTOCK 		= 9;	//주식 (01,31,32,33,34,45,99)
	public static final int 	ACCOUNRECEIVED 		= 10;	//예수금 (01,32,33,34,45,99)
	public static final int 	ACCOUNCREDIT 		= 11;	//신용 (01,32,33,34,99)
	public static final int 	AUTOCREDIT 			= 12;	//자동담보 (01,99,46)
	public static final int 	INVESTCREDIT 		= 13;	//투신담보 (44,45,46)
	public static final int 	ACCOUNTPENSION 		= 14;	//개인연금 (46)
	public static final int 	ELSCREDIT 			= 15;	//ELS/DLS(99, 44, 45)
	
	//매체 코드
	public static final int 	CONN_PC				= 0;
	public static final int 	CONN_MOBILE			= 1;
	
	//매체 코드
	public static final String 	SET_TABLET			= "TABLET";
	public static final String 	SET_PC				= "OPENWEB";
	public static final String 	SET_PHONE			= "PHONE";
	public static final String 	SET_IPHONE			= "IPHONE";
	public static final String 	SET_ANDROIDPHONE	= "ANDROIDPHONE";
	public static final String 	SET_IPAD			= "IPAD";
	public static final String 	SET_ANDROIDPAD		= "ANDROIDPAD";
	public static final String 	SET_ETC				= "ETC";

		
	//단말 코드
	public static final int 	T_IPHONE			= 0;
	public static final int 	T_IPAD				= 1;
	public static final int 	T_ANDROIDPHONE		= 2;
	public static final int 	T_ANDROIDPAD		= 3;
	public static final int 	T_ETCPHONE			= 4;
	public static final int 	T_PC				= 5;
		
	//os code
	public static final int 	OS_WINDOW			= 0;
	public static final int 	OS_LINUX			= 1;
	public static final int 	OS_MAC				= 2;
	public static final int 	OS_ANDROID			= 3;
	public static final int 	OS_IOS				= 4;
	
	
	//browser code
	public static final int 	BROWSER_IE			= 0;
	public static final int 	BROWSER_CHROME		= 1;
	public static final int 	BROWSER_SAFARI		= 2;
	public static final int 	BROWSER_FIREFOX		= 3;
	public static final int 	BROWSER_OPERA		= 4;
	
	//공인인증 관련 action 여부
	public static final String 	ISCERTISSUE			= "CERTISSUE";
	
	//message
	public static final String 	BISANG_MSG 						= "사용량이 많아 접속이 지연되고 있습니다. 잠시 후 다시 이용하여 주시기 바랍니다.";
	public static final String 	LOGIN_MSG 							= "접속이 단절되었습니다. 재로그인 후 이용하여 주십시오.";
	public static final String 	LOGIN_INFO_SELECT_FAIL_MSG 		= "로그인 정보 조회가 실패하였습니다. 다시 로그인하여 주십시오.";
	public static final String 	SEED_DECRYPT_FAIL_MSG 			= "접속이 단절되었습니다. 재로그인 후 이용하여 주십시오.";
	public static final String 	KDF_ERROR_MSG 						= "세션이 끊어졌습니다. 재조회 하시기 바랍니다.";
	public static final String 	ACC_COMPARE_ERR_MSG 				= "본인계좌확인에 실패했습니다. 반드시 처리 결과를 확인하시고, 다시 이용해 주시기 바랍니다.";
	public static final String 	TR_DATA_ERR_MSG 					= "데이터 통신이 실패하였습니다. 반드시 처리 결과를 확인하시고, 다시 이용해 주시기 바랍니다.";
	public static final String 	DIGITAL_SIGN_VERITY_FAIL_MSG 	= "전자서명 검증에 실패하였습니다. 반드시 처리 결과를 확인하시고, 다시 이용해 주시기 바랍니다.";
	public static final String 	POOL_CREATE_FAIL_MSG 				= "Pool 생성 실패 : host is null!";
	public static final String 	LOGIN_CERT_ERR_MSG 				= "로그인이 필요한 페이지 입니다. 로그인후 다시 이용해 주시기 바랍니다.";
	public static final String 	FINAL_TR_EX_CHECK_ERR 			= "사용량이 많아 접속이 지연되고 있습니다. 잠시 후 다시 이용하여 주시기 바랍니다.";
	public static final String 	KDF_INPUT_ERROR_MSG 				= "키보드입력이 비정상적으로 동작하고 있습니다.자세한 내용은 고객센터(1588-9200)으로 연락하여 주시기 바랍니다.";
	public static final String 	ID_ERR_MSG							= "아이디나 비밀번호 오류입니다. 다시한번 확인하시고 입력해 주시기 바랍니다.";
	public static final String 	SSO_KEY_ERR_MSG					= "로그인 정보가 만료되었습니다. 재로그인 하신 후 이용하여 주십시오";
}