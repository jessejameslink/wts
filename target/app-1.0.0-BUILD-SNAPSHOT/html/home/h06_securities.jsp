<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Securities Trading Regulation | MIRAE ASSET</title>
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
                <li><a href="h06_securities.jsp" class="on">Securities Trading Regulation</a></li>
                <li><a href="h06_web.jsp">Web trading guideline</a></li>
                <li><a href="h06_mobile.jsp">Mobile trading guideline</a></li>
                <li><a href="h06_fee.jsp">Fee table</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Securities Trading Regulation</h3>

            <div class="tab_container sec">
                <div class="tab">
                    <div>
                        <a href="#general" class="on">General<br />rules</a>
                        <a href="#hcm">Securities listed<br />on HSX<br />(Ho Chi Minh)</a>
                        <a href="#hni">Securities listed<br />on HNX<br />(Hanoi)</a>
                        <a href="#upcom">Securities<br />registered for<br />trading<br />on UPCOM</a>
                        <a href="#g_bond">Government<br />Bond listed<br />on HNX</a>
                        <a href="#g_foreign">Government<br />Bond in foreign<br />currencies listed<br />on HNX</a>
                    </div>
                </div>

                <div class="tab_conts">
                    <div id="general" class="on">
                        <h4 class="hidden">General rules</h4>

                        <h5 class="sec_title">1. Cash depository</h5>
                        <p>When buying securities, the investors must deposit 100% of the purchasing money plus the incurred fees.</p>

                        <h5 class="sec_title">2. Securities depository</h5>
                        <p>When selling securities, the investor’s the securities depository account opened at the Company must have enough number of securities you want to sell.</p>

                        <h5 class="sec_title">3. Trading method</h5>
                        <ul class="data_list type_01">
                            <li>Directly trading at floor</li>
                            <li>Trading by telephone : 08.39102222 / 04.62730541</li>
                            <li>Web trading : <em><a href="http://wts.masvn.com">wts.masvn.com</a></em></li>
                            <li>Mobile trading : mts.masvn.com</li>
                        </ul>

                        <h5 class="sec_title">4. Settlement period</h5>
                        <div class="price_table">
                            <table>
                                <caption>settlement period</caption>
                                <colgroup>
                                    <col width="50%" />
                                    <col width="50%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Securities type</th>
                                        <th scope="col">Settlement period</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="center">Stocks and fund certificates</td>
                                        <td class="center">T+2</td>
                                    </tr>
                                    <tr>
                                        <td class="center">Bonds</td>
                                        <td class="center">T+1</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">5. Trading of foreign investors :</h5>
                        <table class="table_style_01">
                            <caption>Trading of foreign investors : table</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">In the time of order<br />matching trading</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Buying volume of shares and closed fund certificates will be deducted from the number available for foreign investors immediately after the buy order is executed.</li>
                                            <li>Selling volume of shares and closed fund certificates of foreign investors will be added to the number available for foreign investors right after ending the settlement (T+2).</li>
                                            <li>Buy orders or the rest of partially-filled buy orders of foreign investors which are not executed will be automatically cancelled if ownership limit for foreigners is hit and buy orders inputted into the trading system will not be accepted.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">In the time of put<br />through trading</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Volume of shares and closed fund certificates available for foreign investors will be deducted immediately if transaction is executed between a buying foreign investor and a selling domestic investor.</li>
                                            <li>Volume of shares and closed fund certificates available for foreign investors will be increased after the end of settlement if transaction is executed between a selling foreign investor and a buying domestic investor.</li>
                                            <li>Total number of shares, closed fund certificates available for foreign investors will remain unchanged if the transaction is negotiated between two foreign investors.</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Other rules</h5>
                        <ul class="data_list type_01">
                            <li>
                                <span class="em">The investor may open only an account at a securities company and will be permitted to open accounts at many securities companies.</span>
                            </li>
                            <li>
                                <span class="em">The investor will be permitted to buy and sell the same type of securities on the same trading day on satisfying the following conditions :</span>
                                <ul class="data_list type_03">
                                    <li>The investor uses the same account opened at securities company to place both the buy and sell orders;</li>
                                    <li>The investor may only buy (or sell) the same type of securities when the previous sell (or buy) order of such type of securities has been executed and the trading order satisfies the escrow deposit requirement</li>
                                </ul>
                                </li>
                            <li>
                                <span class="em">Investors will not be permitted :</span>
                                <ul class="data_list type_03">
                                    <li>Conduct deals which do not result in change of ownership of securities;</li>
                                    <li>Simultaneously place buy and sell orders for the same type of securities on the same order matching session, on the same or different accounts in the name [ownership] of such investor.</li>
                                </ul>
                            </li>
                            <li>
                                <span class="em">During the break time :</span>
                                <p>Investors can place new orders for the afternoon trading session. These orders will be stored in the Company system and transferred to the trading system of the Stock Exchange as soon as the beginning of the afternoon trading session. Investors can cancel/modify above orders when these orders are not transferred to the trading system of the Stock Exchanges.</p>
                            <li>
                                <span class="em">Disclosure of information :</span>
                                <ul class="data_list type_03">
                                    <li>Organizations, individuals or a group of relevant people holding 5% or above of voting stocks/ fund certificates of a closed public funds or withdrawing from being major shareholders must report on ownership to the public company, the State Securities Commission (SSC) and the Stock Exchange (SE) (under the Annex VI promulgated together with Circular No. 155/2015/TT-BTC) within 07 days after becoming/ withdrawing from being major shareholders.</li>
                                    <li>Organizations, individuals and a group of relevant people holding 5% or above of voting stocks/ fund certificates of a closed public funds when having changes in the volume of owned stocks/ fund certificates that exceed thresholds of one percent (1%) of the volume of stocks/ fund certificates (including the cases of giving, offering or being given, inherited, transferring or receiving transfers of the call option of additional stocks ... or not performing stock/fund certificate transactions) must report to the public company, SSC and SE within seven days after such changes are made (under the Annex VII promulgated together with Circular No. 155/2015/TT-BTC).</li>
                                    <li>Internal shareholders (Members of Board of Management, Board of Director, Chief Accountant, members of Inspection Committee, major shareholders, persons authorized to make information disclosure and relevant persons of the subjects) of the listing / transaction registering organization upon planning to perform transaction of stocks must report to the SSC, the Stock Exchange and the listing / transaction registering organization at least three (03) working days prior the expected date of performing the transaction and shall only be performed after twenty four hours as from having the disclosure of information from the Stock Exchange. Within 3 working days as from the date of completing the registered transaction or ending of expected transaction, the internal shareholders must report to the SSC, the Stock Exchange, and the listing / transaction registering organization the result of the transaction.</li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                    <!-- // #general -->

                    <div id="hcm">
                        <h4 class="cont_subtitle">Securities listed on the Ho Chi Minh Stock Exchange (HSX)</h4>

                        <h5 class="sec_title">1. Type of securities :</h5>
                        <p>Including: shares, closed fund certificates, ETF fund certificates, bonds (corporate bonds) and other securities after getting approval from the State Securities Commission (SSC)</p>

                        <h5 class="sec_title">2. Trading time :</h5>
                        <p>From Monday to Friday (except Saturday, Sunday and holidays as stipulated by Labor Law)</p>
                        <p class="bu_arrow">Shares, closed fund certificates, ETF fund certificates</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="165" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Session</th>
                                        <th scope="col">Trading method</th>
                                        <th scope="col">Trading time</th>
                                        <th scope="col">Order type</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Market close</td>
                                        <td class="center">15:00</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td rowspan="3" class="left">Morning session</td>
                                        <td class="left">Opening period order matching</td>
                                        <td class="center">09:00 ~ 09:15</td>
                                        <td class="center">LO, ATO</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Continuous order matching I</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td class="center">LO, MP</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">09:15 ~ 11:30</td>
                                        <td class="center">LO, MP</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Break time</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td rowspan="3" class="left">Afternoon session</td>
                                        <td class="left">Continuous order matching II</td>
                                        <td class="center">13:00 ~ 14:30</td>
                                        <td class="center">LO, MP</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Closing period order matching</td>
                                        <td class="center">14:30 ~ 14:45</td>
                                        <td class="center">LO, ATC</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <p class="bu_arrow">Bonds</p>
                        <div class="price_table">
                            <table>
                                <caption>Bonds</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Session</th>
                                        <th scope="col">Trading method</th>
                                        <th scope="col">Trading time</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Market close</td>
                                        <td class="center">15:00</td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td class="left">Morning session</td>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">09:15 ~ 11:30</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Break time</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Afternoon session</td>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Order matching methods:</h5>
                        <table class="table_style_01">
                            <caption>Order matching methods</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Order matching<br />method</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Periodic order matching:<br />The method is made on the basis of comparing buy orders and sell orders of stocks in a specified time. Principles to determine the price as follows :
                                                <ul class="data_list type_03">
                                                    <li>The executed price that reaches largest transaction volume.</li>
                                                    <li>If more than one price satisfies the above condition, the price which is similar or closest with nearest matching order price will be selected.</li>
                                                </ul>
                                            </li>
                                            <li>Continuous order matching:<br />The method is made on the basis of comparing buy orders and sell orders immediately when they are input into the trading system.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Put-through<br />method</th>
                                    <td>
                                        <p>Put-through is the method whereby buyers and sellers negotiate with each other on the transaction conditions in advance, then the trading result will be placed into the trading system</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">4. Matching principles:</h5>
                        <table class="table_style_01">
                            <caption>Matching principles</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Price Priority</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Buy orders at higher price will take precedence</li>
                                            <li>Sell orders at lower price will take precedence</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Time Priority</th>
                                    <td>
                                        <p>In case buy or sell orders at the same price, those which entered into the trading system earlier will take precedence in execution.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">5. Trading unit and Price tick:</h5>
                        <table class="table_style_01">
                            <caption>Trading unit and Price tick</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Trading unit</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Trading unit of order matching in even lot: 10 shares/fund certificates.</li>
                                            <li>Trading volume of put through transactions: 20,000 shares/fund certificates or more.</li>
                                            <li>No trading unit applied for put through transactions.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Price tick</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>
                                                For order matching method
                                                <table class="table_style_02">
                                                    <caption>order matching method</caption>
                                                    <colgroup>
                                                        <col width="25%" />
                                                        <col width="25%" />
                                                        <col width="25%" />
                                                        <col width="25%" />
                                                    </colgroup>
                                                    <thead>
                                                        <tr>
                                                            <th scope="rowgroup" class="bg">Price level (VND)</th>
                                                            <th scope="col">≤ 49,900</th>
                                                            <th scope="col">50,000 ~ 99,500</th>
                                                            <th scope="col">≥ 100,000</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <th scope="row" class="bg">Price Tick (VND)</th>
                                                            <td>100</td>
                                                            <td>500</td>
                                                            <td>1,000</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </li>
                                            <li>For put through method: no price tick applied</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Trading band:</h5>
                        <table class="table_style_01">
                            <caption>Trading band</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Shares,<br />investment fund<br />certificates</th>
                                    <td>
                                        <p>Price range regulated for trading shares and investment fund certificates is ± 7% of the reference price</p>
                                        <ul class="data_list type_02">
                                            <li>Price range of shares/ fund certificates on the transaction date is determined as follows :
                                                <ul class="data_list type_03">
                                                    <li>Ceiling price = Reference price + 7%</li>
                                                    <li>Floor price = Reference price – 7%</li>
                                                </ul>
                                            </li>
                                            <li>In case ceiling price and floor price are equal to reference price :
                                                <ul class="data_list type_03">
                                                    <li>Adjusted ceiling price = Reference price + 01 tick value</li>
                                                    <li>Adjusted floor price = Reference price - 01 tick value</li>
                                                </ul>
                                            </li>
                                            <li>In case adjusted floor price is zero (0)
                                                <ul class="data_list type_03">
                                                    <li>Adjusted ceiling price = Reference price + 01 tick value</li>
                                                    <li>Adjusted floor price = Reference price</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Shares,<br />investment fund<br />certificates on the<br />first trading day</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Reference price applied to newly listed securities on the first trading day will be proposed by the listed company and the consultant company (if any) and approved by the HSX</li>
                                            <li>Price range is ±20% compared to reference price.</li>
                                            <li>Do not allow to perform put through transaction</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Bond</th>
                                    <td>
                                       <p>No price range applied for trading bonds.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">7. Reference price</h5>
                        <ul class="data_list type_01">
                            <li>Reference price is the closing price of the nearest trading day</li>
                            <li>In case of trading securities without dividend or accompanied rights, the reference price in the ex-right date is specified on the basis of closing price of the nearest trading day with adjustment according to the value of dividend received or value of accompanied rights.</li>
                            <li>In case of the issue price of the securities purchasing rights higher than the closing price prior to the ex-right date, HSX will not adjust the reference price on the ex-right trading day.</li>
                            <li>In case of issuing the convertible bonds, private securities, offering securities for investors that are not existing shareholders, issuing securities under the optional program for employees in the company, the reference price will be not adjusted on the ex-right trading day.</li>
                        </ul>

                        <h5 class="sec_title">8. Type of orders:</h5>
                        <table class="table_style_01">
                            <caption>Type of orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">ATO/ATC order</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Buy/sell order at the opening/closing price</li>
                                            <li>Order without definite price, only written ATO/ATC</li>
                                            <li>Order receives higher priority than limit order when comparing to match.</li>
                                            <li>Order is entered into the trading system in time for Periodic order matching to determine the opening/ closing price and will be automatically cancelled at the end of the opening session if they are not executed or partially matched.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Limit order (LO)</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Orders which are to be executed at a pre-specified or better price.</li>
                                            <li>Orders must be defined at a specific price.</li>
                                            <li>Limited orders shall be effective since being entered into the trading system till being cancelled or the end of the trading session.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Market order (MP)</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Buy/sell order to be executed at lowest offer price/ highest bid price available in the market.</li>
                                            <li>If volume of the market order hasn’t been matched completely yet, it will be automatically considered a buying order at the higher price or a selling order at the lower price and continuously matched at the next best price available in the market.</li>
                                            <li>If the volume of order is not met while that of the counter side has been fulfilled, a buying or selling market order will become a limit order with price higher or lower than the last-traded price by one quotation unit.</li>
                                            <li>MP orders are valid in continuous order-matching session only and will be automatically cancelled if there is no corresponding limit order at the time the MP order is input into the trading system.</li>
                                            <li>Order without definite price, only written MP</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">9. Cancellation of orders:</h5>
                        <table class="table_style_01">
                            <caption>Cancellation of orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">In periodic order<br />matching session</th>
                                    <td>
                                        <p>Cancellation of trading orders placed in time for periodic order matching is not allowed</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">In continuous order<br />matching session</th>
                                    <td>
                                         <p>Customer can ask the broker to cancel if the order or remaining part of partially - filled order has not been implemented,  including those which have not been implemented in the previous periodic or continuous order matching session.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- // #hcm -->

                    <div id="hni">
                        <h4 class="cont_subtitle">Securities listed on the Hanoi Stock Exchange (HSX)</h4>

                        <h5 class="sec_title">1. Type of securities :</h5>
                        <p>Shares, bonds and other kinds of securities approved by State Securities Commission (SSC)</p>

                        <h5 class="sec_title">2. Trading time :</h5>
                        <p>From Monday to Friday (except Saturday, Sunday and holidays as stipulated by Labor Law)</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="165" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Session</th>
                                        <th scope="col">Trading method</th>
                                        <th scope="col">Trading time</th>
                                        <th scope="col">Order type</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Market close</td>
                                        <td class="center">15:00</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td rowspan="2" class="left">Morning session</td>
                                        <td class="left">Continuous order matching</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td class="center">LO, MTL, MAK, MOK</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td class="left">Break time</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td rowspan="3" class="left">Afternoon session</td>
                                        <td class="left">Continuous order matching</td>
                                        <td class="center">13:00 ~ 14:30</td>
                                        <td class="center">LO, MTL, MAK, MOK</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Closing period order matching</td>
                                        <td class="center">14:30 ~ 14:45</td>
                                        <td class="center">LO, ATC</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Trading methods :</h5>
                        <table class="table_style_01">
                            <caption>Trading methods</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Order matching<br />method</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Periodic order matching:<br />The method is made on the basis of comparing buy orders and sell orders of stocks in a specified time. Principles to determine the price as follows :
                                                <ul class="data_list type_03">
                                                    <li>The executed price that reaches largest transaction volume.</li>
                                                    <li>If more than one price satisfies the above condition, the price which is similar or closest with nearest matching order price will be selected.</li>
                                                </ul>
                                            </li>
                                            <li>Continuous order matching:<br />The method is made on the basis of comparing buy orders and sell orders immediately when they are input into the trading system.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Put-through<br />method</th>
                                    <td>
                                        <p>Put-through is the method whereby buyers and sellers negotiate with each other on the transaction conditions in advance, then the trading result will be placed into the trading system.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">4. Matching principles :</h5>
                        <table class="table_style_01">
                            <caption>Matching principles</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Price Priority</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Buy orders at higher price will take precedence</li>
                                            <li>Sell orders at lower price will take precedence</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Time Priority</th>
                                    <td>
                                        <p>In case buy or sell orders at the same price, those which entered into the trading system earlier will take precedence in execution.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">5. Trading unit and Price tick :</h5>
                        <table class="table_style_01">
                            <caption>Trading unit and Price tick</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Trading unit</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Trading unit of order matching in even lot: 100 shares / bonds</li>
                                            <li>No trading unit applied for put through transactions.</li>
                                            <li>Trading volume for stock put through transaction : 5,000 shares or more</li>
                                            <li>Trading volume for bond put-through transaction : 1,000 bonds or more</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Price tick</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Tick size for shares in order matching method : 100 VND</li>
                                            <li>No price tick applied for stock put through.</li>
                                            <li>Bonds : not regulated</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Trading band :</h5>
                        <table class="table_style_01">
                            <caption>Trading band</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Trading band of<br />stocks in trading day</th>
                                    <td>
                                        <p>Price range regulated for trading shares and investment fund certificates is ± 7% of the reference price</p>
                                        <ul class="data_list type_02">
                                            <li>Price range of stocks in the transaction date is determined as follows:
                                                <ul class="data_list type_03">
                                                    <li>Ceiling price = Reference price + (Reference price * Trading band)</li>
                                                    <li>Floor price = Reference price - (Reference price * Trading band)</li>
                                                </ul>
                                            </li>
                                            <li>In case ceiling price and floor price are equal to reference price:
                                                <ul class="data_list type_03">
                                                    <li>Adjusted ceiling price = Reference price + 01 tick value</li>
                                                    <li>Adjusted floor price = Reference price - 01 tick value</li>
                                                </ul>
                                            </li>
                                            <li>In case the reference price = 100 vnd:
                                                <ul class="data_list type_03">
                                                    <li>Adjusted ceiling price = Reference price + 01 tick value</li>
                                                    <li>Adjusted floor price = Reference price</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Trading band of<br />stocks on the first<br />trading day</th>
                                    <td>
                                        <p>Trading band applied to newly listed stocks on the first trading day and stocks with over 25-session trading suspension on the re-trading day is ±30% compared to reference price.</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Bond</th>
                                    <td>
                                        <p>No price range applied for trading bonds.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">7. Reference price</h5>
                        <ul class="data_list type_01">
                            <li>Reference price is the closing price of the nearest trading day.</li>
                            <li>Reference price applied to newly listed stocks on the first trading day will be proposed by the listed company or the consultant company (if any)</li>
                            <li>In case of stocks with over 25-session trading suspension, on the re-trading day, the reference price will be decided by the HNX and approved by the State Securities Commission.</li>
                            <li>In case of trading securities that you are not entitled to receive dividend or accompanied rights, the reference price in the ex-right date is specified on the basis of closing price of the nearest trading day with adjustment according to the value of dividend received or value of accompanied rights, except in the following cases :</li>
                            <li>The listed company issues convertible bonds;<br />The listed company issues additional shares with the issue price higher than the closing price of the trading day previous to the ex-right date.</li>
                            <li>In case of stock split or reverse stock split, the reference price on the re-trading day is specified on the basis of closing price of the most recent trading day before the day of stock split or reverse stock split with adjustment according to the exercise rate of stock split or reverse stock split.</li>
                        </ul>

                        <h5 class="sec_title">8. Type of orders:</h5>
                        <table class="table_style_01">
                            <caption>Type of orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">ATC order</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Buy/sell order at the opening/closing price</li>
                                            <li>Order without definite price, only written ATC</li>
                                            <li>Order receives higher priority than limit order when comparing to match.</li>
                                            <li>Order is entered into the trading system in time for Periodic order matching to determine the closing price and will be automatically cancelled if they are not executed or partially matched.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Limit order (LO)</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Orders which are to be executed at a pre-specified or better price.</li>
                                            <li>Orders must be defined at a specific price.</li>
                                            <li>Be input into the trading system in the continuous order matching session and the periodic order matching</li>
                                            <li>Limited orders shall be effective since being entered into the trading system till being cancelled or the end of the trading session.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Market to limit order (MTL)</th>
                                    <td>
                                        <p>a market order if not fully executed, the remaining of the order will be changed to a buying limit order with price higher than the latest executed price one more tick size or the celling price if the latest equal to ceiling price (for buy order) / a selling limit order with price lower than the latest executed price one more tick size or the floor price if the latest is floor price (for sell order)</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Market Fill or<br />Kill order (MOK)</th>
                                    <td>
                                        <p>a market order that must be entire executed; otherwise, the order will be cancelled immediately after input into the trading system.</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Market Fill and<br />Kill order (MAK)</th>
                                    <td>
                                        <p>a market order that is executed fully or partially, the remaining of the order will be cancelled immediately after matching.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">9. Modification and cancellation of orders :</h5>
                        <ul class="data_list type_01">
                            <li>Modification and cancellation of orders are implemented for unmatched buy / sell orders or the rest of partially-filled orders which have not been executed.</li>
                            <li>Limit orders are allowed to modify price, volume and cancel on the trading time. The priority of modified orders is determined as follows :
                                <ul class="data_list type_03">
                                    <li>Modify to reduce volume : the priority of modified orders is unchanged</li>
                                    <li>Modify to increase volume and / or modify price : the priority of modified orders is determined since the modified orders are put into the trading</li>
                                </ul>
                            </li>
                            <li>ATC orders are not allowed to modify, only allowed to cancel on the trading time.</li>
                            <li>All orders are not allowed to modify, cancel within the last 5 minutes of the periodic order matching session</li>
                        </ul>

                        <h5 class="sec_title">10. Odd-lot securities transaction :</h5>
                        <ul class="data_list type_01">
                            <li>Odd-lot securities transaction with volume from 1 to 99 shares/bonds can be directly traded via continuous matching method or put-through on the trading system, or other methods stipulated by laws.</li>
                            <li>Be only entered into the trading system by limit order and must comply with procedure of modification, cancellation of the limit order similar to the even lot trading.</li>
                            <li>Odd-lot securities trading unit : 01 share / bond</li>
                            <li>Trading price :
                                <ul class="data_list type_03">
                                    <li>Price of odd-lot securities trading order must comply with the regulation of trading price similar to the even lot trading.</li>
                                    <li>Odd lot securities trading order is not allowed to use to determine the reference price, index.</li>
                                </ul>
                            </li>
                            <li>Odd-lot securities transactions are not allowed to implement on the first trading day of the newly listed stock/bonds or on the re-trading day of stocks with 25 days trading suspension.</li>
                        </ul>
                    </div>
                    <!-- // #hni -->

                    <div id="upcom">
                        <h4 class="cont_subtitle">Securities registered for trading on UPCOM</h4>

                        <h5 class="sec_title">1. Type of securities :</h5>
                        <p>Shares, bonds and other kinds of securities approved by State Securities Commission (SSC)</p>

                        <h5 class="sec_title">2. Trading time :</h5>
                        <p>From Monday to Friday (except Saturday, Sunday and holidays as stipulated by Labor Law)</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="165" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Session</th>
                                        <th scope="col">Trading method</th>
                                        <th scope="col">Trading time</th>
                                        <th scope="col">Order type</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Market close</td>
                                        <td class="center">15:00</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td rowspan="2" class="left">Morning session</td>
                                        <td class="left">Continuous order matching</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td class="center">LO</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td class="left">Break time</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td rowspan="3" class="left">Afternoon session</td>
                                        <td class="left">Continuous order matching</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td class="center">LO</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Trading methods :</h5>
                        <table class="table_style_01">
                            <caption>Trading methods</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Continuous order<br />matching method</th>
                                    <td>
                                        <p>The method is made on the basis of comparing buy orders and sell orders immediately when they are input into the UPCOM trading system.</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Put-through method</th>
                                    <td>
                                        <p>The method whereby buyers and sellers negotiate with each other on the transaction conditions in advance, then the trading result will be placed into the trading system.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">4. Matching principles :</h5>
                        <table class="table_style_01">
                            <caption>Matching principles</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Price Priority</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Buy orders at higher price will take recedence.</li>
                                            <li>Sell orders at lower price will take precedence.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Time Priority</th>
                                    <td>
                                        <p>In case buy or sell orders at the same price, those which entered into the UPCOM trading system earlier will take precedence in execution.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">5. Trading unit and Price tick :</h5>
                        <table class="table_style_01">
                            <caption>Trading unit and Price tick</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Trading unit</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Trading unit of order matching in even lot: 00 shares/bonds.</li>
                                            <li>No trading unit applied for put through transactions.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Price tick</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Tick size for shares in order matching method: 100 VND</li>
                                            <li>No price tick applied for stock put through.</li>
                                            <li>Bonds : not regulated</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Trading band :</h5>
                        <table class="table_style_01">
                            <caption>Trading band</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Trading band of<br />stocks in trading day</th>
                                    <td>
                                        <p>Trading band of stocks in trading day is ± 15% of the reference price.</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Trading band of<br />stocks on the first<br />trading day</th>
                                    <td>
                                        <p>Trading band applied to newly listed stocks on the first trading day and stocks with over 25-session trading suspension on the re-trading day is ±40% compared to reference price</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">7. Reference price</h5>
                        <ul class="data_list type_01">
                            <li>Reference price applied to newly listed stocks on the first trading day will be proposed by the listed company and approved by SSC</li>
                            <li>Reference price is the weighted average of the even-lot trading prices under continuous order matching method of the nearest trading day.</li>
                            <li>In case of stocks with over 25-session trading suspension, on the re-trading day, the reference price will be decided by the HNX and approved by the State Securities Commission.</li>
                            <li>In case of trading securities that you are not entitled to receive dividend or accompanied rights, the reference price in the ex-right date is specified on the basis of the weighted average price of the nearest trading day with adjustment according to the value of dividend received or value of accompanied rights, except in the following cases:
                                <ul class="data_list type_03">
                                    <li>The listed company issues convertible bonds;</li>
                                    <li>The listed company issues additional shares with the issued price higher than the weighted average price of the trading day previous to the ex-right date.</li>
                                </ul>
                            </li>
                            <li>In case of stock split or reverse stock split, the reference price on the re-trading day is specified on the basis of the weighted average price of the trading day previous to the date of stock split or reverse stock split with adjustment according to the exercise rate of stock split or reverse stock split.</li>
                        </ul>

                        <h5 class="sec_title">8. Modification and cancellation of orders :</h5>
                        <ul class="data_list type_01">
                            <li>Modification and cancellation of an order only be valid when original order has not been executed or the rest of the original order has not been executed.</li>
                            <li>Investors are allowed to modify price, volume or cancel order during the transaction time. The priority of the modified order is determined as follow :
                                <ul class="data_list type_03">
                                    <li>Modify to reduce volume: the priority of the order is unchanged</li>
                                    <li>Increase volume or modify price: the priority of the order is determined since the modified order is entered into UPCOM trading system.</li>
                                </ul>
                            </li>
                            <li>Put through transaction is executed on the trading system is not allowed to cancel.</li>
                        </ul>
                    </div>
                    <!-- // #upcom -->

                    <div id="g_bond">
                        <h4 class="cont_subtitle">Government bond listed on HNX</h4>

                        <h5 class="sec_title">1. Type of bonds :</h5>
                        <ul class="data_list type_01">
                            <li>Government Bonds issued by State Treasury with nominal term greater than or equal to a year</li>
                            <li>Treasury bills issued by State Treasury or State Bank of Vietnam with nominal term not greater than 52 weeks</li>
                            <li>Municipal bonds, Government underwritten bonds</li>
                        </ul>

                        <h5 class="sec_title">2. Trading time :</h5>
                        <p>From Monday to Friday (except Saturday, Sunday and holidays as stipulated by Labor Law)</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185">
                                    <col width="*">
                                    <col width="160">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Session</th>
                                        <th scope="col">Trading method</th>
                                        <th scope="col">Trading time</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Market close</td>
                                        <td class="center">14:15</td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td class="left">Morning session</td>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">08:30 ~ 11:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Break time</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Afternoon session</td>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">13:00 ~ 14:15</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Trading unit :</h5>
                        <p>01 (one) bond</p>

                        <h5 class="sec_title">4. Price tick :</h5>
                        <p>01 (one) VND</p>

                        <h5 class="sec_title">5. Listed par value :</h5>
                        <p>100,000 VND / bond</p>

                        <h5 class="sec_title">6. Trading a bond type in the same session :</h5>
                        <p>The simultaneous purchasing and selling of a bond type in the same session can be made only when changing the ownership of that bond.</p>

                        <h5 class="sec_title">7. Trading orders :</h5>
                        <table class="table_style_01">
                            <caption>Trading orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2" scope="row">Outright<br />transactions</th>
                                    <td>
                                        <p class="em">E-negotiation method</p>
                                        <ul class="data_list type_02">
                                            <li>Whole-market e-negotiation orders :<br />Whole-market e-negotiation orders are tender and offering orders with commitment which is valid in tender and offering date on system.</li>
                                            <li>Option e-negotiation orders : include 02 types of order :
                                                <ul class="data_list type_03">
                                                    <li>
                                                        Price quote order :<br />
                                                        used when investors do not define partners in transactions. Price quote order could be sent to one, one group of members or the whole market.
                                                    </li>
                                                    <li>
                                                        Bid / ask order with firm commitment : <br />
                                                        Bid / ask order with firm commitment is used to match price quote order. Bid / ask order with firm commitment is directly sent to the member who sent price quote order.
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p class="em">Conventional negotiation method</p>
                                        <ul class="data_list type_02">
                                            <li>Daily trading report orders :<br />Daily trading report orders are used to import transactions to system if transactions are agreed by parties.
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th rowspan="2" scope="row">Repos<br />transactions</th>
                                    <td>
                                        <p class="em">E-negotiation method</p>
                                        <ul class="data_list type_02">
                                            <li>Price quote order :<br />used when investors do not define partners in transactions. Price quote order could be sent to one, one group of members or the whole market.</li>
                                            <li>Bid / ask order with firm commitment :<br />Bid / ask order with firm commitment is used to match price quote order. Bid / ask order with firm commitment is directly sent to the member who sent price quote order.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p class="em">Conventional negotiation method</p>
                                        <ul class="data_list type_02">
                                            <li>Daily trading report orders :<br />Daily trading report orders are used to import transactions to system if transactions are agreed by parties.</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">8. Minimum trading volume :</h5>
                        <ul class="data_list type_01">
                            <li>For Outright transaction :
                                <ul class="data_list type_03">
                                    <li>E-negotiation method : 100 GB</li>
                                    <li>Conventional negotiation method : 10,000 GB</li>
                                </ul>
                            </li>
                            <li>For Repos transaction : 100 GB</li>
                        </ul>

                        <h5 class="sec_title">9.  Modification and cancellation of orders :</h5>
                        <ul class="data_list type_01">
                            <li>Investors are allowed to modify or cancel the put through orders only when the original orders have not been executed.</li>
                            <li>Put through transaction already confirmed on the system is not allowed to cancel.</li>
                            <li>For the second time in repos: be allowed to modify the time of repos transaction executed. Modification of the second time transaction that comes to payment or not will be deducted as follows :
                                <ul class="data_list type_03">
                                    <li>For Government bonds : allowed to modify Repo trading time, Repo interest and rate of coupon interest.</li>
                                    <li>For Treasury bills : allowed to modify Repo trading time and Repos interest.</li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                    <!-- // #g_bond -->

                    <div id="g_foreign">
                        <h4 class="cont_subtitle">Government bond in foreign currency listed on HNX</h4>

                        <h5 class="sec_title">1. Trading time :</h5>
                        <p>From Monday to Friday (except Saturday, Sunday and holidays as stipulated by Labor Law)</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185">
                                    <col width="*">
                                    <col width="160">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Session</th>
                                        <th scope="col">Trading method</th>
                                        <th scope="col">Trading time</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Market close</td>
                                        <td class="center">14:15</td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td class="left">Morning session</td>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">08:30 ~ 11:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Break time</td>
                                        <td></td>
                                        <td class="center">11:00 ~ 13:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Afternoon session</td>
                                        <td class="left">Put through transaction</td>
                                        <td class="center">13:00 ~ 14:15</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">2. Trading unit and minimum trading volume :</h5>
                        <p>Not regulated</p>

                        <h5 class="sec_title">3. Price tick :</h5>
                        <p>01 (one) cent (1 USD = 100 cents)</p>

                        <h5 class="sec_title">4. Listed par value :</h5>
                        <p>100 USD / bond</p>

                        <h5 class="sec_title">5. Payment method :</h5>
                        <ul class="data_list type_01">
                            <li>Direct payment shall be made in USD within 01 (one) business day after the transaction date.</li>
                            <li>The exchange rate for transaction payments of GB in foreign currency shall be the inter-bank exchange rate announced by State Bank of Vietnam on the transaction date.</li>
                        </ul>
                    </div>
                    <!-- // #g_foreign -->
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