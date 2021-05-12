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
</style>
</head>
<script>
	$(document).ready(function() {
		getBankInformation();
	});
	
	function getBankInformation() {
		$("#tab22").block({message: "<span>LOADING...</span>"});
		$.ajax({
			dataType  : "json",
			cache: false,
			url       : "/trading/data/genenterorder.do",
			asyc      : true,
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
				loadBank	:	flag
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
								availableAdvance = (cashBalance < 0 ?  numDotComma(formatNumber(dataRow.mvAdvanceableAmount)) + cashBalance : 0);
								outstandingLoan  = 0;
								cashDeposit      = 0;
								sellingPortfolio = 0;
							} else {
								var withAbleAdvan = numDotComma(formatNumber(dataRow.mvWithdrawableAmount)) - numDotComma(formatNumber(dataRow.mvAdvanceableAmount));
								cashBalance       = (withAbleAdvan > 0 ? withAbleAdvan : 0);
								availableAdvance  = Math.min(numDotComma(formatNumber(dataRow.mvWithdrawableAmount)), numDotComma(formatNumber(dataRow.mvAdvanceableAmount)));
								outstandingLoan   = numDotComma(formatNumber(dataRow.mvOutstandingLoan));
								cashDeposit       = numDotComma(formatNumber(dataRow.mvSupplementCash));
								sellingPortfolio  = parseInt(numDotComma(formatNumber(dataRow.mvSupplementCash))) * 1.01 * (parseInt(numDotComma(formatNumber(dataRow.mvSupplementCash))) == 0 ? 0 : 1);
							}
	
							$("#tdBuyingPower").html(numIntFormat(numDotComma(formatNumber(dataRow.mvBuyingPowerd))));            // Buyingpower
							//$("#tdCashBalance").html(numIntFormat(cashBalance));                                    // Cash balance (withdrawable)
							$("#tdCashBalance").html(numIntFormat(numDotComma(formatNumber(dataRow.mvCashBalance))));                                    // Cash balance (withdrawable)
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
							//$("#tdMarginCall").html("모름");           // Margin call (By Options) <-- Todo 항목 확인 필요 -->
	
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
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab22").unblock();
			}
		});
	}
</script>
<div class="tab_content" style="margin-top:0px;">
	<div role="tabpanel" class="tab_pane" id="tab22">
		<!-- Balance -->		
		<div class="c_table_mini">
			<div class="grid_area radius_top margin_top_0" style="height:287px;overflow-x:auto;">
				<div class="group_table radius_top">
					<table class="table list_type_01">
						<colgroup>
							<col width="190" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Buying power" : "Sức mua tối đa") %></th>
								<td id="tdBuyingPower"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Cash balance<br />(withdrawable)" : "Số dư tiền mặt<br />(được rút)") %></th>
								<td id="tdCashBalance"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Withdrawable<br />(include advance)" : "Số dư được rút<br />(bao gồm ứng trước)") %></th>
								<td id="tdWithdrawable"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Available advance" : "Khả năng ứng trước") %></th>
								<td id="tdAvailableAdvance"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Temporary hold cash" : "Tiền tạm giữ") %></th>
								<td id="tdTemporaryHoldCash"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Hold for pending purchase" : "Tiền mua CK chờ khớp") %></th>
								<td id="tdPendingPurchase"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Hold for executed purchase" : "Tiền mua CK đã khớp") %></th>
								<td><span id="tdExecutedPurchase" class="row"></span></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Due Sell" : "Tiền bán CK chờ về") %></th>
								<td><span id="tdDueSell" class="row"></span></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Pending approval for withdrawal" : "Tiền (rút, chuyển khoản) chờ duyệt") %></th>
								<td id="tdPendingApproval"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Outstanding loan" : "Dư nợ ký quỹ") %></th>
								<td><span id="tdOutstandingLoan" class="low"></span></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Margin call (By Options)" : "Gọi bổ sung ký quỹ (Tùy chọn)") %></th>
								<td id="tdMarginCall"></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Cash Deposit" : "Nộp tiền mặt") %></th>
								<td><span id="tdCashDeposit" class="low"></span></td>
							</tr>
							<tr>
								<th style="color:#fff;background:#092d5e;" scope="row"><%= (langCd.equals("en_US") ? "Selling stock in margin portfolio" : "Bán CK trong danh mục ký quỹ") %></th>
								<td><span id="tdSellingPortfolio" class="row"></span></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!-- //Balance -->
	</div>
</div>
</HTML>