<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Thông tin tài khoản | MIRAE ASSET</title>

<script>
	$(document).ready(function() {
		getPortFolio();
	});

	function getPortFolio() {
		var param = {
				mvLastAction      : "PORTFOLIOENQUIRY",
				mvChildLastAction : "PORTFOLIO"
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/enquiryportfolio.do",
			data      : param,
			success   : function(data) {
				if(data.jsonObj != null) {
					if(data.jsonObj.mvPortfolioAccSummaryBean != null) {
						var htmlCashStr = "";
						var accSum  = data.jsonObj.mvPortfolioAccSummaryBean;
						$("#spnTotalAsset").html(numIntFormat(numDotComma(accSum.totalAsset)));
						$("#spnTotalEvaluation").html(numIntFormat(numDotComma(accSum.stockValue)));
						$("#spnTotalProfitLoss").html(numIntFormat(numDotComma(data.jsonObj.totalPL)));
						$("#spnPerProfitLoss").html(accSum.PLPercent);
						
						if (parseFloat(data.jsonObj.totalPL) > 0) {
							$("#spnTotalProfitLoss").css('color', 'green');
						} else if (parseFloat(data.jsonObj.totalPL) < 0) {
							$("#spnTotalProfitLoss").css('color', 'red');
						} else {
							$("#spnTotalProfitLoss").css('color', 'yellow');
						}
						
						if (parseFloat(accSum.PLPercent) > 0) {
							$("#spnPerProfitLoss").css('color', 'green');
						} else if (parseFloat(accSum.PLPercent) < 0) {
							$("#spnPerProfitLoss").css('color', 'red');
						} else {
							$("#spnPerProfitLoss").css('color', 'yellow');
						}
						
						htmlCashStr += "<tr>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.mvCashWithdrawable)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.mvAvailAdvanceMoney)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.mvPendingWithdraw)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.mvPendingSettled)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.mvBuyHoldAmount)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.soldT0)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.soldT1)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.mvOutstandingLoan)) + "</td>";
						htmlCashStr += "	<td>" + numIntFormat(numDotComma(accSum.debitAccruedInterest)) + "</td>";
						htmlCashStr += "</tr>";
						$("#grdCashbalance").html(htmlCashStr);
					}

					if(data.jsonObj.mvPortfolioBeanList != null) {
						var htmlStockStr    = "";
						var lendValue  = 0;
						var maintValue = 0;
						$("#grdPortfolio").find("tr").remove();

						for(var i=0; i < data.jsonObj.mvPortfolioBeanList.length; i++) {
							var rowData = data.jsonObj.mvPortfolioBeanList[i];
							var totalVolume = parseInt(numDotComma(rowData.mvTSettled)) - parseInt(numDotComma(rowData.mvPdSell));
							totalVolume    += (parseInt(numDotComma(rowData.mvTTodayConfirmBuy)) + parseInt(numDotComma(rowData.mvTTodayUnsettleBuy)));
							totalVolume    += parseInt(numDotComma(rowData.mvTT1UnsettleBuy)) + parseInt(numDotComma(rowData.mvTT2UnsettleBuy));
							totalVolume    += parseInt(numDotComma(rowData.mvTDueBuy)) + parseInt(numDotComma(rowData.mvTEntitlementQty)) - parseInt(numDotComma(rowData.mvTTodayConfirmSell));
							var t0Buy       = parseInt(numDotComma(rowData.mvTTodayConfirmBuy)) + parseInt(numDotComma(rowData.mvTTodayUnsettleBuy));
							var volumeHold  = parseInt(numDotComma(rowData.normalHold)) + parseInt(numDotComma(rowData.conditionalHold));
							
							htmlStockStr += "<tr>";
							htmlStockStr += "	<td rowspan=\"2\">" + (i + 1) + "</td>";           // No.
							htmlStockStr += "	<td rowspan=\"2\">" + rowData.mvStockID + "</td>"; // Stock
							htmlStockStr += "	<td>" + numIntFormat(totalVolume) + "</td>";       // Total volume
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvQueuingSell)) + "</td>";    // Hold in day
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTT1UnsettleBuy)) + "</td>"; // T1 Buy
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTMortgageQty)) + "</td>";   // Mortgage
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTAwaitingTraceCert)) + "</td>";      // Await trading
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTAwaitingWithdrawalCert)) + "</td>"; // Await withdrawa
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvAvgPrice)) + "</td>";       // Avg. price
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvWAC)) + "</td>";            // Buy value
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvPL)) + "</td>";             // Profit/Loss
							htmlStockStr += "</tr>";
							htmlStockStr += "<tr class=\"second\">";
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTradableQty)) + "</td>"; // Usable
							htmlStockStr += "	<td>" + numIntFormat(t0Buy) + "</td>";      // T0 Buy
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTDueBuy)) + "</td>";     // T2 Buy
							htmlStockStr += "	<td>" + numIntFormat(volumeHold) + "</td>"; // Holding
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTAwaitingDepositCert)) + "</td>"; // Await deposit
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTEntitlementQty)) + "</td>";      // Pend. entitlemen
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvMarketPrice)) + "</td>"; // Current price
							htmlStockStr += "	<td>" + numIntFormat(numDotComma(rowData.mvMarketValue)) + "</td>"; // Market value
							htmlStockStr += "	<td>" + rowData.mvPLPercent + "</td>"; // %Profit/Loss
							htmlStockStr += "</tr>";
						}

						$("#grdPortfolio").html(htmlStockStr);
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">Thông tin tài khoản</h3>

            <div class="my_asset">
                <div class="search">
