package m.log;

import m.common.tool.tool;
import m.web.common.WebInterface;

/**
 * JEUS log control class
 * log_disabled이 false인 경우 log 출력
 * @author Owner
 *
 */
public class Log{
	private static boolean log_disabled = false;
	//private static boolean log_disabled = true;
	
	/**
	 * log 출력 여부 set
	 * @param disabled
	 */
	public static void setLogDisabled(boolean disabled){
		log_disabled = disabled;
	}//end of setLogDisabled();
	
	/**
	 * log_disabled return
	 * @return
	 */
	public static boolean getLogDisabled(){
		return log_disabled ;
	}//end of getLogDisabled();

	/**
	 * log 출력
	 * @param text
	 */
	public static void print(String text){
		if(log_disabled==false)	{
			System.out.print("[" + tool.getCurrentFormatedTime() + "]" + text);
		}
	}//print();
	
	/**
	 * log 출력
	 * @param text
	 */
	public static void println(String text){
		if(log_disabled==false)	{
			System.out.println("[" + tool.getCurrentFormatedTime() + "]" + text);
		}
	}//println();
	
	/**
	 * log 출력
	 * @param text
	 */
	public static void println(WebInterface req, String text){
		if(log_disabled==false)	{
			System.out.println("[" + tool.getCurrentFormatedTime() + "]" + text);
		}
	}//println();
	
	/**
	 * log 출력
	 * @param text
	 */
	public static void println(){
		if(log_disabled==false)	{
			System.out.println("");
		}
	}//println();
}
