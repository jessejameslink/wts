<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<%
	String langCd 		=	(String) session.getAttribute("LanguageCookie");
%>
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
$(document).ready(function() {
	document.title = "MIRAE ASSET VN | <%= (langCd.equals("en_US") ? "Forgot Password" : "Quên mật khẩu") %>";
	$("#mvWordMatrixKey01").html(randomNumber() + "," + randomAlpha());
	$("#mvWordMatrixKey02").html(randomNumber() + "," + randomAlpha());			
	document.getElementById("wordMatrixValue01").addEventListener("keyup", forceKeyUpMatrix, false);
	document.getElementById("wordMatrixValue02").addEventListener("keyup", forceKeyUpMatrix, false);
	
	//$("#divAuth").hide();
	//$("#divAuthOTP").show();
	//$("#dvRegNumPhone").show();
	//$("#dvRegEmail").hide();
	
	$("#divAuthOTP").hide();
	$("#divAuth").show(); 
	$("#dvRegEmail").show();
	$("#dvRegNumPhone").hide();
	
	//remove
	//("#ba_sn").attr("disabled", true);
	
	$(".transfer_type input").on("change", function() {
		var tg = $(this).attr("data-tg");
		if (tg == "otp"){
			$("#divAuth").hide();
			$("#divAuthOTP").show();
			$("#dvRegNumPhone").show();
			$("#dvRegEmail").hide();
		}else{
			$("#divAuthOTP").hide();
			$("#divAuth").show(); 
			$("#dvRegEmail").show();
			$("#dvRegNumPhone").hide();
		}
			
		$(".tf_place").removeClass("on").filter("." + tg).addClass("on");
		
	});
});

function forceKeyUpMatrix(e)
{
  if(this.value.length==$(this).attr("maxlength")){
	  $("#wordMatrixValue02").focus();
	}
}

function randomNumber(){
    var alpha = new Array('1','2','3','4','5','6','7');	    
   	var num = alpha[Math.floor(Math.random() * alpha.length)];
   	return num;
}

function randomAlpha(){
    var alpha = new Array('A','B','C','D','E','F','G');	    
   	var alp = alpha[Math.floor(Math.random() * alpha.length)];
   	return alp;
}

function checkAccountInformation() {
	var err = "";
	if ($("#accNo").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input account ID\r\n";	
		} else {
			err += "Vui lòng nhập tài khoản\r\n";
		}
	}
	if ($("#regEmail").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input register email\r\n";	
		} else {
			err += "Vui lòng nhập email đăng ký\r\n";
		}
	}
	if ($("#wordMatrixValue01").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input Matrix value 1\r\n";	
		} else {
			err += "Vui lòng nhập mã xác thực 1\r\n";
		}
	}
	if ($("#wordMatrixValue02").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input Matrix value 2\r\n";	
		} else {
			err += "Vui lòng nhập mã xác thực 2\r\n";
		}
	}
	
	if (err != "") {
		alert(err);
		return;
	}
	
	var param = {
			mvClientId             	: $("#accNo").val().toUpperCase().trim(),
			mvEmail      			: $("#regEmail").val(),
			mvWordMatrixKey01       : $("#mvWordMatrixKey01").text(),
			mvWordMatrixValue01 	: $("#wordMatrixValue01").val(),
			mvWordMatrixKey02       : $("#mvWordMatrixKey02").text(),
			mvWordMatrixValue02     : $("#wordMatrixValue02").val(),
			mvService				: "eqt",
			mvSerialnumber			: "",
			mvSaveAuthenticate		: false,
			mvLanguage				: "<%= session.getAttribute("LanguageCookie") %>"
	};
	
	$.ajax({
		type	  : "GET",
		dataType  : "json",
		url       : "/trading/data/validateClientInfo.do",
		data      : param,
		aync      : true,
		success   : function(data) {				
			//console.log(data);
			if(data.jsonObj != null) {
				if(data.jsonObj.mvResult != "SUCCESS") {
					var msg = data.jsonObj.errorMessage;						
					alert(msg);
					
				} else if(data.jsonObj.mvResult == "SUCCESS") {
					$("#checkClient").css("display", "none");
					$("#submitChange").css("display", "block");
				}
			}
		},
		error     :function(e) {				
			console.log(e);
		}
	});
}


