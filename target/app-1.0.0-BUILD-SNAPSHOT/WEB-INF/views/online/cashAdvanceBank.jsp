<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<script>
	var limit	=	15;
	var start	=	0;
	var page	=	1;
	
	var dataList = {};
	var listSelectData = [];
	var orderIDStrArray = "";
	var contractIDStrArray = "";
	var tPlusX = "";
	var bnkCashAdvanceAvailable = 0;
	var t0, t1, t2 = 0;

	$(document).ready(function() {
		getQueryBankInfo();
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		//SinhNH modified on 09/08/2017
		$('#checkAll').click(function() {
	        if (!$(this).is(':checked')) {
	        	$('.case').prop('checked', false);
	        	clearAll();
	        } else {
	        	//check the same T
	        	var firstT = "";
	        	var difT = false;
	        	if (dataList.length > 1) {
	        		firstT = dataList[0].mvSettleDay;
	        		for (var i = 1; i < dataList.length; i++) {
	        			if (dataList[i].mvSettleDay != firstT) {
	        				difT = true;
	        				break;
	        			}
	        		}
	        		if(difT) {
	        			if ("<%= langCd %>" == "en_US") {
	    		        	alert("Can't select all matching order. Because existing the matching order with different date.");	
	    		        } else {
	    		        	alert("Không thể chọn tất cả lệnh khớp. Bởi vì tồn tại lệnh khớp khác ngày.");
	    		        }
	        			$("#checkAll").prop("checked", false);
	    		    	return;
	        		}
	        	}
	        	$('.case').prop('checked', true);
	        	selectAll(dataList);
	        }
	    });

		$('body').on('change','#ordMatchLst input[type="checkbox"]',function(){
			//check the same T
			var isChecked = $(this).prop("checked");
			if (isChecked) {
				var selT = dataList[$(this).val()].mvSettleDay;
				var difT = false;
				for (var i = 0; i < listSelectData.length; i++) {
					if (listSelectData[i].mvSettleDay != selT) {
						difT = true;
						break;
					}
				}
				if (difT) {
					if ("<%= langCd %>" == "en_US") {
			        	alert("Can't select matching order different date.");	
			        } else {
			        	alert("Không thể chọn lệnh khớp khác ngày.");
			        }
					$(this).prop("checked", false);
			    	return;
				}	
			}			
			
			if($('.case').length == $('.case:checked').length) {
                $("#checkAll").prop("checked", true);                
            } else {
                $("#checkAll").prop("checked", false);                
            }
			singleSelectOrder();
		});
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
	
	function selectAll(dataList) {
		t0 = 0, t1 = 0, t2 = 0;
		bnkCashAdvanceAvailable = 0;
		orderIDStrArray = "";
		contractIDStrArray = "";
		tPlusX = "";
		for (var i = 0; i < dataList.length; i++) {
			bnkCashAdvanceAvailable += parseFloat(dataList[i].mvAvailableAmount.replace(/,/g,''));
			if (i == 0) {
				orderIDStrArray += dataList[i].mvOrderID;
			} else {
				orderIDStrArray += "|" + dataList[i].mvOrderID;
			}
			if (i == 0) {
				contractIDStrArray += dataList[i].mvContractID; 
			} else {
				contractIDStrArray += "|" + dataList[i].mvContractID;
			}
			if (dataList[i].mvSettleDay == "T0") {
				t0 = 1;
			} else if (dataList[i].mvSettleDay == "T1") {
				t1 = 1;
			} else if (dataList[i].mvSettleDay == "T2") {
				t2 = 1;
			}
			tPlusX = dataList[i].mvSettleDay;
			//tPlusX = "T0";
		}
		//alert("Array order ID ===" + orderIDStrArray + "\nArray Contract ID ===" + contractIDStrArray);
		$("#bnkCashAdvanceAvailable").html(numIntFormat(bnkCashAdvanceAvailable.toFixed(3) * 1000));
		$("#bnkAdvancePayment").val(numIntFormat(bnkCashAdvanceAvailable.toFixed(3) * 1000));
		if (t0 == 1) {
			calculateInterestAmt(3, bnkCashAdvanceAvailable);	
		} else {
			if (t1 == 1) {
				calculateInterestAmt(2, bnkCashAdvanceAvailable);
			} else {
				calculateInterestAmt(1, bnkCashAdvanceAvailable);
			}
		}
	}
	
	function singleSelectOrder() {		
		listSelectData = [];
	    $('#ordMatchLst tr td :checkbox:checked').map(function () {
	    	listSelectData.push(dataList[$(this).val()]);
	    });
	    //console.log("listSelectData");
	    //console.log(listSelectData);
	    if (listSelectData.length > 0) {
	    	selectAll(listSelectData);	
	    } else {
	    	clearAll();
	    }
	}
	
	function clearAll() {
		bnkCashAdvanceAvailable = 0;
		orderIDStrArray = "";
		contractIDStrArray = "";
		tPlusX = "";
		t0 = 0, t1 = 0, t2 = 0;
		$("#bnkAdvancePayment").val("0");
		$("#bnkAdvanceFee").html(numIntFormat(parseInt(0)));
		$("#bnkCashAdvanceAvailable").html(numIntFormat(parseInt(0)));
	}
	
	function calculateInterestAmt(set, amt) {
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				mvSettlement	: set,
				mvAmount		: amt
		}
		//console.log("param");
		//console.log(param);	
		$.ajax({
			dataType  : "json",
			url       : "/online/data/calculateInterestAmt.do",
			data      : param,
			cache	  : false,
			success   : function(data) {
				//console.log("GET Interest Amt");
				//console.log(data);
				if(data.jsonObj.mvErrorCode == null) {
				 	$("#bnkAdvanceFee").html(numIntFormat(data.jsonObj.mvInterestAmt * 1000));
					
				}
			}
		});
	}
	
	function resetData(){
		$("#checkAll").prop("checked", false);
		$('.case').prop('checked', false);
		clearAll();
	}
	
	// Key Event
	function keyDownEvent(){
		if($("#bnkAdvancePayment").val() == "0"){
			$("#bnkAdvancePayment").val("");
		}
	}
	
	function bnkAdvancePaymentKeyUp() {
		//console.log("ON KEY UP EVENT");
		var tempValue = parseInt($("#bnkAdvancePayment").val().replace(/,/g,''));		
		$("#bnkAdvancePayment").val(tempValue);

		if($("#bnkAdvancePayment").val() == ""){
			$("#bnkAdvancePayment").val("0");
		} else {			
			if (t0 == 1) {
				calculateInterestAmt(3, tempValue / 1000);	
			} else {
				if (t1 == 1) {
					calculateInterestAmt(2, tempValue / 1000);
				} else {
					calculateInterestAmt(1, tempValue / 1000);
				}
			}
		}
		$("#bnkAdvancePayment").val(numIntFormat(tempValue));
	}
	
	function doValidateBnkAdvance() {
		var advPayment = parseInt($("#bnkAdvancePayment").val().replace(/,/g,''));
		if ($("#bnkAdvancePayment").val() == ""){
			if ("<%= langCd %>" == "en_US") {
	        	alert("Amount should not be blank");	
	        } else {
	        	alert("Số lượng không thế trống");
	        }
	    	return;
		} else if (advPayment <= 0) {	    	
	        if ("<%= langCd %>" == "en_US") {
	        	alert("Amount have to greater than 0.");	
	        } else {
	        	alert("Số lượng phải lớn hơn 0.");
	        }
	    	return;
	    } else if (parseInt($("#bnkAdvancePayment").val().replace(/,/g,'')) > (bnkCashAdvanceAvailable * 1000).toFixed()){
	    	if ("<%= langCd %>" == "en_US") {
				alert("Insufficient Fund!");
	    	} else {
	    		alert("Vượt quá số tiền được ứng!");
	    	}
			return
		} else {
			checkAdvancePaymentTime();
			//authCheckCashAdvBank();
		}
	}
	
	function checkAdvancePaymentTime() {
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		}
		$.ajax({
			dataType  : "json",
			url       : "/online/data/checkAdvancePaymentTime.do",
			cache	  : false,
			data	  : param,
			success   : function(data) {
				//console.log("check time cash advance bank");
				//console.log(data);
				if(data.jsonObj.mvResult.length > 0){
					alert("err : mvResult.length > 0\n" + data.mvResult);
				} else {
					if ("<%= authenMethod %>" != "matrix") {
						bankCashAdvanceCheckOTP();
					} else {
						authCheckCashAdvBank();
					}
				}
			}
		});
	}
	
	function authCheckCashAdvBank() {
		var param = {
				divId   : "divIdAuthCashAdvBank",
				divType : "submitBankAdvancePayment"
		}

		$.ajax({
			type     : "POST",
			url      : "/common/popup/authConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdAuthCashAdvBank").fadeIn();
				$("#divIdAuthCashAdvBank").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function bankCashAdvanceCheckOTP() {
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
					authOtpCheckCashAdvBank();
				} else {
					submitBankAdvancePayment();
				}
			}
		});	
	}
	
	function authOtpCheckCashAdvBank() {
		var param = {
				divId               : "divIdOTPCashAdvBank",
				divType             : "submitBankAdvancePayment"
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/otpConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdOTPCashAdvBank").fadeIn();
				$("#divIdOTPCashAdvBank").html(data);
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
	
	function submitBankAdvancePayment() {
		alert("Submit Bank Cash Advance");
		var advPayment = parseInt($("#bnkAdvancePayment").val().replace(/,/g,''));
		
		var param = {
				mvSubAccountID	     	: "<%= session.getAttribute("subAccountID") %>",
				mvOrderIDStrArray		: orderIDStrArray,
				mvContractIDStrArray	: contractIDStrArray,
				mvBankID				: $("#bankId option:selected").val(),
				mvTPLUSX				: tPlusX,
				mvAmount				: advPayment / 1000,
				mvTotalAmt				: bnkCashAdvanceAvailable
		}
		//console.log("==========================");
		//console.log(param);
		//return;
		$.ajax({
			dataType  : "json",
			url       : "/online/data/submitBankAdvancePayment.do",
			data      : param,
			success   : function(data) {
				//console.log("submitBankAdvancePayment");
				//console.log(data);
				if(data.jsonObj.returnCode == 0) {
				 	if(data.jsonObj.mvResult == "SUCCESS") {
				 		if ("<%= langCd %>" == "en_US") {
							alert("The request is accepted");
				    	} else {
				    		alert("Yêu cầu được chấp nhận.");
				    	}
				 		getQueryBankInfo();
				 		resetData();
				 	} else {
				 		if ("<%= langCd %>" == "en_US") {
							alert("The request is rejected.");
				    	} else {
				    		alert("Yêu cầu bị từ chối.");
				    	}
				 	}				 	
				} else {
					if ("<%= langCd %>" == "en_US") {
						alert("The request is failed.");
			    	} else {
			    		alert("Yêu cầu bị lỗi.");
			    	}
				}
			}
		});
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
				//console.log("QUERY BANK CALL");
				//console.log(data);
				if(data.jsonObj.mvBankInfoList.length == 0) {
					if ("<%= langCd %>" == "en_US") {
						alert("You don't register to trading via bank.");	
					} else {
						alert("Bạn không đăng ký giao dịch qua ngân hàng.");
					}
					return;
				} else {
					var optLst	=	"";
					var isBank =  false;
					for(var i=0; i < data.jsonObj.mvBankInfoList.length; i++) {
						var obj	=	data.jsonObj.mvBankInfoList[i];
						if (obj.mvIsDefault == true) {
							isBank = true;
							$("#bankId").append("<option value=\""+obj.mvBankID+"\">"+obj.mvSettlementAccountDisplayName+"</option>");
						}
					}
					if (isBank == false) {
						if ("<%= langCd %>" == "en_US") {
							alert("You don't register to trading via bank.");	
						} else {
							alert("Bạn không đăng ký giao dịch qua ngân hàng.");
						}
						return;
					}
					getCashAdvanceHistory();
					queryAdvancePaymentInfo();
				}
			}
		});
	}
	
	function getCashAdvanceHistory() {
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				queryBank		: true
		};
		
		$.ajax({
			dataType  : "json",
			url       : "/online/data/getCashAdvanceHistory.do",
			data      : param,
			success   : function(data) {
				//console.log("getCashAdvanceHistory Bank");
				//console.log(data);
				if(data.jsonObj.list != null) {					
				 	var inHtml	=	"";				 	
				 	for(var i = 0; i < data.jsonObj.list.length; i++) {
				 		var obj	=	data.jsonObj.list[i];				 		
						inHtml	+=	"<tr>";
						inHtml	+=	"<td class=\"text_center\">"+obj.creationTime+"</td>";
						inHtml	+=	"<td class=\"\">"+upDownNumList(String(Number(obj.totalLendingAmt) * 1000))+"</td>";
						inHtml	+=	"<td class=\"\">"+upDownNumList(obj.fee)+"</td>";
						inHtml	+=	"<td class=\"\">"+obj.status+"</td>";
						inHtml	+=	"<td class=\"\">"+obj.lastApprovaltime+"</td>";
						inHtml	+=	"<td class=\"text_left\">"+""+"</td>";
						inHtml	+=	"</tr>";
			 		}
				 	$("#cashAdvHist").html(inHtml);
				}
			}
		});
	}

	function queryAdvancePaymentInfo() {
		var param		=	{};
		var mvBankID	=	$("#bankId option:selected").val()
		var mvSettlement=	"3T";							//	임시?가변?
				
		param	=	{
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				mvBankID		:	mvBankID,
			 	mvSettlement	:	mvSettlement
		}
		
		$.ajax({
			dataType  : "json",
			url       : "/online/data/queryAdvancePaymentInfo.do",
			data      : param,
			success   : function(data) {
				//console.log("GET queryAdvancePaymentInfo CALL222222");
				//console.log(data);				
				if(data.jsonObj.mvChildBeanList != null) {					
				 	var inHtml	=	"";
				 	dataList = data.jsonObj.mvChildBeanList;
				 	for(var i = 0; i < dataList.length; i++) {
						inHtml	+=	"<tr>";
						inHtml	+=	"<td class=\"text_center\">"+"<input type='checkbox' class='case' name='case' value='"+i+"'/>"+"</td>";
						inHtml	+=	"<td class=\"text_center\">"+dataList[i].mvContractID+"</td>";
						inHtml	+=	"<td class=\"text_center\">"+dataList[i].mvOrderID+"</td>";
						inHtml	+=	"<td class=\"text_center\">"+dataList[i].cashSettleDay+"</td>";
						inHtml	+=	"<td class=\"text_center\">"+dataList[i].tradeDate+"</td>";
						inHtml	+=	"<td class=\"text_center\">"+dataList[i].mvStockID+"</td>";
						inHtml	+=	"<td class=\"\">"+numIntFormat(parseFloat(dataList[i].mvPrice.replace(/,/g,'')).toFixed(3) * 1000)+"</td>";
						inHtml	+=	"<td class=\"\">"+numIntFormat(parseFloat(dataList[i].mvQuantity.replace(/,/g,'')))+"</td>";
						inHtml	+=	"<td class=\"\">"+numIntFormat(parseFloat(dataList[i].mvFormatedAmount.replace(/,/g,'')).toFixed(3) * 1000)+"</td>";
						inHtml	+=	"</tr>";
				 	}
				 	 //console.log(inHtml);
				 	$("#ordMatchLst").html(inHtml);
				}
			}
		});
		if (dataList.length == 0) {
			$('#checkAll').prop('disabled', true);
		} else {
			$('#checkAll').prop('disabled', false);
		}
	}
