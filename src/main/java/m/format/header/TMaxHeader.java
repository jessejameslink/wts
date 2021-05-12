package m.format.header;

import m.action.ActionException;
import m.action.IConstants;
import m.common.tool.tool;
import m.config.SystemConfig;
import m.data.hash;
import m.format.Transaction;
import m.log.Log;
import m.web.common.WebInterface;


/**
 * TMAX Header 구조 :
 *  0.	EYEC		[5]  (5)   - Eye_catch
 *  1.	HOST		[1]  (6)   - 호스트 구분
 *  2.	SERVICE		[9]  (15)  - 서비스 아이디
 *  3.	SCREEN		[4]  (19)  - 화면번호 : space 설정
 *  4.	COMPANY		[3]  (22)  - 회사번호: "049"
 *  5.	MEDIA		[2]  (24)  - 매체 : space로 채움.
 *  6.	TERM		14] (38)  - 단말번호: 로그인에서 받은 단말 번호로 설정 : 실제 미디어 코드가 들어감.
 *  7.	AGENCY		14] (52)  - 단말대행번호: space 설정
 *  8.	IPADDR		12] (64)  - 단말설치위치: space 설정
 *  9.	IPOS		12] (76)  - IP Address: space 설정
 * 10.	PBPR		[1] (77)  - PBPR상태: space 설정
 * 11.	OPDN		[6] (83)  - 조장자팀정: space 설정
 * 12.	ACDN		[3] (86)  - 개좌개설점: 계좌번호의 앞 3자리
 * 13.	OPID		[8] (94)  - 조작자사번: 사용자ID
 * 14.	OPNO		[1] (95)  - 조작자연번: space 설정
 * 15.	TRACE		[1] (96)  - 트레이스레벨: space 설정
 * 16.	ICARD		[1] (97)  - IC카드등급: space 설정
 * 17.	TELLER		[2] (99)  - 텔러번호: space 설정[미사용]
 * 18.	CONTF		[1] (100) - 연속거래구분: 0-정상,1-다음만,2-이전/다음,3-이전만
 * 19.	FTP			[1] (101) - FTP거래구분: space 설정[미사용]
 * 20.	KEY			[1] (102) - Function Key: space 설정[미사용]
 * 21.	DATE		[8] (110) - 거래일자: YYYYMMDD 처음에는 space,이후는 서버에서 받은 값을 설정
 * 22.	TIME		[9] (119) - 거래시각: 화면별로 처음에는 space, 이후는 서버에서 받은 값을 설정
 * 23.	RETURNCODE	[1] (120) - Return code   0-정상, 1-비정상
 * 24.	PGM			[9] (129) - Return program
 * 25.	STEP		[4] (133) - Return step
 * 26.	DATALEN		[4] (137) - 데이타 길이
 * 27.	MSGTYPE		[1] (138) - 메시지 표현방법
 * 28.	MSGKIND		[1] (139) - 메시지 종류 N-normal, W-warning, E-error
 * 29.	MSGCODE		[6] (145) - 메시지코드
 * 30.	MSG			[80] (225) - 메시지 내용
 * 31.	NEXT		[2] (227) - 출력일련번호
 * 32.	FILLER			[11] (238) - 예약영역
 * @author poemlife
 */
public class TMaxHeader implements IConstants{

	public final static int HEADER_SIZE = 238;
	private byte[] header;
	private WebInterface req;
	/********************************************
		로그인 TR또는 초기화 때 받아서 계속 사용하는 필드들
			 7.단말번호
			 9.IP어드레스
			14.조작자 사번(사용자 아이디)
		TR에서 줘야만 하는 필드들
			 2.호소트구분(1)
			 3.서비스ID(9)
			13.계좌개설점(3) 계좌번호의 앞 3자리
			19.연속거래 구분
			22.거래일자
			23.거래시간
	 	tr에 따라 호스트구분과 서비스 아이디는 다르다
	**********************************************/

	private static final hash<int[]> sizes = new hash<int[]>();
	
