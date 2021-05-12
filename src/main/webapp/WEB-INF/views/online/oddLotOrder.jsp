<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script>
	$(document).ready(function() {
		enquiryOddLot();
		oddLotHistoryEnquiry();
		
		var d = new Date();		
		var weeks = getWeeksInMonth(d.getMonth(), d.getFullYear());			
		$("#rFromDate").html((weeks[1].start + 1) + "/" + (d.getMonth()+1) + "/" + d.getFullYear());
		$("#rToDate").html((weeks[1].end - 1) + "/" + (d.getMonth()+1) + "/" + d.getFullYear());
	});

	function authCheckOK(divType){
		if(divType == "submitInCashAdvance"){
			submitAdvancePaymentCreation();
		} else if(divType == "submitCashAdvanceInLoan"){
			submitAdvancePaymentCreationInLoan();
		} else if(divType == "submitInLoanRefund"){
			submitLoanRefundCreation();
		} else if (divType == "submitBankAdvancePayment") {
			submitBankAdvancePayment();
		} else if (divType == "submitInOnlineSignOrder") {
			submitOnlineSignOrder();
		}
	}
	
	function enquiryOddLot(){
		$("#divOddLotOrder").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/enquiryOddLot.do",
			data      : param,
			cache	  : false,
			success   : function(data) {
				//console.log("ODD LOGT CHECK");
				//console.log(data);
			 	if(data.jsonObj.oddLotList != null){
			 		var oddLotListStr = "";
			 		for(var i=0; i<data.jsonObj.oddLotList.length; i++){
			 			oddLotListStr += "<tr>";
		 				oddLotListStr += "	<td class=\"text_center\"><input name=\"chkval\" type=\"checkbox\" value=\""+data.jsonObj.oddLotList[i].marketId +"|"
		 								+ data.jsonObj.oddLotList[i].stockCode  + "|"
		 				 				+ data.jsonObj.oddLotList[i].location  + "|"
		 							 	+ data.jsonObj.oddLotList[i].oddLotQty 
		 							 	+"\"/></td>";
	 					oddLotListStr += "	<td class=\"text_center\">" + data.jsonObj.oddLotList[i].stockCode + "</td>";
	 					oddLotListStr += "	<td class=\"text_center\">" + data.jsonObj.oddLotList[i].settledBal + "</td>";
	 					oddLotListStr += "	<td class=\"text_center\">" + data.jsonObj.oddLotList[i].oddLotQty + "</td>";
	 					oddLotListStr += "	<td>" + data.jsonObj.oddLotList[i].nominalPrice + "</td>";
 						oddLotListStr += "	<td>" + data.jsonObj.oddLotList[i].collectionPrice + "</td>";
						oddLotListStr += "</tr>";

			 		}
			 		$("#oddLotList").html(oddLotListStr);
			 	}
			 	$("#divOddLotOrder").unblock();
		    },
		    error	:function(e) {
		    	console.log(e);
		    	$("#divOddLotOrder").unblock();
		    }
		});
	}

	function oddLotHistoryEnquiry(limit, page){
		$("#divOddLotHistory").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/oddLotHistoryEnquiry.do",
			data      : param,
			cache	  : false,
			success   : function(data) {
				//console.log("===oddLotHistoryEnquiry===");
				//console.log(data);
			 	if(data.jsonObj.historyList != null){
			 		var historyListStr = "";
			 		for(var i=0; i<data.jsonObj.historyList.length; i++){
			 			historyListStr += "<tr>";
			 			historyListStr += "	<td class=\"text_center\">" + data.jsonObj.historyList[i].createTime + "</td>";
			 			historyListStr += "	<td class=\"text_center\">" + data.jsonObj.historyList[i].valueDate + "</td>";
			 			historyListStr += "	<td class=\"text_center\">" + data.jsonObj.historyList[i].instrumentId + "</td>";
		 				historyListStr += "	<td>" + data.jsonObj.historyList[i].appliedQty + "</td>";
	 					historyListStr += "	<td>" + numDotCommaFormat(data.jsonObj.historyList[i].price) + "</td>";
 						historyListStr += "	<td>" + numDotCommaFormat(data.jsonObj.historyList[i].fee) + "</td>";
						historyListStr += "	<td></td>";												// 미확정
						historyListStr += "	<td>" + numDotCommaFormat(data.jsonObj.historyList[i].settleAmt) + "</td>";
						historyListStr += "	<td class=\"text_center\">" + changeState(data.jsonObj.historyList[i].status) + "</td>";
						historyListStr += "</tr>";
			 		}
			 		$("#historyList").html(historyListStr);
			 	}
			 	$("#divOddLotHistory").unblock();

		    },
		    error	:function(e) {
		    	console.log(e);
		    	$("#divOddLotHistory").unblock();
		    }
		});

		//console.log("oddLotHistoryEnquiry");
	}

	//getAnnouncement.action
	// 목록 Check 후 Register 입력시 Action
	// 파라미터값 없음.
	// We do not register to buy odd-lot stock now 메시지 뜸.
	/*
		### Response 값 ###
		annoucementId	:	""
		mvResult	:	null
	*/
	function getAnnouncement() {
		var cnt	=	0;
		$("input[name=chkval]:checked").each(function() {
			cnt++;
		});
		
		if(cnt == 0) {
			if ("<%= langCd %>" == "en_US") {
				alert("Please choose one stock at least.");
		 	} else {
		 		alert("Vui lòng chọn ít nhất 1 mã CK.");
		 	}			
			return;
		}
		
		var param = {
				mvClientID	: 	"<%= session.getAttribute("clientID") %>"
		};

		$.ajax({
			url		  :'/online/data/getAnnouncement.do',
			data	  :param,
			cache	  : false,
		    dataType  : 'json',
		    success: function(data){
			 	//console.log("===getAnnouncement===");
		    	//console.log(data);
			 	if(data == null || data.jsonObj.annoucementId == null || data.jsonObj.annoucementId == "") {
			 		if ("<%= langCd %>" == "en_US") {
				 		alert("We do not register to buy odd-lot stock now");
				 	} else {
				 		alert("Hiện tại chúng tôi không đăng ký mua chứng khoán lô lẻ");
				 	}
			 		return;
			 	} else {
			 		var annoucementId	=	data.jsonObj.annoucementId;
			 		oddLotOrder(annoucementId);
			 	}
		    },
		    error	:function(e) {
		    	console.log(e);
		    }
		});
	}

	function changeState(stus){
		switch(stus){
			case "D":
				stus = "Approved";
				break;
			case "H":
				stus = "Waiting Approval";
				break;
			case "O":
				stus = "Open";
				break;
		}
		return stus;
	}
	
	
	function oddLotOrder(annoucementId) {
		var chkval	=	"";
		var cnt		=	0;
		$("input[name=chkval]:checked").each(function() {
			if(cnt == 0) {
				chkval	+=	$(this).val();
			} else {
				chkval	+=	"," + $(this).val();
			}
			cnt++;
		});		
		
		var param = {
				divId   : "divIdAuthOddLot",
				divType : "submitInOddLotOrder"			//	after action(online.jsp check)
				, annoucementId	:	annoucementId
				, chkval	:	chkval
		}
		//console.log("##PARAM CHECK##");
		//console.log(param);
		$.ajax({
			type     : "POST",
			url      : "/online/popup/oddLotOrder.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				//console.log(data);
				$("#divIdAuthOddLot").fadeIn();
				$("#divIdAuthOddLot").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function getWeeksInMonth(month, year){
		   var weeks=[],
		       firstDate=new Date(year, month, 1),
		       lastDate=new Date(year, month+1, 0), 
		       numDays= lastDate.getDate();
		   
		   var start=1;
		   var end=7-firstDate.getDay();
		   while(start<=numDays){
		       weeks.push({start:start,end:end});
		       start = end + 1;
		       end = end + 7;
		       if(end>numDays)
		           end=numDays;    
		   }        
		    return weeks;
		}   
	
</script>
<div class="tab_content online">
	<div role="tabpanel" class="tab_pane" id="tab3">
		<div id="divOddLotOrder" class="grid_area" style="height:270px;">
			<div class="group_table">
				<table class="table">
					<caption><%= (langCd.equals("en_US") ? "Odd Lot Order" : "Đặt lệnh giao dịch lô lẻ") %></caption>
					<colgroup>
						<col width="30" />
						<col />
						<col />
						<col />
						<col />
						<col />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trading qtty" : "Số dư GD") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Odd lot qtty" : "SL lô lẻ") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Current Price" : "Giá hiện tại") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Executed Price" : "Giá GD lô lẻ") %></th>
						</tr>
					</thead>
					<tbody id="oddLotList">
					</tbody>
				</table>
			</div>
		</div>
		<div class="mdi_bottom left">
			<input class="color" type="submit" value="<%= (langCd.equals("en_US") ? "Register" : "Đăng ký") %>" onclick="getAnnouncement()">
			<label style="color:#333;font-weight:600;"><%= (langCd.equals("en_US") ? "From" : "Từ") %></label>
			<label style="color:blue;" id="rFromDate"></label>
			<label style="color:#333;font-weight:600;"><%= (langCd.equals("en_US") ? "To" : "Đến") %></label>
			<label style="color:blue;" id="rToDate"></label>
		</div>
		<div id="divOddLotHistory" class="grid_area" style="height:275px;">
			<div class="group_table">
				<table class="table">
					<caption><%= (langCd.equals("en_US") ? "Odd Lot Transaction History" : "Tra cứu lịch sử giao dịch chúng khoán lô lẻ") %></caption>
					<thead>
						<tr>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trans Date" : "Ngày GD") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Approve Date" : "Ngày xác nhận") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Odd lot qtty" : "SL lô lẻ") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Executed price" : "Giá thực hiện") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Tax" : "Thuế") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Fee" : "Phí") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Value (VND)" : "Giá trị (VND)") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
						</tr>
					</thead>
					<tbody id="historyList">
					</tbody>
				</table>
			</div>
		</div>

		<div class="desc">
		<% if(langCd.equals("en_US")) { %>
			<p style="color:#f08200;">The Company buys odd-lot shares on working days of the second week of every month.</p>
			<p style="color:#f08200;">The Company makes odd-lot shares transfer procedures with the VSD and makes payment on Client's trading account after odd-lot transaction has been approved by the VSD.</p>
			<p style="color:#f08200;">The company only buys odd-lot shares listed on HSX that are not under warning, supervision or trading suspension status.</p>
			<p style="color:#f08200;">For odd-lot stocks on HNX/UPCOM, Customer can place a sell order at floor or through online trading.</p>
		<% } else { %>
			<p style="color:#f08200;">Công ty thực hiện mua cổ phiếu lô lẻ của khách hàng vào các ngày làm việc của tuần thứ 2 mỗi tháng.</p>
			<p style="color:#f08200;">Công ty thực hiện các nghiệp vụ chuyển khoản lô lẻ với VSD và thanh toán tiền vào tài khoản giao dịch chứng khoán của Khách hàng tại Công ty sau khi giao dịch lô lẻ được VSD chấp thuận.</p>
			<p style="color:#f08200;">Công ty chỉ thực hiện mua cổ phiếu lô lẻ niêm yêt trên HSX không thuộc diện bị cảnh báo, bị kiểm soát, bị tạm ngừng giao dịch.</p>
			<p style="color:#f08200;">Đối với cổ phiếu lô lẻ niêm yết trên HNX/UPCOM, Khách hàng tự đặt lệnh bán trên sàn hoặc trên chức năng đặt lệnh giao dịch trực tuyến</p>
		<% } %>
		</div>
	</div>
</div>
</html>
