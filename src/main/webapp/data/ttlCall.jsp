<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="utf-8"%>
<%@ page import="com.itrade.client.TTLLogin"%>

<%
TTLLogin outResult = new TTLLogin();
String chk = request.getParameter("chk");

if("stockInfo".equals(chk)){
	out.print(outResult.stockInfo(request));
} else if("orderList".equals(chk)){
	out.println(outResult.callEnquiryOrder(request));
} else if("getMarketData".equals(chk)){
	out.println(outResult.getMarketData(request));
} else if("stockSearch".equals(chk)){
	out.println(outResult.stockSearch(request));
} else if("stockStatusUpdate".equals(chk)){
	out.println(outResult.stockInfo(request));
} else if("enterOrder".equals(chk)){
	out.println(outResult.enterOrder(request));
} else if("CancelOrder".equals(chk)){
	out.println(outResult.cancelOrder(request));
} else if("ModifyOrder".equals(chk)){
	out.println(outResult.ModifyOrder(request));
} else if("ttlcommet".equals(chk)){
	out.println(outResult.ttlcomet(request));
} else if("accountbalance".equals(chk)){
	out.println(outResult.accountbalance(request));
} else if("checkSession".equals(chk)){
	out.println(outResult.checkSession(request));
} else if("ordercheck".equals(chk)){
	out.println(outResult.ttlcomet(request));
} else if("ttlInit".equals(chk)){
	out.println(outResult.ttlcomet(request));
} else if("authCardMatrix".equals(chk)){
	out.println(outResult.authCardMatrix(request));
} else if("nowPricecheck".equals(chk)){
	out.println(outResult.ttlcomet(request));
} else if("stockInfoList".equals(chk)){
	out.println(outResult.stockInfo(request));
} else if("genmodifyOrder".equals(chk)){
	out.println(outResult.genmodifyOrder(request));
} else if("orderlistUpdate".equals(chk)){
	out.println(outResult.ttlcomet(request));
} else if("hksModifyOrder".equals(chk)){
	out.println(outResult.ModifyOrder(request));
} else if("changelanguage".equals(chk)){
	out.println(outResult.changelanguage(request));
} else if("unregister".equals(chk)){
	out.println(outResult.ttlcomet(request));
} else if("enterorderfail".equals(chk)){
	out.println(outResult.enterorderfail(request));
} else if("queryMarketStatusInfo".equals(chk)){
	out.println(outResult.queryMarketStatusInfo(request));
} else if("enquiryportfolio".equals(chk)){
	out.println(outResult.enquiryportfolio(request));
} else if("querySoldOrders".equals(chk)){
	out.println(outResult.querySoldOrders(request));
} else if("getCashAdvanceHistory".equals(chk)){
	out.println(outResult.getCashAdvanceHistory(request));
} else if("getLocalAdvanceCreation".equals(chk)){
	out.println(outResult.getLocalAdvanceCreation(request));
} else if("genenterorder".equals(chk)){
	out.println(outResult.getGenenterorder(request));
} else if("submitAdvancePaymentCreation".equals(chk)){
	out.println(outResult.submitAdvancePaymentCreation(request));
} else if("checkAdvancePaymentTime".equals(chk)){
	out.println(outResult.checkAdvancePaymentTime(request));
} else if("enquiryOddLot".equals(chk)){
	out.println(outResult.enquiryOddLot(request));
} else if("oddLotHistoryEnquiry".equals(chk)){
	out.println(outResult.oddLotHistoryEnquiry(request));
} else if("genfundtransfer".equals(chk)){
	out.println(outResult.genfundtransfer(request));
} else if("hksCashTransactionHistory".equals(chk)){
	out.println(outResult.hksCashTransactionHistory(request));
} else if("cancelFundTransfer".equals(chk)){
	out.println(outResult.cancelFundTransfer(request));
} else if("dofundtransfer".equals(chk)){
	out.println(outResult.dofundtransfer(request));
} else if("checkFundTransferTime".equals(chk)){
	out.println(outResult.checkFundTransferTime(request));
} else if("queryCashTranHistory".equals(chk)){
	out.println(outResult.queryCashTranHistory(request));
} else if("queryCashTranHisReport".equals(chk)){
	out.println(outResult.queryCashTranHisReport(request));
} else if("hksStockTransactionHistory".equals(chk)){
	out.println(outResult.hksStockTransactionHistory(request));
} else if("marginLoan".equals(chk)){
	out.println(outResult.marginLoan(request));
} else if("overduedebt".equals(chk)){
	out.println(outResult.overduedebt(request));
} else if("upcomingdebt".equals(chk)){
	out.println(outResult.upcomingdebt(request));
} else if("getEntitlementStockList".equals(chk)){
	out.println(outResult.getEntitlementStockList(request));
} else if("getAllRightList".equals(chk)){
	out.println(outResult.getAllRightList(request));
} else if("getAdditionIssueShareInfo".equals(chk)){
	out.println(outResult.getAdditionIssueShareInfo(request));
} else if("getEntitlementHistory".equals(chk)){
	out.println(outResult.getEntitlementHistory(request));
} else if("avaiablemarginlist".equals(chk)){
	out.println(outResult.avaiablemarginlist(request));
} else if("queryBankInfo".equals(chk)){
	out.println(outResult.queryBankInfo(request));
} else if("getAnnouncement".equals(chk)){
	out.println(outResult.getAnnouncement(request));
} else if("getLocalLoanRefundCreation".equals(chk)){
	out.println(outResult.getLocalLoanRefundCreation(request));
} else if("getLoanRefundData".equals(chk)){
	out.println(outResult.getLoanRefundData(request));
} else if("getLoanRefundHistory".equals(chk)){
	out.println(outResult.getLoanRefundHistory(request));
} else if("checkLoanRefundTime".equals(chk)){
	out.println(outResult.checkLoanRefundTime(request)); 
} else if("submitLoanRefundCreation".equals(chk)){
	out.println(outResult.submitLoanRefundCreation(request));
} else if("changepassword".equals(chk)){
	out.println(outResult.changepassword(request));
} else if("changePin".equals(chk)){
	out.println(outResult.changePin(request));
} 


%>