	static{
		sizes.put( "0", new int[]{  0, 5});			//Eye_catch
		sizes.put( "1", new int[]{  5, 1});		 	//호스트 구분
		sizes.put( "2", new int[]{  6, 9});		 	//서비스 아이디
		sizes.put( "3", new int[]{ 15, 4});		 	//화면번호 : space 설정
		sizes.put( "4", new int[]{ 19, 3});		 	//회사번호: "049"
		sizes.put( "5", new int[]{ 22, 2});		 	//매체
		sizes.put( "6", new int[]{ 24,14});		 	//단말번호: 로그인에서 받은 단말 번호로 설정
		sizes.put( "7", new int[]{ 38,14});		 	//단말대행번호: space 설정
		sizes.put( "8", new int[]{ 52,12});		 	//단말설치위치: space 설정
		sizes.put( "9", new int[]{ 64,12});		 	//IP Address: space 설정
		sizes.put("10", new int[]{ 76, 1});		 	//PBPR상태: space 설정
		sizes.put("11", new int[]{ 77, 6});		 	//조장자팀정: space 설정
		sizes.put("12", new int[]{ 83, 3});		 	//개좌개설점: 계좌번호의 앞 3자리
		sizes.put("13", new int[]{ 86, 8});		 	//조작자사번: 사용자ID
		sizes.put("14", new int[]{ 94, 1});		 	//조작자연번: space 설정
		sizes.put("15", new int[]{ 95, 1});		 	//트레이스레벨: space 설정
		sizes.put("16", new int[]{ 96, 1});		 	//IC카드등급: space 설정
		sizes.put("17", new int[]{ 97, 2});		 	//텔러번호: space 설정[미사용]
		sizes.put("18", new int[]{ 99, 1});		 	//연속거래구분: 0-정상,1-다음만,2-이전/다음,3-이전만
		sizes.put("19", new int[]{100, 1});		 	//FTP거래구분: space 설정[미사용]
		sizes.put("20", new int[]{101, 1});		 	//Function Key: space 설정[미사용]
		sizes.put("21", new int[]{102, 8});		 	//거래일자: YYYYMMDD 처음에는 space,이후는 서버에서 받은 값을 설정
		sizes.put("22", new int[]{110, 9});		 	//거래시각: 화면별로 처음에는 space, 이후는 서버에서 받은 값을 설정
		sizes.put("23", new int[]{119, 1});		 	//Return code   0-정상, 1-비정상
		sizes.put("24", new int[]{120, 9});		 	//Return program
		sizes.put("25", new int[]{129, 4});		 	//Return step
		sizes.put("26", new int[]{133, 4});		 	//데이타 길이
		sizes.put("27", new int[]{137, 1});		 	//메시지 표현방법
		sizes.put("28", new int[]{138, 1});		 	//메시지 종류 N-normal, W-warning, E-error
		sizes.put("29", new int[]{139, 6});		 	//메시지코드
		sizes.put("30", new int[]{145,80});		 	//메시지 내용
		sizes.put("31", new int[]{225, 2});		 	//출력일련번호
		sizes.put("32", new int[]{227,11});		 	//예약영역
		sizes.put("MEDIA", new int[]{27,2});		//매체코드 영역. 실제 매체코드를 5번 영역을 사용하지 않고 6번 영역의 일부를 사용하기 때문에 별도의 매체 코드를 설정해준다.
	}

	/**
	 * Path 설정. 
	 * WEBT를 통해서 원장으로 전달되는 경우와 HTSBP를 통해서 원장으로 전달될때, 주문식별자 정보가 바뀌는 현상 있음. 
	 * HTSBP일때는 PCIP+SERVERIP라면 WEBT는 SERVERIP+PCIP 순서임.
	 */
	private int path;
	
	public TMaxHeader(int path, WebInterface request, Transaction definition) throws Exception{
		this(path, request, String.valueOf(definition.getHost()), definition.getService());
	}//end of TMaxHeader();
	
	public TMaxHeader(int path, WebInterface request, String host, String service) throws Exception{
		this.header = tool.makeFullSpaceBtyeArray(HEADER_SIZE);
		this.path = path;
		this.set(0, "mirae");
		this.set(4, "049");
		this.set(26,"0000");
		this.req = request;
		this.setClientIP();
		this.setServerIP();
		this.setUsid();
		this.setBranchNo();
		this.setHost( host );
		this.setService( service );
		this.setFunction();
	}//end of TMAXHEADER();
	
	/**
	 * @param req
	 * @param host
	 * @param service
	 * @param usePbpr PBPR 사용 여부. true이면 사용, 아니면 false
	 */
	public TMaxHeader(int path, WebInterface req, String host, String service, boolean usePbpr) throws Exception{
		this(path, req, host, service);
		this.setPbpr(usePbpr);
	}//end of TMAXHEADER();

	/**
	 * @param req
	 * @param host
	 * @param service
	 * @param pbpr
	 */
	public TMaxHeader(int path, WebInterface req, String host, String service, byte pbpr) throws Exception{
		this(path, req, host, service);
		this.setPbpr(pbpr);
	}//end of TMAXHEADER();
	