function checkAccountInformationOTP() {
	var err = "";
	if ($("#accNo").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input account ID\r\n";	
		} else {
			err += "Vui lòng nhập tài khoản\r\n";
		}
	}
	if ($("#regNumPhone").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input registered phone number\r\n";	
		} else {
			err += "Vui lòng nhập số điện thoại đã đăng ký\r\n";
		}
	}
	
	if (err != "") {
		alert(err);
		return;
	}
	
	var param = {
			mvClientId : $("#accNo").val().toUpperCase().trim(),
			mvNumPhone : $("#regNumPhone").val(),
			mvLanguage : "<%= session.getAttribute("LanguageCookie") %>"
	};
	
	$.ajax({
		type	  : "GET",
		dataType  : "json",
		url       : "/trading/data/validateClientInfoOTP.do",
		data      : param,
		aync      : true,
		success   : function(data) {				
			//console.log(data);
			if(data.jsonObj != null) {
				if(data.jsonObj.errorCode != "OLS0000") {
					var msg = data.jsonObj.errorMessage;					
					alert('<%= (langCd.equals("en_US") ? "Please check the information or Contact MAS for assistance" : "Vui lòng kiểm tra lại thông tin hoặc Liên hệ MAS hỗ trợ") %>');
				} else if(data.jsonObj.errorMessage == "SUCCESS") {
					$("#mvSecret").val(data.jsonObj.mainResult.secret);
					$("#textOTP").val('<%=(langCd.equals("en_US") ? "Re-Send SMS OTP" : "Gởi lại SMS OTP")%>');
					alert('<%= (langCd.equals("en_US") ? "SMS OTP sent successful" : "SMS OTP đã gởi thành công") %>');
					//$("#checkClient").css("display", "none");
					//$("#submitChangeOTP").css("display", "block");
				}
			}
		},
		error     :function(e) {	
			alert('<%= (langCd.equals("en_US") ? "Please check the information or Contact MAS for assistance" : "Vui lòng kiểm tra lại thông tin hoặc Liên hệ MAS hỗ trợ") %>');
			console.log(e);
		}
	});
}

function comfirmAccountInformationOTP() {
	var err = "";
	if ($("#accNo").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input account ID\r\n";	
		} else {
			err += "Vui lòng nhập tài khoản\r\n";
		}
	}
	if ($("#regNumPhone").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input registered phone number\r\n";	
		} else {
			err += "Vui lòng nhập số điện thoại đã đăng ký\r\n";
		}
	}
	
	if ($("#mvOtp").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input OTP number\r\n";	
		} else {
			err += "Vui lòng nhập số OTP\r\n";
		}
	}
	
	if ($("#mvSecret").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please check the information or Contact MAS for assistance\r\n";	
		} else {
			err += "Vui lòng kiểm tra lại thông tin hoặc Liên hệ MAS hỗ trợ\r\n";
		}
	}
	
	if (err != "") {
		alert(err);
		return;
	}else{
		$("#checkClient").css("display", "none");
		$("#submitChangeOTP").css("display", "block");
	}
}

