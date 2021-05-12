<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$("#tab7").block({message: "<span>LOADING...</span>"});
	var totalRecordCount = 0;
	$(document).ready(function() {
		//console.log("ready");
		$("#tab7").unblock();
// 		marginLoan();		// 성능 저하로 인한 주석처리
	});

	function marginLoan(page, start, limit){
		$("#tab7").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				mvStartDate       	: $("#amvStartDate").val(),
				mvEndDate         	: $("#amvEndDate").val(),
				start				: page ? (page-1) * (limit ? limit : 15) : 0,
				limit				: limit,
				page				: page
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/marginLoan.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("===marginLoan===");
				//console.log(data);
				if(data.jsonObj != null) {
					var marginLoanStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {

							if(data.jsonObj.list[i].rowNum > 0){
								
								marginLoanStatements += "<tr>";
								marginLoanStatements += "	<td class=\"text_center\">" + data.jsonObj.list[i].rowNum + "</td>";
								marginLoanStatements += "	<td class=\"text_center\">" + data.jsonObj.list[i].tranDate + "</td>";
								marginLoanStatements += "	<td class=\"text_left\">" + data.jsonObj.list[i].desc + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].out + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i]["in"] + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].balance + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].marginCallF + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].sellAmount + "</td>";
								marginLoanStatements += "</tr>";
							}
						}
					}
					$("#marginLoanList").html(marginLoanStatements);
					totalRecordCount = data.jsonObj.totalCount;
					drawPage(data.jsonObj.totalCount, (limit ? limit: 15), (page ? page : 1)); // paging
				}
				$("#tab7").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab7").unblock();
			}
		});
	}
	
	//Full Download
	function marginLoanFull(page, start, limit){
		$("#tab7").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				mvStartDate       	: $("#amvStartDate").val(),
				mvEndDate         	: $("#amvEndDate").val(),
				start				: 0,
				limit				: totalRecordCount,
				page				: 1
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/marginLoan.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				if(data.jsonObj != null) {
					var marginLoanStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {

							if(data.jsonObj.list[i].rowNum > 0){
								marginLoanStatements += "<tr>";
								marginLoanStatements += "	<td class=\"text_center\">" + data.jsonObj.list[i].rowNum + "</td>";
								marginLoanStatements += "	<td class=\"text_center\">" + data.jsonObj.list[i].tranDate + "</td>";
								marginLoanStatements += "	<td class=\"text_left\">" + data.jsonObj.list[i].desc + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].out + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i]["in"] + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].balance + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].marginCallF + "</td>";
								marginLoanStatements += "	<td>" + data.jsonObj.list[i].sellAmount + "</td>";
								marginLoanStatements += "</tr>";
							}
						}
					}
					$("#marginLoanListFull").html(marginLoanStatements);
					downloadFull();
				}
				$("#tab7").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab7").unblock();
			}
		});
	}
	//End

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
		marginLoan(pageNo);
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

	function download() {
		$("#downloadLink").prop('download', 'Margin Loan Statements.xls');
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, 'marginLoanDataTable', 'datalist');
		});
		$('#downloadLink')[0].click();
	}
	
	function downloadFull() {
		$("#downloadLink").prop('download', 'Margin Loan Statements.xls');
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, 'marginLoanDataTableFull', 'datalist');
		});
		$('#downloadLink')[0].click();
	}

</script>

<div class="tab_content account">
<!-- 	<input type="hidden" id="page" name="page" value="0"/> -->
	<!-- Margin Loan Statements -->
	<div role="tabpanel" class="tab_pane" id="tab7">
		<div class="search_area in">
			<label for="fromSearch5"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input id="amvStartDate" name="amvStartDate" type="text" class="datepicker" />

			<label for="toSearch5"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input id="amvEndDate" name="amvEndDate" type="text" class="datepicker" />

			<button class="btn" type="button" onclick="marginLoan()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button type="button" class="btn_down" title="Download" onclick="download();">download</button>
			<button type="button" class="btn_down" title="Download All Pages" onclick="marginLoanFull();">download</button>
			<a style="display:none;" href="#" id="downloadLink" download="#"></a>
		</div>

		<div class="group_table" id="marginLoanDataTable">
			<table class="table no_bbt">
				<caption class="hidden">Margin Loan Statements table</caption>
				<colgroup>
					<col width="50" />
					<col width="100" />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "No." : "STT") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Date" : "Ngày phát sinh") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Description" : "Nội dung phát sinh") %></th>
						<th scope="colgroup" colspan="3"><%= (langCd.equals("en_US") ? "Margin Usage" : "Phát sinh tiền ký quỹ") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Margin call" : "Lệnh gọi bổ sung ký quỹ") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Force sell" : "Bán giải chấp") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Debt" : "Nợ") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Payment" : "Trả nợ") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Final debt" : "Dư nợ lũy kế") %></th>
					</tr>
				</thead>
				<tbody id="marginLoanList">
				</tbody>
			</table>
		</div>
		
		<div class="group_table" style="display:none;" id="marginLoanDataTableFull">
			<table class="table no_bbt">
				<caption class="hidden">Margin Loan Statements table</caption>
				<colgroup>
					<col width="50" />
					<col width="100" />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "No." : "STT") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Date" : "Ngày phát sinh") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Description" : "Nội dung phát sinh") %></th>
						<th scope="colgroup" colspan="3"><%= (langCd.equals("en_US") ? "Margin Usage" : "Phát sinh tiền ký quỹ") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Margin call" : "Lệnh gọi bổ sung ký quỹ") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Force sell" : "Bán giải chấp") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Debt" : "Nợ") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Payment" : "Trả nợ") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Final debt" : "Dư nợ lũy kế") %></th>
					</tr>
				</thead>
				<tbody id="marginLoanListFull">
				</tbody>
			</table>
		</div>

		<div class="pagination">
		</div>
	</div>
	<!-- // Margin Loan Statements -->

</div>
<script>
	var d = new Date();
	$(".datepicker").datepicker({
		showOn      : "button",
		dateFormat  : "dd/mm/yy",
		changeYear  : true,
		changeMonth : true
	});
	$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
</script>
</html>
