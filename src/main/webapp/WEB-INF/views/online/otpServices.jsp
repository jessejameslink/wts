<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var mvPhoneNumber = "";
	var sSecretKey = "";
	$(document).ready(function() {
		$("#accNumber").val("<%= session.getAttribute("clientID") %>");
		$("#accName").val("<%= session.getAttribute("ClientName") %>");
		
		//$("#ctcheck").css("display", "none");
		$("#ctconfirm").css("display", "none");
		
		$("#content1").css("display", "inline-block");
		$("#content2").css("display", "none");
		$("#content3").css("display", "none");
		getPhoneNumber();
	});
	
	function menu1Click() {
		$("#menu1").addClass("on");
		$("#menu2").removeClass("on");
		$("#menu3").removeClass("on");
		
		$("#objType").val(1);
		chgType(1);
		
		//$("#btnFailed").css("display", "none");
		
		$("#lbType").css("display", "none");
		$("#txtType").css("display", "none");
		
		$("#content1").css("display", "inline-block");
		$("#content2").css("display", "none");
		$("#content3").css("display", "none");
	}
	
	function menu2Click() {
		$("#menu1").removeClass("on");
		$("#menu2").addClass("on");
		$("#menu3").removeClass("on");
				
		//$("#btnFailed").css("display", "inline-block");
		$("#lbType").css("display", "inline-block");
		$("#txtType").css("display", "inline-block");
		
		$("#content1").css("display", "none");
		$("#content2").css("display", "inline-block");
		$("#content3").css("display", "none");
		
		getFailedNumber();
	}
		
	function menu3Click() {
		$("#menu1").removeClass("on");
		$("#menu2").removeClass("on");
		$("#menu3").addClass("on");
		
		//$("#btnFailed").css("display", "none");
		$("#lbType").css("display", "none");
		$("#txtType").css("display", "none");
		
		$("#content1").css("display", "none");
		$("#content2").css("display", "none");
		if ("<%= authenMethod %>" == "hwotp") {
			$("#content3").css("display", "inline-block");	
		} else {
			$("#content3").css("display", "none");
			if("<%= langCd %>" == "en_US") {
  				alert("This function only use for H/W OTP.");
  			} else {
  				alert("Chức năng này chỉ dử dụng cho H/W OTP.");
  			}
		}
	}
	
	function chgType(type) {
		if(type == "1") {
			//$("#ctcheck").css("display", "none");
			$("#ctconfirm").css("display", "none");
			
			$("#btnOkClicked").css("display", "inline-block");
			//$("#btnCheckEmail").css("display", "none");
			$("#btnConfirmed").css("display", "none");
			$("#descUnlock").css("display", "none");
			$("#descError").css("display", "block");
		} else {
			//$("#ctcheck").css("display", "inline-block");
			$("#ctconfirm").css("display", "inline-block");
			$("#descUnlock").css("display", "block");
			$("#descError").css("display", "none");
			$("#btnOkClicked").css("display", "none");
			//$("#btnCheckEmail").css("display", "inline-block");
			$("#btnConfirmed").css("display", "inline-block");
		}
	}
	
	function errorReportClicked() {
		if ("<%= authenMethod %>" == "swotp") {
			verifyOTPCode("402", "");
		} else {
			verifyOTPCode("704", "");	
		}		
	}
	
	function getFailedNumber() {
		verifyOTPCode("701", "");
	}
	
	function editTimeClicked() {
		if ($("#txtOTP").val() == "") {
			if("<%= langCd %>" == "en_US") {
  				alert("Please input OTP code.");
  			} else {
  				alert("Vui lòng nhập mã OTP.");
  			}
			return;
		}
		
		verifyOTPCode("703", btoa($("#txtOTP").val().trim()));
	}
	
	function checkEmail() {
		if ($("#txtEmail").val() == "") {
			if("<%= langCd %>" == "en_US") {
  				alert("Please input your email.");
  			} else {
  				alert("Vui lòng nhập email của bạn.");
  			}
			return;
		}
		var param	=	{
				mvClientID : "<%= session.getAttribute("clientID") %>"
		};
		$.ajax({
			url:'/accInfo/getAccInfo.do',
			data:param,
			cache: false,
		  	dataType: 'json',
		  	success: function(data){
		  		if(data.jsonObj.mvPersonnalProfileBean != null) {
		  			var odata	=	data.jsonObj.mvPersonnalProfileBean;
					var mvEmail			=	odata.mvEmail;
					mvPhoneNumber	=	odata.mvPhoneNumber;
					if (mvEmail == $("#txtEmail").val().trim()) {						
						$("#ctcheck").css("display", "none");
						$("#ctconfirm").css("display", "inline-block");
						$("#btnCheckEmail").css("display", "none");
						$("#btnConfirmed").css("display", "inline-block");
						
						$("#txtEmail").val("");
					} else {
						if("<%= langCd %>" == "en_US") {
			  				alert("Email not matched.");
			  			} else {
			  				alert("Email không đúng.");
			  			}
						return;
					}
		  		} else {
		  			if("<%= langCd %>" == "en_US") {
		  				alert("No Search Data");
		  			} else {
		  				alert("Không tìm thấy dữ liệu");
		  			}
		  		}
		  	}
		});
	}
	
	function getPhoneNumber() {		
		var param	=	{
				mvClientID : "<%= session.getAttribute("clientID") %>"
		};
		$.ajax({
			url:'/accInfo/getAccInfo.do',
			data:param,
			cache: false,
		  	dataType: 'json',
		  	success: function(data){
		  		if(data.jsonObj.mvPersonnalProfileBean != null) {
		  			var odata	=	data.jsonObj.mvPersonnalProfileBean;					
					mvPhoneNumber	=	odata.mvPhoneNumber;					
		  		} else {
		  			if("<%= langCd %>" == "en_US") {
		  				alert("No Search Data");
		  			} else {
		  				alert("Không tìm thấy dữ liệu");
		  			}
		  		}
		  	}
		});
	}
	
	function sendConfirmCode2() {
		var param = {
				mvAction			: "Default",
				mvDestination		: mvPhoneNumber,
				mvLanguage    		: "<%= session.getAttribute("LanguageCookie") %>"
		};
		
		//console.log("PARAM GET OTP");
		//console.log(param);
		
		$.ajax({
			url:'/online/data/genOTP.do',
			data: param,
			cache: false,
		    dataType: 'json',
		    type: 'GET',
		    success: function(data){
		    	console.log("Get new OTP");
		    	//console.log(data);
		    	if (data.jsonObj.success == true) {
		    		sSecretKey = data.jsonObj.secretKey;		
					$("#btnSendPin").val('<%=(langCd.equals("en_US") ? "Re-Send confirmation code" : "Gửi lại mã xác nhận")%>');
					alert('<%= (langCd.equals("en_US") ? "Confirmation code sent successful" : "Mã xác nhận đã gởi thành công") %>');
					//$(this).attr("disabled","disabled");
					$('#btnSendPin').attr("disabled","disabled");
					$('#btnSendPin').removeClass('btn');
					$('#btnSendPin').addClass('btn:hover');
					$('#smsOtpSucc2').css("display","block");
					
		    	} else {
		    		if ("<%= langCd %>" == "en_US") {
						alert("Can't get OTP code.");	
					} else {
						alert("Không thể lấy mã OTP.");
					}
					return;
		    	}
		    },
		    error : function(data) {		    	
		    	return;
		    }
		});
	}
	
	function sendConfirmCode() {
		var param = {
				mvAction			: "Default",
				mvDestination		: mvPhoneNumber,
				mvLanguage    		: "<%= session.getAttribute("LanguageCookie") %>"
		};
		
		//console.log("PARAM GET OTP");
		//console.log(param);
		
		$.ajax({
			url:'/online/data/genOTP.do',
			data: param,
			cache: false,
		    dataType: 'json',
		    type: 'GET',
		    success: function(data){
		    	//console.log("Get new OTP");
		    	//console.log(data);
		    	if (data.jsonObj.success == true) {
		    		sSecretKey = data.jsonObj.secretKey;	
					$("#btnSendCode").val('<%=(langCd.equals("en_US") ? "Re-Send confirmation code" : "Gửi lại mã xác nhận")%>');
					alert('<%= (langCd.equals("en_US") ? "Confirmation code sent successful" : "Mã xác nhận đã gởi thành công") %>');
					$('#btnSendCode').attr("disabled","disabled");
					$('#btnSendCode').removeClass('btn');
					$('#btnSendCode').addClass('btn:hover');
					$('#smsOtpSucc').css("display","block");

		    	} else {
		    		if ("<%= langCd %>" == "en_US") {
						alert("Can't get OTP code.");	
					} else {
						alert("Không thể lấy mã OTP.");
					}
					return;
		    	}
		    },
		    error : function(data) {		    	
		    	return;
		    }
		});
	}
	
	function confirmed() {
		if ("<%= authenMethod %>" == "swotp") {
			if ("<%= langCd %>" == "en_US") {
				alert("With SW OTP, when reporting lost on SW, immediately SW is Unregistered so there is no SW Unlock service.");	
			} else {
				alert("Với SW OTP, khi thực hiện thao tác này, SW OTP trên thiết bị đã đăng ký sẽ bị hủy và không có chức năng Mở khóa. Muốn dùng lại phải đăng ký mới.");
			}
			return;
		}
			
		if ($("#txtCode").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input Confirm code.");	
			} else {
				alert("Vui lòng nhập mã xác nhận.");
			}
			$("#txtCode").focus();
			return;
		}
		
		var param = {
				mvClientID : "<%= session.getAttribute("clientID") %>",
				mvOtp				: $("#txtCode").val(),
				mvSecretKey			: sSecretKey,
				mvLanguage			: "<%= langCd %>"
		};
		
		//console.log(param);
		
		$.ajax({
			url:'/online/data/verifyOTP.do',
			data: param,
			cache: false,
		    dataType: 'json',
		    type: 'GET',
		    success: function(data){
		    	//console.log("Verify OTP code");
		    	//console.log(data);
		    	if (data.jsonObj.success == true) {
		    		verifyOTPCode("705", "");				
		    	} else {
		    		//For testing not golive
		    		//verifyOTPCode("705", "");
		    		if (data.jsonObj.errorCode == "1100") {
		    			if ("<%= langCd %>" == "en_US") {
		    				alert("Invalid Confirm code.");	
		    			} else {
		    				alert("Mã xác nhận không đúng.");
		    			}
		    		} else if (data.jsonObj.errorCode == "1111") {
		    			if ("<%= langCd %>" == "en_US") {
		    				alert("Confirm code is used. Please resend Confirm code.");	
		    			} else {
		    				alert("Mã xác nhận đã sử dụng. Vui lòng gởi lại mã xác nhận.");
		    			}
				} else if (data.jsonObj.success){
		    			if ("<%= langCd %>" == "en_US") {
		    				alert("Successful!");	
		    			} else {
		    				alert("Thành công !");
		    			}
		    		} else {
		    			alert(data.jsonObj.errorCode);	
		    		}
		    		$("#txtCode").focus();
		    		$("#txtCode").val("");
		    	}
		    },
		    error : function(data) {		    	
		    	return;
		    }
		});
	}
	
	function confirmed2() {
		if ($("#txtPin").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Please input Confirm code.");	
			} else {
				alert("Vui lòng nhập mã xác nhận.");
			}
			$("#txtPin").focus();
			return;
		}
		
		var param = {
				mvClientID : "<%= session.getAttribute("clientID") %>",
				mvOtp				: $("#txtPin").val(),
				mvSecretKey			: sSecretKey,
				mvLanguage			: "<%= langCd %>"
		};
		
		//console.log(param);
		
		$.ajax({
			url:'/online/data/verifyOTP.do',
			data: param,
			cache: false,
		    dataType: 'json',
		    type: 'GET',
		    success: function(data){
		    	//console.log("Verify OTP code");
		    	//console.log(data);
		    	if (data.jsonObj.success == true) {
		    		if ("<%= authenMethod %>" == "hwotp") {
		    			verifyOTPCode("802", "");					
		    		} else if ("<%= authenMethod %>" == "swotp") {
		    			verifyOTPCode("801", "");
		    		}
		    	} else {		    		
		    		if (data.jsonObj.errorCode == "1100") {
		    			if ("<%= langCd %>" == "en_US") {
		    				alert("Invalid Confirm code.");	
		    			} else {
		    				alert("Mã xác nhận không đúng.");
		    			}
		    		} else if (data.jsonObj.errorCode == "1111") {
		    			if ("<%= langCd %>" == "en_US") {
		    				alert("Confirm code is used. Please resend Confirm code.");	
		    			} else {
		    				alert("Mã xác nhận đã sử dụng. Vui lòng gởi lại mã xác nhận.");
		    			}
				} else if (data.jsonObj.success){
		    			if ("<%= langCd %>" == "en_US") {
		    				alert("Successful!");	
		    			} else {
		    				alert("Thành công !");
		    			}
		    		} else {
		    			alert(data.jsonObj.errorCode);	
		    		}
		    		$("#txtPin").focus();
		    		$("#txtPin").val("");
		    	}
		    },
		    error : function(data) {		    	
		    	return;
		    }
		});
	}	
	
	function verifyOTPCode(otpType, otpCode) {
		var cusNo = '<%=session.getAttribute("clientID") %>';
		if (cusNo.length > 7){
			cusNo = cusNo.substring(3);
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
				, uszOTP   				: otpCode
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
					//console.log("Verify OTP");
					//console.log(data);
					if (data.otpResponse.uszReternCode == "0000") {						
						//console.log("Success Case");
						if (otpType == "801" || otpType == "802") {
							//getFailedNumber();
							if ("<%= langCd %>" == "en_US") {
								alert("Reset failed number is success.")
							} else {
								alert("Khôi phục số lần sai thành công.")
							}
							if ("<%= langCd %>" == "en_US") {
								$("#txtSeries").val("0 time / 10 times")
							} else {
								$("#txtSeries").val("0 lần / 10 lần")
							}
							
							$("#txtPin").val("");
						} else if (otpType == "703") {
							if ("<%= langCd %>" == "en_US") {
								alert("Resyns is success.")
							} else {
								alert("Hiệu chỉnh thành công.")
							}
							$("#txtOTP").val("");
						} else if (otpType == "704" || otpType == "402") {
							if ("<%= langCd %>" == "en_US") {
								alert("Report error is success.")
							} else {
								alert("Báo lỗi thành công.")
							}
						} else if (otpType == "705") {
							if ("<%= langCd %>" == "en_US") {
								alert("Restore is success.")
							} else {
								alert("Mở khóa thành công.")
							}
						}
					} else {
						if (otpType == "701") {
							if ("<%= authenMethod %>" == "hwotp") {
								if ("<%= langCd %>" == "en_US") {
									if (data.otpResponse.uszHwFailCnt > 1) {
										$("#txtSeries").val(data.otpResponse.uszHwFailCnt + " times / 10 times")
									} else {
										$('#btnSendPin').attr("disabled","disabled");
										$('#btnSendPin').removeClass('btn');
										$('#btnSendPin').addClass('btn:hover');
										$("#txtSeries").val(data.otpResponse.uszHwFailCnt + " time / 10 times")
									}
								} else {
									if (data.otpResponse.uszHwFailCnt > 1) {
										
									} else {
										$('#btnSendPin').attr("disabled","disabled");
										$('#btnSendPin').removeClass('btn');
										$('#btnSendPin').addClass('btn:hover');
									}
									$("#txtSeries").val(data.otpResponse.uszHwFailCnt + " lần / 10 lần")
								}
							} else if ("<%= authenMethod %>" == "swotp") {
								if ("<%= langCd %>" == "en_US") {
									if (data.otpResponse.uszSwFailCnt > 1) {
										$("#txtSeries").val(data.otpResponse.uszSwFailCnt + " times / 10 times")
									} else {
										$('#btnSendPin').attr("disabled","disabled");
										$('#btnSendPin').removeClass('btn');
										$('#btnSendPin').addClass('btn:hover');
										$("#txtSeries").val(data.otpResponse.uszSwFailCnt + " time / 10 times")
									}
								} else {
									if (data.otpResponse.uszHwFailCnt > 1) {
										
									} else {
										$('#btnSendPin').attr("disabled","disabled");
										$('#btnSendPin').removeClass('btn');
										$('#btnSendPin').addClass('btn:hover');
									}
									$("#txtSeries").val(data.otpResponse.uszSwFailCnt + " lần / 10 lần")
								}
							}
							return;
						}
						//console.log("Error Case");
						var errMessage = "";						
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
						} else if (data.otpResponse.uszReternCode == "6003") {
							if ("<%= langCd %>" == "en_US") {
								errMessage += "Time Resync failure.\n";
							} else {
								errMessage += "Lỗi đồng bộ lại thời gian";
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
						alert(errMessage);
						
					}					
				}
			});	
	}
	
