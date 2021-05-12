package m.pool.socket;

import java.util.Hashtable;
import m.config.SystemConfig;
import m.log.Log;

/**
 * pool을 관리하는 클래스
 * @author 김대원
 *
 */
public class PoolManager extends Thread {
	private long timeout;
	private long useCount;
	private long gcInterval;

	/**
	 * Timeout, maxusecount, run interver을 설정후 start
	 */
	public void start(){
		Log.println("[POOL][PoolManager.start!!!]");
		try{
			this.timeout = Long.parseLong(SystemConfig.get("TIMEOUT").trim());
			this.useCount = Long.parseLong(SystemConfig.get("MAXUSECOUNT").trim());
			this.gcInterval = Long.parseLong(SystemConfig.get("GCINTERVAL").trim());
			if(this.timeout==0l || this.timeout == 0){
				this.timeout = 30000l;
			}
			if(this.useCount==0l || this.useCount == 0){
				this.useCount = 10000l;
			}
			if(this.gcInterval==0l || this.gcInterval == 0){
				this.gcInterval = 1000l;
			}
		}catch(Exception e){
			e.printStackTrace();
			this.timeout = 30000l;
			this.useCount = 10000l;
			this.gcInterval = 1000l;
		}finally{
			super.start();
		}
		Log.println("[POOL][PoolManager.Info]["+this.timeout+"]["+this.useCount+"]["+this.gcInterval+"]");
	}//end of start();
	
	/**
	 * run interver마다 gc를 체크
	 * timeout인 경우 reconnet시킨다
	 * usecount가 초과되었을 경우 reconnet시킨다
	 */
	public void run(){
		while(true){
			Pool.gc();
			Hashtable<String,Connection> pool = Pool.getPool();
			java.util.Enumeration<String> e = pool.keys();
			while(e.hasMoreElements()){
				String key = e.nextElement();
				Connection conn = pool.get(key);
				long useTime = conn.getUseTime();
				
				if(useTime>this.timeout || conn.isClosed()){		//timeout인 경우
					boolean reconnect = Pool.reconnect(conn);
					Log.println("[POOL][PoolManager.run1]["+useTime+"]["+this.timeout+"]["+reconnect+"]");
				}
			}
			try{
				Thread.sleep(gcInterval);
			}catch(Exception exception){
				exception.printStackTrace();
			}
		}
	}//end of run();
	
}//end of PoolManager