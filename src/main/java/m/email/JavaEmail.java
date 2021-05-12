package m.email;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import m.config.SystemConfig;

public class JavaEmail {

	Properties emailProperties;
	Session mailSession;
	MimeMessage emailMessage;

	/*
	String emailHost = "oex.miraeasset.com";
	String emailPort = "25";// gmail's smtp port
	String emailFrom = "contact@miraeasset.com";
	String fromUser = "9108059";
	String fromUserEmailPassword = "pw1@mirae";
	
	*/
	String emailHost = "10.0.16.18";
	String emailPort = "587";
	String emailFrom = "openaccount@miraeasset.com.vn";
	String emailTo = "cs@miraeasset.com.vn";
	String fromUser = "openaccount";
	String fromUserEmailPassword = "p@ssw0rd";
	
	String[] toEmails = { "contact@miraeasset.com.vn", "minh.nk@miraeasset.com.vn", "dongwon.lee@miraeasset.com.vn" };
	String[] toVacancyEmails = { "hr@miraeasset.com.vn", "minh.nk@miraeasset.com.vn", "dongwon.lee@miraeasset.com.vn" };

	public void setMailServerProperties() {
		emailProperties = System.getProperties();
		emailProperties.put("mail.smtp.host", emailHost);
		emailProperties.put("mail.smtp.port", emailPort);
		emailProperties.put("mail.transport.protocol", "smtp");
		emailProperties.put("mail.smtp.auth", "true");
		emailProperties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		emailProperties.put("mail.smtp.starttls.enable", "false");
	}

