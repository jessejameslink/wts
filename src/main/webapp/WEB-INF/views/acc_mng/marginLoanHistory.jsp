<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>

<script>
	$("#tab8").block({message: "<span>LOADING...</span>"});
	var totalRecordCount = 0;
	$(document).ready(function() {
		//console.log("marginLoanHistory");
		$("#tab8").unblock();
 		//marginLoanHistory();		// 성능 저하로 인한 주석처리
	});
	
	function convertDateYEARMONDATE(dateValue){
		//console.log("convertDateYEARMONDATE");
		
		//var dateString = "23/10/2015"; // Oct 23
		var dateParts = dateValue.split("/");
		var dateObject = new Date(+dateParts[2], dateParts[1] - 1, +dateParts[0]); 


		//var date = new Date(strDate);
		var day = ('0' + dateObject.getDate()).slice(-2);
		var month = ('0' + (dateObject.getMonth() + 1)).slice(-2);
		var year = dateObject.getFullYear();
		
		//console.log(year + '-' + month + '-' + day);
		return year + '-' + month + '-' + day;
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

	function marginLoanHistory(page, start, limit){
		
		$("#tab8").block({message: "<span>LOADING...</span>"});
		
		var from = convertDateYEARMONDATE($("#amvStartDate").val());
		var to = convertDateYEARMONDATE($("#amvEndDate").val());
		
		var param = {
				client_id		: 	"<%= session.getAttribute("subAccountID") %>",
				from_date       : from,
				to_date         : to,
				skey			: "30000101",
				user_id			: "",
				start			: page ? (page-1) * (limit ? limit : 15) : 0,
				limit			: limit,
				page			: page
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/marginLoanHistory.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("===marginLoanHistory===");
				console.log(data);
				if(data.jsonObj != null) {
					var marginLoanHistory = "";
					if(data.jsonObj.list1 != null) {
						for(var i=0; i < data.jsonObj.list1.length; i++) {

							if(data.jsonObj.list1[i].stt > 0){
								
								marginLoanHistory += "<tr>";							
								marginLoanHistory += "	<td>" + data.jsonObj.list1[i].stt + "</td>";
								marginLoanHistory += "	<td>" + data.jsonObj.list1[i].trandate + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].loand)/1000) + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].debitinterest) / 1000000) + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].cmanualreserve) / 1000) + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].advanceavailable) / 1000) + "</td>";
								marginLoanHistory += "</tr>";
							}
						}
					}
					$("#marginLoanHistoryList").html(marginLoanHistory);
					totalRecordCount = data.jsonObj.totalCount;
					drawPage(data.jsonObj.totalCount, (limit ? limit: 15), (page ? page : 1)); // paging
				}
				$("#tab8").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab8").unblock();
			}
		});
	}
	
	//Full Download
	function marginLoanHistoryFull(page, start, limit){
		$("#tab8").block({message: "<span>LOADING...</span>"});
		var from = convertDateYEARMONDATE($("#amvStartDate").val().toString('YYYY-MM-dd'));
		var to = convertDateYEARMONDATE($("#amvEndDate").val().toString('YYYY-MM-dd'));
		var param = {
				client_id		: 	"<%= session.getAttribute("subAccountID") %>",
				from_date       : from,
				to_date         : to,
				skey			: "30000101",
				user_id			: "",
				start				: page ? (page-1) * (limit ? limit : 15) : 0,
				limit				: limit,
				page				: page
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/marginLoanHistory.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("===marginLoanHistory===");
				//console.log(data);
				if(data.jsonObj != null) {
					var marginLoanHistory = "";
					if(data.jsonObj.list1 != null) {
						for(var i=0; i < data.jsonObj.list1.length; i++) {

							if(data.jsonObj.list1[i].stt > 0){
								
								marginLoanHistory += "<tr>";							
								marginLoanHistory += "	<td>" + data.jsonObj.list1[i].stt + "</td>";
								marginLoanHistory += "	<td>" + data.jsonObj.list1[i].trandate + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].loand)/1000) + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].debitinterest) / 1000000) + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].cmanualreserve) / 1000) + "</td>";
								marginLoanHistory += "	<td>" + numIntFormat(numDotComma(data.jsonObj.list1[i].advanceavailable) / 1000) + "</td>";
								marginLoanHistory += "</tr>";
							}
						}
					}
					$("#marginLoanHistoryList").html(marginLoanHistory);
					totalRecordCount = data.jsonObj.totalCount;
					drawPage(data.jsonObj.totalCount, (limit ? limit: 15), (page ? page : 1)); // paging
				}
				$("#tab8").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab8").unblock();
			}
		});
	}
	//End

	var util 		= 	new PageUtil();
	function drawPage(totCnt, pageSize, curPage) {
		util.totalCnt 	= 	totCnt; 		//	게시물의 총 건수
		util.pageRows 	= 	pageSize; 		// 	한번에 출력될 게시물 수
		util.disPagepCnt= 	0; 				//	화면 출력 페이지 수
		util.curPage 	= 	curPage;  		//	현재 선택 페이지
		util.setTotalPage();
		fn_DrowPageNumber();
	}

	function fn_DrowPageNumber() {
		$(".pagination").html(util.Drow());
	}

	function goPage(pageNo) {
		marginLoanHistory(pageNo);
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
		$("#downloadLink").prop('download', 'Report Margin Loan.xls');
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, 'marginLoanHistoryDataTable', 'datalist');
		});
		$('#downloadLink')[0].click();
	}
	
	function downloadFull() {
		$("#downloadLink").prop('download', 'Margin Loan Statements.xls');
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, 'marginLoanHistoryDataTableFull', 'datalist');
		});
		$('#downloadLink')[0].click();
	}

