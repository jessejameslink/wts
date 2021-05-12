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
		document.title = "MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "CASH/STOCK SERVICES" : "DỊCH VỤ CHUYỂN TIỀN/CK") %>";
		$("div[name=tabs]").tabs({active : ("<%= session.getAttribute("TAB_IDX1") %>" == "null" ? 0 : "<%= session.getAttribute("TAB_IDX1") %>")});
	});
</script>
</head>
<body class="mdi">
	<div class="mdi_container">
		<!-- tabs -->
		<div name="tabs">
			<ul class="nav nav_tabs " role="tablist">
				<li role="presentation"><a href="/banking/view/cashTransfer.do" aria-controls="tab1" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Cash Transfer to Bank" : "Chuyển tiền ra Ngân hàng") %></a></li>
				<li role="presentation"><a href="/banking/view/cashTransferInternal.do" aria-controls="tab1" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Internal Cash Transfer" : "Chuyển tiền Nội bộ") %></a></li>
				<li role="presentation"><a href="/banking/view/stockTransferInternal.do" aria-controls="tab1" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Internal Stock Transfer" : "Chuyển Chứng Khoán Nội bộ") %></a></li>
				<!--  
				<li role="presentation"><a href="/banking/view/cashDepositOnilne.do" aria-controls="tab2" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Cash Deposit Online" : "Nộp tiền trực tuyến") %></a></li>
				-->
			</ul>
		</div>
		<div id="divIdAuthCashTransfer" class="modal_wrap"></div>
	</div>
  </body>
</html>