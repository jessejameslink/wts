package m.format.header;

import java.io.UnsupportedEncodingException;

import m.action.IConstants;
import m.common.tool.tool;
import m.json.JSONObject;
import m.log.Log;

/**
 * OOP에 대한 grid header를 설정한다
 * @author nhy67
 *
 */
public class OOPGridHeader  implements IConstants{
	private final String 	EMPTYSTR	= "";
	
	private	int 	vRow 		= 10;
	private	int 	nRow	 	= 10;
	private	byte 	flag 		= SPACE;
	private	byte 	gDir		= SPACE;
	private	byte	sDir		= SPACE;
	private	String	sCol		= EMPTYSTR;
	private	byte	iKey		= '1';
	private	int		page		= 1;
	private	byte	xPos		= SPACE;
	private	String  save		= EMPTYSTR;
	
	private int 	index		= 0;
	private byte[] 	output;
	
	/**
	 * vRow return
	 * @return
	 */
	public int getvRow() {
		return vRow;
	}//end getvRow();
	
	/**
	 * vRow set
	 * @param count
	 */
	public void setvRow(int vRow) {
		this.vRow = vRow;
	}//end setvRow();
	
	/**
	 * nRow return
	 * @return
	 */
	public int getnRow() {
		return nRow;
	}//end getnRow();
	
	/**
	 * nRow set
	 * @param count
	 */
	public void setnRow(int nRow) {
		this.nRow = nRow;
	}//end setnRow();
	
	/**
	 * flag return
	 * @return
	 */
	public byte getFlag() {
		return flag;
	}//end getFlag();
	
	/**
	 * flag set
	 * @param count
	 */
	public void setFlag(byte flag) {
		this.flag = flag;
	}//end setFlag();
	
	/**
	 * gDir return
	 * @return
	 */
	public byte getgDir() {
		return gDir;
	}//end getgDir();
	
	/**
	 * gDir set
	 * @param count
	 */
	public void setgDir(byte gDir) {
		this.gDir = gDir;
	}//end setgDir();
	
	/**
	 * sDir return
	 * @return
	 */
	public byte getsDir() {
		return sDir;
	}//end getsDir();
	
	/**
	 * sDir set
	 * @param count
	 */
	public void setsDir(byte sDir) {
		this.sDir = sDir;
	}//end setsDir();
	
	/**
	 * sCol return
	 * @return
	 */
	public String getsCol() {
		return sCol;
	}//end getsCol();
	
	/**
	 * sCol set
	 * @param count
	 */
	public void setsCol(String sCol) {
		this.sCol = sCol;
	}//end setsCol();
	
	/**
	 * iKey return
	 * @return
	 */
	public byte getiKey() {
		return iKey;
	}//end getiKey();
	
	/**
	 * iKey set
	 * @param count
	 */
	public void setiKey(byte iKey) {
		this.iKey = iKey;
	}//end setiKey();
	
	/**
	 * page return
	 * @return
	 */
	public int getPage() {
		return page;
	}//end getPage();
	
	/**
	 * page set
	 * @param count
	 */
	public void setPage(int page) {
		this.page = page;
	}//end setPage();
	
	/**
	 * xPos return
	 * @return
	 */
	public byte getxPos() {
		return xPos;
	}//end getxPos();
	
	/**
	 * xPos set
	 * @param count
	 */
	public void setxPos(byte xPos) {
		this.xPos = xPos;
	}//end setxPos();
	
	/**
	 * save return
	 * @return
	 */
	public String getSave() {
		return save;
	}//end getSave();
	
	/**
	 * save set
	 * @param count
	 */
	public void setSave(String save) {
		this.save = save;
	}//end setSave();
	
	/**
	 * input stream에 header를 set
	 * @param value
	 * @throws Exception
	 */
	public void write(StringBuilder value) throws Exception
	{
		reviseIntValue		(value,vRow, 2);
		reviseIntValue		(value,nRow, 4);
		value.append		((char)flag);
		value.append		((char)gDir);
		value.append		((char)sDir);
		reviseStringValue	(value, sCol, 16);
		value.append		((char)this.iKey);
		reviseIntValue		(value,page, 4);
		reviseStringValue	(value, save, 80);
		
		print("INPUT");
	}
	
	/**
	 * output으로 부터 header정보를 읽어 들인다.
	 * @param output
	 * @param index
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int read(byte[] output, int index, JSONObject data) throws Exception
	{
		this.index 	= index;
		this.output = output;
		
		flag 		= readByte();
		sDir 		= readByte();
		sCol 		= readString(16);
		xPos 		= readByte();
		page 		= readInteger(4);
		save 		= readString(80);
		
		data.put("flag", String.valueOf(flag));
		data.put("sdir", String.valueOf(sDir));
		data.put("scol", String.valueOf(sCol));
		data.put("xpos", String.valueOf(xPos));
		data.put("page", String.valueOf(page));
		data.put("save", String.valueOf(save));
		
		print("OUTPUT");
		
		return this.index;
	}
	
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
			for(int i=0; i < size-valueLength; i++){
				builder.append('0');
			}
			for(int i=0; i < valueLength; i++){
				builder.append(valueString.charAt(i));
			}
		}
	}	
	
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
			for(int i=0; i<size; i++){
				builder.append(' ');
			}
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
	}
	
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
	 * OOPGridHeader log 출력
	 */
	private void print(String type) throws Exception{
		Log.println("[OOP][HEADER]["+type+"] vRow: " + this.getvRow());
		Log.println("[OOP][HEADER]["+type+"] nRow: " + this.getnRow());
		Log.println("[OOP][HEADER]["+type+"] flag: " + this.getFlag());
		Log.println("[OOP][HEADER]["+type+"] gDir: " + this.getgDir());
		Log.println("[OOP][HEADER]["+type+"] sDir: " + this.getsDir());
		Log.println("[OOP][HEADER]["+type+"] sCol: " + this.getsCol());
		Log.println("[OOP][HEADER]["+type+"] iKey: " + this.getiKey());
		Log.println("[OOP][HEADER]["+type+"] page: " + this.getPage());
		Log.println("[OOP][HEADER]["+type+"] save: " + this.getSave());
	}
}
