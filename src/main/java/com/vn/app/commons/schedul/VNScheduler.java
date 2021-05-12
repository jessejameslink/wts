package com.vn.app.commons.schedul;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.vn.app.commons.VNUtil;
import com.vn.app.commons.util.ItemCode;

@Component
public class VNScheduler {

	private static final Logger logger = LoggerFactory.getLogger(VNScheduler.class);
	private static long	rcodCnt	=	0;
	/*
		"0 0 12 * *?" Any day, every month, every day 12:00:00
		"0 15 10? * *" Days, Monthly, Not Available 10:15:00
		"0 15 10 * *?" Any day, every month, every day 10:15:00
		"0 15 10 * *? *" Every day, every day, every month, every day 10:15
		"0 15 10 * * 2005" Any day of the week in 2005, every day 10:15
		"0 * 14 * *?" Any day, month, day, 14 cement 0 sec
		"0 0/5 14 * *?" Any day, every month, every day, every 14 minutes Every 0 minutes 0 seconds
		"0 0/5 14,18 * *?" Any day, every month, every day, 14 o'clock, 18 o'clock 0 seconds every 5 minutes
		"0 0-5 14 * *?" Any day, every month, every day, from 14:00 to every 14:05 every minute 0 seconds
		"0 10,44 14? â€‹â€‹3 WED" Every Wednesday in March, another date or 14:10:00, 14:44:00
		"0 15 10? * MON-FRI" Mon-Fri, every month, 10:15:00 am
		"0 15 10 15 *?" Any day, 15th of every month 10:15:00
	 */
	
	
	/**
	 * ìŠ¤ì¼€ì¥´ëŸ¬ ì˜ˆì œ
	 * @throws Exception
	 * <pre>
	 * 2016. 07. 05. [VN] ìž„ìˆ˜ì„� - ìµœì´ˆìž‘ì„±
	 * left  -> right
	 * Seconds : 0 ~ 59
 	 * Minutes : 0 ~ 59
 	 * Hours   : 0 ~ 23  
 	 * Day of Month : 1 ~ 31
 	 * Month : 1 ~ 12 
 	 * Day of Week : 1 ~ 7 (1 => ì�¼ìš”ì�¼, 7=> í† ìš”ì�¼ / MON,SUN...) 
 	 * Years(optional) : 1970 ~ 2099 
	 * </pre>
	 */
	/*
	@Scheduled(cron="0 0/2 * * * ?")
	public void deleteReqUserInfo() throws Exception{
		logger.info("###### Now Date"+VNUtil.getTimeStamp());		
	}	
	*/
	//Rcod Get Time am08:45
	@Scheduled(cron="0 0/15 08 * * ?")
	public void chkInfo() throws Exception{
		try {
			ItemCode	item	=	new ItemCode();
			item.getRcodContent();
		} catch(Exception e) {
			//System.out.println("@Schedule CHKINFO Error@");
			//System.out.println(e.getMessage());
			e.getMessage();
		}
		//String content	=	item.getRcodContent();
	}	
	
	@Scheduled(cron="0 0/3 * * * ?")
	public void initRcod() throws Exception{
		//System.out.println("í™”ë©´ ë¡œë“œì‹œ ì¢…ëª©ì½”ë“œ ì—…ë�°ì�´íŠ¸ í˜¸ì¶œ");
		if(rcodCnt == 0) {
			//System.out.println("$$ì¢…ëª©ì½”ë“œ ì—…ë�°ì�´íŠ¸==================================================");
			try {
				ItemCode	item	=	new ItemCode();
				item.getRcodContent();
			} catch(Exception e) {
				//System.out.println("@Schedule CHKINFO Error@");
				//System.out.println(e.getMessage());
				e.getMessage();
			}
			rcodCnt++;
		}
	}
	
	//Get miraeassetdaewoo data page call
	@Scheduled(cron="0 0/5 * * * ?")
	public void madw() throws Exception{
		logger.info("@@@@@@SCHEDULE MADW CHECK");
		logger.info("###### Now Date"+VNUtil.getTimeStamp());
		try {
			ItemCode	item	=	new ItemCode();
			item.setUpdateMadw();
		} catch(Exception e) {
			//System.out.println("@Schedule MADW Error@");
			//System.out.println(e.getMessage());
			e.getMessage();
		}
		//String content	=	item.getRcodContent();
	}
	
	
	
}
