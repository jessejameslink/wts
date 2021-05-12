package m.format.header;

import java.io.UnsupportedEncodingException;

import m.action.IConstants;
import m.common.tool.tool;
import m.log.Log;

/**
 * OOP에 대한 grid header를 설정한다
 * @author nhy67
 *
 */
public class ChartHeader  implements IConstants{

	private int 	count			= 300;
	private String	dummy			= "";
	private char 	dataKind		= ' ';
	private char 	dataKey			= ' ';
	private String 	date			= "";
	private byte 	unit			= GU_CODE;
	private byte 	dataIndex		= GI_DAY;
	private int	 	gap				= 0;			// n분, n틱
	private int 	lastTickCount 	= 0;
	private char 	option1			= GUI_MOD;		// 추가옵션#1
	private char 	option2			= GUI_MOD;		// 추가옵션#2
	private String 	codeSymbol		= "";	
	private char 	iKey			= ' ';			// '0':ENTER, '1':PGUP, '2':PGDN, '3':ScrollUp, '4':ScrollDown, '5':First end, '6':Sort
	private char 	xPos			= ' ';			// 다음 구분
	private int 	page			= 0;			// 현재 페이지 번호
	private char 	foreignDigit 	= ' ';			// 외국인 지수를 위한 자리수
	private String 	save = "";
	
	private int 	index			= 0;
	private byte[] 	output;
	
	/**
	 * Count return
	 * @return
	 */
	public int getCount() {
		return count;
	}//end getCount();

	/**
	 * Count set
	 * @param count
	 */
	public void setCount(int count) {
		this.count = count;
	}//end setCount();

	/**
	 * Dummy return
	 * @return
	 */
	public String getDummy() {
		return dummy;
	}//end getDummy();

	/**
	 * DataKind return
	 * @return
	 */
	public char getDataKind() {
		return dataKind;
	}//end getDataKind();
	
	/**
	 * DataKind set
	 * @param dataKind
	 */
	public void setDataKind(char dataKind) {
		this.dataKind = dataKind;
	}//end setDataIndex();

	/**
	 * DataKey return
	 * @return
	 */
	public char getDataKey() {
		return dataKey;
	}//end getDataKey();

	/**
	 * Date return
	 * @return
	 */
	public String getDate() {
		return date;
	}//end getDate();

	/**
	 * Date set
	 * @param count
	 */
	public void setDate(String date) {
		this.date = date;
	}//end setDate();

	/**
	 * Unit return
	 * @return
	 */
	public byte getUnit() {
		return unit;
	}//end getUnit();

	/**
	 * Unit set
	 * @param count
	 */
	public void setUnit(byte unit) {
		this.unit = unit;
	}//end setUnit();

	/**
	 * DataIndex return
	 * @return
	 */
	public byte getDataIndex() {
		return dataIndex;
	}//end getDataIndex();

	/**
	 * DataIndex set
	 * @param count
	 */
	public void setDataIndex(byte dataIndex) {
		this.dataIndex = dataIndex;
	}//end setDataIndex();

	/**
	 * Gap return
	 * @return
	 */
	public int getGap() {
		return gap;
	}//end getGap();

	/**
	 * Gap set
	 * @param count
	 */
	public void setGap(int gap) {
		this.gap = gap;
	}//end setGap();

	/**
	 * LastTickCount return
	 * @return
	 */
	public int getLastTickCount() {
		return lastTickCount;
	}//end getLastTickCount();

	/**
	 * Option1 return
	 * @return
	 */
	public char getOption1() {
		return option1;
	}//end getOption1();

	/**
	 * Option2 return
	 * @return
	 */
	public char getOption2() {
		return option2;
	}//end getOption2();

	/**
	 * CodeSymbol return
	 * @return
	 */
	public String getCodeSymbol() {
		return codeSymbol;
	}//end getCodeSymbol();

	/**
	 * iKey return
	 * @return
	 */
	public char getiKey() {
		return iKey;
	}//end getiKey();

	/**
	 * xPos return
	 * @return
	 */
	public char getxPos() {
		return xPos;
	}//end getxPos();

	/**
	 * Page return
	 * @return
	 */
	public int getPage() {
		return page;
	}//end getPage();

	/**
	 * ForeignDigit return
	 * @return
	 */
	public char getForeignDigit() {
		return foreignDigit;
	}//end getForeignDigit();

	/**
	 * Save return
	 * @return
	 */
	public String getSave() {
		return save;
	}//end getSave();

	/**
	 * input stream에 header를 set
	 * @param value
	 * @throws Exception
	 */
	public void write(StringBuilder value) throws Exception
	{
		reviseIntValue		(value,count, 6);
		reviseStringValue	(value,dummy, 6);
		value.append		(dataKind);
		value.append		(dataKey);
		reviseStringValue	(value,date, 8);
		value.append		((char)unit);
		value.append		((char)dataIndex);
		reviseIntValue		(value,gap, 4);
		reviseIntValue		(value,lastTickCount, 4);
		value.append		(option1);
		value.append		(option2);
		reviseStringValue	(value,codeSymbol, 16);
		value.append		(iKey);
		value.append		(xPos);
		reviseIntValue		(value,page, 4);
		value.append		(foreignDigit);
		reviseStringValue	(value,save, 79);
		
		print("INPUT");
		
	}//end write();
	
