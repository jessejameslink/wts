package m.action.executer;

import java.io.ByteArrayOutputStream;
import java.util.List;
import org.jdom2.Element;
import m.action.ActionException;
import m.common.tool.tool;
import m.config.DataConfig;
import m.format.DefinitionFactory;
import m.format.Transaction;
import m.format.header.TMaxHeader;
import m.json.JSONArray;
import m.json.JSONObject;
import m.log.Log;
import m.log.LogUtil;
import m.pool.client.Connection;
import m.pool.client.Manager;
import m.web.common.WebInterface;

public class Comm extends TransactionExecuter {


	//------------------------------------- 로그를 남기기 위해 필요한 항목들. ----------------------------------------------
	private String 		path;				//TR 처리경로

	/**
	 * @param req
	 */
	public Comm(WebInterface req, String trName) throws Exception{
		super(req, trName);
	}//end of TRExecuter();

	/**
	 * TR 처리경로를 Setting한다.
	 * TR 처리경로는 HTSBP, WEBT, Disabled 세 가지가 있다.
	 * @param path Comm이면 C, Disabled이면 D를 Setting한다.
	 */
	private void setPath(String path){
		this.path = path;
	}//end of setPath();
	
	/**
	 * TR 처리경로를 return한다.
	 * @return Comm이면 C, Disabled이면 D를 return한다.
	 */
	public String getPath(){
		return this.path;
	}//end of getPath();
	
	/**
	 * TR처리 
	 * 1.각 TR설정에 따라 통신 방법 설정('WEBT' : WEBT, 'HTSBP' : HTSBP, 'DISABLED' : TR예외상황, 'DEFAULT' OR NULL : 기본 설정에 따른다)
	 * 2.전체 TR에 대한 통신 방법 설정('WEBT' : WEBT, 'HTSBP' : HTSBP, 'DISABLED' : TR예외상황)
	 * @return
	 * @throws Exception
	 */
	public JSONObject send() throws Exception{
System.out.println("CommExecuter.execute 1");
		Transaction definition;
		try{
			definition = (Transaction)DefinitionFactory.getFormat(this.getTR());
			if(definition==null){
				Log.println(req, "[TR][EXCEPTION][ER0100][TR에 대한 definition이 존재하지 않음]");
				throw new ActionException("[ER0100]", TR_DATA_ERR_MSG);
			}
			Log.println(req, "[TR][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][START]");
			if(this.getHost() == ' '){
				this.setHost(definition.getHost());
			}else{
				definition.setHost(this.getHost());
			}
System.out.println("CommExecuter.execute 2 ");
			this.outdata = new JSONObject();
			String path = DataConfig.getPath(req, definition);
System.out.println("CommExecuter.execute path : " + path);
			if("DISABLED".equals(path)){
				this.setPath("D");		//disabled
				Log.println(req, "[TR][EXCEPTION][ER0101][모든 연결이 비상]");
				throw new ActionException("[ER0001]",BISANG_MSG);
			}else{
System.out.println("CommExecuter.execute 3 ");
				this.setPath("C");		//Communicator
				return this.executeComm(definition);
			}
		}catch(Exception e){
			this.setSuccess(false);
			throw e;
		}finally{
			LogUtil.printTRLog(this);
		}
	}//end of execute();
	

