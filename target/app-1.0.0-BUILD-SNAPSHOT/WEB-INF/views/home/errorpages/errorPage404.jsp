<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<script type="text/javascript" src="/resources/HOME/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/HOME/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function(){
		var currentUrl = window.location.href;
		var idx = currentUrl.indexOf("Default.aspx");
		if (idx >= 0) {
			window.location.href = "https://masvn.com";
			document.title = "https://masvn.com";
		}
	});
</script>
<head>
<title>404 | MIRAE ASSET</title>
</head>
<body>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">       
        <div id="contents">
		    <div style="text-align: center;">
				<img src="/resources/US/images/404_error.png" title="404" />
   			</div>
        </div>
    </div>
</div>

</body>
</html>