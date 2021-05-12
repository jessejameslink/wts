<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<!--
		authCheckOK(divType) : 부모 페이지 내에 실행할 Method
		divId                : 부모 페이지 내에서 사용할 pop div ID명
		divType              : 부모 페이지로 사용할 pop div 처리구분
 -->

<html>
<head>
<style>
/*
.layer_pop {display:none; position:absolute; top:0; left:0; width:100%; height:100%; line-height:24px; background:rgba(0,0,0,0.7); z-index:100;}
.layer_pop_container {position:absolute; top:204px; left:50%; box-sizing:border-box; margin-left:-410px; padding:32px; width:820px; border:2px solid #242d4a; background:#fff;}
.btn_close_pop {position:absolute; top:32px; right:32px; padding:0; width:15px; height:15px; text-indent:-9999px; background:url(/resources/HOME/images/bg_close.png) no-repeat;cursor:pointer;}
 
body.login {background:url(/resources/images/bg_login.jpg) no-repeat 50% 0}
.login h1 {position:absolute; left:50px; top:40px;}
.login_wrap {position:absolute; left:50%; top:50%; width:450px; margin:-350px 0 0 -225px; padding:88px 50px 50px; background:#fff; border-radius:5px;}
 */
 /* 
.layer_pop {display:none; position:absolute; top:0; left:0; width:100%; height:100%; line-height:24px; background:rgba(0,0,0,0.7); z-index:100;}
.layer_pop_container {position:absolute; top:204px; left:50%; box-sizing:border-box; margin-left:-210px; padding:32px; width:450px; border:2px solid #242d4a; background:#fff;}
.btn_close_pop {position:absolute; top:32px; right:32px; padding:0; width:15px; height:15px; text-indent:-9999px; background:url(/resources/HOME/images/bg_close.png) no-repeat;cursor:pointer;}
body.login {background:url(/resources/images/bg_login.jpg) no-repeat 50% 0}
.login h1 {position:absolute; left:50px; top:40px;}
.login_wrap {position:absolute; left:50%; top:50%; width:450px; margin:-50px 0 0 -225px; padding:88px 50px 50px; background:#fff; border-radius:5px;}
.login_wrap .language {position:absolute; right:50px; top:50px;}
.login_wrap .language button {padding:0; line-height:0; border:0;}
.login_wrap label {cursor:pointer;}
.login_wrap .input_area label {display:block; padding:30px 0 20px; font-size:14px; font-weight:600; text-align:left;}
.login_wrap input {width:100%; height:auto; padding:0 0 5px; background:transparent; color:#343434; font-size:18px; text-align:left; border:0; border-bottom:1px solid #e1e1e1;}
.login_wrap .input_area input[type=password]{font-size:28px;}
.login_wrap .input_area p {padding:20px 0;}
.login_wrap .input_area p:before {content:' * ';}
.login_wrap h2 {padding-top:40px;color:#343434;font-size:20px;text-transform:uppercase;text-align:center;}
.login_wrap .choice_area {display:inline-block; margin:0 auto;}
.login_wrap .choice_area label {line-height:18px;}
.login_wrap .choice_area > div {display:inline-block; white-space:nowrap; vertical-align:top;}
.login_wrap .choice_area .loginChk1 {width:250px;}
.login_wrap .choice_area em {display:block; text-indent:18px;}
.login_wrap .choice_area ul {width:55%; padding:5px 0; margin:5px 0 0 18px; border:1px solid #c9d1d5; overflow:hidden;}
.login_wrap .choice_area li {float:left; width:46%; margin:0 2px; text-align:center;}
.login_wrap .choice_area li strong {display:block; padding:0 0 5px;}
.login_wrap .choice_area li strong:after {content:' ]'}
.login_wrap .choice_area li strong:before {content:'[ '}
.login_wrap .choice_area li input {width:40px; background:#48505a;}
.login_wrap .btn_login {padding:20px 0; text-align:center;}
.login_wrap .btn_login button {width:60%; height:49px; background:#0082ca; color:#fff; font-size:18px; font-weight:100; border:0;}
.security_code h3 {padding:30px 0 20px; font-size:14px; text-align:left;}
.security_code > div {position:relative;}
.security_code input {width:100%; vertical-align:middle; border:0; border-bottom:1px solid #e1e1e1;}
.security_code > div > img {position:absolute; right:0; top:-20px;}
.login_wrap .address li {padding:20px 0 0; color:#777; line-height:18px;}
//.login_wrap .address li strong {display:block; padding:0 0 0 10px; background:url(/resources/images/bg_dot.gif) no-repeat 0 50%;}
.login_wrap .address li strong {display:block;}
 */



</style>
<script>
function cancel() {
	$("#divLoginViewPop").fadeOut();
}