	@SuppressWarnings("unchecked")
	private JSONObject executeComm(Transaction definition) throws Exception{
		Log.println(req, "[TR][INFO][executeComm]");
		Connection conn = null;
		try{
			Element format = definition.getFormat();
			TMaxHeader tmaxInHeader = new TMaxHeader(4, req, definition);
	        tmaxInHeader.setMedia(req.getMediaCode());
	        tmaxInHeader.setMacAddr(req.getMacAddr());
	        this.setTmaxInHeader(tmaxInHeader);
			this.makeInput(format);
			long startTime = System.currentTimeMillis();
			try{
System.out.println("Befor Connect : ");
				conn = Manager.getConnection();
System.out.println("After Connect : ");
				Log.println(req, "[TR][CONNECT] ["+ definition.getTR() +"]" + "[" + conn.getId() + "]");
				this.setHostIP(conn.getHost());
				this.setConnectionTime(System.currentTimeMillis()-startTime);
/*				
				if("commhmax".equals(definition.getTR())){
					conn.writeData(this.tmaxInHeader.getHeader());
				}
*/
System.out.println("header==["+new String(tmaxInHeader.getHeader())+"]");
				conn.writeTMaxHeader(tmaxInHeader.getHeader());
System.out.println("input==["+new String(this.input)+"]");
				conn.writeData(this.input);
			}finally{
				this.setTrTime(System.currentTimeMillis()-startTime);
			}
/*
			if("commhmax".equals(definition.getTR())){
				byte[] tMaxHearOutput = conn.readTMaxHeader();
				this.tmaxOutHeader = new TMaxHeader(COMM, req, definition);
				this.tmaxOutHeader.setHeader(tMaxHearOutput);
			}
			
			if("commhmax".equals(definition.getTR())){
				if(!definition.getService().equals(this.tmaxOutHeader.getService())){
					LogUtil.printIDExceptionLog(this);
					Log.println(req, "[TR][EXCEPTION][ER0103][PB처리시 서비스명이 output값과 동일하지 않음]");
					throw new ActionException("[ER0103]", TR_DATA_ERR_MSG);
				}
			}
			
			if("commhmax".equals(definition.getTR())){
				this.outdata.put("messageCode", this.tmaxOutHeader.getMessageCode());
				this.outdata.put("message", this.tmaxOutHeader.getReturnMessage());
				this.outdata.put("returnCode", this.tmaxOutHeader.getReturnCode());
				this.messageCode 	= 	this.tmaxOutHeader.getMessageCode();
				this.message 		= 	this.tmaxOutHeader.getReturnMessage();
				this.returnCode 	= 	String.valueOf(this.tmaxOutHeader.getReturnCode());
			}
*/
			byte[] h = conn.readTMaxHeader();
			TMaxHeader tmaxOutHeader = new TMaxHeader(COMM, h);
			this.setTmaxOutHeader(tmaxOutHeader);
System.out.println("CommExecuter.header==["+new String(tmaxOutHeader.getHeader())+"]");
			this.outdata.put("messageCode", tmaxOutHeader.getMessageCode());
			this.outdata.put("message", tmaxOutHeader.getReturnMessage());
			this.outdata.put("returnCode", tmaxOutHeader.getReturnCode());
			this.setMssageCode(tmaxOutHeader.getMessageCode());
			this.setMssage(tmaxOutHeader.getReturnMessage());
			this.setReturnCode(tmaxOutHeader.getReturnCode());
//			if(!"0".equals(this.returnCode)){
				int len = -1;
				byte[] r = new byte[8192];
				while((len=conn.read(r))!=-1){
					this.output = tool.append(this.output, r, 0, len);
				}
System.out.println("this.output=="+new String(this.output));			
				Log.println(req, "[TR][OUTPUT] ["+ new String(this.output, "utf-8")+"]");
				
				this.makeOutput(format);
				this.setSuccess(true);
//			}
			return this.outdata;
		}catch(Exception e){
			throw e;
		}finally{
			if(conn != null)	conn.close();
		}
	}//end of executeComm();
	
	/**
	 * TmaxInput Value를 return한다.
	 * @return
	 */
	public byte[] getTmaxInput() throws Exception{
		return tool.append(getTmaxInHeader().getHeader(), this.input);
	}//end of getTmaxInput();
	
	/**
	 * TmaxOutput Value를 return한다.
	 * @return
	 */
	public byte[] getTmaxOutput() throws Exception{
		return tool.append(getTmaxOutHeader().getHeader(), this.output);
	}//end of getTmaxOutput();
	
	/**
	 * Input Stream data를 생성한다.
	 */
	private void makeInput(Element format) throws Exception{
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		try{
			List<Element> list = format.getChildren();
			for(int i=0,len=list.size();i<len;i++){
				Element child = list.get(i);
				byte[] val = makeTRInput(req, child.getAttributeValue("name"), child);
				if(val!=null)		outStream.write(val);
			}
			this.input = outStream.toByteArray();
		}finally{
			Log.println(req, "[TR][INPUT] [" +outStream.toString("utf-8")+"]");
		}
	}//end of makeInput();
	
	private byte[] makeTRInput(WebInterface req, String parameterName, Element element) throws Exception{
		if("value".equals(element.getName())){
			if("in".equals(element.getAttributeValue("io"))||"inout".equals(element.getAttributeValue("io"))){
				Object obj = req.getAttribute(parameterName);
				byte[] result;
				if(obj != null && obj instanceof byte[]){
					result = (byte[])obj;
				}else{
					String value = req.getString(parameterName);
					result = value.getBytes("utf-8");
				}
				
				String size 		= element.getAttributeValue("length");
				String direction 	= element.getAttributeValue("direction");
				
				if(tool.isNull(size))		return null;
				
				int len = Integer.parseInt(size);
				if(result.length==len){
					return result;
				}else if(result.length<len){
					byte[] rvalue = tool.makeFullSpaceBtyeArray(len);
					if("RIGHT".equalsIgnoreCase(direction)){
						System.arraycopy(result, 0, rvalue ,len-result.length, result.length);
					}else{
						System.arraycopy(result, 0, rvalue,0, result.length);
					}
					
					return rvalue;
				}else{
					byte[] rvalue = new byte[len];
					System.arraycopy(result, 0, rvalue,0, len);
					return rvalue;
				}
			}
		}else if("table".equals(element.getName())){
			java.util.List<Element> list = element.getChildren();
			if(list!=null){
				byte[] result = null;
				String cnt = element.getAttributeValue("count");
				int gridSize = 0;
				if(isInt(cnt)){
					gridSize = Integer.parseInt(cnt.trim());
				}else if("*".equals(cnt)){
					gridSize = Integer.parseInt(req.getString("count"));
				}else{
					String val = req.getString(cnt);
					if(isInt(val))	gridSize = Integer.parseInt(val);
					else			gridSize = 0;
				}
				for(int i=0;i<gridSize;i++){
					for(int j=0,len=list.size();j<len;j++){
						Element child = list.get(j);
						byte[] val = this.makeTRInput(req, child.getAttributeValue("name")+"_"+i, child);
						result = tool.append(result, val);
					}
				}
				return result;
			}
		}
		return null;
	}//end of makeInput();
	
