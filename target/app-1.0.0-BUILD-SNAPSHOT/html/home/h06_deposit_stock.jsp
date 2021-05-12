<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Deposit stock | MIRAE ASSET</title>
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
                <li><a href="h06_deposit_stock.jsp" class="on">Deposit stock</a></li>
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
                <li><a href="h06_web.jsp">Web trading guideline</a></li>
                <li><a href="h06_mobile.jsp">Mobile trading guideline</a></li>
                <li><a href="h06_fee.jsp">Fee table</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Deposit stock</h3>

            <ul class="step_list">
                <li>
                    <div class="step">
                        step<span>01</span>
                    </div>
                    <div class="body">
                        <p>Client opens a securities trading account if not having an account yet.</p>
                    </div>
                </li>
                <li>
                    <div class="step">
                        step<span>02</span>
                    </div>
                    <div class="body">
                        <p>Client fills in the securities depository form (3 copies) (attach pdf file),<br />accompanied the shareholder book/ certificate of shares ownership</p>
                    </div>
                </li>
                <li>
                    <div class="step">
                        step<span>03</span>
                    </div>
                    <div class="body">
                        <p>The Company checks information in the securities depository form and shareholder<br />book/ certificate of shares ownership and give back to client one copy</p>
                    </div>
                </li>
                <li>
                    <div class="step">
                        step<span>04</span>
                    </div>
                    <div class="body">
                        <p>The Company will send dossiers to VSD. After receiving the confirmation from VSD,<br />the Company will record  securities balance in the client’s account and notify to client.</p>
                    </div>
                </li>
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