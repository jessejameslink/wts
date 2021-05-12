package m.action.executer;

import java.io.IOException;
import java.util.List;

import org.jdom2.Element;

import m.action.ActionException;
import m.common.tool.tool;
import m.config.DataConfig;
import m.format.DefinitionFactory;
import m.format.Transaction;
import m.format.header.ChartHeader;
import m.format.header.InHeader;
import m.format.header.OutHeader;
import m.json.JSONArray;
import m.json.JSONObject;
import m.log.Log;
import m.log.LogUtil;
import m.pool.socket.Connection;
import m.pool.socket.Pool;
import m.web.common.WebInterface;

public class Chart extends TransactionExecuter {

	//------------------------------------- 필수적으로 필요한 항목들. ----------------------------------------------
	private ChartHeader 		gridHeader;		//Grid Header

	/**
	 * @param req
	 */
	public Chart(WebInterface req, String trName) throws Exception{
		super(req, trName);
		this.setChartHeader();
	}//end of TRExecuter();

	/**
	 * Chart header를 생성한다.
	 * @throws Exception
	 */
	public void setChartHeader() throws Exception{
		this.gridHeader = new ChartHeader();
		this.gridHeader.setCount(req.getInt("count"));
		this.gridHeader.setDataIndex(req.getByte("dataIndex"));
		if(!tool.isNull(req.getString("dataKind"))){	
			this.gridHeader.setDataKind((char)req.getByte("dataKind"));		
		}
		if(!tool.isNull(req.getString("date"))){	
			this.gridHeader.setDate(req.getString("date"));		
		}
		if(!tool.isNull(req.getString("unit"))){
			this.gridHeader.setUnit(req.getByte("unit"));
		}
		if(!tool.isNull(req.getString("gap"))){
			this.gridHeader.setGap(req.getInt("gap"));
		}
	}//end of checkHeader();
	
	/**
	 * Chart처리
	 * HTSBP를 통한 통신(HTSBP가 비상일경우 예외처리) 
	 * @return
	 * @throws Exception
	 */
	public JSONObject send() throws Exception{
		Transaction definition;
		try{
			definition = (Transaction)DefinitionFactory.getFormat(this.getTR());
			if(definition==null){
				Log.println(req, "[Chart][EXCEPTION][ER0700][TR에 대한 definition이 존재하지 않음]");
				throw new ActionException("[ER0700]", TR_DATA_ERR_MSG);
			}
			Log.println(req, "[Chart][" + definition.getHost() + "][" + definition.getTR() + "][" + definition.getService() + "][START]");
			this.setHost(definition.getHost());
			this.outdata = new JSONObject();
			String path = DataConfig.getPathWithcheckBpState();
			if("DISABLED".equals(path)){
				Log.println(req, "[Chart][EXCEPTION][ER0701][모든 연결이 비상]");
				throw new ActionException("[ER0701]",BISANG_MSG);
			}else{
				return executeChart(definition);
			}
		}catch(Exception e){
			this.setSuccess(false);
			throw e;
		}finally{
			LogUtil.printChartLog(this);
		}
	}//end of execute();
	
	
	/**
	 * Chart를 이용한 TR처리
	 * @param definition
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private JSONObject executeChart(Transaction definition) throws Exception{
		Connection conn = null;
		try{
			Element format = definition.getFormat();
			this.makeInput(format);
			InHeader inheader = new InHeader(req, definition);
System.out.println("LENGTH==>" + this.input.length);
			inheader.setLength(this.input.length);
			long startTime = System.currentTimeMillis();
			OutHeader outHeader = null;
			try{
				Pool pool = Pool.getInstance();
				conn = pool.getConnection();
				
				Log.println(req, "[TR][CONNECT] ["+ definition.getTR() +"]" + "[" + conn.getId() + "]");
				
				Log.println(req, "[TR][CHK VAL] ["+ conn.getHost() +"]" + "[" + conn.getPort() + "]");
				
				
				System.out.println(conn.getId());
				this.setHostIP(conn.getHost());
				this.setConnectionTime(System.currentTimeMillis()-startTime);
				this.setInHeader(inheader);
				conn.writeHeader(inheader);
				conn.writeData(this.input);
				byte[] outh = conn.readCommonHeader();
				outHeader = new OutHeader(outh);
				this.setOutHeader(outHeader);
				int datalen = outHeader.getLength();
				if(datalen == 0){
					Log.println(req, "[Chart][EXCEPTION][ER0702][업무폭주, 잠시후 이용하시오]");
					throw new ActionException("[ER0702]", BISANG_MSG);
				}
				this.output = conn.readData(datalen);
				Log.println(req, "[Chart][OUTPUT] ["+ new String(this.output, "utf-8")+"]");
			}catch(Exception e){
				e.getStackTrace();
				System.out.println(e.getMessage());
				this.setSuccess(false);
				throw e;
			}finally{
				this.setTrTime(System.currentTimeMillis()-startTime);
			}
			this.outdata.put("messageCode", "");
			this.outdata.put("message", outHeader.getReturnMessage());
			this.outdata.put("returnCode", outHeader.getReturnCode());
			this.setMssageCode("");
			this.setMssage(outHeader.getReturnMessage());
			this.setReturnCode(outHeader.getReturnCode());
			
			this.makeOutput(format, definition.getTR());
			this.setSuccess(true);
			return this.outdata;
		}catch(Exception e){
			System.out.println("#############CHECK OUT PRINT##############");
			System.out.println(e.getMessage());
			e.printStackTrace();
			System.out.println(e);
			System.out.println("##########################################");
			if(conn != null)	conn.reconnect();
			throw new ActionException("[ER0704]", TR_DATA_ERR_MSG);
		}finally{
			if(conn != null)	conn.close();
		}		
	}//end of executeHTSBP();
	
	/**
	 * input Stream 데이타를 생성한다.
	 * @param format
	 * @throws Exception
	 */
	private void makeInput(Element format) throws Exception{
		try{
			StringBuilder value = new StringBuilder();
			List<Element> list = format.getChildren();
			for(int i=0,len=list.size();i<len;i++){
				Element child = list.get(i);
				String val = makeTRInput(req, child.getAttributeValue("name"), child);
				if(val!=null)		value.append(val);
			}
			this.input = value.toString().getBytes("utf-8");
		}finally{
			Log.println(req, "[Chart][INPUT] [" +new String(this.input, "utf-8")+"]");
		}
	}//end of makeInput();
	
