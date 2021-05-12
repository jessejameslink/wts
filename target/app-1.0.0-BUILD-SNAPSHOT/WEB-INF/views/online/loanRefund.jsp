<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	/*
	*	Cash Advance 코드
	*/
	var loanLvAdvAvaiable = 0; // Cash advance available 값

	var loanT2AdvAvailable = 0;
	var loanT1AdvAvailable = 0;
	var loanT0AdvAvailable = 0;
	var loanT2Days = 0;
	var loanT1Days = 0;
	var loanT0Days = 0;
	var loanInterestRate = 0;
	/*
	*	Cash Advance 코드 End
	*/

	$(document).ready(function() {
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		getLocalLoanRefundCreation();
		getLocalAdvanceCreation();
		getMarginInterestPayment();			// Temp.. 미정의
		getLoanRefundData();
		getLoanRefundHistory();
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
	// Loan Refund 내역조회 1
	function getLocalLoanRefundCreation(){
		$("#divLoanRefund").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/getLocalLoanRefundCreation.do",
			data      : param,
			asyc      : true,
			cache	  : false,
			success   : function(data){
				//console.log("--------getLocalLoanRefundCreation--------");
				//console.log(data);				
				if(data.jsonObj.mvLoanBean != null) {
					$("#beginningLoanValue").val(data.jsonObj.mvLoanBean.loan);

					$("#beginningLoan").html(numDotCommaFormat(data.jsonObj.mvLoanBean.loan));
					$("#availableCashForRefund").html(numDotCommaFormat(data.jsonObj.mvLoanBean.cashrsv));
					$("#cashAdvanceable").html(numDotCommaFormat(data.jsonObj.mvLoanBean.advAvailable));
				} else {

				}
				$("#divLoanRefund").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divLoanRefund").unblock();
			}
		});
	}

	function checkLoanRefundTime(){		
		var fundAmount = parseInt($("#txtLoanRefundAmount").val().replace(/,/g,''));
		var availableCashForRefund = parseInt($("#availableCashForRefund").text().replace(/,/g,''));
		
		if (fundAmount <= 0) {
	        if ("<%= langCd %>" == "en_US") {
	        	alert("Refund Amount should not be blank. Please complete function Cash Advance before performing function Loan refund.");	
	        } else {
	        	alert("Số tiền trả nợ không đủ. Quý khách hàng vui lòng hoàn tất thực hiện chức năng Ứng trước tiền bán chứng khoán trước khi thực hiện giao dịch Hoàn trả vay ký quỹ.");
	        }
	    	return;
	    } 
		else if(availableCashForRefund <= 0){
	    	if ("<%= langCd %>" == "en_US") {
				alert("Available Amount should not be blank. please complete function Cash Advance before performing function Loan refund.");
	    	} else {
	    		alert("Khả năng trả nợ không đủ. Quý khách hàng vui lòng hoàn tất thực hiện chức năng Ứng trước tiền bán chứng khoán trước khi thực hiện giao dịch Hoàn trả vay ký quỹ.");
	    	}
			return;
		}else if(availableCashForRefund < fundAmount){
			if ("<%= langCd %>" == "en_US") {
				alert("Please complete function Cash Advance before performing function Loan refund.");
	    	} else {
	    		alert("Khả năng trả nợ nhỏ hơn tiền hoàn trả vay. Quý khách hàng vui lòng hoàn tất thực hiện chức năng Ứng trước tiền bán chứng khoán trước khi thực hiện giao dịch Hoàn trả vay ký quỹ.");
	    	}
			return;			
		}
		
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  	: "json",
			url      	: "/online/data/checkLoanRefundTime.do",
			data     	: param,
			asyc      	: true,
			cache		: false,
			success		: function(data){
				//console.log("===checkLoanRefundTime===");
				//console.log(data);
				if(data.jsonObj.mvResult != "SUCCESS"){
					alert(data.jsonObj.errorMessage);
				}else{					
					if ("<%= authenMethod %>" != "matrix") {
						loanRefundCheckOTP("submitInLoanRefund");
					} else {
						authCheckInLoan("submitInLoanRefund");
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function utoa(data) {
		  return btoa(unescape(encodeURIComponent(data)));
		}

	function submitLoanRefundCreation(){
		var encodeBase64 = utoa($("#txtRemark").val());
		$("#divLoanRefund").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",				
				lvLoanPay			: $("#loanRefundAmount").val(), 		   // 전송 금액
				lvAmount			: parseFloat($("#loanRefundAmount").val()) / 1000,		   // = lvLoanPay	/ 1000
				lvRemark 			:$("#txtRemark").val(),
				mvBase64			: encodeBase64
		};

		$.ajax({
			dataType  	: "json",
			url      	: "/online/data/submitLoanRefundCreation.do",
			data     	: param,
			asyc      	: true,
			success		: function(data){
				//console.log("===submitLoanRefundCreation===");
				//console.log(data);
				if(data.jsonObj.mvResult == "FAILED"){
					$("#divLoanRefund").unblock();
					if ("<%= langCd %>" == "en_US") {
						//alert("Loan refund failed.");
						alert(data.jsonObj.errorMessage);
					} else {
						//alert("Hoàn trả tiền vay thất bại.");
						alert(data.jsonObj.errorMessage);
					}
				} else {
					$("#divLoanRefund").unblock();
					if ("<%= langCd %>" == "en_US") {
						alert("Loan refund successfully.");	
					} else {
						alert("Hoàn trả tiền vay thành công.");
					}
					getLocalLoanRefundCreation();
					getLoanRefundData();
					clearData("loanRefund");	
				}	
			},
			error     :function(e) {
				console.log(e);
				$("#divLoanRefund").unblock();
			}
		});
	}

	// Loan Refund 내역조회 2
	function getLocalAdvanceCreation(){
		$("#divLoanRefund2").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/getLocalAdvanceCreation.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				//console.log("===getLocalAdvanceCreation===");
				//console.log(data);
				if(data.jsonObj.mvAdvanceBean != null){
					$("#cashAdvanceAvailableInLoan").html(numDotCommaFormat(data.jsonObj.mvAdvanceBean.advAvailable));
					$("#advanceFeeInLoan").html(numDotCommaFormat(Math.floor(data.jsonObj.mvAdvanceBean.advFee*1000)/1000));

					/*
					*	Cash Advance 코드
					*/
					loanLvAdvAvaiable = data.jsonObj.mvAdvanceBean.advAvailable;

					loanT2AdvAvailable = data.jsonObj.mvAdvanceBean.t2AdvAvailable * 1000;
					loanT1AdvAvailable = data.jsonObj.mvAdvanceBean.t1AdvAvailable * 1000;
					loanT0AdvAvailable = data.jsonObj.mvAdvanceBean.t0AdvAvailable * 1000;
					loanT2Days = data.jsonObj.mvAdvanceBean.t2Days;
					loanT1Days = data.jsonObj.mvAdvanceBean.t1Days;
					loanT0Days = data.jsonObj.mvAdvanceBean.t0Days;
					loanInterestRate = data.jsonObj.mvAdvanceBean.interestRate;
					/*
					*	Cash Advance 코드 End
					*/
				} else {

				}
				$("#divLoanRefund2").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divLoanRefund2").unblock();
			}
		});
	}


	/*
	* 2016.09.30 - AS-IS 및 TO-BE 명시 안되어있음
	*
	*/
	function getMarginInterestPayment(){
		$("#divMarginInterestPayment").block({message: "<span>LOADING...</span>"});
		var param = {
		};
		$("#divMarginInterestPayment").unblock();
	}

	// Loan Refund Transaction Status 조회
	function getLoanRefundData(){
		$("#divLoanRefundList").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};		
		
		$.ajax({
			dataType  : "json",
			url      : "/online/data/getLoanRefundData.do",
			data     : param,
			success  : function(data){
				//console.log("===LOAN REFUND DATA===");
				//console.log(data);
				if(data.jsonObj != null && data.jsonObj.loanrefundList != null && data.jsonObj.loanrefundList.length > 0 ) {
					for(var i = 0; i < data.jsonObj.loanrefundList.length; i++){

						var loanTranStatusStr = "";
						for(var i = 0; i < data.jsonObj.loanrefundList.length; i++){
							loanTranStatusStr += "<tr>";
							loanTranStatusStr += "	<td class=\"text_center\">" + data.jsonObj.loanrefundList[i].tranID + "</td>";
							loanTranStatusStr += "	<td class=\"text_center\">" + data.jsonObj.loanrefundList[i].tradeDate + "</td>";
							loanTranStatusStr += "	<td>" + numDotCommaFormat(data.jsonObj.loanrefundList[i].refundAmt) + "</td>";
							loanTranStatusStr += "	<td>" + data.jsonObj.loanrefundList[i].type + "</td>";
							loanTranStatusStr += "	<td class=\"text_center\">" + data.jsonObj.loanrefundList[i].status + "</td>";
							loanTranStatusStr += "	<td>" + data.jsonObj.loanrefundList[i].remark + "</td>";		// remark = ${remark} != 'For Margin Call' ? ${remark}?'For Margin Call'
							loanTranStatusStr += "	<td class=\"text_center\">" + data.jsonObj.loanrefundList[i].lastupdate + "</td>";
							loanTranStatusStr += "</tr>";
						}
						$("#loanRefundList").html(loanTranStatusStr);
					}
				} else {

				}
				$("#divLoanRefundList").unblock();
			},
			error     :function(e) {
				//console.log("ERROR-------------");
				console.log(e);
				$("#divLoanRefundList").unblock();
			}
		});
	}

	// Loan Refund Transaction History 조회
	function getLoanRefundHistory(){
		$("#divLoanReTranHistory").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID		: "<%= session.getAttribute("subAccountID") %>",
				mvStartDate			: $("#mvStartDate").val(),
				mvEndDate			: $("#mvEndDate").val()
		};

		$.ajax({
			dataType : "json",
			url      : "/online/data/getLoanRefundHistory.do",
			data     : param,
			asyc     : true,
			cache	 : false,
			success  : function(data){				
				//console.log("======LOAN REFUND HISTORY======>");
				//console.log(data);				
				if(data.jsonObj.loanrefundhistoryList != null && data.jsonObj.loanrefundhistoryList.length > 0 ) {
					var loanHistoryStr = "";
					for(var i = 0; i < data.jsonObj.loanrefundhistoryList.length; i++){
						loanHistoryStr += "<tr>";
						loanHistoryStr += "	<td class=\"text_center\">" + data.jsonObj.loanrefundhistoryList[i].tranID + "</td>";
						loanHistoryStr += "	<td class=\"text_center\">" + data.jsonObj.loanrefundhistoryList[i].tradeDate + "</td>";
						loanHistoryStr += "	<td>" + numDotCommaFormat(data.jsonObj.loanrefundhistoryList[i].refundAmt) + "</td>";
						loanHistoryStr += "	<td>" + changeSymbol(data.jsonObj.loanrefundhistoryList[i].type, "type") + "</td>";
						loanHistoryStr += "	<td class=\"text_center\">" + changeSymbol(data.jsonObj.loanrefundhistoryList[i].status, "status") + "</td>";
						loanHistoryStr += "	<td>" + data.jsonObj.loanrefundhistoryList[i].remark + "</td>";
						loanHistoryStr += "	<td class=\"text_center\">" + data.jsonObj.loanrefundhistoryList[i].lastupdate + "</td>";
						loanHistoryStr += "</tr>";
					}
					$("#loanHistoryList").html(loanHistoryStr);
				} else {

				}
				$("#divLoanReTranHistory").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divLoanReTranHistory").unblock();
			}
		});
	}

	function changeSymbol(value, symbol){
		if(symbol == "type"){
			switch(value){
				case "A":
					value = "Auto Repayment";
					break;
				case "M":
					value = "Repayment by Request";
					break;
			}
		} else if(symbol == "status"){
			switch(value){
				case "A":
					value = "Approved";
					break;
				case "P":
					value = "Pending Approval";
					break;
			}
		}
		return value;
	}

	// Cash Advance 실행 시
	function doValidateAdvanceInLoan() {
		var advPayment = parseInt($("#txtLoanAdvanceAmount").val());
		if (advPayment <= 0) {
	        if ("<%= langCd %>" == "en_US") {
	        	alert("Amount should not be blank");	
	        } else {
	        	alert("Số tiền ứng lớn hơn không.");
	        }
	    	return;
	    } else if(parseInt($("#txtLoanAdvanceAmount").val().replace(/,/g,'')) > parseFloat(loanLvAdvAvaiable) * 1000){
	    	if ("<%= langCd %>" == "en_US") {
				alert("Insufficient Fund!");
	    	} else {
	    		alert("Vượt quá số tiền được ứng!");
	    	}
			return
		}else{
			checkAdvancePaymentTimeInLoan();			
		}
	}

	function checkAdvancePaymentTimeInLoan() {
		var param = {
				mvSubAccountID		: "<%= session.getAttribute("subAccountID") %>"
		};
		$.ajax({
			dataType  : "json",
			url       : "/online/data/checkAdvancePaymentTime.do",
			data	  : param,
			cache	  : false,
			success   : function(data) {
				if(data.jsonObj.mvResult.length > 0){
					alert("err : mvResult.length > 0\n" + data.mvResult);
				} else {
					if ("<%= authenMethod %>" != "matrix") {
						loanRefundCheckOTP("submitCashAdvanceInLoan");
					} else {
						authCheckInLoan("submitCashAdvanceInLoan");
					}
				}
			}
		});
	}

	// Cash Advance 실행 후
	function authCheckInLoan(divType) {
		var param = {
				divId   : "divIdAuthLoanRefund",
				divType : divType
		}

		$.ajax({
			type     : "POST",
			url      : "/common/popup/authConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdAuthLoanRefund").fadeIn();
				$("#divIdAuthLoanRefund").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});

	}

	function submitAdvancePaymentCreationInLoan() {
		$("#divLoanRefund2").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID			: "<%= session.getAttribute("subAccountID") %>",
				mvClientName			: "<%= session.getAttribute("ClientV") %>",
				lvAdvAvaiable			:numIntFormat(parseFloat(lvAdvAvaiable) * 1000),
				lvAdvRequest			:$("#loanAdvanceAmount").val(),
				lvAmount				:$("#loanAdvanceAmount").val()/1000
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/submitAdvancePaymentCreation.do",
			data      : param,
			success   : function(data) {
				alert(data.jsonObj.errorMessage);
				getLocalLoanRefundCreation();
				getLocalAdvanceCreation();
				getMarginInterestPayment();			// Temp.. 미정의
				clearData('cashAdvance');
				$("#divLoanRefund2").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divLoanRefund2").unblock();
			}
		});
	}

	function clearData(target){
		if(target == "cashAdvance"){
			$("#loanAdvanceAmount").val("");
			$("#txtLoanAdvanceAmount").val("0");
			$("#advanceFeeInLoan").html("0");
		} else if(target == "loanRefund"){
			$("#loanRefundAmount").val("");
			$("#txtLoanRefundAmount").val("0");
			$("#txtRemark").val("");
		}else if(target == "marginInterestPayment"){

		}
	}

	function loanKeyDownEvent(curTypingField){
		if(curTypingField == "loanAdvanceAmount"){
			if($("#txtLoanAdvanceAmount").val() == "0"){
				$("#txtLoanAdvanceAmount").val("");
			}
		} else if(curTypingField == "loanRefundAmount"){
			if($("#txtLoanRefundAmount").val() == "0"){
				$("#txtLoanRefundAmount").val("");
			}
		}
	}

	function loanKeyUpEvent(curTypingField) {
		if(curTypingField == "loanAdvanceAmount"){
			var tempValue = parseInt($("#txtLoanAdvanceAmount").val().replace(/,/g,''));
			var advAmt = tempValue;
			$("#txtLoanAdvanceAmount").val(tempValue);

			var tempFee = 0;
			var cont = true;

			if($("#txtLoanAdvanceAmount").val() == "NaN"){
				$("#txtLoanAdvanceAmount").val("0");
				$("#advanceFeeInLoan").html(0);
			} else {
				if(loanT2AdvAvailable > 0){
					if(advAmt > loanT2AdvAvailable){
						tempFee += parseFloat(loanT2AdvAvailable)*parseFloat(loanT2Days)*parseFloat(loanInterestRate)/360/100;
						advAmt = advAmt - loanT2AdvAvailable;
					}else {
						tempFee += parseFloat(advAmt)*parseFloat(loanT2Days)*parseFloat(loanInterestRate)/360/100;
						cont = false;
					}
				}

				if(cont && loanT1AdvAvailable > 0){
					if(advAmt > loanT1AdvAvailable){
						tempFee += parseFloat(loanT1AdvAvailable)*parseFloat(loanT1Days)*parseFloat(loanInterestRate)/360/100;
						advAmt = advAmt - loanT1AdvAvailable;
					}else {
						tempFee += parseFloat(advAmt)*parseFloat(loanT1Days)*parseFloat(loanInterestRate)/360/100;
						cont = false;
					}
				}

				if(cont && loanT0AdvAvailable > 0){
					if(advAmt > loanT0AdvAvailable){
						tempFee += parseFloat(loanT0AdvAvailable)*parseFloat(loanT0Days)*parseFloat(loanInterestRate)/360/100;
						advAmt = advAmt - loanT0AdvAvailable;
					}else {
						tempFee += parseFloat(advAmt)*parseFloat(loanT0Days)*parseFloat(loanInterestRate)/360/100;
						cont = false;
					}
				}
				$("#advanceFeeInLoan").html(numIntFormat(parseInt(tempFee)));
			}
			$("#loanAdvanceAmount").val(tempValue);
			$("#txtLoanAdvanceAmount").val(numIntFormat(tempValue));

		} else if(curTypingField == "loanRefundAmount"){
			$("#txtLoanRefundAmount").val(parseInt($("#txtLoanRefundAmount").val().replace(/,/g,'')));

			if($("#txtLoanRefundAmount").val() == "NaN"){
				$("#txtLoanRefundAmount").val(0);
				$("#loanRefundAmount").val(0);
			} else {
				$("#loanRefundAmount").val($("#txtLoanRefundAmount").val());
				$("#txtLoanRefundAmount").val(numIntFormat($("#txtLoanRefundAmount").val()));
			}
		}
	}
	
	function loanRefundCheckOTP(divType) {
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
					authOtpCheckLoanFund(divType);
				} else {
					if (divType == "submitCashAdvanceInLoan") {
						submitAdvancePaymentCreationInLoan();
					} else {
						submitLoanRefundCreation();
					}
				}
			}
		});	
	}
	
	function authOtpCheckLoanFund(divType) {
		var param = {
				divId               : "divIdOTPLoanRefund",
				divType             : divType
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/otpConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdOTPLoanRefund").fadeIn();
				$("#divIdOTPLoanRefund").html(data);
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
</script>
<div class="tab_content online">
	<div role="tabpanel" class="tab_pane" id="tab5">
		<div class="loan_top">
			<div class="pull_left" style="width: 50%;">
				<div id="divLoanRefund" class="group_table">
					<table class="table no_bbt list_type_01">
						<caption><%= (langCd.equals("en_US") ? "Loan Refund" : "Hoàn trả vay ký quỹ") %></caption>
						<colgroup>
							<col width="150" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Beginning Loan" : "Dư nợ đầu ngày") %></th>
								<td id="beginningLoan">
									<input type="hidden" id="beginningLoanValue" name="beginningLoan" value="" />
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Available cash for refund" : "Khả năng trả nợ") %></th>
								<td id="availableCashForRefund"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash advanceable" : "Khả năng ứng trước") %></th>
								<td id="cashAdvanceable"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Loan refund amount" : "Số tiền hoàn trả") %></th>
								<td class="input">
									<input type="hidden" id="loanRefundAmount" name="loanRefundAmount" value="" />
									<input type="text" class="text won" id="txtLoanRefundAmount" value="0" onkeydown="loanKeyDownEvent('loanRefundAmount')" onkeyup="loanKeyUpEvent('loanRefundAmount')" />
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Remark" : "Ghi chú") %></th>
								<td class="input">
									<input type="text" class="text won" id="txtRemark"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="mdi_bottom">
					<input class="color" type="submit" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>" onclick="checkLoanRefundTime()" />
					<input type="reset" value="<%= (langCd.equals("en_US") ? "Clear" : "Xóa") %>" onclick="clearData('loanRefund')" />
				</div>
			</div>

			<div class="pull_left" style="width: 49%;">
				<div id="divLoanRefund2" class="group_table">
					<table class="table no_bbt list_type_01">
						<caption><%= (langCd.equals("en_US") ? "Cash Advance" : "Khả năng ứng trước") %></caption>
						<colgroup>
							<col width="150" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash advance available" : "Khả năng ứng trước") %></th>
								<td id="cashAdvanceAvailableInLoan"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Advance fee" : "Phí ứng trước") %></th>
								<td id="advanceFeeInLoan"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Advance amount" : "Số tiền ứng") %></th>
								<td class="input">
									<input type="hidden" id="loanAdvanceAmount" name="loanAdvanceAmount" value="" />
									<input class="text won" type="text" id="txtLoanAdvanceAmount" value="0" onkeydown="loanKeyDownEvent('loanAdvanceAmount')" onkeyup="loanKeyUpEvent('loanAdvanceAmount')"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="mdi_bottom">
					<input class="color" type="submit" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>" onclick="doValidateAdvanceInLoan();">
					<input type="reset" value="<%= (langCd.equals("en_US") ? "Clear" : "Xóa") %>" onclick="clearData('cashAdvance');">
				</div>
			</div>

			<div class="pull_left" style="display: none;">
				<div id="divMarginInterestPayment" class="group_table">
					<table class="table no_bbt list_type_01">
						<caption><%= (langCd.equals("en_US") ? "Margin Interest Payment" : "Thanh toán lãi vay ký quỹ") %></caption>
						<colgroup>
							<col width="150" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash balance" : "Số dư tiền mặt") %></th>
								<td>0</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Margin interest" : "Lãi vay ký quỹ") %></th>
								<td>0</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Interest amount" : "Số tiền trả lãi") %></th>
								<td class="input">
									<input type="text" class="text won" />
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="mdi_bottom">
					<input class="color" type="submit" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>">
					<input type="reset" value="<%= (langCd.equals("en_US") ? "Clear" : "Xóa") %>">
				</div>
			</div>
		</div>
		<!-- // .loan top -->

		<div id="divLoanRefundList" class="grid_area" style="height:180px;">
			<div class="group_table">
				<table class="table">
					<caption><%= (langCd.equals("en_US") ? "Loan Refund Transaction Status" : "Trạng thái giao dịch hoàn trả vay ký quỹ") %></caption>
					<thead>
						<tr>
							<th scope="col"><%= (langCd.equals("en_US") ? "ID" : "STT") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trading Date" : "Ngày giao dịch") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Loan refund amount" : "Số tiền hoàn trả") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Type" : "Loại giao dịch") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Processing Status" : "Trạng thái xử lý") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Remark" : "Ghi chú") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Last update" : "Ngày cập nhật cuối") %></th>
						</tr>
					</thead>
					<tbody id="loanRefundList">
					</tbody>
				</table>
			</div>
		</div>

		<div class="search_area in">
			<label for="fromSearch3"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input id="mvStartDate" name="mvStartDate" type="text" class="datepicker" />

			<label for="toSearch3"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input id="mvEndDate" name="mvEndDate" type="text" class="datepicker" />

			<button class="confirm" type="button" onclick="getLoanRefundHistory();"><%= (langCd.equals("en_US") ? "Execute" : "Tra cứu") %></button>
		</div>

		<div id="divLoanReTranHistory" class="grid_area" style="height:180px;">
			<div class="group_table">
				<table class="table">
					<caption><%= (langCd.equals("en_US") ? "Loan Refund Transaction History" : "Lịch sử giao dịch hoàn trả vay ký quỹ") %></caption>
					<thead>
						<tr>
							<th scope="col"><%= (langCd.equals("en_US") ? "ID" : "STT") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Trading Date" : "Ngày giao dịch") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Loan refund amount" : "Số tiền hoàn trả") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Type" : "Loại giao dịch") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Processing Status" : "Trạng thái xử lý") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Remark" : "Ghi chú") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Last update" : "Ngày cập nhật cuối") %></th>
						</tr>
					</thead>
					<tbody id="loanHistoryList">
					</tbody>
				</table>
			</div>
		</div>

		<div class="desc">
		<% if(langCd.equals("en_US")) { %>
			<p>The Refund loan request has to be made before 4:30pm.</p>
			<p>Customer wants to refund loan by cash advanceable, please complete function "Cash Advance" before performing function "Loan refund".</p>
		<% } else { %>
			<p>Thực hiện hoàn trả vay ký quỹ phải được thực hiện trước 4g30 chiều của ngày giao dịch.</p>
			<p>Trong trường hợp Quý khách hàng muốn "Hoàn trả vay ký quỹ" bằng tiền ứng trước. Quý khách hàng vui lòng hoàn tất thực hiện chức năng "ứng trước tiền bán chứng khoán" trước khi thực hiện giao dịch "Hoàn trả vay ký quỹ".</p>
		<% } %>
		</div>
	</div>
</div>

</html>
