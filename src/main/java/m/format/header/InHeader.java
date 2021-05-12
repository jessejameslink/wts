package m.format.header;

import m.action.ActionException;
import m.action.IConstants;
import m.common.tool.tool;
import m.format.Transaction;
import m.log.Log;
import m.web.common.WebInterface;

/**
 * HTS BP와 TR 통신을 위한 공통Header 구조.
 * Input 구조 : 
 * 		2 : 0xfe, 0xfe
 * 		1 : 압축여부
 * 		5 : data length(이후 : header 이후 부분과 data 부분 포함)
 * 		16 : PC IP
 * 		2 : "01"로 고정
 * 		8 : tr code
 * 		10 : service code
 * 		1 : 에러발생여부
 * 		10 : filler
 * 		10 : filler
 * Output 구조 : 
 * 		Input 구조 + Message 80byte
 * @author poemlife
 */
public class InHeader implements IConstants{
	public static final int COMMONHEADER_INPUT_SIZE = 65;

	public static final byte STARTER = (byte)0xfe;
	
	private byte[] header = tool.makeFullSpaceBtyeArray(145);
	
	private WebInterface request;

	/**
	 * CommonHeader를 생성한다.
	 * @param web Web Parameter를 전달할 Web Request
	 */
	public InHeader(WebInterface web, Transaction definition) throws Exception{
		this.header[0] = STARTER;
		this.header[1] = STARTER;
		this.header[2] = '0';
		this.request = web;
		this.setTrName(definition.getTR());
		this.setService(definition.getService());
		this.setUsip();
	}//end of CommonHeader();
	