$(document).ready(function() {
	$( "div[name=tabs]" ).tabs();
	
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
		$(".layer_pop_container").block({message: "<span>LOADING...</span>"});
		
		if($("#securitycode").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("please input security code");	
			} else {
				alert("Vui lòng nhập mã bảo mật");
			}
			$(".layer_pop_container").unblock();
			$("#securitycode").focus();
			return;
		}
		$(".login_wrap").block({message: "<span>LOADING...</span>"});
		var param = {
				mvClientID		:$("#mvClientID").val(),
				mvPassword		:$("#mvPassword").val(),
				securitycode	:$("#securitycode").val()
		};
		
		$.ajax({
			url:'/login/login.do',
			data:param,
		    dataType: 'json',
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
			 			if ("<%= langCd %>" == "en_US") {
			 				alert("Change Password Need");	
			 			} else {
			 				alert("Cần thay đổi mật khẩu");
			 			}

			 			location.href	=	"/home/account/changePw.do";
			 			return;
			 		}
			 		
			 		
			 		var rtUrl	=	"${old_url}";
			 		if(rtUrl.indexOf("wts") > 0) {
			 			location.href	=	rtUrl;
			 		} else if(rtUrl.indexOf("account") > 0) {
			 			location.href	=	rtUrl;
			 		} else if(rtUrl.indexOf("logout") > 0) {
			 			location.href	=	"/";
			 		} else {
			 			location.href	=	"/";
			 		}
			 		changeLan(('<%= session.getAttribute("LanguageCookie") %>' != "null"? '<%= session.getAttribute("LanguageCookie") %>' : "vi_VN"));
			 		//location.href="/wts/view/trading.do";
			 	} else {
			 		$(".layer_pop_container").unblock();
			 		//alert(data.jsonObj.mvMessage.toString());
			 		//location.reload();
			 		if ("<%= langCd %>" == "en_US") {
			 			alert(data.jsonObj.mvMessage.toString());
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
		    	$(".layer_pop_container").unblock();
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



</script>
</head>

<%--
<body>	
	<!-- login_layer_popup -->
	<!-- 
	<div class="modal_layer add" style="top:1300px; left:890px; width:650px; height:850px; margin-left:0;">
	 -->
	<div class="modal_layer login">
		<div class="login_wrap popup">
	  		<h1><img src="/resources/images/logo.png" alt="MIRAE ASSET WTS"></h1>
			<h2>GIAO DỊCH TRỰC TUYẾN</h2>
			<!-- 
			<span class="language">
				<button type="button" onclick="changeLan('en_US'); history.go(0);"><img src="/resources/images/icon_lang_en.gif" alt="English"></button>
				<button type="button" onclick="changeLan('vi_VN'); history.go(0);"><img src="/resources/images/icon_lang_vi.gif" alt="vietnamese"></button>
			</span>
			 -->
			<div class="input_area">
				<label for="mvClientID">Số Tài khoản</label>
				<input id="mvClientID" type="text" value="077C">
				<label for="mvPassword">Mật khẩu</label>
				<input id="mvPassword" type="password" value="">
				<!-- <p>Login using any of the following services.</p> -->
			</div>
	
			<div class="security_code">
				<h3>Ma an toan</h3>
				<div>
					<input id="securitycode" type="text" value="">
					<img src="http://10.0.31.4/randomImage.jpg" alt="Security Code">
					<!--
					<img src="/resources/images/security_code.gif" alt="Security Code">
					-->
				</div>
			</div>
			 
			 <!--- DO NOT EDIT - GlobalSign SSL Site Seal Code - DO NOT EDIT --->
			 <div class="loginLabel" id="ext-gen1030" style="top: -8px;">		 
			 <script src="//ssif1.globalsign.com/SiteSeal/siteSeal/siteSeal/siteSeal.do?p1=127.0.0.1:8080&amp;p2=SZ125-50&amp;p3=image&amp;p4=en&amp;p5=V0023&amp;p6=S001&amp;p7=http"></script><span><img name="ss_imgTag" border="0" src="//ssif1.globalsign.com/SiteSeal/siteSeal/siteSeal/siteSealImage.do?p1=127.0.0.1:8080&amp;p2=SZ125-50&amp;p3=image&amp;p4=en&amp;p5=V0023&amp;p6=S001&amp;p7=http&amp;deterDn=" alt="" oncontextmenu="return false;" galleryimg="no"></span><span id="ss_siteSeal_fin_SZ125-50_image_en_V0023_S001"></span>
			 <script type="text/javascript" src="//seal.globalsign.com/SiteSeal/gmogs_image_125-50_en_dblue.js">
			 </script>
			 </div>
			 <!--- DO NOT EDIT - GlobalSign SSL Site Seal Code - DO NOT EDIT --->
			 
			<div class="btn_login"><button type="button" id="loginOn">Đăng nhập</button></div>
	
			<ul class="address">
				<li>
					<strong>TRỤ SỞ CHÍNH</strong>
					<p>Tòa nhà Sài Gòn Royal, Tầng 7, 91 Pasteur, Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh<br>
					
					ĐT: 84-8-3-9102222 - Fax: 84-8-3-9107222</p>
				</li>
				<li>
					<strong>CHI NHÁNH HÀ NỘI</strong>
					<p>Tòa nhà SacomBank, Tầng 8, 27 Hàng Bài, Quận Hoàn Kiếm, Hà Nội<br>
					
					ĐT: 84-4-62730541 - Fax: 84-4-62730544</p>
				</li>
			</ul>
	
	  	</div>
		
		<button class="close" type="button" onclick="cancel();">close</button>
	</div>
	<!-- //login_layer_popup -->
</body>
--%>


<%-- 
<body>
	<div class="layer_pop_container">
		<div class="board_detail">
		  	<div class="login_wrap">
				<h2><%= (langCd.equals("en_US") ? "trading online" : "GIAO DỊCH TRỰC TUYẾN") %></h2>
		<div class="input_area">
			<label for="mvClientID"><%= (langCd.equals("en_US") ? "Account" : "Số Tài khoản") %></label>
			<input id="mvClientID" type="text" value="077C">
			<label for="mvPassword"><%= (langCd.equals("en_US") ? "Password" : "Mật khẩu") %></label>
			<input id="mvPassword" type="password" value="">
			<!-- <p>Login using any of the following services.</p> -->
		</div>

		<div class="security_code">
			<h3><%= (langCd.equals("en_US") ? "Security Code" : "Mã an toàn") %></h3>
			<div>
				<input id="securitycode" type="text" value="">
				<img src="${ttl}randomImage.jpg?_dc=${key}" alt="Security Code">
				<!--
				<img src="/resources/images/security_code.gif" alt="Security Code">
				-->
			</div>
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
		 
		<div class="btn_login"><button type="button" id="loginOn"><%= (langCd.equals("en_US") ? "Login" : "Đăng nhập") %></button></div>
		

		<ul class="address">
			<li>
				<strong><%= (langCd.equals("en_US") ? "HEADQUARTER" : "TRỤ SỞ CHÍNH") %></strong>
				<p><%= (langCd.equals("en_US") ? "7th Floor, Sai Gon Royal building, 91 Pasteur Street," : "Tòa nhà Sài Gòn Royal, Tầng 7, 91 Pasteur, Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh<br>") %>
				<%= (langCd.equals("en_US") ? "Ben Nghe Ward, District 1, Ho Chi Minh City<br>" : "") %>
				<%= (langCd.equals("en_US") ? "Tel  84-8-3-9102222    Fax  84-8-3-9107222" : "ĐT: 84-8-3-9102222 - Fax: 84-8-3-9107222") %></p>
			</li>
			<li>
				<strong><%= (langCd.equals("en_US") ? "HA NOI BRANCH" : "CHI NHÁNH HÀ NỘI") %></strong>
				<p><%= (langCd.equals("en_US") ? "8th Floor, SacomBank building, 27 Hang Bai Street,  " : "Tòa nhà SacomBank, Tầng 8, 27 Hàng Bài, Quận Hoàn Kiếm, Hà Nội<br>") %>
				<%= (langCd.equals("en_US") ? "Hoan Kiem District, Ha Noi<br>" : "") %>
				<%= (langCd.equals("en_US") ? "Tel  84-4-62730541    Fax  84-4-62730544" : "ĐT: 84-4-62730541 - Fax: 84-4-62730544") %></p>
			</li>
		</ul>
		  	</div>
    	</div>
    	<button type="button" class="btn_close_pop" onclick="cancel()">close</button>
	</div>
</body>
 --%>

<body>
<div id="loignPopup" class="layer_pop">
	<input type="hidden" value="${old_url}"/>
	
    <div class="layer_pop_container">
    	<h2>TRADING ONLINE</h2>
    	<dl class="input_area">
    		<dt><span class="icon_id"></span></dt>
    		<dd><input id="mvClientID" type="text" value="<%= (langCd.equals("en_US") ? "077F" : "077C") %>"></dd>
    		<dt><span class="icon_pw"></span></dt>
    		<dd><input id="mvPassword" type="password" value=""></dd>
    		<dt><span class="icon_security"></span></dt>
    		<dd class="security"><input id="securitycode" type="text" value=""><div class="code"><img src="${ttl}randomImage.jpg?_dc=${key}" alt="Security Code"></div></dd>
    	</dl>
    	
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
    	
    	
    	<div class="button_area">
    		<button type="button" id="loginOn" class="btn_login">Login</button>
    		<button type="button" class="btn_close_pop">Cancel</button>
    	</div>
    	<dl class="login_info">
    		<dt><span></span>HEADQUARTER</dt>
    		<dd><span>TEL  84-8-3-9102222</span><span>Fax  84-8-3-9107222</span></dd>
    		<dt><span></span>HA NOI BRANCH</dt>
    		<dd><span>TEL  84-4-62730541</span><span>Fax  84-4-62730544</span></dd>
    	</dl>
    </div>
</div>
</body>



</html>