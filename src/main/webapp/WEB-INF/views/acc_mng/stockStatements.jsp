<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var totalRecordCount = 0;
	$(document).ready(function() {
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());

		getStockStatements();
	});

	function getStockStatements() {
		$("#tab6").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				mvStartDate       : $("#ssmvStartDate").val(),
				mvEndDate         : $("#ssmvEndDate").val(),
				timePeriod		  : "Customize",
				start             : ($("#page").val() == 0 ? 0 : (($("#page").val() - 1) * 15)),
				page              : $("#page").val(),
				limit			  : 15
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/hksStockTransactionHistory.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("===hksStockTransactionHistory===");
				//console.log(data);
				if(data.jsonObj != null) {
					var stockStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var state   = data.jsonObj.list[i];
							var sellQty = state.sellQty;
							stockStatements += "<tr>";
							stockStatements += "	<td class=\"text_center\">" + state.refId + "</td>";     // Order No.
							stockStatements += "	<td class=\"text_center\">" + state.tradeDate + "</td>"; // Trans date
							stockStatements += "	<td class=\"text_center\">" + state.stockCode + "</td>"; // Stock
							stockStatements += "	<td class=\"text_center\">" + state.action + "</td>"; // Action
							stockStatements += "	<td>" + ((state.buyQty == null || state.buyQty == 0) ? "" : numIntFormat(state.buyQty.replace(/,/g,''))) + "</td>";   // Quantity - Credit
							stockStatements += "	<td>" + (state.buyPrice == null ? "0" : numIntFormat(numDotComma(state.buyPrice))) + "</td>";                     // Avg price - Credit
							stockStatements += "	<td>" + (state.buyAmount == null ? "0" : numIntFormat(numDotComma(state.buyAmount))) + "</td>";                   // Amt - Credit
							stockStatements += "	<td>" + ((sellQty == null || sellQty == 0) ? "" : numIntFormat(Math.abs(sellQty.replace(/,/g,'')))) + "</td>";  // Quantity - Debit
							stockStatements += "	<td>" + (state.sellPrice == null ? "0" : numIntFormat(numDotComma(state.sellPrice))) + "</td>";                   // Avg price - Debit
							stockStatements += "	<td>" + (state.sellAmount == null ? "0" : numIntFormat(numDotComma(state.sellAmount))) + "</td>";                 // Amt - Debit
							stockStatements += "	<td>" + numIntFormat(numDotComma(state.fee)) + "</td>";                          // Value - Fee + Tax
							stockStatements += "	<td>" + state.feePercent + "</td>";                   // (%) - Fee + Tax
							stockStatements += "	<td class=\"text_left\">" + state.desc + "</td>";     // Description
							stockStatements += "</tr>";
						}
					}

					$("#trStockStatements").html(stockStatements);
					totalRecordCount = data.jsonObj.totalCount;
					drawPage(data.jsonObj.totalCount, "15", (parseInt($("#page").val()) == 0 ? 1 : parseInt($("#page").val())));
				} else { 
					alert("No Search Data");
				}
				$("#tab6").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab6").unblock();
			}
		});
	}
	
	//Full Download
	function getStockStatementsFull() {
		$("#tab6").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				mvStartDate       : $("#ssmvStartDate").val(),
				mvEndDate         : $("#ssmvEndDate").val(),
				timePeriod		  : "Customize",
				start             : 0,
				page              : 1,
				limit			  : totalRecordCount
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/hksStockTransactionHistory.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				if(data.jsonObj != null) {
					var stockStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var state   = data.jsonObj.list[i];
							var sellQty = state.sellQty;
							stockStatements += "<tr>";
							stockStatements += "	<td class=\"text_center\">" + state.refId + "</td>";     // Order No.
							stockStatements += "	<td class=\"text_center\">" + state.tradeDate + "</td>"; // Trans date
							stockStatements += "	<td class=\"text_center\">" + state.stockCode + "</td>"; // Stock
							stockStatements += "	<td class=\"text_center\">" + state.action + "</td>"; // Action
							stockStatements += "	<td>" + ((state.buyQty == null || state.buyQty == 0) ? "" : numIntFormat(state.buyQty.replace(/,/g,''))) + "</td>";   // Quantity - Credit
							stockStatements += "	<td>" + (state.buyPrice == null ? "0" : numIntFormat(numDotComma(state.buyPrice))) + "</td>";                     // Avg price - Credit
							stockStatements += "	<td>" + (state.buyAmount == null ? "0" : numIntFormat(numDotComma(state.buyAmount))) + "</td>";                   // Amt - Credit
							stockStatements += "	<td>" + ((sellQty == null || sellQty == 0) ? "" : numIntFormat(Math.abs(sellQty.replace(/,/g,'')))) + "</td>";  // Quantity - Debit
							stockStatements += "	<td>" + (state.sellPrice == null ? "0" : numIntFormat(numDotComma(state.sellPrice))) + "</td>";                   // Avg price - Debit
							stockStatements += "	<td>" + (state.sellAmount == null ? "0" : numIntFormat(numDotComma(state.sellAmount))) + "</td>";                 // Amt - Debit
							stockStatements += "	<td>" + numIntFormat(numDotComma(state.fee)) + "</td>";                          // Value - Fee + Tax
							stockStatements += "	<td>" + state.feePercent + "</td>";                   // (%) - Fee + Tax
							stockStatements += "	<td class=\"text_left\">" + state.desc + "</td>";     // Description
							stockStatements += "</tr>";
						}
					}

					$("#trStockStatementsFull").html(stockStatements);
					donwloadFull();
				} else { 
					alert("No Search Data");
				}
				$("#tab6").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab6").unblock();
			}
		});
	}
	//End

	function donwload() {
		$("#downloadLink").prop("download", "Stock Statements.xls");
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, "stockStatements", "datalist");
		});
		$("#downloadLink")[0].click();
	}
	
	function donwloadFull() {
		$("#downloadLink").prop("download", "Stock Statements.xls");
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, "stockStatementsFull", "datalist");
		});
		$("#downloadLink")[0].click();
	}

	var util 		= 	new PageUtil();
	function drawPage(totCnt, pageSize, curPage) {
		util.totalCnt 	= 	totCnt; 		//	게시물의 총 건수
		util.pageRows 	= 	pageSize; 		// 	한번에 출력될 게시물 수
		util.disPagepCnt= 	5; 				//	화면 출력 페이지 수
		util.curPage 	= 	curPage;  		//	현재 선택 페이지
		util.setTotalPage();
		fn_DrowPageNumber();
	}

	function fn_DrowPageNumber() {
		$(".pagination").html(util.Drow());
	}

	function goPage(pageNo) {
		$("#page").val(pageNo);
		getStockStatements();
	}

	function next() {
		var page		=	util.getNext();
		util.curPage    =	page;
		goPage(page);
	}

	function prev() {
		var page		=	util.getPrev();
		util.curPage    =	page;
		goPage(page);
	}
