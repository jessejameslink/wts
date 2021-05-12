package m.security;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import m.common.tool.Base64;

/**
 * 박성우 사용
 * 
 * 2011. 05. 17, 김종명 개발(정석영 작업본 카피) 
 */

public class SecureData {
	
	private static String key;
	
	/**
	 * 암/복호화를 위한 키를 읽어온다.
	 * @param cfg
	 * @param index
	 */
	public static void readKey(String cfg, int index){
		Properties userProperties = new Properties();
		try {
			userProperties.load(new FileInputStream(new File(cfg)));
			key = userProperties.getProperty("key"+index).trim();	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}//end of readKey();
	
	/**
	 * 암/복호화를 위한 키를 읽어온다.
	 */
	public static void readKey(int index){
		readKey("/actus/mirae/cfg/seed.key", index);
	}//end of readKey();

	/**
	 * 암/복호화를 위한 키를 읽어온다.
	 */
	public static void readKey(){
		readKey(0);
	}//end of readKey();
	
	public static String encrypt(int index, String text){
		try{
			SeedCipher seed = new SeedCipher();
			String encryptText = Base64.encode(seed.encrypt(text, key.getBytes(), "UTF-8"));
			return encryptText;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}//end of encrypt();
	
	public static String decrypt(int index, String encryptText){
		try{
			SeedCipher seed = new SeedCipher();
			byte[] encryptbytes = Base64.decode(encryptText);
			String decryptText = seed.decryptAsString(encryptbytes, key.getBytes(), "UTF-8");
			return decryptText;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}//end of decrypt();
	
	public static void main(String[] args){
		readKey(0);
		readKey(1);
	}//end of main();
}//end of SecureData
