<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Web trading guideline | MIRAE ASSET</title>
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
                <li><a href="h06_sms.jsp">SMS</a></li>
                <li><a href="h06_securities.jsp">Securities Trading Regulation</a></li>
                <li><a href="h06_web.jsp" class="on">Web trading guideline</a></li>
                <li><a href="h06_mobile.jsp">Mobile trading guideline</a></li>
                <li><a href="h06_fee.jsp">Fee table</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Web trading guideline</h3>

            <div class="trading_guide web">
                <div class="guideline">
                    <p>Web trading guideline</p>
                    <a href="">Download</a>
                </div>
                <div class="risk_info">
                    <p>Risk Information about<br />online trading</p>
                    <a href="">Download</a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>