	public void createEmailMessage(String emailSubject, String emailBody)
			throws AddressException, MessagingException {
		mailSession = Session.getDefaultInstance(emailProperties, null);
		mailSession.setDebug(true);
		emailMessage = new MimeMessage(mailSession);
		InternetAddress from = new InternetAddress(emailFrom);
		try {
			from.setPersonal("Mirae Asset Securities");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        emailMessage.setFrom(from);
        
		for (int i = 0; i < toEmails.length; i++) {
			emailMessage.addRecipient(Message.RecipientType.TO,
					new InternetAddress(toEmails[i]));
		}
		emailMessage.setSubject(emailSubject);
		emailMessage.setContent(emailBody, "text/html; charset=UTF-8");

	}
	
	public void createResetPwdEmailMessage(String emailSubject, String emailBody, String frTo)
			throws AddressException, MessagingException {
		mailSession = Session.getDefaultInstance(emailProperties, null);
		mailSession.setDebug(true);
		emailMessage = new MimeMessage(mailSession);
		InternetAddress from = new InternetAddress(emailFrom);
		try {
			from.setPersonal("Mirae Asset Securities");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        emailMessage.setFrom(from);
        emailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(frTo));
		
		emailMessage.setSubject(emailSubject);
		emailMessage.setContent(emailBody, "text/html; charset=UTF-8");

	}
	
	public void createVacancyEmailMessage(String emailSubject, String emailBody, String filename1, String filename2) throws AddressException, MessagingException {
		mailSession = Session.getDefaultInstance(emailProperties, null);
		mailSession.setDebug(true);
		emailMessage = new MimeMessage(mailSession);
		InternetAddress from = new InternetAddress(emailFrom);
		try {
			from.setPersonal("Mirae Asset Securities");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        emailMessage.setFrom(from);
        
		for (int i = 0; i < toVacancyEmails.length; i++) {
			emailMessage.addRecipient(Message.RecipientType.TO,
					new InternetAddress(toVacancyEmails[i]));
		}
		emailMessage.setSubject(emailSubject);
		
		// Create the message part
        BodyPart messageBodyPart = new MimeBodyPart();

        // Now set the actual message
        messageBodyPart.setContent(emailBody, "text/html; charset=UTF-8");

        // Create a multipart message
        Multipart multipart = new MimeMultipart();

        // Set text message part
        multipart.addBodyPart(messageBodyPart);
        
        if (!filename1.equals("")) {
        	addAttachment(multipart, filename1);
        }
        if (!filename2.equals("")) {        
        	addAttachment(multipart, filename2);
        }
        
     // Send the complete message parts
        emailMessage.setContent(multipart);
	}
	
	public void createOpenOnlineEmailMessage(String emailSubject, String emailBody, String filename1, String filecontent) throws AddressException, MessagingException {
		mailSession = Session.getDefaultInstance(emailProperties, null);
		//mailSession.setDebug(true);
		emailMessage = new MimeMessage(mailSession);
		InternetAddress from = new InternetAddress(emailFrom);
		try {
			from.setPersonal("Open Account");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        emailMessage.setFrom(from);        
        emailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(emailTo));        
		emailMessage.setSubject(emailSubject);
		
		// Create the message part
        BodyPart messageBodyPart = new MimeBodyPart();

        // Now set the actual message
        messageBodyPart.setContent(emailBody, "text/html; charset=UTF-8");

        // Create a multipart message
        Multipart multipart = new MimeMultipart();

        // Set text message part
        multipart.addBodyPart(messageBodyPart);
        
        if (!filename1.equals("")) {
        	addAttachment2(multipart, filename1, filecontent);
        }
        
        // Send the complete message parts
        emailMessage.setContent(multipart);
	}
	
	public void addAttachment(Multipart multipart, String filename) throws AddressException, MessagingException{
		DataSource source = new FileDataSource(filename);
	    BodyPart messageBodyPart = new MimeBodyPart();
	    messageBodyPart.setDataHandler(new DataHandler(source));
	    messageBodyPart.setFileName(filename);       
	    multipart.addBodyPart(messageBodyPart);
	}
	
	public void addAttachment2(Multipart multipart, String filename, String fileContent) throws AddressException, MessagingException{
		
		String[] strings = fileContent.split(",");
		byte[] data = Base64.getDecoder().decode(strings[1]);
		
		String fullPath = "c:/Temp/" + filename;
		//String filePathServer = "/opt/apache-tomcat-8.0.38/webapps/docs/cmnd/" + filename;
		
		String filepath = SystemConfig.get("EMAIL_PATH");
		//System.out.println("EMAIL_PATH");
		//System.out.println(filepath);
		
		File theDir = new File(filepath);

		// if the directory does not exist, create it
		if (!theDir.exists()) {
		    //System.out.println("creating directory: " + theDir.getName());
		    boolean result = false;

		    try{
		        theDir.mkdir();
		        result = true;
		    } 
		    catch(SecurityException se){
		        //handle it
		    }        
		    if(result) {    
		        //System.out.println("DIR created");  
		    }
		}
		
		String filePathServer = filepath + filename;
		
		
		String useFilePath = "";

		try( OutputStream stream = new FileOutputStream(filePathServer) ) 
		{
		   stream.write(data);
		   useFilePath = filePathServer;
		}
		catch (Exception e) 
		{
		   System.err.println("Couldn't write to file server...");
		   try( OutputStream stream = new FileOutputStream(fullPath) ) 
			{
			   stream.write(data);
			   useFilePath = fullPath;
			}
			catch (Exception ex) 
			{
			   System.err.println("Couldn't write to file local...");
			}
		}
		
		DataSource source = new FileDataSource(useFilePath);
	    BodyPart messageBodyPart = new MimeBodyPart();
	    messageBodyPart.setDataHandler(new DataHandler(source));
	    messageBodyPart.setFileName(filename);       
	    multipart.addBodyPart(messageBodyPart);
	}

	public void sendEmail() throws AddressException, MessagingException {
		Transport transport = mailSession.getTransport("smtp");
		transport.connect(emailHost, fromUser, fromUserEmailPassword);		
		transport.sendMessage(emailMessage, emailMessage.getAllRecipients());
		transport.close();
	}
}