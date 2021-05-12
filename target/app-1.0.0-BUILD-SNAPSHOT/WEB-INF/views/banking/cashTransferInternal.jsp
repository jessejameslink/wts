<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var pTranID = "";
	var pStatus = "";

	$(document).ready(function() {
		var d = new Date();
		$("#ojSubAccountIn").html($("#ojSubAccount").html());
		changeToSubAccountInterCash($("#ojSubAccount").val());
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$("#cmvEndDateIn").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		d.setMonth(d.getMonth() - 1);
		$("#cmvStartDateIn").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		
		genfundtransfer();
		hksCashTransactionHistoryIn()
		
	});
	
	function changeToSubAccountInterCash(valu) {
		//lengOjSubAccount = (valu % lengOjSubAccount) + 1;
		$("#ojSubAccount").val(valu);
		$("#ojSubAccountIn").val((valu % lengOjSubAccount) + 1);
	}
	
	function changeFromSubAccountInterCash(valu) {
		$("#ojSubAccountIn").val(valu);
		$("#ojSubAccount").val((valu % lengOjSubAccount) + 1);
		genfundtransfer();
	}
	
	function changeSubAccountInterCash111() {
		var se = $("#ojSubAccount").val();
		
		if (se == 1){
			se = 2;
		}
		else if (se == 2)
		{
			se = 1;
		}
		else{
			se = 1;
		}
		$("#ojSubAccountIn").val(se);
	}
	
	function getSubAccount() {
		var param = {
				mvClientID	:	"<%=session.getAttribute("clientID")%>"
			};

			$.ajax({
				dataType  : "json",
				cache		: false,
				url       : "/trading/data/getSubAccount.do",
				data      : param,
				success   : function(data) {
					//console.log("Sub cash List");
					//console.log(data);
					$("#ojSubAccountIn option").remove();
					for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
						$("#ojSubAccountIn").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + "</option>");
					}	
					
					//Transfer
					$("#ojTranferSubAccountCashIn option").remove();
					for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
						$("#ojTranferSubAccountCashIn").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + "</option>");
					}
					changeSubAccountInterCash($("#ojSubAccount").val());
				},
				error     :function(e) {					
					console.log(e);
				}
			});
	}

	function genfundtransfer() {
		$("#tab2").block({message: "<span>LOADING...</span>"});
		//console.log("LOADING...genfundtransfer");
		var param = {
				mvSubAccountID		: $("#ojSubAccount option:selected").text(),
				mvTransactionType	: ""
		}
		
		$.ajax({
			dataType  : "json",
			url       : "/banking/data/genfundtransfer.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				$("#ulAccountNumber").find("li").remove();
				if(data.jsonObj != null) {
					//console.log("====genfundtransfer CASH TRANSFER====BANKING====")
					//console.log(data);
					if(data.jsonObj.mvErrorCode != "1") {
						
						$("#mvAvailableIn").val(data.jsonObj.mvAvailable);
						$("#mvBalanceIn").val(data.jsonObj.mvBalance);
						$("#chargeRateIn").val(data.jsonObj.chargeRate);
						$("#mvFundTransferFromIn").val(data.jsonObj.mvFundTransferFrom);
	
						$("#tdCashbalanceIn").html(numIntFormat(numDotComma(data.jsonObj.mvCashBalance)));
						$("#tdCashwithdrawableIn").html(numIntFormat(numDotComma(data.jsonObj.mvAvailable)));	
						hksCashTransactionHistoryIn();
					} else {
						$("#tab2").unblock();
						alert(data.jsonObj.mvErrorResult);
						//hksCashTransactionHistoryIn();
						
						return;
					}
					$("#tab2").unblock();
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab2").unblock();
			}
		});
	}

	function hksCashTransactionHistoryIn() {
		$("#tab2").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	  : "<%=session.getAttribute("subAccountID")%>",
				mvStartDate       : $("#cmvStartDateIn").val(),
				mvEndDate         : $("#cmvEndDateIn").val(),
				mvStatus		  : $("#ojStatusIn").val(),
				tradeType		  : "FUND",
				mvTransferType	  : "T",
				limit             : $("#limit").val(),
				start             : ($("#page").val() == "0" ? "0" : (($("#page").val() - 1) * $("#limit").val())),
				page              : $("#page").val()
		};

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
							cashAdvanceTransaction += "	<td class=\"text_center\"></td>";							
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
							cashAdvanceTransaction += "	<td class=\"text_left\">" + hcth.remark + "</td>";
							cashAdvanceTransaction += "	<td class=\"text_center\">";
							cashAdvanceTransaction += "	<td class=\"text_center\">";
							if(status == "P") {
								cashAdvanceTransaction += "		<button type=\"button\" class=\"btn_cancel\" onclick=\"authCheckCashIn('cancel', '" + hcth.tranID + "','" + status + "','" + hcth.minFeeAmt  + "','" + hcth.minFeeAmt  + "','" + hcth.minFeeAmt + "')\"><%=(langCd.equals("en_US") ? "Cancel" : "Hủy")%></button>";
							}
							cashAdvanceTransaction += "	</td>";
							cashAdvanceTransaction += "</tr>";
						}
					}
					drawPage(data.jsonObj.totalCount, $("#limit").val(), (parseInt($("#page").val()) == "0" ? "1" : parseInt($("#page").val())));
					$("#trCashAdvanceTransactionIn").html(cashAdvanceTransaction);
					$("#tab2").unblock();
				}
				
			},
			error     :function(e) {
				console.log(e);
				$("#tab2").unblock();
			}
		});
	}

	function getTranType(transType) {
		if(transType == "T") {
			if ("<%=langCd%>" == "en_US") {
			return "Internal";
			} else {
				return "Nội bộ";
			}
		} else if(transType == "W") {
			if ("<%=langCd%>" == "en_US") {
			return "External";
			} else {
				return "Ngân hàng";
			}
		}
	}

	function getStatus(status) {
		switch (status) {
			case "P":
				if ("<%=langCd%>" == "en_US") {
				return "Pending";
				} else {
					return "Chờ xử lý";
				}
			case "A":
				if ("<%=langCd%>" == "en_US") {
				return "Approved";
				} else {
					return "Đã chấp nhận";
				}
			case "R":
				if ("<%=langCd%>" == "en_US") {
				return "Rejected";
				} else {
					return "Không chấp nhận";
				}
			case "D":
				if ("<%=langCd%>" == "en_US") {
				return "Deleted"
				} else {
					return "Đã hủy";
				}
			default :
				return ""
		}
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
		var mvAmount   = $("#transferAmountIn").val().replace(/,/g,'');
		var chargeRate = $("#chargeRateIn").val();
		$("#transferAmountIn").val(numIntFormat(mvAmount));
		$("#mvAmountIn").val(mvAmount / 1000);
		if(mvAmount != "" && mvAmount != "0" &&  parseFloat(mvAmount) > 0){
			
		} else {
			if(Number(mvAmount) <= 0) {
				$("#transferAmountIn").val(0);
			}
		}
	}

	function divAccountShowHide(tagId) {
		if($("#" + tagId).css("display") == "none") {
			$("#" + tagId).show();
		} else {
			$("#" + tagId).hide();
		}
	}	

	function authCheckCashIn(divGubun, tranID, status) {
		pTranID = tranID;
		pStatus = status;

		var param = {
				divId               : "divIdAuthCashTransferIn",
				divType             : divGubun
		};
		$("#tab2").block({message: "<span>LOADING...</span>"});
		$.ajax({
			type     : "POST",
			url      : "/common/popup/authConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#tab2").unblock();
				$("#divIdAuthCashTransferIn").fadeIn();
				$("#divIdAuthCashTransferIn").html(data);
			},
			error     :function(e) {
				$("#tab2").unblock();
				console.log(e);
			}
		});
	}

	function authCheckOK(divGubun) {
		if(divGubun == "submit_in") {
			dofundtransferIn();
		} else if(divGubun == "cancel") {
			cancelFundTransferIn();
		}
	}

	function cashTransferPlaceCancelIn() {

		$("#transferAmountIn").val("0");
		$("#remarkIn").val("");		
	}

	function checkFundTransferTimeIn() {
		
		if($("#ojSubAccountIn").val() == $("#ojTranferSubAccountCashIn").val()) {
			if ("<%=langCd%>" == "en_US") {
				alert("Please select a difference sub account to transfer.");	
			} else {
				alert("Vui lòng chọn 1 tiểu khoản khác tiểu khoản hiện tại.");
			}
			return;
		}

		if($("#transferAmountIn").val() < 1) {
			if ("<%=langCd%>" == "en_US") {
				alert("Amount should not be blank.");	
			} else {
				alert("Số lượng không thế trống");
			}
			return;
		}

		$("#tab2").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%=session.getAttribute("subAccountID")%>"
		}
		$.ajax({
			dataType  : "json",
			url       : "/banking/data/checkFundTransferTime.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				if(data != null) {
					$("#tab2").unblock();
					if(data.jsonObj.mvFundTransferResult == "SUCCESS") {
						if ("<%= authenMethod %>" != "matrix") {
							cashInCheckOTP();
						} else {
							authCheckCashIn("submit_in", "", "");
						}
						
					} else {
						alert(data.jsonObj.mvFundTransferResult);
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#tab2").unblock();
			}
		});
	}	

	function dofundtransferIn() {
		$("#tab2").block({message: "<span>LOADING...</span>"});
		
		if ($("#remarkIn").val() == "") {
			if ("<%=langCd%>" == "en_US") {
				$("#remarkIn").val("Cash Transfer Internal");	
			} else {
				$("#remarkIn").val("Chuyen tien noi bo");
			}
		}
		
		var encodeBase64 = utoa("" + "|" + "" + "|" + "" + "|" + $("#remarkIn").val());
		
		var param = {
				
				mvSubAccountID		: $("#ojSubAccount option:selected").text(),
				mvBankId            : "MAS",
				mvDestClientID      : "<%=session.getAttribute("clientID")%>",
				mvDestBankID        : "MAS",
				inputBankName       : "MAS",
				inputBankBranch     : "MAS",
				mvDestAccountName   : "MAS",
				mvDestSubAccountID	: $("#ojSubAccountIn option:selected").text(),
				mvAmount            : $("#mvAmountIn").val(),
				mvTransferType      : "T",
				mvRemark            : $("#remarkIn").val(),				
				mvPersonCharged     : "1",
				mvWithdrawAmt       : $("#transferAmountIn").val(),
				mvAvaiableAmt       : numIntFormat(($("#mvAvailableIn").val().replace(/,/g,'')) * 1000),
				mvTransferFee       : "0",
				mvClientName		: "<%=session.getAttribute("ClientName")%>",
				mvDestBankAccountID	: "",
				mvDestTradingAccSeq	: $("#ojSubAccountIn").val(),
				mvBase64			: encodeBase64
		};
		//console.log(param);

		$.ajax({
			dataType  : "json",
			url       : "/banking/data/dofundtransfer.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				$("#tab2").unblock();
				
				$("#ojStatusIn").val("ALL");
				cashTransferPlaceCancelIn();
				genfundtransfer();

				//if(data.jsonObj.mvResult == "success") {
				alert(data.jsonObj.errorMessage);
				//}
			},
			error     :function(e) {
				console.log(e);
				$("#tab2").unblock();
			}
		});
	}	

	function cancelFundTransferIn() {
		$("#tab2").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	  : 	"<%=session.getAttribute("subAccountID")%>",
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
						if ("<%=langCd%>" == "en_US") {
									alert("Cash transfer order is cancelled. Please check in History screen.");
								} else {
									alert("Lệnh chuyển tiền đã bị hủy. Kiểm tra màn hình Lịch sử");
								}
							}
						}
						$("#tab2").unblock();
					},
					error : function(e) {
						console.log(e);
						$("#tab2").unblock();
					}
				});
	}

	var util = new PageUtil();
	function drawPage(totCnt, pageSize, curPage) {
		util.totalCnt = totCnt; //	게시물의 총 건수
		util.pageRows = pageSize; // 	한번에 출력될 게시물 수
		util.disPagepCnt = 5; //	화면 출력 페이지 수
		util.curPage = curPage; //	현재 선택 페이지
		util.setTotalPage();
		fn_DrowPageNumber();
	}

	function fn_DrowPageNumber() {
		$(".pagination").html(util.Drow());
	}

	function goPage(pageNo) {
		$("#page").val(pageNo);
		hksCashTransactionHistoryIn();
	}

	function next() {
		var page = util.getNext();
		util.curPage = page;
		goPage(page);
	}

	function prev() {
		var page = util.getPrev();
		util.curPage = page;
		goPage(page);
	}

	function convNum(v) {
		var rt = v.split(",").join("");
		rt = upDownNumList(String(parseFloat(rt)));
		return rt;
	}

	function formatNumber(num) {
		if (num.indexOf('.') != -1) {
			var priceSpl = num.split(".");
			if (priceSpl[1].length == 1) {
				num = priceSpl[0] + "." + priceSpl[1] + "00";
			} else if (priceSpl[1].length == 2) {
				num = priceSpl[0] + "." + priceSpl[1] + "0";
			}
		}
		return num;
	}

	function isNum() {
		var key = event.keyCode;
		if (!(key == 8 || key == 9 || key == 13 || key == 46 || key == 144 || (key >= 48 && key <= 57) || key == 110 || key == 190)) {
			event.returnValue = false;
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
	
	function cashInCheckOTP() {
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
					authOtpCheckIn();
				} else {					
					authCheckOK("submit_in", "", "");
				}
			}
		});	
	}
	
	function authOtpCheckIn() {
		var param = {
				divId               : "divIdOTPCashIn",
				divType             : "cashTranferInternal"
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/otpConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdOTPCashIn").fadeIn();
				$("#divIdOTPCashIn").html(data);
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
</script>
<div class="tab_content banking">
	<input type="hidden" id="mvAvailableIn" name="mvAvailableIn" value="">
	<input type="hidden" id="mvBalanceIn" name="mvBalanceIn" value="">
	<input type="hidden" id="chargeRateIn" name="chargeRateIn" value="">
	<input type="hidden" id="mvFundTransferFromIn"
		name="mvFundTransferFromIn" value=""> <input type="hidden"
		id="mvAmountIn" name="mvAmountIn" value=""> <input
		type="hidden" id="page" name="page" value="1" /> <input type="hidden"
		id="limit" name="limit" value="10" />

	<div role="tabpanel" class="tab_pane" id="tab2">
		<div class="wrap_left">
			<div class="tf_place same on">
				<div class="group_table">
					<table class="table no_bbt list_type_01">
						<caption><%=(langCd.equals("en_US") ? "Cash Transfer Internal" : "Thực hiện chuyển tiền nội bộ")%></caption>
						<colgroup>
							<col width="150" />
							<col />
						</colgroup>
						<tbody>
							<%-- <tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Tranfer sub account" : "Chuyển từ tài khoản")%></th>
								<td class="text_left">
									<select style="margin-top:-3px;color:black;font-weight:600;" id="ojTranferSubAccountCashIn" onChange="changeSubAccountInterCash()">
									</select>
								</td>
							</tr> --%>
							<tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Cash balance" : "Số dư tiền mặt<br />(được rút)")%></th>
								<td id="tdCashbalanceIn">
								</td>
							</tr>
							<tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Cash withdrawable" : "Số dư được rút<br />(bao gồm ứng trước)")%></th>
								<td id="tdCashwithdrawableIn"></td>
							</tr>
							<tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Transfer type" : "Loại hình<br />chuyển khoản")%></th>
								<td class="text_left">
									<div>
										<input type="radio" id="type_ef" name="type_sm" value="1" checked="checked" /> 
										<label for="type_ef"><%=(langCd.equals("en_US") ? "Transfer by Internal" : "Chuyển tiền nội bộ")%></label>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Beneficiary<br />sub account" : "Tài khoản<br />thụ hưởng")%></th>
								<td class="text_left">
									<!-- <span style="margin-top: -3px; color: black; font-weight: 600;" id="ojSubAccountIn" ></span> -->
									<select style="margin-top: -3px; color: black; font-weight: 600;" id="ojSubAccountIn" onChange="changeFromSubAccountInterCash(this.value)"></select>
								</td>
							</tr>
							<tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Account type" : "Loại tài khoản")%></th>
								<td><%=(langCd.equals("en_US") ? "Internal Account" : "Tài khoản nội bộ")%></td>
							</tr>
							<tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Transfer amount" : "Số tiền chuyển khoản")%></th>
								<td class="input"><input class="text won" type="text" id="transferAmountIn" name="transferAmountIn" value="0" onkeyup="transferAmountCalc()" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" onkeypress="isNum();" onkeydown="keyDownEvent(this.id, event)"></td>
							</tr>
							<tr>
								<th scope="row"><%=(langCd.equals("en_US") ? "Remark" : "Ghi chú")%></th>
								<td class="input"><input class="text" type="text" id="remarkIn" name="remarkIn" value=""></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="mdi_bottom cb">
					<input class="color" type="button" value="<%=(langCd.equals("en_US") ? "Submit" : "Thực hiện")%>" onclick="checkFundTransferTimeIn()" />
					<input type="reset" value=<%=(langCd.equals("en_US") ? "Cancel" : "Hủy")%> onclick="cashTransferPlaceCancelIn()" />
				</div>
				<% if (langCd.equals("en_US")) { %>
					<p class="em">* Please select a difference sub account with current sub account.</p>
				<% } else { %>
					<p class="em">* Vui lòng chọn 1 tiểu khoản khác với tiểu khoản hiện tại.</p>
				<% } %>
			</div>
			<!-- // .tf_place.same -->
		</div>
		<div class="wrap_right">
			<div class="search_area in">
				<label for="fromSearch"><%=(langCd.equals("en_US") ? "From" : "Từ ngày")%></label>
				<input type="text" id="cmvStartDateIn" name="mvStartDateIn" class="datepicker" /> 
				<label for="toSearch"><%=(langCd.equals("en_US") ? "To" : "Đến ngày")%></label>
				<input type="text" id="cmvEndDateIn" name="mvEndDateIn" class="datepicker" /> 
				<select id="ojStatusIn">
					<option value="ALL"><%=(langCd.equals("en_US") ? "All" : "Tất cả")%></option>
					<option value="P"><%=(langCd.equals("en_US") ? "Pending" : "Chờ xử lý")%></option>
					<option value="A"><%=(langCd.equals("en_US") ? "Approved" : "Đã chấp nhận")%></option>
					<option value="R"><%=(langCd.equals("en_US") ? "Rejected" : "Không chấp nhận")%></option>
					<option value="D"><%=(langCd.equals("en_US") ? "Deleted" : "Đã hủy")%></option>
				</select>

				<button class="btn" type="button" onclick="hksCashTransactionHistoryIn()"><%=(langCd.equals("en_US") ? "Search" : "Tra cứu")%></button>
			</div>

			<div class="group_table double">
				<table class="table">
					<caption><%=(langCd.equals("en_US") ? "Cash Transfer Transaction" : "Giao dịch chuyển tiền")%></caption>
					<colgroup>
						<col width="60" />
						<col />
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
							<th scope="col" rowspan="2"><%=(langCd.equals("en_US") ? "Select" : "Chọn GD")%></th>
							<th scope="col" rowspan="2"><%=(langCd.equals("en_US") ? "Transfer Type" : "Loại hình chuyển khoản")%></th>
							<th scope="col" rowspan="2"><%=(langCd.equals("en_US") ? "Transfer amount" : "Số tiền")%></th>
							<th scope="col"><%=(langCd.equals("en_US") ? "Beneficiary account" : "Tài khoản thụ hưởng")%></th>
							<th scope="col"><%=(langCd.equals("en_US") ? "Bank name" : "Tên ngân hàng")%></th>
							<th scope="col" rowspan="2"><%=(langCd.equals("en_US") ? "Status" : "Trạng thái")%></th>
							<th scope="col"><%=(langCd.equals("en_US") ? "Approve Time" : "Thời gian xác nhận")%></th>
							<th scope="col" rowspan="2"><%=(langCd.equals("en_US") ? "Remarks" : "Ghi chú")%></th>
							<th scope="col" rowspan="2"><%=(langCd.equals("en_US") ? "Cancel" : "Hủy GD")%></th>
						</tr>
						<tr>
							<th scope="col"><%=(langCd.equals("en_US") ? "Beneficiary name" : "Người thụ hưởng")%></th>
							<th scope="col"><%=(langCd.equals("en_US") ? "Bank branch" : "Chi nhánh")%></th>
							<th scope="col"><%=(langCd.equals("en_US") ? "Date" : "Ngày GD")%></th>
						</tr>
					</thead>
					<tbody id="trCashAdvanceTransactionIn">
					</tbody>
				</table>
			</div>

			<div class="pagination"></div>
		</div>
	</div>
</div>
<div id="divIdAuthCashTransferIn" class="modal_wrap"></div>
<div id="divIdOTPCashIn" class="modal_wrap"></div>
</html>