	/**
	 * 주어진 String이 int value인지 여부를 check한다.
	 * @param value
	 * @return
	 */
	private boolean isInt(String value){
		try{
			if(tool.isNull(value))		return false;
			Integer.parseInt(value.trim());
			return true;
		}catch(Exception e){
			return false;
		}
	}//end of isInt();

	private JSONObject makeOutput(Element format)throws Exception{
		List<Element> list = format.getChildren();
		int index = 0;
		for(int i=0,len=list.size();i<len;i++){
			Element child = list.get(i);
			index = makeTROutput(child, index, child.getAttributeValue("name"), this.outdata);
		}
		return this.outdata;
	}//end of makeOutput();

	@SuppressWarnings("unchecked")
	private int makeTROutput(Element element, int index, String parameterName, JSONObject data) throws Exception{
		if("value".equals(element.getName())){
			if("out".equals(element.getAttributeValue("io"))||"inout".equals(element.getAttributeValue("io"))){
				String size = element.getAttributeValue("length");
				int len = 0;
				if("*".equals(size)){
					len = getSizeOfNullTerminated(output, index);
				}else{
					len = Integer.parseInt(size.trim());
				}
				
				if(index+len>output.length){
					Log.println(req, "[TR][EXCEPTION][ER0107][output길이가 definition과 일치하지 않음][length]["+(index+len)+"]["+output.length+"]");
					throw new ActionException("[ER0107]", TR_DATA_ERR_MSG);
				}
				
				byte[] result = tool.makeFullSpaceBtyeArray(len);
				System.arraycopy(this.output, index, result, 0, len);
				data.mput(parameterName, result);
				return index+len;
			}
		}else if("table".equals(element.getName())){
			java.util.List<Element> list = element.getChildren();
			
			if(list!=null){
				JSONArray rsArr = new JSONArray();
				data.put(parameterName, rsArr);
				if(element.getAttributeValue("parse") != null && "null-terminated".equalsIgnoreCase(element.getAttributeValue("parse"))){
					while(getNextByte(index) != -1){
						JSONObject gridData = new JSONObject();
						//rsArr.add(gridData);
						for(int j=0,len=list.size();j<len;j++){
							if(this.output[index] == 0){
		                        index = this.output.length; 
								break;
							}
							Element child = list.get(j);
							index = this.makeTROutput(child, index, child.getAttributeValue("name"), gridData);
						}
						if(getNextByte(index) != -1)	rsArr.add(gridData);
					}
				}else{
					String cnt = element.getAttributeValue("count");
					int gridSize = 0;
					if(cnt.charAt(0) == '*'){
						while(getNextByte(index) != -1){
							JSONObject gridData = new JSONObject();
							//rsArr.add(gridData);
							for(int j=0,len=list.size();j<len;j++){
								Element child = list.get(j);
								index = this.makeTROutput(child, index, child.getAttributeValue("name"), gridData);
							}
							if(getNextByte(index) != -1)	rsArr.add(gridData);
						}
					}else{
						if(isInt(cnt)){
							gridSize = Integer.parseInt(cnt.trim());
						}else{
							if(isInt((String)data.get(cnt))){
								gridSize = Integer.parseInt((String)data.get(cnt));
							}else{
								gridSize = 0;
							}
						}
						
						for(int i=0;i<gridSize;i++){
							JSONObject gridData = new JSONObject();
							rsArr.add(gridData);
							for(int j=0,len=list.size();j<len;j++){
								Element child = list.get(j);
								index = this.makeTROutput(child, index, child.getAttributeValue("name"), gridData);
							}
						}
					}
				}
				return index;
			}
		}
		return index;
	}//end of makeOutput();
	
	/**
	 * type이 data인 value에 대해서 값이 0이 나올때 까지의 index를 구해서 return한다.
	 * @param output
	 * @param index
	 * @return
	 * @throws Exception
	 */
	private int getSizeOfNullTerminated(byte[] output, int index) throws Exception{
		int startIndex = index;
		int length = output.length;
		while(index < length && output[index] != 0){
			index++;
		}
		int size = index-startIndex;
		return size;
	}//end of getSizeOfNullTerminated();
	
	// 다음에 읽혀질 바이트를 미리 엿본다
	public byte getNextByte(int index){
		if(index+1 < output.length)		return output[index];
		else						return -1;
	}//end of getNextByte();
	
}//end of Comm