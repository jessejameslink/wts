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

// 		getPriceHistory();
	});

	function getPriceHistory() {
		$("#tab2").block({message: "<span>LOADING...</span>"});
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
				$("#tab2").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab2").unblock();
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
	<!-- Price history -->
	<div role="tabpanel" class="tab_pane" id="tab2">
		<div class="search_area in">
			<label for="symbol"><%= (langCd.equals("en_US") ? "Symbol" : "Mã CK") %></label>
			<span><input type="text" class="text" id="symbol" /></span>

			<label for="fromSearch1"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input id="fromSearch1" type="text" class="datepicker"/>

			<label for="toSearch1"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input id="toSearch1" type="text" class="datepicker">

			<button class="btn" type="button"><%= (langCd.equals("en_US") ? "Search" : "Tìm kiếm") %></button>
			<button type="button" class="btn_down" title="Download">download</button>
		</div>

		<div class="group_table ph_table">
			<table class="table no_bbt">
				<caption class="hidden">Price History table</caption>
				<thead>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Change (+ -/%)" : "Thay đổi (+ -/%)") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Open Price" : "Giá mở cửa") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Highest price" : "Giá cao nhất") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Lowest price" : "Giá thấp nhất") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Close Price" : "Giá đóng cửa") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Average Price" : "Giá bình quân") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Adjusted Price" : "Giá đóng cửa điều chỉnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Trading Volume" : "KL khớp lệnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Put through Volume" : "KL thỏa thuận") %></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="text_center">2016-05-13</td>
						<td class="text_center">
							<span class="arrow low">-02 (-0.91%)</span>
						</td>
						<td>21.8</td>
						<td>23.2</td>
						<td>21.7</td>
						<td>21.7</td>
						<td>22.23</td>
						<td>21.7</td>
						<td>536,457</td>
						<td>-</td>
					</tr>
					<tr>
						<td class="text_center">2016-05-12</td>
						<td class="text_center">
							<span class="arrow up">+1.9 (+9.45)</span>
						</td>
						<td>20.4</td>
						<td>22.1</td>
						<td>20.2</td>
						<td>22</td>
						<td>21.73</td>
						<td>22</td>
						<td>558,080</td>
						<td>15,000</td>
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
	<!-- // Price history -->
</div>
</html>
