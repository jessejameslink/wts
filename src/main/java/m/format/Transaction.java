package m.format;

import m.action.IConstants;
import m.common.tool.tool;
import org.jdom2.Document;
import org.jdom2.Element;
/**
 * TR/DB 조회/처리에 대한 데이터 포맷을 정의한다.
 * 데이터는 Input/Output으로 구성되고, 각각 Header/Data 부분을 가진다.
 * 원장 데이터의 경우, CommonHeader/TMAXHeader/PBPRHeader 구조를 가질 수 있다.
 * @author poemlife
 */
public class Transaction implements Definition, IConstants{
	private String 	tr;			//TR명
	private String 	service;	//원장 TR명
	private char 	host;		//원장 종류(0, 1, 7)
	private String 	datatype;	//데이터 종류(TR, OOP)
	private Element format;		//Input/Output format

	public Transaction(Document doc){
		if(doc==null)		return;
		format = doc.getRootElement();
		this.setTR(format.getAttributeValue("trcode"));
		this.setService(format.getAttributeValue("servicecode"));
		this.setHost(format.getAttributeValue("host"));
		this.setDatatype(format.getAttributeValue("datatype"));
	}//end of Definition();
	
	/**
	 * Data Source타입을 return한다.
	 * Transaction class는 TR을 처리하는 class이므로, 무조건 TRANSACTION을 return한다.
	 */
	public int getDataType(){
		return TRANSACTION;
	}//end of getDataType();
	
	/**
	 * TR명을 Setting한다.
	 * @param trName
	 */
	private void setTR(String trName){
		this.tr = trName;
	}//end of setTrName();

	/**
	 * TR명을 return한다.
	 * @return
	 */
	public String getTR(){
		if(this.tr==null)		return new String();
		else					return this.tr.trim();
	}//end of getTr();
	
	/**
	 * Service명을 Setting한다.
	 * @param service
	 * @author Owner 20150710 김종명 수정.
	 *     개인화 조회를 위한 TR모듈 적용을 위해 pibohmax라는 TR명 고정부분을 삭제
	 *     향후 tr xml 파일 생성시 반드시 tr명과 service명을 입력해주어야 함.
	 */
	private void setService(String service){
		if(service!=null)		this.service = service;
/*
		if(service!=null&&service.trim().length()==9){
			this.setTR("pibohmax");
			this.service = service;
		}
*/
	}//end of setService();
	
	/**
	 * Service명을 리턴한다.
	 * @param service
	 */
	public String getService(){
		return this.service;
	}//end of getService();
	
	/**
	 * 접속할 원장의 종류.
	 * @param host
	 * 		0 : 업무계
	 * 		1 : 정보계
	 * 		7 : 일부
	 */
	private void setHost(String host){
		if(tool.isNull(host)){	
			if("pibohmax".equalsIgnoreCase(this.tr)){
				this.setHost(HOST_TRANSACTION);
			}else if("pibomagn".equalsIgnoreCase(this.tr)){
				this.setHost("10.0.10.2");
			}else{
				this.host = ' ';
			}
		}
		else{
			this.setHost(host.charAt(0));
		}
	}//end of setHost();
	
	/**
	 * Host를 Setting한다.
	 * @param host
	 */
	public void setHost(char host){
		this.host = host;
	}//end of setHost();
	
	/**
	 * Host를 return한다.
	 * @return ' ' : Host 없음.(원장TR아님), '0' : 업무계, '1' : 정보계
	 */
	public char getHost(){
		return this.host;
	}//end of getHost();
	
	/**
	 * Datatype을 Setting한다.
	 * @param trName
	 */
	private void setDatatype(String datatype){
		this.datatype = datatype;
	}//end of setDatatype();

	/**
	 * Datatype을 return한다.
	 * @return
	 */
	public String getDatatype(){
		if(this.datatype==null)	return new String();
		else					return this.datatype.trim();
	}//end of getDatatype();
	
	/**
	 * Input/Output format을 return한다.
	 * @return
	 */
	public Element getFormat(){
		return this.format;
	}//end of getFormat();
	
}//end of Definition
