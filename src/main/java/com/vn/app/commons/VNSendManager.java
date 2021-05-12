package com.vn.app.commons;

import java.util.Hashtable;
import java.util.Set;

import m.config.SystemConfig;

@SuppressWarnings("deprecation")
public class VNSendManager {
	
	private static long index;
	
	private static Hashtable<String, VNSend> list = new Hashtable<String,VNSend>();

	public static void set(VNSend client){
		long idx = nextIndex();
		VNSend oldclient = list.get(String.valueOf(idx));
		if(oldclient==null)		list.put(String.valueOf(idx), client);
		else					set(client);
	}//end of set();
	
	public static long nextIndex(){
		return index++;
	}//end of nextIndex();
	
	public static void check(){
		Set<String> key = list.keySet();
		String[] names = key.toArray(new String[]{});
		for(int i=0, len=names.length;i<len;i++){
			try{
				VNSend client = list.get(names[i]);
				long startTime = client.getStartTime();
				if(System.currentTimeMillis()-startTime>SystemConfig.getTTLTimeout()){
					client.getHttpClient().close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}//end of check();

	public static void run(){
		while(true){
			try{
				check();
				Thread.sleep(5000l);
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}//end of run();
	
	static{
		run();
	}
}
