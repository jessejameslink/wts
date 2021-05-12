package m.security;

import m.common.tool.Base64;

/**
 * History
 * -2008. 03. 11, Create, 손님138, [Description] 
 */
public class SeedLog {
	private static String key = "miraevietnamenc";
	
	public String encrypt(byte[] input) {
		try{
			SeedCipher seed = new SeedCipher();
			String encryptText = Base64.encode(seed.encrypt(input, key.getBytes()));
			return encryptText;
		}catch(Exception e){
			e.printStackTrace();
			return "ORIGIN::"+Base64.encode(input);
		}
	}//end of encrypt();
	
	public byte[] decrypt(String encryptText) {
		try{
			SeedCipher seed = new SeedCipher();
			byte[] encryptbytes = Base64.decode(encryptText);
			return seed.decrypt(encryptbytes, key.getBytes());
		}catch(Exception e){
			e.printStackTrace();
			return ("ERROR"+encryptText).getBytes();
		}
	}//end of decrypt();
}//end of SeedLog