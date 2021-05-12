package m.action;

import java.util.Enumeration;
import java.util.Hashtable;

import m.action.executer.TransactionExecuter;
import m.web.common.WebInterface;

/**
 * TR을 async 방식으로 처리한다.
 * 이런 TR들을 관리하는 Manager class이다.
 * @author Onwer
 *
 */
public class TRManager {
	public static final int READY 		= -1;
	public static final int SENDED 		= 1;
	public static final int RECEIVED 	= 2;
	public static final int ERROR		= 3;
	
	private long startTime; 

	private WebInterface req;
	private Hashtable<String,TransactionExecuter> trs = new Hashtable<String,TransactionExecuter>();
	
	public TRManager(WebInterface req){
		this.req = req;
	}//end of TRManager();
	
	/**
	 * TR을 생성해서 전송한다.
	 * @param trname
	 */
	public void executeTR(String trname){
		try{
			Thread.sleep(50l);
			TRAExecuter executer = new TRAExecuter(this.req, trname);
			trs.put(trname, executer);
			executer.execute();
			if(startTime==0l)		startTime = System.currentTimeMillis();
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of executeTR();

	/**
	 * Chart TR을 생성해서 전송한다.
	 * @param trname
	 */
	public void executeChart(String trname){
		try{
			ChartAExecuter executer = new ChartAExecuter(this.req, trname);
			trs.put(trname, executer);
			executer.execute();
			if(startTime==0l)		startTime = System.currentTimeMillis();
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of executeChart();

	/**
	 * TR을 생성해서 전송한다.
	 * @param trname
	 */
	public void executeOOP(String trname){
		try{
			OOPAExecuter executer = new OOPAExecuter(this.req, trname);
			trs.put(trname, executer);
			executer.execute();
			if(startTime==0l)		startTime = System.currentTimeMillis();
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of executeOOP();
	
	/**
	 * TR을 생성해서 전송한다.
	 * @param trname
	 */
	public void executeCertTR(String trname){
		try{
			TRAExecuter executer = new TRAExecuter(this.req, trname);
			trs.put(trname, executer);
			executer.executeCertTR();
			if(startTime==0l)		startTime = System.currentTimeMillis();
		}catch(Exception e){
			e.printStackTrace();
		}
	}//end of executeTR();

	/**
	 * TR 처리 완료 여부를 return한다.
	 * @return TR 처리가 완료되면 true, 완료되지 않으면 false를 return한다.
	 */
	public boolean completeExecuter() throws Exception{
		Enumeration<TransactionExecuter> e = trs.elements();
		boolean complete = true;
		while(e.hasMoreElements()){
			int status = e.nextElement().getStatus();
			switch(status){
				case RECEIVED :  complete = complete && true; 	break;
				case SENDED :
				case READY : 
					return false;
				case ERROR :  throw new ActionException("ERTR10", "TR처리 오류");
			}
		}
		return complete;
	}//end of completeTR();
	
	public void waitCompleted() throws Exception{
		while(!this.completeExecuter()){
			if(System.currentTimeMillis()-startTime>30000){
				throw new ActionException("ERTR11", "TR처리 지연");
			}
			try{
				Thread.sleep(100l);
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}//end of waitCompleted();
	
	/**
	 * 특정 TR이 처리가 되었는지 체크해서 대기한다.
	 * @param trname TR명
	 * @throws Exception
	 */
	public void waitTR(String trname) throws Exception{
		TransactionExecuter executer = trs.get(trname);
		if(executer==null)		return;
		while(executer.getStatus()!=RECEIVED){
			try{
				if(System.currentTimeMillis()-this.startTime>30000l){
					throw new ActionException("ERTR12", trname+" 처리 지연");
				}
				Thread.sleep(100l);
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}//end of waitTR();
	
	public TransactionExecuter getExecuter(String trname) throws Exception{
		try{
			this.waitCompleted();
			return trs.get(trname);
		}catch(Exception e){
			throw e;
		}
	}//end of getExecuter();
	
	public TRAExecuter getTR(String trname) throws Exception{
		return (TRAExecuter)this.getExecuter(trname);
	}//end of getTRAExecuter();

	public ChartAExecuter getChart(String trname) throws Exception{
		return (ChartAExecuter)this.getExecuter(trname);
	}//end of getChartAExecuter();

	public OOPAExecuter getOOP(String trname) throws Exception{
		return (OOPAExecuter)this.getExecuter(trname);
	}//end of getOOPAExecuter();

}//end of TRManager();
