package m.security;

import m.common.tool.Base64;

import java.security.MessageDigest;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * This class converts a UTF-8 string into a cipher string, and vice versa.
 * It uses 128-bit AES Algorithm in Cipher Block Chaining (CBC) mode with a UTF-8 key
 * string and a UTF-8 initial vector string which are hashed by MD5. PKCS5Padding is used
 * as a padding mode and binary output is encoded by Base64.
 * 
 * @author JO Hyeong-ryeol
 */
public class StringEncrypter {
	private Cipher rijndael;
	private SecretKeySpec key;
	private IvParameterSpec initalVector;

	/**
	 * Creates a StringEncrypter instance.
	 * 
	 * @param key A key string which is converted into UTF-8 and hashed by MD5.
	 *            Null or an empty string is not allowed.
	 * @param initialVector An initial vector string which is converted into UTF-8
	 *                      and hashed by MD5. Null or an empty string is not allowed.
	 * @throws Exception
	 */
	public StringEncrypter(String key, String initialVector) throws Exception {
		if (key == null || key.equals(""))
			throw new Exception("The key can not be null or an empty string.");

		if (initialVector == null || initialVector.equals(""))
			throw new Exception("The initial vector can not be null or an empty string.");

		// Create a AES algorithm.
		this.rijndael = Cipher.getInstance("AES/CBC/PKCS5Padding");

		// Initialize an encryption key and an initial vector.
		MessageDigest md5 = MessageDigest.getInstance("MD5");
		this.key = new SecretKeySpec(md5.digest(key.getBytes("UTF8")), "AES");
		this.initalVector = new IvParameterSpec(md5.digest(initialVector.getBytes("UTF8")));
	}

	/**
	 * Encrypts a string.
	 * 
	 * @param value A string to encrypt. It is converted into UTF-8 before being encrypted.
	 *              Null is regarded as an empty string.
	 * @return An encrypted string.
	 * @throws Exception
	 */
	public String encrypt(String value){
		try{
			if (value == null)			value = "";
			// Initialize the cryptography algorithm.
			this.rijndael.init(Cipher.ENCRYPT_MODE, this.key, this.initalVector);
			// Get a UTF-8 byte array from a unicode string.
			byte[] utf8Value = value.getBytes("UTF8");
			// Encrypt the UTF-8 byte array.
			byte[] encryptedValue = this.rijndael.doFinal(utf8Value);
			// Return a base64 encoded string of the encrypted byte array.
			return Base64.encode(encryptedValue).replaceAll("\r", "").replaceAll("\n", "");
		}catch(Exception e){
			e.printStackTrace();
			return new String();
		}
	}//end of encrypter();

	public String encrypt(byte[] value) {
		try{
			if (value == null)			value = "".getBytes();
			// Initialize the cryptography algorithm.
			this.rijndael.init(Cipher.ENCRYPT_MODE, this.key, this.initalVector);
			byte[] encryptedValue = this.rijndael.doFinal(value);
			// Return a base64 encoded string of the encrypted byte array.
			return Base64.encode(encryptedValue).replaceAll("\r", "").replaceAll("\n", "");
		}catch(Exception e){
			e.printStackTrace();
			return new String();
		}
	}//end of encrypt();
	
	public static void main(String[] args){
		try{
			String key = "MIRAEASSET";
			String iv = "onlineservice";    
			// 인스턴스 만들기.
			StringEncrypter encrypter = new StringEncrypter(key, iv);
				
			// 문자열 암호화.
			//System.out.println(encrypter.encrypt("bnk_txt^박주연|hsm_yn^0|ac_seq^015879|oa_p_sum^5500|pd_cd^99|brch_cd^014|tr_use^05|tr_dtl_seq^0000000|oa_p^5500|bank_ac_no^175120066717|cs_hph_tel2^595|hp_chk_dv^0|conn_bnk_cd^032|oa_fee^0|srct_txt^|cs_hph_tel1^018|pwd^8122|inpt_bnk_acn^박주연|cs_hph_tel3^1953"));
			// 문자열 복호화.
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