</script>

<div class="tab_content account">
<!-- 	<input type="hidden" id="page" name="page" value="0"/> -->
	<!-- Margin Loan Statements -->
	<div role="tabpanel" class="tab_pane" id="tab8">
		<div class="search_area in">
			<label for="fromSearch5"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input id="amvStartDate" name="amvStartDate" type="text" class="datepicker" />

			<label for="toSearch5"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input id="amvEndDate" name="amvEndDate" type="text" class="datepicker" />

			<button class="btn" type="button" onclick="marginLoanHistory()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button type="button" class="btn_down" title="Download" onclick="download();">download</button>
			<button type="button" class="btn_down" title="Download All Pages" onclick="marginLoanHistoryFull();">download</button>
			<a style="display:none;" href="#" id="downloadLink" download="#"></a>
		</div>

		<div class="group_table" id="marginLoanHistoryDataTable">
			<table class="table no_bbt">
				<caption class="hidden"><%= (langCd.equals("en_US") ? "MARGIN ACCOUNT BALANCE STATEMENT" : "BÁO SỐ DƯ TÀI KHOẢNG KÝ QUỸ") %></caption>
				<colgroup>
					<col width="50" />
					<col width="100" />
					<col width="300" />
					<col width="300" />
					<col width="300" />
					<col width="300" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "No." : "STT") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Trade Date" : "Ngày giao dịch") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Outstanding Loan" : "Dư nợ") %></th>
						<th scope="col" colspan="1"><%= (langCd.equals("en_US") ? "Debit Interest" : "Lãi") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Cash Reserve" : "Tiền mặt") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Available Advance" : "Tiền có thể ứng trước") %></th>
					</tr>					
				</thead>
				<tbody id="marginLoanHistoryList">
				</tbody>
			</table>
		</div>
		
		<div class="group_table" style="display:none;" id="marginLoanHistoryDataTableFull">
			<table class="table no_bbt">
				<caption class="hidden"><%= (langCd.equals("en_US") ? "MARGIN ACCOUNT BALANCE STATEMENT" : "BÁO SỐ DƯ TÀI KHOẢNG KÝ QUỸ") %></caption>
				<colgroup>
					<col width="50" />
					<col width="100" />
					<col width="300" />
					<col width="300" />
					<col width="300" />
					<col width="300" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "No." : "STT") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Trade Date" : "Ngày giao dịch") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Outstanding Loan" : "Dư nợ") %></th>
						<th scope="col" colspan="1"><%= (langCd.equals("en_US") ? "Debit Interest" : "Lãi") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Cash Reserve" : "Tiền mặt") %></th>
						<th scope="col" rowspan="1"><%= (langCd.equals("en_US") ? "Available Advance" : "Tiền có thể ứng trước") %></th>
					</tr>
				</thead>
				<tbody id="marginLoanHistoryListFull">
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