</script>

<div class="tab_content account">
	<input type="hidden" id="page" name="page" value="0"/>
	<!-- Stock Statements -->
	<div role="tabpanel" class="tab_pane" id="tab6">
		<div class="search_area in">
			<label for="fromSearch4"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input type="text" id="ssmvStartDate" name="ssmvStartDate" class="datepicker" />

			<label for="toSearch4"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input type="text" id="ssmvEndDate" name="ssmvEndDate" class="datepicker" />

			<button class="btn" type="button" onclick="getStockStatements()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button type="button" class="btn_down" title="Download" onclick="donwload();">download</button>
			<button type="button" class="btn_down" title="Download All Pages" onclick="getStockStatementsFull();">download</button>
			<a style="display:none;" href="#" id="downloadLink" download="#"></a>
		</div>

		<div class="group_table" id="stockStatements">
			<table class="table no_bbt">
				<caption class="hidden">Stock Statements table</caption>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Order No." : "STT") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Trans date" : "Ngày GD") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Action" : "Loại giao dịch") %></th>
						<th scope="colgroup" colspan="3"><%= (langCd.equals("en_US") ? "Credit" : "Phát sinh tăng") %></th>
						<th scope="colgroup" colspan="3"><%= (langCd.equals("en_US") ? "Debit" : "Phát sinh giảm") %></th>
						<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Fee + Tax" : "Phí + Thuế") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Description" : "Mô tả") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Quantity" : "Khối lượng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Avg price" : "Giá TB") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Amt" : "Tổng cộng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Quantity" : "Khối lượng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Avg price" : "Giá TB") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Amt" : "Tổng cộng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Value" : "Giá trị") %></th>
						<th scope="col">(%)</th>
					</tr>
				</thead>
				<tbody id="trStockStatements">
				</tbody>
			</table>
		</div>
		
		<div class="group_table" style="display:none;" id="stockStatementsFull">
			<table class="table no_bbt">
				<caption class="hidden">Stock Statements table</caption>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Order No." : "STT") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Trans date" : "Ngày GD") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Action" : "Loại giao dịch") %></th>
						<th scope="colgroup" colspan="3"><%= (langCd.equals("en_US") ? "Credit" : "Phát sinh tăng") %></th>
						<th scope="colgroup" colspan="3"><%= (langCd.equals("en_US") ? "Debit" : "Phát sinh giảm") %></th>
						<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Fee + Tax" : "Phí + Thuế") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Description" : "Mô tả") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Quantity" : "Khối lượng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Avg price" : "Giá TB") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Amt" : "Tổng cộng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Quantity" : "Khối lượng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Avg price" : "Giá TB") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Amt" : "Tổng cộng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Value" : "Giá trị") %></th>
						<th scope="col">(%)</th>
					</tr>
				</thead>
				<tbody id="trStockStatementsFull">
				</tbody>
			</table>
		</div>

		<div class="pagination">
		</div>
	</div>
	<!-- // StockStatements -->
</div>
</html>
