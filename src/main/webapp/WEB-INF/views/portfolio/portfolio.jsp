<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>

<!-- PIE Chart -->
<script src="https://www.amcharts.com/lib/3/amcharts.js"></script>
<script src="https://www.amcharts.com/lib/3/pie.js"></script>
<script src="https://www.amcharts.com/lib/3/plugins/export/export.min.js"></script>
<link rel="stylesheet" href="https://www.amcharts.com/lib/3/plugins/export/export.css" type="text/css" media="all" />
<script src="https://www.amcharts.com/lib/3/themes/light.js"></script>
<!-- End -->

<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	var dataChartProvider = [];
	$(document).ready(function() {
		document.title = "MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "PORTFOLIO" : "DANH MỤC ĐẦU TƯ") %>";
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		getPortFolio();
	});
	
	function createChart() {
		//console.log(dataChartProvider);
		var chart = AmCharts.makeChart( "chartdiv", {
			"hideCredits":true,
			"type": "pie",
			"theme": "light",
			"dataProvider": dataChartProvider,
			"valueField": "value",
			"titleField": "stock",
			"balloon":{
			"fixedPosition":'none'
			}			  
		} 
		);
	}

	function getPortFolio() {
		//console.log("PORT FOLIO CALL");
		$(".mdi_container").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};
		var accountBankHid = getCookieResign('accountBankHid');
				
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/enquiryportfolio.do",
			data      : param,
			cache: false,
			success   : function(data) {
				//console.log("데이터 확인+++++++++++++++++++++++++++++++");
				//console.log(data);
				var htmlStr    = "";
				var lendValue  = 0;
				var maintValue = 0;
				var accSum = 0;
				var minVal = 0;
				
				if(data.jsonObj != null) {
					if(data.jsonObj.errorCode == "HKSBOE99922") {												
						alert(data.jsonObj.errorMessage);
						$(".mdi_container").unblock();
						return;
					}					
					
					if(data.jsonObj.mvPortfolioAccSummaryBean != null) {
						accSum = data.jsonObj.mvPortfolioAccSummaryBean;
						// Summary
						$("#totalAsset").html(numIntFormat(Number(numDotComma(accSum.totalAsset)) + Number(accountBankHid)));
						$("#equity").html(numIntFormat(numDotComma(accSum.equity)));
						$("#stockValue").html(numIntFormat(numDotComma(accSum.stockValue)));
						$("#totalPL").html(numIntFormat(numDotComma(data.jsonObj.totalPL)));
						$("#PLPercent").html(accSum.PLPercent + "%");
						
						if(Number(accSum.PLPercent) > 0) {
							$("#totalPL").addClass("up");
							$("#PLPercent").addClass("up");
						} else if(Number(accSum.PLPercent) < 0) {
							$("#totalPL").addClass("low");
							$("#PLPercent").addClass("low");
						}
						
						// Cash information
						$("#cashBalance").html(numIntFormat(numDotComma(accSum.cashBalance)));
						if (accountBankHid != null && accountBankHid != "" && accountBankHid > -1){
							$("#cashBalance").html(numIntFormat(Number(accountBankHid)));
						}
						
						$("#mvAvailAdvanceMoney").html(numIntFormat(numDotComma(accSum.mvAvailAdvanceMoney)));
						$("#mvHoldAmount").html(numIntFormat(numDotComma(accSum.CTodayConfirmBuy)));
						$("#mvBuyHoldAmount").html(numIntFormat(numDotComma(accSum.mvBuyHoldAmount)));
						$("#pendingWithdrawal").html(numIntFormat(numDotComma(accSum.pendingWithdrawal)));
						$("#soldT0").html(numIntFormat(numDotComma(accSum.soldT0)));
						$("#soldT1").html(numIntFormat(numDotComma(accSum.soldT1)));
						//$("#soldT2").html(numIntFormat(numDotComma(accSum.soldT2)));
						$("#pendCashDev").html(numIntFormat(numDotComma(accSum.pendCashDiv)));

						// Portfolio assessment
						$("#totalAssetMaintenance").html(numIntFormat(numDotComma(accSum.totalAssetMaintenance)));
						$("#equityMar").html(numIntFormat(numDotComma(accSum.equityMar)));
						$("#stockMaintenance").html(numIntFormat(numDotComma(accSum.stockMaintenance)));
						$("#cashMaintenance").html(numIntFormat(numDotComma(accSum.cashMaintenance)));
						$("#outStandingLoan").html(numIntFormat(numDotComma(accSum.mvOutstandingLoan)));
						$("#debtIncByPurchase").html(numIntFormat(numDotComma(accSum.debtIncByPurchase)));
						$("#debitAccruedInterest").html(numIntFormat(numDotComma(accSum.debitAccruedInterest)));
						$("#creditLimit").html(numIntFormat(numDotComma(accSum.mvCreditLimit)));

						// Margin position
						$("#mvMarginValue").html(numIntFormat(numDotComma(accSum.mvMarginValue)));
						
						minVal	=	accSum.minMarginReq;
						if(minVal == null) {
							minVal	=	0;
						}
						
						$("#minMarginReq").html(Number(minVal) + "%");
						$("#curLiqMargin").html((accSum.curLiqMargin.length > 5 ? Number(accSum.curLiqMargin.substring(0, accSum.curLiqMargin.length - 1)) : Number(accSum.curLiqMargin)) + "%");
						$("#cashDeposit").html(numIntFormat(numDotComma(accSum.cashDeposit)));
						$("#sellStkInMarPort").html(numIntFormat(numDotComma(accSum.sellStkInMarPort)));
						$("#sellStkNotInMarPort").html(numIntFormat(numDotComma(accSum.sellStkNotInMarPort)));
					}
					
					if(data.jsonObj.mvPortfolioBeanList != null) {
						
						$("#grdPortfolio").replaceAll();
						
						var sortList = data.jsonObj.mvPortfolioBeanList.slice(0);
						sortList.sort(function(a,b) {
						    var x = a.mvStockID.toLowerCase();
						    var y = b.mvStockID.toLowerCase();
						    return x < y ? -1 : x > y ? 1 : 0;
						});						
						//console.log('List After sort:');
						//console.log(sortList);
						var rows = 1;
						for(var i=0; i < sortList.length; i++) {
							var rowData = sortList[i];
							var totalVolume = parseInt(numDotComma(rowData.mvTSettled)) - parseInt(numDotComma(rowData.mvPdSell));
							totalVolume    += (parseInt(numDotComma(rowData.mvTTodayConfirmBuy)) + parseInt(numDotComma(rowData.mvTTodayUnsettleBuy)));
							totalVolume    += parseInt(numDotComma(rowData.mvTT1UnsettleBuy)) + parseInt(numDotComma(rowData.mvTT2UnsettleBuy));
							totalVolume    += parseInt(numDotComma(rowData.mvTDueBuy)) + parseInt(numDotComma(rowData.mvTEntitlementQty)) - parseInt(numDotComma(rowData.mvTTodayConfirmSell));
							if (totalVolume == 0) {
								continue;
							}
							var t0Buy       = parseInt(numDotComma(rowData.mvTTodayConfirmBuy)) + parseInt(numDotComma(rowData.mvTTodayUnsettleBuy));
							var volumeHold  = parseInt(numDotComma(rowData.normalHold)) + parseInt(numDotComma(rowData.conditionalHold));
							lendValue      += parseInt(numDotComma(rowData.mvMartginValue));
							maintValue     += parseInt(numDotComma(rowData.maintenanceValue));

							htmlStr += "<tr style=\"cursor:pointer\" " + ((rows - 1) % 2 == 0 ? "" : "class='even'") + ">";							
							htmlStr += "	<td class=\"text_center\">" + rows + "</td>";           // No.
							htmlStr += "	<td onclick=\"portfolioOrder('" + trim(rowData.mvStockID) + "','" + trim(rowData.mvMarketID) + "');\" class=\"text_center\">" + rowData.mvStockID + "</td>"; // Stock
							htmlStr += "	<td>" + numIntFormat(totalVolume) + "</td>"; // Volume - Total volume
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTradableQty)) + "</td>"; // Volume - Usable
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvQueuingSell)) + "</td>"; // Volume - Hold in day
							htmlStr += "	<td>" + numIntFormat(t0Buy) + "</td>";   // Volume - T0 Buy
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTT1UnsettleBuy)) + "</td>"; // Volume - T1 Buy
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTDueBuy)) + "</td>";        // Volume - T2 Buy
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTMortgageQty)) + "</td>";   // Volume - Mortgage
							//htmlStr += "	<td>" + numIntFormat(volumeHold) + "</td>"; // Volume - Hold
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTAwaitingTraceCert)) + "</td>";   // Volume - Await trading
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTAwaitingDepositCert)) + "</td>"; // Volume - Await deposit
							//htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTAwaitingWithdrawalCert)) + "</td>"; // Volume - Await withdrawa
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTEntitlementQty)) + "</td>";         // Volume - Pend. entitlemen
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvAvgPrice)) + "</td>";    // Price - Avg. price
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvMarketPrice)) + "</td>"; // Price - Current price
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvWAC)) + "</td>";         // Portfolio Assessment - Buy value
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvMarketValue)) + "</td>"; // Portfolio Assessment - Market value
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvPL)) + "</td>";        // Portfolio Assessment - Profit/Loss
							
							if(Number(rowData.mvPLPercent.replace(/[,]/g, "")) > 0) {
								htmlStr	+=	"<td class=\"up\">";
							} else if(Number(rowData.mvPLPercent.replace(/[,]/g, "")) < 0) {
								htmlStr	+=	"<td class=\"low\">";
							} else {
								htmlStr	+=	"<td>";
							}
							
							htmlStr +=  rowData.mvPLPercent + "</td>"; // Portfolio Assessment - %Profit/Loss
							
							htmlStr += "	<td>" + numIntFormat(rowData.mvMarginPercentage) + "</td>"; // (%) Margin - %Lend.
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvMartginValue)) + "</td>"; // (%) Margin - Lending value
							htmlStr += "</tr>";
							rows ++;
							//Create data chart provider
							var dataObject = {"stock":trim(rowData.mvStockID), "value":numDotComma(rowData.mvMarketValue)};
		                    // add object to dataProvider array
		                    //dataChartProvider.push(dataObject);
						}

						$("#grdPortfolio").html(htmlStr);
						$("#tdLendValue").html(numIntFormat(lendValue));
						//createChart();
					}
					$(".mdi_container").unblock();
				} else {
					if ("<%= langCd %>" == "en_US") {
					 	alert("No Search Data"); 
					} else {
					 	alert("Không tìm thấy dữ liệu");
					}

					$(".mdi_container").unblock();
					
				}
			},
			error     :function(e) {
				console.log(e);
				$(".mdi_container").unblock();
			}
		});
	}
	function portfolioOrder(stock, marketID) {
		var param = {
				symbol              : stock,
				marketID            : marketID,
				divId               : "divPortfolioOrder"
		};

		$.ajax({
			type     : "POST",
			url      : "/margin/popup/portfolioOrder.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divPortfolioOrder").fadeIn();
				$("#divPortfolioOrder").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function formatNumber(num) {
		if(num.indexOf('.') != -1) {
			var priceSpl = num.split(".");
			if(priceSpl[1].length == 1) {
				num = priceSpl[0] + "." + priceSpl[1] + "00";
			} else if (priceSpl[1].length == 2) {
				num = priceSpl[0] + "." + priceSpl[1] + "0";
			}
		}
		return num;
	}
</script>

<style>
#chartdiv {
  width: 50%;
  height: 500px;
  margin-top: -70px;
  margin-left: -100px;
  margin-bottom: -70px;
}
</style>

</head>
<body class="mdi">
	<div>
		<!-- 템플릿 사용부분 -->
		<div class="mdi_container">
			<div>			
			<h3 class="tit bg"><%= (langCd.equals("en_US") ? "Cash" : "Tiền") %><a href="/wts/view/portfolio.do"  class="btn_rescan_port"></a></h3>
			</div>			
			<div class="cash_wrap margin_top_0">
				<div class="group_table cash1 radius_top">
					<table class="table no_bbt list_type_01">
						<colgroup>
							<col width="160" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Summary" : "Tổng quan") %></th>
								<th><%= (langCd.equals("en_US") ? "Value(VND)" : "Giá trị(VND)") %></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Total asset" : "Tổng tài sản") %></th>
								<td id="totalAsset"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Net Asset" : "Tài sản thực có") %></th>
								<td id="equity"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Total stock market value" : "Tổng giá trị chứng khoán") %></th>
								<td id="stockValue"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Profit/Loss" : "Lãi/lỗ") %></th>
								<td id="totalPL"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "%Profit/Loss (per equity)" : "% Lãi/lỗ (trên tài sản thực có)") %></th>
								<td id="PLPercent" class=""></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="group_table cash2 radius_top">
					<table class="table no_bbt list_type_01">
						<colgroup>
							<col width="160" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Cash information" : "Thông tin tài khoản tiền") %></th>
								<th><%= (langCd.equals("en_US") ? "Value(VND)" : "Giá trị(VND)") %></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Cash balance (withdrawable)" : "Số dư được rút (bao gồm ứng trước)") %></th>
								<td id="cashBalance"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Cash advanceable" : "Số dư ứng trước") %></th>
								<td id="mvAvailAdvanceMoney"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Hold for executed purchase" : "Tiền mua CK đã khớp") %></th>
								<td id="mvHoldAmount"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Hold for pending purchase" : "Tiền mua CK chờ khớp") %></th>
								<td id="mvBuyHoldAmount"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Pending approval for withdrawal" : "Tiền (rút, chuyển khoản) chờ duyệt") %></th>
								<td id="pendingWithdrawal"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="group_table cash3 radius_top">
					<table class="table no_bbt list_type_01">
						<colgroup>
							<col width="160" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Cash Status" : "Trạng thái tiền") %></th>
								<th><%= (langCd.equals("en_US") ? "Value(VND)" : "Giá trị(VND)") %></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Sold T+0" : "Tiền bán T+0") %></th>
								<td id="soldT0"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Sold T+1" : "Tiền bán T+1") %></th>
								<td id="soldT1"></td>
							</tr>
							<%-- <tr>
								<th><%= (langCd.equals("en_US") ? "Sold T+2" : "Tiền bán T+2") %></th>
								<td id="soldT2"></td>
							</tr> --%>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Pending Cash Dividend" : "Cổ tức tiền chờ về") %></th>
								<td id="pendCashDev"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Debt increased by purchase" : "Tăng nợ do lệnh mua") %></th>
								<td id="debtIncByPurchase" class="low"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Credit limit" : "Hạn mức tín dụng") %></th>
								<td id="creditLimit" class="low"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="group_table cash4 radius_top">
					<table class="table no_bbt list_type_01">
						<colgroup>
							<col width="160" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Margin position" : "Trạng thái kỹ quỹ") %></th>
								<th><%= (langCd.equals("en_US") ? "Value(VND)" : "Giá trị(VND)") %></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Lendable value" : "Khả năng vay ký quỹ") %></th>
								<td id="mvMarginValue"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Minimum margin requirement" : "Tỷ lệ ký quỹ tối thiểu bắt buộc") %></th>
								<td id="minMarginReq"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Current liquidating margin" : "Tỷ lệ ký quỹ hiện tại") %></th>
								<td id="curLiqMargin" class="up"></td>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Outstanding loan" : "Dư nợ ký quỹ") %></th>
								<td id="outStandingLoan" class="low"></td>
							</tr>
							
							<tr>
								<th><%= (langCd.equals("en_US") ? "Accured debit interest" : "Lãi vay cộng dồn") %></th>
								<td id="debitAccruedInterest" class="low"></td>
							</tr>							
						</tbody>
					</table>
				</div>
			</div>
			<div class="search_area in">				
				<div class="pull_right;" style="display: none;">
					<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label><input id="fromSearch" type="text" class="datepicker" placeholder="13/05/2016">
					<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label><input id="toSearch" type="text" class="datepicker" placeholder="13/05/2016">
					<button class="btn" type="button">Search</button>
				</div>
			</div>
			<h3 class="tit bg"><%= (langCd.equals("en_US") ? "Stock" : "Chứng khoán") %></h3>
			<div class="grid_area margin_top_0 radius_top" style="height:100%;">
				<div class="group_table double radius_top">
					<%--
					<table class="table">
						<thead>
							<tr>
								<th rowspan="3"><%= (langCd.equals("en_US") ? "No." : "STT") %></th>
								<th rowspan="3"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th class="bd_bt2" colspan="6"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
								<th class="bd_bt2" colspan="4"><%= (langCd.equals("en_US") ? "Portfolio Assessment" : "Đánh giá danh mục") %></th>
								<th class="bd_bt2" colspan="2"><%= (langCd.equals("en_US") ? "(%) Margin" : "(%) Ký quỹ") %></th>
							</tr>
							<tr>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Total volume" : "Tổng khối lượng") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Hold in day" : "Số dư khoanh giữ") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "T1 Buy" : "Mua T1") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Mortgage" : "Cầm cố") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Await trading" : "Chờ giao dịch") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Await<br> withdrawa" : "Chờ rút") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Avg. price" : "Giá TB") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Buy value" : "Giá trị mua") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Profit/Loss" : "Lãi/Lỗ") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Total<br>Profit/Loss" : "Tổng Lãi/Lỗ") %></th>
								<th class="bd_bt2" rowspan="2"><%= (langCd.equals("en_US") ? "TotalEvaluation Amount" : "Tổng giá trị ước tính") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "%Lend." : "% Cho vay") %></th>
								<th class="bd_bt2"><%= (langCd.equals("en_US") ? "%Maint." : "% Đảm bảo") %></th>
							</tr>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Usable" : "Số dư GD") %></th>
								<th><%= (langCd.equals("en_US") ? "T0 Buy" : "Mua T0") %></th>
								<th><%= (langCd.equals("en_US") ? "T2 Buy" : "Mua T2") %></th>
								<th><%= (langCd.equals("en_US") ? "Hold" : "Phong tỏa (BT+ĐK)") %></th>
								<th><%= (langCd.equals("en_US") ? "Await deposit" : "Chờ lưu ký") %></th>
								<th><%= (langCd.equals("en_US") ? "Pend. entitlemen" : "Chờ THQ") %></th>
								<th><%= (langCd.equals("en_US") ? "Current price" : "Giá hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "Market value" : "Giá trị thị trường") %></th>
								<th><%= (langCd.equals("en_US") ? "%Profit/Loss" : "% Lãi/Lỗ") %></th>
								<th><%= (langCd.equals("en_US") ? "Total<br>%Profit/Loss" : "Tổng % Lãi/Lỗ") %></th>
								<th><%= (langCd.equals("en_US") ? "Lending value" : "Khả năng vay") %></th>
								<th><%= (langCd.equals("en_US") ? "Maintenance value" : "Giá trị đảm bảo") %></th>
							</tr>
						</thead>
						<tfoot>
							<tr class="bd_t1">
								<th class="bd_bt0" rowspan="2" colspan="11"><%= (langCd.equals("en_US") ? "Total" : "Tổng") %></th>
								<td class="text_center">000</td>
								<td class="bd_bt0 text_center" rowspan="2">000</td>
								<td class="text_center">000</td>
								<td class="text_center">000</td>
							</tr>
							<tr>
								<td class="bd_bt0 text_center">000</td>
								<td class="bd_bt0" id="tdLendValue"></td>
								<td class="bd_bt0" id="tdMaintValue"></td>
							</tr>
						</tfoot>
						<tbody id="grdPortfolio">
						</tbody>
					</table>
					--%>
					<table class="table">
						<thead>
							<tr>
								<th rowspan="2"><%= (langCd.equals("en_US") ? "No." : "STT") %></th>
								<th rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th colspan="10"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
								<th colspan="2"><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
								<th colspan="4"><%= (langCd.equals("en_US") ? "Portfolio Assessment" : "Đánh giá danh mục") %></th>
								<th colspan="4"><%= (langCd.equals("en_US") ? "(%) Margin" : "(%) Ký quỹ") %></th>
							</tr>
							<tr>
							<%-- 
								<th><%= (langCd.equals("en_US") ? "Total</BR>volume" : "Tổng khối lượng") %></th>
								<th><%= (langCd.equals("en_US") ? "Usable" : "Số dư GD") %></th>
								<th><%= (langCd.equals("en_US") ? "Hold</BR>in day" : "Số dư khoanh giữ") %></th>
								<th><%= (langCd.equals("en_US") ? "T0 Buy" : "Mua T0") %></th>
								<th><%= (langCd.equals("en_US") ? "T1 Buy" : "Mua T1") %></th>
								<th><%= (langCd.equals("en_US") ? "T2 Buy" : "Mua T2") %></th>
								<th><%= (langCd.equals("en_US") ? "Mortgage" : "Cầm cố") %></th>
								<th><%= (langCd.equals("en_US") ? "Hold" : "Phong tỏa (BT+ĐK)") %></th>
								<th><%= (langCd.equals("en_US") ? "Await</BR>trading" : "Chờ giao dịch") %></th>
								<th><%= (langCd.equals("en_US") ? "Await</BR>deposit" : "Chờ lưu ký") %></th>
								<th><%= (langCd.equals("en_US") ? "Await</BR> withdrawa" : "Chờ rút") %></th>
								<th><%= (langCd.equals("en_US") ? "Pend.</BR>entitlemen" : "Chờ THQ") %></th>
								<th><%= (langCd.equals("en_US") ? "Avg. price" : "Giá TB") %></th>
								<th><%= (langCd.equals("en_US") ? "Current</BR>price" : "Giá hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "Buy value" : "Giá trị mua") %></th>
								<th><%= (langCd.equals("en_US") ? "Market value" : "Giá trị thị trường") %></th>
								<th><%= (langCd.equals("en_US") ? "Profit/Loss" : "Lãi/Lỗ") %></th>
								<th><%= (langCd.equals("en_US") ? "%Profit/Loss" : "% Lãi/Lỗ") %></th>
								<th><%= (langCd.equals("en_US") ? "Total Profit/Loss" : "Tổng Lãi/Lỗ") %></th>
								<th><%= (langCd.equals("en_US") ? "Total %Profit/Loss" : "Tổng % Lãi/Lỗ") %></th>
								<th><%= (langCd.equals("en_US") ? "Total Evaluation Amount" : "Tổng giá trị ước tính") %></th>
								<th><%= (langCd.equals("en_US") ? "%Lend." : "% Cho vay") %></th>
								<th><%= (langCd.equals("en_US") ? "Lending value" : "Khả năng vay") %></th>
								<th><%= (langCd.equals("en_US") ? "%Maint." : "% Đảm bảo") %></th>
								<th><%= (langCd.equals("en_US") ? "Maintenance value" : "Giá trị đảm bảo") %></th>
							 --%>	
							 	<th><%= (langCd.equals("en_US") ? "Total<BR/>volume" : "Tổng<BR/>khối lượng") %></th>
								<th><%= (langCd.equals("en_US") ? "Usable" : "Số dư GD") %></th>
								<th><%= (langCd.equals("en_US") ? "Hold<BR/>in day" : "Số dư<BR/>khoanh giữ") %></th>
								<th><%= (langCd.equals("en_US") ? "T0 Buy" : "Mua T0") %></th>
								<th><%= (langCd.equals("en_US") ? "T1 Buy" : "Mua T1") %></th>
								<th><%= (langCd.equals("en_US") ? "T2 Buy" : "Mua T2") %></th>
								<th><%= (langCd.equals("en_US") ? "Mortgage" : "Cầm cố") %></th>
								<th><%= (langCd.equals("en_US") ? "Await<BR/>trading" : "Chờ<BR/>giao dịch") %></th>
								<th><%= (langCd.equals("en_US") ? "Await<BR/>deposit" : "Chờ<BR/>lưu ký") %></th>
								<th><%= (langCd.equals("en_US") ? "Pend.<BR/>entitlement" : "Chờ<BR/>THQ") %></th>
								<th><%= (langCd.equals("en_US") ? "Avg. price" : "Giá TB") %></th>
								<th><%= (langCd.equals("en_US") ? "Current<BR/>price" : "Giá<BR/>hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "Buy value" : "Giá trị mua") %></th>
								<th><%= (langCd.equals("en_US") ? "Market value" : "Giá trị thị trường") %></th>
								<th><%= (langCd.equals("en_US") ? "P/L" : "Lãi/Lỗ") %></th>
								<th><%= (langCd.equals("en_US") ? "%<BR/>P/L" : "%<BR/>Lãi/Lỗ") %></th>
								
								<th><%= (langCd.equals("en_US") ? "%Lend." : "%<BR/> Cho vay") %></th>
								<th><%= (langCd.equals("en_US") ? "Lending value" : "Khả năng vay") %></th>								
							</tr>
						</thead>
						<tfoot>
							<tr class="bd_t1">
								<th colspan="18"><%= (langCd.equals("en_US") ? "Total" : "Tổng") %></th>
								<td colspan="2" id="tdLendValue"></td>								
							</tr>
						</tfoot>
						<tbody id="grdPortfolio">
						</tbody>
					</table>
				</div>
			</div>
			<!--
			<h3 class="tit bg"><%= (langCd.equals("en_US") ? "SHARE YOUR LIST" : "TỶ TRỌNG DANH MỤC") %></h3>
			<div id="chartdiv"></div>
			-->
		</div>
		<!-- //템플릿 사용부분 -->		
  	</div>  	
  	<div id="divPortfolioOrder" class="modal_wrap"></div>  	
</body>
</html>