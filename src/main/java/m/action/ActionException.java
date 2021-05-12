package m.action;

/**
 * 예외처리 핸들링 클래스
 * @author 김대원
 *
 */
public class ActionException extends Exception{
	
	private static final long serialVersionUID = -2223122117205300130L;

	public ActionException(final String errCode, final String errMsg){
		super(errCode + errMsg);
	}
}
