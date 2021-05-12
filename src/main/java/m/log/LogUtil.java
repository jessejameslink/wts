package m.log;

import java.net.InetAddress;
import java.util.StringTokenizer;

import m.action.executer.Chart;
import m.action.executer.Comm;
import m.action.executer.OOP;
import m.action.executer.TR;
import m.action.IConstants;
import m.common.tool.tool;
import m.config.SystemConfig;
import m.format.DefinitionFactory;
import m.format.Transaction;
import m.format.header.InHeader;
import m.format.header.OutHeader;
import m.format.header.TMaxHeader;
import m.security.SeedLog;
import m.web.common.WebInterface;
import m.log.LogCfg;

/**
 * 濡쒓렇 愿��젴 怨듯넻紐⑤뱢.
 * �쇅遺��뿉�꽌 濡쒓렇瑜� �궓湲몃븣 �샇異쒗빐�꽌 �궗�슜.
 * 
 * @author poemlife
 */
public class LogUtil implements IConstants{
	private static SeedLog seed;
	
	private static LogWriter accesslog		= new LogWriter(SystemConfig.get("ACCESSLOG"		));
	private static LogWriter trlog			= new LogWriter(SystemConfig.get("TRLOG"			));
	private static LogWriter loginlog 		= new LogWriter(SystemConfig.get("LOGINLOG"		));
	
	private static String serverip;

	public synchronized static void getInstance(){
		try{
			if(accesslog	==null)	accesslog	= new LogWriter(SystemConfig.get("ACCESSLOG"		));		//Access Log
			if(trlog		==null)	trlog		= new LogWriter(SystemConfig.get("TRLOG"			));		//TR Log
			if(loginlog		==null)	loginlog 	= new LogWriter(SystemConfig.get("LOGINLOG"		));		//�젒�냽濡쒓렇
			StringBuffer usip = new StringBuffer();
			StringTokenizer ip = new StringTokenizer(InetAddress.getLocalHost().getHostAddress(), ".");
			while(ip.hasMoreTokens()){
				usip.append(tool.fillChar(ip.nextToken(), 3, '0', tool.LEFT));
			}
			serverip = usip.toString();
		}catch(Exception e){
    		e.printStackTrace();
    		serverip = SystemConfig.getServerIP();
    	}
	}//end of getInstance();
	
	/**
	 * Log File�쓣 �깮�꽦�븳�떎.
	 */
	public synchronized static void makeLogFile(){
		if(accesslog	!=null){	accesslog		.close();	accesslog	.open(SystemConfig.get("ACCESSLOG"	));	}	//Access Log
		if(trlog		!=null){	trlog			.close();	trlog		.open(SystemConfig.get("TRLOG"		));	}	//TR Log
		if(loginlog		!=null){	loginlog		.close();	loginlog 	.open(SystemConfig.get("LOGINLOG"		));	}	//�젒�냽濡쒓렇
	}//end of makeLogFile();
	
