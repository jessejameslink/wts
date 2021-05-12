package m.pool.transclient;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import m.action.ActionException;
import m.action.IConstants;
import m.json.JSONObject;
import m.json.JSONValue;

/**
 * Http protocol로 서버와 통신을 하기 위한 Connection
 * @author poemlife
 */
public class Connection implements IConstants{
	private int id;					//Connection ID
	private String url;				//접속할 서버의 URL. 설정 파일을 읽어서 가져온다.
	
	private HttpURLConnection conn;		//URLConnection Object
	
	private BufferedInputStream is;
	private BufferedOutputStream os;

	private long stime;
	private long ctime;
	
	protected Connection(String url) throws Exception{
		this.url = url;
		this.stime = System.currentTimeMillis();
		this.connect();
		this.ctime = System.currentTimeMillis();
	}//end of Connection();
	
	/**
	 * Connection ID를 Setting한다.
	 * 이 Setting은 동일 package 내의 Manager에서만 처리 가능하다.
	 * @param id
	 */
	protected void setId(int id){
		this.id = id;
	}//end of setId();
	
	/**
	 * Connection ID를 return한다.
	 * @return
	 */
	public int getId(){
		return this.id;
	}//end of getId();
	
	/**
	 * URL을 Setting한다.
	 * @param host
	 */
	protected void setHost(String host){
		this.url = host;
	}//end of setHost();
	
	/**
	 * 접속할 서버의 URL 정보를 가져온다.
	 * @param host
	 */
	public String getHost(){
		return this.url;
	}//end of setHost();

	/**
	 * 서버로 호출을 할 Connection을 생성한다. 
	 * @throws ActionException 
	 */
	public void connect() throws Exception{
		URL main = null;
		main = new URL(this.url);
		this.conn = (HttpURLConnection)main.openConnection();
		conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;"); 
		conn.setRequestProperty("Accept-Charset", "UTF-8");
		conn.setRequestMethod("POST");
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setUseCaches(false);
		conn.setDefaultUseCaches(false);
		
		//System.out.println("conn : " +  this.url);
	}//end of connect();
	
	/**
	 * InputStream에서 data를 읽어온다.
	 * @param value
	 * @return
	 * @throws Exception
	 */
	public int read(byte[] value) throws Exception{
		try{
			if(this.is==null)		return 0;
			else					return this.is.read(value);
		}catch(Exception e){
			throw e;
		}
	}//end of read();
	
	/**
	 * OutputStream으로 data를 write한다.
	 * @param data
	 * @throws Exception
	 */
	public void write(byte[] data, int offset, int len) throws Exception{
		try{
			if(this.os==null)		return;
			else					this.os.write(data, offset, len);
		}catch(Exception e){
			throw e;
		}
	}//end of write();
	
	/**
	 * OutputStream으로 data를 write한다.
	 * @param data
	 * @throws Exception
	 */
	public void write(byte[] data) throws Exception{
		try{
			if(this.os==null)		return;
			else					this.os.write(data);
		}catch(Exception e){
			throw e;
		}
	}//end of write();
	
	/**
	 * Socket을 close시킨다.
	 */
	public void close(){
		try{
			if(this.is!=null)		this.is.close();
			if(this.os!=null)		this.os.close();
			Manager.remove(this);
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of close();
	
	/**
	 * TR 처리에 소요된 시간을 return한다.
	 * @return
	 */
	public long getExecuteTime(){
		return System.currentTimeMillis() - this.ctime;
	}//end of getExecuteTime();

	/**
	 * Connection 연결에 걸린 시간을 return한다.
	 * @return
	 */
	public long getConnectTime(){
		return this.ctime - this.stime;
	}//end of getExecuteTime();
	
	/**
	 * Body write
	 * @param data
	 * @throws Exception
	 */
	public void writeData(byte[] data) throws Exception{
		if(this.os==null)		this.os = new BufferedOutputStream(this.conn.getOutputStream());
		this.os.write(data);
		this.os.flush();
	}//end of write();
	
	/**
	 * Body read
	 * @param dataSize
	 * @return
	 * @throws Exception
	 */
	public byte[] readData() throws Exception{
		
		if(this.is==null)		this.is = new BufferedInputStream(this.conn.getInputStream());
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		
		byte[] bs = new byte[1024];
		
		int len = 0;
		while((len = is.read(bs)) > -1){
			byte[] rs = new byte[len];
			
			System.arraycopy(bs, 0, rs, 0, len);
			bos.write(rs);
		}
		return bos.toByteArray();
	}//end of readData();
	
	/**
	 * Body read
	 * @param dataSize
	 * @return
	 * @throws Exception
	 */
	public JSONObject readJSONData() throws Exception{
		return (JSONObject)JSONValue.parseWithException(new String(this.readData()));
	}//end of readData();
}//end of Connection