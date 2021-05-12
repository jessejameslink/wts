<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {
		getOverduedebt();
		getPortFolio();
	});
	
	function getOverduedebt() {
		$("#tab3").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		}
		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/overduedebt.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				if(data.jsonObj != null) {
					if(data.jsonObj.overdueDebt != null) {
						$("#tdOverdueDebt").html(numIntFormat(parseInt(data.jsonObj.overdueDebt.overdueDebt * 1000)));
						$("#tdProcessingDebt").html(numIntFormat(parseInt(data.jsonObj.overdueDebt.processedDebt * 1000)));
						$("#tdCashAdvanceRequest").html(numIntFormat(parseInt(data.jsonObj.overdueDebt.advanceRequest * 1000)));
						$("#tdCashSupplementRequest").html(numIntFormat(parseInt(data.jsonObj.overdueDebt.cashSupplement * 1000)));
						$("#tdSellStockRequest").html(numIntFormat(parseInt(data.jsonObj.overdueDebt.sellStockRequest * 1000)));
						$("#tdForceSell").html(numIntFormat(parseInt(data.jsonObj.overdueDebt.forceSell * 1000)));
						$("#tdForceSelldays").html(numIntFormat(parseInt(data.jsonObj.overdueDebt.forceSellDays)) + " days");
					}
				}
				$("#tab3").unblock();
				getUpcomingdebt();
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
	}

	function getUpcomingdebt() {
		$("#tab3").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		}
		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/upcomingdebt.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				if(data.jsonObj != null) {
					var upcomingDebt = "";
					if(data.jsonObj.upcomingDebt != null) {
						for(var i=0; i < data.jsonObj.upcomingDebt.length; i++) {
							var upDebt = data.jsonObj.upcomingDebt[i];
							upcomingDebt += "<li>";
							upcomingDebt += "	<span class=\"date\">" + upDebt.Date + "</span>";
							upcomingDebt += "	<span class=\"value\">" + numIntFormat(parseInt(upDebt.Value * 1000)) + "</span>";
							upcomingDebt += "</li>";
						}
					}

					$("#trUpcomingDebt").html(upcomingDebt);
				}
				$("#tab3").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
	}
	
	function getPortFolio() {
		$(".tab3").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/enquiryportfolio.do",
			data      : param,
			success   : function(data) {
				//console.log("PORT DATA");
				//console.log(data);
				if(data.jsonObj != null) {
					var accSum = data.jsonObj.mvPortfolioAccSummaryBean;
					$("#tdEnquity").html(numIntFormat(numDotComma(accSum.equity)));
					$("#tdTotalAsset").html(numIntFormat(numDotComma(accSum.totalAsset)));
					$("#tdTotalCash").html(numIntFormat(numDotComma(accSum.cashBalance)));
					$("#tdStockAmount").html(numIntFormat(numDotComma(accSum.stockValue)));
				}
				$(".tab3").unblock();
			},
			error     :function(e) {
				console.log(e);
				$(".tab3").unblock();
			}
		});
	}
	
