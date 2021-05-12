<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>


<html>
<head>

<script>
	var receiveData  = null;
	var cancelModify = null;

	$(document).ready(function() {
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		$("#btnCanModConfirm").focus();
		receiveData  = JSON.parse('<%=request.getParameter("dataList")%>');
		cancelModify = '<%=request.getParameter("cancelModify")%>';
		initDataSetting();
		if ("<%= authenMethod %>" != "matrix") {
			cmCheckOTP();
		} else {
			authConfirmCanMod();
		}
		document.getElementById("cmwordMatrixValue01").addEventListener("keyup", forceKeyUpMatrix, false);
		document.getElementById("cmwordMatrixValue02").addEventListener("keyup", forceKeyUpMatrix, false);
	});
	
	function forceKeyUpMatrix(e)
	{
	  if(this.value.length==$(this).attr("maxlength")){
		  $("#cmwordMatrixValue02").focus();
		}
	}
 	
	function cmCheckOTP() {
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
					$("#divOTPCM").css("display", "block");
				} else {
					$("#divOTPCM").css("display", "none");
				}
			}
		});	
	}

	function initDataSetting(){
		// Title + Headline		
 		$("#cancelModifyTitle").html("<span class=\"type\"> " + <%= (langCd.equals("en_US") ? "(cancelModify==\"cancel\" ? \"Confirm Cancel\":\"Confirm Modify\")" : "(cancelModify==\"cancel\" ? \"Xác nhận hủy lệnh\":\"Xác nhận sửa lệnh\")") %> + "</span> ");
 		
		$("#mvStockID").html(receiveData.mvStockID);
		$("#mvStockName").html(receiveData.mvStockName);
		$("#mvOrderType").html(receiveData.mvOrderType);

		if(cancelModify == "modify"){
			$("#mvPriceModal").val(numDotCommaFormat(receiveData.mvPrice.replace(/[,]/g, "")));	    	
			$("#mvVolumeModal").val(receiveData.mvOSQty);
			$("#priceModal").val(numDotCommaFormat(receiveData.mvPrice.replace(/[,]/g, "")));	    	
			$("#volumeModal").val(receiveData.mvOSQty);
		} else if (cancelModify == "cancel") {

			$("#mvPrice").html(numDotCommaFormat(receiveData.mvPrice.replace(/[,]/g, "")));
			$("#mvQty").html(receiveData.mvOSQty);
		}

		$("#mvGrossAmt").html(numDotCommaFormat(receiveData.mvGrossAmt));
		$("#netFee").html(numDotCommaFormat(receiveData.mvBS == "B" ? receiveData.mvNetAmt - receiveData.mvGrossAmt : receiveData.mvGrossAmt - receiveData.mvNetAmtmoa));
	}

	// Key Event
	function keyDownEvent(id, e){
		if($("#" + id).val() == "0"){
			if(e.keyCode == "190"){
				$("#" + id).val("0");	
			}else{
				$("#" + id).val("");				
			}
		}
	}

	function volumeModiChange() {
		var modiVolumeView = $("#mvVolumeModal").val().replace(/[,.]/g,'');
		if(modiVolumeView.indexOf('.') != -1) {
			var modiVolSpl = modiPriceView.split(".");
			if(modiVolSpl[1].length > 1) {
				modiVolumeView = modiVolSpl[0] + "." + modiVolSpl[1].substring(0, 2);
			}
		} else {
			if(modiVolumeView.length > 9) {
				modiVolumeView = modiVolumeView.substring(0, 9);
			}
		}
		
		var modiPriceView  = $("#mvPriceModal").val().replace(/,/g,'');
		if(modiPriceView.indexOf('.') != -1) {
			var modiPriceSpl = modiPriceView.split(".");
			if(modiPriceSpl[1].length > 1) {
				modiPriceView = modiPriceSpl[0] + "." + modiPriceSpl[1].substring(0, 2);
			}
		} else {
			if(modiPriceView.length > 9) {
				modiPriceView = modiPriceView.substring(0, 9);
			}
		}
		console.log(modiVolumeView);
		console.log(modiPriceView);
		$("#volumeModal").val(modiVolumeView);
		$("#mvVolumeModal").val(numIntFormat(modiVolumeView));
		$("#mvGrossAmt").html(numIntFormat(modiVolumeView * modiPriceView));
	}

	function priceModiChange() {
		// 4자리.2자리
		var modiPriceView  = $("#mvPriceModal").val().replace(/,/g,'');
		if(modiPriceView.indexOf('.') != -1) {
			var modiPriceSpl = modiPriceView.split(".");
			if(modiPriceSpl[1].length > 1) {
				modiPriceView = modiPriceSpl[0] + "." + modiPriceSpl[1].substring(0, 2);
			}
		} else {
			if(modiPriceView.length > 9) {
				modiPriceView = modiPriceView.substring(0, 9);
			}
		}
		
		var modiVolumeView = $("#mvVolumeModal").val().replace(/[,.]/g,'');
		if(modiVolumeView.indexOf('.') != -1) {
			var modiVolSpl = modiPriceView.split(".");
			if(modiVolSpl[1].length > 1) {
				modiVolumeView = modiVolSpl[0] + "." + modiVolSpl[1].substring(0, 2);
			}
		} else {
			if(modiVolumeView.length > 9) {
				modiVolumeView = modiVolumeView.substring(0, 9);
			}
		}
		console.log(modiVolumeView);
		console.log(modiPriceView);
		$("#priceModal").val(modiPriceView);
		$("#mvPriceModal").val(numIntFormat(modiPriceView));
		$("#mvGrossAmt").html(numIntFormat(modiVolumeView * modiPriceView));
	}

	function authConfirmCanMod(confirm) {				
		$("#divCanModConf").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID		 : 	"<%= session.getAttribute("subAccountID") %>",
				wordMatrixKey01      : $("#cmmvWordMatrixKey01").text(),
				wordMatrixKey02      : $("#cmmvWordMatrixKey02").text(),
				wordMatrixValue01    : $("#cmwordMatrixValue01").val(),
				wordMatrixValue02    : $("#cmwordMatrixValue02").val(),
				serialnumber         : $("#serialnumber").val(),
				mvSaveAuthenticate   : $("#cmsaveAuthenticate").is(':checked')
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/authCardMatrix.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				$("#divCanModConf").unblock();
				
				if(data != null) {
					if(data.jsonObj.mvSuccess == "FAIL") {
						var authCard = data.jsonObj.mvClientCardBean;
						$("#cmmvWordMatrixKey01").html(authCard.mvWordMatrixKey01);
						$("#cmmvWordMatrixKey02").html(authCard.mvWordMatrixKey02);
						$("#serialnumber").val(authCard.serialnumber);
						$("#divAuth").css("display","block");
						if(data.jsonObj.mvClientCardBean.mvErrorCode != "CARD006"){ // not New Card
							alert(data.jsonObj.mvMessage);
							$("#cmwordMatrixValue01").val("");
							$("#cmwordMatrixValue02").val("");
						}
						if(data.jsonObj.mvClientCardBean.mvErrorCode == "SERVER_ERROR"){
							$("#divAuth").css("display","none");
							$("#btnCanModConfirm").css("display","none");
						}
					} else if(data.jsonObj.mvSuccess == "SUCCESS") {
						$("#divAuth").css("display","none");
						if(confirm && confirm =="confirm"){
							if(cancelModify == "cancel"){
								cancelConfirm();
							} else if(cancelModify == "modify"){
								modifyConfirm();
							}
						}
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divCanModConf").unblock();
			}

		});
	}
	
	function checkInputChange() {
		var priceCurr = receiveData.mvPrice.replace(/[,]/g, "").replace(/[.]/g, "");
		var volumeCurr = receiveData.mvOSQty.replace(/[,]/g, "");
		var priceView = ($("#priceModal").val().replace(/[,]/g, ""));
		var volumeView = ($("#mvVolumeModal").val().replace(/[,]/g, ""));		
		
		if (priceCurr == priceView && volumeCurr == volumeView) {
			if ("<%= langCd %>" == "en_US") {
				alert("Please change price or volume.");	
			} else {
				alert("Vui lòng thay đổi giá hoặc khối lượng.");
			}
			$("#priceView").focus();
			return false;
		} else {
			return true;
		}
	}

	function modifyConfirm() {		
		$("#mvMarketId").val(receiveData.mvMarketID);
		var priceView = ($("#priceModal").val().replace(/[,]/g, ""));
		if (!checkInputChange()) {
			return;
		}
		if(priceView > 0) {
			if($("#mvMarketId").val() == "HO") {
				if(priceView <= 10000) {
					if(priceView % 10 != 0) {
						$("#priceView").focus();
						if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price for lot size 10.");
						} else {
							alert("Giá không hợp lệ, không chia hết cho 10.")
						}
						return;
					}
				} else if(priceView > 10000 && priceView <= 49500) {
					if(priceView % 50 != 0) {
						$("#priceView").focus();
						if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price for lot size 50.");
						} else {
							alert("Giá không hợp lệ, không chia hết cho 50.");
						}
						return;
					}
				} else if(priceView >= 50000) {
					if(priceView % 100 != 0) {
						$("#priceView").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price for lot size 100.");
							} else {
								alert("Giá không hợp lệ, không chia hết cho 100.");
							}
						return;
					}
				}
			} else if($("#mvMarketId").val() == "HA") {
				if(priceView % 10 != 0) {
					$("#priceView").focus();
					if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price for lot size 10.");
						} else {
							alert("Giá không hợp lệ, không chia hết cho 10.");
						}
					return;
				}
			} else if($("#mvMarketId").val() == "OTC") {
				if(priceView % 10 != 0) {
					$("#priceView").focus();
					if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price for lot size 10.");
						} else {
							alert("Giá không hợp lệ, không chia hết cho 10.");
						}
					return;
				}
			}
		}		
		$("#divCanModConf").block({message: "<span>LOADING...</span>"});
						
		var param = {
				mvSubAccountID	: "<%= session.getAttribute("subAccountID") %>",
				mvOrderId		: receiveData.mvOrderID,
				mvOrderGroupId	: receiveData.mvOrderGroupID,
				mvNewPrice		: ($("#priceModal").val().replace(/,/g, '')) / 1000,
				mvNewQty		: $("#volumeModal").val().replace(/,/g, ''),
				mvStockId		: receiveData.mvStockID,
				mvMarketId		: receiveData.mvMarketID,
				mvOrigQty		: receiveData.mvOSQty.replace(/,/g, ''),
				mvStopOrderType : receiveData.receiveData,
				mvStopPrice		: receiveData.mvStopPrice
		};
		
		 $.ajax({
			dataType  : "json",
			url       : "/trading/data/modifyOrder.do",
			data      : param,
			success   : function(data) {
				//console.log("MOIDFY===>");
				//console.log(data);				
		    	if(data != null){
		    		if (data.jsonObj.mvResult == "success") {
		    			if ("<%= langCd %>" == "en_US") {
		    				autoAlert("Modify Success.", 2000);
			    		} else {
			    			autoAlert("Sửa lệnh thành công.", 2000);
			    		}
		    			cancelCM();				    			
			    	} else {
		    			alert(data.jsonObj.errorMessage);  		
			    	}
		    	}

		    	$("#divCanModConf").unblock();
		    },
		    error:function(e){
		    	console.log(e)
		    	$("#divCanModConf").unblock();
		    }
		});
	}

	function cancelConfirm() {
		$("#divCanModConf").block({message: "<span>LOADING...</span>"});
		var strParam = [];
		var dataObject = {"mvOrderId":receiveData.mvOrderID, "mvOrderGroupId":receiveData.mvOrderGroupID};
		strParam.push(dataObject);
		var param = {
				mvSubAccountID	: "<%= session.getAttribute("subAccountID") %>",
				mvOrder			: JSON.stringify(strParam)	
				
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/cancelOrder.do",
			data      : param,
			success   : function(data) {
				//console.log("===CANCEL RESULT===");
				//console.log(data);
		    	$("#divCanModConf").unblock();
		    	if (data.jsonObj.mvResult == "success") {
		    		if ("<%= langCd %>" == "en_US") {
		    			autoAlert("Cancel Success", 2000);
		    		} else {
		    			autoAlert("Hủy lệnh thành công", 2000);
		    		}
		    		cancelCM();
		    	}else{
		    		alert(data.jsonObj.errorMessage); 
		    	}
		    },
		    error:function(e){
		    	console.log(e);
		    	$("#divCanModConf").unblock();
		    }
		});
	}

	function cancelCM() {
		//window.close();
		var tagId = '<%=request.getParameter("divIdCM")%>';
		$("#" + tagId).fadeOut();
	}
	
	function autoAlert(msg,duration){		
	 	var el = document.createElement("div");
	 	el.setAttribute("style","z-index:2000;position:fixed;top:0%;left:40%;background-color:grey;border-radius:3px;padding:20px 40px;font-size:16px;color:white;");
	 	el.innerHTML = msg;
	 	setTimeout(function(){
	  		el.parentNode.removeChild(el);
	 	},duration);
	 	document.body.appendChild(el);
	}
	
	function cancelModifyConfirm() {
		if ("<%= authenMethod %>" == "matrix") {
			if($("#divAuth").css("display") == "none") {
				if(cancelModify == "cancel"){
					cancelConfirm();
				} else if(cancelModify == "modify"){
					modifyConfirm();
				}
			} else {
				authConfirmCanMod("confirm");
			}
		} else {
			if($("#divOTPCM").css("display") == "none") {
				if(cancelModify == "cancel"){
					cancelConfirm();
				} else if(cancelModify == "modify"){
					modifyConfirm();
				}
			} else {
				verifyCMOTPCode();
			}
		}
	}
	
	function verifyCMOTPCode() {
		if ($("#otpCodeCM").val().length != 6) {
			if ("<%= langCd %>" == "en_US") {
				alert("Occurs when the entered OTP number is not a six-digit number.");
			} else {
				alert("Lỗi xảy ra khi nhập OTP không là 6 chữ số.")
			}
			$("#otpCodeCM").focus();
			return;
		}
		var cusNo = '<%= session.getAttribute("ClientV") %>';
		if (cusNo.length > 7){
			cusNo = cusNo.substring(3);
		}
		
		
		var otpType = "";
		if ("<%= authenMethod %>" == "hwotp") {
			otpType = "702";
		} else if ("<%= authenMethod %>" == "swotp") {
			otpType = "204";
		}
		var d = new Date();
		var date = d.getFullYear() + "" + (d.getMonth() + 1) + "" + d.getDate();
		var time = d.getHours() + "" + d.getMinutes() + "" + d.getSeconds();
		var param = {
				uszMSG_Length  			: "0226"
				, uszTR_Name   			: "BOTP"
				, uszTR_CODE   			: otpType
				, uszSR_TYPE   			: "S"
				, uszTR_DATE   			: date
				, uszTR_TIME   			: time
				, uszCustomerNo   		: cusNo
				, uszOTP   			: btoa($("#otpCodeCM").val().trim())
				, uszProductType  	 	: ""
				, uszAuthLogType  	 	: ""
				, uszMultiLogin   		: ""
				, uszProductAuthType	: ""
				, uszAuthData   		: ""
				, uszNewAuthData   		: ""
				, uszDeviceId   		: ""
				, uszDeviceType   		: ""
			};
		
			//console.log(param);

			$.ajax({
				url      : "/trading/data/mVerifyOTP.do",
				contentType	:	"application/json; charset=utf-8",
				data     : param,
				dataType : "json",
				success  : function(data) {
					//console.log("Verify Sell OTP");
					//console.log(data);
					if (data.otpResponse.uszReternCode == "0000") {						
						//console.log("Success Case");
						if(cancelModify == "cancel"){
							cancelConfirm();
						} else if(cancelModify == "modify"){
							modifyConfirm();
						}
						if ($("#saveOTP").is(':checked')) {
							saveCMOTP();
						}
					} else {
						//console.log("Error Case");
						var errMessage = "";
						var failedMessage = "";
						var failedNumber;
						if ("<%= authenMethod %>" == "hwotp") {
							failedNumber = data.otpResponse.uszHwFailCnt;
						} else {
							failedNumber = data.otpResponse.uszPinFailCnt;
						}
						if ("<%= langCd %>" == "en_US") {
							failedMessage += "OTP code is wrong " + failedNumber + " time(s). Please input again.\n(Notice, input wrong OTP  exceed 10 times, have to reset failed number OTP.)";
						} else {
							failedMessage += "Mã OTP nhập sai " + failedNumber + " lần. Vui lòng nhập lại.\n(Lưu ý, nhập sai OTP quá 10 lần, OTP buộc phải tiến hành cài đặt lại.)";
						}
						if (data.otpResponse.uszReternCode == "1001") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Unauthorized device. It can be used after registration.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1002") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Unauthorized app. It can be used after registering the app.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1003") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "It is already registered and used. If you want to register again, please deregister and register again.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1006") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "There are no registrations with the corresponding product.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1012") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "No valid server challenge found for this request.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1013") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "User biometric authentication is not complete (in progress)\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1014") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Expiration time for the authentication result confirmation has been exceeded. (Max 5 minutes)\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1015") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Not applicable. (Already processed)\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1016") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Missing report state\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1101") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "The registration code request is prohibited.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1103") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Registration code expired or registration code not found.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1400") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "URL call error that does not match the authentication type. (Check FIDO, BIOTP)/Invalid URL call\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1401") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Unauthorized user. The service can be used after the registration process.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1498") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Error in request message format, parameter name, or parameter input information.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1500") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Internal error in the server.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1601") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "There is no registered authentication product (such as PIN/Pattern).\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1602") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Authentication failed with the authentication product (such as PIN/Pattern).\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5001") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Unauthorized user. The service can be used after the registration process.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5002") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "No Token ID\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5003") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "No Key Data\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5004") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Uninsurable state\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6000") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "OTP authentication number (6 digits only) verification failed.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6013") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Incomplete the biometric authentication.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6014") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "The OTP authentication request has been made for already verified status.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6015") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "False request due to the request of transaction linkage OTP verification rather than the regular OTP verification. Or false request due to the request of regular OTP verification rather than transaction linkage OTP verification.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6016") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Transaction information (TranInfo) error.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6017") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Query expiration time has been exceeded. (Max 5 minutes)\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6019") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Your M-OTP was locked\n";
							} else {
								errMessage += "Dịch vụ M-OTP của bạn đã bị khóa\n";
							}
						} else if (data.otpResponse.uszReternCode == "6023") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Unissued status\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6024") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Suspension of service\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6025") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Revocation\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8001") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Unauthorized user. The service can be used after the registration process.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8002") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "No Token ID\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8003") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "No Key Data\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8004") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Not revocable\n";
							} else {
								errMessage += "";
							}
						} else {
							if ("<%= langCd %>" == "en_US") {
								errMessage += data.otpResponse.uszReternCode +"\n";
							} else {
								errMessage += "";
							}							
						}
						if (data.otpResponse.uszReternCode == "1016" || data.otpResponse.uszReternCode == "6019") {
							alert(errMessage);
						} else {
							alert(errMessage + failedMessage);	
						}
					}					
				}
			});	
	}
	
	function saveCMOTP() {
		var param = {
				mvUserID 		: '<%=session.getAttribute("ClientV")%>'
				, mvSaveTime	: $("#ojSelTime").val()
			};

			$.ajax({
				url      : "/trading/data/mSaveOTP.do",
				contentType	:	"application/json; charset=utf-8",
				data     : param,
				dataType : "json",
				success  : function(data) {
					//console.log("Save OTP");
					//console.log(data);								
				}
			});	
	}

