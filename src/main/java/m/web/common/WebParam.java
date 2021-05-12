package m.web.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import m.common.tool.tool;

/**
 * @author poemlife
 *
 */
public class WebParam extends WebInterface {

	public WebParam(HttpServletRequest req, HttpServletResponse res) {
		super(req, res);
		super.setType(JSP);		
	}//end of WebParam();

	/**
	 * key에 해당하는 parameter를 찾아서 return한다.
	 * @see m.web.common.WebInterface#getParameter(java.lang.String, java.lang.String)
	 */
	public String getParameter(String key, String defaultValue) {
		if(tool.isNull(key))		return defaultValue;
		String value = req.getParameter(key);
		if(value==null)				return defaultValue;
		else						return value;
	}//end of getParameter();

	/**
	 * Parameter를 String Array type으로 return한다.
	 * @see m.web.common.WebInterface#getParameterValues(java.lang.String, java.lang.String[])
	 */
	public String[] getParameterValues(String key, String[] defaultValue) {
		if(tool.isNull(key))		return defaultValue;
		String[] value = req.getParameterValues(key);
		if(value==null)				return defaultValue;
		else						return value;
	}//end of getParameterValues();

}//end of WebParam
