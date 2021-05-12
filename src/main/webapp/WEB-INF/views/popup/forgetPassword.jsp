<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");	
%>
<html>
<head>
<script>
	$(document).ready(function() {
		$("#fpmvWordMatrixKey01").html(randomNumber() + "," + randomAlpha());
		$("#fpmvWordMatrixKey02").html(randomNumber() + "," + randomAlpha());
		document.getElementById("fpwordMatrixValue01").addEventListener("keyup", forceKeyUpMatrix, false);
		document.getElementById("fpwordMatrixValue02").addEventListener("keyup", forceKeyUpMatrix, false);
	});
	
	function forceKeyUpMatrix(e)
	{
	  if(this.value.length==$(this).attr("maxlength")){
		  $("#fpwordMatrixValue02").focus();
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
	
	function changePassword() {
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
		
		if ($("#newPass").val() != $("#confPass").val()) {
			if ("<%= langCd %>" == "en_US") {
				alert("Password do not match");	
			} else {
				alert("Mật khẩu mới không khớp");
			}
			return;
		}
		
		var param = {
				mvClientId             	: $("#accNo").val().toUpperCase(),
				mvEmail      			: $("#regEmail").val(),
				mvNewPassword       	: $("#newPass").val(),
				mvNewPasswordConfirm    : $("#confPass").val(),
				mvWordMatrixKey01       : $("#fpmvWordMatrixKey01").text(),
				mvWordMatrixValue01 	: $("#fpwordMatrixValue01").val(),
				mvWordMatrixKey02       : $("#fpmvWordMatrixKey02").text(),
				mvWordMatrixValue02     : $("#fpwordMatrixValue02").val()
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
				//console.log(data);
				if(data.jsonObj != null) {
					if(data.jsonObj.mvStatus == "fail") {
						var msg = data.jsonObj.mvErrorMsg;						
						if ("<%= langCd %>" == "en_US") {
							if (msg.indexOf("is locked") > 0) {
								alert("Your Matrix Card is locked, because you did input wrong more than 5 times. Please directly contact with MAS to support quickly.");
								closePop();
							} else if (msg.indexOf("Email not found") >= 0) {
								alert("You did not register your email with us, so you can not use this function now. Please directly contact with MAS to support quickly.");
								closePop();
							} else {
								alert(msg);	
							}							
						} else {
							if (msg.indexOf("4 times") > 0) {
								alert("Bạn chỉ còn 4 lần xác thực");
							} else if (msg.indexOf("3 times") > 0) {
								alert("Bạn chỉ còn 3 lần xác thực");
							} else if (msg.indexOf("2 times") > 0) {
								alert("Bạn chỉ còn 2 lần xác thực");
							} else if (msg.indexOf("1 times") > 0) {
								alert("Bạn chỉ còn 1 lần xác thực");
							} else if (msg.indexOf("0 times") > 0) {
								alert("Bạn không còn lần xác thực");
							} else if (msg.indexOf("is not exist") > 0) {
								alert("Matrix Card không tồn tại");
							} else if (msg.indexOf("is locked") > 0) {
								alert("Matrix Card của bạn đã bị khóa, vì bạn đã xác thực sai quá 5 lần. Vui lòng liên hệ trực tiếp với MAS để được hỗ trợ nhanh chóng");
								closePop();
							} else if (msg.indexOf("Email is not matched") >= 0) {
								alert("Email không đúng với email đã đăng kí");
							} else if (msg.indexOf("Email not found") >= 0) {
								alert("Bạn đã không đăng kí email với chúng tôi, vì vậy bạn không thể sử dụng chức năng quên mật khẩu bây giờ. Vui lòng liên hệ trực tiếp với MAS để được hỗ trợ nhanh chóng");
								closePop();
							}
						}
						
					} else if(data.jsonObj.mvStatus == "success") {
						sendInformEmail();
						closePop();
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
			},
			error     :function(e) {				
				console.log(e);
			}
		});	
	}

	function closePop() {
		$("#" + $("#newsDivId").val()).fadeOut();
	}
</script>

</head>
<body>
	<input type="hidden" id="newsDivId" name="newsDivId" value="${newsDivId}">
	<div id="divNews" class="modal_layer fpwd">
		<h2><%= (langCd.equals("en_US") ? "Forgot Password?" : "Quên mật khẩu?") %></h2>
		<div>
			<label>
				<%= (langCd.equals("en_US") ? "Account No." : "Số tài khoản") %>
				<span style="color: red;">(*)</span>
			</label>			
		</div>
		<div>
			<input class="text won" type="text" id="accNo" name="accNo" style="text-transform: uppercase; text-align:left; width: 100% !important">
		</div>
		<div>
			<label><%= (langCd.equals("en_US") ? "Registered email" : "Email đã đăng ký") %><span style="color: red;">(*)</span></label>			
		</div>
		<div>
			<input class="text won" type="text" id="regEmail" name="regEmail" style="text-align:left; width: 100% !important">
		</div>
		<div>
			<label><%= (langCd.equals("en_US") ? "New password" : "Mật khẩu mới") %><span style="color: red;">(*)</span></label>			
		</div>
		<div>
			<input class="text won" type="password" id="newPass" name="newPass" style="text-align:left; width: 100% !important">
		</div>
		<div>
			<label><%= (langCd.equals("en_US") ? "Confirm password" : "Xác nhận mật khẩu mới") %><span style="color: red;">(*)</span></label>			
		</div>
		<div>
			<input class="text won" type="password" id="confPass" name="confPass" style="text-align:left; width: 100% !important">
		</div>
		
		<div id="divAuth" class="layer_add" style="border-top:0px;">
			<h3 class="layer_add_title"><%= (langCd.equals("en_US") ? "Authentication" : "Xác thực") %><span style="color: red;">(*)</span></h3>
			<div class="form_area">
				<ul class="security_check">
					<li><strong id="fpmvWordMatrixKey01"></strong><input type="password" id="fpwordMatrixValue01" name="fpwordMatrixValue01" value="" maxlength="1"></li>
					<li><strong id="fpmvWordMatrixKey02"></strong><input type="password" id="fpwordMatrixValue02" name="fpwordMatrixValue02" value="" maxlength="1"></li>
				</ul>
			</div>
		</div>
		<div style="width:60%;float:right;padding-top:10px;">
			<input type="button" class="color" value="<%=(langCd.equals("en_US") ? "CONFIRM" : "XÁC NHẬN")%>" onclick="changePassword()">
		</div>
		<button class="close" type="button" onclick="closePop()">close</button>		
	</div>
</body>
</html>