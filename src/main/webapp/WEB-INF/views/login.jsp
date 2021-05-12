<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");
	response.setHeader("P3P", "CP='CAO PSA CONi OTR OUR DEM ONL'");
%>

<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	//String popup = (String) session.getAttribute("defaultSubAccount");
	if (langCd == null) {
		langCd = "vi_VN";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">

<script type="text/javascript" src="/resources/js/jquery.min.js" /></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js" /></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/css/common.css" />
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<title>MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "LOGIN" : "ĐĂNG NHẬP") %></title>


<script>
var rtUrl	=	"/";
$(document).ready(function() {
	$( "div[name=tabs]" ).tabs();
	$("#divForgetPasswordPop").hide();
	Captcha();
	
	$('#mvPassword').keypress(function(e){
	    if(e.keyCode  == 13){
	        // 실행시킬 함수 입력
	        $("#loginOn").click();
	    }
	});
	
	$('#securitycode').keypress(function(e){
	    if(e.keyCode  == 13){
	        // 실행시킬 함수 입력
	        $("#loginOn").click();
	    }
	});
	
	
	//setCookieResign('ppkcookie','testcookie',5);

	//var x = getCookieResign('ppkcookie');
	//if (x) {
	    //alert('cookie');
	//}
	
	function setCookieResign(name,value,days) {
	    var expires = "";
	    if (days) {
	        var date = new Date();
	        //date.setTime(date.getTime() + (days*24*60*60*1000));
	        date.setTime(date.getTime() + (days*1000));
	        expires = "; expires=" + date.toUTCString();
	    }
	    document.cookie = name + "=" + (value || "")  + expires + "; path=/";
	}
	function getCookieResign(name) {
	    var nameEQ = name + "=";
	    var ca = document.cookie.split(';');
	    for(var i=0;i < ca.length;i++) {
	        var c = ca[i];
	        while (c.charAt(0)==' ') c = c.substring(1,c.length);
	        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	    }
	    return null;
	}
	function eraseCookie(name) {   
	    document.cookie = name+'=; Max-Age=-99999999;';  
	}
	
	
	
	$("#loginOn").click(function(){
		
		<%-- if (<%= showV6 %>" != 1 && cookiesss != 1){
			showPopupVersion6();	
		}
		else if(<%= showV6 %>" != 2){
			upgradeVersion6();
		} --%>
		//upgradeVersion6();
		//return;
		if($("#securitycode").val() == "") {
			if ("<%=langCd%>" == "en_US") {
				alert("Please input security code");	
			} else {
				alert("Vui lòng nhập mã bảo mật");
			}
			$("#securitycode").focus();
			return;
		}
		
		if (!ValidCaptcha()) {
			if ("<%=langCd%>" == "en_US") {
				alert("Let's input right character same the picture.");	
			} else {
				alert("Hãy nhập chính xác các ký tự trong hình.");
			}
			$("#securitycode").focus();
			return;
		}
		
		$(".login_wrap").block({message: "<span>LOADING...</span>"});
		var param = {
				mvClientID		:$("#mvClientID").val().toUpperCase().substring(3),
				mvPassword		:$("#mvPassword").val(),
				securitycode	:$("#securitycode").val()
		};
		
		$.ajax({
			url:'/login/login.do',
			data:param,
			cache: false,
		    dataType: 'json',
		    type: 'POST',
		    success: function(data){
		    	//console.log("LOGIN DATA");
		    	//console.log(data);
		    	
			 	if(data.jsonObj.success.toString() == "true"){			 		
			 		if(data.jsonObj.mainResult.login.needChangePassword == true) {
			 			if ("<%=langCd%>" == "en_US") {
							alert("Change Password Need");	
						} else {
							alert("Cần thay đổi mật khẩu");
						}
			 			location.href	=	"/home/account/changePw.do";
			 			return;
			 		}
			 		
			 		rtUrl	=	"${old_url}";			 		
			 		
			 		if(rtUrl.indexOf("wts") > 0) {
			 		} else if(rtUrl.indexOf("account") > 0) {
			 		} else if(rtUrl.indexOf("logout") > 0) {
			 			rtUrl	=	"/";
			 		} else {
			 			rtUrl	=	"/";
			 		}
			 		changeLan(('<%=session.getAttribute("LanguageCookie")%>' != "null"? '<%=session.getAttribute("LanguageCookie")%>' : "vi_VN"));
			 		setCookieResign('loginSuccess','popupone',1);
			 	} else {
			 		$(".login_wrap").unblock();
			 		alert(data.jsonObj.errorMessage);
			 		setCookieResign('loginSuccess','popuptwo',1);
			 	}
		    },
		    error : function(data) {
		    	//console.log(data);
		    	$(".login_wrap").unblock();
		    	if ("<%=langCd%>" == "en_US") {
		    		alert("System error has occurred.please call adminstrator.");	
		    	} else {
		    		alert("Lỗi hệ thống đã xảy ra. Vui lòng gọi cho quản trị viên.");
		    	}
		    	setCookieResign('loginSuccess','popuptwo',1);
		    	return;
		    }
		});
	});
	
	<%-- if (<%= showV6 %>" != 1 && cookiesss != 1){
		showPopupVersion6();	
	}
	else if(<%= showV6 %>" != 2){
		upgradeVersion6();
	}
	 --%>
	//test
	//upgradeVersion6();
	//showPopupVersion6();
	//end test
	setInterval(Captcha, 600000);
});

	
	function upgradeVersion6(){
		var mess = "";
		var mess1 = "";
		if ("<%= langCd %>" == "en_US") {
			mess1 = 'Click on outsite pop up to continue!';
			mess = '<img src="https://www.masvn.com/docs/image/upgradesystem_en.png" width="150%" height="100%" style="margin-top: 100px;">';
		} else {
			mess1 = 'Click ngoài thông báo để tiếp tục!';
			mess = '<img src="https://www.masvn.com/docs/image/upgradesystem.png" width="150%" height="100%" style="margin-top: 100px;">';
		}
		$.blockUI({ 
	           message: $('#displayBox'), 
	           css: { 
	                //width: 7707 + "px",
	                //height: 7706 + "px",
	                top: '2%',
	                left: '30%',
	                //margin: (-7706 / 10) + 'px 0 0 '+ (-7707/10) + 'px'
	    	     },
				//message: '<img src="https://www.masvn.com/docs/image/1week.png" width="150%" height="100%" style="margin-top: 100px;">',
				message: mess,
	    		timeout:   5000 
		}); 
		$('.blockOverlay').attr('title', mess1 ).click($.unblockUI);
		//document.getElementById("loginOn").disabled=true;
		return;
	}

	function showPopupVersion6() {
		var mess = "";
		var mess1 = "";
		if ("<%= langCd %>" == "en_US") {
			mess1 = 'Click on outsite pop up to continue!';
			mess = '<img src="https://www.masvn.com/docs/image/1week_en.png" width="150%" height="100%" style="margin-top: 100px;">';
		} else {
			mess1 = 'Click ngoài thông báo để tiếp tục!';
			mess = '<img src="https://www.masvn.com/docs/image/1week.png" width="150%" height="100%" style="margin-top: 100px;">';
		}
		$.blockUI({ 
			message: $('#displayBox'), 
	           css: { 
	                //width: 7707 + "px",
	                //height: 7706 + "px",
	                top: '2%',
	                left: '30%',
	                //margin: (-7706 / 10) + 'px 0 0 '+ (-7707/10) + 'px'
	    	     },
				//message: '<img src="https://www.masvn.com/docs/image/1week.png" width="150%" height="100%" style="margin-top: 100px;">',
				message: mess,
	    		timeout:   5000  
		}); 
		$('.blockOverlay').attr('title', mess1 ).click($.unblockUI);
	}
	
	function Captcha() {
		var alpha = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
		var i;
		for (i = 0; i < 6; i++) {
			var a = alpha[Math.floor(Math.random() * alpha.length)];
			var b = alpha[Math.floor(Math.random() * alpha.length)];
			var c = alpha[Math.floor(Math.random() * alpha.length)];
			var d = alpha[Math.floor(Math.random() * alpha.length)];
		}
		var code = a + ' ' + b + ' ' + ' ' + c + ' ' + d;
		document.getElementById("mainCaptcha").innerHTML = code
		document.getElementById("mainCaptcha").value = code
	}
	function ValidCaptcha() {
		var string1 = removeSpaces(document.getElementById('mainCaptcha').value);
		var string2 = $("#securitycode").val();
		if (string1 == string2) {
			return true;
		} else {
			return false;
		}
	}
	function removeSpaces(string) {
		return string.split(' ').join('');
	}

	function sercureRefresh() {
		//console.log("CHK LOG");
		$.ajax({
			dataType : "json",
			url : "/data/gettime.do",
			data : "",
			success : function(data) {
				if (data != null) {
				$("#sec_code").attr("src","${ttl}randomImage.jpg?_dc="+  data.rtdate);
				}
			},
			error : function(e) {
				console.log(e);
			}
		});
	}

	function changeLan(str) {
		setCookie("LanguageCookie", str, 30);
		var param = {
		mvCurrentLanguage	:	str
		, request_locale	:	str
		};

		$.ajax({
			dataType : "json",
			url : "/home/changelanguage.do",
			data : param,
			success : function(data) {
				if (rtUrl == "/") {
					location.reload();
				} else {
					location.href = rtUrl;
				}
				if (data != null) {

				}
			},
			error : function(e) {
				console.log(e);
			}
		});
	}

	function authCardMetrix() {
		var param = {

		};

		$.ajax({
			url : "/trading/data/authCardMatrix.do",
			data : param,
			dataType : 'json',
			success : function(data) {
				if (data.jsonObj.success.toString() == "true") {
					//보안카드 선택시 다음로직
					if ($('input[name=loginChk]:checked').val() == "1") {
						location.href = "/wts/init";
					} else {

					}
				} else {
					login = "";
					alert(data.jsonObj.mvMessage.toString());
				}
			}
		});
	}

	function openForgetPassword() {
		var param = {
			divId : "divForgetPasswordPop"
		};

		$.ajax({
			type : 'POST',
			url : '/login/popup/forgetPassword.do',
			data : param,
			dataType : 'html',
			success : function(data) {
				$("#divForgetPasswordPop").fadeIn();
				$("#divForgetPasswordPop").html(data);
			},
			error : function(e) {
				console.log(e);
			}
		});
	}
	//http://jhgan.tistory.com/43
	function setCookie(cname, cvalue, exdays) {
		var d = new Date();
		d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
		var expires = "expires=" + d.toGMTString();
		document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	}
