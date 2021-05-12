package m.log;

import java.io.InputStream;
import java.util.Properties;

import m.common.tool.tool;

public class LogCfg{
	public static final int ACCESSLOG 	= 1;		//access log. �젒洹쇰줈洹�
	public static final int LOGINLOG 	= 2;		//�젒�냽濡쒓렇. 濡쒓렇�씤�븳 濡쒓렇.
	public static final int TRLOG		= 3;		//TR 濡쒓렇. 紐⑤뱺 TR �궗�슜�떆 �궓源�.
	public static final int DBLOG		= 4;		//DB 濡쒓렇. 紐⑤뱺 DB 愿��젴 泥섎━�떆 �궓源�.
	public static final int CERTLOG		= 5; 		//�쟾�옄�꽌紐낃�利� 諛� 二쇰Ц 濡쒓렇. �쟾�옄�꽌紐낃�利� �썑 二쇰Ц�떆 �궓源�.
	public static final int FILELOG		= 6; 		//�뙆�씪�쟾�넚濡쒓렇. IDC �꽌踰꾨줈 �뙆�씪�쟾�넚�떆 �궓源�

	private static boolean _logWrite = false;
	private static int _logGrade = 0;
	private static boolean _isDev = false;
	
	public static final int NORMAL 	= 0;
	public static final int TOTAL	= 1;
	
	private static Properties cfg;
	
	/**
	 * /actus/mirae/cfg/nw.properties �뙆�씪�쓣 �씫�뼱�꽌 Log 愿��젴 �꽕�젙媛믪쓣 媛��졇�삩�떎.
	 * LogGrade : 濡쒓렇瑜� �궓湲� �벑湲�.
	 * 			Normal : 異뺤빟 濡쒓렇留� �궓源�.
	 * 			Total : �쟾泥� 濡쒓렇�궓 �궓源�.
	 * 			
	 */
	public static final void readProperties(){
		try {
			ClassLoader cl = Thread.currentThread().getContextClassLoader();
			if(cl == null){
				cl = ClassLoader.getSystemClassLoader();
			}
			InputStream in = cl.getResourceAsStream("config/system.properties");
			cfg.load(in);
			_logWrite = "TRUE".equals(cfg.getProperty("isLog").trim().toUpperCase());
			_logGrade = Integer.parseInt(cfg.getProperty("LogGrade").trim().toUpperCase());
			_isDev = "TRUE".equals(cfg.getProperty("isDev").trim().toUpperCase());
		}catch(Exception e)    {
			e.printStackTrace();
		}
	}//end of readProperties();

	/**
	 * �쟾泥� 濡쒓렇瑜� �궓湲몄� �뿬遺�瑜� �뙋�떒�븳�떎.
	 * @param log true硫� 濡쒓렇瑜� �궓湲곌퀬, false硫� �궓湲곗� �븡�뒗�떎.
	 */
	public static final void setLog(boolean log){
		_logWrite = log;
	}//end of setLog();

	/**
	 * 濡쒓렇�궓源��뿬遺�瑜� return�븳�떎.
	 * @return true硫� 濡쒓렇瑜� �궓湲곌퀬, false硫� �궓湲곗� �븡�뒗�떎.
	 */
	public static final boolean getLog(){
		return _logWrite;
	}//end of getLog();

	/**
	 * 濡쒓렇 �벑湲됱쓣 媛��졇�삩�떎.
	 * @return 1占싱몌옙 占쏢세로그몌옙 占쏙옙占쏙옙占쏙옙 占십곤옙, 2占쏙옙 占쏢세로그몌옙 占쏙옙占쏙옙占�.
	 */
	public static final int getLogGrade(){
		return _logGrade;
	}//end of getLog();

	/**
	 * 占싸그몌옙 占쏙옙占쏙옙占쏙옙 占쏙옙占싸몌옙 Setting占싼댐옙.
	 * @param logGrade 1占싱몌옙 占쏢세로그몌옙 占쏙옙占쏙옙占쏙옙 占십곤옙, 2占쏙옙 占쏢세로그몌옙 占쏙옙占쏙옙占�.
	 */
	public static final void setLogGrade(int logGrade){
		if(logGrade<0 || logGrade>2)		return;
		_logGrade = logGrade;
	}//end of setLogGrade();

	/**
	 * 占싸그몌옙 占쏙옙占쏙옙占쏙옙 占쏙옙占싸몌옙 Setting占싼댐옙.
	 * @param logGrade 1占싱몌옙 占쏢세로그몌옙 占쏙옙占쏙옙占쏙옙 占십곤옙, 2占쏙옙 占쏢세로그몌옙 占쏙옙占쏙옙占�.
	 */
	public static final void setLogGrade(String logGrade){
		if(tool.isNull(logGrade))		return;
		int lg = 0;
		try{
			lg = Integer.parseInt(logGrade.trim());
		}catch(Exception e){
			return;
		}
		_logGrade = lg;
	}//end of setLogGrade();

	/**
	 * 占쏙옙 占쏙옙占� 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占�, 占싣니몌옙 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占� 占쏙옙占싸몌옙 return占싼댐옙.
	 * @return 占쏙옙占쌩깍옙占싱몌옙 true, 占쏙옙占쏙옙占싱몌옙 false占쏙옙 return占싼댐옙.
	 */
	public static final boolean isDev(){
		return _isDev;
	}//end of isDev();

	/**
	 * 占쏙옙 占쏙옙占� 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占�, 占싣니몌옙 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占� 占쏙옙占싸몌옙 Setting占싼댐옙.
	 * @param isDev 占쏙옙占쌩깍옙占싱몌옙 true, 占쏙옙占쏙옙占싱몌옙 false占쏙옙 return占싼댐옙.
	 */
	public static final void setIsDev(boolean isDev){
		_isDev = isDev;
	}//end of setIsDev();

	/**
	 * 占쏙옙 占쏙옙占� 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占�, 占싣니몌옙 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占� 占쏙옙占싸몌옙 Setting占싼댐옙.
	 * @param isDev 占쏙옙占쌩깍옙占싱몌옙 true, 占쏙옙占쏙옙占싱몌옙 false占쏙옙 return占싼댐옙.
	 */
	public static final void setIsDev(String isDev){
		if(tool.isNull(isDev))		return;
		_isDev = "TRUE".equals(isDev.toUpperCase().trim());
	}//end of setIsDev();

	/**
	 * /actus/mirae/cfg/nw.properties �뙆�씪�쓣 �씫�뼱�꽌 name�뿉 �빐�떦�븯�뒗�젙蹂대�� 李얠븘�꽌 return�븳�떎.
	 * @param name
	 * @return
	 */
	public static final String getProperty(String name){
		if(cfg==null)		readProperties();
		return cfg.getProperty(name); 
	}//end of getProperty();
	
	static{
		readProperties();
	}
}