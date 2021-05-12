package m.pool.socket;

import java.util.ArrayList;
import java.util.Hashtable;
import m.action.ActionException;
import m.action.IConstants;
import m.config.SystemConfig;
import m.log.Log;

/**
 * Socket Pool Object
 * @author 김대원
 */
public class PoolV2 implements IConstants{

	private static HostInfo[] hostInfo;
	private static int size;
	private static Hashtable<String,Connection> pool = new Hashtable<String,Connection>();

	private static ArrayList<Connection> gcPool = new ArrayList<Connection>();
	private static PoolManager manager;
	private static PoolV2 instance = null;
	
	private long TIMEWAIT;
	
	public PoolV2(){
		init();
	}
	
	public static PoolV2 getInstance() {
        if (instance == null) {
            synchronized (PoolV2.class) {
                if (instance == null) {
                    instance = new PoolV2();
                }
            }
        }

        return instance;
    }
	
	/**
	 * init
	 */
	private void init(){
		this.TIMEWAIT = Long.parseLong(SystemConfig.get("TIMEWAIT").trim());
		if(this.TIMEWAIT == 0l || this.TIMEWAIT == 0){
			this.TIMEWAIT = 10000l;
		}
	}
	
	/**
	 * Pool을 생성한다. 
	 * @param h
	 * @param p
	 * @throws Exception
	 */
	public static void makePool(String[] host, int port) throws Exception{
		if(host==null){
			throw new ActionException("[ER0200]",POOL_CREATE_FAIL_MSG);
		}
		size = host.length;
		hostInfo = new HostInfo[size];
		for(int i=0;i<size;i++){
			hostInfo[i] = new HostInfo();
			hostInfo[i].setHost(host[i]);
			hostInfo[i].setPort(port);
			hostInfo[i].setReconnect(false);
			Connection c = new Connection(i, hostInfo[i].getHost(), hostInfo[i].getPort());
			pool.put(String.valueOf(c.getId()), c);
		}
		if(manager==null){
			manager = new PoolManager();
			manager.start();
		}
	}//end of makePool();
	
	/**
	 * pool 을 return
	 * @return
	 */
	public static Hashtable<String,Connection> getPool(){
		return pool;
	}//end of getPool();
	
	/**
	 * Connection을 return한다.
	 * @param name
	 * @return
	 */
	public Connection getConnection() throws Exception{
		synchronized (this) {
			long start = System.currentTimeMillis();
			Connection conn = getFreeConnection();
			
			try{
				if(conn != null)	return conn;
				while(true){
					wait(1 * 1000);
					conn = getFreeConnection();
					if(conn != null)	break;
					
					long end = System.currentTimeMillis();
					if(end - start >= TIMEWAIT){
						Log.println("[POOL][EXCEPTION][ER0200][Pool.getConnection : Free Connection이 없음]");
						throw new ActionException("[ER0200]", BISANG_MSG);
					}
				}
				
				return conn;
			}catch(Exception e){
				Log.println("[POOL][EXCEPTION][ER0200][Pool.getConnection : Free Connection이 없음]");
				throw new ActionException("[ER0200]", BISANG_MSG);
			}
		}
	}//end of getConnection();
	
	private Connection getFreeConnection() throws Exception{
		for(int current = 0; current<size; current++){
			int id = current%size;
			Connection conn = pool.get(String.valueOf(id));
			if(conn==null){
				try{
					Log.println("[POOL][connection is null]["+id+"]["+hostInfo[id].getHost()+"]["+hostInfo[id].getPort()+"]");
					Connection c = new Connection(id, hostInfo[id].getHost(), hostInfo[id].getPort());
					pool.put(String.valueOf(c.getId()), c);
					hostInfo[id].setReconnect(false);
					c.setUse(true);
					return c;
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			if(!conn.getUse()){
				if(!hostInfo[id].getReconnect() && conn.isConnected()){
					conn.setUse(true);
					return conn;
				}
			}
		}
		
		return null;
	}
	
	/**
	 * 해당 Connection을 close시킨다.
	 * @param conn
	 */
	protected static void close(Connection conn){
		conn.closeConnection();
	}//end of close();
	
	/**
	 * Socket을 reconnect한다.
	 * @param conn
	 * @return
	 */
	protected static boolean reconnect(Connection conn){
		pool.remove(String.valueOf(conn.getId()));
		gcPool.add(conn);
		return true;
	}//end of reconnect();
	
	/**
	 * 사용하지 않는 Connection을 close시킨다.
	 */
	public static final void gc(){
		for(int i=0,size=gcPool.size();i<size;i++){
			try{
				Connection conn = gcPool.get(0);
				conn.closeConnection();
				gcPool.remove(0);
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}//end of gc();
	
	private static class HostInfo{
		/**
		 * 연결할 host 정보
		 */
		private String host;
		/**
		 * 재연결 여부
		 */
		private boolean reconnect = false;
		/**
		 * 연결할 port
		 */
		private int port;
		
		private void setHost(String host){
			this.host = host;
		}//end of setHost();
		
		private String getHost(){
			return this.host;
		}//end of getHost();
		
		private void setPort(int port){
			this.port = port;
		}//end of setPort();
		
		private int getPort(){
			return this.port;
		}//end of getPort();
		
		private void setReconnect(boolean start){
			this.reconnect = start;
		}//end of setReconnect();
		
		private boolean getReconnect(){
			return this.reconnect;
		}//end of getReconnect();
	}//end of HostInfo
	
	public static void main(String[] args){
		try{
			String[] host = new String[80];
			for(int i=0;i<host.length;i++){
				host[i] = "10.16.100.162";
			}
			PoolV2.makePool(host, 15204);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	static{
		int BPCNT = SystemConfig.getBPCnt();
		String[] host = new String[BPCNT];
		for(int i=0;i<host.length;i++){
			host[i] = "10.16.100.162";
		}
		try{
			Log.println("[POOL][before makePool!!!]");
			makePool(host, SystemConfig.getIntBPPort());
			Log.println("[POOL][after makePool!!!]");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}//end of Pool
