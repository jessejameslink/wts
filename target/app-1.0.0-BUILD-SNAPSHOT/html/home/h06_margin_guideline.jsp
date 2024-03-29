<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Guideline | MIRAE ASSET</title>
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
                        <li><a href="h06_margin_guideline.jsp" class="on">Guideline</a></li>
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
            <h3 class="cont_title">Guideline</h3>

            <div class="tab_container mg">
                <div class="tab">
                    <div>
                        <a href="#registration" class="on">Registration of<br />Margin trading service</a>
                        <a href="#process">Process for<br />registration of online<br />Margin trading service</a>
                        <a href="#notice">Notice on<br />Margin trading service</a>
                        <a href="#cease">Cease the<br />Margin trading service</a>
                    </div>
                </div>

                <div class="tab_conts">
                    <div id="registration" class="on">
                        <h4 class="hidden">Registration of Margin trading service</h4>
                        <p>The Clients sign the  “Contract for opening Margin trading account”  (“Contract”)<br />with the Company at our Head office or Hanoi branch.</p>
                    </div>
                    <!-- // #registration -->

                    <div id="process">
                        <h4 class="hidden">Process for registration of online Margin trading service</h4>
                        <p
                        >Process for registration of online Margin trading service includes the following steps :</p>

                        <ul class="step_list">
                            <li>
                                <div class="step">
                                    step<span>01</span>
                                </div>
                                <div class="body">
                                    <p>Sign an Appendix “Agreement for using utilities” with the Company.</p>
                                    <p class="mg_note">
                                        <em>Notes</em><br />
                                        * This step is not applied to Clients already registered online trading service
                                    </p>
                                </div>
                            </li>
                            <li>
                                <div class="step">
                                    step<span>02</span>
                                </div>
                                <div class="body">
                                    <p>
                                        Login into account on <em><a href="http://www.masvn.com">www.masvn.com</a></em> at “WEB TRADING” with provided user name and password. In order to ensure online trading safety, Customers are recommended to create new password after the first login time.
                                    </p>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <!-- // #process -->

                    <div id="notice">
                        <h4 class="hidden">Notice on Margin trading service</h4>

                        <h5 class="em">Conditions for purchasing on margin</h5>
                        <ul class="data_list type_01">
                            <li>Customers have to complete margin trading registration.</li>
                            <li>Securities purchased on margin must be in the Marginable portfolio announced by the Company from time to time.</li>
                            <li>Purchase value must not exceed the credit limit allowable for each customer in accordance with the Company regulations from time to time.</li>
                        </ul>

                        <h5 class="em">Margin loan refund before maturity</h5>
                        <p>Customer can choose the loan refund method : automatic loan refund or loan refund on demand</p>
                        <ul class="data_list type_01">
                            <li>
                                Automatic loan refund :
                                <p>The system will automatically collect a part or whole of the loan if at the end of the trading day, customer’s account has unspent cash balances (please contact our hotline (+84) 8 3910 2222 / (+84) 4 6273 0541 for registration)</p>
                            </li>
                            <li>
                                Loan refund on demand :
                                <p>If cash is available in account and Customers want to refund a part or entire margin loan, Customers fill in “Request on early loan refund” and submit directly at the counter or login online trading account, access Other service/Loan refund and input the specific amount refund.</p>
                            </li>
                        </ul>

                        <h5 class="em">Margin call notice</h5>
                        <ul class="data_list type_01">
                            <li>In case maintenance ratio is less than the required maintenance ratio due to devaluation of collateral asset caused by securities in customer’s margin trading account removed from marginable securities portfolio pursuant to the Company’s regulation, Customer is requested for additional collateral within T+5 working days, so that maintenance ratio turns back to safe level;</li>
                            <li>In case maintenance ratio is less than the required maintenance ratio due to other reasons (devaluation of collateral asset caused by market supply and demand, in ex-right date, …), Customer is requested for additional collateral within T+2 working days, so that maintenance ratio turns back to safe level;</li>
                            <li>In case loans expire and customer doesn’t refund: Customer is requested to fulfill loan payment obligation within T+7 working days; or pursuant to specified supplementary term if maintenance ratio is less than the required maintenance ratio of the portfolio.</li>
                        </ul>

                        <h5 class="em">Margin call notice method</h5>
                        <ul class="data_list type_01">
                            <li>The Company will inform Margin call notice to Customers via telephone or SMS or other methods as specified in the margin trading contract.</li>
                        </ul>

                        <h5 class="em">Supplementary method </h5>
                        <ul class="data_list type_01">
                            <li>Customers supplement assets by selling securities to ensure maintenance ratio equal or greater than the required maintenance ratio.</li>
                            <li>Customers supplement money by cash deposit or by transfer into the Margin account so as to ensure maintenance ratio equal or greater than the required maintenance ratio.</li>
                        </ul>

                        <h5 class="em">Reference price of securities at the ex-right date</h5>
                        <ul class="data_list type_01">
                            <li>The reference price will be automatically decreased (if any) at the ex-rights date in accordance with the regulations of the Stock Exchanges.</li>
                        </ul>

                        <h5 class="em">Securities in a state of delisted, suspended, alerted or special controlled</h5>
                        <ul class="data_list type_01">
                            <li>When securities are delisted, suspended, alerted or special controlled, maintenance ratio and lending ratio of those securities will be adjusted to 0 (zero) right upon the official information from the Stock Exchanges.</li>
                        </ul>

                        <h5 class="em">Securities removed from marginable portfolio announced by the Company</h5>
                        <ul class="data_list type_01">
                            <li>After the Company announces to remove securities from marginable portfolio, the maintenance ratio and lending ratio of those securities will be adjusted to 0 (zero) immediately.</li>
                            <li>Customers should actively follow up and manage portfolio to avoid ability of margin call.</li>
                        </ul>

                        <h5 class="em">Loan term extension</h5>
                        <ul class="data_list type_01">
                            <li>In principle, the term of the loan is 03 months from the date of disbursement of the loan. Customer needs to repay the loan, interest and other related costs (if any) at the maturity date of the loan.</li>
                            <li>Customer can request to extend the loan term but not exceed one more period of 03 months based on customer’s extension request.</li>
                        </ul>

                    </div>
                    <!-- // #notice -->

                    <div id="cease">
                        <h4 class="hidden">Cease the Margin trading service</h4>

                        <p class="em">Cease the margin trading service</p>

                        <ul class="step_list">
                            <li>
                                <div class="step">
                                    step<span>01</span>
                                </div>
                                <div class="body">
                                    <p>Customers are required to contact with the broker or operator at the transaction office so as to fulfill obligations relating the Contract.</p>
                                </div>
                            </li>
                            <li>
                                <div class="step">
                                    step<span>02</span>
                                </div>
                                <div class="body">
                                    <p>Based on confirmation on fulfillment of obligations as specified in the Contract, Customers sign onto “Request to close Margin trading account”</p>
                                </div>
                            </li>
                            <li>
                                <div class="step">
                                    step<span>03</span>
                                </div>
                                <div class="body">
                                    <p>The Company confirms to cease providing margin trading service with Customers.</p>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <!-- // #cease -->
                </div>
            </div>
            <!-- // .tab_container -->

        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>