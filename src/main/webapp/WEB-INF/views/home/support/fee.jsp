<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Support";
	});
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Support</h2>
            <ul>
                <li><a href="/home/support/account.do">Open cash account in ACB</a></li>
                <li><a href="/home/support/depositCash.do">Deposit cash</a></li>
                <li><a href="/home/support/depositStock.do">Deposit stock</a></li>
                <li><a href="/home/support/cashAdvance.do">Cash advance</a></li>
                <li><a href="/home/support/cashTransfer.do">Cash transfer</a></li>
                <li>
                    <a href="/home/support/marginGuideline.do">Margin trading</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/support/marginGuideline.do">Guideline</a></li>
                        <li><a href="/home/support/marginList.do">List and Basic Information</a></li>
                    </ul>
                </li>
                <li><a href="/home/support/sms.do">SMS</a></li>
                <li><a href="/home/support/securities.do">Securities Trading Regulation</a></li>
                <li><a href="/home/support/web.do">Web trading guideline</a></li>
                <li><a href="/home/support/mobile.do">Mobile trading guideline</a></li>
                <li><a href="/home/support/fee.do" class="on">Fee table</a></li>
                <li><a href="/home/subpage/openAccount.do">Guideline on dossiers for securities account opening</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Fee table</h3>

            <div class="fee">
                <h4 class="cont_subtitle">SECURITIES SERVICE FEE TABLE</h4>
                <h5 class="sml_title">Mirae Asset Securities (Vietnam) LLC is pleased to announce the securities service fee table applicable from March 19<sup style="vertical-align: super;">th</sup> , 2020 as follows:</h5>

				<h6 class="sec_title">I. LISTED SECURITIES TRADING ACCOUNT </h6>
                <div class="price_table">
                    <table>
                        <caption>Tài khoản chứng khoán niêm yết</caption>
                        <colgroup>
                            <col width="50%" />
                            <col width="50%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">Service</th>
                                <th scope="col">Fee</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="font-weight:bold;" class="left">Open securities trading account</td>
                                <td class="left">Free of charge</td>
                            </tr>
                            <tr>
                                <td style="font-weight:bold;" class="left">Close securities trading account</td>
                                <td class="left">VND 100,000 /account</td>
                            </tr>
                            <tr>
                                <td style="font-weight:bold;" class="left">Register trading code for foreign clients</td>
                                <td class="left">Free of charge</td>
                            </tr>
                            <tr>
                                <td style="font-weight:bold;" class="left">Issue online trading card for the first time</td>
                                <td class="left">Free of charge</td>
                            </tr>
                            <tr>
                                <td style="font-weight:bold;" class="left">Reissue online trading card from the second time</td>
                                <td class="left">VND 50,000/time</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
				
                <h6 class="sec_title">II. SECURITIES TRANSACTION FEE</h6>
                <ul class="data_list type_01">
                    <li>
                        <span class="em">Transaction of stocks, fund certificates, covered warrants listed on HSX, HNX, UPCOM (including both matching and put through transaction method)</span>

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
                                        <td style="font-weight:bold;" class="left">Foreign clients</td>
                                        <td></td>
                                        <td class="center">0.40%</td>
                                        <td class="center">0.15%</td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight:bold;" rowspan="2" class="left">Domestic clients</td>
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

                <h6 class="sec_title">III. FINANCIAL SERVICE FEE</h6>

                <div class="box">
                    <ul class="info_list">
                        <li>
                            <span class="title">Cash Advance Service</span>
                            <span class="desc">
                                <span>12% year</span>
                            </span>
                        </li>
                        <li>
                            <p class="title">Margin Service</p>
                            <p>
                                <span class="title bu01">Lending Interest Rate(*)</span>
                                <span class="desc">
                                    <span>12% year</span>
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
                
                <h6 class="sec_title">IV. BLOCK, UNBLOCK PLEDGED SECURITIES UPON REQUEST</h6>
                <ul class="data_list type_01">                    
                    <li>
                        <span class="em">Block, unblock at MAS</span><br />
                        Fee: 200,000 VND/request
                    </li>
                    <li>
                        <span class="em">Block, unblock at VSD</span><br />
                        Fee: 300,000 VND/request
                    </li>
                    <li>
                        <span class="em">Handling pledged securities: </span> 
                        0.3% of total trading value
                    </li>   
                </ul>
                
                <h6 class="sec_title">V. PRINTING STATEMENT OF SECURITIES ACCOUNT (WITH CERTIFIED SEAL)</h6>
                <ul class="data_list type_01">                                                                
                	<span class="em">Fee:</span>
                	<li>
                        <span class="em">Under 3 months:</span> Free of charge                      
                    </li>
                    <li>
                        <span class="em">From 3 months to less than 12 months:</span> 20,000 VND/copy                        
                    </li>
                    <li>
                        <span class="em">Greater than or equal to 12 months:</span> 50,000 VND/copy/each year                        
                    </li>
                    <span class="em">Note:</span> Time of printing is up to the present
                </ul>
                
                <h6 class="sec_title">VI. PROVIDE STATEMENT OF SECURITIES ACCOUNT</h6>
                <ul class="data_list type_01">
                	<span class="em">Fee:</span> 50,000 VND/copy
                </ul>
				
                <h6 class="sec_title">VII. SERVICE FEE FOR TRADING AT STOCK EXCHANGES</h6>

                <ul class="data_list type_01">
                       <!--  <span class="em">Phí lưu ký chứng khoán</span> -->
                        <table class="info_table">
							<caption>Phí ủy thác đấu giá</caption>
                            <colgroup>
                                <col width="240" />
                                <col width="*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Listed stock, investment fund certificate (excluding ETF)</th>
                                    <td>0.027% trading value</td>
                                </tr>
                                <tr>
                                    <th scope="row">Listed ETF</th>
                                    <td>0.018% trading value</td>
                                </tr>
                                <tr>
                                    <th scope="row">Corporate bonds and debt instruments in accordance with the Law on public debt management</th>
                                    <td>0.0054% trading value</td>
                                </tr>
                                <tr>
                                    <th scope="row">Stock, fund certificate listed on UPCOM</th>
                                    <td>0.018% trading value</td>
                                </tr>
                                <tr>
                                    <th scope="row">Covered warrant</th>
                                    <td>0.018% trading value</td>
                                </tr>
                            </tbody>
                        </table>
                </ul>                
                <h6 class="sec_title">VIII. SERVICE FEE AT VIETNAM SECURITIES DEPOSITORY (VSD)</h6>
				<ul class="data_list type_01">
                        <table class="info_table">
                            <caption>Phí ủy thác đấu giá</caption>
                            <colgroup>
                                <col width="240" />
                                <col width="*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Securities depository fee
										<ul>
											<li>For stocks, fund certificates, covered warrant</li>
											<li>For corporate bonds and debt instruments in accordance with the Law on public debt management</li>											
										</ul>
									</th>						
									<td>
										<ul>
											<li>VND 0.27/stock, fund certificate, covered warrant/month</li>
											<li>VND 0.18/bond/month, maximum VND 2,000,000/month/ticker</li>
									   </ul>
									</td>
                                </tr>
                                <tr>
                                    <th scope="row">Securities transfer fee among Investors' accounts at different depository members; or to make a payment</th>						
									<td>
										<ul>
											<li>VND 0.3/securities/1 transfer time/ticker</br>(not greater than VND 300,000/1 transfer time/ticker)
											</li>
										</ul>
									</td>
                                </tr>
								<tr>
                                    <th scope="row">Stock/fund certificate ownership transfer fee not traded through Stock Exchanges
									</th>						
									<td>
										<ul>
											<li style="font-weight: bold;">Collected on Seller:</li>
												0.2% total transfer value (for MAS)</br>
												0.1% total transfer value (for VSD)</br>
											<li style="font-weight: bold;">Collected on Buyer</li>
												0.1% total transfer value (for VSD)</br>
									   </ul>
									</td>
                                </tr>
                            </tbody>
                        </table>
                </ul>
                <h6 class="sec_title">IX.	UNLISTED (OTC) SECURITIES TRADING</h6>
				<ul class="data_list type_01">                    
                        <table class="info_table">
                            <caption>Phí môi giới chứng khoán chưa niêm yết</caption>
                            <colgroup>
                                <col width="240" />
                                <col width="*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Brokerage fee and Transfer fee of unlisted shares</th>
                                    <td>0.5% total trading value</td>
                                </tr>
                                <tr>
                                    <th scope="row">Transfer fee of unlisted shares under MAS shareholder management</th>
                                    <td>0.2% total transfer value</br> 
                                    Minimum VND 50,000 / 1 time
									</td>
                                </tr>
                            </tbody>
                        </table>                    
                </ul>
				<ul class="data_list type_01">                    
                     <li>
                        <span class="em">NOTE: Service fee table does not include personal income tax payable by the investor as required by law</span><br />
                        <span class="em" style="margin-right:150px;float:right;">Mirae Asset Securities (Vietnam) LLC</span><br />
                        <span class="em" style="margin-right:270px;float:right;">CEO</span><br /><br /><br /><br />
                        <span class="em" style="margin-right:220px;float:right;">Kang Moon Kyung</span>
                    </li>                       
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>