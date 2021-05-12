<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Basic Definitions";
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
            <h2>Derivatives</h2>
            <ul>
                <li><a href="/home/derivaties/basicconcept.do" class="on">Basic Definitions</a></li>
                <li><a href="/home/derivaties/indexseries.do">VN30 Index Future</a></li>
                <li><a href="/home/derivaties/bondseries.do">VGB Future</a></li>
                <li><a href="/home/derivaties/feetable.do">Fee Chart</a></li>
                <li><a href="/home/derivaties/tradeguide.do">Trading Guide</a></li>
                <li><a href="/home/derivaties/endow.do">Free derivatives trading</a></li>
                <!--  
                <li><a href="/home/derivaties/derinews.do">News</a></li>
                <li><a href="/home/derivaties/registernews.do">Newsletter Registration</a></li>
                -->
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Basic Definitions</h3>
            <div class="deri_basic01_en"></div>
            <div class="deri_basic02_en"></div>
            <div class="deri_basic03_en"></div>
            <div class="deri_basic04_en"></div>
            <div class="deri_basic05_en"></div>
            <div class="deri_basic06_en"></div>
            <div class="deri_basic07_en"></div>
            
            <div id="divNoticePop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 60px 40px; border:1px solid #aaaaab;overflow:auto;height:385px; top:-2%;left:62%;width:800px;">
					<div class="total_wrap" style="width:100%;">
						<div class="deri_notice_en">
						</div>
					</div>
					<button class="close" type="button" onclick="closeNoticePop()">Huy</button>
				</div>
			</div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>