	public TMaxHeader(int path, byte[] header) throws Exception{
		this.path = path;
		this.setHeader(header);
	}//end of TMaxHeader();

	/**
	 * key에 해당하는 value를 Setting한다.
	 * @param key
	 * @return
	 */
	public void set(int index, byte[] value) throws Exception{
		if(index<0||index>32){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0300][TMaxHeader.set : invalid index : "+index + "]");
			throw new ActionException("[ER0300]", TR_DATA_ERR_MSG);
		}
		if(value==null){		//별도의 null check를 하지 않는다. null일 경우, arraycopy를 하지 않는다.
			return;
		}
		int[] info = this.getSizes(index);		//0 : Starting Poing, 1 : Length
		if(value.length>info[1]){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0301][TMaxHeader.set : invalid "+index+"th data length ["+value.length+"]["+info[1]+"]["+new String(value)+"]");
			throw new ActionException("[ER0301]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(value, 0, this.header, info[0], value.length);
	}//end of set();
	
	public void set(int index, String value) throws Exception{
		this.set(index, value.getBytes());
	}//end of set();
	
	/**
	 * key에 해당하는 value를 Setting한다.
	 * @param key
	 * @return
	 */
	public void set(String key, byte[] value) throws Exception{
		if(tool.isNull(key)){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0302][TMaxHeader.set : Key is Null!!!]");
			throw new ActionException("[ER0302]", TR_DATA_ERR_MSG);
		}
		int[] info = this.getSizes(key);		//0 : Starting Poing, 1 : Length
		if(info==null){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0303][TMaxHeader.set : invalid Key ["+key+"]");
			throw new ActionException("[ER0303]", TR_DATA_ERR_MSG);
		}
		if(value.length>info[1]){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0304][TMaxHeader.set : invalid "+key+"'s data length ["+value.length+"]["+info[1]+"]["+new String(value)+"]");
			throw new ActionException("[ER0304]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(value, 0, this.header, info[0], value.length);
	}//end of set();
	
	/**
	 * key에 해당하는 value를 Setting한다.
	 * @param key
	 * @return
	 */
	public void set(int index, byte value) throws Exception{
		if(index<0||index>32){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0305][TMaxHeader.set : invalid index : "+index + "]");
			throw new ActionException("[ER0305]", TR_DATA_ERR_MSG);
		}
		int[] info = this.getSizes(index);		//0 : Starting Poing, 1 : Length
		if(info[1]!=1){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0306][TMaxHeader.set : invalid "+index+"th data length [1]["+info[1]+"]["+value+"]");
			throw new ActionException("[ER0306]", TR_DATA_ERR_MSG);
		}
		this.header[info[0]] = value;
	}//end of set();
	
	/**
	 * key에 해당하는 value를 Setting한다.
	 * @param key
	 * @return
	 */
	public void set(String key, byte value) throws Exception{
		if(tool.isNull(key)){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0307][TMaxHeader.set : Key is Null!!!]");
			throw new ActionException("[ER0307]", TR_DATA_ERR_MSG);
		}
		int[] info = this.getSizes(key);		//0 : Starting Poing, 1 : Length
		if(info[1]!=1){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0308][TMaxHeader.set : invalid "+key+"th data length [1]["+info[1]+"]["+value+"]");
			throw new ActionException("[ER0308]", TR_DATA_ERR_MSG);
		}
		this.header[info[0]] = value;
	}//end of set();

	/**
	 * key에 해당하는 value를 찾아서 return한다.
	 * @param key
	 * @return
	 */
	public byte[] get(int index) throws Exception{
		int[] leninfo = this.getSizes(index);
		byte[] value = tool.makeFullSpaceBtyeArray(leninfo[1]);
		System.arraycopy(this.header, leninfo[0], value, 0, value.length);
		return value;
	}//end of get();
	
	/**
	 * key에 해당하는 value를 찾아서 return한다.
	 * @param key
	 * @return
	 */
	public byte[] get(String key) throws Exception{
		int[] leninfo = this.getSizes(key);
		byte[] value = tool.makeFullSpaceBtyeArray(leninfo[1]);
		System.arraycopy(this.header, leninfo[0], value, 0, value.length);
		return value;
	}//end of get();
	
	/**
	 * index에 해당하는 size info를 찾아서 return한다.
	 * @param index
	 * @return
	 */
	public int[] getSizes(int index) throws Exception{
		if(index<0||index>32){
			Log.println(req, "[TMAXHEADER][INFO][TMaxHeader.getsizes : invalid index : "+index+"]");
			return null;
		}
		return sizes.get(String.valueOf(index));
	}//endof getSizes();
	
