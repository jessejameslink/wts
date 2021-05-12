<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var pTranID = "";
	var pStatus = "";
	var isBank =  false;
	$(document).ready(function() {
		getQueryBankInfo();
		$("#divAccountNumber").hide();
		$("#divAccountNumber_reg").hide();
		var d = new Date();
		getSubAccount();
		//genfundtransfer();
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		$(".transfer_type input").on("change", function() {
			var tg = $(this).attr("data-tg");
			$(".tf_place").removeClass("on").filter("." + tg).addClass("on");
		});

		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$("#cmvEndDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		d.setMonth(d.getMonth() - 1);
		$("#cmvStartDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
	});
	
	function getSubAccount() {
		var param = {
				mvClientID	:	"<%= session.getAttribute("clientID") %>"
			};

			$.ajax({
				dataType  : "json",
				cache		: false,
				url       : "/trading/data/getSubAccount.do",
				data      : param,
				success   : function(data) {
					//console.log("Sub Account List");
					//console.log(data);
					/* $("#ojTranferSubAccountCash option").remove();
					for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
						$("#ojTranferSubAccountCash").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + "</option>");
					} */
					$("#ojSubAccount").val(<%= session.getAttribute("defaultSubAccount") %>);
					genfundtransfer();
				},
				error     :function(e) {					
					console.log(e);
				}
			});
	}
	
	function chgSubAccountB(val) {			
		//changeSubAccount($("#ojTranferSubAccountCash option:selected").text(), val);
		genfundtransfer();
	}
	
	function genfundtransfer() {
		var param = {
				<%-- mvSubAccountID		: 	"<%= session.getAttribute("subAccountID") %>", --%>
				mvSubAccountID		: 	$("#ojSubAccount option:selected").text(),
				mvTransactionType	: ""
		}
		
		$.ajax({
			dataType  : "json",
			url       : "/banking/data/genfundtransfer.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				$("#ulAccountNumber_reg").find("li").remove();
				if(data.jsonObj != null) {
					//console.log("====genfundtransfer CASH TRANSFER====BANKING====")
					//console.log(data);
					if(data.jsonObj.mvErrorCode != "1") {
						
						$("#mvAvailable").val(data.jsonObj.mvAvailable);
						$("#mvBalance").val(data.jsonObj.mvBalance);
						$("#chargeRate").val(data.jsonObj.chargeRate);
						$("#mvFundTransferFrom").val(data.jsonObj.mvFundTransferFrom);
	
						$("#tdCashbalance").html(numIntFormat(numDotComma(data.jsonObj.mvCashBalance)));
						$("#tdCashwithdrawable").html((isBank ==  false)?numIntFormat(numDotComma(data.jsonObj.mvAvailable)):"0");
						$("#tdCashbalance_reg").html(numIntFormat(numDotComma(data.jsonObj.mvCashBalance)));
						$("#tdCashwithdrawable_reg").html(numIntFormat(numDotComma(data.jsonObj.mvAvailable)));
	
						if(data.jsonObj.mvReceiversList != null) {
							var accountNumberStr = "";
							for(var i=0; i < data.jsonObj.mvReceiversList.length; i++) {
								var accont = data.jsonObj.mvReceiversList[i];
								accountNumberStr += "<li><a onclick=\"accountNumberChange_reg('" + accont.receiverAccID + "', '" + accont.receiverBankName + "', '" + accont.receiverName + "', '" + accont.minFeeAmt + "', '" + accont.maxFeeAmt + "', '" + accont.transferFee + "')\" style=\"cursor: pointer;\">" + accont.receiverAccID + "</a></li>";
								$("#ulAccountNumber_reg").html(accountNumberStr);
							}
						}
					} else {
						alert(data.jsonObj.mvErrorResult);						
						return;
					}
				}

				hksCashTransactionHistory();
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function hksCashTransactionHistory() {
		$("#tab1").block({message: "<span>LOADING...</span>"});
		var param = {
				<%-- mvSubAccountID		: 	"<%= session.getAttribute("subAccountID") %>", --%>
				mvSubAccountID		: 	$("#ojSubAccount option:selected").text(),
				mvStartDate       : $("#cmvStartDate").val(),
				mvEndDate         : $("#cmvEndDate").val(),
				mvStatus		  : $("#ojStatus").val(),
				tradeType		  : "FUND",
				mvTransferType	  : "W",
				limit             : $("#limit").val(),
				start             : ($("#page").val() == "0" ? "0" : (($("#page").val() - 1) * $("#limit").val())),
				page              : $("#page").val()
		};
		
		//console.log(param);

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/hksCashTransactionHistory.do",
			asyc      : true,
			cache	  : false,
			data      : param,
			success   : function(data) {
				//console.log("===CASHTRANSFER hksCashTransactionHistory===");
				//console.log(data);
				if(data.jsonObj != null) {
					var cashAdvanceTransaction = "";

					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var hcth = data.jsonObj.list[i];
							var status = hcth.status;
							cashAdvanceTransaction += "<tr>";
							cashAdvanceTransaction += "	<td class=\"text_center\">";
							if(status == "A") {
								cashAdvanceTransaction += "		<button type=\"button\" class=\"btn buy\" onclick=\"selectCashTransactionHistory('" + hcth.receiveClientID + "','" + status + "','" + hcth.ownerName  + "','" + hcth.bankName  + "','" + hcth.bankBranch + "')\"><%= (langCd.equals("en_US") ? "Select" : "Chọn") %></button>";
							}
							cashAdvanceTransaction += "	</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + getTranType(hcth.transType) + "</td>"; // Transfer Type
							cashAdvanceTransaction += "	<td class=\"text_center\">" + upDownNumList(String(Number(hcth.totalLendingAmt)*1000)) + "</td>"; // Transfer amount
							cashAdvanceTransaction += "	<td class=\"text_center\">";
							cashAdvanceTransaction += "		<div>" + (hcth.receiveClientID == "" ? "-" : hcth.receiveClientID) + "</div>"; // Beneficiary account
							cashAdvanceTransaction += "		<div>" + (hcth.ownerName == "" ? "-" : hcth.ownerName) + "</div>"; // Beneficiary name
							cashAdvanceTransaction += "	</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">";
							cashAdvanceTransaction += "		<div>" + (hcth.bankName == "" ? "-" : hcth.bankName) + "</div>";     // Bank name
							cashAdvanceTransaction += "		<div>" + (hcth.bankBranch == "" ? "-" : hcth.bankBranch) + "</div>"; // Bank branch
							cashAdvanceTransaction += "	</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">" + getStatus(status) + "</td>"; // Status
							cashAdvanceTransaction += "	<td class=\"text_center\">";
							cashAdvanceTransaction += "		<div>" + (hcth.lastApprovaltime == "" ? "-" : hcth.lastApprovaltime) + "</div>"; // Approve Time
							cashAdvanceTransaction += "		<div>" + (hcth.creationTime == "" ? "-" : hcth.creationTime) + "</div>";         // Date
							cashAdvanceTransaction += "	</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">";
							if(status == "P") {
								if ("<%= authenMethod %>" != "matrix") {
									cashAdvanceTransaction += "		<button type=\"button\" class=\"btn_cancel\" onclick=\"authOtpCheck('cancel', '" + hcth.tranID + "','" + status + "','" + hcth.minFeeAmt  + "','" + hcth.minFeeAmt  + "','" + hcth.minFeeAmt + "')\"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>";
								} else {
									cashAdvanceTransaction += "		<button type=\"button\" class=\"btn_cancel\" onclick=\"authCheck('cancel', '" + hcth.tranID + "','" + status + "','" + hcth.minFeeAmt  + "','" + hcth.minFeeAmt  + "','" + hcth.minFeeAmt + "')\"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>";
								}
							}
							cashAdvanceTransaction += "	</td>";
							cashAdvanceTransaction += "</tr>";
						}
					}
					drawPage(data.jsonObj.totalCount, $("#limit").val(), (parseInt($("#page").val()) == "0" ? "1" : parseInt($("#page").val())));
					$("#trCashAdvanceTransaction").html(cashAdvanceTransaction);
				}
				$("#tab1").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab1").unblock();
			}
		});
	}

	function getTranType(transType) {
		if(transType == "I") {
			if ("<%= langCd %>" == "en_US") {
			return "Internal";
			} else {
				return "Nội bộ";
			}
		} else if(transType == "W") {
			if ("<%= langCd %>" == "en_US") {
			return "External";
			} else {
				return "Ngân hàng";
			}
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

	function getAccountNumber() {
		$("#minFeeAmt").val("0");
		$("#maxFeeAmt").val("0");
		$("#transferFee").val("0");

		if($("#accountNumber").val() == "") {
			$("#divAccountNumber").hide();
			return;
		}

		$("#divAccountNumber").show();
		$("#accountNumber").val($("#accountNumber").val().toUpperCase());
	}

	function getAccountNumber_reg() {
		$("#minFeeAmt").val("0");
		$("#maxFeeAmt").val("0");
		$("#transferFee").val("0");

		if($("#accountNumber_reg").val() == "") {
			$("#divAccountNumbe_regr").hide();
			return;
		}

		$("#divAccountNumber_reg").show();
		$("#accountNumber_reg").val($("#accountNumber_reg").val().toUpperCase());
	}

	function onFocusIn(tagId) {
		if($("#" + tagId).val() == "0") {
			$("#" + tagId).val("");
		}
	}

	function onFocusOut(tagId) {
		if($("#" + tagId).val() == "") {
			$("#" + tagId).val("0");
		}
	}

	function transferAmountCalc() {
		var mvAmount   = $("#transferAmount").val().replace(/,/g,'');
		var chargeRate = $("#chargeRate").val();
		$("#transferAmount").val(numIntFormat(mvAmount));
		$("#mvAmount").val(mvAmount / 1000);
		if(mvAmount != "" && mvAmount != "0" &&  parseFloat(mvAmount) > 0){
			var fee = parseFloat(chargeRate) * parseFloat(mvAmount) / 100;
			$("#txtRealFee").val(fee);

			if(parseFloat(chargeRate) > 0) {
				var minF = parseFloat($("#minFeeAmt").val());
				var maxF = parseFloat($("#maxFeeAmt").val());

				if(minF > fee) {
					$("#txtRealFee").val(minF);
				} else if(maxF < fee){
					$("#txtRealFee").val(maxF);
				}
			}
		} else {
			if(Number(mvAmount) <= 0) {
				$("#transferAmount").val(0);
			}
		
			$("#txtRealFee").val("0");
		}
	}

	function transferAmountCalc_reg() {
		var mvAmount   = $("#transferAmount_reg").val().replace(/,/g,'');
		var chargeRate = $("#chargeRate").val();
		$("#transferAmount_reg").val(numIntFormat(mvAmount));
		$("#mvAmount_reg").val(mvAmount / 1000);
		if(mvAmount != "" && mvAmount != "0" &&  parseFloat(mvAmount) > 0){
			var fee = parseFloat(chargeRate) * parseFloat(mvAmount) / 100;
			$("#txtRealFee").val(fee);

			if(parseFloat(chargeRate) > 0) {
				var minF = parseFloat($("#minFeeAmt").val());
				var maxF = parseFloat($("#maxFeeAmt").val());

				if(minF > fee) {
					$("#txtRealFee").val(minF);
				} else if(maxF < fee){
					$("#txtRealFee").val(maxF);
				}
			}
		} else {
		
		
			if(Number(mvAmount) <= 0) {
				$("#transferAmount_reg").val(0);
			}
		
			$("#txtRealFee").val("0");
		}
	}

	function divAccountShowHide(tagId) {
		if($("#" + tagId).css("display") == "none") {
			$("#" + tagId).show();
		} else {
			$("#" + tagId).hide();
		}
	}

	function accountNumberChange(receiverAccID, bankName, receiverName, minFeeAmt, maxFeeAmt, transferFee) {
		$("#divAccountNumber").hide();
		$("#accountNumber").val(receiverAccID);
		$("#fullname").val(receiverName);
		$("#bankName").val(bankName);
		$("#minFeeAmt").val(minFeeAmt);
		$("#maxFeeAmt").val(maxFeeAmt);
		$("#transferFee").val(transferFee);
	}
	
	function accountNumberChange_reg(receiverAccID, bankName, receiverName, minFeeAmt, maxFeeAmt, transferFee) {
		$("#divAccountNumber_reg").hide();
		$("#accountNumber_reg").val(receiverAccID);
		$("#tdFullName_reg").html(receiverName);
		$("#tdBank_reg").html(bankName);
		
	}

	function authCheck(divGubun, tranID, status) {
		pTranID = tranID;
		pStatus = status;

		var param = {
				divId               : "divIdAuthCashTransfer",
				divType             : divGubun
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/authConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdAuthCashTransfer").fadeIn();
				$("#divIdAuthCashTransfer").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function authCheckOK(divGubun) {
		if(divGubun == "submit") {
			dofundtransfer();
		} else if(divGubun == "submit_reg") {
			dofundtransfer_reg();
		} else if(divGubun == "cancel") {
			cancelFundTransfer();
		}
	}

	function cashTransferPlaceCancel() {
		$("#accountNumber").val("");
		$("#bankBranch").val("");
		$("#transferAmount").val("0");
		$("#remark").val("");
		$("#fullname").val("");
		$("#bankName").val("");
	}

	function cashTransferPlaceCancel_reg() {
		$("#tdFullName_reg").html("");
		$("#tdBank_reg").html("");

		$("#accountNumber_reg").val("");
		$("#transferAmount_reg").val("0");
		$("#remark_reg").val("");
		$("#bankBranch_reg").val("");
	}

	function getQueryBankInfo() {
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/queryBankInfo.do",
			data      : param,
			aync      : true,
			cache	  : false,
			success   : function(data) {
				//console.log("QUERY BANK CALL R6");
				//console.log(data);
				if(data.jsonObj.mvBankInfoList.length > 0) {
					var optLst	=	"";
					
					for(var i=0; i < data.jsonObj.mvBankInfoList.length; i++) {
						var obj	=	data.jsonObj.mvBankInfoList[i];
						if (obj.mvIsDefault == true) {
							isBank = true;
						}
					}
					if (isBank == true) {							
						if ("<%= langCd %>" == "en_US") {
							alert("The accounts have to trading via bank.");	
						} else {
							alert("Tài khoản giao dịch qua ngân hàng.");
						}
						return;
					}
					return;
				}
			}
		});
	}
	function checkFundTransferTime() {
		
		if(isBank == true) {
			if ("<%= langCd %>" == "en_US") {
				alert("The accounts have to trading via bank.");	
			} else {
				alert("Tài khoản giao dịch qua ngân hàng.");
			}
			return;
		}

		
		if($("#accountNumber").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please select an account to transfer.");	
			} else {
				alert("Chọn tài khoản để chuyển");
			}

			return;
		}

		if($("#transferAmount").val() < 1) {
			if ("<%= langCd %>" == "en_US") {
				alert("Amount should not be blank.");	
			} else {
				alert("Số lượng không thế trống");
			}
			return;
		}

		$("#tab1").block({message: "<span>LOADING...</span>"});
		var param = {
				<%-- mvSubAccountID		: 	"<%= session.getAttribute("subAccountID") %>", --%>
				mvSubAccountID		: 	$("#ojSubAccount option:selected").text(),
		}
		$.ajax({
			dataType  : "json",
			url       : "/banking/data/checkFundTransferTime.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				if(data != null) {
					$("#tab1").unblock();
					if(data.jsonObj.mvFundTransferResult == "SUCCESS") {
						if ("<%= authenMethod %>" != "matrix") {
							authOtpCheck("submit", "", "");
						} else {
							authCheck("submit", "", "");
						}
					} else {
						alert(data.jsonObj.mvFundTransferResult);
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab1").unblock();
			}
		});
	}

	function checkFundTransferTime_reg() {
		if($("#accountNumber_reg").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please select an account to transfer.");	
			} else {
				alert("Chọn tài khoản để chuyển");
			}

			return;
		}

		if($("#transferAmount_reg").val() < 1) {
			if ("<%= langCd %>" == "en_US") {
				alert("Amount should not be blank.");	
			} else {
				alert("Số lượng không thế trống");
			}
			return;
		}
		
		if($("#bankBranch_reg").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input bank branch.");	
			} else {
				alert("Vui lòng nhập tên chi nhánh.");
			}
			return;
		}

		$("#tab1").block({message: "<span>LOADING...</span>"});
		var param = {
				<%-- mvSubAccountID		: 	"<%= session.getAttribute("subAccountID") %>", --%>
				mvSubAccountID		: 	$("#ojSubAccount option:selected").text(),
		}
		$.ajax({
			dataType  : "json",
			url       : "/banking/data/checkFundTransferTime.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				if(data != null) {
					$("#tab1").unblock();
					if(data.jsonObj.mvFundTransferResult == "SUCCESS") {
						if ("<%= authenMethod %>" != "matrix") {
							authOtpCheck("submit_reg", "", "");
						} else {
							authCheck("submit_reg", "", "");
						}						
					} else {
						alert(data.jsonObj.mvFundTransferResult);
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab1").unblock();
			}
		});
	}

	function dofundtransfer() {
		$("#tab1").block({message: "<span>LOADING...</span>"});
		var bankNameOp = $("#bankName option:selected").text();
		
		if ($("#fullname").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input full name.");	
			} else {
				alert("Vui lòng nhập tên người thụ hưởng.");
			}
			$("#tab1").unblock();
			$("#fullname").focus();
			return;
		}
		
		if ($("#bankName").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input bank name.");	
			} else {
				alert("Vui lòng nhập tên ngân hàng.");
			}
			$("#tab1").unblock();
			$("#bankName").focus();
			return;
		}
		
		if (bankNameOp == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input bank name.");	
			} else {
				alert("Vui lòng nhập tên ngân hàng.");
			}
			$("#tab1").unblock();
			$("#bankName").focus();
			return;
		}
		
		if ($("#bankBranch").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input bank branch.");	
			} else {
				alert("Vui lòng nhập tên chi nhánh.");
			}
			$("#tab1").unblock();
			$("#bankBranch").focus();
			return;
		}
		
		if ($("#remark").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				$("#remark").val("Cash Withdraw");	
			} else {
				$("#remark").val("Rut tien");
			}
		}
		
		var encodeBase64 = utoa($("#fullname").val() + "|" + bankNameOp + "|" + $("#bankBranch").val() + "|" + $("#remark").val());
		
		var param = {
				<%-- mvSubAccountID		: 	"<%= session.getAttribute("subAccountID") %>", --%>
				mvSubAccountID		: 	$("#ojSubAccount option:selected").text(),
				mvBankId            : "",
				mvDestClientID      : "<%= session.getAttribute("clientID") %>",
				mvDestBankID        : "",
				inputBankName       : bankNameOp,
				inputBankBranch     : $("#bankBranch").val(),
				mvDestAccountName   : $("#fullname").val(),
				mvAmount            : $("#mvAmount").val(),
				mvTransferType      : "W",
				mvRemark            : $("#remark").val(),				
				mvPersonCharged     : "1",
				mvWithdrawAmt       : $("#transferAmount").val(),
				mvAvaiableAmt       : numIntFormat(($("#mvAvailable").val().replace(/,/g,'')) * 1000),
				mvTransferFee       : $("#txtRealFee").val(),
				mvClientName		: "<%= session.getAttribute("ClientName") %>",
				mvDestBankAccountID	: $("#accountNumber").val(),
				mvDestTradingAccSeq	: "",
				mvBase64			: encodeBase64
		};

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/dofundtransfer.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				$("#tab1").unblock();
				
				$("#ojStatus").val("ALL");
				cashTransferPlaceCancel();
				cashTransferPlaceCancel_reg();
				genfundtransfer();

				//if(data.jsonObj.mvResult == "success") {
				alert(data.jsonObj.errorMessage);
				//}
			},
			error     :function(e) {
				console.log(e);
				$("#tab1").unblock();
			}
		});
	}
	
	function utoa(data) {
		  return btoa(unescape(encodeURIComponent(data)));
		}

	function dofundtransfer_reg() {
		$("#tab1").block({message: "<span>LOADING...</span>"});
		
		if ($("#bankBranch_reg").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input bank branch.");	
			} else {
				alert("Vui lòng nhập tên chi nhánh.");
			}
			$("#tab1").unblock();
			$("#bankBranch_reg").focus();
			return;
		}
		
		if ($("#remark_reg").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				$("#remark_reg").val("Cash Withdraw");	
			} else {
				$("#remark_reg").val("Rut tien");
			}
		}
		
		var encodeBase64 = utoa($("#tdFullName_reg").text() + "|" + $("#tdBank_reg").text() + "|" + $("#bankBranch_reg").val() + "|" + $("#remark_reg").val());
		
		var param = {
				<%-- mvSubAccountID		: 	"<%= session.getAttribute("subAccountID") %>", --%>
				mvSubAccountID		: 	$("#ojSubAccount option:selected").text(),
				mvBankId            : "",
				mvDestClientID      : "<%= session.getAttribute("clientID") %>",
				mvDestBankID        : "",
				inputBankName       : $("#tdBank_reg").text(),
				inputBankBranch     : $("#bankBranch_reg").val(),
				mvDestAccountName   : $("#tdFullName_reg").text(),
				mvAmount            : $("#mvAmount_reg").val(),
				mvTransferType      : "W",
				mvRemark            : $("#remark_reg").val(),				
				mvPersonCharged     : "1",
				mvWithdrawAmt       : $("#transferAmount_reg").val(),
				mvAvaiableAmt       : numIntFormat(($("#mvAvailable").val().replace(/,/g,'')) * 1000),
				mvTransferFee       : $("#txtRealFee").val(),
				mvClientName		: "<%= session.getAttribute("ClientName") %>",
				mvDestBankAccountID	: $("#accountNumber_reg").val(),
				mvDestTradingAccSeq	: "",
				mvBase64			: encodeBase64
		};

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/dofundtransfer.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				$("#tab1").unblock();

				cashTransferPlaceCancel();
				cashTransferPlaceCancel_reg();
				genfundtransfer();

				//if(data.jsonObj.mvResult != "success") {
				alert(data.jsonObj.errorMessage);
				//}
			},
			error     :function(e) {
				console.log(e);
				$("#tab1").unblock();
			}
		});
	}

	function cancelFundTransfer() {
		$("#tab1").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	  : 	"<%= session.getAttribute("subAccountID") %>",
				mvTranID          : pTranID,
				mvStatus          : pStatus
		};

		pTranID = "";
		pStatus = "";

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/cancelFundTransfer.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				if(data != null) {
					if(data.jsonObj.mainResult == "SUCCESS") {
						genfundtransfer();
						if ("<%= langCd %>" == "en_US") {
							alert("Cash transfer order is cancelled. Please check in History screen.");	
						} else {
							alert("Lệnh chuyển tiền đã bị hủy. Kiểm tra màn hình Lịch sử");
						}
					}
				}
				$("#tab1").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab1").unblock();
			}
		});
	}
	
	function selectCashTransactionHistory(receiveClientID, status, ownerName, bankName, bankBranch) {
		if (status == "A") {			
			$("#accountNumber").val(receiveClientID);
			$("#fullname").val(ownerName);
			$("#bankName").val(bankName);
			$("#bankBranch").val(bankBranch);
		}
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
		hksCashTransactionHistory();
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
	
	function convNum(v) {
		var rt	=	v.split(",").join("");
		rt		=	upDownNumList(String(parseFloat(rt)));
		return rt;
	}
	
	function formatNumber(num) {
		if(num.indexOf('.') != -1) {
			var priceSpl = num.split(".");
			if(priceSpl[1].length == 1) {
				num = priceSpl[0] + "." + priceSpl[1] + "00";
			} else if (priceSpl[1].length == 2) {
				num = priceSpl[0] + "." + priceSpl[1] + "0";
			}
		}
		return num;
	}
	
	function isNum() {
		var key	=	event.keyCode;
		if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)) {
			event.returnValue	=	false;
		}
	}
	
	// Key Event
	function keyDownEvent(id, e) {
		if ($("#" + id).val() == "0") {
			if (e.keyCode == "190") {
				$("#" + id).val("0");
			} else {
				$("#" + id).val("");
			}
		}
	}
	
	function cashTransferCheckOTP(divType) {
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
					authOtpCheck(divType, "", "");
				} else {
					if (divType == "submit") {
						dofundtransfer();
					} else {
						dofundtransfer_reg();
					}
				}
			}
		});	
	}
	
	function authOtpCheck(divType, tranID, status) {
		pTranID = tranID;
		pStatus = status;
		var param = {
				divId               : "divIdOTP",
				divType             : divType
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/otpConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdOTP").fadeIn();
				$("#divIdOTP").html(data);
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
</script>
<div class="tab_content banking">
	<input type="hidden" id="mvAvailable" name="mvAvailable" value="">
	<input type="hidden" id="mvBalance" name="mvBalance" value="">
	<input type="hidden" id="chargeRate" name="chargeRate" value="">
	<input type="hidden" id="mvFundTransferFrom" name="mvFundTransferFrom" value="">
	<input type="hidden" id="mvAmount" name="mvAmount" value="">
	<input type="hidden" id="mvAmount_reg" name="mvAmount_reg" value="">
	<input type="hidden" id="minFeeAmt" name="minFeeAmt" value="0">
	<input type="hidden" id="maxFeeAmt" name="maxFeeAmt" value="0">
	<input type="hidden" id="transferFee" name="transferFee" value="0">
	<input type="hidden" id="txtRealFee" name="txtRealFee" value="0">
	<input type="hidden" id="page" name="page" value="1"/>
	<input type="hidden" id="limit" name="limit" value="10"/>

	<div role="tabpanel" class="tab_pane" id="tab1">
		<div class="wrap_left">
			<div class="tf_place same on">
				<div class="group_table">
					<table class="table no_bbt list_type_01">
						<caption><%= (langCd.equals("en_US") ? "Cash Transfer Place" : "Thực hiện chuyển tiền") %></caption>
						<colgroup>
							<col width="150" />
							<col />
						</colgroup>
						<tbody>
							<%-- <tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Tranfer sub account" : "Chuyển từ tài khoản")%></th>
								<td class="text_left">
									<select style="margin-top:-3px;color:black;font-weight:600;" id="ojTranferSubAccountCash" onchange="chgSubAccountB(this.value);">
									</select>
								</td>
							</tr> --%>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash balance" : "Số dư tiền mặt<br />(được rút)") %></th>
								<td id="tdCashbalance"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash withdrawable" : "Số dư được rút<br />(bao gồm ứng trước)") %></th>
								<td id="tdCashwithdrawable"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Transfer type" : "Loại hình<br />chuyển khoản") %></th>
								<td class="text_left">
									<div>
										<input type="radio" id="type_ef" name="type_sm" value="1" checked="checked"/>
										<label for="type_ef"><%= (langCd.equals("en_US") ? "Transfer by Banking" : "Chuyển khoản qua Ngân Hàng") %></label>
									</div>
									<!--<div>
										<input type="radio" id="type_if" name="type_sm" value="2" disabled="disabled"/>
										<label for="type_if"><%= (langCd.equals("en_US") ? "Including fee" : "Phí trong") %></label>
									</div>-->
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Beneficiary<br />account number" : "Tài khoản ngân<br />hàng thụ hưởng") %></th>
								
								<td class="input">
									<input type="text" id="accountNumber" name="accountNumber" value=""/>
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Account type" : "Loại tài khoản") %></th>
								<td><%= (langCd.equals("en_US") ? "Banking Account" : "Tài khoản ngân hàng") %></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Beneficiary fullname" : "Người thụ hưởng") %></th>
								<td class="input"><input class="text" type="text" id="fullname" name="fullname" value=""></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Bank name" : "Tên ngân hàng<br />thụ hưởng") %></th>
								<!-- <td class="input"><input class="text" type="text" id="bankName" name="bankName" value=""></td> -->
								<td class="text_left">
									<select id="bankName" name="bankName">
										<option value="0"><%= (langCd.equals("en_US") ? "" : "") %></option>
										<option value="1"><%= (langCd.equals("en_US") ? "AB BANK" : "AB BANK") %></option>
										<option value="2"><%= (langCd.equals("en_US") ? "ACB" : "ACB") %></option>
										<option value="3"><%= (langCd.equals("en_US") ? "AGRI BANK" : "AGRI BANK") %></option>
										<option value="4"><%= (langCd.equals("en_US") ? "BAC A BANK" : "BAC A BANK") %></option>
										<option value="5"><%= (langCd.equals("en_US") ? "BAO VIET BANK" : "BAO VIET BANK") %></option>
										<option value="6"><%= (langCd.equals("en_US") ? "BIDV" : "BIDV") %></option>
										<option value="7"><%= (langCd.equals("en_US") ? "CB BANK" : "CB BANK") %></option>
										<option value="8"><%= (langCd.equals("en_US") ? "CO-OP BANK" : "CO-OP BANK") %></option>
										<option value="9"><%= (langCd.equals("en_US") ? "DONG A BANK" : "DONG A BANK") %></option>
										<option value="10"><%= (langCd.equals("en_US") ? "EXIM BANK" : "EXIM BANK") %></option>
										<option value="11"><%= (langCd.equals("en_US") ? "GP BANK" : "GP BANK") %></option>
										<option value="12"><%= (langCd.equals("en_US") ? "HDBANK" : "HDBANK") %></option>
										<option value="13"><%= (langCd.equals("en_US") ? "HONGLEONG BANK" : "HONGLEONG BANK") %></option>
										<option value="14"><%= (langCd.equals("en_US") ? "IBK" : "IBK") %></option>
										<option value="15"><%= (langCd.equals("en_US") ? "INDOVINA BANK" : "INDOVINA BANK") %></option>
										<option value="16"><%= (langCd.equals("en_US") ? "KIEN LONG BANK" : "KIEN LONG BANK") %></option>
										<option value="17"><%= (langCd.equals("en_US") ? "LD VIET NGA" : "LD VIET NGA") %></option>
										<option value="18"><%= (langCd.equals("en_US") ? "LIEN VIET POST BANK" : "LIEN VIET POST BANK") %></option>
										<option value="19"><%= (langCd.equals("en_US") ? "MSB" : "MSB") %></option>
										<option value="20"><%= (langCd.equals("en_US") ? "MBBANK" : "MBBANK") %></option>
										<option value="21"><%= (langCd.equals("en_US") ? "NAM A BANK" : "NAM A BANK") %></option>
										<option value="22"><%= (langCd.equals("en_US") ? "OCEAN BANK" : "OCEAN BANK") %></option>
										<option value="23"><%= (langCd.equals("en_US") ? "PG BANK" : "PG BANK") %></option>
										<option value="24"><%= (langCd.equals("en_US") ? "OCB" : "OCB") %></option>
										<option value="25"><%= (langCd.equals("en_US") ? "PVCOM BANK" : "PVCOM BANK") %></option>
										<option value="26"><%= (langCd.equals("en_US") ? "QUOC DAN" : "QUOC DAN") %></option>
										<option value="27"><%= (langCd.equals("en_US") ? "SACOMBANK" : "SACOMBANK") %></option>
										<option value="28"><%= (langCd.equals("en_US") ? "SAI GON-HA NOI" : "SAI GON-HA NOI") %></option>
										<option value="29"><%= (langCd.equals("en_US") ? "SAIGONBANK" : "SAIGONBANK") %></option>
										<option value="30"><%= (langCd.equals("en_US") ? "SEA BANK" : "SEA BANK") %></option>
										<option value="31"><%= (langCd.equals("en_US") ? "SHIN HAN" : "SHIN HAN") %></option>
										<option value="32"><%= (langCd.equals("en_US") ? "STANDARD CHARTERED BANK" : "STANDARD CHARTERED BANK") %></option>
										<option value="33"><%= (langCd.equals("en_US") ? "TECHCOMBANK" : "TECHCOMBANK") %></option>
										<option value="34"><%= (langCd.equals("en_US") ? "TMCP SAI GON" : "TMCP SAI GON") %></option>
										<option value="35"><%= (langCd.equals("en_US") ? "TPBANK" : "TPBANK") %></option>
										<option value="36"><%= (langCd.equals("en_US") ? "UOB" : "UOB") %></option>
										<option value="37"><%= (langCd.equals("en_US") ? "VIB" : "VIB") %></option>
										<option value="38"><%= (langCd.equals("en_US") ? "VID PUBLIC BANK" : "VID PUBLIC BANK") %></option>
										<option value="39"><%= (langCd.equals("en_US") ? "VIET A BANK" : "VIET A BANK") %></option>
										<option value="40"><%= (langCd.equals("en_US") ? "VIET CAPITAL BANK" : "VIET CAPITAL BANK") %></option>
										<option value="41"><%= (langCd.equals("en_US") ? "VIETCOMBANK" : "VIETCOMBANK") %></option>
										<option value="42"><%= (langCd.equals("en_US") ? "VIETINBANK" : "VIETINBANK") %></option>
										<option value="43"><%= (langCd.equals("en_US") ? "VP BANK" : "VP BANK") %></option>
										<option value="44"><%= (langCd.equals("en_US") ? "WOORI BANK VIET NAM" : "WOORI BANK VIET NAM") %></option>
										<option value="45"><%= (langCd.equals("en_US") ? "HANA BANK" : "HANA BANK") %></option>
										<%-- <option value="46"><%= (langCd.equals("en_US") ? "IBK" : "IBK") %></option>
										<option value="47"><%= (langCd.equals("en_US") ? "IBK" : "IBK") %></option> --%>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Bank branch" : "Chi nhánh") %></th>
								<td class="input"><input class="text" type="text" id="bankBranch" name="bankBranch" value=""></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Transfer amount" : "Số tiền chuyển khoản") %></th>
								<td class="input"><input class="text won" type="text" id="transferAmount" name="transferAmount" value="0" onkeyup="transferAmountCalc()" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" onkeypress="isNum();" onkeydown="keyDownEvent(this.id, event)"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Remark" : "Ghi chú") %></th>
								<td class="input"><input class="text" type="text" id="remark" name="remark" value=""></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="mdi_bottom cb">
					<input class="color" type="button" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>" onclick="checkFundTransferTime()"/>
					<input type="reset" value=<%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %> onclick="cashTransferPlaceCancel()"/>
				</div>
			<% if(langCd.equals("en_US")) { %>
				<p class="em">* Please enter the full name of  Beneficiary Bank and the Branch.<br/>* Or select an Approved transaction in the list.<br/>* Requests to transfer money from 8:00 to 16:00 to the bank account will be processed immediately after receiving the customer's request on MAS's system.<br/>* Orders after 16:00 will not take effect, please make your request on the next trading day.<br/>* Value customers are kindly following the guide cash transfer <a style="color: #ed5432!important;font-weight: bold;" href="https://www.masvn.com/cate/rut-tienchuyen-tien-893" target="_blank">here.</a> </p>
			<% } else { %>
				<p class="em">* Vui lòng điền đầy đủ tên ngân hàng thụ hưởng và chi nhánh.<br/>* Hoặc chọn lệnh chuyển tiền đã được chấp nhận trong danh sách.<br/>* Các yêu cầu chuyển tiền từ 8:00 -16:00 ra tài khoản ngân hàng sẽ được thực hiện ngay sau khi nhận được yêu cầu của khách hàng trên hệ thống của MAS.<br/>* Các lệnh sau 16:00 không có hiệu lực, Quý Khách hàng vui lòng thực hiện yêu cầu vào ngày giao dịch kế tiếp.<br/>* Quý khách có thể theo dõi Hướng dẫn chuyển tiền trực tuyến tại <a style="color: #ed5432!important;font-weight: bold;" href="https://www.masvn.com/cate/rut-tienchuyen-tien-893" target="_blank">đây.</a></p>
			<% } %>
			</div>
			<!-- // .tf_place.same -->

			<div class="tf_place reg">
				<div class="group_table">
					<table class="table no_bbt">
						<caption><%= (langCd.equals("en_US") ? "Cash Transfer Place" : "Thực hiện chuyển tiền") %></caption>
						<colgroup>
							<col width="54%" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash balance" : "Số dư tiền mặt") %></th>
								<td id="tdCashbalance_reg"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Cash withdrawable" : "Số dư được rút") %></th>
								<td id="tdCashwithdrawable_reg"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Transfer type" : "Loại hình<br />chuyển khoản") %></th>
								<td class="text_left">
									<div>
										<input type="radio" id="type_ef2" name="type_reg" value="1" checked="checked"/>
										<label for="type_ef2"><%= (langCd.equals("en_US") ? "Transfer by Banking" : "Chuyển khoản<br />qua Ngân Hàng") %></label>
									</div>
									<!--<div>
										<input type="radio" id="type_if2" name="type_reg" value="2" disabled="disabled"/>
										<label for="type_if2"><%= (langCd.equals("en_US") ? "Including fee" : "Phí trong") %></label>
									</div>-->
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Full name" : "Tên người thụ hưởng") %></th>
								<td id="tdFullName_reg"></td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Account Number" : "Số tài khoản thụ hưởng") %></th>
								<td class="text_left">
									<div class="input_dropdown">
										<span>
											<input type="text" id="accountNumber_reg" name="accountNumber_reg" onkeyup="getAccountNumber_reg()" style="width:82%;" disabled/>
											<button type="button" onclick="divAccountShowHide('divAccountNumber_reg')"></button>
										</span>
										<div id="divAccountNumber_reg">
											<ul id="ulAccountNumber_reg">
											</ul>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Bank" : "Ngân hàng thụ hưởng") %></th>
								<td id="tdBank_reg"></td>
							</tr>
							
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Bank branch" : "Chi nhánh") %></th>
								<td class="input"><input class="text" type="text" id="bankBranch_reg" name="bankBranch_reg" value=""></td>
							</tr>
							
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Transfer amount" : "Số tiền chuyển khoản") %></th>
								<td class="input"><input class="text won" type="text" id="transferAmount_reg" name="transferAmount_reg" value="0" onkeyup="transferAmountCalc_reg()" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" onkeypress="isNum();" onkeydown="keyDownEvent(this.id, event)" ></td>
							</tr>
							
							<tr>
								<th scope="row"><%= (langCd.equals("en_US") ? "Remark" : "Ghi chú") %></th>
								<td class="input"><input class="text" type="text" id="remark_reg" name="remark_reg" value=""></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="mdi_bottom cb">
					<input class="color" type="button" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>" onclick="checkFundTransferTime_reg()"/>
					<input type="reset" value="<%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %>" onclick="cashTransferPlaceCancel_reg()"/>
				</div>
			</div>
			<!-- // .tf_place.reg -->
		</div>
		<div class="wrap_right">
			<div class="transfer_type">
				<%= (langCd.equals("en_US") ? "Money transfer type :" : "Loại chuyển tiền:") %>
				<input type="radio" id="ba_sn" name="type" data-tg="same" checked="checked" />
				<label for="ba_sn"><%= (langCd.equals("en_US") ? "Bank account with the same beneficiary name" : "Tài khoản ngân hàng cùng tên người thụ hưởng") %></label>
				<input type="radio" id="ba_re" name="type" data-tg="reg" />
				<label for="ba_re"><%= (langCd.equals("en_US") ? "Registered Bank Account" : "Số tài khoản NH đã đăng ký") %></label>				
			</div>

			<div class="search_area in">
				<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
				<input type="text" id="cmvStartDate" name="mvStartDate" class="datepicker" />

				<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
				<input type="text" id="cmvEndDate" name="mvEndDate" class="datepicker" />
				
				<select id="ojStatus">
					<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
					<option value="P"><%= (langCd.equals("en_US") ? "Pending" : "Chờ xử lý") %></option>
					<option value="A"><%= (langCd.equals("en_US") ? "Approved" : "Đã chấp nhận") %></option>
					<option value="R"><%= (langCd.equals("en_US") ? "Rejected" : "Không chấp nhận") %></option>
					<option value="D"><%= (langCd.equals("en_US") ? "Deleted" : "Đã hủy") %></option>					
				</select>

				<button class="btn" type="button" onclick="hksCashTransactionHistory()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			</div>

			<div class="group_table double">
				<table class="table">
					<caption><%= (langCd.equals("en_US") ? "Cash Transfer Transaction" : "Giao dịch chuyển tiền") %></caption>
					<colgroup>
						<col width="60" />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col width="60" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Select" : "Chọn GD") %></th>
							<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Transfer Type" : "Loại hình chuyển khoản") %></th>
							<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Transfer amount" : "Số tiền") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Beneficiary account" : "Tài khoản thụ hưởng") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Bank name" : "Tên ngân hàng") %></th>
							<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Approve Time" : "Thời gian xác nhận") %></th>
							<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy GD") %></th>
						</tr>
						<tr>
							<th scope="col"><%= (langCd.equals("en_US") ? "Beneficiary name" : "Người thụ hưởng") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Bank branch" : "Chi nhánh") %></th>
							<th scope="col"><%= (langCd.equals("en_US") ? "Date" : "Ngày GD") %></th>
						</tr>
					</thead>
					<tbody id="trCashAdvanceTransaction">
					</tbody>
				</table>
			</div>

			<div class="pagination">
			</div>
		</div>
	</div>
</div>

<div id="divIdAuthCashTransfer" class="modal_wrap"></div>
<div id="divIdOTP" class="modal_wrap"></div>

</html>