</script>
<div class="tab_content online">
	<div role="tabpanel" class="tab_pane" id="tab2">
		<div class="wrap_left">
			<div class="group_table">
				<table class="table no_bbt list_type_01">
					<caption><%= (langCd.equals("en_US") ? "Cash Advance Place" : "Thực hiện ứng trước") %></caption>
					<colgroup>
						<col width="150" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Bank Account" : "Số Tài khoản Ngân hàng") %></th>
							<td>
								<select id="bankId" name="bankId">
								</select>
							</td>
						</tr>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Cash advance available" : "Khả năng ứng trước") %></th>
							<td id="bnkCashAdvanceAvailable"></td>
						</tr>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Advance fee" : "Phí ứng trước") %></th>
							<td id="bnkAdvanceFee"></td>
						</tr>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Advance amount" : "Số tiền ứng") %></th>
							<td class="input"><input class="text won" type="text" id="bnkAdvancePayment" value="" onkeyup="bnkAdvancePaymentKeyUp()" onkeydown="keyDownEvent()"></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="mdi_bottom">
				<input type="submit" value="<%= (langCd.equals("en_US") ? "Submit" : "Thực hiện") %>" class="color" onclick="doValidateBnkAdvance();">
				<input type="reset" value="<%= (langCd.equals("en_US") ? "reset" : "Hủy") %>"  onclick="resetData();">
			</div>
		</div>
		<div class="wrap_right">
			<div class="grid_area" style="height:318px;">
				<div class="group_table">
					<table class="table">
						<caption><%= (langCd.equals("en_US") ? "Order Matching List" : "Danh sách lệnh khớp") %></caption>
						<colgroup>
							<col width="30" />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th><input type="checkbox" value="" id="checkAll" name="check"/></th>
								<th><%= (langCd.equals("en_US") ? "Contract ID" : "Số hợp đồng") %></th>
								<th><%= (langCd.equals("en_US") ? "Order ID" : "Mã lệnh") %></th>
								<th><%= (langCd.equals("en_US") ? "Settlement Date" : "Ngày Thực hiện") %></th>
								<th><%= (langCd.equals("en_US") ? "Trade Date" : "Ngày bán") %></th>
								<th><%= (langCd.equals("en_US") ? "Stock ID" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
								<th><%= (langCd.equals("en_US") ? "Quantity" : "Số lượng") %></th>
								<th><%= (langCd.equals("en_US") ? "Value" : "Giá trị") %></th>
							</tr>
						</thead>
						<tbody id="ordMatchLst">
						<!-- 
							<tr>
								<td class="text_center"><input type="checkbox"></td>
								<td class="text_center">10294513</td>
								<td class="text_center">10294513</td>
								<td class="text_center">13/05/2016</td>
								<td class="text_center">13/05/2016</td>
								<td class="text_center">AAA</td>
								<td>00.00</td>
								<td>00.00</td>
								<td>00.00</td>
							</tr>
							 -->
						</tbody>
					</table>
				</div>
			</div>
			<div class="grid_area" style="height:317px;">
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
						<tbody id="cashAdvHist">
						<!-- 
							<tr>
								<td class="text_center">13/05/2016</td>
								<td>00.00</td>
								<td>00.00</td>
								<td>00.00</td>
								<td>00.00</td>
								<td class="text_left">HNX</td>
							</tr>
							 -->
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
</html>
