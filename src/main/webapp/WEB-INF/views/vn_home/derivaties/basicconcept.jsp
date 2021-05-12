<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Khái niệm cơ bản";
		$("#divNoticePop").hide();
		
		var currentUrl = window.location.href;
		var idx = currentUrl.indexOf("?");
		if (idx >= 0) {
			$("#divNoticePop").fadeIn();
		} else {
			$("#divNoticePop").fadeOut();
		}
		newUrl = currentUrl.substring(0, idx);
		window.history.replaceState("", "", newUrl);
	});
	
	function closeNoticePop() {
		$("#divNoticePop").fadeOut();
	}
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Phái sinh</h2>
            <ul>
                <li><a href="/home/derivaties/basicconcept.do" class="on">Khái niệm cơ bản</a></li>
                <li><a href="/home/derivaties/indexseries.do">HĐTL Chỉ số Index</a></li>
                <li><a href="/home/derivaties/bondseries.do">HĐTL Trái phiếu chính phủ</a></li>
                <li><a href="/home/derivaties/feetable.do">Biểu phí</a></li>
                <li><a href="/home/derivaties/tradeguide.do">Hướng dẫn giao dịch</a></li>
                <!--
                <li><a href="/home/derivaties/endow.do">Miễn phí giao dịch</a></li>
                  
                <li><a href="/home/derivaties/derinews.do">Tin tức</a></li>                
                <li><a href="/home/derivaties/registernews.do">Đăng ký nhận bản tin</a></li>
                -->
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">        	
            <h3 class="cont_title">Khái niệm cơ bản</h3>
            <div class="deri_basic00_vn"></div>
            <div class="deri_basic01_vn"></div>
            <div class="deri_basic02_vn"></div>
            <div class="deri_basic03_vn"></div>
            <div class="deri_basic04_vn"></div>
            <div class="deri_basic05_vn"></div>
            <div class="deri_basic06_vn"></div>
            <div class="deri_basic07_vn"></div>
            <div class="deri_basic08_vn"></div>            
            
            <div id="divNoticePop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 60px 40px; border:1px solid #aaaaab;overflow:auto;height:385px; top:-2%;left:62%;width:800px;">
					<div class="total_wrap" style="width:100%;">
						<div class="deri_notice_vn">
						</div>
					</div>
					<button class="close" type="button" onclick="closeNoticePop()">Huy</button>
				</div>
			</div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>