function changePassword() {
	var err = "";
	
	if ($("#newPass").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input new password\r\n";	
		} else {
			err += "Vui lòng nhập mật khẩu mới\r\n";
		}
	}
	if ($("#confPass").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input confirm new password\r\n";	
		} else {
			err += "Vui lòng nhập xác nhận mật khẩu mới\r\n";
		}
	}	
	
	if (err != "") {
		alert(err);
		return;
	}
	
	if ($("#newPass").val() != $("#confPass").val()) {
		if ("<%= langCd %>" == "en_US") {
			alert("Password do not match");	
		} else {
			alert("Mật khẩu mới không khớp");
		}
		return;
	}
	var param = {
			mvClientId             	: $("#accNo").val().toUpperCase().trim(),
			mvEmail      			: $("#regEmail").val(),
			mvNewPassword       	: $("#newPass").val(),
			mvNewPasswordConfirm    : $("#confPass").val(),
			mvWordMatrixKey01       : $("#mvWordMatrixKey01").text(),
			mvWordMatrixValue01 	: $("#wordMatrixValue01").val(),
			mvWordMatrixKey02       : $("#mvWordMatrixKey02").text(),
			mvWordMatrixValue02     : $("#wordMatrixValue02").val(),
			mvService				: "eqt",
			mvSerialnumber			: "",
			mvSaveAuthenticate		: false,
			mvLanguage				: "<%= session.getAttribute("LanguageCookie") %>"
	};			
	//console.log("Input Reset Password");
	//console.log(param);
	$.ajax({
		type	  : "GET",
		dataType  : "json",
		url       : "/trading/data/resetPassword.do",
		data      : param,
		aync      : true,
		success   : function(data) {
			//console.log("reset password!");
			//console.log(data);
			//Save reset password history
			getClientIP(data.jsonObj.mvStatus);			
			//send email
			if(data.jsonObj != null) {
				if(data.jsonObj.mvStatus != "success") {					
					if ("<%= langCd %>" == "en_US") {
						alert("Reset password failed.");				
					} else {
						alert("Cập nhật mật khẩu thất bại.")
					}
				} else if(data.jsonObj.mvStatus == "success") {
					//sendInformEmail();
					if ("<%= langCd %>" == "en_US") {
						alert("Reset password successfully!")
					} else {
						alert("Đã cập nhật mật khẩu mới!")
					}
					location.href	=	"https://wts.masvn.com";
				}
			}
		},
		error     :function(e) {				
			console.log(e);
		}
	});
}

function changePasswordOTP() {
	var err = "";
	
	if ($("#newPassOTP").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input new password\r\n";	
		} else {
			err += "Vui lòng nhập mật khẩu mới\r\n";
		}
	}
	if ($("#confPassOTP").val() == "") {
		if ("<%= langCd %>" == "en_US") {
			err += "Please input confirm new password\r\n";	
		} else {
			err += "Vui lòng nhập xác nhận mật khẩu mới\r\n";
		}
	}	
	
	if (err != "") {
		alert(err);
		return;
	}
	
	if ($("#newPassOTP").val() != $("#confPassOTP").val()) {
		if ("<%= langCd %>" == "en_US") {
			alert("Password do not match");	
		} else {
			alert("Mật khẩu mới không khớp");
		}
		return;
	}
	var param = {
			mvClientId             	: $("#accNo").val().toUpperCase().trim(),
			//mvClientId             	: "C087360",
			mvNumPhone      		: $("#regNumPhone").val(),
			//mvNumPhone      		: "0837873388",
			mvNewPassword       	: $("#newPassOTP").val(),
			//mvNewPassword       	: "123456",
			mvNewPasswordConfirm    : $("#confPassOTP").val(),
			//mvNewPasswordConfirm    : "123456",
			mvOTP    				: $("#mvOtp").val(),
			mvSecret    			: $("#mvSecret").val(),
			mvLanguage				: "<%= session.getAttribute("LanguageCookie") %>"
	};			
	//console.log("Input Reset Password");
	//console.log(param);
	$.ajax({
		type	  : "GET",
		dataType  : "json",
		url       : "/trading/data/resetPasswordOTP.do",
		data      : param,
		aync      : true,
		success   : function(data) {
			//console.log("reset password!");
			//console.log(data);
			//Save reset password history
			getClientIP(data.jsonObj.mvStatus);			
			//send email
			if(data.jsonObj != null) {
				if(data.jsonObj.mvStatus != "success") {					
					if ("<%= langCd %>" == "en_US") {
						alert("Reset password failed.");				
					} else {
						alert("Cập nhật mật khẩu thất bại.")
					}
				} else if(data.jsonObj.mvStatus == "success") {
					//sendInformEmail();
					if ("<%= langCd %>" == "en_US") {
						alert("Reset password successfully!")
					} else {
						alert("Đã cập nhật mật khẩu mới!")
					}
					location.href	=	"https://wts.masvn.com";
				}
			}
		},
		error     :function(e) {				
			console.log(e);
		}
	});
}

