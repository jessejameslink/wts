package m.config;

import java.io.*;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Properties;

import com.vn.app.commons.util.ItemCode;

import m.action.IConstants;
import m.common.tool.tool;
import m.data.hash;

/**
 * system config ?젙?쓽 Class
 * 
 * @author nhy67
 * @author poemlife
 */

public class SystemConfig implements IConstants{

	private static hash<String> config = new hash<String>();

	private static String SERVERIP	= "100000031009";
	private static String BPHOST 		= "10.0.31.9";
	private static String BPPORT 		= "15204";
	private static String BPCNT 		= "3";

	private static String TTLHOST		= "";

	private static long TTLCheckInterval = 5000l;
	private static long TTLTimeout		= 30000l; 
	
	private static boolean 	_logWrite 	= false;
	private static boolean 	_loaded		= false;
	private static boolean 	DB_DISABLED	= false;
	
	private static HashSet<String> avoidList = new HashSet<String>(); 

	/**
	 * Log를 남기지 않을 TR명을 Setting한다.
	 * @param trname
	 */
	public static void setAvoidLogTR(String trname){
		avoidList.add(trname);
	}//end of setAvoidLogTR();
	
	/**
	 * 해당 TR이 Log를 남길건지 여부를 returng한다.
	 * @param trname
	 * @return 로그를 남기면 true, 아니면 false
	 */
	public static boolean isAvoidLogTR(String trname){
		return avoidList.contains(trname);
	}//end of isAvoidLogTR();

	/**
	 * 로그를 남기지 않을 TR의 List를 return한다.
	 * @return
	 */
	public static String[] getAvoidLogTRList(){
		return avoidList.toArray(new String[]{});
	}//end of getAvoidLogTRList();
	
	/**
	 * Config瑜? Setting?븳?떎.
	 * @param name ?냽?꽦紐?
	 * @param value ?냽?꽦媛?
	 */
	public static void set(String name, String value) throws Exception{
		if(tool.isNull(name)||tool.isNull(value))	throw new Exception("name or value is null");
		config.put(name.trim(), value.trim());
	}//end of set();
	
	/**
	 * Config ?냽?꽦?쓣 return?븳?떎.
	 * @param name
	 * @return
	 */
	public static String get(String name){
		if(tool.isNull(name))		return new String();
		String value = config.get(name.trim());
		if(value==null)			return new String();
		else					return value.trim();
	}//end of get();
	
	public static void reload(){
		_loaded = false;
		load();
	}//end of reload();
	
