package m.format;

/**
 * Data 조회를 하기 위한 request/response의 기본 단위. 
 * @author nhy67
 */
public interface Definition {
	/**
	 * 이 Data Type이 DB인지, TR인지를 return한다.
	 * Transaction class에서는 TRANSACTION을, Database class에서는 DATABASE를 무조건 return한다.
	 * @return
	 */
	public int getDataType();
}//end of Definition