	static{
		try{
			StringBuffer usip = new StringBuffer();
			StringTokenizer ip = new StringTokenizer(InetAddress.getLocalHost().getHostAddress(), ".");
			while(ip.hasMoreTokens()){
				usip.append(tool.fillChar(ip.nextToken(), 3, '0', tool.LEFT));
			}
			serverip = usip.toString();
//			makeLogFile();
			getInstance();
		}catch(Exception e){
			e.printStackTrace();
			serverip = SystemConfig.getServerIP();
		}
	}//end of static

	
	/**
	 * �쎒 �젒洹쇰줈洹몃�� �궓湲대떎.
	 * Log format : [weblog][access][time][userid][userip][ap name]
	 * @param req
	 */
	public static void printAccessLog(WebInterface req, String targetName){
		try{
			String domain = req.getServerName();
			String origin = null;
			String userid = tool.fillChar(req.getUsid(), 8, ' ', tool.RIGHT);
			if(tool.isNull(targetName))	targetName = "targetId";
			if("true".equals(req.getIsMTS())){
				origin = "M";
				domain = "mstock.smartmiraeasset.com";
			}else if("true".equals(req.getMTSLite())){
				origin = "L";
				domain = "mstocklite.smartmiraeasset.com";
			}else if(req.isNative()){
				origin = "N";
				domain = "finweb.smartmiraeasset.com";
			}else{
				origin = "W";
				domain = req.getServerName();
			}
			accesslog.write("access::"+req.getMediaCode()+"::"+origin+"::"+domain+"::"+tool.getCurrentFormatedTime()+"::"+userid+"::"+req.getClientIP()+"::"+seed.encrypt(req.getMacAddr().getBytes())+"::"+req.getString(targetName)+"::"+req.getRequestURL());
//			  �떆媛�|�솕硫댁퐫�뱶||ID|IP|濡쒓렇�씤�샃�뀡|�씠�쟾�솕硫댁퐫�뱶|�떒留먯젙蹂�|�빐�긽�룄|留ㅼ껜肄붾뱶|||||||||||||
//  20160105000007|100000||kRsixsEWd7jm42B5rHl7Og==|175.223.27.141|||||76|211.115.103.115|1.66|||||||||||
			
//			wlog.write(tool.getCurrentTime()+"|"+req.getString(targetName)+"||"+userid+"|"+domain+"||||"+req.getMediaCode()+"|url="+req.getRequestURL()+"|"+origin+"|||||||||||");
		}catch(Exception e){
    		e.printStackTrace();
    	}
	}//end of printAccessLog();
	
	public static void printAccessLog(WebInterface req){
		printAccessLog(req, "targetId");
	}//end of printAccessLog();

	/**
	 * �쎒 �젒�냽濡쒓렇瑜� �궓湲대떎.
	 * Log format : [weblog][login][time][userid][userIP][serverIp][濡쒓렇�씤�꽦怨듭뿬遺�][Method][�씤利앹꽱�꽣 鍮꾩긽�뿬遺�][怨듭씤�씤利앹뿬遺�][二쇰Ц�떆�씤利앹꽌�옱�솗�씤�뿬遺�][�겢�씪�씠�뼵�듃�젙蹂�][NAT�젙蹂�][Base64 Encoded ���꽌紐낃컪]
	 * 
	 * @param req
	 * @param wdata �겢�씪�씠�뼵�듃 �떒留먯젙蹂�
	 * @param success 濡쒓렇�씤 �꽦怨듭뿬遺�
	 * @param level 濡쒓렇�씤 �젅踰�
	 */
    public static void printLoginLog(WebInterface req, String wdata, int success, String level){
    	try{
            loginlog.write(
            		(new StringBuilder("[weblog][login]["))
            			.append(req.getMediaCode()).append("][")
            			.append(tool.getCurrentFormatedTime()).append("][")
            			.append(req.getUsid()).append("][")
            			.append(req.getClientIP()).append("][")
            			.append(req.getMacAddr()).append("][")
            			.append(serverip).append("][")
            			.append("]succ[").append(success==1?"Y":"N")
            			.append("]Method[").append(req.getString("login.Method"))
            			.append("]Xchk[").append(req.getXchk())
            			.append("]Cert[").append(req.getCertlogin())
            			.append("]reCert[").append(req.getReconfirmCert())
            			.append("]clinfo[").append(wdata)
            			.append("]Sign[").append(req.getString("signedDataString").replace("\n", ""))
            			.append("]level[").append(level).append("]").toString());

    	}catch(Exception e){
    		e.printStackTrace();
    	}
    }//end of printLoginLog();