	/**
	 * definition에 정의된 데이터를 set
	 * @param req
	 * @param parameterName
	 * @param element
	 * @return
	 * @throws Exception
	 */
	private String makeTRInput(WebInterface req, String parameterName, Element element) throws Exception{
		StringBuilder value = new StringBuilder();
		if("value".equals(element.getName())){
			if("in".equals(element.getAttributeValue("io"))||"inout".equals(element.getAttributeValue("io"))){
				value.append(parameterName);
				value.append((char)DEL);
				value.append(req.getString(parameterName));
				value.append((char)VN13);
				if("inout".equals(element.getAttributeValue("io"))){
					value.append(parameterName);
					value.append((char)VN13);
				}
System.out.println("CHART1=>" + value.toString());
				return value.toString();
			}else if("out".equals(element.getAttributeValue("io"))){
				value.append(parameterName);
				value.append((char)VN13);
System.out.println("CHART2=>" + value.toString());
				return value.toString();
			}
		}else if("table".equals(element.getName())){
			value.append("?");
			value.append(parameterName);
			value.append((char)DEL);
			
			this.gridHeader.write(value);
			List<Element> list = element.getChildren();
			for(int i=0; i < list.size(); i++)
			{
				Element childDefinition = list.get(i);
				String symbol = childDefinition.getAttributeValue("name");
				value.append(symbol);
				value.append((char)LF);
				Thread.sleep(0);
			}
			value.append((char)VN13);	
System.out.println("CHART3=>" + value.toString());
			return value.toString();
		}
		return null;
	}//end of makeInput();
	
	/**
	 * output stream을 생성한다.
	 * @param format
	 * @return
	 * @throws Exception
	 */
	private void makeOutput(Element format, String trCd)throws Exception{
		List<Element> list = format.getChildren();
		int index = 0;
		if("pibghoop".equals(trCd))	index += 16;
		
		for(int i=0,len=list.size();i<len;i++){
			Element child = list.get(i);
			index = makeTROutput(child, index, child.getAttributeValue("name"), this.outdata);
		}
	}//end of makeOutput();

	/**
	 * output으로부터 definition에 정의된 데이터를 set
	 * @param element
	 * @param index
	 * @param parameterName
	 * @param data
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private int makeTROutput(Element element, int index, String parameterName, JSONObject data) throws Exception{
		if("value".equals(element.getName())){
			if("out".equals(element.getAttributeValue("io"))||"inout".equals(element.getAttributeValue("io"))){
				int startIndex = index;
				while(index < this.output.length){
					byte byteValue = this.output[index];
					index++;
					if(byteValue == DEL || byteValue == TAB || byteValue == LF || byteValue == CR || byteValue == VN13){
						break;
					}
				}
				int size = index-startIndex;
				if(size > 0){
					byte[] result = tool.makeFullSpaceBtyeArray(size);
					System.arraycopy(this.output, startIndex, result, 0, size);
					data.mput(parameterName, result);
				}else{
					data.put(parameterName, new String());
				}
				
				return index;
			}
		}else if("table".equals(element.getName())){
			java.util.List<Element> list = element.getChildren();
			if(list!=null){
				index = gridHeader.read(this.output, index);
				JSONArray rsArr = new JSONArray();
				data.put("a"+parameterName, rsArr);
				
				while(true){
					int nextByte = getNextByte(index);	// XNL
					if(nextByte == -1)						break;
					
					if(nextByte == CR){
						readByte(index);
						break;
					}
					
					JSONObject gridData = new JSONObject();
					rsArr.add(gridData);
					for(int j=0,len=list.size();j<len;j++){
						Element child = list.get(j);
						index = this.makeTROutput(child, index, child.getAttributeValue("name"), gridData);
					}
					Thread.sleep(0);
				}
				return index;
			}
		}
		return index;
	}//end of makeOutput();
	
	/**
	 * 다음에 읽혀질 byte을 return
	 * @param index
	 * @return
	 */
	public byte getNextByte(int index){
		if(index < output.length)	return output[index];
		else						return -1;
	}//end of getNextByte();
	
	/**
	 * output에서 바이트 단위로 읽어 들인다.
	 * @param index
	 * @return
	 * @throws IOException
	 */
	public byte readByte(int index) throws IOException{
		return output[index++];
	}//end of readByte();
	
	/**
	 * value의 끝에 size만큼의 ' '을 보정한 값을 return
	 * @param value
	 * @param size
	 * @return StringBuilder
	 * @throws Exception
	 */
	public String reviseStringValue(String value, int size) throws Exception{
		StringBuilder builder = new StringBuilder();
		byte[] bytes = value.getBytes("utf-8");
		
		if(value == null || bytes.length == 0){
			for(int i=0; i<size; i++)
				builder.append((char)SPACE);
		}else{
			builder.append(value);
			int valueLength = bytes.length;
			for(int i=0; i<size-valueLength; i++){
				builder.append((char)SPACE);
			}
		}
		return builder.toString();
	}//end of reviseStringValue();

}