	/**
	 * Key에 해당하는 size info를 return한다.
	 * @param key
	 * @return
	 */
	public int[] getSizes(String key) throws Exception{
		if(tool.isNull(key)){
			Log.println(req, "[TMAXHEADER][INFO][TMaxHeader.getsizes : Key is Null!!!]");
			return null;
		}
		return sizes.get(key);
	}//end of getSize();
	
	/**
	 * Host를 Setting한다.
	 * @param host
	 */
	public void setHost(String host) throws Exception{
		if(host==null||host.length()!=1){
			return;
		}
		this.setHost(host.charAt(0));
	}//end of setHost();
	
	/**
	 * Host를 Setting한다.
	 * @param host
	 */
	public void setHost(char host) throws Exception{
		switch(host){
			case ' ' : 				//원장TR 아닐때
			case '0' : 				//정보계
			case '1' :				//업무계
			case '7' : 				//상품정보
				this.set(1, (byte)host);
				break;
		}
	}//end of setHost();

	/**
	 * Host를 Setting한다.
	 * @param host
	 */
	public void setHost(byte host) throws Exception{
		this.setHost((char)host);
	}//end of setHost();
	
	/**
	 * Host 정보를 return한다.
	 * @param host
	 */
	public char getHost() throws Exception{
		byte[] value = this.get(1);
		int[] leninfo = this.getSizes(1);
		if(value==null){
			Log.println(req, "[TMAXHEADER][INFO][TmaxHeader.getHost : invalid Host Info!! value is null!!]");
			return ' ';
		}
		if(value.length!=leninfo[1]){
			Log.println(req, "[TMAXHEADER][INFO][TmaxHeader.getHost : invalid Host Info!!["+new String(value)+"]");
			return ' ';
		}
		return (char)value[0];
	}//end of getHost();
	
	/**
	 * 서비스명을 Setting한다.
	 * @param service
	 */
	public void setService(String service) throws Exception{
		if(tool.isNull(service)){
			return;
		}
		byte[] s = service.getBytes();
		this.setService(s);
	}//end of setService();
	
