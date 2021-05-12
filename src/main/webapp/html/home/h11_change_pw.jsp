<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Change Password | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/US/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">My ASSET</h3>

            <div class="form_container">
            	<h4>Change Password</h4>
        		<div class="inputs c_pw">
            		<form>
        				<div>
        					<label for="acc">Account</label>
                        <div class="select_wrap">
                            <select id="acc">
	        						<option>077-C-123456</option>
	        						<option>077-C-123456</option>
	        						<option>077-C-123456</option>
	        					</select>
                        </div>
        				</div>
        				<div>
        					<label for="pw">Password</label>
        					<input type="password" id="pw" maxlength="16"/>
        				</div>
        				<div>
        					<label for="new_pw">New Password</label>
        					<input type="password" id="new_pw" maxlength="16"/>
        				</div>
        				<div>
        					<label for="con_pw">Confirm Password</label>
        					<input type="password" id="con_pw" maxlength="16"/>
        				</div>

        				<input type="submit" value="Change" class="change" />
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