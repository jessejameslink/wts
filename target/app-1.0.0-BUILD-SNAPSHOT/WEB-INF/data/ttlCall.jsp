<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ page import="com.itrade.client.TTLLogin"%>


<%
TTLLogin outResult = new TTLLogin();
String chk = request.getParameter("chk");

if("stcokInfo".equals(chk)){
	out.print(outResult.stockInfo(request));
}else if("orderList".equals(chk)){
	out.println(outResult.callEnquiryOrder(request));
}else if("getMarketData".equals(chk)){
	out.println(outResult.getMarketData(request));
}else if("stockSearch".equals(chk)){
	out.println(outResult.stockSearch(request));
}else if("stockStatusUpdate".equals(chk)){
	out.println(outResult.stockInfo(request));
}else if("enterOrder".equals(chk)){
	out.println(outResult.enterOrder(request));
}else if("CancelOrder".equals(chk)){
	out.println(outResult.cancelOrder(request));
}else if("ModifyOrder".equals(chk)){
	out.println(outResult.ModifyOrder(request));
}else if("ttlcommet".equals(chk)){
	out.println(outResult.ttlcomet(request));
}else if("accountbalance".equals(chk)){
	out.println(outResult.accountbalance(request));
}else if("checkSession".equals(chk)){
	out.println(outResult.checkSession(request));
}else if("ordercheck".equals(chk)){
	out.println(outResult.ttlcomet(request));
}else if("ttlInit".equals(chk)){
	out.println(outResult.ttlcomet(request));
}else if("authCardMatrix".equals(chk)){
	out.println(outResult.authCardMatrix(request)); 
}else if("nowPricecheck".equals(chk)){
	out.println(outResult.ttlcomet(request)); 
}else if("stockInfoList".equals(chk)){
	out.println(outResult.stockInfo(request)); 
}else if("genmodifyOrder".equals(chk)){
	out.println(outResult.genmodifyOrder(request)); 
}else if("orderlistUpdate".equals(chk)){
	out.println(outResult.ttlcomet(request)); 
}else if("hksModifyOrder".equals(chk)){
	out.println(outResult.ModifyOrder(request)); 
}else if("changelanguage".equals(chk)){
	out.println(outResult.changelanguage(request)); 
}else if("unregister".equals(chk)){
	out.println(outResult.ttlcomet(request)); 
}else if("enterorderfail".equals(chk)){
	out.println(outResult.enterorderfail(request)); 
}else if("queryMarketStatusInfo".equals(chk)){
	out.println(outResult.queryMarketStatusInfo(request)); 
}else if("enquiryportfolio".equals(chk)){
	out.println(outResult.enquiryportfolio(request)); 
}            
 





%>