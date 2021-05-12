package m.pool.client;

import java.util.Enumeration;
import java.util.Properties;

import m.data.hash;
import m.common.tool.tool;

public class Manager extends Thread{
	private static int index;
	
	private static String[] urls;
	private static long check_interval = 60000l;
	private static int conn_timeout = 30000;
	private static hash<Connection> lists = new hash<Connection>();
	
	public synchronized static final Connection getConnection(){
		Connection conn = new Connection(next());
		conn.setId(index++);
		lists.put(String.valueOf(conn.getId()), conn);
		return conn;
	}//end of getConnection();

	/**
	 * 설정 파일을 읽어온다.
	 */
	public synchronized static final void readProperty(){
		Properties p = tool.readProperties("/actus/mirae/cfg/Communication.cfg");
		try{
			int size = Integer.parseInt(p.getProperty("URLSIZE").trim());
			urls = new String[size];
			for(int i=0;i<size;i++){
				urls[i] = p.getProperty("URL"+i);
			}
			check_interval = Long.parseLong(p.getProperty("CHECKINTERVAL").trim());
			conn_timeout = Integer.parseInt(p.getProperty("CONNECTIONTIMEOUT").trim());
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of readProperty();

	/**
	 * 접속할 서버의 URL을 Setting한다.
	 * 외부에서 해당 Method를 읽어올 수 있도록 public으로 정의한다.
	 * @param url
	 */
	public void setURL(String[] url){
		urls = url;
	}//end of setURL();
	
	/**
	 * 접속할 서버의 URL을 가져온다.
	 * @return
	 */
	public String[] getURL(){
		return urls;
	}//end of getURL();
	
	/**
	 * Connection 중 처리시간이 30초 이상인 Connection을 close시킨다.
	 */
	public synchronized static void cut(){
		Enumeration<Connection> conns = lists.elements();
		while(conns.hasMoreElements()){
			Connection conn = conns.nextElement();
			if(conn!=null){
				if(conn.getExecuteTime()>conn_timeout){
					conn.close();
					remove(conn);
				}
			}
		}
	}//end of clear();
	
	/**
	 * Connection을 close시키고, list에서 삭제한다.
	 * @param conn
	 */
	protected static final void remove(Connection conn){
		lists.remove(String.valueOf(conn.getId()));
	}//end of remove();
	
	public void run(){
		try{
			cut();
			Thread.sleep(check_interval);				//1분마다 한번씩 Connection들을 정리한다.
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of run();

	protected static String next(){
		return urls[index++%urls.length];
	}//end of next();

	static{
		readProperty();
	}//end of static
	
}//end of ConnectionInfo
