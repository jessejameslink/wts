package m.json;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import m.common.tool.*;

public class JSONObject extends org.json.simple.JSONObject{
	
	private Map<String, byte[]> byteMap = new HashMap<String, byte[]>();
	
	@SuppressWarnings("unchecked")
	public void mput(String key, byte[] value){
		byteMap.put(key, value);
		try {
			this.put(key, new String(value, "utf-8").trim());
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * String형의 Data return
	 * null일 경우 defaultValue return
	 * @param key
	 * @return
	 */
	public String getString(String key, String defaultValue){
		if(tool.isNull(key))		return defaultValue;
		Object obj = this.get(key);
		if(obj==null)	return defaultValue;
		else	return (String)obj;
	}
	
	/**
	 * String형의 Data return
	 * null일 경우 new String() return
	 * @param key
	 * @return
	 */
	public String getString(String key){
		return this.getString(key, new String());
	}
	
	/**
	 * int형의 data return
	 * null일 경우 defaultValue return
	 * @param key
	 * @return
	 */
	public int getInt(String key, int defaultValue){
		try{
			return Integer.parseInt(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return 0;
		}
	}//end of getInt();
	
	/**
	 * int형의 data return
	 * null일 경우 0 return 
	 * @param key
	 * @return
	 */
	public int getInt(String key){
		return this.getInt(key, 0);
	}
	
	/**
	 * key에 해당하는 value를 찾아서 byte[] type으로 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public byte[] getBytes(String key){
		byte[] value = this.byteMap.get(key);
		if(value==null)		return null;
		else				return value;
	}//end of getBytes();
	
	/**
	 * key에 해당하는 value를 찾아서 byte type으로 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public byte getByte(String key, byte defaultValue){
		try{
			return Byte.parseByte(this.getString(key, String.valueOf(defaultValue)));
		}catch(Exception e){
			e.printStackTrace();
			return defaultValue;
		}
	}//end of getInt();
	
	/**
	 * key에 해당하는 value를 찾아서 byte type으로 return한다.
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	public byte getByte(String key){
		return this.getByte(key, (byte)0);
	}//end of getInt();
}
