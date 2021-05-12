package m.action.executer;

import java.util.StringTokenizer;

import m.action.ActionException;
import m.action.IConstants;
import m.common.tool.tool;
import m.format.DefinitionFactory;
import m.format.Transaction;
import m.format.header.InHeader;
import m.format.header.OutHeader;
import m.format.header.TMaxHeader;
import m.log.Log;
import m.web.common.WebInterface;
import m.web.common.WebParam;
import m.json.JSONObject;

/**
 * TR 처리를 위한 super class.
 * @author nhy67
 */
public abstract class TransactionExecuter implements IConstants{
 
	//------------------------------------- 필수적으로 필요한 항목들. ----------------------------------------------
	private String 			trName;					//TR명
	protected WebInterface 	req;					//request/response
	private InHeader 			inHeader;				//Input Common Header
	private OutHeader 			outHeader;				//Output Common Header
	private TMaxHeader 		tmaxInHeader;			//TMAX InHeader
	private TMaxHeader 		tmaxOutHeader;			//TMAX Output Header
	protected byte[] 			input;					//input data
	protected byte[] 			output;					//output data
	protected JSONObject 		outdata;				//Output data 가공된거.
	private String 			originValue 	= "";	//원문
	private String 			certValue 		= "";	//서명값
	private String 			messageCode;			//메세지 코드
	private String 			message;				//메세지 
	private String 			returnCode;				//리턴 코드
	private String 			mediaCode;				//미디어코드
	
	
	//------------------------------------- 로그를 남기기 위해 필요한 항목들. ----------------------------------------------
	private long 				connectiontime;		//Connection을 가져오는데 걸린 시간.
	private long 				trtime;				//TR 처리 소요시간
	private boolean 			success;			//TR 처리 성공여부
	private char 				host = ' ';			//Host
	private String 			hostIP;				//Host Server IP
	private boolean 			isCertify;			//전자서명검증 여부
	private boolean 			isLcombo = false;	//lcombo 존재 여부

	//------------------------------------- Async 처리를 위해 필요한 항목들. ----------------------------------------------
	private int status 					= -1;		/*
														 * -1 : send 이전
														 * 1 : send 이후
														 * 2 : receive 이후
														 */

	/**
	 * receive status를 Setting한다.
	 * @param status -1 : ready
	 * 				 1 : send이후
	 *    			 2 : receive 이후
	 */
	protected final void setStatus(int status){
		this.status = status;
	}//end of setStatus();
	
	/**
	 * receive status를 return한다.
	 * @param status -1 : ready
	 * 				 1 : send이후
	 *    			 2 : receive 이후
	 */
	public final int getStatus(){
		return this.status;
	}//end of getStatus();
	
