package m.action;

import m.json.JSONObject;

/**
 * TR 처리를 위한 interface.
 * @author 김대원
 */
public interface Executer{
	public JSONObject execute() throws Exception;
}//end of TRExecuter
