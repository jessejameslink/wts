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
	var msgResult = "";
	$(document).ready(function() {	
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		$("#btnMultiCanConfirm").focus();
		receiveData  = JSON.parse('<%=request.getParameter("multiDataList")%>');
		initDataSetting();
		if ("<%= authenMethod %>" != "matrix") {
			mcCheckOTP();
		} else {
			authConfirmMulCan();
		}
		document.getElementById("mcwordMatrixValue01").addEventListener("keyup", forceKeyUpMatrix, false);
		document.getElementById("mcwordMatrixValue02").addEventListener("keyup", forceKeyUpMatrix, false);
	});
	
	function forceKeyUpMatrix(e)
	{
	  if(this.value.length==$(this).attr("maxlength")){
		  $("#mcwordMatrixValue02").focus();
		}
	}
	
	function mcCheckOTP() {
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
					$("#divOTPMC").css("display", "block");
				} else {
					$("#divOTPMC").css("display", "none");
				}
			}
		});	
	}
	
	function initDataSetting() {
		var htmlStr = "";
		for(var i=0; i < receiveData.length; i++) {
			htmlStr += "<tr style=\"cursor:pointer\" " + (i % 2 == 0 ? "" : "class='even'") + ">";
			htmlStr += "	<td style='text-align:center !important'>" + receiveData[i].mvStockID + "</td>"; // 
			htmlStr += "	<td style='text-align:center !important'>" + receiveData[i].mvBS + "</td>"; //
			htmlStr += "	<td>" + numDotCommaFormat(receiveData[i].mvPrice.replace(/[,]/g, "")) + "</td>"; //
			htmlStr += "	<td>" + receiveData[i].mvQty + "</td>"; //
			htmlStr += "	<td>" + receiveData[i].mvOSQty + "</td>"; //
			htmlStr += "	<td style='text-align:center !important'>" + statusChange(receiveData[i].mvStatus) + "</td>"; //
			htmlStr += "	<td style='text-align:center !important'>" + receiveData[i].mvModifiedTime + "</td>"; //
			htmlStr += "</tr>";
		}
		$("#grdCancelOrder").html(htmlStr);
	}
	
	function authConfirmMulCan(confirm) {		
		$("#divMutilCanConf").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID		 : 	"<%= session.getAttribute("subAccountID") %>",
				wordMatrixKey01      : $("#mcmvWordMatrixKey01").text(),
				wordMatrixKey02      : $("#mcmvWordMatrixKey02").text(),
				wordMatrixValue01    : $("#mcwordMatrixValue01").val(),
				wordMatrixValue02    : $("#mcwordMatrixValue02").val(),
				serialnumber         : $("#serialnumber").val(),
				mvSaveAuthenticate   : $("#mcsaveAuthenticate").is(':checked')
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/authCardMatrix.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				$("#divMutilCanConf").unblock();
				if(data != null) {
					if(data.jsonObj.mvSuccess == "FAIL") {
						var authCard = data.jsonObj.mvClientCardBean;
						$("#mcmvWordMatrixKey01").html(authCard.mvWordMatrixKey01);
						$("#mcmvWordMatrixKey02").html(authCard.mvWordMatrixKey02);
						$("#serialnumber").val(authCard.serialnumber);
						$("#divAuth").css("display","block");
						if(data.jsonObj.mvClientCardBean.mvErrorCode != "CARD006"){ // not New Card
							alert(data.jsonObj.mvMessage);
							$("#mcwordMatrixValue01").val("");
							$("#mcwordMatrixValue02").val("");
						}
						if(data.jsonObj.mvClientCardBean.mvErrorCode == "SERVER_ERROR"){
							$("#divAuth").css("display","none");
							$("#btnMultiCanConfirm").css("display","none");
						}
					} else if(data.jsonObj.mvSuccess == "SUCCESS") {
						$("#divAuth").css("display","none");
						if(confirm && confirm =="confirm"){
							runMultiCancelConfirm();
						}
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divMutilCanConf").unblock();
			}

		});
	}
	
	function runMultiCancelConfirm() {
		$("#divMutilCanConf").block({message: "<span>LOADING...</span>"});
		if(receiveData.length > 20){
			if ("<%= langCd %>" == "en_US") {
    			autoAlert("Multi cancel overer 20 orders", 2000);
    		} else {
    			autoAlert("Hủy nhiều lênh vượt quá 20 lệnh.", 2000);
    		}
			$("#divMutilCanConf").unblock();
			cancelMC();
			return;
		}
		var strParam = [];
		for (var i = 0; i < receiveData.length; i++) {
			var dataObject = {"mvOrderId":receiveData[i].mvOrderID, "mvOrderGroupId":receiveData[i].mvOrderGroupID};
			strParam.push(dataObject);
		}
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
		    	$("#divMutilCanConf").unblock();
		    	if (data.jsonObj.mvResult == "success") {
		    		if ("<%= langCd %>" == "en_US") {
		    			autoAlert("Cancel Success", 2000);
		    		} else {
		    			autoAlert("Hủy lệnh thành công", 2000);
		    		}
		    		cancelMC();
		    	}else{
		    		alert(data.jsonObj.errorMessage); 
		    	}
		    },
		    error:function(e){
		    	console.log(e);
		    	$("#divMutilCanConf").unblock();
		    }
		});
	}

	function cancelMC() {		
		var tagId = '<%=request.getParameter("divIdMulti")%>';
		$("#" + tagId).fadeOut();
	}
	
	function statusChange(stus){
		switch(stus){
			case "SOI":
				if ("<%= langCd %>" == "en_US") {
					stus = "Stop Inactive Order";	
				} else {
					stus = "Chưa kích hoạt";
				}
				break;
			case "IAV":
				if ("<%= langCd %>" == "en_US") {
					stus = "Inactive";
				} else {
					stus = "Chưa kích hoạt";
				}
				break;
			case "SOR":
				if ("<%= langCd %>" == "en_US") {
					stus = "Stop Ready";
				} else {
					stus = "Lệnh dừng";
				}
				break;
			case "PAP":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PAM":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PAS":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PAI":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PSB":
				if ("<%= langCd %>" == "en_US") {
				stus = "Ready To Send";
				} else {
					stus = "Sẵn sàng gửi";
				}
				break;
			case "STB":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "WRN":
				if ("<%= langCd %>" == "en_US") {
				stus = "Price Warning";
				} else {
					stus = "Cảnh báo giá";
				}
				break;
			case "BIX":
				if ("<%= langCd %>" == "en_US") {
				stus = "Queue";
				} else {
					stus = "Chờ khớp";
				}
				break;
			case "ACK":
				if ("<%= langCd %>" == "en_US") {
				stus = "Queue";
				} else {
					stus = "Chờ khớp";
				}
				break;
			case "AMS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Modify Sent";
				} else {
					stus = "Đã gửi sửa";
				}
				break;
			case "ACS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Cancel Sent";
				} else {
					stus = "Đã gửi hủy"
				}
				break;
			case "BPM":
				if ("<%= langCd %>" == "en_US") {
				stus = "Watting Cancel";
				} else {
					stus = "Chờ hủy";
				}
				break;
			case "BMS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "BSS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "REJ":
				if ("<%= langCd %>" == "en_US") {
				stus = "Reject";
				} else {
					stus = "Đã từ chối";
				}
				break;
			case "CAN":
				if ("<%= langCd %>" == "en_US") {
				stus = "Cancelled";
				} else {
					stus = "Đã hủy";
				}
				break;
			case "WA":
				if ("<%= langCd %>" == "en_US") {
					stus = "Waiting";
				} else {
					stus = "Chờ xác nhận";
				}
				break;
			case "FEX":
				if ("<%= langCd %>" == "en_US") {
					stus = "Fully Executed";
				} else {
					stus = "Khớp toàn bộ";
				}
				break;
			case "PEX":
				if ("<%= langCd %>" == "en_US") {
					stus = "Partially Filled";
				} else {
					stus = "Khớp một phần";
				}
				break;
			case "Q":
				if ("<%= langCd %>" == "en_US") {
					stus = "Queued";
				} else {
					stus = "Chờ khớp";
				}
				break;
			case "WC":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Cancel";
				} else {
					stus = "Chờ hủy";
				}
				break;
			case "WM":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Modify";
				} else {
					stus = "Chờ sửa";
				}
				break;
			case "KLL":
				if ("<%= langCd %>" == "en_US") {
				stus = "Killed";
				} else {
					stus = "Đã từ chối";
				}
				break;				
			case "FLL":
				if ("<%= langCd %>" == "en_US") {
				stus = "Fully Filled";
				} else {
					stus = "Khớp toàn bộ";
				}
				break;
			case "FLC":
				if ("<%= langCd %>" == "en_US") {
				stus = "Partial Filled (Partial Cancel)";
				} else {
					stus = "Khớp 1 phần (Hủy 1 phần)";
				}
				break;
			case "FAK":
				if ("<%= langCd %>" == "en_US") {
				stus = "Filled and Killed";
				} else {
					stus = "Khớp và hủy";
				}
				break;
			case "MPA":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "MPS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Modify";
				} else {
					stus = "Chờ sửa";
				}
				break;
			case "MSD":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "WRR":
				if ("<%= langCd %>" == "en_US") {
				stus = "Price Warning";
				} else {
					stus = "Cảnh báo giá";
				}
				break;
			case "CPD":
				if ("<%= langCd %>" == "en_US") {
				stus = "Completed";
				} else {
					stus = "Đã hoàn thành";
				}
				break;
			case "EXP":
				if ("<%= langCd %>" == "en_US") {
				stus = "Expired";
				} else {
					stus = "Hết hiệu lực";
				}
				break;
			case "PXP":
				if ("<%= langCd %>" == "en_US") {
				stus = "Partially Expire";
				} else {
					stus = "Hết hạn 1 phần";
				}
				break;
			case "CON":
				if ("<%= langCd %>" == "en_US") {
				stus = "Conditional";
				} else {
					stus = "Lệnh điều kiện";
				}
				break;
			case "COI":
				if ("<%= langCd %>" == "en_US") {
				stus = "COI";
				} else {
					stus = "COI";
				}
				break;
			case "OCO":
				if ("<%= langCd %>" == "en_US") {
				stus = "OCO";
				} else {
					stus = "OCO";
				}
				break;
			case "OCI":
				if ("<%= langCd %>" == "en_US") {
				stus = "OCI";
				} else {
					stus = "OCI";
				}
				break;
			case "ALF":
				if ("<%= langCd %>" == "en_US") {
				stus = "Be Allocated";
				} else {
					stus = "Be Allocated (Fully Filled)";
				}
				break;
			case "UND":
				if ("<%= langCd %>" == "en_US") {
				stus = "Undefined";
				} else {
					stus = "Undefined";
				}
				break;
			case "NEW":
				if ("<%= langCd %>" == "en_US") {
					stus = "New";	
				} else {
					stus = "Chờ xử lý";
				}
				break;
			case "IAT":
				if ("<%= langCd %>" == "en_US") {
				stus = "Inactive";
				} else {
					stus = "Không hiệu lực";
				}
				break;
			case "SND":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gởi";
				}
				break;
			case "TRIG":
				if ("<%= langCd %>" == "en_US") {
				stus = "Trigger Order";
				} else {
					stus = "Lệnh điều kiện";
				}
				break;
			default:
				stus = "";
				break;
			}
		return stus;
	}
	
	function autoAlert(msg,duration){		
	 	var el = document.createElement("div");
	 	el.setAttribute("style","z-index:2000;position:fixed;top:0%;left:40%;background-color:grey;border-radius:3px;padding:20px 40px;font-size:16px;color:white;word-wrap: break-word;");
	 	el.innerHTML = msg;
	 	setTimeout(function(){
	  		el.parentNode.removeChild(el);
	 	},duration);
	 	document.body.appendChild(el);
	}
	
	function multiCancelConfirm() {
		if ("<%= authenMethod %>" == "matrix") {
			if($("#divAuth").css("display") == "none") {
				runMultiCancelConfirm();
			} else {
				authConfirmMulCan("confirm");
			}
		} else {
			if($("#divOTPMC").css("display") == "none") {
				runMultiCancelConfirm();
			} else {
				verifyMCOTPCode();
			}
		}
	}
	
	function verifyMCOTPCode() {
		if ($("#otpCodeMC").val().length != 6) {
			if ("<%= langCd %>" == "en_US") {
				alert("Occurs when the entered OTP number is not a six-digit number.");
			} else {
				alert("Lỗi xảy ra khi nhập OTP không là 6 chữ số.")
			}
			$("#otpCodeMC").focus();
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
				, uszOTP   			: btoa($("#otpCodeMC").val().trim())
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
						runMultiCancelConfirm();
						if ($("#saveOTP").is(':checked')) {
							saveMCOTP();
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
	
	function saveMCOTP() {
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
		<div class="modal_layer mult">			
			<h2 id="cancelModifyTitle"><%= (langCd.equals("en_US") ? "Confirm Multi Cancel Order" : "Xác Nhận Hủy Nhiều Lệnh") %></h2>
			<div id="divMutilCanConf">				
				<div class="group_table" style="height: 384px;overflow-y: auto;">
					<table class="no_bbt">
						<colgroup>
							<col width="10%">
							<col width="10%">
							<col width="16%">
							<col width="16%">
							<col width="20%">
							<col width="15%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Buy/Sell" : "Mua/Bán") %></th>
								<th><%= (langCd.equals("en_US") ? "Price(VND)" : "Giá(VND)") %></th>
								<th><%= (langCd.equals("en_US") ? "Vol" : "Khối lượng") %></th>
								<th><%= (langCd.equals("en_US") ? "Pending Vol" : "Khối lượng chờ khớp") %></th>
								<th><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
								<th><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
							</tr>
						</thead>				
						<tbody id="grdCancelOrder">							
						</tbody>
					</table>
				</div>

				<div id="divAuth" class="layer_add" style="display:none;">
					<h3 class="layer_add_title" style="width:300px;margin-left:200px;"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %></h3>
					<div class="form_area" style="width:300px;left:200px;">
						<ul class="security_check">
							<li><strong id="mcmvWordMatrixKey01"></strong><input type="password" id="mcwordMatrixValue01" name="mcwordMatrixValue01"  value="" maxlength="1"  /></li>
							<li><strong id="mcmvWordMatrixKey02"></strong><input type="password" id="mcwordMatrixValue02" name="mcwordMatrixValue02" value="" maxlength="1"  /></li>
						</ul>
						<div>
							<input type="checkbox" id="mcsaveAuthenticate" name="mcsaveAuthenticate" checked="checked">
							<label for="saveA"><%= (langCd.equals("en_US") ? "Save Authentication?" : "Lưu xác thực?") %></label>
						</div>
					</div>
					<div style="padding: 20px;">
						<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
					</div>
				</div>
				<!-- OPT Confirm -->
				<div id="divOTPMC" class="layer_add" style="display:none;">
					<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %></h3>
						<div class="form_area">
							<div>
								<label for="otp" style="padding-left:0;"><%= (langCd.equals("en_US") ? "Enter OTP Code" : "Nhập mã OTP") %></label>
								<input style="margin-left:8px;" type="text" id="otpCodeMC" name="otpCodeMC">						
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
					<button id="btnMultiCanConfirm" type="button" onclick="multiCancelConfirm()" class="add"><%= (langCd.equals("en_US") ? "Confirm" : "Xác nhận") %></button>
					<%-- <button id="btnMultiCanConfirm" type="button" onclick="authConfirm('confirm')" class="add"><%= (langCd.equals("en_US") ? "Confirm" : "Xác nhận") %></button> --%>
					<button type="button" onclick="cancelMC()"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
				</div>
			</div>
		</div>
	</form>
</body>

</html>