	/**
	 * data length를 Setting한다.
	 * @param len
	 */
	private void setLength(byte[] len) throws Exception{
		if(len.length>5){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0400][CommonHeader.setLength : Length 입력 오류 : ["+new String(len)+"]");
			throw new ActionException("[ER0400]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(len, 0, this.header,3,len.length);
	}//end of setLength();
	
	/**
	 * data length를 Setting한다.
	 * data length는 반드시 입력이 되어야 한다.
	 * @param length
	 */
	public void setLength(int length) throws Exception{
		if(length<0||length>99999){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0401][CommonHeader.setLength : Length 입력 오류 : ["+length+"]");
			throw new ActionException("[ER0401]", TR_DATA_ERR_MSG);
		}
		if("pibohmax".equals(this.getTrName())){
			byte[] len = tool.fillChar(String.valueOf(length+57+TMaxHeader.HEADER_SIZE), 5, '0', tool.LEFT).getBytes();
			this.setLength(len);
		}else{
			byte[] len = tool.fillChar(String.valueOf(length+57), 5, '0', tool.LEFT).getBytes();
			this.setLength(len);
		}
	}//end of setLength();
	
	/**
	 * data length를 return한다.
	 * @return
	 */
	public int getLength() throws Exception{
		byte[] len = tool.makeFullSpaceBtyeArray(5);
		System.arraycopy(this.header, 3, len, 0, len.length);
		String length = new String(len);
		try{
			if(tool.isNull(length))		return 0;
			return Integer.parseInt(length.trim())-57;
		}catch(Exception e){
			return 0;
		}
	}//end of getLength();
	
	/**
	 * 사용자 PC IP를 Setting한다.
	 * @param usip
	 */
	public void setUsip(byte[] ip) throws Exception{
		if(ip.length>16){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0402][CommonHeader.setUsip : 사용자 IP 입력 오류 : ["+new String(ip)+"]");
			throw new ActionException("[ER0402]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(ip, 0, this.header, 8, ip.length);
	}//end of setUsip();
	
	/**
	 * 사용자 PC IP를 Setting한다.
	 * @param usip
	 */
	public void setUsip(String usip) throws Exception{
		if(tool.isNull(usip)){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0409][CommonHeader.setUsip : 사용자 IP 입력 오류 : ["+usip+"]");
			throw new ActionException("[ER0409]", TR_DATA_ERR_MSG);
		}
		byte[] ip = usip.getBytes();
		this.setUsip(ip);
	}//end of setUsip();

	/**
	 * 사용자 PC IP를 Setting한다.
	 * @param usip
	 */
	public void setUsip() throws Exception{
		this.setUsip(this.request.getClientIP());
	}//end of setUsip();
	
	/**
	 * 사용자 IP를 가져온다.
	 * @return
	 */
	public String getUsip() throws Exception{
		byte[] ip = tool.makeFullSpaceBtyeArray(16);
		System.arraycopy(this.header, 8, ip, 0, ip.length);
		return new String(ip);
	}//end of getUsip();
	
	/**
	 * Tr명을 Setting한다.
	 * @param trName
	 */
	public void setTrName(byte[] trName) throws Exception{
		if(trName==null||trName.length>8){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0403][CommonHeader.setTrName : TR Name is invalid : ["+new String(trName)+"]");
			throw new ActionException("[ER0403]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(trName, 0, this.header, 26, trName.length);
	}//end of setTrName()

	/**
	 * Tr명을 Setting한다.
	 * @param trName
	 */
	public void setTrName(String trName) throws Exception{
		if(tool.isNull(trName)||trName.length()>8){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0404][CommonHeader.setTrName : TR Name is invalid : ["+trName+"]");
			throw new ActionException("[ER0404]", TR_DATA_ERR_MSG);
		}
		byte[] tr = trName.trim().getBytes();
		this.setTrName(tr);
	}//end of setTrName()

	/**
	 * TR명을 return한다.
	 * @return
	 */
	public String getTrName() throws Exception{
		byte[] tr = tool.makeFullSpaceBtyeArray(8);
		System.arraycopy(this.header, 26, tr, 0, tr.length);
		return new String(tr);
	}//end of getTrName();
	
	/**
	 * 서비스명을 Setting한다.
	 * @param service
	 */
	public void setService(byte[] service) throws Exception{
		if(service==null||service.length>10)		return;
		System.arraycopy(service, 0, this.header, 34, service.length);
	}//end of setService();

	/**
	 * 서비스명을 Setting한다.
	 * @param service
	 */
	public void setService(String service) throws Exception{
		if(tool.isNull(service)||service.length()>10)		return;
		byte[] s = service.getBytes();
		this.setService(s);
	}//end of setService();
	
	/**
	 * 서비스명을 Setting한다.
	 * @param service
	 */
	public String getService() throws Exception{
		byte[] s = tool.makeFullSpaceBtyeArray(10);
		System.arraycopy(this.header, 34,s,0,s.length);
		return new String(s).trim();
	}//end of getService();
	
	/**
	 * ReturnCode를 Setting한다.
	 * @param errorCode 0 : 정상, 1 : 에러
	 */
	public void setReturnCode(String errorCode) throws Exception{
		if(tool.isNull(errorCode))		setReturnCode('0');
		if(errorCode.trim().length()>1){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0405][CommonHeader.setReturnCode : ReturnCode Setting Error.["+errorCode+"]");
			throw new ActionException("[ER0405]", TR_DATA_ERR_MSG);
		}
		this.setReturnCode(errorCode.charAt(0));
	}//end of errorCode();
	
	/**
	 * ReturnCode를 Setting한다.
	 * @param errorCode 0 : 정상, 1 : 에러
	 */
	public void setReturnCode(char errorCode) throws Exception{
		this.header[44] = (byte) errorCode;
	}//end of errorCode();
	
	/**
	 * ReturnCode를 return한다.
	 * @return errorCode 0 : 정상, 1 : 에러
	 */
	public char getReturnCode() throws Exception{
		return (char)this.header[44];
	}//end of getReturnCode();

	/**
	 * User Filler를 Setting한다.
	 * @param filler
	 */
	public void setUserFiller(byte[] filler) throws Exception{
		if(filler==null)		return;
		if(filler.length>10){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0406][CommonHeader.setUserFiller1 : invalid filler : ["+new String(filler)+"]");
			throw new ActionException("[ER0406]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(filler, 0, this.header, 45, filler.length);
	}//end of setUserFiller();
	
	/**
	 * User Filler를 Setting한다.
	 * @param filler
	 */
	public void setUserFiller(String filler) throws Exception{
		if(filler==null||filler.length()>10){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0407][CommonHeader.setUserFiller2 : invalid filler : ["+new String(filler)+"]");
			throw new ActionException("[ER0407]", TR_DATA_ERR_MSG);
		}
		this.setUserFiller(filler.getBytes());
	}//end of setUserFiller();
	
	/**
	 * User Filler를 Setting한다.
	 * @return filler
	 */
	public String getUserFiller() throws Exception{
		byte[] filler =tool.makeFullSpaceBtyeArray(10);
		System.arraycopy(this.header, 45, filler, 0, 10);
		return new String(filler);
	}//end of getUserFiller();

	/**
	 * Filler를 Setting한다.
	 * @param filler
	 */
	public void setFiller(byte[] filler) throws Exception{
		if(filler==null)		return;
		if(filler.length>10){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0407][CommonHeader.setFiller1 : invalid filler : ["+new String(filler)+"]");
			throw new ActionException("[ER0407]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(filler, 0, this.header, 55, filler.length);
	}//end of setUserFiller();

	/**
	 * User Filler를 Setting한다.
	 * @param filler
	 */
	public void setFiller(String filler) throws Exception{
		if(filler==null||filler.length()>10){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0408][CommonHeader.setFiller2 : invalid filler : ["+new String(filler)+"]");
			throw new ActionException("[ER0408]", TR_DATA_ERR_MSG);
		}
		this.setFiller(filler.getBytes());
	}//end of setUserFiller();
	
	/**
	 * User Filler를 Setting한다.
	 * @return filler
	 */
	public String getFiller() throws Exception{
		byte[] filler =tool.makeFullSpaceBtyeArray(10);
		System.arraycopy(this.header, 55, filler, 0, 10);
		return new String(filler);
	}//end of getUserFiller();

	/**
	 * Message를 Setting한다.
	 * @param msg
	 */
	public void setReturnMessage(byte[] msg) throws Exception{
		if(msg==null)		return;
		if(msg.length>80){
			Log.println(request, "[TMAXHEADER][EXCEPTION][ER0408][CommonHeader.setMessage1 : invalid Message!!! : ["+new String(msg)+"]");
			throw new ActionException("[ER0408]", TR_DATA_ERR_MSG);
		}
		System.arraycopy(msg, 0, this.header, 65, msg.length);
	}//end of setMessage();

	/**
	 * Return Message를 Setting한다.
	 * @param msg
	 */
	public void setReturnMessage(String msg) throws Exception{
		if(tool.isNull(msg))		return;
		byte[] message = msg.getBytes();
		this.setReturnMessage(message);
	}//end of setMessage();

	/**
	 * Return Message를 return한다.
	 * @return
	 */
	public String getReturnMessage() throws Exception{
		try{
			byte[] msg = tool.makeFullSpaceBtyeArray(80);
			System.arraycopy(this.header, 65, msg, 0, msg.length);
			return new String(msg, "utf-8").trim();
		}catch(Exception e){
			return new String();
		}
	}//end of getReturnMessage();
	
	/**
	 * Input Header를 byte[]로 return한다.
	 * @return
	 */
	public byte[] getInputHeader() throws Exception{
		byte[] inheader = tool.makeFullSpaceBtyeArray(65);
		System.arraycopy(this.header,0, inheader, 0, inheader.length);
		return inheader;
	}//end of getInputHeader();
	
}//end of CommonHeader
