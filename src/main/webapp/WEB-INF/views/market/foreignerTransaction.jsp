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

// 		getForeignerTransaction();
	});

	function getForeignerTransaction() {
		$("#tab4").block({message: "<span>LOADING...</span>"});
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
				$("#tab4").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab4").unblock();
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
	<!-- Foreigner Transaction -->
	<div role="tabpanel" class="tab_pane" id="tab4">
		<div class="search_area in">
			<label for="ft_market_sel"><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></label>
			<span>
				<select name="" id="ft_market_sel">
					<option value="">HNX</option>
					<option value="">HNX</option>
					<option value="">HNX</option>
					<option value="">HNX</option>
				</select>
			</span>

			<label for="ft_date"><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></label>
			<input id="ft_date" type="text" class="datepicker">

			<button class="btn" type="button"><%= (langCd.equals("en_US") ? "Search" : "Tìm kiếm") %></button>
		</div>

		<div class="group_table ft_table">
			<table class="table no_bbt">
				<caption class="hidden">Foreigner Transaction table</caption>
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
				</colgroup>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Symbol" : "Mã CK") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Total Room" : "Tổng Room") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Current Room" : "Room hiện tại") %></th>
						<th scope="col" colspan="2"><%= (langCd.equals("en_US") ? "Buy" : "Mua") %></th>
						<th scope="col" colspan="2"><%= (langCd.equals("en_US") ? "Sell" : "Bán") %></th>
						<th scope="col" colspan="2"><%= (langCd.equals("en_US") ? "Net Trading" : "Giao dịch ròng") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Bid Volume" : "Khối lượng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Value" : "Giá trị") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Ask Volume" : "Khối lượng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Value" : "Giá trị") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Net Volume" : "Khối lượng ròng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Net Value" : "Giá trị ròng") %></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="text_center">AAA</td>
						<td>14,125,917</td>
						<td>19,404,000</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
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
	<!-- // Foreigner Transaction -->
</div>
</html>
