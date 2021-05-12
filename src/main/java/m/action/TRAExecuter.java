package m.action;

import m.action.executer.TR;
import m.web.common.WebInterface;

/**
 * TR 처리를 위한 class.
 * @author poemlife
 */
public class TRAExecuter extends TR implements Runnable{
	private Thread t;
	
	public TRAExecuter(WebInterface req, String trName) throws Exception {
		super(req, trName);
	}//end of ChartAExecuter();

	public void execute() {
		this.t = new Thread(this);
		t.start();
	}//end of execute();

	public final void run(){
		try{
			this.setStatus(TRManager.SENDED);
			this.send();
			this.setStatus(TRManager.RECEIVED);
		}catch(Exception e){
			this.setStatus(TRManager.ERROR);
			e.printStackTrace();
		}
	}//end of run();
}//end of TRExecuter
