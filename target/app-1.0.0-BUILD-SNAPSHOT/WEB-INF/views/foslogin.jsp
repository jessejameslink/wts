<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
	        response.setHeader("Cache-Control", "no-cache");
	response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
%>

<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	
	if(langCd == null){
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

<script type="text/javascript" src="/resources/js/jquery.min.js"/></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"/></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/css/common.css" />

<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<title>MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "LOGIN" : "ĐĂNG NHẬP") %></title>


<script>
var rtUrl	=	"/";
$(document).ready(function() {
	
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
	
	$("#loginOn").click(function(){
		$(".login_wrap").block({message: "<span>LOADING...</span>"});
		var param = {
				mvClientID		:$("#mvClientID").val().toUpperCase(),
				mvPassword		:$("#mvPassword").val(),
				securitycode	:$("#securitycode").val()
		};
		
		$.ajax({
			url:'/login/foslogin.do',
			data:param,
			cache: false,
		    dataType: 'json',
		    type: 'POST',
		    success: function(data){
			 	if(data.jsonObj.success.toString() == "true"){
			 		/*
			 		if($('input[name=loginChk]:checked').val() == "1"){//보안카드 선택없이 가면 일단 ID ,PWD로 통과
			 			location.href="/trading/tradingMain.do";
			 		} else {												//아닐경우 보안카드 검사로 패스
			 			//authCardMetrix();
			 			alert("다른거 선택해라");
			 		}
			 		*/
			 		if(data.jsonObj.needChangePwd == "true") {
			 			//alert("Change Password Need");
			 			if ("<%= langCd %>" == "en_US") {
							alert("Change Password Need");	
						} else {
							alert("Cần thay đổi mật khẩu");
						}
			 			location.href	=	"/home/account/changePw.do";
			 			return;
			 		}
			 		
			 		
			 		rtUrl	=	"${old_url}";
			 		//localStorage.setItem("login", "");
			 		
			 		if(rtUrl.indexOf("wts") > 0) {
			 			//location.href	=	rtUrl;
			 		} else if(rtUrl.indexOf("account") > 0) {
			 			//location.href	=	rtUrl;
			 		} else if(rtUrl.indexOf("logout") > 0) {
			 			//location.href	=	"/";
			 			rtUrl	=	"/";
			 		} else {
			 			rtUrl	=	"/";
			 			//location.href	=	"/";
			 		}
			 		changeLan(('<%= session.getAttribute("LanguageCookie") %>' != "null"? '<%= session.getAttribute("LanguageCookie") %>' : "vi_VN"));
			 		//location.href="/wts/view/trading.do";
			 	} else {
			 		$(".login_wrap").unblock();			 		
			 		//location.reload();
			 		if ("<%= langCd %>" == "en_US") {			 			
			 			if (data.jsonObj.mvMessage.toString().indexOf("3911") >= 0) {
			    			alert("Web service is not ready. Please contact with MAS by number (08) 39110690 for help.");
			    		} else if (data.jsonObj.mvMessage.toString().indexOf("Số tài khoản hoặc mật khẩu") >= 0) {
			    			alert("Wrong Account Number or Password. Please try again.");
			    		} else {
			    			alert(data.jsonObj.mvMessage.toString());
			    		}			 			
			    	} else {
			    		if (data.jsonObj.mvMessage.toString().indexOf("Error message") >= 0) {
			    			alert("Thông báo lỗi không xác định trong lập bản đồ mã lỗi");
			    		} else {
			    			alert(data.jsonObj.mvMessage.toString());
			    		}
			    	}
			 	}
		    },
		    error : function(data) {
		    	$(".login_wrap").unblock();
		    	if ("<%= langCd %>" == "en_US") {
		    		alert("System error has occurred.please call adminstrator.");	
		    	} else {
		    		alert("Lỗi hệ thống đã xảy ra. Vui lòng gọi cho quản trị viên.");
		    	}
		    	return;
		    }
		});
	});
	
});






function changeLan(str) {
	var param = {
		mvCurrentLanguage	:	str
		, request_locale	:	str
	};

	$.ajax({
		dataType  : "json",
		url       : "/home/changelanguage.do",
		data      : param,
		success   : function(data) {
			
			if(rtUrl == "/") {
				location.reload();
			} else {
				location.href	=	rtUrl;
			}
			
			if(data != null) {
				
			}
		},
		error     :function(e) {
			console.log(e);
		}
	});
}
	
</script>
<style type="text/css">
#mainCaptcha{
	background-color: grey;
	position: absolute;
	right : 0px;
	top: -18px;
	
}
</style>
</head>
  <body class="login">
  <input type="hidden" value="${old_url}"/>
  	<div class="login_wrap">
  		<h1><img src="/resources/images/logo.png" alt="MIRAE ASSET WTS"></h1>
		<h2><%= (langCd.equals("en_US") ? "trading online" : "GIAO DỊCH TRỰC TUYẾN") %></h2>
		 
		<span class="language">
			<button type="button" onclick="changeLan('en_US'); "><img src="/resources/images/icon_lang_en.gif" alt="English"></button>
			<button type="button" onclick="changeLan('vi_VN'); "><img src="/resources/images/icon_lang_vi.gif" alt="vietnamese"></button>
		</span> 
		   
		 
		
		<div class="input_area">
			<label for="mvClientID"><%= (langCd.equals("en_US") ? "Account" : "Số Tài khoản") %></label>
			<input style="text-transform: uppercase;" id="mvClientID" type="text" value="<%= (langCd.equals("en_US") ? "077F" : "077C") %>">
			<label for="mvPassword"><%= (langCd.equals("en_US") ? "Password" : "Mật khẩu") %></label>
			<input id="mvPassword" type="password" value="">
			<!-- <p>Login using any of the following services.</p> -->
		</div>

		
		
		<div style="border-bottom:1px solid;" class="btn_login"><button type="button" id="loginOn"><%= (langCd.equals("en_US") ? "Login" : "Đăng nhập") %></button></div>
		 
		 

		
		
		

  	</div>
  	 	
	<script>
	$("body").height();
	</script>
  </body>
</html>