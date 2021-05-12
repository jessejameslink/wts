<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Đăng nhập | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/VN/css/miraeasset.css">
<script type="text/javascript" src="/resources/VN/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/VN/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/VN/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">Thông tin tài khoản</h3>

            <div class="form_container">
            	<h4>Đăng nhập</h4>
        		<div class="inputs">
            		<form>
        				<div>
        					<label for="acc">Số tài khoản</label>
        					<input type="text" id="acc" value="077C" />
        				</div>
        				<div>
        					<label for="pw">Mật khẩu</label>
        					<input type="password" id="pw" maxlength="16"/>
        				</div>
        				<div class="sec_code">
        					<label for="sec">Security Code</label>
        					<div class="captcha">
        						<img src="/resources/VN/images/temp_captcha.jpg" alt="" />
        					</div>
        					<input type="text" id="sec" />
        				</div>
        				<input type="submit" value="Đăng nhập" class="submit" />
            		</form>
        		</div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>