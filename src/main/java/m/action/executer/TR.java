package m.action.executer;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import org.jdom2.Element;

import m.action.ActionException;
import m.common.tool.tool;
import m.config.DataConfig;
import m.config.SystemConfig;
import m.format.DefinitionFactory;
import m.format.GridIn;
import m.format.GridOut;
import m.format.Transaction;
import m.format.header.InHeader;
import m.format.header.OutHeader;
import m.format.header.TMaxHeader;
import m.json.JSONArray;
import m.json.JSONObject;
import m.log.Log;
import m.log.LogUtil;
import m.pool.socket.Connection;
import m.pool.socket.Pool;
import m.web.common.WebInterface;
import tmax.webt.WebtBuffer;
import tmax.webt.WebtConnection;
import tmax.webt.WebtConnectionPool;
import tmax.webt.WebtRemoteService;

public class TR extends TransactionExecuter {
	//------------------------------------- 로그를 남기기 위해 필요한 항목들. ----------------------------------------------
	private String 		path;				//TR 처리경로

	/**
	 * @param req
	 */
	public TR(WebInterface req, String trName) throws Exception{
		super(req, trName);
	}//end of TRExecuter();

	/**
	 * TR 처리경로를 Setting한다.
	 * TR 처리경로는 HTSBP, WEBT, Disabled 세 가지가 있다.
	 * @param path HTSBP이면 H, WEBT이면 W, Disabled이면 D를 Setting한다.
	 */
	private void setPath(String path){
		this.path = path;
	}//end of setPath();
	
