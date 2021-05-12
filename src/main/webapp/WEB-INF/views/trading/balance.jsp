<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
	        response.setHeader("Cache-Control", "no-cache");
	response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Content-Style-Type" content="text/css"/>
		<meta http-equiv="Cache-Control" content="no-cache" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="-1" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />


<style>
.label_balance1 {position:relative;display:inline-block;height:20px;line-height:20px;vertical-align:middle;color:#666;background: #d9d9d9;border: 1px solid #d7d7d7;margin-left:10px;padding:0 3px 0 3px;}
.label_balance2 {position:relative;display:inline-block;height:20px;line-height:20px;vertical-align:middle;color:#666;border: 1px solid #d7d7d7;margin:0;padding:0 5px 0 10px;}
</style>
</head>
<script>
	$(document).ready(function() {
		//getAccountbalance();
		getBankInformation();
	});
	
	
	function getBankInformation() {
		$("#tab22").block({message: "<span>LOADING...</span>"});
		var param	=	{
				mvSubAccountID	:	"<%= session.getAttribute("subAccountID") %>"
		};
		$.ajax({
			dataType  : "json",
			cache: false,
			url       : "/trading/data/genenterorder.do",
			asyc      : true,
			data	  : param,
			success   : function(data) {
				//console.log("GET RESULT ENTER ORDER");
				//console.log(data);
				if(data.jsonObj != null) {					
					var flag	=	false;
					for(var i = 0; i < data.jsonObj.mvSettlementAccList.length; i++) {
						var obj	=	data.jsonObj.mvSettlementAccList[i];
						if(obj.mvBankID != "" ) {
							flag	=	true;
						}
					}
					
					if(flag) {
						getAccountbalance(true);
					} else {
						getAccountbalance(false);
					}
				}
				$("#tab22").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab22").unblock();
			}
		});
	}

	function getAccountbalance(flag) {
		$("#tab22").block({message: "<span>LOADING...</span>"});		
		
		var param	=	{
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				loadBank		:	flag
		};

		$.ajax({
			dataType  : "json",			
			url       : "/margin/data/accountbalance.do",
			cache: false,
			data	  : param,
			asyc      : true,
			success   : function(data) {
				//console.log("CHECK THE BALANCE");
				//console.log(data);
				$("#tab22").unblock();
				if(data.jsonObj != null) {
					if(data.jsonObj.mvList != null) {
						var dataRow = data.jsonObj.mvList[0];
						if (flag == false) {							
							var cashBalance      = "";
							var availableAdvance = "";
							var outstandingLoan  = "";
							var cashDeposit      = "";
							var sellingPortfolio = "";
							if(dataRow.mvAccountType != "M") {
								cashBalance      = numDotComma(formatNumber(dataRow.mvCSettled)) - numDotComma(formatNumber(dataRow.mvPendingBuy)) - numDotComma(formatNumber(dataRow.mvPendingWithdraw)) - numDotComma(formatNumber(dataRow.mvHoldingAmt));
								//availableAdvance = (cashBalance < 0 ?  numDotComma(formatNumber(dataRow.mvAdvanceableAmount)) + cashBalance : 0);
								availableAdvance = numDotComma(formatNumber(dataRow.mvAdvanceableAmount));
								outstandingLoan  = 0;
								cashDeposit      = 0;
								sellingPortfolio = 0;
							} else {
								var withAbleAdvan = numDotComma(formatNumber(dataRow.mvWithdrawableAmount)) - numDotComma(formatNumber(dataRow.mvAdvanceableAmount));
								cashBalance       = (withAbleAdvan > 0 ? withAbleAdvan : 0);
								//availableAdvance  = Math.min(numDotComma(formatNumber(dataRow.mvWithdrawableAmount)), numDotComma(formatNumber(dataRow.mvAdvanceableAmount)));
								availableAdvance  = numDotComma(formatNumber(dataRow.mvAdvanceableAmount));
								outstandingLoan   = numDotComma(formatNumber(dataRow.mvOutstandingLoan));
								cashDeposit       = numDotComma(formatNumber(dataRow.mvSupplementCash));
								sellingPortfolio  = numDotComma(formatNumber(dataRow.mvMaintenanceCall));
							}
	
							$("#tdBuyingPower").html(numIntFormat(numDotComma(formatNumber(dataRow.mvBuyingPowerd))));            // Buyingpower
							//$("#tdCashBalance").html(numIntFormat(cashBalance));                                    // Cash balance (withdrawable)
							//$("#tdCashBalance").html(numIntFormat(numDotComma(formatNumber(dataRow.mvCashBalance))));      
							$("#tdCashBalance").html(numIntFormat(numDotComma(formatNumber(dataRow.mvCashMaintenance))));  // Cash balance (withdrawable)
							$("#tdWithdrawable").html(numIntFormat(numDotComma(formatNumber(dataRow.mvWithdrawableAmount))));     // Withdrawable (include advance)
	
							//$("#tdAvailableAdvance").html(numIntFormat(availableAdvance));                          // Available advance
							$("#tdAvailableAdvance").html(numIntFormat(numDotComma(formatNumber(dataRow.mvAdvanceableAmount))));                          // Available advance
							$("#tdTemporaryHoldCash").html(numIntFormat(numDotComma(formatNumber(dataRow.mvTemporaryHoldCash)))); // Temporary hold cash
	
							//$("#tdPendingPurchase").html(numIntFormat(numDotComma(dataRow.mvPendingSettled)));      // Hold for pending purchase
							//$("#tdExecutedPurchase").html(numIntFormat(numDotComma(dataRow.mvHoldingAmt)));     // Hold for executed purchase <-- Todo 항목 확인 필요 -->
							
							$("#tdPendingPurchase").html(numIntFormat(numDotComma(formatNumber(dataRow.mvBuyHoldAmount))));      // Hold for pending purchase
							$("#tdExecutedPurchase").html(numIntFormat(numDotComma(formatNumber(dataRow.mvPendingSettled))));     // Hold for executed purchase <-- Todo 항목 확인 필요 -->
							
							
							$("#tdPendingApproval").html(numIntFormat(numDotComma(formatNumber(dataRow.mvPendingWithdraw))));     // Pending approval for withdrawal
	
							$("#tdOutstandingLoan").html(numIntFormat(outstandingLoan));                            // Outstanding loan
							$("#tdMarginCall").html(numIntFormat(numDotComma(formatNumber(dataRow.mvMarginCall))));           // Margin call (By Options) <-- Todo 항목 확인 필요 -->
	
							$("#tdCashDeposit").html(numIntFormat(cashDeposit));                                    // Cash Deposit
							$("#tdSellingPortfolio").html(numIntFormat(sellingPortfolio));                          // Selling stock in margin portfolio
						} else { //back account
							$("#tdBuyingPower").html(numIntFormat(numDotComma(formatNumber(dataRow.mvBuyingPowerd))));            // Buyingpower
							$("#tdCashBalance").html(numIntFormat(numDotComma(formatNumber(dataRow.mvBuyingPowerd))));            // Cash balance (withdrawable)
							$("#tdPendingPurchase").html(numIntFormat(numDotComma(formatNumber(dataRow.mvBuyHoldAmount))));      // Hold for pending purchase
							$("#tdExecutedPurchase").html(numIntFormat(numDotComma(formatNumber(dataRow.mvPendingSettled))));     // Hold for executed purchase
							$("#tdDueSell").html(numIntFormat(numDotComma(formatNumber(dataRow.mvDueSell))));     // Due Sell
						}
					}
					getStockInfoList();
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab22").unblock();
			}
		});
	}

	function getStockInfoList() {
		$("#tab22").block({message: "<span>LOADING...</span>"});
		
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/enquiryportfolio.do",
			data      : param,
			cache: false,
			success   : function(data) {
				//console.log("데이터 확인+++++++++++++++++++++++++++++++");
				//console.log(data);
				if(data.jsonObj != null) {
					if(data.jsonObj.mvPortfolioAccSummaryBean != null) {
						var accSum = data.jsonObj.mvPortfolioAccSummaryBean;
						
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
					}
					if(data.jsonObj.mvPortfolioBeanList != null) {
						var htmlStr    = "";
						$("#grdStockBal").find("tr").remove();
						
						var sortList = data.jsonObj.mvPortfolioBeanList.slice(0);
						sortList.sort(function(a,b) {
						    var x = a.mvStockID.toLowerCase();
						    var y = b.mvStockID.toLowerCase();
						    return x < y ? -1 : x > y ? 1 : 0;
						});
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
							var tdSell 		= parseInt(numDotComma(rowData.mvTTodayConfirmSell)) + parseInt(numDotComma(rowData.mvTTodayUnsettleSell));
							
							htmlStr += "<tr style=\"cursor:pointer\" onclick=\"balanceItem('" + rowData.mvStockID + "');\"" + (i % 2 == 0 ? "" : "class='even'") + ">";	
							htmlStr += "	<td class=\"text_center\">" + rowData.mvStockID + "</td>"; // Stock Code
							htmlStr += "	<td>" + numIntFormat(totalVolume) + "</td>"; // Volume - Total volume
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTradableQty)) + "</td>"; // Volume - Usable
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvAvgPrice)) + "</td>";    // Price - Avg. price
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvMarketPrice)) + "</td>"; // Price - Current price
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvPL)) + "</td>";        // Portfolio Assessment - Profit/Loss							
							if(Number(rowData.mvPLPercent.replace(/[,]/g, "")) > 0) {
								htmlStr	+=	"<td class=\"up\">";
							} else if(Number(rowData.mvPLPercent.replace(/[,]/g, "")) < 0) {
								htmlStr	+=	"<td class=\"low\">";
							} else {
								htmlStr	+=	"<td>";
							}							
							htmlStr +=  rowData.mvPLPercent + "</td>"; // Portfolio Assessment - %Profit/Loss
							
							htmlStr += "	<td>" + numIntFormat(t0Buy) + "</td>";   // Volume - Today Buy
							htmlStr += "	<td>" + numIntFormat(tdSell) + "</td>";   // Volume - Today Sell
							
							htmlStr += "</tr>";							
						}

						$("#grdStockBal").html(htmlStr);
					}
					$("#tab22").unblock();
				} else {
					if ("<%= langCd %>" == "en_US") {
					 alert("No Search Data"); 
					} else {
					 alert("Không tìm thấy dữ liệu");
					}
					$("#tab22").unblock();
					
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab22").unblock();
			}
		});
	}

	function balanceItem(rcod) {
		$('#selltab a[href="/trading/view/entersell.do"]').trigger('click');
		$("#tab31").find("span[name='bid_rcod']").html(rcod);
		trdSelItem(rcod, "");
	}
	
	function formatNumber(num) {
		if(num.indexOf('.') != -1) {
			var priceSpl = num.split(".");
			if(priceSpl[1].length == 1) {
				num = priceSpl[0] + "." + priceSpl[1] + "00";
			} else if (priceSpl[1].length == 2) {
				num = priceSpl[0] + "." + priceSpl[1] + "0";
			} else if (priceSpl[1].length > 3) {
				num = parseFloat(num.replace(/,/g,'')).toFixed(3);
			}
		} else {
			num = num + ".000" ;
		}
		return num;
	}
