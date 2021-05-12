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
		$("#cmvStartDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		$("#cmvEndDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		getCashTransactionHistory();
	});

	function getCashTransactionHistory() {
		$("#tab4").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				tradeType         : $("#tradeType").val(),
				mvStartDate       : $("#cmvStartDate").val(),
				mvEndDate         : $("#cmvEndDate").val(),
				start             : ($("#page").val() == 0 ? 0 : (($("#page").val() - 1) * 15)),
				page              : $("#page").val(),
				limit			  : 15
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/queryCashTranHistory.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("===queryCashTranHistory===");
				//console.log(data);
				if(data.jsonObj != null) {
					var cashTranHistory = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var tranHis = data.jsonObj.list[i];
							cashTranHistory += "<tr>";
							cashTranHistory += "	<td class=\"text_center\">" + tranHis.tranID + "</td>"; // Trans. ID
							cashTranHistory += "	<td class=\"text_center\">" + tranHis.trandate + "</td>"; // Trans. date
							cashTranHistory += "	<td class=\"text_left\">" + getTranType(trim(tranHis.transType)) + "</td>"; // Trans. type
							cashTranHistory += "	<td>" + numIntFormat(numDotComma(tranHis.totalLendingAmt)) + "</td>"; // Amount (VND)
							cashTranHistory += "	<td class=\"text_center\">" + getStatus(tranHis.status) + "</td>"; // Status
							cashTranHistory += "	<td class=\"text_left\">" + tranHis.remark + "</td>"; // Notes
							cashTranHistory += "	<td class=\"text_center\">" + tranHis.lastApprovaltime + "</td>"; // Last update
							cashTranHistory += "</tr>";
						}
					}

					$("#trCashTranHistory").html(cashTranHistory);
				}
				totalRecordCount = data.jsonObj.totalCount;
				drawPage(data.jsonObj.totalCount, "15", (parseInt($("#page").val()) == 0 ? 1 : parseInt($("#page").val())));
				$("#tab4").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab4").unblock();
			}
		});
	}
	
	function getCashTransactionHistoryFull() {
		$("#tab4").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				tradeType         : $("#tradeType").val(),
				mvStartDate       : $("#cmvStartDate").val(),
				mvEndDate         : $("#cmvEndDate").val(),
				start             : 0,
				page              : 1,
				limit			  : totalRecordCount
		};
		
		//console.log("param download");
		//console.log(param);

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/queryCashTranHistory.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				if(data.jsonObj != null) {
					var cashTranHistoryFull = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var tranHis = data.jsonObj.list[i];
							cashTranHistoryFull += "<tr>";
							cashTranHistoryFull += "	<td class=\"text_center\">" + tranHis.tranID + "</td>"; // Trans. ID
							cashTranHistoryFull += "	<td class=\"text_center\">" + tranHis.trandate + "</td>"; // Trans. date
							cashTranHistoryFull += "	<td class=\"text_left\">" + getTranType(trim(tranHis.transType)) + "</td>"; // Trans. type
							cashTranHistoryFull += "	<td>" + numIntFormat(numDotComma(tranHis.totalLendingAmt)) + "</td>"; // Amount (VND)
							cashTranHistoryFull += "	<td class=\"text_center\">" + getStatus(tranHis.status) + "</td>"; // Status
							cashTranHistoryFull += "	<td class=\"text_left\">" + tranHis.remark + "</td>"; // Notes
							cashTranHistoryFull += "	<td class=\"text_center\">" + tranHis.lastApprovaltime + "</td>"; // Last update
							cashTranHistoryFull += "</tr>";
						}
					}

					$("#trCashTranHistoryFull").html(cashTranHistoryFull);
				}
				downloadFull();
				$("#tab4").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab4").unblock();
			}
		});
	}

	function getTranType(tradeType) {
		switch (tradeType) {
			case "SCAXW":
				if ("<%= langCd %>" == "en_US") {
				return "Exercise Subscription";
				} else {
					return "Đăng ký mua";
				}
			case "SCAC":
				if ("<%= langCd %>" == "en_US") {
				return "Dividend";
				} else {
					return "Trả cổ tức bằng tiền mặt";
				}
			case "CCPCW":
				if ("<%= langCd %>" == "en_US") {
				return "Cash Withdrawal";
				} else {
					return "Rút tiền";
				}
			case "CCPCD":
				if ("<%= langCd %>" == "en_US") {
				return "Cash Deposit";
				} else {
					return "Nộp tiền";
				}
			case "SCSS":
				if ("<%= langCd %>" == "en_US") {
				return "Sold Contract Settlement";
				} else {
					return "Thanh toán giao dịch bán";
				}
			case "SCSB":
				if ("<%= langCd %>" == "en_US") {
				return "Bought Contract Settlement";
				} else {
					return "Thanh toán giao dịch mua";
				}
			case "CCIPOS":
				if ("<%= langCd %>" == "en_US") {
				return "Interest Posting";
				} else {
					return "Phân bố lãi suất";
				}
			case "CCIPOSP":
				if ("<%= langCd %>" == "en_US") {
				return "Deposit interest";
				} else {
					return "Lãi tiền gửi";
				}
			case "CCIPOSR":
				if ("<%= langCd %>" == "en_US") {
				return "Margin fee";
				} else {
					return "Lãi Margin";
				}
			case "SCLRD":
				if ("<%= langCd %>" == "en_US") {
				return "Ex_Repos Deposit";
				} else {
					return "Nhận cho vay cầm cố chứng khoán";
				}
			case "ODDAL":
				if ("<%= langCd %>" == "en_US") {
				return "Odd lot allotment";
				} else {
					return "Phân bố lô lẻ";
				}
			case "SCLRW":
				if ("<%= langCd %>" == "en_US") {
				return "Ex_Repos Withdraw";
				} else {
					return "Hoàn trả cho vay cầm cố chứng khoán";
				}
			case "SCLRIW":
				if ("<%= langCd %>" == "en_US") {
				return "Ex_Repos Interest Withdraw";
				} else {
					return "Phí nhận cho vay cầm cố chứng khoán";
				}
			case "SCLAD":
				if ("<%= langCd %>" == "en_US") {
				return "Advance Payment Deposit";
				} else {
					return "Nhận cho vay ứng trước bán chứng khoán";
				}
			case "SCLAW":
				if ("<%= langCd %>" == "en_US") {
				return "Advance Payment Withdraw";
				} else {
					return "Hoàn trả cho vay ứng trước bán chứng khoán";
				}
			case "CCFP":
				if ("<%= langCd %>" == "en_US") {
				return "Custodian Fee Posting";
				} else {
					return "Phí lưu ký";
				}
			case "CSFP":
				if ("<%= langCd %>" == "en_US") {
				return "SMS Fee Posting";
				} else {
					return "Phí SMS";
				}
			default :
				return ""
		}
	}

	function getStatus(status) {
		switch (status) {
		case "P":
			if ("<%= langCd %>" == "en_US") {
			return "Pending";
			} else {
				return "Chờ xử lý";
			}
		case "A":
			if ("<%= langCd %>" == "en_US") {
			return "Approved";
			} else {
				return "Đã chấp nhận";
			}
		case "R":
			if ("<%= langCd %>" == "en_US") {
			return "Rejected";
			} else {
				return "Không chấp nhận";
			}
		case "D":
			if ("<%= langCd %>" == "en_US") {
			return "Deleted"
			} else {
				return "Đã hủy";
			}
		default :
			return ""
		}
	}

	function donwload() {
		$("#downloadLink").prop("download", "Cash Transaction History.xls");
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, "cashTranHistory", "datalist");
		});
		$("#downloadLink")[0].click();
	}
	
	function downloadFull() {
		$("#downloadLink").prop("download", "Cash Transaction History.xls");
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, "cashTranHistoryFull", "datalist");
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
		getCashTransactionHistory();
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
	<!-- Cash Transaction History -->
	<div role="tabpanel" class="tab_pane" id="tab4">
		<div class="search_area in">
			<label for="type"><%= (langCd.equals("en_US") ? "Trans type" : "Loại giao dịch") %></label>
			<span>
				<select id="tradeType" name="tradeType">
					<option value="ALL"><%= (langCd.equals("en_US") ? "ALL" : "Tất cả") %></option>
					<option value="SCAXW"><%= (langCd.equals("en_US") ? "Exercise Subscription" : "Đăng ký mua") %></option>
					<option value="SCAC"><%= (langCd.equals("en_US") ? "Dividend" : "Trả cổ tức bằng tiền mặt") %></option>
					<option value="CCPCW"><%= (langCd.equals("en_US") ? "Cash Withdrawal" : "Rút tiền") %></option>
					<option value="CCPCD"><%= (langCd.equals("en_US") ? "Cash Deposit" : "Nộp tiền") %></option>
					<option value="SCSS"><%= (langCd.equals("en_US") ? "Sold Contract Settlement" : "Thanh toán giao dịch bán") %></option>
					<option value="CCIPOSP"><%= (langCd.equals("en_US") ? "Deposit interest" : "Lãi tiền gửi") %></option>
					<option value="CCIPOSR"><%= (langCd.equals("en_US") ? "Margin fee" : "Lãi Margin") %></option>
					<option value="SCSB"><%= (langCd.equals("en_US") ? "Bought Contract Settlement" : "Thanh toán giao dịch mua") %></option>
					<option value="SCLRD"><%= (langCd.equals("en_US") ? "Ex_Repos Deposit" : "Nhận cho vay cầm cố chứng khoán") %></option>
					<option value="ODDAL"><%= (langCd.equals("en_US") ? "Odd lot allotment" : "Phân bố lô lẻ") %></option>
					<option value="SCLRW"><%= (langCd.equals("en_US") ? "Ex_Repos Withdraw" : "Hoàn trả cho vay cầm cố chứng khoán") %></option>
					<option value="SCLRIW"><%= (langCd.equals("en_US") ? "Ex_Repos Interest Withdraw" : "Phí nhận cho vay cầm cố chứng khoán") %></option>
					<option value="SCLAD"><%= (langCd.equals("en_US") ? "Advance Payment Deposit" : "Nhận cho vay ứng trước bán chứng khoán") %></option>
					<option value="SCLAW"><%= (langCd.equals("en_US") ? "Advance Payment Withdraw" : "Hoàn trả cho vay ứng trước bán chứng khoán") %></option>
					<option value="CCFP"><%= (langCd.equals("en_US") ? "Custodian Fee Posting" : "Phí lưu ký") %></option>
					<option value="CSFP"><%= (langCd.equals("en_US") ? "SMS Fee Posting" : "Phí SMS") %></option>
				</select>
			</span>

			<label for="fromSearch2"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input type="text" id="cmvStartDate" name="mvStartDate" class="datepicker" />

			<label for="toSearch2"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input type="text" id="cmvEndDate" name="mvEndDate" class="datepicker" />

			<button class="btn" type="button" onclick="getCashTransactionHistory()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button type="button" class="btn_down" title="Download" onclick="donwload();">download</button>
			<button type="button" class="btn_down" title="Download All Pages" onclick="getCashTransactionHistoryFull();">download</button>
			<a style="display:none;" href="#" id="downloadLink" download="#"></a>
		</div>

		<div class="group_table" id="cashTranHistory">
			<table class="table no_bbt">
				<caption class="hidden">Cash Transaction History table</caption>
				<colgroup>
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col />
					<col width="10%" />
					<col />
					<col width="10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Trans. ID" : "Mã GD") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Trans. date" : "Ngày GD") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Trans. type" : "Loại giao dịch") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Amount (VND)" : "Số tiền (VND)") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Notes" : "Ghi chú") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Last update" : "Ngày cập nhật cuối") %></th>
					</tr>
				</thead>
				<tbody id="trCashTranHistory">
				</tbody>
			</table>
		</div>
		
		<div class="group_table" style="display:none;" id="cashTranHistoryFull">
			<table class="table no_bbt">
				<caption class="hidden">Cash Transaction History table</caption>
				<colgroup>
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col />
					<col width="10%" />
					<col />
					<col width="10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Trans. ID" : "Mã GD") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Trans. date" : "Ngày GD") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Trans. type" : "Loại giao dịch") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Amount (VND)" : "Số tiền (VND)") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Notes" : "Ghi chú") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Last update" : "Ngày cập nhật cuối") %></th>
					</tr>
				</thead>
				<tbody id="trCashTranHistoryFull">
				</tbody>
			</table>
		</div>

		<div class="pagination">
		</div>
	</div>
	<!-- // Cash Transaction History -->
</div>
</html>