function sendInformEmail() {
	var emailSubject = "Reset password for customer";
	var emailBody = "Dear Valued Customer,<br>We did reset your password, view more information bellow:<br>";
	
	emailBody = "Account ID: " + $("#accNo").val().toUpperCase() + "<br>";				
	emailBody = emailBody + "Register Email: " + $("#regEmail").val() + "<br>";		
	emailBody = emailBody + "New Password: " + $("#newPass").val() + "<br>";
	emailBody = emailBody + "Regards,<br>Mirae Asset Security";
	
	var param = {
			mvEmailSubject             	: emailSubject,
			mvEmailBody      			: emailBody,
			mvEmailTo       			: $("#regEmail").val()
	};		
	//console.log("Send Email Param");
	//console.log(param);
	$("body").block({message: "<span>LOADING...</span>"});
	$.ajax({
		type	  : "GET",
		dataType  : "json",
		url       : "/login/resetPassword.do",
		data      : param,
		aync      : true,
		success   : function(data) {				
			if(data.trResult != null) {
				if (data.trResult == "error") {
					if ("<%= langCd %>" == "en_US") {
						alert("Reset password successfully!")
					} else {
						alert("Đã cập nhật mật khẩu mới!")
					}
				} else if (data.trResult == "success") {
					if ("<%= langCd %>" == "en_US") {
						alert("Reset password successfully! We sent for you an inform email.")
					} else {
						alert("Đã cập nhật mật khẩu mới! Chúng tôi đã gởi cho bạn một email thông báo.")
					}
				}
			}
			clear();
			$("#checkClient").css("display", "block");
			$("#submitChange").css("display", "none");
			$("body").unblock();
			location.href	=	"https://wts.masvn.com";
		},
		error     :function(e) {				
			console.log(e);
			clear();
			$("body").unblock();
		}
	});	
}

function getClientIP(status) {
	$.ajax({
		dataType  : "json",
		url       : "/login/getClientIPAddress.do",
		success   : function(data) {
			//console.log("DATA RETURN === ");
			//console.log(data.trResult);
			$("#deviceID").val(data.trResult);
			saveResetPwdHistory(status);
		},
		error     :function(e) {				
			console.log(e);
		}
	});
}

function saveResetPwdHistory(stus) {	
	//Browser version	
	var userAgent = navigator.userAgent;
	var browser = "";
	var user = userAgent.toLowerCase();
	if (user.indexOf("msie") != -1)
    {
        var substring=userAgent.substring(userAgent.indexOf("MSIE")).split(";")[0];
        browser=substring.split(" ")[0].replace("MSIE", "IE")+"-"+substring.split(" ")[1];
    } else if (user.indexOf("edge") != -1)
    {
        browser=(userAgent.substring(userAgent.indexOf("Edge")).split(" ")[0]).replace("/", "-");
    } else if (user.indexOf("safari") != -1 && user.indexOf("version") != -1)
    {
        browser=(userAgent.substring(userAgent.indexOf("Safari")).split(" ")[0]).split("/")[0]+"-"+(userAgent.substring(userAgent.indexOf("Version")).split(" ")[0]).split("/")[1];
    } else if ( user.indexOf("opr") != -1 || user.indexOf("opera") != -1)
    {
        if(user.indexOf("opera") != -1)
            browser=(userAgent.substring(userAgent.indexOf("Opera")).split(" ")[0]).split("/")[0]+"-"+(userAgent.substring(userAgent.indexOf("Version")).split(" ")[0]).split("/")[1];
        else if(user.indexOf("opr") != -1)
            browser=((userAgent.substring(userAgent.indexOf("OPR")).split(" ")[0]).replace("/", "-")).replace("OPR", "Opera");
    } else if (user.indexOf("chrome") != -1)
    {
        browser=(userAgent.substring(userAgent.indexOf("Chrome")).split(" ")[0]).replace("/", "-");
    } else if ((user.indexOf("mozilla/7.0") > -1) || (user.indexOf("netscape6") != -1)  || (user.indexOf("mozilla/4.7") != -1) || (user.indexOf("mozilla/4.78") != -1) || (user.indexOf("mozilla/4.08") != -1) || (user.indexOf("mozilla/3") != -1) )
    {        
        browser = "Netscape-?";

    } else if (user.indexOf("firefox") != -1)
    {
        browser=(userAgent.substring(userAgent.indexOf("Firefox")).split(" ")[0]).replace("/", "-");
    } else if(user.indexOf("rv") != -1)
    {
        browser="IE-" + user.substring(user.indexOf("rv") + 3, user.indexOf(")"));
    } else
    {
        browser = "UnKnown, More-Info: "+userAgent;
    }
    
	var param = {
			acid				: "077" + $("#accNo").val().toUpperCase(),
			chan				: "WTS",
			stus               	: stus,
			dvid                : $("#deviceID").val(),			
			bver				: browser
	};
	//console.log("Save Reset Password History");
	//console.log(param);
	//return;
	$.ajax({
		dataType  : "json",
		url       : "/login/saveResetPwdHis.do",
		data      : param,
		aync      : true,
		success   : function(data) {
			//console.log("DATA RETURN === ");
			//console.log(data.trResult.rcod);
		},
		error     :function(e) {				
			console.log(e);
		}
	});
}

