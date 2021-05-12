package m.security;

public class StringKey {
	private static String key = "orderlogcert";
	private static String iv = "onlineservice";
	
	public static String getKey(){
		return key;
	}//end of getKey();
	
	public static String getIV(){
		return iv;
	}//end of getIV();
}//end of StringKey
