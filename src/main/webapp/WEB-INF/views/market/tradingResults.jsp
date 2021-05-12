<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());

// 		getTradingResults();
	});

	function getTradingResults() {
		$("#tab3").block({message: "<span>LOADING...</span>"});
		var param = {
				mvStartDate       : $("#mvStartDate").val(),
				mvEndDate         : $("#mvEndDate").val(),
				start             : ($("#page").val() == "0" ? "1" : (($("#page").val() - 1) * 15) + 1),
				limit			  : 14,
				page              : $("#page").val()
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/queryCashTranHisReport.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				if(data.jsonObj != null) {
					var cashStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var state = data.jsonObj.list[i];
							cashStatements += "<tr>";
							cashStatements += "	<td class=\"text_center\">" + state.ROWNUM + "</td>";   // Order No.
							cashStatements += "	<td class=\"text_center\">" + state.TRANDATE + "</td>"; // Date
							cashStatements += "	<td class=\"text_left\">" + state.REMARKS + "</td>";    // Description
							cashStatements += "	<td>" + numIntFormat(parseInt(state.BALBF)) + "</td>";     // Beginning
							cashStatements += "	<td>" + numIntFormat(parseInt(state.CREDITAMT)) + "</td>"; // Credit
							cashStatements += "	<td>" + numIntFormat(parseInt(state.DEBITAMT)) + "</td>";  // Debit amount
							cashStatements += "	<td>" + numIntFormat(parseInt(state.BALCF)) + "</td>";     // Ending balance
							cashStatements += "</tr>";
						}
					}

					$("#trCashStatements").html(cashStatements);
				}
				drawPage(data.jsonObj.totalCount, "15", (parseInt($("#page").val()) == "0" ? "1" : parseInt($("#page").val())));
				$("#tab3").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
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
		getCashStatements();
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

<div class="tab_content market">
	<input type="hidden" id="page" name="page" value="0"/>
	<!-- Trading results -->
	<div role="tabpanel" class="tab_pane" id="tab3">
		<div class="search_area in">
			<label for="market_sel"><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></label>
			<span>
				<select name="" id="market_sel">
					<option value="">HNX</option>
					<option value="">HNX</option>
					<option value="">HNX</option>
					<option value="">HNX</option>
				</select>
			</span>

			<label for="tr_date"><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></label>
			<input id="tr_date" type="text" class="datepicker">

			<button class="btn" type="button"><%= (langCd.equals("en_US") ? "Search" : "Tìm kiếm") %></button>
			<button type="button" class="btn_down" title="Download">download</button>
		</div>

		<div class="group_table tr_table">
			<table class="table no_bbt">
				<caption class="hidden">Trading results table</caption>
				<colgroup>
					<col width="70" />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Symbol" : "Mã CK") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Close Price" : "Giá đóng cửa") %></th>
						<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Bid" : "Mua") %></th>
						<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Ask" : "Bán") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Bid Average" : "KLTB lệnh mua") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Ask Average" : "KLTB lệnh bán") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Buy - Sell" : "KL Mua - KL Bán") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Total Volume" : "Tổng KLGD") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Total Value" : "Tổng GTGD") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Orders" : "Số lệnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Orders" : "Số lệnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="text_center">AAA</td>
						<td>21.7</td>
						<td>390</td>
						<td>625,800</td>
						<td>277</td>
						<td>689,800</td>
						<td>1,604.60</td>
						<td>2,409.30</td>
						<td>-64,000</td>
						<td>536,457</td>
						<td>11,925,985,000</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="pagination">
			<a href="" class="prev">prev</a>
			<a href="" class="current">1</a>
			<a href="">2</a>
			<a href="">3</a>
			<a href="">4</a>
			<a href="">5</a>
			<a href="" class="next">next</a>
		</div>
	</div>
	<!-- // Trading results -->
</div>
</html>