</script>

</head>
<body class="mdi">
	<input type="hidden" id="mvMarketId" name="mvMarketId" value="">
	<form action="" autocomplete="Off">
		<div class="modal_layer <%=request.getParameter("cancelModify")%>">
			<h2 id="cancelModifyTitle"><%=request.getParameter("cancelModify")%> : AAA (Stock name)</h2>
			<div class="cont" id="divCanModConf">
			<%-- 
				<H2><%= (langCd.equals("en_US") ? "Order Information" : "Chứng nhận theo thứ tự") %></H2>			
			 --%>	
				<table>
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<td id="mvStockID"></td>
					</tr>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Stock Name" : "Tên Công ty") %></th>
						<td id="mvStockName"></td>
					</tr>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Price (VND)" : "Giá(VND)") %></th>
						<td id="mvPrice">
							<input type="hidden" id="priceModal" name="priceModal" value="">
							<input id="mvPriceModal" class="text won" type="text" value="VND" onkeydown="keyDownEvent(this.id, event)" onkeyup="priceModiChange()" maxlength="9" >
						</td>
					</tr>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Order volume" : "Khối lượng") %></th>
						<td id="mvQty">
							<input type="hidden" id="volumeModal" name="volumeModal" value="">
							<input id="mvVolumeModal" class="text won" type="text" value="0" onkeydown="keyDownEvent(this.id, event)" onkeyup="volumeModiChange()" maxlength="8" >
						</td>
					</tr>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Order Type" : "Loại lệnh") %></th>
						<td id="mvOrderType"></td>
					</tr>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Value (VND)" : "Giá trị (VND)") %></th>
						<td id="mvGrossAmt"></td>
					</tr>
					<!--
					<tr >
						<th><%= (langCd.equals("en_US") ? "Net fee" : "Phí tạm tính") %></th>
						<td id="netFee"></td>
					</tr>
					-->
				</table>

				<div id="divAuth" class="layer_add" style="display:none;">
					<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %></h3>
					<div class="form_area">
						<ul class="security_check">
							<li><strong id="cmmvWordMatrixKey01"></strong><input type="password" id="cmwordMatrixValue01" name="cmwordMatrixValue01"  value="" maxlength="1"  /></li>
							<li><strong id="cmmvWordMatrixKey02"></strong><input type="password" id="cmwordMatrixValue02" name="cmwordMatrixValue02" value="" maxlength="1"  /></li>
						</ul>
						<div>
							<input type="checkbox" id="cmsaveAuthenticate" name="cmsaveAuthenticate" checked="checked">
							<label for="saveA"><%= (langCd.equals("en_US") ? "Save Authentication?" : "Lưu xác thực?") %></label>
						</div>
					</div>
					<div style="padding: 20px;">
						<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
					</div>
				</div>
				<!-- OPT Confirm -->
				<div id="divOTPCM" class="layer_add" style="display:none;">
					<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %></h3>
						<div class="form_area">
							<div>
								<label for="otp" style="padding-left:0;"><%= (langCd.equals("en_US") ? "Enter OTP Code" : "Nhập mã OTP") %></label>
								<input style="margin-left:8px;" type="text" id="otpCodeCM" name="otpCodeCM">						
							</div>
							
							<div style="margin-top:10px;">								
								<input type="checkbox" id="saveOTP" name="saveOTP">
								<label for="saveOTP"><%= (langCd.equals("en_US") ? "Save OTP?" : "Lưu OTP?") %></label>
								<select id="ojSelTime">									
									<option value="8">1.  8H</option>
									<option value="4">2.  4h</option>
									<option value="2">3.  2H</option>
									<!-- <option value="16">4. 24H</option> -->
								</select>
							</div>				
						</div>
					<div style="padding: 20px;">
						<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
					</div>
				</div>				
				
				<!-- End OTP Confirm -->
				<div class="btn_wrap">
					<button id="btnCanModConfirm" type="button" onclick="cancelModifyConfirm()" class="add"><%= (langCd.equals("en_US") ? "Confirm" : "Xác nhận") %></button>
					<button type="button" onclick="cancelCM()"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
				</div>
			</div>
		</div>
	</form>
</body>

</html>