<!-- 
                    <div class="select">
                        <label for="acc">Số tài khoản</label>
                        <div class="select_wrap acc">
                            <select id="acc">
                                <option value="">077-C-123456</option>
                                <option value="">077-C-123456</option>
                                <option value="">077-C-123456</option>
                            </select>
                        </div>
                    </div>
-->
<!-- 
                    <div class="select">
                        <label for="bank">Ngân hàng</label>
                        <div class="select_wrap">
                            <select id="bank">
                                <option value="">ACB</option>
                                <option value="">HOSE</option>
                                <option value="">HNXSE</option>
                                <option value="">UPCOM</option>
                                <option value="">VSD</option>
                            </select>
                        </div>
                    </div>
-->
                </div>

                <ul class="summary">
                    <li class="sm01">
                        <div>Tổng tài sản</div>
                        <span id="spnTotalAsset"></span>
                    </li>
                    <li class="sm02">
                        <div>Giá trị chứng khoán</div>
                        <span id="spnTotalEvaluation"></span>
                    </li>
                    <li class="sm03">
                        <div>Tổng Lãi/Lỗ</div>
                        <span id="spnTotalProfitLoss"></span>
                    </li>
                    <li class="sm04">
                        <div>% Lãi/Lỗ</div>
                        <span id="spnPerProfitLoss"></span>
                    </li>
                </ul>
                
                <h4 class="sec_title">Số dư tài khoản tiền</h4>
                <div class="price_table">
                	<table>
                		<caption>Số dư tiền</caption>
                		<colgroup>
                            <col width="120" />
                            <col width="120" />
                            <col width="120" />
                            <col width="120" />
                            <col width="120" />
                            <col span="2" width="60" />
                            <col width="120" />
                            <col width="*" />
                        </colgroup>
                        <thead class="multi_row">
                            <tr>
                                <th rowspan="2" scope="col" class="center">Số dư <br/>có thể rút</th>
                                <th rowspan="2" scope="col" class="center">Số tiền <br/>có thể ứng</th>
                                <th rowspan="2" scope="col" class="center">Số tiền <br/>rút chờ duyệt</th>
                                <th rowspan="2" scope="col" class="center">Tiền mua CK<br/>đã khớp</th>
                                <th rowspan="2" scope="col" class="center">Tiền mua CK<br/>chờ khớp</th>
                                <th colspan="2" scope="col" class="center">Tiền bán chờ về</th>
                                <th rowspan="2" scope="col" class="center">Dư nợ <br/>kí quỹ</th>
                                <th rowspan="2" scope="col" class="center">Lãi vay <br/>cộng dồn</th>
                            </tr>
                            <tr>
                                <th scope="col">T0</th>
                                <th scope="col">T1</th>
                            </tr>
                        </thead>
                        <tbody id="grdCashbalance">
                        </tbody>
                	</table>
                </div>

                <h4 class="sec_title">Danh mục / Số dư chứng khoán</h4>
                <div class="price_table">
                    <table>
                        <caption>Số dư chứng khoán</caption>
                        <colgroup>
                            <col width="40" />
                            <col width="*" />
                            <col span="9" width="97" />
                        </colgroup>
                        <thead class="multi_row">
                            <tr>
                                <th rowspan="2" scope="col">STT</th>
                                <th rowspan="2" scope="col" class="center">Mã CK</th>
                                <th scope="col">Tổng cộng</th>
                                <th scope="col">Tạm giữ T0</th>
                                <th scope="col">Mua T1</th>
                                <th scope="col">Cầm cố</th>
                                <th scope="col">Chờ GD</th>
                                <th scope="col">Chờ rút</th>
                                <th scope="col">Giá TB</th>
                                <th scope="col">Giá trị mua</th>
                                <th scope="col">Lãi/Lỗ</th>
                            </tr>
                            <tr>
                                <th scope="col">Số dư GD</th>
                                <th scope="col">Mua T0</th>
                                <th scope="col">Mua T2</th>
                                <th scope="col">Tạm giữ</th>
                                <th scope="col">Chờ LK</th>
                                <th scope="col">Chờ THQ</th>
                                <th scope="col">Giá hiện tại</th>
                                <th scope="col">Giá trị thị trường</th>
                                <th scope="col">% Lãi/Lỗ</th>
                            </tr>
                        </thead>
                        <tbody id="grdPortfolio">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>