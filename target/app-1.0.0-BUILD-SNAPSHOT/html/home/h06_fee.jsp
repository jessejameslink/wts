<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Fee table | MIRAE ASSET</title>
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
                <li><a href="h06_web.jsp">Web trading guideline</a></li>
                <li><a href="h06_mobile.jsp">Mobile trading guideline</a></li>
                <li><a href="h06_fee.jsp" class="on">Fee table</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Fee table</h3>

            <div class="fee">
                <h4 class="cont_subtitle">SECURITIES SERVICE FEE TABLE</h4>
                <h5 class="sml_title">Applied from May 01, 2016</h5>

                <h6 class="sec_title">I. SECURITIES TRANSACTION FEE</h6>
                <ul class="data_list type_01">
                    <li>
                        <span class="em">Transaction of stocks, fund certificates isted on HSX, HNX, UPCOM<br />(including both matching and put through transaction method)</span>

                        <div class="price_table">
                            <table>
                                <caption>Transaction</caption>
                                <colgroup>
                                    <col width="145">
                                    <col width="*">
                                    <col width="180">
                                    <col width="180">
                                </colgroup>
                                <thead class="multi_row">
                                    <tr>
                                        <th scope="col" rowspan="2">Clients</th>
                                        <th scope="col" rowspan="2">Total trading value</th>
                                        <th scope="col" colspan="2">Fee rate</th>
                                    </tr>
                                    <tr>
                                        <th scope="col">Floor / telephone trading</th>
                                        <th scope="col">Internet trading</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="left">Foreign clients</td>
                                        <td></td>
                                        <td class="center">0.40%</td>
                                        <td class="center">0.15%</td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="left">Domestic clients</td>
                                        <td class="left">Lower than 100 million VND</td>
                                        <td class="center">0.25%</td>
                                        <td class="center">0.15%</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Greater than or equal to 100 million VND</td>
                                        <td class="center">0.20%</td>
                                        <td class="center">0.15%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>
                    <li>
                        <span class="em">Transaction of bonds</span><br />
                        Negotiation fee (from 0.02% to 0.1% of total trading value)
                    </li>
                </ul>

                <h6 class="sec_title">II. FINANCIAL SERVICE FEE</h6>

                <div class="box">
                    <ul class="info_list">
                        <li>
                            <span class="title">Cash Advance Service</span>
                            <span class="desc">
                                <span>14% year</span>
                            </span>
                        </li>
                        <li>
                            <p class="title">Margin Service</p>
                            <p><span class="title bu01">Lending Interest Rate (*)</span></p>
                            <p>
                                <span class="title bu02">Promotion Interest Rate (the first 5 months)</span>
                                <span class="desc">
                                    <span>9.99% / year</span>
                                </span>
                            </p>
                            <p>
                                <span class="title bu02">Lending Interest Rate after promotion period</span>
                                <span class="desc">
                                    <span>14% / year</span>
                                </span>
                            </p>
                            <p>
                                <span class="title bu01">Overdue Interest Rate</span>
                                <span class="desc">
                                    <span>150% x (*)</span>
                                </span>
                            </p>
                        </li>
                    </ul>
                </div>

                <h6 class="sec_title">III. FEES COLLECTED BY VIETNAM SECURITIES DEPOSITORY (VSD)</h6>

                <ul class="data_list type_01">
                    <li>
                        <span class="em">Securities depository fee</span>

                        <table class="info_table">
                            <caption>margin loan term</caption>
                            <colgroup>
                                <col width="240">
                                <col width="*">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">For stocks, fund certificates</th>
                                    <td>VND 0.4 / stock, fund certificate/month</td>
                                </tr>
                                <tr>
                                    <th scope="row">For bonds</th>
                                    <td>VND 0.2 / bond / month</td>
                                </tr>
                            </tbody>
                        </table>
                    </li>
                    <li>
                        <span class="em">Securities transfer fee</span> due to account closure or upon investor’s request<br />
                        VND 0.5/securities/1 transfer time/1 ticker (not greater than VND 500,000/1 transfer time/1 ticker)
                    </li>
                    <li>
                        <span class="em">Securities ownership transfer fee not traded through Stock Exchanges</span><br />
                        As the rate of VSD at the time of the transaction execution
                    </li>
                </ul>

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