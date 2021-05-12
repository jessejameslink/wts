package m.format.header;

import m.common.tool.tool;
import m.log.Log;

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
public class OutHeader{
	public static final int COMMONHEADER_OUTPUT_SIZE = 145;

	public static final byte STARTER = (byte)0xfe;
	
	private byte[] header = tool.makeFullSpaceBtyeArray(145);
	
	/**
	 * CommonHeader를 생성한다.
	 * @param web Web Parameter를 전달할 Web Request
	 */
	public OutHeader(byte[] header) throws Exception{
		this.header = header;
//		print();
	}//end of CommonHeader();
	
	/**
	 * Output Header를 byte[]로 return한다.
	 * @return
	 */
	public byte[] getOutputHeader() throws Exception{
		return header;
	}//end of getOutputHeader();
	
	/**
	 * 압축여부를 가져온다.
	 * @return
	 */
	public byte getCompression() throws Exception{
		return this.header[2];
	}//end of getUsip();
	
	/**
	 * data length를 return한다.
	 * @return
	 */
	public int getLength() throws Exception{
		byte[] len =tool.makeFullSpaceBtyeArray(5);
		
		System.arraycopy(this.header, 3, len, 0, len.length);
		String length = new String(len);
		try{
			if(tool.isNull(length))		return 0;
			return Integer.parseInt(length.trim())-137;
		}catch(Exception e){
			return 0;
		}
	}//end of getLength();
	
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
	public String getService() throws Exception{
		byte[] s = tool.makeFullSpaceBtyeArray(10);
		System.arraycopy(this.header, 34,s,0,s.length);
		return new String(s).trim();
	}//end of getService();
	
	/**
	 * ReturnCode를 return한다.
	 * @return errorCode 0 : 정상, 1 : 에러
	 */
	@SuppressWarnings("unused")
	public String getReturnCode() throws Exception{
		byte[] rc = tool.makeFullSpaceBtyeArray(1);
		System.arraycopy(this.header, 44, rc, 0, rc.length);
		if(rc == null)	return new String("1");
		else return new String(rc);
	}//end of getReturnCode();

	/**
	 * User Filler를 Setting한다.
	 * @return filler
	 */
	public String getUserFiller() throws Exception{
		byte[] filler = tool.makeFullSpaceBtyeArray(10);
		System.arraycopy(this.header, 45, filler, 0, 10);
		return new String(filler);
	}//end of getUserFiller();

	/**
	 * User Filler를 Setting한다.
	 * @return filler
	 */
	public String getFiller() throws Exception{
		byte[] filler = tool.makeFullSpaceBtyeArray(10);
		System.arraycopy(this.header, 55, filler, 0, 10);
		return new String(filler);
	}//end of getUserFiller();

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
	 * CommonHeader log 출력
	 */
	private void print() throws Exception{
		Log.println("[TR][HEADER] compression: " 	+ this.getCompression());
		Log.println("[TR][HEADER] dataLength: " 	+ this.getLength());
		Log.println("[TR][HEADER] userIP: " 		+ this.getUsip());
		Log.println("[TR][HEADER] trCode: " 		+ this.getTrName());
		Log.println("[TR][HEADER] serviceCode: " 	+ this.getService());
		Log.println("[TR][HEADER] error: " 			+ this.getReturnCode());
		Log.println("[TR][HEADER] message: " 		+ this.getReturnMessage());
	}
}//end of CommonHeader
