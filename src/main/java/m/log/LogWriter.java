package m.log;

import java.io.*;
import m.action.IConstants;
import m.common.tool.tool;

/**
 * log�뿉 ���븳 湲곕줉�쓣 愿�由ы븯�뒗 �겢�옒�뒪
 * @author 源����썝
 *
 */
public class LogWriter implements IConstants{
	private FileOutputStream writer;
	private String filename;
	
	public LogWriter(String logFileName){
		open(logFileName);
	}//end of Log();
	
	/**
	 * File�뿉 ���븳 stream�쓣 �깮�꽦�븳�떎
	 * @param logFileName
	 */
	public void open(String logFileName){
		try{
			this.filename = logFileName;
			this.writer = new FileOutputStream(logFileName+'_'+tool.getToday(), true);
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of open();
	
	/**
	 * File�뿉 ���븳 stream �떕�뒗�떎
	 */
	public void close(){
		try{
			if(this.writer!=null)		this.writer.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of close();
	
	/**
	 * File�뿉 濡쒓렇瑜� 湲곕줉�븳�떎
	 * @param msg
	 */
	public void write(String msg){
		try{
			if(!new File(this.filename).exists()){
				this.open(this.filename);
			}
			writer.write(msg.getBytes());
			writer.write("\n".getBytes());
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of write();
	
	/**
	 * FileOutputStream return
	 * @return
	 */
	public FileOutputStream getWriter(){
		return this.writer;
	}// end of getWriter();
	
}//end of Log
