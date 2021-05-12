package m.action;

import java.util.Enumeration;

import m.common.tool.tool;
import m.json.JSONObject;
import m.log.Log;
import m.pool.transclient.Connection;
import m.pool.transclient.Manager;
import m.web.common.WebInterface;
import m.web.common.WebParam;

/**
 * 웹서비스 처리를 위한 클래스
 * @author 김대원
 *
 */
public class TransExecuter implements IConstants{
	//------------------------------------- 필수적으로 필요한 항목들. ----------------------------------------------
	private 	String 			trName;					//TR명
	private 	WebInterface 	req;					//request/response
	private		String			input = new String();	//input data
	
	//------------------------------------- 로그를 남기기 위해 필요한 항목들. ----------------------------------------------
	private 	boolean 		success;			//TR 처리 성공여부
	private		long 			connectiontime;		//Connection을 가져오는데 걸린 시간.
	private 	long 			trtime;				//TR 처리 소요시간
	
	/**
	 * WebInterface를 return한다.
	 * @return
	 */
	public WebInterface getRequest(){
		return this.req;
	}//end of getRequest();
	
	/**
	 * 처리 성공여부를 Setting한다.
	 * @param success
	 */
	private void setSuccess(boolean success){
		this.success = success;
	}//end of setSuccess();
	
	/**
	 * 처리 성공여부를 return한다.
	 * @return
	 */
	public boolean getSuccess(){
		return this.success;
	}//end of getSuccess();
	
	/**
	 * Connection을 가져오는데 걸린 시간.
	 * @param time
	 */
	private void setConnectionTime(long time){
		this.connectiontime = time; 
	}//end of setConnectionTime();
	
	/**
	 * Connection을 가져오는데 걸린 시간을 return한다.
	 * @return
	 */
	public long getConnectionTime(){
		return this.connectiontime;
	}//end of getConnectionTime();
	
	/**
	 * 처리에 소요된 시간을 Setting한다.
	 * @param time
	 */
	private void setTrTime(long time){
		this.trtime = time;
	}//end of setTrTime();
	
	/**
	 * 처리에 소요된 시간을 return한다.
	 * @return
	 */
	public long getTrTime(){
		return this.trtime;
	}//end of getTrTime();
	
	/**
	 * @param req
	 */
	public TransExecuter(WebInterface req, String trName) throws Exception{
		switch(req.getType()){
	        case WebInterface.JSP 	: this.req = (WebParam)req;		break;
        }
		
		if(tool.isNull(trName)){
			Log.println("[TR][EXCEPTION][ER0112][trName is null]");
			throw new ActionException("[ER0112]", TR_DATA_ERR_MSG);
		}else{
			this.trName = trName.trim();
		}
	}//end of DBExecuter();
	
	/**
	 * 웹서비스처리 
	 * @return
	 * @throws Exception
	 */
	public JSONObject execute() throws Exception {
		try{
			Log.println("[CO][" +this.trName + "][START]");
			return this.executeTrans();
		}catch(Exception e){
			this.setSuccess(false);
			throw e;
		}finally{
		}
	}//end of execute();
	
	private JSONObject executeTrans() throws Exception{
		Log.println("[TR][INFO][executeComm]");
		Connection conn = null;
		long startTime = System.currentTimeMillis();
		try{
				conn = Manager.getConnection();
				Log.println("[TR][CONNECT] ["+ this.trName +"]" + "[" + conn.getId() + "]");
				this.setConnectionTime(System.currentTimeMillis()-startTime);
				makeInputData();
				conn.writeData(this.input.getBytes());
				this.setSuccess(true);
				return conn.readJSONData();
		}catch(Exception e){
			throw e;
		}finally{
			this.setTrTime(System.currentTimeMillis()-startTime);
			if(conn != null)	conn.close();
		}
	}//end of executeComm();
	
	/**
	 * parametar 형태의 input data생성
	 * @return
	 */
	private void makeInputData(){
		this.input 		= "trName="+this.trName;
		String gubun 	= "&";
		
		Enumeration<String> pEm = req.getParameterNames();
		while (pEm.hasMoreElements()) {
			
			String str 		= pEm.nextElement();
			String val 		= req.getString(str);
			
			input += gubun + str + "=" + val;
		}
		
		Enumeration<String> aEm = req.getAttributeNames();
		while (aEm.hasMoreElements()) {
			String str 		= aEm.nextElement();
			String val 		= req.getString(str);
			
			input += gubun + str + "=" + val;
		}
	}//end of makeInputData();
}//end of DBExecuter();