</script>
<style type="text/css">
#mainCaptcha {
	background-color: grey;
	position: absolute;
	right: 0px;
	top: -18px;
}
</style>
</head>
<body class="login">
	<input type="hidden" value="${old_url}" />
	
	<div class="login_wrap">
  		<h1><img src="/resources/images/logo.png" alt="MIRAE ASSET WTS"></h1>
		<h2><%=(langCd.equals("en_US") ? "FUNDAMENTAL TRADING" : "GIAO DỊCH CƠ SỞ")%></h2>
		<span class="language">
			<button type="button" onclick="changeLan('en_US'); "><img src="/resources/images/icon_lang_en.gif" alt="English"></button>
			<button type="button" onclick="changeLan('vi_VN'); "><img src="/resources/images/icon_lang_vi.gif" alt="vietnamese"></button>
		</span>

		<div class="input_area">
			<label for="mvClientID"><%=(langCd.equals("en_US") ? "Account" : "Số Tài khoản")%></label>
			<input style="text-transform: uppercase;" id="mvClientID" type="text" value="<%= (langCd.equals("en_US") ? "077F" : "077C") %>" maxlength="13">
			<label for="mvPassword"><%= (langCd.equals("en_US") ? "Password" : "Mật khẩu") %></label>
			<input id="mvPassword" type="password" value="">
			<!-- <p>Login using any of the following services.</p> -->
		</div>

		<div class="security_code">
			<h3><%=(langCd.equals("en_US") ? "Security Code" : "Mã an toàn")%></h3>
			<div>
				<input id="securitycode" type="text" value="">
				<h2 type="text" id="mainCaptcha"></h2>
			</div>
		</div>
		<!-- Wait TTL API  -->
		<div style="padding-top: 10px; padding-bottom: 10px;">
			<a href="/home/account/resetpassword.do" target="_blank" style="color:#30618e;text-decoration: underline;font-weight: bold;"><%= (langCd.equals("en_US") ? "Forgot password?" : "Quên mật khẩu?") %></a>
		</div>


		<div style="padding-top: 10px; padding-bottom: 10px;">
				<%= (langCd.equals("en_US") ? "Don't have an account? " : "Chưa có tài khoản? ") %><a href="/home/subpage/openAccount.do" target="_blank" style="color:#30618e;text-decoration: underline;font-weight: bold;"><%= (langCd.equals("en_US") ? "Open an account free" : "Mở tài khoản miễn phí") %></a>			
		</div>

		<!--- DO NOT EDIT - GlobalSign SSL Site Seal Code - DO NOT EDIT --->
		<div class="loginLabel" id="ext-gen1030" style="top: -8px;">
		 <span id="ss_img_wrapper_gmogs_image_125-50_en_dblue">
		 <a href="https://www.globalsign.com/" target=_blank title="GlobalSign Site Seal" rel="nofollow">
		 <img alt="SSL" border=0 id="ss_img" src="//seal.globalsign.com/SiteSeal/images/gs_noscript_125-50_en.gif"></a>
			</span>
		 <script type="text/javascript" src="//seal.globalsign.com/SiteSeal/gmogs_image_125-50_en_dblue.js">
				
			</script>
		</div>
		<!--- DO NOT EDIT - GlobalSign SSL Site Seal Code - DO NOT EDIT --->

		<div style="border-bottom:1px solid;" class="btn_login"><button type="button" id="loginOn"><%= (langCd.equals("en_US") ? "Login" : "Đăng nhập") %></button></div>

		<div style="padding-top: 10px;">
			<table>
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tbody>
					<tr>
						<td style="border-bottom:0px;text-align:center;color:#30618e;font-weight: bold;">
							<a href="/home/support/web.do" target="_blank"><%= (langCd.equals("en_US") ? "USER GUIDE" : "Hướng dẫn") %></a>
						</td>
						<td style="border-bottom:0px;text-align:center;color:#30618e;font-weight: bold;">
							<a href="/home/support/account.do" target="_blank"><%= (langCd.equals("en_US") ? "SUPPORT" : "Hỗ trợ") %></a>
						</td>
						<td style="border-bottom:0px;text-align:center;color:#30618e;font-weight: bold;">
							<a href="/home/subpage/private.do" target="_blank"><%= (langCd.equals("en_US") ? "PRIVACY POLICY" : "Bảo mật") %></a>
						</td>
						<td style="border:0px;text-align:center;color:#30618e;font-weight: bold;">
							<a href="/home/subpage/terms.do" target="_blank"><%= (langCd.equals("en_US") ? "TERMS OF USE" : "Đ.khoản sử dụng") %></a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div>
			<table>
				<colgroup>
					<col width="100%" />
				</colgroup>
				<tbody>
					<tr>
						<strong><%= (langCd.equals("en_US") ? "HEADQUARTER" : "TRỤ SỞ CHÍNH") %></strong>
						<p><%= (langCd.equals("en_US") ? "7th Floor, Le Meridien building, 3C Ton Duc Thang Street," : "Tòa nhà Le Meridien, Tầng 7, 3C Tôn Đức Thắng, Phường Bến Nghé, <br/>Quận 1, Tp. Hồ Chí Minh<br/>") %>
						<%= (langCd.equals("en_US") ? "Ben Nghe Ward, <br/>District 1, Ho Chi Minh City<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-28-39102222 Fax  84-28-39107222" : "ĐT: 84-28-39102222 Fax: 84-28-39107222") %></p>					
					</tr>
					<tr>
						<strong><%= (langCd.equals("en_US") ? "HO CHI MINH BRANCH" : "CHI NHÁNH HỒ CHÍ MINH") %></strong>
						<p><%= (langCd.equals("en_US") ? "7th Floor, Sai Gon Royal building, 91 Pasteur Street," : "Tòa nhà Sài Gòn Royal, Tầng 7, 91 Pasteur, Phường Bến Nghé, <br/>Quận 1, Tp. Hồ Chí Minh<br/>") %>
						<%= (langCd.equals("en_US") ? "Ben Nghe Ward, <br/>District 1, Ho Chi Minh City<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-28-39102222 Fax  84-28-39107222" : "ĐT: 84-28-39102222 Fax: 84-28-39107222") %></p>
					</tr>
					<tr>
						<strong><%= (langCd.equals("en_US") ? "SAI GON BRANCH" : "CHI NHÁNH SÀI GÒN") %></strong>
						<p><%= (langCd.equals("en_US") ? "16th Floor, Green Power building, 35 Ton Duc Thang Street," : "Tòa nhà Green Power, Tầng 16, 35 Tôn Đức Thắng, Phường Bến Nghé, <br/>Quận 1, Tp. Hồ Chí Minh<br/>") %>
						<%= (langCd.equals("en_US") ? "Ben Nghe Ward, <br/>District 1, Ho Chi Minh City<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-28-39102222 Fax  84-28-39107222" : "ĐT: 84-28-39102222 Fax: 84-28-39107222") %></p>
					</tr>					
					<tr>
						<strong><%= (langCd.equals("en_US") ? "HA NOI BRANCH" : "CHI NHÁNH HÀ NỘI") %></strong>
						<p><%= (langCd.equals("en_US") ? "3rd Floor, HCO building, 44B Ly Thuong Kiet Street,  " : "Tòa nhà HCO, Tầng 3, 44B Lý Thường Kiệt, Quận Hoàn Kiếm, Hà Nội<br/>") %>
						<%= (langCd.equals("en_US") ? "Hoan Kiem District, Ha Noi<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-24-73093968 Fax  84-24-39387198" : "ĐT: 84-24-73093968 Fax: 84-24-39387198") %></p>
					</tr>
					<tr>
						<strong><%= (langCd.equals("en_US") ? "THANG LONG BRANCH" : "CHI NHÁNH THĂNG LONG") %></strong>
						<p><%= (langCd.equals("en_US") ? "14th Floor, Gelex building, 52 Le Dai Hanh, Le Dai Hanh Ward, " : "Tòa nhà Gelex, Tầng 14, 52 Lê Đại Hành, Phường Lê Đại Hành, Quận Hai Bà Trưng, Hà Nội<br/>") %>
						<%= (langCd.equals("en_US") ? "Hai Ba Trung District, Ha Noi City<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-24-73083968 Fax  84-24-32151002" : "ĐT: 84-24-73083968 Fax: 84-24-32151002") %></p>
					</tr>										
					<tr>
						<strong><%= (langCd.equals("en_US") ? "VUNG TAU BRANCH" : "CHI NHÁNH VŨNG TÀU") %></strong>
						<p><%= (langCd.equals("en_US") ? "5th Floor, Giao Chau building, 102A Le Hong Phong, Ward 4,  " : "Tòa nhà Giao Châu, Tầng 5, 102A Lê Hồng Phong, Phường 4, Tp. Vũng Tàu, Tỉnh Bà Rịa - Vũng Tàu<br/>") %>
						<%= (langCd.equals("en_US") ? "Vung Tau City, Ba Ria - Vung Tau Province<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-254-7303968 Fax  84-254-7303968" : "ĐT: 84-254-7303968 Fax: 84-254-7303968") %></p>
					</tr>					
					<tr>
						<strong><%= (langCd.equals("en_US") ? "DA NANG BRANCH" : "CHI NHÁNH ĐÀ NẴNG") %></strong>
						<p><%= (langCd.equals("en_US") ? "Ground Floor, Vinh Trung Plaza building, 255-257 Hung Vuong, Vinh Trung Ward,  " : "Tòa nhà Vĩnh Trung Plaza, Tầng Trệt, 255-257 Hùng Vương, Phường Vĩnh Trung, Quận Thanh Khê, Tp. Đà Nẵng<br/>") %>
						<%= (langCd.equals("en_US") ? "Thanh Khe District, Da Nang City<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-236-7303968 Fax  84-236-7303968" : "ĐT: 84-236-7303968 Fax: 84-236-7303968") %></p>
					</tr>
					<tr>
						<strong><%= (langCd.equals("en_US") ? "CAN THO BRANCH" : "CHI NHÁNH CẦN THƠ") %></strong>
						<p><%= (langCd.equals("en_US") ? "5th Floor, VCCI Can Tho building, 12 Hoa Binh, An Cu Ward,  " : "Tòa nhà VCCI Cần Thơ, Tầng 5, 12 Hòa Bình, Phường An Cư, Quận Ninh Kiều, Tp. Cần Thơ<br/>") %>
						<%= (langCd.equals("en_US") ? "Ninh Kieu District, Can Tho City<br/>" : "") %>
						<%= (langCd.equals("en_US") ? "Tel  84-292-7303968 Fax  84-28-39107222" : "ĐT: 84-292-7303968 Fax: 84-28-39107222") %></p>
					</tr>
				</tbody>
			</table>
		</div>

		<div style="border-top: 1px solid; padding-top: 10px;">
			<table>
				<colgroup>
					<col width="70%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
				</colgroup>
				<tbody>
					<tr>
						<td style="border:0px;text-align:left;background-color:#00457c;color:#fff;">
							© 2017 Mirae Asset Securities (Vietnam) LLC
						</td>
						<td style="border:0px;">
							<a href="https://www.linkedin.com/company/mirae-asset-global-investments/" target="_blank"><img src="/resources/US/images/icon_linkedin.png" alt="linked in"></a>
						</td>
						<td style="border:0px;">
							<a href="https://twitter.com/miraeasset" target="_blank"><img src="/resources/US/images/icon_twitter.png" alt="twitter"></a>
						</td>
						<td style="border:0px;">
							<a href="https://www.youtube.com/user/miraeasset" target="_blank"><img src="/resources/US/images/icon_youtube.png" alt="youtube"></a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

	</div>
	<div id="divForgetPasswordPop" class="modal_wrap"></div>
	<script>
	$("body").height();
	</script>
</body>
</html>