	/**
	 * TR 처리경로를 return한다.
	 * @return HTSBP면 H, WEBT면 W, Disabled이면 D를 return한다.
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
		Transaction definition;
		try{
			if(!tool.isNull(getUsid())&&!getIp().equals(getClientIP())){
				System.out.println("[TR][EXCEPTION][ER0117][로그인 IP와 client IP가 동일하지 않음]["+tool.getCurrentTime()+"]["+getUsid()+"]["+getIp()+"]["+getClientIP()+"]["+req.getRequest()+"]");
//				throw new ActionException("[ER0117]", LOGIN_INFO_SELECT_FAIL_MSG);
			}
			definition = (Transaction)DefinitionFactory.getFormat(getTR());
			if(definition==null){
				System.out.println("[TR][EXCEPTION][ER0100]["+getTR()+"][TR에 대한 definition이 존재하지 않음]");
				throw new ActionException("[ER0100]", TR_DATA_ERR_MSG);
			}
			Log.println(req, "[TR][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][START]");
			if(getHost() == ' '){
				this.setHost(definition.getHost());
			}else{
				definition.setHost(getHost());
			}
			
			JSONObject outdata = new JSONObject();
			this.setOutdata(outdata);
			String path = DataConfig.getPath(req, definition);
			if("DISABLED".equals(path)){
				this.setPath("D");		//disabled
				Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0101][모든 연결이 비상]");
				throw new ActionException("[ER0001]",BISANG_MSG);
			}else if("HTSBP".equals(path)){
				this.setPath("H");		//HTSBP
				return this.executeHTSBP(definition);
			}else if(path.startsWith("tmax")){
				this.setPath("W");		//WEBT
				return executeWebT(definition, path);
			}
		}catch(Exception e){
			this.setSuccess(false);
			throw e;
		}finally{
			LogUtil.printTRLog(this);
		}
		return new JSONObject();
	}//end of execute();
	
	/**
	 * BP를 이용한 TR처리
	 * @param definition
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private JSONObject executeHTSBP(Transaction definition) throws Exception{
		if(!SystemConfig.isAvoidLogTR(definition.getTR())){
			Log.println(req, "[TR][INFO][executeHTSBP][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "]");
		}
		Connection conn = null;
		long startTime = System.currentTimeMillis();
		
		try{
			Element format = definition.getFormat();
			this.makeInput(definition, format);
			InHeader inHeader = new InHeader(req, definition);
			inHeader.setLength(this.input.length);
			TMaxHeader tmaxInHeader = null;
			if("pibohmax".equals(definition.getTR())){
				tmaxInHeader = new TMaxHeader(HTSBP, req, definition);
				tmaxInHeader.setMedia(getMediaCode());
				tmaxInHeader.setMacAddr(getMacAddr());
				this.setTmaxInHeader(tmaxInHeader);
			}
			Pool pool = Pool.getInstance();
			conn = pool.getConnection();
			if(!SystemConfig.isAvoidLogTR(definition.getTR())){
				Log.println(req, "[TR][CONNECT][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][" + conn.getId() + "]");
			}
			
			this.setHostIP(conn.getHost());
			this.setConnectionTime(System.currentTimeMillis()-startTime);
			//공통Header Write
			setInHeader(inHeader);
			conn.writeHeader(inHeader);
			//TMAX Header Write
			if("pibohmax".equals(definition.getTR())){
				if(tmaxInHeader!=null)		conn.writeData(tmaxInHeader.getHeader());
			}
			//Input data Write
			conn.writeData(this.input);

			//공통Header read
			byte[] outh = conn.readCommonHeader();
			OutHeader outHeader = new OutHeader(outh);
			this.setOutHeader(outHeader);
			int datalen = outHeader.getLength();
			TMaxHeader tmaxOutHeader = null;
			if("pibohmax".equals(definition.getTR())){
				//TMAX Header read
				byte[] tMaxHearOutput = conn.readTMaxHeader();
				tmaxOutHeader = new TMaxHeader(HTSBP, req, definition);
				tmaxOutHeader.setHeader(tMaxHearOutput);
				this.setTmaxOutHeader(tmaxOutHeader);
				datalen -= TMaxHeader.HEADER_SIZE;
			}
			if(!definition.getTR().equals(outHeader.getTrName())){
				LogUtil.printIDExceptionLog(this);
				Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0102][PB처리시 TR명이 output값과 동일하지 않음]["+definition.getTR()+"]["+outHeader.getTrName()+"]");
				throw new ActionException("[ER0102]", TR_DATA_ERR_MSG);
			}
			
			if("pibohmax".equals(definition.getTR())){
				if(tmaxOutHeader!=null){
					if(!definition.getService().equals(tmaxOutHeader.getService())){
						LogUtil.printIDExceptionLog(this);
						Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0103][PB처리시 서비스명이 output값과 동일하지 않음]["+definition.getService()+"]["+tmaxOutHeader.getService()+"]");
						throw new ActionException("[ER0103]", TR_DATA_ERR_MSG);
					}
					/**
					 * Update 2012.10.04, By Min
					 * Out Header 값에서 IP 비교하여 아닌경우에 Exception 발생시킴.
					 */
					if(!getClientIP().equals(tmaxOutHeader.getClientIP())){
						LogUtil.printIDExceptionLog(this);
						Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0104][PBT처리시 client ip가 output값과 동일하지 않음]["+getClientIP()+"]["+tmaxOutHeader.getClientIP()+"]");
						throw new ActionException("[ER0104]", TR_DATA_ERR_MSG);
					}
				}
			}
			
			if("pibohmax".equals(definition.getTR())){
				if(tmaxOutHeader!=null){
					this.outdata.put("messageCode", tmaxOutHeader.getMessageCode());
					this.outdata.put("message", tmaxOutHeader.getReturnMessage());
					this.outdata.put("returnCode", tmaxOutHeader.getReturnCode());
					this.setMssageCode(tmaxOutHeader.getMessageCode());
					this.setMssage(tmaxOutHeader.getReturnMessage());
					this.setReturnCode(tmaxOutHeader.getReturnCode());
				}
			}else{
				this.outdata.put("messageCode", "");
				this.outdata.put("message", outHeader.getReturnMessage());
				this.outdata.put("returnCode", outHeader.getReturnCode());
				this.setMssageCode("");
				this.setMssage(outHeader.getReturnMessage());
				this.setReturnCode(outHeader.getReturnCode());
			}
			
			if(datalen <= 0){
				String msg = BISANG_MSG;
				if(!tool.isNull(this.outdata.getString("message"))){
					msg = this.outdata.getString("message");
				}
				if(!SystemConfig.isAvoidLogTR(definition.getTR())){
					Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0113][" + msg + "]");
				}
				
				throw new ActionException("[ER0113]", msg);
			}
			//data read
			this.output = conn.readData(datalen);
			if(!SystemConfig.isAvoidLogTR(definition.getTR())){
				Log.println(req, "[TR][OUTPUT]["+definition.getTR()+"]["+definition.getService()+"]["+ new String(this.output, "utf-8")+"]");
			}
			this.makeOutput(format);
			this.setSuccess(true);
			return this.outdata;
		}catch(IOException e){
			String msg = TR_DATA_ERR_MSG;
			if(!tool.isNull(this.outdata.getString("message"))){
				msg = this.outdata.getString("message");
			}
			if(conn != null)	conn.reconnect();
			e.printStackTrace();
			throw new ActionException("[ER0116]", msg);
		}catch(Exception e){
			String msg 		= TR_DATA_ERR_MSG;
			String msgCD	= "[ER0116]";
			
			if(!tool.isNull(this.outdata.getString("message"))){
				msg = this.outdata.getString("message");
			}else if(e.getMessage() != null && e.getMessage().startsWith("[ER")){
				msg 	= e.getMessage();
				msgCD 	= "";
			}
			
			if(conn != null)	conn.reconnect();
			e.printStackTrace();
			throw new ActionException(msgCD, msg);
		}finally{
			this.setTrTime(System.currentTimeMillis()-startTime);
			if(conn != null)	conn.close();
		}
	}//end of executeHTSBP();
	
	/**
	 * WebT를 이용한 TR처리
	 * @param definition
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private JSONObject executeWebT(Transaction definition, String webt) throws Exception{
		Log.println(req, "[TR][INFO][executeWebT][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "]");
		WebtConnection connection 	= null;
		WebtBuffer receiveBuffer 	= null;
		long startTime = System.currentTimeMillis();
		
		try{
			Element format = definition.getFormat();
			this.makeInput(definition, format);
			TMaxHeader tmaxInHeader = new TMaxHeader(WEBT, req, definition);
			tmaxInHeader.setMedia(getMediaCode());
			tmaxInHeader.setMacAddr(getMacAddr());
			this.setTmaxInHeader(tmaxInHeader);
			
			connection = getWebTConnection(definition, webt);
			if(connection == null){
				Log.println(req, "[TR][EXCEPTION][ER0113][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][connection is null]");
				throw new ActionException("[ER0113]",TR_DATA_ERR_MSG);
			}
			this.setHostIP(connection.getAddress());
			this.setConnectionTime(System.currentTimeMillis()-startTime);
			WebtRemoteService service = new WebtRemoteService (definition.getService(), connection);
			WebtBuffer sendBuffer = service.createCarrayBuffer(TMaxHeader.HEADER_SIZE+this.input.length);
			sendBuffer.setBytes(tool.append(tmaxInHeader.getHeader(), this.input));
			receiveBuffer = service.tpcall(sendBuffer);
			
			byte[] tmaxheader = receiveBuffer.getBytes(0, TMaxHeader.HEADER_SIZE);
			TMaxHeader tmaxOutHeader = new TMaxHeader(WEBT, req, definition);
			tmaxOutHeader.setHeader(tmaxheader);
			this.setTmaxOutHeader(tmaxOutHeader);
			
			if(!definition.getService().equals(tmaxOutHeader.getService())){
				LogUtil.printIDExceptionLog(this);
				Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0105][WEBT처리시 서비스명이 output값과 동일하지 않음]["+definition.getService()+"]["+tmaxOutHeader.getService()+"]");
				throw new ActionException("[ER0105]", TR_DATA_ERR_MSG);
			}
			/**
			 * Update 2012.10.04, By Min
			 * Out Header 값에서 IP 비교하여 아닌경우에 Exception 발생시킴.
			 */
			if( !getClientIP().equals(tmaxOutHeader.getClientIP())){
				LogUtil.printIDExceptionLog(this);
				Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0106][WEBT처리시 client ip가 output값과 동일하지 않음]["+getClientIP()+"]["+tmaxOutHeader.getClientIP()+"]");
				throw new ActionException("[ER0106]", TR_DATA_ERR_MSG);
			}
			
			this.outdata.put("messageCode", tmaxOutHeader.getMessageCode());
			this.outdata.put("message", tmaxOutHeader.getReturnMessage());
			this.outdata.put("returnCode", tmaxOutHeader.getReturnCode());
			setMssageCode(tmaxOutHeader.getMessageCode());
			setMssage(tmaxOutHeader.getReturnMessage());
			setReturnCode(tmaxOutHeader.getReturnCode());
			
			if(receiveBuffer.getDataLength()-TMaxHeader.HEADER_SIZE <= 0){
				String msg = BISANG_MSG;
				if(!tool.isNull(this.outdata.getString("message"))){
					msg = this.outdata.getString("message");
				}
				Log.println(req, "[TR][EXCEPTION][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][ER0114][" + msg + "]");
				
				throw new ActionException("[ER0114]", msg);
			}
			
			this.output = receiveBuffer.getBytes(TMaxHeader.HEADER_SIZE, receiveBuffer.getDataLength()-TMaxHeader.HEADER_SIZE);
			
			Log.println(req, "[TR][OUTPUT][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "]["+ new String(this.output, "utf-8")+"]");
			
			this.makeOutput(format);
			this.setSuccess(true);
			return this.outdata;
		}catch(Exception e){
			String msg 		= TR_DATA_ERR_MSG;
			String msgCD	= "[ER0119]";
			
			if(!tool.isNull(this.outdata.getString("message"))){
				msg = this.outdata.getString("message");
			}else if(e.getMessage() != null && e.getMessage().startsWith("[ER")){
				msg 	= e.getMessage();
				msgCD	= "";
			}
			e.printStackTrace();
			throw new ActionException(msgCD, msg);
		}finally{
			this.setTrTime(System.currentTimeMillis()-startTime);
			if(connection != null)	connection.close();
		}
	}//end of executeWebT
	
	/**
	 * Input Stream data를 생성한다.
	 */
	private void makeInput(Transaction definition, Element format) throws Exception{
		
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		try{
			List<Element> list = format.getChildren();
			for(int i=0,len=list.size();i<len;i++){
				Element child = list.get(i);
				String fieldNM = child.getAttributeValue("name");
				byte[] val = makeTRInput(req, fieldNM, child);
				
				
				if(val!=null)		outStream.write(val);
			}
			this.input = outStream.toByteArray();
		}finally{
			Log.println(req, "[TR][INPUT][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][" +outStream.toString("utf-8")+"]");
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
		}else if("GridIn".equals(element.getName())){
			GridIn gridin = new GridIn();
			gridin.setVFlg(req.getString("gridFlag"	, "0"		));			//vflg
			gridin.setVRow(req.getString("gridRow"	, "15"		));			//vrow
			gridin.setNRow(req.getString("gridRow"	, "0015"	));			//nrow
			gridin.setGDir(req.getString("gridGdir"	, "1"		));			//gdir
			gridin.setSDir(req.getString("gridSdir"	, "0"		));			//sdir
			gridin.setSCol(req.getString("gridScol"				));			//scol
			gridin.setIKey(req.getString("gridIkey"	, "0"		));			//ikey
			gridin.setPage(req.getString("gridPage"				));			//page
			gridin.setSave(req.getString("gridSave"				));			//save
			gridin.makeHeader();
			return gridin.getHeader();
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
		if("lcombo".equals(parameterName))	super.setLCombo(true);
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
							if(!super.getLCombo()){
								if(this.output[index] == 0){
			                        index = this.output.length; 
									break;
								}
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
		}else if("GridOut".equals(element.getName())){
			GridOut gridout = new GridOut();
			byte[] outh = new byte[GridOut.HEADER_OUT];
			System.arraycopy(this.output, index, outh, 0, outh.length);
			gridout.setHeader(outh);
			data.put("gridFlag", gridout.getFlag());
			data.put("gridSdir", gridout.getSDir());
			data.put("gridScol", gridout.getScol());
			data.put("gridXpos", gridout.getXPos());
			data.put("gridPage", gridout.getPage());
			data.put("gridSave", gridout.getSave());
			return index+GridOut.HEADER_OUT;
		}
		return index;
	}//end of makeOutput();
	

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
	private byte getNextByte(int index){
		if(index+1 < output.length)		return output[index];
		else						return -1;
	}//end of getNextByte();
	
	/**
	 * WebT Connection을 리턴한다
	 * 기본적으로 ip/hostType의 조합으로 연결이 결정된다
	 * (정보계 1 : tmax01, 정보계 2 : tmax02, 업무계 1 : tmax11, 업무계 2 : tmax22)
	 * 정보계/업무계 전 서버가 비상일 경우 예외 발생
	 * 정보계/업무계 각 서버의 비상여부에 따라서 connection 결정(비상인 서버는 회피해서 연결)
	 * 
	 * @param Transaction
	 * @param webt
	 * @return
	 * @throws Exception
	 */
	private WebtConnection getWebTConnection(Transaction definition, String webt) throws Exception{
		if(definition.getHost()=='0'||definition.getHost()=='1'||definition.getHost()=='2'||definition.getHost()=='5'){
			return WebtConnectionPool.getConnection(webt);
		}else{
			Log.println(req, "[TR][EXCEPTION][ER0111][WebT처리시 host가 0 or 1 이 아님][host]["+definition.getHost()+"]");
			throw new ActionException("[ER0111]", TR_DATA_ERR_MSG);
		}
	}//end of getWebTConnection();


}