    /**
     * TR 泥섎━ 濡쒓렇瑜� �궓湲대떎.
	 * Log format : [weblog][trinfo][time][user id][user ip][server ip][host ip][trname][servicename][hostname][�꽦怨듭뿬遺�][connect�쉷�뱷�떆 �냼�슂�떆媛�][泥섎━�냼�슂�떆媛�][error][messagecode][msg]
     * 
     * @param executer
     */
	public static void printTRLog(TR executer){
		WebInterface req = executer.getRequest();
		try{
			String LogID = "";
			if (!tool.isNull(req.getUsid())){
				LogID = tool.fillChar(req.getUsid(), 8, ' ', tool.RIGHT);
			} else{
				LogID = "        ";
			}
			String trName = executer.getTR();
			String serviceName = null;
	        String error = " ";
	        String msgcode = new String();
	        String msg = new String();
			if(trName.length()==8){
				serviceName = "         ";
				OutHeader header = executer.getOutHeader();
				if(header != null){
					error = header.getReturnCode();
					msgcode = "      ";
					msg = header.getReturnMessage().trim();
				}
			}else if(trName.length()==9||trName.startsWith("retire.")){
				trName = "pibohmax";
				serviceName = executer.getTR();
				TMaxHeader header = executer.getTmaxOutHeader();
				if(header != null){
					error = header.getReturnCode();
					msgcode = header.getMessageCode();
					msg = header.getReturnMessage().trim();
				}
			}
			char succ = 'N';
			if(executer.getSuccess())		succ = 'Y';
			if(!SystemConfig.isAvoidLogTR(trName)){
//			if(!"bo047009".equals(trName)){
				trlog.write("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+trName+"]["+serviceName+"]["+req.getActionName()+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
				//Log.print("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+trName+"]["+serviceName+"]["+req.getActionName()+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
			}
		}catch(Exception e){
    		e.printStackTrace();
    	}
	}//end of printTRLog();
	
	/**
     * TR 泥섎━ 濡쒓렇瑜� �궓湲대떎.
	 * Log format : [weblog][trinfo][time][user id][user ip][server ip][host ip][trname][servicename][hostname][�꽦怨듭뿬遺�][connect�쉷�뱷�떆 �냼�슂�떆媛�][泥섎━�냼�슂�떆媛�][error][messagecode][msg]
     * 
     * @param executer
     */
	public static void printTRLog(Comm executer){
		WebInterface req = executer.getRequest();
		try{
			String LogID = "";
			if (!tool.isNull(req.getUsid())){
				LogID = tool.fillChar(req.getUsid(), 8, ' ', tool.RIGHT);
			} else{
				LogID = "        ";
			}
			String trName = executer.getTR();
			String serviceName = null;
	        String error = " ";
	        String msgcode = new String();
	        String msg = new String();
			trName = "commhmax";
			serviceName = executer.getTR();
			TMaxHeader header = executer.getTmaxOutHeader();
			if(header != null){
				error = header.getReturnCode();
				msgcode = header.getMessageCode();
				msg = header.getReturnMessage().trim();
			}
			char succ = 'N';
			if(executer.getSuccess())		succ = 'Y';
			if(!SystemConfig.isAvoidLogTR(trName)){
//			if(!"bo047009".equals(trName)){
				trlog.write("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+trName+"]["+serviceName+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
				//Log.print("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+trName+"]["+serviceName+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
			}
		}catch(Exception e){
    		e.printStackTrace();
    	}
	}//end of printTRLog();

	/**
     * OOP 泥섎━ 濡쒓렇瑜� �궓湲대떎.
	 * Log format : [weblog][trinfo][time][user id][user ip][server ip][host ip][trname][servicename][hostname][�꽦怨듭뿬遺�][connect�쉷�뱷�떆 �냼�슂�떆媛�][泥섎━�냼�슂�떆媛�][error][messagecode][msg]
     * 
     * @param executer
     */
	public static void printOOPLog(OOP executer){
		try{
			WebInterface req = executer.getRequest();
			String LogID = "";
			if (!tool.isNull(req.getUsid())){
				LogID = tool.fillChar(req.getUsid(), 8, ' ', tool.RIGHT);
			} else{
				LogID = "        ";
			}
			String trName = executer.getTR();
			String serviceName = null;
			String error = " ";
	        String msgcode = new String();
	        String msg = new String();
	        serviceName = "         ";
			OutHeader header = executer.getOutHeader();
			if(header != null){
				error = header.getReturnCode();
				msg = header.getReturnMessage().trim();
			}
			msgcode = "      ";
			Transaction definition = (Transaction)DefinitionFactory.getFormat(trName);
			char succ = 'N';
			if(executer.getSuccess())		succ = 'Y';
			if(!SystemConfig.isAvoidLogTR(trName)){
				trlog.write("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+definition.getTR()+"]["+serviceName+"]["+req.getActionName()+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
				//Log.print("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+definition.getTR()+"]["+serviceName+"]["+req.getActionName()+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
			}
		}catch(Exception e){
    		e.printStackTrace();
    	}
	}//end of printOOPLog();
	
	/**
     * Chart 泥섎━ 濡쒓렇瑜� �궓湲대떎.
	 * Log format : [weblog][trinfo][time][user id][user ip][server ip][host ip][trname][servicename][hostname][�꽦怨듭뿬遺�][connect�쉷�뱷�떆 �냼�슂�떆媛�][泥섎━�냼�슂�떆媛�][error][messagecode][msg]
     * 
     * @param executer
     */
	public static void printChartLog(Chart executer){
		try{
			WebInterface req = executer.getRequest();
			String LogID = "";
			if (!tool.isNull(req.getUsid())){
				LogID = tool.fillChar(req.getUsid(), 8, ' ', tool.RIGHT);
			} else{
				LogID = "        ";
			}
			String trName = executer.getTR();
			String serviceName = null;
			String error = " ";
	        String msgcode = new String();
	        String msg = new String();
	        serviceName = "         ";
			OutHeader header = executer.getOutHeader();
			if(header != null){
				error = header.getReturnCode();
				msg = header.getReturnMessage().trim();
			}
			msgcode = "      ";
			char succ = 'N';
			if(executer.getSuccess())		succ = 'Y';
			if(!SystemConfig.isAvoidLogTR(trName)){
				trlog.write("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+trName+"]["+serviceName+"]["+req.getActionName()+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
				//Log.print("[weblog][trinfo]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]["+LogID+"]["+req.getClientIP()+"]["+req.getMacAddr()+"]["+serverip+"]["+executer.getHostIP()+"]["+trName+"]["+serviceName+"]["+req.getActionName()+"]host["+executer.getHost()+"]succ["+succ+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]error["+error+"]["+msgcode+"]["+msg+"]");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of printChartLog();
	
	/**
	 * 濡쒓렇�씤 �꽭�뀡 �씠�긽�쁽�긽�뿉 ��鍮꾪븳 濡쒓렇 �궓湲곌린
	 * Log format : [weblog][IDException][�넻�떊諛⑸쾿][time][in trname][out trname][in ip][out ip][hostip][connection�쉷�뱷�떆 �냼�슂�떆媛�][泥섎━�떆媛�][由ы꽩肄붾뱶][由ы꽩肄붾뱶][由ы꽩硫붿꽭吏�][input][output]
	 * @param executer
	 */
	public static void printIDExceptionLog(TR executer){
		try{
			WebInterface req = executer.getRequest();
			String trName = executer.getTR();
			if(trName.length()==8){
	        	InHeader in = executer.getInHeader();
	        	OutHeader out = executer.getOutHeader();

	        	trlog.write("[weblog][IDException][BP]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]"
						+ "tr["+in.getTrName()+"]["+out.getTrName()+"]"
						+ "ip["+in.getUsip()+"]["+out.getUsip()+"]" 
						+ "con["+executer.getHostIP()+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]"
						+ "error["+out.getReturnCode()+"]["+out.getReturnMessage()+"]"
						+ "["+seed.encrypt(executer.getInput())+"]["+seed.encrypt(executer.getOutput())+"]"
				);
/*
	        	Log.print("[weblog][IDException][BP]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]"
						+ "tr["+in.getTrName()+"]["+out.getTrName()+"]"
						+ "ip["+in.getUsip()+"]["+out.getUsip()+"]" 
						+ "con["+executer.getHostIP()+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]"
						+ "error["+out.getReturnCode()+"]["+out.getReturnMessage()+"]"
						+ "["+seed.encrypt(executer.getInput())+"]["+seed.encrypt(executer.getOutput())+"]"
				);
*/
			}else if(trName.length()==9||trName.startsWith("retire.")){
				TMaxHeader in = executer.getTmaxInHeader();
				TMaxHeader out = executer.getTmaxOutHeader();
/*
				Log.print("[weblog][IDException][WT]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]"
						+ "service["+in.getService()+"]["+out.getService()+"]"
						+ "ip["+in.getClientIP()+"]["+out.getClientIP()+"]" 
						+ "con["+executer.getHostIP()+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]"
						+ "error["+out.getReturnCode()+"]["+out.getMessageCode()+"]["+out.getReturnMessage()+"]"
						+ "["+seed.encrypt(executer.getTmaxInput())+"]["+seed.encrypt(executer.getTmaxOutput())+"]"
				);
*/						
				trlog.write("[weblog][IDException][WT]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]"
						+ "service["+in.getService()+"]["+out.getService()+"]"
						+ "ip["+in.getClientIP()+"]["+out.getClientIP()+"]" 
						+ "con["+executer.getHostIP()+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]"
						+ "error["+out.getReturnCode()+"]["+out.getMessageCode()+"]["+out.getReturnMessage()+"]"
						+ "["+seed.encrypt(executer.getTmaxInput())+"]["+seed.encrypt(executer.getTmaxOutput())+"]"
				);
			}
		}catch(Exception e){
    		e.printStackTrace();
    	}
	}//end of printIDExceptionLog();

	/**
	 * 濡쒓렇�씤 �꽭�뀡 �씠�긽�쁽�긽�뿉 ��鍮꾪븳 濡쒓렇 �궓湲곌린
	 * Log format : [weblog][IDException][�넻�떊諛⑸쾿][time][in trname][out trname][in ip][out ip][hostip][connection�쉷�뱷�떆 �냼�슂�떆媛�][泥섎━�떆媛�][由ы꽩肄붾뱶][由ы꽩肄붾뱶][由ы꽩硫붿꽭吏�][input][output]
	 * @param executer
	 */
	public static void printIDExceptionLog(Comm executer){
		try{
			WebInterface req = executer.getRequest();
			TMaxHeader in = executer.getTmaxInHeader();
			TMaxHeader out = executer.getTmaxOutHeader();

			trlog.write("[weblog][IDException][WT]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]"
					+ "service["+in.getService()+"]["+out.getService()+"]"
					+ "ip["+in.getClientIP()+"]["+out.getClientIP()+"]" 
					+ "con["+executer.getHostIP()+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]"
					+ "error["+out.getReturnCode()+"]["+out.getMessageCode()+"]["+out.getReturnMessage()+"]"
					+ "["+seed.encrypt(executer.getTmaxInput())+"]["+seed.encrypt(executer.getTmaxOutput())+"]"
			);
/*
			Log.print("[weblog][IDException][WT]["+req.getMediaCode()+"]["+tool.getCurrentFormatedTime()+"]"
					+ "service["+in.getService()+"]["+out.getService()+"]"
					+ "ip["+in.getClientIP()+"]["+out.getClientIP()+"]" 
					+ "con["+executer.getHostIP()+"]time["+executer.getConnectionTime()+"]["+executer.getTrTime()+"]"
					+ "error["+out.getReturnCode()+"]["+out.getMessageCode()+"]["+out.getReturnMessage()+"]"
					+ "["+seed.encrypt(executer.getTmaxInput())+"]["+seed.encrypt(executer.getTmaxOutput())+"]"
			);
*/
		}catch(Exception e){
    		e.printStackTrace();
    	}
	}//end of printCertLog();
	
	static{
		try{
			seed = new SeedLog();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}//end of LogUtil
