<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String chkval = request.getParameter("chkval");
	String annoucementId	=	request.getParameter("annoucementId");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<head>

<script>
	var bankData = null;
	var inSeq = "-1";
	$(document).ready(function() {
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		if ("<%= authenMethod %>" != "matrix") {
			oCheckOTP();
		} else {
			authConfirmOddLot();
		}
		//authConfirmOddLot();
		getQueryBank();
		
		/*document.getElementsByTagName('select')[0].onchange = function() {
		  var index = this.selectedIndex;
		  if (index == 0) {
			  inSeq = "-1";
		  } else {
			  inSeq = bankData[index - 1].mvInterfaceSeq;
		  }
		}*/
		document.getElementById("odwordMatrixValue01").addEventListener("keyup", forceKeyUpMatrix, false);
		document.getElementById("odwordMatrixValue02").addEventListener("keyup", forceKeyUpMatrix, false);
	});
	
	function forceKeyUpMatrix(e)
	{
	  if(this.value.length==$(this).attr("maxlength")){
		  $("#odwordMatrixValue02").focus();
		}
	}
	
	function oCheckOTP() {
		var chkval	=	"<%=chkval%>";
		var inHtml	=	"";

		chkval	=	chkval.split(",");

		var setParam	=	"";
		for(var i = 0; i < chkval.length; i++) {
			var data	=	chkval[i];

			data	=	data.split("|");

			inHtml	+=	"<tr>";
			for(var j = 0; j < data.length; j++) {
				if(j != 0) {
					inHtml	+=	"<td>" + data[j] + "</td>";
				}
			}			
			inHtml	+=	"</tr>";
		}
		$("#oddList").html(inHtml);
		
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
					$("#divOTPO").css("display", "block");
				} else {
					$("#divOTPO").css("display", "none");
				}
			}
		});	
	}
	function changeBankAccount() {
		var index = $("#bankOpt option:selected").index();		
		if (index == 0) {
		  inSeq = "-1";
		} else {
		  inSeq = index;
		}
	}

	function authConfirmOddLot(confirm){	
		var chkval	=	"<%=chkval%>";
		var inHtml	=	"";

		chkval	=	chkval.split(",");

		var setParam	=	"";
		for(var i = 0; i < chkval.length; i++) {
			var data	=	chkval[i];

			data	=	data.split("|");

			inHtml	+=	"<tr>";
			for(var j = 0; j < data.length; j++) {
				if(j != 0) {
					inHtml	+=	"<td>" + data[j] + "</td>";
				}
			}			
			inHtml	+=	"</tr>";
		}			
		$("#oddList").html(inHtml);
		
		$("#divAuthLayer").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID		 : 	"<%= session.getAttribute("subAccountID") %>",
				wordMatrixKey01      : $("#odmvWordMatrixKey01").text(),
				wordMatrixKey02      : $("#odmvWordMatrixKey02").text(),
				wordMatrixValue01    : $("#odwordMatrixValue01").val(),
				wordMatrixValue02    : $("#odwordMatrixValue02").val(),
				serialnumber         : $("#serialnumber").val(),
				mvSaveAuthenticate   : $("#odsaveAuthenticate").is(':checked')
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/authCardMatrix.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				//console.log("AUTH CHECK");
				//console.log(data);
				$("#divAuthLayer").unblock();
				if(data != null) {
					if(data.jsonObj.mvSuccess == "FAIL") {
						var authCard = data.jsonObj.mvClientCardBean;
						$("#odmvWordMatrixKey01").html(authCard.mvWordMatrixKey01);
						$("#odmvWordMatrixKey02").html(authCard.mvWordMatrixKey02);
						$("#serialnumber").val(authCard.serialnumber);
						$("#divAuth").css("display","block");
						if(data.jsonObj.mvClientCardBean.mvErrorCode != "CARD006"){ // not New Card
							alert(data.jsonObj.mvMessage);
							$("#odwordMatrixValue01").val("");
							$("#odwordMatrixValue02").val("");
						}
						if(data.jsonObj.mvClientCardBean.mvErrorCode == "SERVER_ERROR"){
							$("#divAuth").css("display","none");
							$("#btnAuthConfirm").css("display","none");
						}
					} else if(data.jsonObj.mvSuccess == "SUCCESS") {						
						 if(confirm == 'SAVE') {
							 oddOrder();
						 }
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divAuthLayer").unblock();
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

	function getQueryBank() {
		//Query bank info
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		}
		$.ajax({
			dataType  : "json",
			url       : "/online/data/queryBankInfo.do",
			data      : param,
			aync      : true,
			cache	  : false,
			success   : function(data) {
				//console.log("CHECK QUERY BANK DATA#############");
				//console.log(data);
				if (data.jsonObj.mvBankInfoList.length > 0) {
					for(var i=0; i < data.jsonObj.mvBankInfoList.length; i++) {
						if (data.jsonObj.mvBankInfoList[i].mvIsDefault == true) {
							inSeq = data.jsonObj.mvBankInfoList[i].mvInterfaceSeq;
							$("#bankOpt").append("<option value='" + JSON.stringify(data.jsonObj.mvBankInfoList[i]) + "'>"+ data.jsonObj.mvBankInfoList[i].mvSettlementAccountDisplayName + "</option>");
							$("#bankOpt").val($("#bankOpt option:eq(1)").val());
						}
						else{
							$("#bankOpt").val($("#bankOpt option:eq(0)").val());
						}
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function orderConfirm() {
		if ("<%= authenMethod %>" == "matrix") {
			if($("#divAuth").css("display") == "none") {
				oddOrder();
			} else {			
				authConfirmOddLot("SAVE");
			}
		} else {
			if($("#divOTPO").css("display") == "none") {
				oddOrder();
			} else {
				verifyOOTPCode();
			}
		}
	}
	
	function verifyOOTPCode() {
		if ($("#otpCode").val().length != 6) {
			if ("<%= langCd %>" == "en_US") {
				alert("Occurs when the entered OTP number is not a six-digit number.");
			} else {
				alert("Lỗi xảy ra khi nhập OTP không là 6 chữ số.")
			}
			$("#otpCode").focus();
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
						oddOrder();
						if ($("#saveOTP").is(':checked')) {
							saveOOTP();
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
	
	function saveOOTP() {
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
	
	function oddOrder() {
		var param	=	{};
		
		var oddList		=	$("#oddOrderParam").val();		
		oddList			=	oddList.split(",");				
		mvOddList	=	$("#oddOrderParam").val();
		
		param.mvOddList			=	mvOddList;
		param.annoucementId		=	$("#annoucementId").val();
		param.mvInterfaceSeq	=	inSeq;
		param.mvSubAccountID		= 	"<%= session.getAttribute("subAccountID") %>";
		//console.log("Param submit odd lot");
		//console.log(param);
		$.ajax({
			dataType  : "json",
			url       : "/online/data/submitOddLot.do",
			data      : param,
			aync      : true,
			cache	  : false,
			success   : function(data) {
				//console.log("===submitOddLot===");
				//console.log(data);
				if(data != null && (data.jsonObj.mvResult == "SUCCESS")) {
					alert(data.jsonObj.errorMessage);
					parent.enquiryOddLot();
					parent.oddLotHistoryEnquiry();
					cancel();
					return;
				}else{
					alert(data.jsonObj.errorMessage);
					cancel();
					return;
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
		
		
		
		
		
	}
	
</script>

</head>
<body>
	<input id="annoucementId" name="annoucementId" type="hidden" value="<%=annoucementId%>"/>
	<input id="oddOrderParam" name="oddOrderParam" type="hidden" value="<%=chkval%>"/>
	<!-- Buy : Authentication -->
	<div id="divOddConfLayer" class="modal_layer auth" style="top:10%; left:35%;">
		<div class="layer_add">
			<h2 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %></h2>
			
			
			<div class="form_area">
				<div>
					<span style="text-align:left;"><B>Bank Account</B></span>
					
					<span style="text-align:right;padding-left:30px;">
						<select id="bankOpt" onchange="changeBankAccount();">
							<option value="-1">MAS</option>
						</select>
					</span>
				</div>
				
				<div style="margin-top:20px;">
					<table>
						<!-- <caption></caption> -->
	                    <colgroup>
	                        <col width="20%" />
	                        <col width="40%" />
	                        <col width="*" />
	                    </colgroup>
						<thead>
							<tr>
								<th scope="col">Stock</th>
                            	<th scope="col">Type</th>
                            	<th scope="col">Volume</th>
							</tr>
						</thead>
						<tbody id="oddList">
						</tbody>
					</table>
				</div>
			</div>
			
			<div class="form_area">
				<div id="divAuth" class="layer_add" style="display: none;">
					<ul class="security_check">
						<li><strong id="odmvWordMatrixKey01"></strong><input type="password" id="odwordMatrixValue01" name="odwordMatrixValue01" value="" maxlength="1"  /></li>
						<li><strong id="odmvWordMatrixKey02"></strong><input type="password" id="odwordMatrixValue02" name="odwordMatrixValue02" value="" maxlength="1"  /></li>
					</ul>
					<div>
						<input type="checkbox" id="odsaveAuthenticate" name="odsaveAuthenticate" checked="checked">
						<label for="saveA"><%= (langCd.equals("en_US") ? "Save Authentication?" : "Lưu xác thực?") %></label>
					</div>
					<div style="padding: 20px;">
						<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
					</div>
				</div>
				<div id="divAuthMsg" style="display:none;">
					<strong><%=(langCd.equals("en_US") ? "Do you want to do this action ?" : "Bạn có muốn thực hiện chức năng này không?")%></strong>
				</div>
			</div>
			<!-- OPT Confirm -->					
			<div class="form_area">
				<div id="divOTPO" class="layer_add" style="display: none;">
					<div>
						<label for="otp" style="padding-left:0;"><%= (langCd.equals("en_US") ? "Enter OTP Code" : "Nhập mã OTP") %></label>
						<input style="margin-left:8px;" type="text" id="otpCode" name="otpCode">						
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
					<div style="padding: 20px;">
						<span style="color:blue !important;"><%= (langCd.equals("en_US") ? "*Warning: Saving authentication maybe potentially risk to your account if you lose your phone or password." : "*Cảnh báo: Việc lưu xác thực có thể dẫn đến rủi ro cho tài khoản giao dịch nếu bạn bị mất thiết bị hoặc mật khẩu.") %></span>
					</div>
				</div>				
			</div>
			<!-- End OTP Confirm -->
			
			<div class="btn_wrap">
				<button id="btnAuthConfirm" class="add" type="button" onclick="orderConfirm();"><%= (langCd.equals("en_US") ? "OK" : "OK") %></button>
				<button type="button" onclick="cancel();"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
			</div>
		</div>
	</div>
	<!-- //Buy : Authentication -->
</body>

</html>