</script>
<div class="tab_content">
	<div role="tabpanel" class="tab_pane" id="tab22">
		<!-- Balance -->
		<div class="c_table">
			<h3 class="tit"><%= (langCd.equals("en_US") ? "Cash" : "Tiền") %></h3>
			<div class="grid_area radius_top margin_top_0" style="height:390px;overflow-y:hidden;overflow-x:auto;">
				<div class="group_table radius_top">
					<table class="table list_type_01">
						<colgroup>
							<col width="190" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Buying power" : "Sức mua tối đa") %></th>
								<td id="tdBuyingPower"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Buying Power<br />by Cash (sub M)" : "Sức mua tiền mặt (đv Sub M)") %></th>
								<td id="tdCashBalance"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Withdrawable<br />(include advance)" : "Số dư được rút<br />(bao gồm ứng trước)") %></th>
								<td id="tdWithdrawable"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Available advance" : "Khả năng ứng trước") %></th>
								<td id="tdAvailableAdvance"></td>
							</tr>
							<!--  
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Temporary hold cash" : "Tiền tạm giữ") %></th>
								<td id="tdTemporaryHoldCash"></td>
							</tr>
							-->
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Hold for pending purchase" : "Tiền mua CK chờ khớp") %></th>
								<td id="tdPendingPurchase"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Hold for executed purchase" : "Tiền mua CK đã khớp") %></th>
								<td><span id="tdExecutedPurchase" class="row"></span></td>
							</tr>
							<!--  
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Due Sell" : "Tiền bán CK chờ về") %></th>
								<td><span id="tdDueSell" class="row"></span></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Pending approval for withdrawal" : "Tiền (rút, chuyển khoản) chờ duyệt") %></th>
								<td id="tdPendingApproval"></td>
							</tr>
							-->
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Outstanding loan" : "Dư nợ ký quỹ") %></th>
								<td><span id="tdOutstandingLoan" class="low"></span></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Margin call (By Options)" : "Gọi bổ sung ký quỹ (Tùy chọn)") %></th>
								<td id="tdMarginCall"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash Deposit" : "Nộp tiền mặt") %></th>
								<td><span id="tdCashDeposit" class="low"></span></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Selling stock out margin portfolio" : "Bán CK ngoài danh mục ký quỹ") %></th>
								<td><span id="tdSellingPortfolio" class="row"></span></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="s_table">			
			<div style="height:35px; border: 1px solid #d7d7d7; border-bottom: none; border-radius: 3px 3px 0 0;line-height: 35px;">
			<label style="color:#666666;font-weight: 600;"><%= (langCd.equals("en_US") ? "Stock" : "CK") %></label>
			<label class="label_balance1"><%= (langCd.equals("en_US") ? "Stock value" : "Giá trị CK") %>			
			</label>
			<label class="label_balance2" id="stockValue"></label>
			<label class="label_balance1"><%= (langCd.equals("en_US") ? "P/L" : "Lãi/Lỗ") %>
			</label>
			<label class="label_balance2" id="totalPL"></label>
			<label class="label_balance1"><%= (langCd.equals("en_US") ? "%P/L" : "%Lãi/Lỗ") %>			
			</label>
			<label class="label_balance2" id="PLPercent"></label>
			</div>
			<div class="grid_area radius_top margin_top_0" style="height:390px;">
				<div class="group_table type2 radius_top">
					<table class="table ">
						<colgroup>
							<col />
							<col width="12%" />
							<col width="12%" />
							<col width="12%" />
							<col width="12%" />
							<col width="16%" />
							<col width="8%" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Portfolio Assessment" : "Đánh giá danh mục") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Trade in day" : "Giao dịch trong ngày") %></th>
							</tr>
							<tr>
								<th scope="col"><%= (langCd.equals("en_US") ? "Total" : "Tổng KL") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Usable" : "Số dư GD") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Avg." : "Giá TB") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "P/L" : "Lãi/Lỗ") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "% P/L" : "% Lãi/Lỗ") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Bought" : "Đã mua") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Sold" : "Đã bán") %></th>
							</tr>
						</thead>
						<tbody id="grdStockBal">
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!-- //Balance -->
	</div>
</div>
</HTML>