
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

		getCashStatements();
	});

	function schCashStatement() {
		$("#page").val(0);
		getCashStatements();
	}
	
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
		return month;
	}
	
	
	
	function getCashStatements() {
		$("#tab5").block({message: "<span>LOADING...</span>"});
		
		var from = convertDateYEARMONDATE($("#amvStartDate").val());
		var to = convertDateYEARMONDATE($("#amvEndDate").val());
		
		if ((to - from) > 1){
			if ("<%= langCd %>" == "en_US") {
				alert("Please query in time 1 month around."); 
			} else {
				alert("Vui lòng tìm lịch sử trong khoảng thời gian 1 tháng.");
			}
			return;
		}
		var param = {
				mvSubAccountID	  : "<%= session.getAttribute("subAccountID") %>",
				mvStartDate       : $("#csmvStartDate").val(),
				mvEndDate         : $("#csmvEndDate").val(),
				tradeType  		  : "ALL",
				timePeriod		  : "Customize",
				start             : ($("#page").val() == 0 ? 0 : (($("#page").val() - 1) * 15)),
				limit			  : 15,
				page              : $("#page").val()
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/queryCashTranHisReport.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("====  queryCashTranHisReport JSON DAT=====");
				//console.log(data);
				if(data.jsonObj != null) {
					var cashStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var state = data.jsonObj.list[i];
							cashStatements += "<tr>";
							cashStatements += "	<td class=\"text_center\">" + state.ROWNUM + "</td>";   // Order No.
							cashStatements += "	<td class=\"text_center\">" + state.TRANDATE + "</td>"; // Date
							cashStatements += "	<td class=\"text_left\">" + state.REMARKS + "</td>";    // Description
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.BALBF)) + "</td>";     // Beginning
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.CREDITAMT)) + "</td>"; // Credit
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.DEBITAMT)) + "</td>";  // Debit amount
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.BALCF)) + "</td>";     // Ending balance
							cashStatements += "</tr>";
						}
					}

					$("#trCashStatements").html(cashStatements);
					totalRecordCount = data.jsonObj.totalCount;
					drawPage(data.jsonObj.totalCount, "15", (parseInt($("#page").val()) == 0 ? 1 : parseInt($("#page").val())));
				} else {
					if ("<%= langCd %>" == "en_US") {
						alert("No Search Data"); 
					} else {
						alert("Không tìm thấy dữ liệu");
					}
				}
				$("#tab5").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab5").unblock();
			}
		});
	}
	
	//Full Download
	function getCashStatementsFull() {
		$("#tab5").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	  : "<%= session.getAttribute("subAccountID") %>",
				mvStartDate       : $("#csmvStartDate").val(),
				mvEndDate         : $("#csmvEndDate").val(),
				tradeType  		  : "ALL",
				timePeriod		  : "Customize",
				start             : 0,
				limit			  : totalRecordCount,
				page              : 1
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/queryCashTranHisReport.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("JSON DAT++++++++++++");
				//console.log(data);
				if(data.jsonObj != null) {
					var cashStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var state = data.jsonObj.list[i];
							cashStatements += "<tr>";
							cashStatements += "	<td class=\"text_center\">" + state.ROWNUM + "</td>";   // Order No.
							cashStatements += "	<td class=\"text_center\">" + state.TRANDATE + "</td>"; // Date
							cashStatements += "	<td class=\"text_left\">" + state.REMARKS + "</td>";    // Description
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.BALBF)) + "</td>";     // Beginning
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.CREDITAMT)) + "</td>"; // Credit
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.DEBITAMT)) + "</td>";  // Debit amount
							cashStatements += "	<td>" + numIntFormat(numDotComma(state.BALCF)) + "</td>";     // Ending balance
							cashStatements += "</tr>";
						}
					}
					$("#trCashStatementsFull").html(cashStatements);
					donwloadFull();
				} else {
					if ("<%= langCd %>" == "en_US") {
						alert("No Search Data"); 
					} else {
						alert("Không tìm thấy dữ liệu");
					}
				}
				$("#tab5").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab5").unblock();
			}
		});
	}
	//End

	function donwload() {
		$("#downloadLink").prop("download", "Cash Statements.xls");
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, "cashStatements", "datalist");
		});
		$("#downloadLink")[0].click();
	}
	
	function donwloadFull() {
		$("#downloadLink").prop("download", "Cash Statements.xls");
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, "cashStatementsFull", "datalist");
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

<div class="tab_content account">
	<input type="hidden" id="page" name="page" value="0"/>
	<!-- Cash Statements -->
	<div role="tabpanel" class="tab_pane" id="tab5">
		<div class="search_area in">
			<label for="fromSearch3"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input type="text" id="csmvStartDate" name="csmvStartDate" class="datepicker" />

			<label for="toSearch3"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input type="text" id="csmvEndDate" name="csmvEndDate" class="datepicker" />

			<button class="btn" type="button" onclick="schCashStatement()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu ") %></button>
			<button type="button" class="btn_down" title="Download" onclick="donwload();">download</button>
			<button type="button" class="btn_down" title="Download All Pages" onclick="getCashStatementsFull();">download</button>
			<a style="display:none;" href="#" id="downloadLink" download="#"></a>
		</div>

		<div class="group_table" id="cashStatements">
			<table class="table no_bbt">
				<caption class="hidden">Cash Statements table</caption>
				<colgroup>
					<col width="10%" />
					<col width="10%" />
					<col />
					<col />
					<col />
					<col />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order No." : "STT") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Description" : "Mô tả") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Beginning" : "Số dư đầu kỳ") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Credit" : "Phát sinh tăng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Debit amount" : "Phát sinh giảm") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Ending balance" : "Số dư cuối kỳ") %></th>
					</tr>
				</thead>
				<tbody id="trCashStatements">
				</tbody>
			</table>
		</div>
		
		<div class="group_table" style="display:none;" id="cashStatementsFull">
			<table class="table no_bbt">
				<caption class="hidden">Cash Statements table</caption>
				<colgroup>
					<col width="10%" />
					<col width="10%" />
					<col />
					<col />
					<col />
					<col />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order No." : "STT") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Description" : "Mô tả") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Beginning" : "Số dư đầu kỳ") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Credit" : "Phát sinh tăng") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Debit amount" : "Phát sinh giảm") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Ending balance" : "Số dư cuối kỳ") %></th>
					</tr>
				</thead>
				<tbody id="trCashStatementsFull">
				</tbody>
			</table>
		</div>

		<div class="pagination">
		</div>
	</div>
	<!-- // Cash Statements -->
</div>
</html>
