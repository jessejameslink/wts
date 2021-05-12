package com.vn.app.commons.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.commons.codec.binary.Base64;

//http://pandorica.tistory.com/4
@SuppressWarnings("restriction")
public class DecodeFileUtil {
	public void decodeStringtoFile(String encodesString, String outputFileName)
            throws IOException {
/*	DELETE
    	BASE64Decoder base64Decoder = new BASE64Decoder();
        InputStream inStream = new ByteArrayInputStream(encodesString.toString().getBytes("UTF-8"));
        BufferedOutputStream outStream = new BufferedOutputStream(new FileOutputStream(outputFileName));
        
        base64Decoder.decodeBuffer(inStream, outStream);      
        inStream.close();
        outStream.close();
*/
		
/*	DELETE
		// Code
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] decodedBytes = decoder.decodeBuffer(encodesString);
		File file = new File(outputFileName);;
		FileOutputStream fop = new FileOutputStream(file);
		fop.write(decodedBytes);
		fop.flush();
		fop.close();
*/
		//System.out.println("FILE WRITE START");
		byte[] decoded = Base64.decodeBase64(encodesString);
		File file = new File(outputFileName);;
		FileOutputStream fop = new FileOutputStream(file);
		
		try {
			fop.write(decoded);
			//System.out.println("FILE WRITE END");
			fop.flush();
			fop.close();
		} catch (Exception e) {
			//System.out.println("#FILE WRITE ERROR#");
			e.getMessage();
			//System.out.println(e);
			fop.flush();
			fop.close();
		} finally {
			fop.flush();
			fop.close();
		}

    }
}