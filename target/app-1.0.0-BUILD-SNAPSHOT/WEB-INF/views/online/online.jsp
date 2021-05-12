<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "ONLINE SERVICES" : "DỊCH VỤ TRỰC TUYẾN") %>";
		$("div[name=tabs]").tabs({active : ("<%= session.getAttribute("TAB_IDX1") %>" == "null" ? 0 : "<%= session.getAttribute("TAB_IDX1") %>")});
		
		if ("<%=authenMethod%>" == "matrix") {
			$('#ui-id-13').remove();
		}		
	});

</script>
</head>
<body class="mdi">
	<div>
		<!-- 템플릿 사용부분 -->
		<div class="mdi_container">
			<!-- tabs -->
			<div name="tabs">
				<ul class="nav nav_tabs " role="tablist">					
					
					<li role="presentation"><a href="/online/view/cashAdvance.do" aria-controls="tab1" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Cash Advance" : "Ứng trước tiền bán chứng khoán") %></a></li>
					<li role="presentation"><a href="/online/view/cashAdvanceBank.do" aria-controls="tab2" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Cash Advance Bank" : "Ứng trước tiền bán chứng khoán (Ngân hàng)") %></a></li>
					<li role="presentation"><a href="/online/view/oddLotOrder.do" aria-controls="tab3" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Odd Lot Order" : "Giao dịch cổ phiếu lẻ") %></a></li>
					<li role="presentation"><a href="/online/view/entitlementOnline.do" aria-controls="tab4" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Entitlement Online" : "Thực hiện quyền online") %></a></li>
					<li role="presentation"><a href="/online/view/loanRefund.do" aria-controls="tab5" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Loan Refund" : "Hoàn trả vay ký quỹ") %></a></li>
					<li role="presentation"><a href="/online/view/onlineSignOrder.do" aria-controls="tab6" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "Online Order Confirmation" : "Ký nhận lệnh trực tuyến") %></a></li>
					<li role="presentation"><a href="/online/view/otpServices.do" aria-controls="tab7" role="tab" data-toggle="tab"><%= (langCd.equals("en_US") ? "OTP Services" : "Dịch vụ OTP") %></a></li>
				</ul>
			</div>
			
			<div id="divIdAuth" class="modal_wrap"></div>
			<div id="divIdOTP" class="modal_wrap"></div>
			<div id="divIdAuthCashAdv" class="modal_wrap"></div>
			<div id="divIdOTPCashAdv" class="modal_wrap"></div>
			<div id="divIdAuthCashAdvBank" class="modal_wrap"></div>
			<div id="divIdOTPCashAdvBank" class="modal_wrap"></div>
			<div id="divIdAuthEtitlement" class="modal_wrap"></div>
			<div id="divIdOTPEtitlement" class="modal_wrap"></div>
			<div id="divIdAuthLoanRefund" class="modal_wrap"></div>
			<div id="divIdOTPLoanRefund" class="modal_wrap"></div>
			<div id="divIdAuthOddLot" class="modal_wrap"></div>
			<div id="divIdOTPOddLot" class="modal_wrap"></div>
			<div id="divIdAuthSignOrder" class="modal_wrap"></div>
			<div id="divIdOTPSignOrder" class="modal_wrap"></div>
		</div>
		<!-- //템플릿 사용부분 -->
	</div>
</body>

</html>