function clear() {
	$("#accNo").val("");
	$("#regEmail").val("");
	$("#newPass").val("");
	$("#confPass").val("");
	$("#newPassOTP").val("");
	$("#confPassOTP").val("");
	$("#mvWordMatrixKey01").text("");
	$("#mvWordMatrixKey02").text("");
	$("#wordMatrixValue01").val("");
	$("#wordMatrixValue02").val("");
}
</script>
<style>
.security_check_authen {width:100%; padding:18px 0 44px; margin:0 auto; background:#f3f3f3; border-radius:10px; overflow:hidden; text-align:center;}
.security_check_authen li {display:inline-block;}
.security_check_authen li strong {display:block; padding:0 0 5px; color:#666; font-size:12px; font-weight:600; text-align:left;}
.security_check_authen li strong:after {content:' ]'}
.security_check_authen li strong:before {content:'[ '}
.security_check_authen li input {width:100px; background:#fff; font-size:20px; letter-spacing:2px;}
.security_check_authen + div {position:absolute; bottom:15px; left:78px;}

.layer_authen {padding:0 40px; border-top:1px dashed #d0d0d0;}
.layer_authen:first-child {border-top:0;}
.layer_authen .layer_add_title {padding:10px 0 20px; background:none; color:#295f85; font-size:14px; text-transform:uppercase;}
.layer_authen:first-child .layer_add_title {padding-top:20px;}
.layer_authen .btn_wrap {padding:15px 0 0;}
.layer_authen .btn_wrap button {width:60px; height:23px; background:#ff7e00; color:#fff; line-height:23px; font-weight:100; border:0;}
</style>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<input type="hidden" id="deviceID" name="deviceID" value="">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title"><%= (langCd.equals("en_US") ? "RESET PASSWORD" : "ĐẶT LẠI MẬT KHẨU") %></h3>
            <div id="checkClient" class="form_container" style="width:500px;display:block;">
        		<div class="inputs c_pw" style="margin-top: 0px;">
            		<form> 
						<div class="transfer_type">
								<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authenication Type :" : "Loại Bảo Mật :") %></h3>
								<div style="float: right;">
									<input type="radio" id="ba_sn" name="type" data-tg="otp" style="float: left;"/>
									<label for="ba_sn" style="float: left;"><%= (langCd.equals("en_US") ? "SMS OTP" : "SMS OTP") %></label>
									<input type="radio" id="ba_re" name="type" data-tg="matrix" checked="checked"/>
									<label for="ba_re" style="float: initial;"><%= (langCd.equals("en_US") ? "MATRIX CARD" : "THẺ MATRIX") %></label>
								</div>
						</div>
        				<div>
        					<label for="acc" style="width:160px;"><%= (langCd.equals("en_US") ? "Account No." : "Số tài khoản") %><span style="color: red;">(*)</span></label>
        					<label style="width:35px;font-weight: bold;font-size:17px;">077</label>        					
                        	<input style="text-transform: uppercase;width:210px;" type="text" id="accNo" name="accNo" value=""/>
        				</div>
        				
        				<div id="dvRegEmail">
        					<label for="acc" style="width:195px;"><%= (langCd.equals("en_US") ? "Registered email" : "Email đã đăng ký") %><span style="color: red;">(*)</span></label>
                        	<input type="text" id="regEmail" name="regEmail" value=""/>
        				</div>
        				
        				<div id="dvRegNumPhone">
        					<label for="acc" style="width:195px;"><%= (langCd.equals("en_US") ? "Registered Phone number" : "Số điện thoại đã đăng ký") %><span style="color: red;">(*)</span></label>
                        	<input type="text" id="regNumPhone" name="regNumPhone" value=""/>
        				</div>
							
						<div id="divAuth" class="layer_add_title" style="border-top:0px;">
							<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication Matrix" : "Xác thực Matrix") %><span style="color: red;">(*)</span></h3>
							<div class="form_area">
								<ul class="security_check_authen">
									<li><strong id="mvWordMatrixKey01"></strong><input style="width: 100px;" type="password" id="wordMatrixValue01" name="wordMatrixValue01" value="" maxlength="1"></li>
									<li><strong id="mvWordMatrixKey02"></strong><input style="width: 100px;" type="password" id="wordMatrixValue02" name="wordMatrixValue02" value="" maxlength="1"></li>
								</ul>
							</div>
							<input type="button" value="<%=(langCd.equals("en_US") ? "CHECK INFORMATION" : "KIỂM TRA THÔNG TIN")%>" class="change" onclick="checkAccountInformation()"/>
						</div>						
						<div id="divAuthOTP" class="layer_add_title" style="border-top:0px;">
							<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication SMS OTP" : "Xác thực SMS OTP") %><span style="color: red;">(*)</span></h3>
							<div class="form_area">
								<ul class="security_check_authen">									
									<li><strong><%= (langCd.equals("en_US") ? "INPUT SMS OTP" : "NHẬP SMS OTP") %></strong><input style="width: 100px;" type="text" id="mvOtp" name="mvOtp" value="" maxlength="6"></li>
									<li><input type="button" id="textOTP" name="textOTP" value="<%=(langCd.equals("en_US") ? "Send SMS OTP" : "Gởi SMS OTP")%>" style="height: 30px;margin-top: 30px;font-size: 12px; min-width: 130px;" class="change" onclick="checkAccountInformationOTP()"/></li>
									<li><input style="width: 100px; display: none;" type="text" id="mvSecret" name="mvSecret" value="" maxlength="32"></li>
								</ul>																
							</div>
							<input type="button" value="<%=(langCd.equals("en_US") ? "CHECK INFORMATION" : "KIỂM TRA THÔNG TIN")%>" class="change" onclick="comfirmAccountInformationOTP()"/>
						</div>
						        				
            		</form>
        		</div>
            </div>
            <div id="submitChange" class="form_container" style="width:385px;display:none;">
        		<div class="inputs c_pw" style="margin-top: 0px;">
            		<form>
        				<div>
        					<label for="new_pw" style="width:175px;"><%= (langCd.equals("en_US") ? "New password" : "Mật khẩu mới") %><span style="color: red;">(*)</span></label>
        					<input type="password" id="newPass" name="newPass" value="" maxlength="16"/>
        				</div>
        				<div>
        					<label for="con_pw" style="width:175px;"><%= (langCd.equals("en_US") ? "Confirm password" : "Xác nhận mật khẩu mới") %><span style="color: red;">(*)</span></label>
        					<input type="password" id="confPass" name="confPass" value="" maxlength="16"/>
        				</div>						
        				<input type="button" value="<%=(langCd.equals("en_US") ? "CONFIRM" : "XÁC NHẬN")%>" class="change" onclick="changePassword()"/>
            		</form>
        		</div>
            </div>
            <div id="submitChangeOTP" class="form_container" style="width:385px;display:none;">
        		<div class="inputs c_pw" style="margin-top: 0px;">
            		<form>
        				<div>
        					<label for="new_pw" style="width:175px;"><%= (langCd.equals("en_US") ? "New password" : "Mật khẩu mới") %><span style="color: red;">(*)</span></label>
        					<input type="password" id="newPassOTP" name="newPassOTP" value="" maxlength="16"/>
        				</div>
        				<div>
        					<label for="con_pw" style="width:175px;"><%= (langCd.equals("en_US") ? "Confirm password" : "Xác nhận mật khẩu mới") %><span style="color: red;">(*)</span></label>
        					<input type="password" id="confPassOTP" name="confPassOTP" value="" maxlength="16"/>
        				</div>						
        				<input type="button" value="<%=(langCd.equals("en_US") ? "CONFIRM" : "XÁC NHẬN")%>" class="change" onclick="changePasswordOTP()"/>
            		</form>
        		</div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>