	public static void load(){
		if (!_loaded){
			Properties p 	= new Properties();
			InputStream in 	= null;
			try{
				ClassLoader cl = Thread.currentThread().getContextClassLoader();
				if(cl == null){
					cl = ClassLoader.getSystemClassLoader();
				}
				
				try{
					
					String iPSer = ItemCode.getIp();
					//System.out.println("This is IP: " + iPSer);
					
//					if("10.0.31.9".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/9system.properties");
//					} else if("10.0.9.43".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/43system.properties");
//					} else if("10.0.31.2".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/opt.system.properties");
//					} else 
					if("10.0.31.7".equals(iPSer)) {
						System.out.println("This is IP : " + iPSer);
//						in = cl.getResourceAsStream("config/opt7.system.properties");
						in = cl.getResourceAsStream("config/opt7R6.system.properties");
//					}
//					if("10.0.31.8".equals(iPSer)) {
//						System.out.println("This is IP : " + iPSer);
//						in = cl.getResourceAsStream("config/opt7.system.properties");
//						in = cl.getResourceAsStream("config/opt8R6.system.properties");
//					} else 
//					if("10.0.31.28".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/opt28R6.system.properties");
//					} else if("10.0.31.11".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/opt11.system.properties");
//					} else if("10.0.31.13".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/opt13.system.properties");
//					} else if("10.0.31.14".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/opt14.system.properties");
//					} else if("10.0.31.5".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/dev5.system.properties");
//					} else if("10.0.16.56".equals(iPSer)) {
//						in = cl.getResourceAsStream("config/dev6.system.properties");
//					} else if("10.0.46.5".equals(iPSer)) {
//						System.out.println("TEST WTS R6");
//						in = cl.getResourceAsStream("config/dev65.system.properties");
//					} else if("10.0.46.9".equals(iPSer)) {
//						System.out.println("TEWTS R6 469");
//						in = cl.getResourceAsStream("config/dev469.system.properties");
//					} else if("10.0.46.10".equals(iPSer)) {
//						System.out.println("TEWTS R6 469");
//						in = cl.getResourceAsStream("config/dev4610.system.properties");
//					} else if("10.0.25.36".equals(iPSer) || "192.168.122.1".equals(iPSer)) {
//						System.out.println("TEWTS R6 25.36");
//						in = cl.getResourceAsStream("config/opt2536.system.properties");
//					} else if(ItemCode.getDomainName().contains("test.masvn.com")) {
//						System.out.println("TEST WTS R6 testmasvn");
//						in = cl.getResourceAsStream("config/testmasvn.system.properties");
					} else {
						System.out.println("This is IP else: " + iPSer);
						//in = cl.getResourceAsStream("config/system.properties");
						in = cl.getResourceAsStream("config/opt7R6.system.properties");
					}
					
					p.load(in);
					SERVERIP 	= p.getProperty("SERVERIP");
					BPHOST 		= p.getProperty("BPHOST");
					BPPORT 		= p.getProperty("BPPORT");
					BPCNT 		= p.getProperty("BPCNT");
					TTLHOST		= p.getProperty("TTLHOST");
					
					TTLCheckInterval = Long.parseLong(p.getProperty("TTLCheckInterval"));
					
					_logWrite 	= "TRUE".equals(p.getProperty("ISLOG").trim().toUpperCase());
					DB_DISABLED = "TRUE".equals(p.getProperty("DB_DISABLED").trim().toUpperCase());
					Enumeration<Object> enumeration = p.keys();
					while(enumeration.hasMoreElements()){
						String key = (String)enumeration.nextElement();
						set(key, p.getProperty(key));
					}
				}catch(Exception e){
					e.printStackTrace();
				}
				
				BufferedReader br = null;
				try{
					br = new BufferedReader(new InputStreamReader(cl.getResourceAsStream("config/AvoidLogTR.list")));
					String line = null;
					while((line=br.readLine())!=null){
						avoidList.add(line.trim());
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				try{
					_loaded = true;
					if(in!=null)		in.close();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
	}//end of load();
	
	/**
	 * SERVERIP SET
	 * @param value
	 * @throws Exception
	 */
	public static void setServerIP(String value) throws Exception{
		if(value != null && value.trim().length() > 0)			SERVERIP = value;
		else													throw new Exception("Config.SERVER_IP IS NULL OR EMPTY STRING: " + value);
	} //end of setServerIP();
	
	/**
	 * SERVERIP GET
	 * @return
	 */
	public static String getServerIP(){
		return SERVERIP;
	}//end of getServerIP();
	
	/**
	 * HTSBP HOST SET
	 * @param value
	 * @throws Exception
	 */
	public static void setBPHost(String value) throws Exception{
		if(value != null && value.trim().length() > 0)			BPHOST = value;
		else													throw new Exception("Config.BPHOST IS NULL OR EMPTY STRING: " + value);
	} //end of setBPHost();
	
	/**
	 * HTSBP HOST GET
	 * @return
	 */
	public static String getBPHost(){
		return BPHOST;
	}//end of getBPHost();
	
	/**
	 * HTSBP BPCNT SET
	 * @param value
	 * @throws Exception
	 */
	public static void setBPCnt(String value) throws Exception{
		if(value != null && value.trim().length() > 0)			BPCNT = value;
		else													throw new Exception("Config.BPCNT IS NULL OR EMPTY STRING: " + value);
	} //end of setBPCnt();
	
	/**
	 * HTSBP BPCNT GET
	 * @return
	 */
	public static int getBPCnt(){
		if(tool.isNull(BPCNT))	return 40;
		return Integer.parseInt(BPCNT);
	}//end of getBPCnt();
	
	/**
	 * HTSBP PORT SET
	 * @param value
	 * @throws Exception
	 */
	public static void setBPPort(String value) throws Exception{
		if(value != null && value.trim().length() > 0)			BPPORT = value;
		else													throw new Exception("Config.BPPORT IS NULL");
	} //end of setBPPort();
	
	/**
	 * HTSBP PORT GET
	 * @return
	 */
	public static String getBPPort(){
		return BPPORT;
	}//end of getBPPort();
	
	/**
	 * HTSBP HOST INT?삎 GET
	 * @return
	 * @throws Exception
	 */
	public static int getIntBPPort() throws Exception{
		int bpPort;
		try{
			bpPort = Integer.parseInt(BPPORT);
		}catch(Exception e){
			throw new Exception("Config.PORT_IP IS NOT NUMBER:");
		}
		return bpPort;
	}//end of getBPPort();
	
	/**
	 * ?쟾泥? 濡쒓렇瑜? ?궓湲몄? ?뿬遺?瑜? ?뙋?떒?븳?떎.
	 * @param log true硫? 濡쒓렇 ?궓源?, false硫? 濡쒓렇瑜? ?궓湲곗? ?븡?쓬.
	 */
	public static final void setLog(boolean log){
		_logWrite = log;
	}//end of setLog();

	/**
	 * 濡쒓렇瑜? ?궓湲곕뒗吏??뿉 ???븳 ?뿬遺?瑜? return?븳?떎.
	 * @return true硫? 濡쒓렇瑜? ?궓源?. false硫? 濡쒓렇瑜? ?궓湲곗? ?븡?쓬.
	 */
	public static final boolean getLog(){
		return _logWrite;
	}//end of getLog();
	
	/**
	 * 寃뚯떆?뙋?슜 DB鍮꾩긽?뿬遺? set
	 * @param true硫? 鍮꾩긽, false硫? ?젙?긽
	 */
	public static final void setDBDisabled(boolean state){
		DB_DISABLED = state;
	}//end of setLog();

	/**
	 * 寃뚯떆?뙋?슜 DB鍮꾩긽?뿬遺?瑜? return?븳?떎.
	 * @return true硫? 鍮꾩긽. false硫? ?젙?긽
	 */
	public static final boolean getDBDisabled(){
		return DB_DISABLED;
	}//end of getLog();

	public static final String getTTLHost(){
		return TTLHOST;
	}//end of getTTLHost();
	
	public static final void setTTLHost(String host){
		TTLHOST = host;
	}//end of setTTLHost();

	public static final long getTTLCheckInterval(){
		return TTLCheckInterval;
	}//end of getTTLcheckInterval();
	
	public static final void setTTLCheckInterval(long interval){
		TTLCheckInterval = interval;
	}//end of setTTLCheckInterval();

	public static final void setTTLTimeout(long timeout){
		TTLTimeout = timeout;
	}//end of setTTLTimeout();
	
	public static final long getTTLTimeout(){
		return TTLTimeout;
	}//end of getTTLTimeout();
	
	static{
		try{
			load();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
}//end of Config