	/**
	 * output으로 부터 header정보를 읽어 들인다.
	 * @param output
	 * @param index
	 * @return
	 * @throws Exception
	 */
	public int read(byte[] output, int index) throws Exception
	{
		this.index 	= index;
		this.output = output;
		
		count 			= readInteger(6);				// 일자수
		dummy 			= readString(6);				// 더미
		dataKind 		= (char) readByte();			// 패턴종류
		dataKey 		= (char) readByte();			// 데이터키
		date 			= readString(8);				// 기준일자
		unit 			= (byte)readByte();				// 종목,업종,선물 등등
		dataIndex 		= (byte) readByte();			// 일,주,월
		gap 			= readInteger(4);				// n분,n틱
		lastTickCount 	= readInteger(4);				// 마지막 Tick Count
		option1 		= (char) readByte();			// 추가옵션 #1
		option2 		= (char) readByte();			// 추가옵션 #2
		codeSymbol 		= readString(16);				// 심볼
		iKey 			= (char)readByte();				// Key Action
		xPos 			= (char)readByte();				// 다음구분
		page 			= readInteger(4);				// 현재페이지
		foreignDigit 	= (char)readByte();				// 외국인지수를 위한 자리수
		save 			= readString(79);				// Grid In out save field
		
		print("OUTPUT");
		
		return this.index;
	}//end read();
	
	/**
	 * value의 선두에 size만큼의 0을 보정한 값을 return
	 * @param value
	 * @param size
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public void reviseIntValue(StringBuilder builder, int value, int size) throws Exception
	{
		String valueString = Integer.toString(value);
		byte[] bytes = valueString.getBytes("utf-8");
		int valueLength = bytes.length;
		if(valueLength <= size)
		{
			for(int i=0; i < size-valueLength; i++)
				builder.append('0');
			for(int i=0; i < valueLength; i++)
				builder.append(valueString.charAt(i));
		}
	}//end reviseIntValue();
	
	/**
	 * value의 끝에 size만큼의 ' '을 보정한 값을 return
	 * @param value
	 * @param size
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public void reviseStringValue(StringBuilder builder, String value, int size) throws Exception
	{
		byte[] bytes = value.getBytes("utf-8");
		
		if(value == null || bytes.length == 0)
		{
			for(int i=0; i<size; i++)
				builder.append(' ');
		}
		else
		{
			builder.append(value);
			int valueLength = bytes.length;
			for(int i=0; i<size-valueLength; i++)
			{
				builder.append(' ');
			}
		}
	}//end reviseStringValue();
	
	/**
	 * output에서 바이트단위로 읽어 들인다.
	 * @return
	 * @throws Exception
	 */
	public byte readByte() throws Exception{
		return this.output[this.index++];
	}//end of readByte();
	
	/**
	 * output에서 size만큼의 String값을 읽어 들인다.
	 * @param size
	 * @return
	 * @throws Exception
	 */
	public String readString(int size) throws Exception{
		byte[] result = new byte[size];
		System.arraycopy(this.output, this.index, result, 0, size);
		
		this.index += size;
		return new String(new String(result, "utf-8"));
	}//end of readString();

	/**
	 * output에서 size만큰의 int값을 읽어 들인다.
	 * @param size
	 * @return
	 * @throws Exception
	 */
	public int readInteger(int size) throws Exception{
		byte[] result = new byte[size];
		System.arraycopy(this.output, this.index, result, 0, size);
		this.index += size;
		String dest = new String(result, "utf-8");
		
		if(tool.isNull(dest)){
			return 0;
		}
		try{
			return Integer.parseInt(dest.trim());
		}catch(Exception e){
			return 0;
		}
	}//end of readString();
	
	/**
	 * ChartHeader log 출력
	 */
	private void print(String type) throws Exception{
		Log.println("[Chart][HEADER]["+type+"] count: " 		+ this.getCount());
		Log.println("[Chart][HEADER]["+type+"] dummy: " 		+ this.getDummy());
		Log.println("[Chart][HEADER]["+type+"] dataKind: " 		+ this.getDataKind());
		Log.println("[Chart][HEADER]["+type+"] dataKey: " 		+ this.getDataKey());
		Log.println("[Chart][HEADER]["+type+"] date: " 			+ this.getDate());
		Log.println("[Chart][HEADER]["+type+"] unit: " 			+ this.getUnit());
		Log.println("[Chart][HEADER]["+type+"] dataIndex: " 	+ this.getDataIndex());
		Log.println("[Chart][HEADER]["+type+"] gap: " 			+ this.getGap());
		Log.println("[Chart][HEADER]["+type+"] lastTickCount: " + this.getLastTickCount());
		Log.println("[Chart][HEADER]["+type+"] option1: " 		+ this.getOption1());
		Log.println("[Chart][HEADER]["+type+"] option2: " 		+ this.getOption2());
		Log.println("[Chart][HEADER]["+type+"] iKey: " 			+ this.getiKey());
		Log.println("[Chart][HEADER]["+type+"] xPos: " 			+ this.getxPos());
		Log.println("[Chart][HEADER]["+type+"] foreignDigit: " 	+ this.getForeignDigit());
		Log.println("[Chart][HEADER]["+type+"] save: " 			+ this.getSave());
	}
}
