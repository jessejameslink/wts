<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>List and Basic Information | MIRAE ASSET</title>
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
                    <a href="h06_margin_guideline.jsp" class="on">Margin trading</a>
                    <ul class="lnb_sub">
                        <li><a href="h06_margin_guideline.jsp">Guideline</a></li>
                        <li><a href="h06_margin_list.jsp" class="on">List and Basic Information</a></li>
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
            <h3 class="cont_title">List and Basic Information</h3>

            <div class="mg_info">
                <h4>1. Margin loan term</h4>
                <table>
                    <caption>margin loan term</caption>
                    <colgroup>
                        <col width="210" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Maximum term for a loan</th>
                            <td>03 months</td>
                        </tr>
                        <tr>
                            <th scope="row">Loan term extension</th>
                            <td>maximum one more 03 months</td>
                        </tr>
                    </tbody>
                </table>

                <h4>2. Interest rate for Margin trading service</h4>
                <div class="box">
                    <ul class="info_list">
                        <li>
                            <span class="title">Preferential interest rate for the first<br />5 months from the margin contract date</span>
                            <span class="desc">
                                <span>9.99% / year</span>
                            </span>
                        </li>
                        <li>
                            <span class="title">Normal interest rate</span>
                            <span class="desc">
                                <span>14% / year</span>
                            </span>
                        </li>
                        <li>
                            <span class="title">Overdue interest rate</span>
                            <span class="desc">
                                <span>150% normal interest rate</span>
                            </span>
                        </li>
                    </ul>
                </div>

                <h4>3.  Margin call notice method</h4>
                <p>Send SMS or directly call the registered telephone number in Margin trading contract.</p>

                <h4>4.  Marginable portfolio</h4>
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