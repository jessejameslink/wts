<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>
<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<title>ACCOUNT MANAGEMENT</title>
<script>
	$(document).ready(function() {
		$("div[name=tabs]").tabs({active : ("<%= session.getAttribute("TAB_IDX1") %>" == "null" ? 0 : "<%= session.getAttribute("TAB_IDX1") %>")});
	});
</script>
</head>
<body class="mdi">
	<div class="mdi_container">
		<!-- tabs -->
		<div name="tabs">
			<ul class="nav nav_tabs " role="tablist">
				<li role="presentation"><a href="/market/view/marketOverview.do" aria-controls="tab1" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Market Overview" : "Tổng quan thị trường") %></a></li>
				<li role="presentation"><a href="/market/view/priceHistory.do" aria-controls="tab2" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Price history" : "Lịch sử giá") %></a></li>
				<li role="presentation"><a href="/market/view/tradingResults.do" aria-controls="tab3" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Trading results" : "Kết quả giao dịch") %></a></li>
				<li role="presentation"><a href="/market/view/foreignerTransaction.do" aria-controls="tab4" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Foreigner Transaction" : "Giao dịch Nhà đầu tư nước ngoài") %></a></li>
			</ul>
		</div>
	</div>
</body>
</html>