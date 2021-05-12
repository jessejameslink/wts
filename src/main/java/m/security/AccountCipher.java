package m.security;

import m.common.tool.Base64;
import m.common.tool.tool;

/**
 * 계좌번호나 기타 데이터를 암/복화할때 사용한다.
 * Client로 전달되는 값 중에서 변조가 될 가능성이 있는 값에 대해서 암/복호화를 해야하고, 그럴때 이 class를 사용한다.
 * @author poemlife
 */
public class AccountCipher {

	private static final String KEY = "online"+tool.getToday()+"service";
	
	/**
	 * 주어진 String을 Seed 알고리즘을 사용하여 암호화한다.
	 * @param plainText 평문
	 * @return Base64 Encoding된 암호문
	 */
	public static String encrypt(String plainText){
		if(tool.isNull(plainText))		return new String();
		try{
			SeedCipher seed = new SeedCipher();
			//System.out.println("encrypt.plainText==["+plainText+"]");
			String encryptText = Base64.encode(seed.encrypt(plainText, KEY.getBytes()));
			//System.out.println("encrypt.encryptText==["+encryptText+"]");
			return encryptText;
		}catch(Exception e){
			e.printStackTrace();
			return "ORIGIN::"+Base64.encode(plainText.getBytes());
		}
	}//end of call_encrypt();
	
	/**
	 * 주어진 String을 Seed 알고리즘을 사용하여 복호화한다.
	 * @param encryptText Base64 Encoding된 암호문
	 * @return 평문
	 */
	public static String decrypt(String encryptText){
		if(tool.isNull(encryptText))		return new String();
		try{
			SeedCipher seed = new SeedCipher();
			byte[] encryptbytes = Base64.decode(encryptText);
			String decryptText = seed.decryptAsString(encryptbytes, KEY.getBytes());
			return decryptText;
		}catch(Exception e){
			e.printStackTrace();
			return "ORIGIN::"+encryptText;
		}
	}//end of call_decrypt();

	/**
	 * 원문과 암호문이 서로 같은 값인지를 검증한다
	 * @param plainText 평문
	 * @param encryptText Base64 Encoding된 암호문
	 * @return 동일한 값이면 true, 다른 값이면 false.
	 */
	public static boolean verify(String plainText, String encryptText){
		if(tool.isNull(plainText)||tool.isNull(encryptText))		return false;
		return encryptText.equals(encrypt(plainText));
	}//end of verify();
}//end of AccountCipher