</script>
<div class="tab_content account">
	<!-- Asset/Margin Information -->
	<div role="tabpanel" class="tab_pane" id="tab3">
		<div class="group_table">
			<table class="table no_bbt list_type_01">
				<caption class="hidden">Asset Margin Information Table</caption>
				<colgroup>
					<col width="14.5%">
					<col width="12%">
					<col width="19%">
					<col width="12%">
					<col width="14.5%">
					<col width="12%">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Asset Information" : "Thông tin tài sản") %></th>
						<th scope="colgroup" colspan="5"><%= (langCd.equals("en_US") ? "Margin Informaion" : "Thông tin ký quỹ") %></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="row" class="strong"><%= (langCd.equals("en_US") ? "Net Asset" : "Tài sản ròng") %></th>
						<td id="tdEnquity">0</td>
						<th scope="row" class="strong"><%= (langCd.equals("en_US") ? "Stock amount on margin" : "Giá trị chứng khoán ký quỹ") %></th>
						<td>0</td>
						<th scope="colgroup" colspan="2" class="strong text_center tit_list"><%= (langCd.equals("en_US") ? "OVERDUE DEBT" : "NỢ QUÁ HẠN") %></th>
						<th scope="col" class="strong text_center tit_list"><%= (langCd.equals("en_US") ? "UPCOMING DEBT" : "NỢ SẮP ĐẾN HẠN") %></th>
					</tr>
					<tr>
						<th scope="row" class="strong"><%= (langCd.equals("en_US") ? "Total Asset" : "Tổng tài sản") %></th>
						<td id="tdTotalAsset">0</td>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Available stock volume" : "Số lượng chứng khoán hiện có") %></th>
						<td>0</td>
						<th scope="row" class="inner_th"><%= (langCd.equals("en_US") ? "Overdue Debt" : "Nợ quá hạn") %></th>
						<td id="tdOverdueDebt"></td>
						<td rowspan="8" class="uc_debt">
							<ul id="trUpcomingDebt" class="uc_debt_list">
							</ul>
						</td>
					</tr>
					<tr>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Total Cash" : "Tiền mặt") %></th>
						<td id="tdTotalCash">0</td>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Wait volume for buying settlement" : "Số lượng chứng khoán chờ về") %></th>
						<td>0</td>
						<th scope="row" class="inner_th"><%= (langCd.equals("en_US") ? "Processing Debt" : "Nợ phải xử lý") %></th>
						<td id="tdProcessingDebt"></td>
					</tr>
					<tr>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Unavailable Cash" : "Tiền chờ về") %></th>
						<td>0</td>
						<th scope="row" class="strong"><%= (langCd.equals("en_US") ? "Evaluation amount" : "Giá trị tạm tính") %></th>
						<td>0</td>
						<th scope="row" class="inner_th"><%= (langCd.equals("en_US") ? "Cash Advance Request" : "Yêu cầu ứng trước tiền bán") %></th>
						<td id="tdCashAdvanceRequest"></td>
					</tr>
					<tr>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Dividend" : "Cổ tức") %></th>
						<td>0</td>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Available stock volume" : "Số lượng chứng khoán hiện có") %></th>
						<td>0</td>
						<th scope="row" class="inner_th"><%= (langCd.equals("en_US") ? "Cash Supplement Request" : "Yêu cầu bổ sung tiền mặt") %></th>
						<td id="tdCashSupplementRequest"></td>
					</tr>
					<tr>
						<th scope="row" class="strong"><%= (langCd.equals("en_US") ? "Stock Amount" : "Giá trị chứng khoán") %></th>
						<td id="tdStockAmount">0</td>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Wait quantity for buying settlement" : "Số lượng chứng khoán chờ về") %></th>
						<td>0</td>
						<th scope="row" class="inner_th"><%= (langCd.equals("en_US") ? "Sell Stock Request" : "Yêu cầu bán chứng khoán") %></th>
						<td id="tdSellStockRequest"></td>
					</tr>
					<tr>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Available stock amount" : "Giá trị chứng khoán hiện có") %></th>
						<td>0</td>
						<th scope="row"></th>
						<td></td>
						<th scope="row" class="inner_th"><%= (langCd.equals("en_US") ? "Force Sell" : "Bán giải chấp") %></th>
						<td id="tdForceSell"></td>
					</tr>
					<tr>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Unavailable stock amount" : "Giá trị chứng khoán chờ về") %></th>
						<td>0</td>
						<th scope="row"></th>
						<td></td>
						<th scope="row" class="inner_th"><%= (langCd.equals("en_US") ? "Force Sell days" : "Thời hạn bán giải chấp") %></th>
						<td id="tdForceSelldays"></td>
					</tr>
					<tr>
						<th scope="row">- <%= (langCd.equals("en_US") ? "Buying wait amount" : "Giá trị chứng khoán chờ về") %></th>
						<td>0</td>
						<th scope="row"></th>
						<td></td>
						<th scope="row" class="inner_th"></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!-- // Asset/Margin Information -->
</div>
</html>
