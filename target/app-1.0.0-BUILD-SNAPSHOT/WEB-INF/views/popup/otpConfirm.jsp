<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
%>

<html>
<head>

<script>
	$(document).ready(function() {
		
		var tagType = '<%=request.getParameter("divType")%>';
		$("#otpCode").val('');
		if (tagType == "submit_reg" || tagType == "submit" || tagType == "cancel") {
			$("#saveOTPArea").css("display", "none");
		}
	});
	
	function verifyOTPCode() {
		if ($("#otpCode").val().length != 6) {
			if ("<%= langCd %>" == "en_US") {
				alert("Occurs when the entered OTP number is not a six-digit number.");
			} else {
				alert("Lỗi xảy ra khi nhập OTP không là 6 chữ số.")
			}
			$("#otpCode").focus();
			return;
		}
		var cusNo = '<%=session.getAttribute("ClientV") %>';
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
				, uszOTP   				: btoa($("#otpCode").val().trim())
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
		$("#otpCode").val().trim()
			$.ajax({
				url      : "/trading/data/mVerifyOTP.do",
				contentType	:	"application/json; charset=utf-8",
				data     : param,
				dataType : "json",
				success  : function(data) {
					//console.log("Verify OTP");
					//console.log(data);
					if (data.otpResponse.uszReternCode == "0000") {						
						//console.log("Success Case");
						cancel();
						var tagType = '<%=request.getParameter("divType")%>';
						if (tagType == "submitInCashAdvance") {
							parent.submitAdvancePaymentCreation();
						} else if (tagType == "submitBankAdvancePayment") {
							parent.submitBankAdvancePayment();
						} else if (tagType == "stockTranferInternal") {
							parent.dofundtransferStockIn();
						} else if (tagType == "cashTranferInternal") {
							parent.dofundtransferIn();
						} else if (tagType == "submitEntilementOnline") {
							parent.doReg();
						} else if (tagType == "submitCashAdvanceInLoan") {
							parent.submitAdvancePaymentCreationInLoan();
						} else if (tagType == "submitInLoanRefund") {
							parent.submitLoanRefundCreation();
						} else if (tagType == "submitInOnlineSignOrder") {
							parent.submitOnlineSignOrder();
						} else if (tagType == "submit") {
							parent.dofundtransfer();
						} else if (tagType == "submit_reg") {
							parent.dofundtransfer_reg();
						} else if (tagType == "cancel") {
							parent.cancelFundTransfer();
						}
						//Save OTP if check checkbox
						if ($("#saveOTP").is(':checked')) {
							if (tagType != "submit" && tagType != "submit_reg" && tagType != "cancel") {
								saveMOTP();	
							}							
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
	
	function saveMOTP() {
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

	function cancel() {
		<%-- var tagId = '<%=request.getParameter("divId")%>';
		$("#" + tagId).fadeOut("normal", function() {
	        $(this).remove();
	    }); --%>
		var tagId = '<%=request.getParameter("divId")%>';
		$("#" + tagId).fadeOut();
	}

</script>

</head>
<body>

	<!-- Buy : Authentication -->
	<div id="divOTPLayer" class="modal_layer auth" style="top:10%; left:35%;border-radius:10px;">
		<div class="layer_add">
			<h2 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %></h2>
			<div id="divOTP" class="layer_add" style="padding:10px;">				
				<div class="form_area">
					<div>
						<label for="otp" style="padding-left:0;"><%= (langCd.equals("en_US") ? "Enter OTP Code" : "Nhập mã OTP") %></label>
						<input style="margin-left:8px;" type="text" id="otpCode" name="otpCode">						
					</div>
					
					<div style="margin-top:10px;" id="saveOTPArea">
						
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
			</div>
			<div>
				<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
			</div>
			<div class="btn_wrap">			
				<button style="width:80px;" type="button" id="btnExecute" onclick="verifyOTPCode()" class="add"><%= (langCd.equals("en_US") ? "Confirm" : "Xác nhận") %></button>
				<button type="button" onclick="cancel();"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
			</div>
		</div>
	</div>
	<!-- //Buy : Authentication -->
</body>

</html>