	/**
	 * 서비스명을 Setting한다.
	 * @param service
	 */
	public void setService(byte[] service) throws Exception{
		if(service==null){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0310][Service is Null]");
			throw new ActionException("[ER0310]", TR_DATA_ERR_MSG);
		}
		int[] leninfo = this.getSizes(2);
		if(service.length!=leninfo[1]){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0311][service is invalid!!!["+new String(service)+"]");
			throw new ActionException("[ER0311]", TR_DATA_ERR_MSG);
		}
		this.set(2, service);
	}//end of setService();

	/**
	 * 서비스명을 Setting한다.
	 * @param service
	 */
	public String getService() throws Exception{
		return new String(this.get(2));
	}//end of getService();
	
	/**
	 * 화면번호를 Setting한다.
	 * @param screenNo
	 */
	public void setScreenNo(String screenNo) throws Exception{
		if(screenNo==null){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0312][screenNo is Null]");
			throw new ActionException("[ER0312]", TR_DATA_ERR_MSG);
		}
		byte[] sno = screenNo.getBytes();
		this.setScreenNo(sno);
	}//end of setScreenNo();
	
	/**
	 * 화면번호를 Setting한다.
	 * @param screenNo
	 */
	public void setScreenNo(byte[] screenNo) throws Exception{
		if(screenNo==null){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0313][screenNo is Null]");
			throw new ActionException("[ER0313]", TR_DATA_ERR_MSG);
		}
		this.set(3, screenNo);
	}//end of setScreenNo();
	
	/**
	 * 화면번호를 반환한다.
	 * @return newVal 화면번호
	 */
	public String getScreenNo()	throws Exception{
		return new String(this.get(3));
	}//end of getScreenNo();

	public void setMedia(String media) throws Exception{
		if(media==null){
			this.setMedia("13".getBytes());
		}else{
			this.setMedia(media.getBytes());
		}
	}//end of setMedia();
	
	public void setMedia(byte[] media) throws Exception{
		if(media==null){
			this.set(6,"04913");
		}else{
			int[] leninfo = sizes.get("6");
			if(media.length>leninfo[1]){
				this.set(6,"04913");
			}else{
				this.set(6, "049"+new String(media));
			}
		}
	}//end of setMedia();
	
	public void setMacAddr(String macAddr) throws Exception{
		if(macAddr==null){
			this.setMacAddr("000000000000".getBytes());
		}else{
			this.setMacAddr(macAddr.getBytes());
		}
	}//end of setMacAddr();
	
	public void setMacAddr(byte[] macAddr) throws Exception{
		if(macAddr==null){
			this.set(7,"000000000000");
		}else{
			if(macAddr.length>12){
				byte[] temp = new byte[12];
				System.arraycopy(macAddr, 0, temp, 0, 12);
				this.set(7,temp);
			}else{
				this.set(7, macAddr);
			}
		}
	}//end of setMacAddr();
	
	/**
	 * 매체구분을 설정한다.
	 * @param 매체구분
	 */
	public String getMedia() throws Exception{
		return new String(this.get(6));
	}//end of getMedia();

	/**
	 * IP 정보를 가져와 헤더값에 셋팅한다.
	*/
	public void setClientIP() throws Exception{
		String clientIp = this.req.getClientIP();
		this.set(9, clientIp.getBytes());
		if(this.path==WEBT)		this.set(9, clientIp.getBytes());
		else					this.set(8, clientIp.getBytes());
	}//end of setClientIP();
	
	/**
	 * 사용자 IP를 return한다
	 * @return
	 */
	public String getClientIP() throws Exception{
//		return new String("127000000001");
		return new String(this.get(9));
	}//end of getClientIP();
	
	/**
	 * 서버 IP를 Setting한다.
	 * Setting할 서버 IP는 설정 메모리에 Setting된 값을 사용한다.
	 * 설정 메모리에 Setting된 키값은 SERVERIP이다.
	 */
	public void setServerIP() throws Exception{
		this.setServerIP(SystemConfig.getServerIP());
	}//end of setServerIP();
	
	/**
	 * 서버번호를 설정한다.
	 * @param serverip 서버 IP
	 */
	public void setServerIP(String serverip) throws Exception{
		if(serverip==null){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0314][serverip is Null]");
			throw new ActionException("[ER0314]", TR_DATA_ERR_MSG);
		}
		this.setServerIP(serverip.getBytes());
	}//end of setServerIP();

	/**
	 * 서버번호를 설정한다.
	 * @param serverip 서버 IP
	 */
	public void setServerIP(byte[] serverip) throws Exception{
		if(serverip==null){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0315][serverip is Null]");
			throw new ActionException("[ER0315]", TR_DATA_ERR_MSG);
		}
		if(this.path==WEBT)		this.set(8, serverip);
		else					this.set(9, serverip);
	}//end of setServerIP();

	/**
	 * 서버 IP를 찾아서 return한다.
	 * @return
	 */
	public String getServerIP() throws Exception{
		if(this.path==WEBT)		return new String(this.get(8));
		else					return new String(this.get(9));
	}//end of getServerIP();
	
	/**
	 * BP IP를 Setting한다.
	 * @param bpip
	 */
	public void setBpip(String bpip) throws Exception{
		if(bpip==null){
			this.setBpip(new byte[]{});
		}else{
			this.setBpip(bpip.getBytes());
		}
	}//end of setBpip();

	/**
	 * BP IP를 Setting한다.
	 * @param bpip
	 */
	public void setBpip(byte[] bpip) throws Exception{
		this.set(9, bpip);
	}//end of setBpip();
	
	/**
	 * BP IP를 return한다.
	 * @param bpip
	 */
	public String getBpip() throws Exception{
		return new String(this.get(9));
	}//end of setBpip();
	
	/**
	 * PBPR 사용 여부를 Setting한다.
	 * PBPR은 출력시 사용되는 포맷이다.
	 * 현재 PBPR은 증명서 출력 관련 컨텐츠에서만 부분적으로 사용된다.
	 * @param value true면 사용, false면 사용안함.
	 */
	public void setPbpr(boolean value) throws Exception{
		if(value)		this.setPbpr((byte)0x09);
		else			this.setPbpr((byte)0x20);
	}//end of setPbpr();
	
	/**
	 * PBPR 사용 여부를 Setting한다.
	 * @param value 0x09면 사용, 아니면 사용 안함.
	 */
	public void setPbpr(byte value) throws Exception{
		if(value==0x09){			//PBPR 사용
			this.set(10, value);
		}else{						//그외. PBPR 사용안함.
			this.set(10, (byte)0x20);
		}
	}//end of setPbpr();

	/**
	 * PBPR 사용 여부를 Setting한다.
	 * @return true면 사용, false면 사용안함.
	 */
	public boolean usePbpr() throws Exception{
		return this.getPbpr()==(byte)0x09;
	}//end of usePbpr();
	
	/**
	 * PBPR 사용 여부를 return한다.
	 * @return 0x09이면 사용, 아니면 사용안함.
	 */
	public byte getPbpr() throws Exception{
		byte[] value = this.get(10);
		if(value==null||value.length!=1)		return (byte)0x20;
		else									return (byte)0x09;
	}//end of getPbpr();

	public void setBranchNo(String accno) throws Exception{
		if(accno==null)		this.setBranchNo();
		else				this.setBranchNo(accno.getBytes());
	}//end of setBranchNo();
	
	/**
	 * 계좌 개설점을Setting한다.
	 * 계좌 개설점은 업무계/정보계의 1/2호기를 나누는 역할을 수행한다.
	 * @param accno
	 */
	public void setBranchNo(byte[] accno) throws Exception{
		if(accno==null){
			this.setBranchNo();
		}
		int[] leninfo = this.getSizes(12);
		if(accno.length!=leninfo[1]){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0316][TMaxHeader.setBranchNo : invalid BranchNo ["+new String(accno)+"]");
			throw new ActionException("[ER0316]", TR_DATA_ERR_MSG);
		}
		this.set(12, accno);
	}//end of setBranchNo();
	
	/**
	 * 계좌 개설점을Setting한다.
	 * 계좌 개설점은 업무계/정보계의 1/2호기를 나누는 역할을 수행한다.
	 * PC IP가 짝수이면 1호기(001), 홀수이면 2호기(050)로 분배한다.
	 */
	public void setBranchNo() throws Exception{
		String usip = this.req.getRemoteAddr();
		char idx = usip.charAt(usip.length()-1);
		switch(idx){
			case '0' : 
			case '2' : 
			case '4' : 
			case '6' : 
			case '8' :
				this.setBranchNo("001".getBytes());
				break;
			default : 
				this.setBranchNo("050".getBytes());
				break;
		}
	}//end of setBranchNo();
	
	/**
	 * 계좌 개설점을 return한다.
	 * 계좌 개설점은 업무계/정보계의 1/2호기를 나누는 역할을 수행한다.
	 * @return branchNo
	 */
	public String getBranchNo() throws Exception{
		return new String(this.get(12));
	}//end of getBranchNo();

	/**
	 * 조작자 사번을 Setting한다.
	 */
	@SuppressWarnings("unused")
	private void setOpdn() throws Exception{
		String usid = this.req.getUsid();
		if(usid==null)		this.setOpdn(null);
		if(usid.length()>6)	this.setOpdn(usid.substring(0,6).getBytes());
	}//end of setOpdn();
	
	/**
	 * 조작자 사번을 Setting한다.
	 * 웹은 조작자 사번이 따로 존재하지 않으므로, 사용자ID의 앞 6자리를 따서 사용한다.
	 */
	private void setOpdn(byte[] opdn) throws Exception{
		this.set(11, opdn);
	}//end of setOpdn();

	/**
	 * 사용자 ID를 Setting한다.
	 */
	public void setUsid() throws Exception{
		String usid = this.req.getUsid();
		if(usid==null)			return;
		this.setUsid(usid.getBytes());
	}//end of setUsid();

	/**
	 * 사용자 ID를 Setting한다.
	 * @param usid
	 */
	private void setUsid(byte[] usid) throws Exception{
		this.set(13, usid);
	}//end of setUsid();
	
	/**
	 * 사용자 ID를 찾아서 return한다.
	 * @return
	 */
	public String getUsid() throws Exception{
		return new String(this.get(13));
	}//end of getUsid();

	/**
	 * Function key 를 Setting한다.
	 * @return
	 */
	private void setFunction() throws Exception{
		this.set(20, new String("1").getBytes());
	}//end of setFunction();
	
	/**
	 * 연속거래구분을 Setting한다.
	 * @param gubn 0 : 정상, 1 : 다음만, 2 : 이전/다음, 3 : 이전만
	 */
	public void setContinue(char gubn) throws Exception{
		switch(gubn){
			case ' ' : 
			case '0' : 
			case '1' : 
			case '2' :
			case '3' : 
				this.set(18, (byte)gubn);
				break;
		}
	}//end of setContinue();
	
	/**
	 * 연속거래구분을 return한다.
	 * @return 0 : 정상, 1 : 다음만, 2 : 이전/다음, 3 : 이전만
	 */
	public char getContinue() throws Exception{
		byte[] value = this.get(18);
		if(value==null)		return ' ';
		switch((char)value[0]){
			case ' ' : 
			case '0' : 
			case '1' : 
			case '2' :
			case '3' : 
				return (char)value[0];
			default : return ' ';
		}
	}//end of getContinue();
	
	/** 
	 * 거래일자를 Setting한다.
	 * 연속조회 등의 경우 사용한다.
	 * 현재는 미사용 상태이다.
	 * @param date
	 */
	public void setDate(String date) throws Exception{
		if(date==null)		return;
		this.setDate(date.getBytes());
	}//end of setDate();
	
	/** 
	 * 거래일자를 Setting한다.
	 * 연속조회 등의 경우 사용한다.
	 * 현재는 미사용 상태이다.
	 * @param date
	 */
	public void setDate(byte[] date) throws Exception{
		if(date==null)			return;
		this.set(21, date);
	}//end of setDate();
	
	/** 
	 * 거래일자를 return한다.
	 * 연속조회 등의 경우 사용한다.
	 * 현재는 미사용 상태이다.
	 * @return date
	 */
	public String getDate() throws Exception{
		return new String(this.get(21));
	}//end of getDate();
	
	/** 
	 * 거래시간을 Setting한다.
	 * 연속조회 등의 경우 사용한다.
	 * 현재는 미사용 상태이다.
	 * @param time
	 */
	public void setTime(String time) throws Exception{
		if(time==null)		return;
		this.setTime(time.getBytes());
	}//end of setTime();
	
	/** 
	 * 거래시간을 Setting한다.
	 * 연속조회 등의 경우 사용한다.
	 * 현재는 미사용 상태이다.
	 * @param time
	 */
	public void setTime(byte[] time) throws Exception{
		if(time==null)		return;
		this.set(22, time);
	}//end of setTime;
	
	/** 
	 * 거래시간을 return한다.
	 * 연속조회 등의 경우 사용한다.
	 * 현재는 미사용 상태이다.
	 * @param time
	 */
	public String getTime() throws Exception{
		return new String(this.get(23));
	}//end of getTime();
	
	/**
	 * returnCode를 Setting한다.
	 * @return 0이면 정상, 1이면 비정상.
	 */
	public void setReturnCode(String returnCode) throws Exception{
		this.set(23, returnCode);
	}//end of getReturnCode();

	/**
	 * 원장에서 전달받은 returnCode를 return한다.
	 * 원장에서 잔달받은 값이므로, 별도의 Set 함수는 없다.
	 * @return 0이면 정상, 1이면 비정상.
	 */
	public String getReturnCode() throws Exception{
		byte[] value = this.get(23);
		if(value==null)		return new String("1");
		else				return new String(value);
	}//end of getReturnCode();
	
	/**
	 * 원장에서 전달받은 Return Program을 return한다.
	 * 원장에서 전달받은 값이므로, 별도의 Set 함수는 없다.
	 * @return
	 */
	public String getReturnProgram() throws Exception{
		return new String(this.get(24));
	}//end of getReturnProgram();

	/**
	 * 원장에서 전달받은 Pbpr Data Length를 return한다.
	 * 원장에서 전달받은 값이므로, 별도의 Set 함수는 없다.
	 * @return data length
	 */
	public int getPbprLength() throws Exception{
		String dataLen = new String(this.get(26));
		try{
			if(tool.isNull(dataLen))		return 0;
			return Integer.parseInt(dataLen.trim());
		}catch(Exception e){
			return 0;
		}
	}//end of getPbprLength();

	/**
	 * 원장에서 전달받은 Message Code를 return한다.
	 * 원장에서 전달받은 값이므로, 별도의 Set 함수는 없다.
	 * @return
	 */
	public void setMessageCode(String messageCode) throws Exception{
		if(tool.isNull(messageCode))	messageCode = "";
		byte[] mcode = messageCode.getBytes("utf-8");
		int len = this.getSizes(29)[1];
		if(mcode==null||mcode.length<len){
			this.set(29, mcode);
		}else{
			byte[] val = new byte[len];
			System.arraycopy(mcode, 0, val, 0, len);
			this.set(29, val);
		}
	}//end of setMessageCode();

	/**
	 * 원장에서 전달받은 Message Code를 return한다.
	 * @return
	 */
	public String getMessageCode() throws Exception{
		return new String(this.get(29));
	}//end of getMessageCode();
	
	/**
	 * 원장에서 전달받은 Message Code를 return한다.
	 * 원장에서 전달받은 값이므로, 별도의 Set 함수는 없다.
	 * @return
	 */
	public void setReturnMessage(String msg) throws Exception{
		if(tool.isNull(msg))	msg="";
		byte[] m = msg.getBytes("utf-8");
		int len = this.getSizes(30)[1];
		if(m.length>len){
			byte[] val = new byte[len];
			System.arraycopy(m, 0, val, 0, len);
			this.set(30, val);
		}else{
			this.set(30, m);
		}
	}//end of getReturnMessage();

	/**
	 * 원장에서 전달받은 Message Code를 return한다.
	 * 원장에서 전달받은 값이므로, 별도의 Set 함수는 없다.
	 * @return
	 */
	public String getReturnMessage() throws Exception{
		try{
			/*
			 * 김종명 추가 : 20130906
			 * 내용 : Message Code가 T99999일 경우, 원장 메시지를 강제로 변경.
			 * "서비스준비중, 잠시 후 다시 이용해 주십시오." 라는 메시지 대신에 "결제작업수행중 : 모든 (예약)주문/계좌조회가 불가합니다."라는 메시지로 변경
			 */
			if("T99999".equals(this.getMessageCode())){
				return "시스템 점검 또는 결제작업 수행중입니다. \n모든 (예약)주문/계좌조회가 불가하오니 잠시후 이용하여 주시기 바랍니다.";
			}else{
				return new String(this.get(30), "utf-8");
			}
		}catch(Exception e){
			return new String(this.get(30));
		}
	}//end of getReturnMessage();

	/**
	 * Next 여부를 Setting한다.
	 * @param next
	 */
	public void setNext(String next) throws Exception{
		if(next==null)		return;
		this.setNext(next.getBytes());
	}//end of setNext();
	
	/**
	 * Next 여부를 Setting한다.
	 * @param next
	 */
	public void setNext(byte[] next) throws Exception{
		if(next==null)		return;
		this.set(31, next);
	}//end of setNext();
	
	/**
	 * Next처리를 위한 value
	 * @return
	 */
	public String getNext() throws Exception{
		return new String(this.get(31));
	}//end of getNext();
	
	/**
	 * Filler를 Setting한다.
	 * @param filler
	 */
	public void setFiller(String filler) throws Exception{
		if(filler==null)		return;
		this.setFiller(filler.getBytes());
	}//end of setFiller();
	
	/**
	 * Filler를 Setting한다.
	 * @param filler
	 */
	public void setFiller(byte[] filler) throws Exception{
		if(filler==null)		return;
		this.set(32, filler);
	}//end of setFiller();
	
	/**
	 * Filler를 return한다.
	 * @return
	 */
	public String getFiller() throws Exception{
		return new String(this.get(32));
	}//end of getFiller();
	
	/**
	 * Header를 return한다
	 * @return
	 */
	public byte[] getHeader() throws Exception{
		return header;
	}//end of getHeader();
	
	/**
	 * Header값을 Setting한다.
	 * 원장에서 전달받은 Header값을 Setting할때 사용한다.
	 * @param header
	 */
	public void setHeader(byte[] header) throws Exception{
		if(header==null){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0317][TmaxHeader.setHeader : header is null!!!]");
			throw new ActionException("[ER0317]", TR_DATA_ERR_MSG);
		}
		if(header.length!=HEADER_SIZE){
			Log.println(req, "[TMAXHEADER][EXCEPTION][ER0317][TmaxHeader.setHeader : invalid header value is null["+new String(header)+"]");
			throw new ActionException("[ER0317]", TR_DATA_ERR_MSG);
		}
		this.header = header;
		this.print();
	}//end of setHeader();
	
	/**
	 * TmaxHeader log 출력
	 */
	public void print() throws Exception{
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] hostType: " 	+ this.getHost());
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] serviceID: " 	+ this.getService());
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] screenNo: " 	+ this.getScreenNo());
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] company: " 	+ new String(this.get(4)));
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] terminal: " 	+ new String(this.get(6)));
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] MACADDR: "	+ new String(this.get(7)));
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] userIP: " 	+ new String(this.get(9)));
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] bpIP: " 		+ new String(this.get(8)));
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] printBPBR:"	+ new String(this.get(10)));
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] returnCode: " + this.getReturnCode());
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] program: " 	+ this.getReturnProgram());
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] pbprLength: " + this.getPbprLength());
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] messageCode: "+ this.getMessageCode());
		Log.println(req, "[TR][HEADER]["+tool.getCurrentTime()+"][" + getHost() + "][pibohmax][" + getService() + "] message: " 	+ this.getReturnMessage());
	}
	
}//end of TMaxHeader