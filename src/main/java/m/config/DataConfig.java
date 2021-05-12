package m.config;

import java.util.HashSet;

import m.action.IConstants;
import m.data.hash;
import m.format.Transaction;
import m.web.common.WebInterface;

/**
 * 각 서버 및 컨넥터에 대한  정의 Class
 * DB, 원장(Host0, Host1, Host7), BP에 대한 비상여부 및 우회경로 설정.
 * 디폴트컨넥터에 대한 설정 (WEBT, BP, DISABLED)
 * host별 비상여부 및 우회경로 설정
 * @author nhy67
 */
public class DataConfig implements IConstants{

	
	private static hash<String> svr_state = new hash<String>();

	private static final HashSet<String> stat = new HashSet<String>();
	
	/**
	 * State를 Setting한다.
	 * @param host
	 * @param state
	 */
	public static final void setState(String host, int state){
		try{
			if(stat.contains(host)){
				if(state==NORMAL||state==BISANG||state==PASS){
					svr_state.put(host, String.valueOf(state));
				}
			}
		}catch(Exception e){
			
		}
	}//end of setState();
	
	/**
	 * TR의 조회 경로를 return한다.
	 * @param req
	 * @param definition
	 * @return
	 */
	public static final String getPath(WebInterface req, Transaction definition) throws Exception{
		if(definition==null)	return "HTSBP";
		if(definition.getHost()==' '){			//BP TR
			return getPathWithcheckBpState();
		}else if(definition.getHost()=='0'||definition.getHost()=='1'){		//정보계 및 업무계
			String state = svr_state.get(String.valueOf(definition.getHost())+req.getBranch());
			
			if(state.charAt(0)==NORMAL){
				return getPathWithCheckTR(definition, req.getBranch());
			}else if(state.charAt(0)==BISANG){
				state = svr_state.get(String.valueOf(definition.getHost())+req.getNextBranch());
				if(state.charAt(0)==NORMAL){
					return getPathWithCheckTR(definition, req.getNextBranch());
				}else{
					return "DISABLED";
				}
			}
		}else if(definition.getHost()=='2' || definition.getHost()=='5'){		//퇴직연금
			String state = svr_state.get(String.valueOf(definition.getHost())+req.getBranch());
			if(state.charAt(0)==NORMAL){
				return getPathWithCheckTR(definition, req.getBranch());
			}else if(state.charAt(0)==BISANG){
				state = svr_state.get(String.valueOf(definition.getHost())+req.getNextBranch());
				if(state.charAt(0)==NORMAL){
					return getPathWithCheckTR(definition, req.getNextBranch());
				}else{
					return "DISABLED";
				}
			}
			
			return getPathWithcheckBpState();
		}else if(definition.getHost()=='7'){		//상품정보 : WebT 사용 불가.(연결 안됨) 무조건 HTS BP  사용
			return getPathWithcheckBpState();
		}
		return "HTSBP";
	}//end of getPath();

	/**
	 * htsBp 상태체크후 path return
	 * @return
	 */
	public static final String getPathWithcheckBpState() throws Exception{
		String state = svr_state.get("HTSBP");
		if("BISANG".equals(state)){
			return "DISABLED";
		}
		return "HTSBP";
	}
	
	/**
	 * TR별 상태체크후 path return
	 * @param definition
	 * @param branch
	 * @return
	 */
	private static final String getPathWithCheckTR(Transaction definition, char branch) throws Exception{
		return "HTSBP";
	}
	
	static{
		stat.add("HTSBP");
		stat.add("01");
		stat.add("02");
		stat.add("11");
		stat.add("12");
		stat.add("21");
		stat.add("22");
		stat.add("51");
		stat.add("52");
		stat.add("7");
		stat.add("DB");
		svr_state.put("HTSBP", 	String.valueOf(NORMAL));
		svr_state.put("01", 	String.valueOf(NORMAL));
		svr_state.put("02", 	String.valueOf(NORMAL));
		svr_state.put("11", 	String.valueOf(NORMAL));
		svr_state.put("12", 	String.valueOf(NORMAL));
		svr_state.put("21", 	String.valueOf(NORMAL));
		svr_state.put("22", 	String.valueOf(NORMAL));
		svr_state.put("51", 	String.valueOf(NORMAL));
		svr_state.put("52", 	String.valueOf(NORMAL));
		svr_state.put("7", 		String.valueOf(NORMAL));
		svr_state.put("DB", 	String.valueOf(NORMAL));
	}

	public static void main(String[] args){
		char a = '1';
		//System.out.println((char)(a+2));
	}
	
}//end of DataConfig
