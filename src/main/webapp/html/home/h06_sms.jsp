<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>SMS | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/US/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Support</h2>
            <ul>
                <li><a href="h06_account.jsp">Open cash account in ACB</a></li>
                <li><a href="h06_deposit_cash.jsp">Deposit cash</a></li>
                <li><a href="h06_deposit_stock.jsp">Deposit stock</a></li>
                <li><a href="h06_cash_advance.jsp">Cash advance</a></li>
                <li><a href="h06_cash_transfer.jsp">Cash transfer</a></li>
                <li>
                    <a href="h06_margin_guideline.jsp">Margin trading</a>
                    <ul class="lnb_sub">
                        <li><a href="h06_margin_guideline.jsp">Guideline</a></li>
                        <li><a href="h06_margin_list.jsp">List and Basic Information</a></li>
                    </ul>
                </li>
                <li><a href="h06_sms.jsp" class="on">SMS</a></li>
                <li><a href="h06_securities.jsp">Securities Trading Regulation</a></li>
                <li><a href="h06_web.jsp">Web trading guideline</a></li>
                <li><a href="h06_mobile.jsp">Mobile trading guideline</a></li>
                <li><a href="h06_fee.jsp">Fee table</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">SMS</h3>

            <h4 class="cont_subtitle">Registration / Cancellation of SMS service</h4>
            <p>Sign Agreement to register or cancel SMS service at the Company’s offices</p>

            <h4 class="cont_subtitle">Receive automatically messages sent to the registered mobile number</h4>

            <ul class="data_list type_01">
                <li>Matching result messages</li>
                <li>Notice and/or advertisement messages</li>
                <li>Other messages</li>
            </ul>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>