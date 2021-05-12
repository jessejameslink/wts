<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<script type="text/javascript" src="/resources/HOME/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/HOME/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
<html lang="vi">
<head>
<title>MIRAE ASSET VN | Trang bảo trì</title>
<script>
$(document).ready(function() {
	var currentUrl = window.location.href;
	
	var idx3 = currentUrl.indexOf("wts.masvn.com");
	var idx1 = currentUrl.indexOf("resetpassword");
	var idx2 = currentUrl.indexOf("openAccount");
	if (idx3 >= 0) {
		currentUrl = "https://wts.masvn.com/login.do?redirect=/wts/view/trading.do";
		window.location.href = currentUrl;
	}
	if (idx1 >= 0 || idx2 >= 0 || idx3 ) {
		window.location.href = currentUrl;
	}
});
</script>
</head>
<body>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">       
        <div id="contents">
		    <div style="text-align: center;">
				<img src="/resources/images/spinner.gif" title="maintenance" />
   			</div>
        </div>
    </div>
</div>

</body>
</html>