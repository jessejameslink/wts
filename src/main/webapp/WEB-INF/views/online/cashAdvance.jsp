<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var lvAdvAvaiable = 0; // Cash advance available 값

	var t2AdvAvailable = 0;
	var t1AdvAvailable = 0;
	var t0AdvAvailable = 0;
	var t2Days = 0;
	var t1Days = 0;
	var t0Days = 0;
	var interestRate = 0;

	$(document).ready(function() {
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		getCashAdvancePlace();
		getOrderMatchingList();
		getCashAdvanceTransaction();
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
	
	function resetData(){
		$("#advanceAmount").val("");
		$("#txtAdvanceAmount").val("0");
	}

	// Key Event
	function keyDownEvent(){
		if($("#txtAdvanceAmount").val() == "0"){
			$("#txtAdvanceAmount").val("");
		}
	}

	function keyUpEvent() {
		//console.log("ON KEY UP EVENT");
		var tempValue = parseInt($("#txtAdvanceAmount").val().replace(/,/g,''));
		var advAmt = tempValue;
		$("#txtAdvanceAmount").val(tempValue);

		var tempFee = 0;
		var cont = true;

		if($("#txtAdvanceAmount").val() == "NaN"){
			$("#txtAdvanceAmount").val("0");
			$("#advanceFee").html(0);
		} else {
			if(t2AdvAvailable > 0){
				if(advAmt > t2AdvAvailable){
					tempFee += parseFloat(t2AdvAvailable)*parseFloat(t2Days)*parseFloat(interestRate)/360/100;
					advAmt = advAmt - t2AdvAvailable;
				}else {
					tempFee += parseFloat(advAmt)*parseFloat(t2Days)*parseFloat(interestRate)/360/100;
					cont = false;
				}
			}

			if(cont && t1AdvAvailable > 0){
				if(advAmt > t1AdvAvailable){
					tempFee += parseFloat(t1AdvAvailable)*parseFloat(t1Days)*parseFloat(interestRate)/360/100;
					advAmt = advAmt - t1AdvAvailable;
				}else {
					tempFee += parseFloat(advAmt)*parseFloat(t1Days)*parseFloat(interestRate)/360/100;
					cont = false;
				}
			}

			if(cont && t0AdvAvailable > 0){
				if(advAmt > t0AdvAvailable){
					tempFee += parseFloat(t0AdvAvailable)*parseFloat(t0Days)*parseFloat(interestRate)/360/100;
					advAmt = advAmt - t0AdvAvailable;
				}else {
					tempFee += parseFloat(advAmt)*parseFloat(t0Days)*parseFloat(interestRate)/360/100;
					cont = false;
				}
			}
			$("#advanceFee").html(numIntFormat(parseInt(tempFee)));
		}
		$("#advanceAmount").val(tempValue);
		$("#txtAdvanceAmount").val(numIntFormat(tempValue));
	}

	function doValidateAdvance() {
		var advPayment = numIntFormat(parseFloat($("#txtAdvanceAmount").val().replace(/,/g,'')));
		//console.log(advPayment);
		if (advPayment <= 0) {
	    	//TTLUtils.showMessage( messageBox.title.error, messageBox.message.noAmount);
	        if ("<%= langCd %>" == "en_US") {
	        	alert("Amount should not be blank");	
	        } else {
	        	alert("Số lượng không thế trống");
	        }
	    	return;
	    } else if(parseFloat($("#txtAdvanceAmount").val().replace(/,/g,'')) > parseFloat(lvAdvAvaiable) * 1000){
	    	if ("<%= langCd %>" == "en_US") {
				alert("Insufficient Fund!");
	    	} else {
	    		alert("Vượt quá số tiền được ứng!");
	    	}
			return
		}else{
			checkAdvancePaymentTime();			
		}
	}

	function checkAdvancePaymentTime() {
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};
		$.ajax({
			dataType  : "json",
			url       : "/online/data/checkAdvancePaymentTime.do",
			data	  : param,
			aync      : true,
			cache	  : false,
			success   : function(data) {
				//console.log(data);
				if(data.jsonObj.mvResult == ""){
					if ("<%= authenMethod %>" != "matrix") {
						cashAdvanceCheckOTP();
					} else {
						authCheckCashAdv();
					}
				} else {
					alert("data.jsonObj.mvResult");
				}
			}
		});
	}
	


	function authCheckCashAdv() {
		var param = {
				divId   : "divIdAuthCashAdv",
				divType : "submitInCashAdvance"
		}

		$.ajax({
			type     : "POST",
			url      : "/common/popup/authConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdAuthCashAdv").fadeIn();
				$("#divIdAuthCashAdv").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function cashAdvanceCheckOTP() {
		var param = {
				mvUserID 		: '<%=session.getAttribute("ClientV")%>'
			};
		$.ajax({
			url      : "/trading/data/mCheckOTP.do",
			contentType	:	"application/json; charset=utf-8",
			data     : param,
			dataType : "json",
			success  : function(data) {
				//console.log("Check OTP");
				//console.log(data);
				if (data.otpResponseCheck.result != "0") {
					authOtpCheckCashAdv();
				} else {
					submitAdvancePaymentCreation();
				}
			}
		});	
	}
	
	function authOtpCheckCashAdv() {
		var param = {
				divId               : "divIdOTPCashAdv",
				divType             : "submitInCashAdvance"
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/otpConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdOTPCashAdv").fadeIn();
				$("#divIdOTPCashAdv").html(data);
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}

	
	function submitAdvancePaymentCreation() {
		$("#divIdAuthCashAdv").block({message: "<span>LOADING...</span>"});
		
		var param = {
				mvSubAccountID			: 	"<%= session.getAttribute("subAccountID") %>",
				mvClientName			: 	"<%= session.getAttribute("ClientV") %>",
				lvAdvAvaiable			:numIntFormat(parseFloat(lvAdvAvaiable) * 1000),
				lvAdvRequest			:$("#advanceAmount").val(),
				lvAmount				:$("#advanceAmount").val()/1000
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/submitAdvancePaymentCreation.do",
			data      : param,
			success   : function(data) {
				//console.log("submitAdvancePaymentCreation");
				//console.log(data);
				alert(data.jsonObj.errorMessage);
				resetData();
				getCashAdvancePlace();
				getOrderMatchingList();
				getCashAdvanceTransaction();
				$("#divIdAuthCashAdv").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divIdAuthCashAdv").unblock();
			}
		});
	}

	function getCashAdvancePlace(){
		$("#divCashAdvancePlace").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/getLocalAdvanceCreation.do",
			data      : param,
			aync      : true,
			cache: false,
			success   : function(data) {
				//console.log("getLocalAdvanceCreation");
				//console.log(data);
				if(data.jsonObj.mvAdvanceBean != null){
					$("#cashAdvanceAvailable").html(numDotCommaFormat(data.jsonObj.mvAdvanceBean.advAvailable));
					$("#advanceFee").html(numDotCommaFormat(Math.floor(data.jsonObj.mvAdvanceBean.advFee*1000)/1000));

					lvAdvAvaiable = data.jsonObj.mvAdvanceBean.advAvailable;

					t2AdvAvailable = data.jsonObj.mvAdvanceBean.t2AdvAvailable * 1000;
					t1AdvAvailable = data.jsonObj.mvAdvanceBean.t1AdvAvailable * 1000;
					t0AdvAvailable = data.jsonObj.mvAdvanceBean.t0AdvAvailable * 1000;
					t2Days = data.jsonObj.mvAdvanceBean.t2Days;
					t1Days = data.jsonObj.mvAdvanceBean.t1Days;
					t0Days = data.jsonObj.mvAdvanceBean.t0Days;
					interestRate = data.jsonObj.mvAdvanceBean.interestRate;
				}
				$("#divCashAdvancePlace").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divCashAdvancePlace").unblock();
			}

		});
	}

	function getCashAdvanceTransaction(){
		$("#divCashAdvanceTransaction").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/getCashAdvanceHistory.do",
			data      : param,
			aync      : true,
			cache: false,
			success   : function(data) {
				//console.log("getCashAdvanceHistory");
				//console.log(data);
			 	if(data.jsonObj.list != null){
			 		var strList = "";
			 		for(var i = 0; i<data.jsonObj.list.length; i++){
			 			strList += "<tr>"
					 				+ "<td class='text_center'>" + data.jsonObj.list[i].creationTime + "</td>"		//
					 				+ "<td class='text_center'>" + numDotCommaFormat(data.jsonObj.list[i].totalLendingAmt) + "</td>" 	// 콤마(.) * 1000
					 				+ "<td class='text_center'>" + numDotCommaFormat(data.jsonObj.list[i].interestAccured) + "</td>" 	// Ad fee
					 				+ "<td class='text_center'>" + statusChange(data.jsonObj.list[i].status) + "</td>"		//	Status
					 				+ "<td class='text_center'>" + data.jsonObj.list[i].lastApprovaltime + "</td>"		// Last Update
					 				+ "<td class='text_center'>" + (data.jsonObj.list[i].status? "":"Your cash advance available will not change utill it is approved" ) + "</td>"		// Note
					 				+ "</td>";
					}
					$("#advanceTransaction").html(strList);
				}
			 	$("#divCashAdvanceTransaction").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divCashAdvanceTransaction").unblock();
			}

		});
	}

	function getOrderMatchingList() {
		$("#divOrderMatchingList").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/querySoldOrders.do",
			data      : param,
			aync      : true,
			cache: false,
			success   : function(data) {
				//console.log("querySoldOrders");
				//console.log(data);
			 	if(data.jsonObj.mvChildBeanList.length > 0){
			 		var strList = "";
			 		for(var i = 0; i<data.jsonObj.mvChildBeanList.length; i++){
			 			strList += "<tr>"
					 				+ "<td class='text_center'>" + data.jsonObj.mvChildBeanList[i].mvOrderID + "</td>"		//	ID
					 				+ "<td class='text_center'>" + data.jsonObj.mvChildBeanList[i].tradeDate + "</td>" 	// MatchingDate
					 				+ "<td class='text_center'>" + data.jsonObj.mvChildBeanList[i].cashSettleDay + "</td>" 	// MatchingDate
					 				+ "<td class='text_center'>" + data.jsonObj.mvChildBeanList[i].mvStockID + "</td>"		//
					 				+ "<td class='text_center'>" + data.jsonObj.mvChildBeanList[i].mvQuantity + "</td>"		//
					 				+ "<td class='text_center'>" + numIntFormat(numDotComma(data.jsonObj.mvChildBeanList[i].mvAmount)) + "</td>"		//
					 				+ "<td class='text_center'>" + numIntFormat(numDotComma(data.jsonObj.mvChildBeanList[i].tradingFee)) + "</td>"		//
					 				+ "</tr>";
					}
					$("#matchingList").html(strList);
				}
				if(data.jsonObj.mvErrorCode != "OLS0000") {
					alert("Error code : " + data.jsonObj.mvErrorCode + "\nErr Msg : " + data.jsonObj.errorMessage);
				}
				$("#divOrderMatchingList").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divOrderMatchingList").unblock();
			}
		});
	}


	function statusChange(stus){
		switch(stus){
			case "I":
				if ("<%= langCd %>" == "en_US") {
				stus = "Pending";
				} else {
					stus = "Chờ xủ lý";
				}
				break;
			case "A":
				if ("<%= langCd %>" == "en_US") {
				stus = "Authorized";
				} else {
					stus = "Ủy quyền";
				}
				break;
			case "S":
				if ("<%= langCd %>" == "en_US") {
				stus = "Settled";
				} else {
					stus = "Duyệt";
				}
				break;
			case "C":
				if ("<%= langCd %>" == "en_US") {
				stus = "Cancelled";
				} else {
					stus = "Đã hủy";
				}
				break;
			case "P":
				if ("<%= langCd %>" == "en_US") {
				stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
		}
		return stus;
	}

</script>

<div class="tab_content online">
	<div role="tabpanel" class="tab_pane" id="tab1">
		<div class="wrap_left">
			<div id="divCashAdvancePlace" class="group_table">
				<table class="table no_bbt list_type_01 bg">
					<caption><%= (langCd.equals("en_US") ? "Cash Advance Place" : "Thực hiện ứng trước") %></caption>
					<colgroup>
						<col width="150" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Cash advance available" : "Khả năng ứng trước") %></th>
							<td id="cashAdvanceAvailable"></td>
						</tr>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Advance fee" : "Phí ứng trước") %></th>
							<td id="advanceFee"></td>
						</tr>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Advance amount" : "Số tiền ứng trước") %></th>
							<td class="input">
								<input class="text won" type="text" id="txtAdvanceAmount" value="0" onkeydown="keyDownEvent()" onkeyup="keyUpEvent()"/>
								<input type="hidden" id="advanceAmount" name="advanceAmount" value="" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="mdi_bottom">
				<input type="submit" class="color" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>" onclick="doValidateAdvance();">
				<input type="reset" value="<%= (langCd.equals("en_US") ? "Clear" : "Xóa") %>" onclick="resetData();">
			</div>
		</div>
		<div class="wrap_right">
			<div id="divCashAdvanceTransaction" class="grid_area" style="height:318px;">
				<div class="group_table">
					<table class="table">
						<caption><%= (langCd.equals("en_US") ? "Cash Advance Transaction" : "Giao dịch ứng trước trong ngày") %></caption>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Date" : "Ngày GD") %></th>
								<th><%= (langCd.equals("en_US") ? "Advance amount" : "Số tiền ứng") %></th>
								<th><%= (langCd.equals("en_US") ? "Advance fee" : "Phí ứng trước") %></th>
								<th><%= (langCd.equals("en_US") ? "Processing status" : "Trạng thái xử lý") %></th>
								<th><%= (langCd.equals("en_US") ? "Last update" : "Thời gian cập nhật") %></th>
								<th><%= (langCd.equals("en_US") ? "Note" : "Lưu ý") %></th>
							</tr>
						</thead>
						<tbody id="advanceTransaction"></tbody>

					</table>
				</div>
			</div>
			<div id="divOrderMatchingList" class="grid_area" style="height:317px;">
				<div class="group_table">
					<table class="table">
						<caption><%= (langCd.equals("en_US") ? "Order Matching List" : "Danh sách lệnh khớp") %></caption>
						<colgroup>
							<col width="12%" />
							<col width="12%" />
							<col width="12%" />
							<col />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "ID" : "Số lệnh") %></th>
								<th><%= (langCd.equals("en_US") ? "Matching Date" : "Ngày khớp") %></th>
								<th><%= (langCd.equals("en_US") ? "Payment Date" : "Ngày thanh toán") %></th>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
								<th><%= (langCd.equals("en_US") ? "Value (VND)" : "Gía trị (VND)") %></th>
								<%-- 
								<th><%= (langCd.equals("en_US") ? "Fee" : "Phí") %></th>
								<th><%= (langCd.equals("en_US") ? "Tax" : "Thuế") %></th>
								 --%>
								<th><%= (langCd.equals("en_US") ? "Fee + Tax" : "Phí + Thuế") %></th>
							</tr>
						</thead>
						<tbody id="matchingList"></tbody>

					</table>
				</div>
			</div>
		</div>
	</div>
</div>

</html>
