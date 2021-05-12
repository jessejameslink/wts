<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Xác nhận Mật khẩu | MIRAE ASSET</title>
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
            	<h4>Mật khẩu tài khoản</h4>
        		<div class="inputs c_pw">
            		<form>
        				<div>
        					<label for="acc">Số tài khoản</label>
                        <div class="select_wrap">
                            <select id="acc">
	        						<option>077-C-123456</option>
	        						<option>077-C-123456</option>
	        						<option>077-C-123456</option>
	        					</select>
                        </div>
        				</div>
        				<div>
        					<label for="pw">Mật khẩu hiện tại</label>
        					<input type="password" id="pw" maxlength="16"/>
        				</div>
        				<div>
        					<label for="new_pw">Mật khẩu mới</label>
        					<input type="password" id="new_pw" maxlength="16"/>
        				</div>
        				<div>
        					<label for="con_pw">Xác nhận mật khẩu mới</label>
        					<input type="password" id="con_pw" maxlength="16"/>
        				</div>

        				<input type="submit" value="Xác nhận" class="change" />
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