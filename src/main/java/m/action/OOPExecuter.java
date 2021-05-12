package m.action;

import m.action.executer.OOP;
import m.web.common.WebInterface;
import m.json.JSONObject;

/**
 * OOP 처리를 위한 class.
 * @author poemlife
 */
public class OOPExecuter extends OOP{

	public OOPExecuter(WebInterface req, String trName) throws Exception {
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

}//end of OOPExecuter