</script>
<style>
/*
 * OTP Services
 */
.otp_menu {position:relative; float:left; width:240px; z-index:1;}
.otp_menu ul {padding:9px 0 8px; background:#f7f7f7;}
.otp_menu li a {display:block; padding:12px 10px 11px 21px; font-size:14px; line-height:2em}
.otp_menu li a:hover,
.otp_menu li a.on {color:#fff; background:#4973ad;}

.otp_contents {position:relative;padding:0px 40px 0 265px;}
</style>
<div class="tab_content">
	<div class="otp_menu">
		<ul>
			<li>
				<a class="on" id="menu1" onclick="menu1Click();"><%= (langCd.equals("en_US") ? "Lost Report / Restore" : "Báo cáo lỗi và Mở khóa dịch vụ") %></a>
			</li>
			<li>
				<a id="menu2" onclick="menu2Click();"><%= (langCd.equals("en_US") ? "Failed Query / Reset" : "Tra cứu và Khôi phục số lần sai") %></a>
			</li>
			<li>
				<a id="menu3" onclick="menu3Click();"><%= (langCd.equals("en_US") ? "Resync OTP" : "Hiệu chỉnh thời gian") %></a>
			</li>						
		</ul>
	</div>
	<div class="otp_contents">
		<!-- Account Info -->
		<div>
			<label><%= (langCd.equals("en_US") ? "Account Number" : "Số TK") %></label>
			<input style="margin-left:8px;" type="text" id="accNumber" name="accNumber" disabled>
			<input style="margin-left:8px;" type="text" id="accName" name="accName" disabled>
			
			<!--  
			<button type="button" onclick="queryFailed();" style="display:none;margin-left:8px;" id="btnFailed" class="btn"><%= (langCd.equals("en_US") ? "Query" : "Tra cứu") %></button>
			-->
			<label style="display:none;margin-left:8px;" id="lbType"><%= (langCd.equals("en_US") ? "Type" : "Phân loại") %></label>
			<input style="display:none;margin-left:8px;" type="text" id="txtType" name="txtType" disabled placeholder="<%= (langCd.equals("en_US") ? "Reset failed count" : "Khôi phục số lần sai") %>">
		</div>
		<div style="border-bottom:1px solid;padding-top:10px;"></div>
		
		<!-- Content 1 -->
		<div id="content1">
			<div style="padding-top:10px;">			
				<label style="width:120px;"><%= (langCd.equals("en_US") ? "Type" : "Phân loại") %></label>
				<select id="objType" style="width:155px;" onchange="chgType(this.value);">
					<option value="1"><%= (langCd.equals("en_US") ? "1. Lost Report" : "1. Báo cáo lỗi") %></option>
					<option value="2"><%= (langCd.equals("en_US") ? "2. Restore" : "2. Mở khóa dịch vụ") %></option>
				</select>
			</div>
			<!--  
			<div style="padding-top:10px;" id="ctcheck">
				<label style="width:120px;"><%= (langCd.equals("en_US") ? "Email Confirm" : "Xác nhận Email") %></label>
				<input style="" type="text" id="txtEmail" name="txtEmail">
			</div>
			-->
			<div style="padding-top:10px;" id="ctconfirm">
				<label style="width:120px;"><%= (langCd.equals("en_US") ? "Confirm Code" : "Mã xác nhận") %></label>
				<input style="" type="text" id="txtCode" name="txtCode">
				<button type="button" onclick="sendConfirmCode();" style="margin-left:8px;" id="btnSendCode" class="btn"><%= (langCd.equals("en_US") ? "Send confirmation code" : "Gửi mã xác nhận") %></button>
			</div>
			<div id="smsOtpSucc" class="desc" style="padding-top:30px;display: none;">
				<% if(langCd.equals("en_US")) { %>
					<p>The verification code has been sent to the registered phone number and is valid within 3 minutes.</p>
				<% } else { %>
					<p>Mã xác thực đã gởi đến số điện thoại đăng ký và có hiệu lực trong vòng 3 phút.</p>
				<% } %>
			</div>
			<div style="padding-top:50px;padding-left:130px;">
				<button type="button" onclick="errorReportClicked();" style="margin-left:8px;" id="btnOkClicked" class="btn">OK</button>
				<!--  
				<button type="button" onclick="checkEmail();" style="margin-left:8px;display:none;" id="btnCheckEmail" class="btn"><%= (langCd.equals("en_US") ? "Check" : "Kiểm tra") %></button>
				-->
				<button type="button" onclick="confirmed();" style="margin-left:8px;display:none;" id="btnConfirmed" class="btn"><%= (langCd.equals("en_US") ? "Confirm" : "Xác nhận") %></button>
			</div>
			
			<div id="descError" class="desc" style="padding-top:30px;display:block">
				<% if(langCd.equals("en_US")) { %>
					<p>With SW OTP, when reporting lost on SW, immediately SW is Unregistered so there is no SW Unlock service.</p>
				<% } else { %>
					<p>Với SW OTP, khi thực hiện thao tác này, SW OTP trên thiết bị đã đăng ký sẽ bị hủy và không có chức năng Mở khóa. Muốn dùng lại phải đăng ký mới.</p>
				<% } %>
			</div>
			<div id="descUnlock" class="desc" style="padding-top:30px;display:none">
				<% if(langCd.equals("en_US")) { %>
					<p>Unlock service is only apllied for Harware OTP ( Token OTP/ Card OTP)</p>
				<% } else { %>
					<p>Chức năng " Mở khóa" chỉ dùng cho Hardware OTP (Token OTP/ Card OTP)</p>
				<% } %>
			</div>
		</div>
		
		<!-- Content 2 -->
		<div id="content2">
			<div style="padding-top:10px;">
				<label style="width:120px;"><%= (langCd.equals("en_US") ? "OTP Failed Times" : "Số lần sai OTP") %></label>
				<input style="" type="text" id="txtSeries" name="txtSeries" disabled>
			</div>
			<div style="padding-top:10px;">
				<label style="width:120px;"><%= (langCd.equals("en_US") ? "Confirm Number" : "Số xác nhận") %></label>
				<input style="" type="text" id="txtPin" name="txtPin">
				<button type="button" onclick="sendConfirmCode2();" style="margin-left:8px;" id="btnSendPin" class="btn"><%= (langCd.equals("en_US") ? "Send confirmation code" : "Gửi mã xác nhận") %></button>
			</div>
			<div id="smsOtpSucc2" class="desc" style="padding-top:30px;display: none;">
				<% if(langCd.equals("en_US")) { %>
					<p>The verification code has been sent to the registered phone number and is valid within 3 minutes.</p>
				<% } else { %>
					<p>Mã xác thực đã gởi đến số điện thoại đăng ký và có hiệu lực trong vòng 3 phút.</p>
				<% } %>
			</div>
			<div style="padding-top:50px;padding-left:130px;">				
				<button type="button" onclick="confirmed2();" style="margin-left:8px;" id="btnConfirmedPin" class="btn"><%= (langCd.equals("en_US") ? "Confirm" : "Xác nhận") %></button>
			</div>
			<div class="desc" style="padding-top:30px;">
				<% if(langCd.equals("en_US")) { %>
					<p>OTP is wrong more than 10 times, reset the number of times to continue using the service again.</p>
				<% } else { %>
					<p>OTP sai quá 10 lần, thực hiện reset lại số lần để tiếp tục sử dụng lại dịch vụ.</p>
				<% } %>
			</div>
		</div>
		
		<!-- Content 3 -->
		<div id="content3">
			<div style="padding-top:10px;">
				<label style="width:120px;"><%= (langCd.equals("en_US") ? "OTP Code" : "Mã xác thực OTP") %></label>
				<input style="" type="text" id="txtOTP" name="txtOTP">
			</div>
			<div class="desc" style="padding-top:30px;">
				<% if(langCd.equals("en_US")) { %>
					<p>To correct the time, please enter the OTP code.</p>
				<% } else { %>
					<p>Để hiệu chỉnh thời gian, vui lòng nhập mã OTP.</p>
				<% } %>
			</div>
			<div style="padding-top:30px;padding-left:130px;">
				<button type="button" onclick="editTimeClicked();" style="margin-left:8px;" id="btnOk3Clicked" class="btn">OK</button>
			</div>		
		</div>
	</div>
</div>

</html>
