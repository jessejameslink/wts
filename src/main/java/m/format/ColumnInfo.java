package m.format;

import java.util.ArrayList;
import java.util.List;
import m.action.IConstants;
import m.common.tool.tool;
import org.jdom2.Element;

/**
 * DB Column에 관한 Metadata 정보를 delivery하기 위해 정의된 class이다.
 * @author poemlife
 */
public class ColumnInfo implements IConstants{
	
	private String columnName;		//Column Name
	private int type;				//Column Type. String, Number, int, float, date, time, etc.
	private char inout;				//Input/Output type 여부.
	private String subQuery;		//Clob data인 경우, update를 위해 필요한 subquery
	private ArrayList<ColumnInfo> in_param;	//subquery에 사용할 input parameter

	/**
	 * ColumnInfo Object를 생성한다.
	 * @param element
	 * @throws Exception
	 */
	public ColumnInfo(Element element) throws Exception{
		if(element==null)		throw new Exception("ClientInfo : element is null!");
		if("param".equals(element.getName())){
			this.setName(element.getAttributeValue("name"));		//Column Name
			this.setType(element.getAttributeValue("type"));		//Data Type
			this.setInOut(element.getAttributeValue("io"));			//Input/Output field 여부
			if(this.isClob()){
				this.setSubQuery(element.getChildTextTrim("subquery"));
				List<Element> param = element.getChildren("param");
				this.in_param = new ArrayList<ColumnInfo>();
				for(int i=0,size=param.size();i<size;i++){
					this.in_param.add(new ColumnInfo(param.get(i)));
				}
			}
		}
	}//end of ColumnInfo();
	
	/**
	 * Column Name을 Setting한다.
	 * @param name
	 */
	private void setName(String name){
		this.columnName = name;
	}//end of setName();
	
	/**
	 * Column Name을 return한다.
	 * @return
	 */
	public String getName(){
		return this.columnName;
	}//end of getName();
	
	/**
	 * Column의 data type을 Setting한다
	 * @param type
	 */
	public void setType(String type){
		if(tool.isNull(type))		this.type = STRING;
		type = type.trim().toUpperCase();
		if("INT".equals(type)){
			this.type = INT;
		}else if("FLOAT".equals(type)){
			this.type = FLOAT;
		}else if("DATE".equals(type)){
			this.type = DATE;
		}else if("CLOB".equals(type)){
			this.type = CLOB;
		}else{
			this.type = STRING;
		}
	}//end of setType();
	
	/**
	 * Column의 data type을 return한다.
	 * @return STRING, NUMBER, INT, FLOAT, DATE, CLOB.... 
	 */
	public int getType(){
		return this.type;
	}//end of getType();

	/**
	 * Input/Output 여부를 Setting한다.
	 * @param io
	 */
	private void setInOut(String io){
		if(tool.isNull(io))		return;
		io = io.trim().toUpperCase();
		if("IN".equals(io))			this.inout = 'I';
		else if("OUT".equals(io))	this.inout = 'O';
	}//end of setIO();
	
	/**
	 * Input Field인지 여부를 return한다.
	 * @return input field면 true, 아니면 false를 return한다.
	 */
	public boolean isInputField(){
		return this.inout=='I';
	}//end of isInputField();
	
	/**
	 * Output Field인지 여부를 return한다.
	 * @return Output Field면 true, 아니면 false를 return한다.
	 */
	public boolean isOutputField(){
		return this.inout=='O';
	}//end of isOutField();
	
	/**
	 * 이 필드가 CLOB 필드인지 여부를 return한다.
	 * @return CLOB 필드면 true, 아니면 false를 return한다.
	 */
	public boolean isClob(){
		return this.getType()==CLOB;
	}//end of isClob();
	
	/**
	 * CLOB type data인 경우, update를 위해 필요한 subquery를 Setting한다.
	 * @param query
	 */
	public void setSubQuery(String query){
		this.subQuery = query;
	}//end of setSubQuery();
	
	/**
	 * CLOB type data인 경우, update를 위해 필요한 subquery를 return한다.
	 * @return
	 */
	public String getSubQuery(){
		return this.subQuery;
	}//end of getSubQuery();
	
	/**
	 * CLOB type data인 경우 사용할 subquery에 들어가는 parameter를 add시킨다.
	 * @param param
	 */
	public void addParam(ColumnInfo param){
		if(this.in_param==null)		this.in_param = new ArrayList<ColumnInfo>();
		this.in_param.add(param);
	}//end of addParam();
	
	/**
	 * CLOB type data인 경우 사용할 subquery에 들어가는 Parameter를 Setting한다.
	 * @param index index. 
	 * @param param parameter info
	 */
	public void setParam(int index, ColumnInfo param){
		if(index<0)							return;
		if(this.in_param==null)		this.in_param = new ArrayList<ColumnInfo>();
		if(index>=this.in_param.size())		return;
		this.in_param.set(index, param);
	}//end of addParam();
	
	/**
	 * CLOB type data인 경우 사용할 subquery에 들어가는 parameter name을 Array type으로 return한다.
	 * @return
	 */
	public String[] getParams(){
		if(this.in_param==null)		return null;
		int size = this.getParamCount();
		String[] infos = new String[size];
		for(int i=0;i<size;i++){
			ColumnInfo info = this.in_param.get(i);
			infos[i] = info.getName();
		}
		return infos;
	}//end of getParams();
	
	/**
	 * Clob type data인 경우 사용할 subquery에 들어가는 parameter의 count를 return한다.
	 * @return
	 */
	public int getParamCount(){
		if(this.in_param==null)		return 0;
		else						return this.in_param.size();
	}//end of getParamCount();
	
	/**
	 * Clob type data인 경우 사용할 subquery에 들어가는 parameter의 정보를 return한다.
	 * @param index
	 * @return 잘못된 index나 parameter 정보가 없을 경우, null을 return한다.
	 */
	public ColumnInfo getParam(int index){
		if(this.in_param==null)			return null;
		if(index<0)						return null;
		if(index>=this.in_param.size())	return null;
		return this.in_param.get(index);
	}//end of getParam();
}//end of ColumnInfo
