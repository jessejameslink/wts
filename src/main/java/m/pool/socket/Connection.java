package m.pool.socket;

import java.net.Socket;
import java.net.UnknownHostException;
import java.io.*;
import m.common.tool.tool;
import m.format.header.InHeader;
import m.format.header.OutHeader;
import m.format.header.TMaxHeader;

/**
 * BP서버와의 socket통신을 위한 개별 connection
 * PoolManager에 의해 관리된다
 * @author 김대원
 *
 */
public class Connection extends Socket{
	/**
	 * Connection id
	 */
	private int id;
	private BufferedInputStream 	is;
	private BufferedOutputStream 	os;
	private String host;
	private int port;
	private boolean isUse = false;
	private long useCount;
	private long useTime;
	private long makeSocketTime;					//Socket이 생성된 시점.
	private long makeConnectionTime;				//Connection이 생성된 시점.
	
	/**
	 * Socket을 생성한다.
	 * @param host
	 * @param port
	 * @throws UnknownHostException
	 * @throws IOException
	 */
	public Connection(int index, String host, int port) throws UnknownHostException, IOException{
		super(host, port);
		this.host 	= host;
		this.port 	= port;
		this.id 	= index;
		this.is 	= new BufferedInputStream(super.getInputStream());
		this.os 	= new BufferedOutputStream(super.getOutputStream());
		this.makeSocketTime = System.currentTimeMillis();
		this.makeConnectionTime = System.currentTimeMillis();
	}//end of Connection();
	
	public long getMakeTime(){
		return this.makeConnectionTime;
	}//end of getMakeTime();
	
	/**
	 * Connection의 index를 return한다.
	 * @return
	 */
	public int getId(){
		return this.id;
	}//end of getId();
	
	/**
	 * Connection을 Pool로 반환한다.
	 */
	public void close(){
		synchronized ( this ){
			try {
				if(this.is != null && this.is.available() > 0){
					this.reconnect();
				}
			} catch (IOException e) {
				this.reconnect();
			}
			
			this.setUse(false);
			notifyAll();	
		}
	}//end of close();
	
	public void reconnect(){
		Pool.reconnect(this);
	}//end of reconnect();
	
	/**
	 * Connection을 close시킨다.
	 */
	protected void closeConnection(){
		try{
			if(super.isConnected())		super.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of closeConnection();
	
	/**
	 * Connection의 사용 여부를 Setting한다.
	 * @param use true면 사용중, false면 사용 완료(대기중).
	 */
	public void setUse(boolean use){
		this.isUse = use;
		if(this.isUse){
			this.useTime = System.currentTimeMillis();
		}else{
			this.useTime = 0;
		}
		this.useCount++;
	}//end of setUse();
	
	/**
	 * Connection의 사용 여부를 return한다.
	 * @return true면 사용중, false면 사용 완료(대기중).
	 */
	public boolean getUse(){
		return this.isUse;
	}//end of getUse();
	
	/**
	 * 사용 시간을 return한다.
	 * @return
	 */
	public long getUseTime(){
		if(this.isUse){
			return System.currentTimeMillis() - this.useTime;
		}else{
			return 0l;
		}
	}//end of getUseTime();
	
	/**
	 * 이 Socket의 사용 횟수를 return한다.
	 * @return
	 */
	public long getUseCount(){
		return this.useCount;
	}//end of getUseCount();
	
	/**
	 * Socket이 접속한 서버의 IP 정보를 return한다.
	 * @return
	 */
	public String getHost(){
		return this.host;
	}//end of getHost();
	
	/**
	 * Socket이 접속한 서버의 port 정보를 return한다.
	 * @return
	 */
	public int getPort(){
		return this.port;
	}//end of getPort();
	
	/**
	 * Header write
	 * @param header
	 * @throws Exception
	 */
	public void writeHeader(InHeader header) throws Exception{
		os.write(header.getInputHeader());
		os.flush();
	}//end of writeHeader();
	
	/**
	 * Body write
	 * @param data
	 * @throws Exception
	 */
	public void writeData(byte[] data) throws IOException, Exception{
		try{
			os.write(data);
			os.flush();
		}catch(IOException e){
			throw e;
		}catch(Exception e){
			throw e;
		}
	}//end of write();
	
	/**
	 * Header read
	 * @return
	 * @throws Exception
	 */
	public byte[] readCommonHeader() throws IOException, Exception{
		int headerSize = OutHeader.COMMONHEADER_OUTPUT_SIZE;
		byte[] header = new byte[headerSize];
		int readedSize = 0;
		for(int i=0;headerSize>readedSize;i++){
			readedSize = is.read(header, readedSize, headerSize-readedSize);
			if(readedSize<0){
				throw new IOException("데이터 통신 지연. 잠시 후 다시 이용해 주십시오.");
			}
			readedSize += readedSize;
		}
		return header;
/*
		while((readedSize=is.read(header, readedSize, headerSize-readedSize))>-1){
			readedSize+=readedSize ;
			if(readedSize>=headerSize)	return header;
		}
		return header;

		try{
			byte[] header = new byte[OutHeader.COMMONHEADER_OUTPUT_SIZE];
			int readedSize = 0;
			while(readedSize=is.read(header)){
				
			}
			return header;
		}catch(IOException e){
			throw e;
		}catch(Exception e){
			throw e;
		}
*/
	}//end of readCommonHeader();
	
	/**
	 * TmaxHeader read
	 * @return
	 * @throws Exception
	 */
	public byte[] readTMaxHeader() throws Exception{
		int headerSize = TMaxHeader.HEADER_SIZE;
		byte[] header = new byte[headerSize];
		int readedSize = 0;
		while(headerSize>readedSize){
			readedSize = is.read(header, readedSize, headerSize-readedSize);
			if(readedSize<0){
				throw new IOException("데이터 통신 지연. 잠시 후 다시 이용해 주십시오.");
			}
			readedSize += readedSize;
		}
		return header;
/*
		byte[] tmaxHeader = new byte[TMaxHeader.HEADER_SIZE];
		is.read(tmaxHeader);
		return tmaxHeader;
*/
	}//end of readTMaxHeader();
	
	/**
	 * Body read
	 * @param dataSize
	 * @return
	 * @throws Exception
	 */
	public byte[] readData(int dataSize) throws Exception{
		byte[] result = null;
		byte[] buffer = new byte[8192];
		int len = 0, datalen= 0;
		while((len=is.read(buffer))>-1){
			result = tool.append(result, buffer, 0, len);
			datalen += len;
			if(datalen>=dataSize)	break;
		}
		return result;
	}//end of readData();
	
}//end of Connection