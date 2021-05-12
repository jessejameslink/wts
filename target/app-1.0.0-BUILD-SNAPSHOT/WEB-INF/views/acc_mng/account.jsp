<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "ACCOUNT MANAGEMENT" : "QUẢN LÝ TÀI KHOẢN") %>";
		$("div[name=tabs]").tabs({active : ("<%= session.getAttribute("TAB_IDX1") %>" == "null" ? 0 : "<%= session.getAttribute("TAB_IDX1") %>")});
	});
</script>
</head>
<body class="mdi">
	<div class="mdi_container">
		<!-- tabs -->
		<div name="tabs">
			<ul class="nav nav_tabs " role="tablist">
				<li role="presentation"><a href="/accInfo/accInfo.do" aria-controls="tab1" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Account Information" : "Thông tin tài khoản") %></a></li>
				<li role="presentation"><a href="/accInfo/ordHist.do" aria-controls="tab2" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Order History" : "Lịch sử đặt lệnh") %></a></li>
				<li role="presentation"><a href="/accInfo/view/assetMargin.do" aria-controls="tab3" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Asset / Margin Information" : "Thông tin tài sản / ký quỹ") %></a></li>
				<li role="presentation"><a href="/accInfo/view/cashTransactionHistory.do" aria-controls="tab4" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Cash Transaction History" : "Tra cứu lịch sử giao dịch tiền") %></a></li>
				<li role="presentation"><a href="/accInfo/view/cashStatements.do" aria-controls="tab5" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Cash Statements" : "Sao kê tài khoản tiền") %></a></li>
				<li role="presentation"><a href="/accInfo/view/stockStatements.do" aria-controls="tab6" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Stock Statements" : "Sao kê tài khoản chứng khoán") %></a></li>
				<li role="presentation"><a href="/accInfo/view/marginLoanStatements.do" aria-controls="tab7" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Margin Loan Statements" : "Sao kê nợ ký quỹ") %></a></li>
				<li role="presentation"><a href="/accInfo/view/marginLoanHistory.do" aria-controls="tab8" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Margin Loan" : "Dư nợ ký quỹ") %></a></li>
			</ul>
		</div>
	</div>
</body>
</html>