	/**
	 * @param req
	 */
	public TransactionExecuter(WebInterface req, String trName) throws Exception{
		switch(req.getType()){
	        case WebInterface.JSP 	: this.req = (WebParam)req;		break;
        }
		if(tool.isNull(trName)){
			Log.println(req, "[TR][EXCEPTION][ER0112][trName is null]");
			throw new ActionException("[ER0112]", TR_DATA_ERR_MSG);
		}else{
			this.trName = trName.trim();
		}
		try{
			Transaction definition = (Transaction)DefinitionFactory.getFormat(this.trName);
			if("pibohmax".equals(definition.getTR()))	this.monitor(this.req.getActionName(), definition.getTR()+"."+definition.getService(), this.req.getHeader("Referer"));
			else										this.monitor(this.req.getActionName(), definition.getTR(), this.req.getHeader("Referer"));
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of TRExecuter();

    /**
     * Monitor 시스템에서 사용할 Unique Name.
     * TR명  + "." + Service명으로 return한다.
     * @action Action Name
     * @tr Tr name
     * @referer Referer URL
     */
    private final void monitor(String action, String tr, String referer){
    }//end of monitor();
	
	/**
	 * WebInterface를 return한다.
	 * @return
	 */
	public final WebInterface getRequest(){
		return this.req;
	}//end of getRequest();
	
	/**
	 * TR명을 return한다.
	 * @return
	 */
	public final String getTR(){
		return this.trName;
	}//end of getTR()

	/**
	 * Connection을 가져오는데 걸린 시간.
	 * @param time
	 */
	protected final void setConnectionTime(long time){
		this.connectiontime = time; 
	}//end of setConnectionTime();
	
	/**
	 * Connection을 가져오는데 걸린 시간을 return한다.
	 * @return
	 */
	public final long getConnectionTime(){
		return this.connectiontime;
	}//end of getConnectionTime();
	
	/**
	 * TR 처리에 소요된 시간을 Setting한다.
	 * @param time
	 */
	protected final void setTrTime(long time){
		this.trtime = time;
	}//end of setTrTime();
	
	/**
	 * TR 처리에 소요된 시간을 return한다.
	 * @return
	 */
	public final long getTrTime(){
		return this.trtime;
	}//end of getTrTime();
	
	/**
	 * TR 처리 성공여부를 Setting한다.
	 * @param success
	 */
	protected final void setSuccess(boolean success){
		this.success = success;
	}//end of setSuccess();
	
	/**
	 * TR 처리 성공여부를 return한다.
	 * @return
	 */
	public final boolean getSuccess(){
		return this.success;
	}//end of getSuccess();
	
	/**
	 * Host를 Setting한다.
	 * @param host
	 */
	public final void setHost(char host){
		this.host = host;
	}//end of setHost();
	
	/**
	 * Host를 return한다.
	 * @return
	 */
	public final char getHost(){
		return this.host;
	}//end of getHost();
	
	/**
	 * Connection의 HOST IP를 Setting한다.
	 * @param index
	 */
	protected final void setHostIP(String ip){
		this.hostIP = ip;
	}//end of setHostIP();
	
	/**
	 * Connection의 Host IP를 return한다.
	 * @return
	 */
	public final String getHostIP(){
		return this.hostIP;
	}//end of getHostIP();

	/**
	 * InHeader를 Setting한다.
	 * @return
	 */
	protected final void setInHeader(InHeader inHeader) {
		this.inHeader = inHeader;
	}//end of setInHeader();

	/**
	 * InHeader를 리턴한다
	 * @return
	 */
	public final InHeader getInHeader() {
		return inHeader;
	}//end of getInHeader();

	/**
	 * OutHeader를 Setting한다.
	 * @return
	 */
	protected final void setOutHeader(OutHeader outHeader) {
		this.outHeader = outHeader;
	}//end of setOutHeader();

	/**
	 * OutHeader를 리턴한다
	 * @return
	 */
	public final OutHeader getOutHeader() {
		return outHeader;
	}//end of getOutHeader();

	/**
	 * Input data의 TMAXHeader를 Setting한다
	 * @return
	 */
	public final void setTmaxInHeader(TMaxHeader inHeader) {
		this.tmaxInHeader = inHeader;
	}//end of getTmaxInHeader();

	/**
	 * Input data의 TMAXHeader를 리턴한다
	 * @return
	 */
	public final TMaxHeader getTmaxInHeader() {
		return tmaxInHeader;
	}//end of getTmaxInHeader();

	/**
	 * Output data의 TMAX Header를 Setting한다.
	 * @return
	 */
	public final void setTmaxOutHeader(TMaxHeader outHeader){
		this.tmaxOutHeader = outHeader;
	}//end of getTmaxOutHeader();

	/**
	 * Output data의 TMAX Header를 return한다.
	 * @return
	 */
	public final TMaxHeader getTmaxOutHeader(){
		return tmaxOutHeader;
	}//end of getTmaxOutHeader();

	/**
	 * originValue를 Setting한다.
	 * @return
	 */
	protected final void setOriginValue(String originValue){
		this.originValue = originValue;
	}//end of setOriginValue();

	/**
	 * originValue를 return한다.
	 * @return
	 */
	public final String getOriginValue(){
		return this.originValue;
	}//end of getOriginValue();
	
	/**
	 * certValue를 Setting한다.
	 * @return
	 */
	public final void setCertValue(String certValue){
		this.certValue = certValue;
	}//end of setCertValue();

	/**
	 * certValue return한다.
	 * @return
	 */
	public final String getCertValue(){
		return this.certValue;
	}//end of getCertValue();
	
	/**
	 * 전자서명검증여부를 Setting한다.
	 * @param isCertify
	 */
	protected final void setIsCertify(boolean isCertify){
		this.isCertify = isCertify;
	}//endof isCertify();
	
	/**
	 * 전자서명검증여부를 return한다.
	 * @return
	 */
	public final boolean getIsCertify(){
		return this.isCertify;
	}//end of getIsCertify();
	
	/**
	 * 메세지코드를 Setting한다.
	 * @return
	 */
	public final void setMssageCode(String messageCode){		//==> 향후 오타 수정할 것!!! 어떻게 오타를 수정없이 그대로 사용하냐!!!
		this.messageCode = messageCode;
	}//end of setMssageCode();

	/**
	 * 메세지코드를 return한다.
	 * @return
	 */
	public final String getMssageCode(){		//==> 향후 오타 수정할 것!!! 어떻게 오타를 수정없이 그대로 사용하냐!!!
		if(this.messageCode == null)	return new String();
		return this.messageCode;
	}//end of getMssageCode();
	
	/**
	 * 메세지를 Setting한다.
	 * @return
	 */
	public final void setMssage(String msg){			//==> 향후 오타 수정할 것!!! 어떻게 오타를 수정없이 그대로 사용하냐!!!
		this.message = msg;
	}//end of setMssage();

	/**
	 * 메세지를 return한다.
	 * @return
	 */
	public final String getMssage(){			//==> 향후 오타 수정할 것!!! 어떻게 오타를 수정없이 그대로 사용하냐!!!
		if(this.message == null)	return new String();
		return this.message;
	}//end of getMssage();
	
	/**
	 * 리턴코드를 Setting한다.
	 * @return
	 */
	public final void setReturnCode(String returnCode){
		this.returnCode = returnCode;
	}//end of setReturnCode();

	/**
	 * 리턴코드를 return한다.
	 * @return
	 */
	public final String getReturnCode(){
		if(this.returnCode == null)	return new String();
		return this.returnCode;
	}//end of getReturnCode();
	
	/**
	 * TR처리 
	 * 1.각 TR설정에 따라 통신 방법 설정('WEBT' : WEBT, 'HTSBP' : HTSBP, 'DISABLED' : TR예외상황, 'DEFAULT' OR NULL : 기본 설정에 따른다)
	 * 2.전체 TR에 대한 통신 방법 설정('WEBT' : WEBT, 'HTSBP' : HTSBP, 'DISABLED' : TR예외상황)
	 * @return
	 * @throws Exception
	 */
	public abstract JSONObject send() throws Exception;

	/**
	 * Input Value를 Setting한다.
	 * @return
	 */
	public final void setInput(byte[] input) {
		this.input = input;
	}//end of setInput();

	/**
	 * Input Value를 return한다.
	 * @return
	 */
	public final byte[] getInput() throws Exception{
		return tool.append(inHeader.getInputHeader(), this.input);
	}//end of getInput();
	
	/**
	 * Output Value를 Setting한다.
	 * @return
	 */
	public final void setOutput(byte[] output) {
		this.output = output;
	}//end of setOutput();

	/**
	 * Output Value를 return한다.
	 * @return
	 */
	public final byte[] getOutput() throws Exception{
		return tool.append(outHeader.getOutputHeader(), this.output);
	}//end of getOutput();

	/**
	 * Output data를 Setting한다.
	 * @return
	 */
	protected final void setOutdata(JSONObject outdata){
		this.outdata = outdata;
	}//end of setOutdata()

	/**
	 * Output data를 format를 이용해서 가공한 결과를 return한다.
	 * @return
	 */
	public final JSONObject getOutdata() {
		return this.outdata;
	}//end of getOutdata()
	
	/**
	 * 전자서명검증 후 성공하면 TR을 전송하고, 실패하면 Error를 return한다.
	 * @param originValue 원문
	 * @param certValue 서명값
	 * @return JSONObject
	 * @throws Exception
	 */
	public  JSONObject executeCertTR() throws Exception{
		return null;
	}//end of executeCertTR();

	/**
	 * 매체코드를 Setting한다.
	 * @return
	 */
	public final void setMediaCode(String mediaCode){
		this.mediaCode = mediaCode;
	}//end of getMediaCode();

	/**
	 * 매체코드를 가져온다.
	 * @return
	 */
	public final String getMediaCode(){
		if(tool.isNull(this.mediaCode))		return this.req.getMediaCode();
		else								return this.mediaCode;
	}//end of getMediaCode();
	
	/**
	 * Mac Address를 가져온다.
	 * @return
	 */
	public final String getMacAddr(){
		return this.req.getMacAddr();
	}//end of getMacAddr();
	
	/**
	 * 사용자 ID를 가져온다.
	 * @return
	 */
	public final String getUsid(){
		return this.req.getUsid();
	}//end of getUsid();
	
	/**
	 * 로그인IP를 가져온다.
	 * @return
	 */
	public final String getIp(){
		String ip = this.req.getIp();
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
	}//end of getIp();
	
	/**
	 * client ip를 가져온다.
	 * @return
	 */
	public final String getClientIP(){
		return this.req.getClientIP();
	}//end of getClientIP();
	
	/**
	 * 비상여부를 가져온다.
	 * @return
	 */
	public final String getXchk(){
		return this.req.getXchk();
	}//end of getXchk();
	
	/**
	 * 공개키를 가져온다.
	 * @return
	 */
	public final String getPkey(){
		return this.req.getPkey();
	}//end of getPkey();
	
	/**
	 * 공개키를 Setting한다.
	 * @param pkey
	 */
	public final void setPkey(String pkey){
		this.req.setPkey(pkey);
	}//endof setPkey();

	/**
	 * LCombo 존재여부를 Setting한다.
	 * @param isLCombo
	 */
	protected final void setLCombo(boolean isLCombo){
		this.isLcombo = isLCombo;
	}//end of setLCombo();

	/**
	 * LCombo 존재여부를 return한다.
	 * @return
	 */
	protected final boolean getLCombo(){
		return this.isLcombo;
	}//end of getLCombo();
	
}//end of Executer
