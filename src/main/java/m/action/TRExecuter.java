package m.action;

import m.action.executer.TR;
import m.web.common.WebInterface;
import m.json.JSONObject;

/**
 * TR 처리를 위한 class.
 * @author nhy67
 */
public class TRExecuter extends TR{
 
	public TRExecuter(WebInterface req, String trName) throws Exception {
		super(req, trName);
	}//end of ChartExecuter();
	
	public JSONObject execute() throws Exception{
		try{
			this.setStatus(TRManager.SENDED);
			JSONObject obj = this.send();
			this.setStatus(TRManager.RECEIVED);
			return obj;
		}catch(Exception e){
			this.setStatus(TRManager.ERROR);
			e.printStackTrace();
			throw e;
		}
	}//end of execute();
	
}//end of TRExecuter
