package com.vn.app.commons.util;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

public class GETIP {
	
	
	public static void main(String[] args) throws SocketException {
	
		String ip	=	"";
			boolean	isLoopBack	=	true;
			Enumeration<NetworkInterface>	en;
			en	=	NetworkInterface.getNetworkInterfaces();
			
			while(en.hasMoreElements()) {
				NetworkInterface ni	=	en.nextElement();
				if(ni.isLoopback())
					continue;
				
				Enumeration<InetAddress> inetAddresses	=	ni.getInetAddresses();
				while(inetAddresses.hasMoreElements()) {
					InetAddress ia	=	inetAddresses.nextElement();
					if(ia.getHostAddress() != null && ia.getHostAddress().indexOf(".") != -1) {
						ip	=	ia.getHostAddress();
						isLoopBack	=	false;
						break;
					}
				}
				if(!isLoopBack)
					break;
			}
			//System.out.println("IP==>"+ ip);
			
	}
}