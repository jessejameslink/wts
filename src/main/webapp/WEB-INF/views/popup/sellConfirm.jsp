<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<script>
	$(document).ready(function() {
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		$("#btnConfirmOrderSell").focus();
		$("#popTitleSC").append (("<%=langCd%>" == "en_US" ? ("${buySell}" == "buy" ? "Buy" : "Sell") : ("${buySell}" == "buy" ? "Mua" : "Bán")) );
		if ("<%=authenMethod%>" != "matrix") {
			sCheckOTP();
		} else {
			authConfirmSell("");
		}
		//verifyOrder();
		document.getElementById("sellwordMatrixValue01").addEventListener("keyup", forceKeyUpMatrix, false);
		document.getElementById("sellwordMatrixValue02").addEventListener("keyup", forceKeyUpMatrix, false);
	});
	
	function forceKeyUpMatrix(e)
	{
	  if(this.value.length==$(this).attr("maxlength")){
		  $("#sellwordMatrixValue02").focus();
		}
	}
	
	function sCheckOTP() {
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
					$("#divOTPS").css("display", "block");
				} else {
					$("#divOTPS").css("display", "none");
				}
			}
		});	
	}

	function verifyOrder() {
		$("#divSellConf").block({message: "<span>LOADING...</span>"});
		var param = {
				mvBS             : $("#buySellSC").val(),
				mvStockCode      : $("#stockSC").val(),
				//mvMarketId       : $("#mvMarketId").val(),
				mvMarketID       : $("#mvMarketIdSC").val(),
				mvPrice          : $("#priceSC").val(),
				mvQuantity       : $("#volumeSC").val(),
				mvOrderTypeValue : $("#orderTypeSC").val(),
				mvGrossAmt       : $("#valueSC").val(),
				mvBankID         : $("#mvBankIDSC").val(),
				mvBankACID       : $("#mvBankACIDSC").val(),
				mvGoodTillDate   : $("#expiryDtSC").val()
		};

		//console.log("VERIFY ORDER CHECK");
		//console.log(param);
		
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/verifyOrder.do",
			data      : param,
			cache 	  : false,
			success   : function(data) {
				$("#divSellConf").unblock();
				if(data.jsonObj != null) {
// 					authConfirmSell("");
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divSellConf").unblock();
			}
		});
	}

	function authConfirmSell(flag) {
		$("#divSellConf").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID		 : 	"<%=session.getAttribute("subAccountID")%>",
				wordMatrixKey01      : $("#sellmvWordMatrixKey01").text(),
				wordMatrixKey02      : $("#sellmvWordMatrixKey02").text(),
				wordMatrixValue01    : $("#sellwordMatrixValue01").val(),
				wordMatrixValue02    : $("#sellwordMatrixValue02").val(),
				serialnumber         : $("#serialnumber").val(),
				mvSaveAuthenticate   : $("#sellsaveAuthenticate").is(':checked')
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/authCardMatrix.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				$("#divSellConf").unblock();
				if(data.jsonObj != null) {
					if(data.jsonObj.mvSuccess == "FAIL") {
						$("#divAuth").css("display", "block");
						var authCard = data.jsonObj.mvClientCardBean;
						$("#sellmvWordMatrixKey01").html(authCard.mvWordMatrixKey01);
						$("#sellmvWordMatrixKey02").html(authCard.mvWordMatrixKey02);
						$("#serialnumber").val(authCard.serialnumber);
						if(data.jsonObj.mvClientCardBean.mvErrorCode == "incorrect") {
							alert("Not Correct CartNo.\n" + data.jsonObj.mvErrorResult);
						}
						
					} else if(data.jsonObj.mvSuccess == "SUCCESS") {
						if(flag == "SAVE") {
							enterSell();
						}
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divSellConf").unblock();
			}
		});
	}

	function sellConfirm() {
		if ("<%=authenMethod%>" == "matrix") {
			if($("#divAuth").css("display") == "none") {
				enterSell();
			} else {
				authConfirmSell("SAVE");
			}
		} else {
			if($("#divOTPS").css("display") == "none") {
				enterSell();
			} else {
				verifySOTPCode();
			}
		}
	}
	
	function verifySOTPCode() {
		if ($("#otpCode").val().length != 6) {
			if ("<%=langCd%>" == "en_US") {
				alert("Occurs when the entered OTP number is not a six-digit number.");
			} else {
				alert("Lỗi xảy ra khi nhập OTP không là 6 chữ số.")
			}
			$("#otpCode").focus();
			return;
		}
		var cusNo = '<%=session.getAttribute("ClientV")%>';
		if (cusNo.length > 7){
			cusNo = cusNo.substring(3);
		}
		var otpType = "";
		if ("<%=authenMethod%>" == "hwotp") {
			otpType = "702";
		} else if ("<%=authenMethod%>" == "swotp") {
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
						enterSell();
						if ($("#saveOTP").is(':checked')) {
							saveSOTP();
						}
					} else {
						//console.log("Error Case");
						var errMessage = "";
						var failedMessage = "";
						var failedNumber;
						if ("<%=authenMethod%>" == "hwotp") {
							failedNumber = data.otpResponse.uszHwFailCnt;
						} else {
							failedNumber = data.otpResponse.uszPinFailCnt;
						}
						if ("<%=langCd%>" == "en_US") {
							failedMessage += "OTP code is wrong " + failedNumber + " time(s). Please input again.\n(Notice, input wrong OTP  exceed 10 times, have to reset failed number OTP.)";
						} else {
							failedMessage += "Mã OTP nhập sai " + failedNumber + " lần. Vui lòng nhập lại.\n(Lưu ý, nhập sai OTP quá 10 lần, OTP buộc phải tiến hành cài đặt lại.)";
						}
						if (data.otpResponse.uszReternCode == "1001") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Unauthorized device. It can be used after registration.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1002") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Unauthorized app. It can be used after registering the app.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1003") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "It is already registered and used. If you want to register again, please deregister and register again.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1006") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "There are no registrations with the corresponding product.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1012") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "No valid server challenge found for this request.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1013") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "User biometric authentication is not complete (in progress)\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1014") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Expiration time for the authentication result confirmation has been exceeded. (Max 5 minutes)\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1015") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Not applicable. (Already processed)\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1016") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Missing report state\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1101") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "The registration code request is prohibited.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1103") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Registration code expired or registration code not found.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1400") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "URL call error that does not match the authentication type. (Check FIDO, BIOTP)/Invalid URL call\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1401") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Unauthorized user. The service can be used after the registration process.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1498") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Error in request message format, parameter name, or parameter input information.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1500") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Internal error in the server.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1601") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "There is no registered authentication product (such as PIN/Pattern).\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "1602") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Authentication failed with the authentication product (such as PIN/Pattern).\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5001") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Unauthorized user. The service can be used after the registration process.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5002") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "No Token ID\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5003") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "No Key Data\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "5004") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Uninsurable state\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6000") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "OTP authentication number (6 digits only) verification failed.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6013") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Incomplete the biometric authentication.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6014") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "The OTP authentication request has been made for already verified status.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6015") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "False request due to the request of transaction linkage OTP verification rather than the regular OTP verification. Or false request due to the request of regular OTP verification rather than transaction linkage OTP verification.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6016") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Transaction information (TranInfo) error.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6017") {
							if ("<%=langCd%>" == "en_US") {
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
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Unissued status\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6024") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Suspension of service\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "6025") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Revocation\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8001") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Unauthorized user. The service can be used after the registration process.\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8002") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "No Token ID\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8003") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "No Key Data\n";
							} else {
								errMessage += "";
							}
						} else if (data.otpResponse.uszReternCode == "8004") {
							if ("<%=langCd%>" == "en_US") {
								errMessage += "Not revocable\n";
							} else {
								errMessage += "";
							}
						} else {
							if ("<%=langCd%>" == "en_US") {
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
	
	function saveSOTP() {
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

	function enterSell() {
		$("#divSellConf").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID			  : "<%=session.getAttribute("subAccountID")%>",
				mvBS                      : $("#divSellConf").find("#buySellSC").val(),
				mvStockCode               : $("#divSellConf").find("#stockSC").val(),				
				//mvOrderTypeValue          : ( $("#divSellConf").find("#mvStopSC").val() == "N" ? $("#divSellConf").find("#orderTypeSC").val() : "P"),
				mvOrderTypeValue          : $("#divSellConf").find("#orderTypeSC").val(),
				mvQuantity                : $("#divSellConf").find("#volumeSC").val(),
				mvPrice                   : numIntFormat(numDotComma($("#divSellConf").find("#priceSC").val()) / 1000),
				mvGrossAmt                : $("#divSellConf").find("#valueSC").val(),				
				mvMarketID                : $("#divSellConf").find("#mvMarketIdSC").val(),				
				mvGoodTillDate            : $("#divSellConf").find("#expiryDtSC").val(),				
				mvBankID                  : $("#divSellConf").find("#mvBankIDSC").val(),
				mvBankACID                : $("#divSellConf").find("#mvBankACIDSC").val(),
				mvStop					  : $("#mvStopSC").val(),
				mvStopPrice				  : ($("#mvStopPriceSC").val() != "" ? numIntFormat(numDotComma($("#mvStopPriceSC").val()) / 1000) : ""),
				mvStopType				  : $("#mvStopTypeSC").val(),
				mvBankPIN				  : "",
				mvRemark				  : ""
		};
		//console.log("ORDER CONFIRM WINDOW===>");
		//console.log(param);
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/enterOrder.do",
			data      : param,
			aync      : true,
			cache 	  : false,
			success   : function(data) {
				//console.log("ENTER ORDER CHECK");
				//console.log(data);
				$("#divSellConf").unblock();
				enterOpenPopupBuySell = false;
				if(data.jsonObj != null) {
					if(data.jsonObj.mainResult.success) {						
						if ("<%=langCd%>" == "en_US") {
							autoAlert("Your order was successful.", 2000);
						} else {
							autoAlert("Đặt lệnh thành công.", 2000);
						}						
						try {
							parent.clearData(1);			//	주문데이터 초기화
							sellCancel();
						} catch(e) {
							console.log(e);
							sellCancel();
						}
						
					} else {
						alert(data.jsonObj.errorMessage);
						sellCancel();
					}
				} else {
					if ("<%= langCd %>" == "en_US") {
						alert("There is a problem with your order processing. Please order again from the beginning.");	
					} else {
						alert("Có vấn đề với quá trình đặt lệnh của bạn. Vui lòng đặt lệnh lại từ đầu.");
					}

				}
			},
			error     :function(e) {
				$("#divSellConf").unblock();
				enterOpenPopupBuySell = false;
				//alert(e);
				console.log(e);
			}
		});
	}	

	function sellCancel() {
		$("#" + $("#divIdOrderPopSC").val()).fadeOut();
		enterOpenPopupBuySell = false;
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
</script>

</head>
<body>
	<form autocomplete="Off">
		<div id="divSellConf" class="modal_layer ${buySell}">
 			<input type="hidden" id="mvInstrumentSC" name="mvInstrument" value="${formData.mvInstrument}">
			<input type="hidden" id="mvMarketIdSC" name="mvMarketId" value="${formData.mvMarketId}">
			<input type="hidden" id="mvMarketIdListSC" name="mvMarketIdList" value="${formData.mvMarketIdList}">
			<input type="hidden" id="mvEnableGetStockInfoSC" name="mvEnableGetStockInfo" value="${formData.mvEnableGetStockInfo}">
			<input type="hidden" id="mvActionSC" name="mvAction" value="${formData.mvAction}">
			<input type="hidden" id="mvTemporaryFeeSC" name="mvTemporaryFee" value="${formData.mvTemporaryFee}">
			<input type="hidden" id="maxMarginSC" name="maxMargin" value="${formData.maxMargin}">
			<input type="hidden" id="lendingSC" name="lending" value="${formData.lending}">
			<input type="hidden" id="valueSC" name="value" value="${formData.value}">
			<input type="hidden" id="netFeeSC" name="netFee" value="${formData.netFee}">
			<input type="hidden" id="buySellSC" name="buySell" value="${formData.buySell}">
			<input type="hidden" id="buyingPowerSC" name="buyingPower" value="${formData.buyingPower}">
			<input type="hidden" id="stockSC" name="stock" value="${formData.stock}">
			<input type="hidden" id="mvBankIDSC" name="mvBankID" value="${formData.mvBankID}">
			<input type="hidden" id="mvBankACIDSC" name="mvBankACID" value="${formData.mvBankACID}">
			<input type="hidden" id="priceSC" name="price" value="${formData.price}">
			<input type="hidden" id="volumeSC" name="volume" value="${formData.volume}">
			<input type="hidden" id="orderTypeSC" name="orderType" value="${formData.orderType}">
			<input type="hidden" id="orderTypeNmSC" name="orderTypeNm" value="${formData.orderTypeNm}">
			<input type="hidden" id="expiryDtSC" name="expiryDt" value="${formData.expiryDate}">
			<input type="hidden" id="advancedDtSC" name="advancedDt" value="${formData.advancedDate}">
			<input type="hidden" id="refIdSC" name="refId" value="${formData.refId}">
			<input type="hidden" id="waitOrderSC" name="waitOrder" value="${formData.chkExpiry}">
			<input type="hidden" id="afterServerVerificationSC" name="afterServerVerification" value="Y"> <!-- Todo 항목확인 필요 -->
			<input type="hidden" id="mvStockNameSC" name="mvStockName" value="${formData.mvStockName}">
			<input type="hidden" id="divIdOrderPopSC" name="divIdOrderPop" value="${formData.divId}">
			<input type="hidden" id="serialnumberSC" name="serialnumber" value="">
			
			<input type="hidden" id="mvStopSC" name="mvStopSC" value="${formData.mvStop}">
			<input type="hidden" id="mvStopTypeSC" name="mvStopTypeSC" value="${formData.mvStopType}">
			<input type="hidden" id="mvStopPriceSC" name="mvStopPriceSC" value="${formData.mvStopPrice}">
			
 			<h2 id="popTitleSC"><%= (langCd.equals("en_US") ? "Confirm" : "Lệnh") %> : </h2>

			<div class="cont">	
				<table>
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Stock" : "Mã CK")%></th>
						<td>${formData.stock}</td>
					</tr>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Stock Name" : "Tên Công ty")%></th>
						<td>${formData.mvStockName}</td>
					</tr>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Price (VND)" : "Giá (VND)")%></th>
						<td>${formData.price}</td>
					</tr>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Order volume" : "Khối lượng")%></th>
						<td>${formData.volumeView}</td>
					</tr>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Order Type" : "Loại lệnh")%></th>
						<td>${formData.orderTypeNm}</td>
					</tr>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Value (VND)" : "Giá trị (VND)")%></th>
						<td>${formData.value}</td>
					</tr>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Net fee" : "Phí tạm tính")%></th>
						<td>${formData.netFee}</td>
					</tr>
					<tr>
						<th><%=(langCd.equals("en_US") ? "Effect To Date" : "Lệnh đến hạn")%></th>
						<td>${formData.expiryDate}</td>
					</tr>
				</table>
			</div>
			<div id="divAuth" class="layer_add" style="display: none;">
				<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %></h3>
				<div class="form_area">
					<ul class="security_check">
						<li><strong id="sellmvWordMatrixKey01"></strong><input type="password" id="sellwordMatrixValue01" name="sellwordMatrixValue01" value="" maxlength="1"></li>
						<li><strong id="sellmvWordMatrixKey02"></strong><input type="password" id="sellwordMatrixValue02" name="sellwordMatrixValue02" value="" maxlength="1"></li>
					</ul>
					<div>
						<input type="checkbox" id="sellsaveAuthenticate" name="sellsaveAuthenticate" checked="checked">
						<label for="saveA"><%= (langCd.equals("en_US") ? "Save Authentication?" : "Lưu xác thực?") %></label>
					</div>
				</div>
				<div style="padding: 20px;">
					<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
				</div>
			</div>
			<!-- OPT Confirm -->
			<div id="divOTPS" class="layer_add" style="display: none;">
				<h3 class="layer_add_title"><%=(langCd.equals("en_US") ? "Authentication" : "Xác thực")%></h3>
				<div class="form_area">
					<div>
						<label for="otp" style="padding-left: 0;"><%=(langCd.equals("en_US") ? "Enter OTP Code" : "Nhập mã OTP")%></label>
							<input style="margin-left:8px;" type="text" id="otpCode" name="otpCode">						
					</div>

					<div style="margin-top: 10px;">

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
				<button id="btnConfirmOrderSell" type="button" onclick="sellConfirm()" class="add"><%=(langCd.equals("en_US") ? "Confirm" : "Xác nhận")%></button>
				<button type="button" onclick="sellCancel()"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
			</div>
		</div>
	</form>
</body>
</html>