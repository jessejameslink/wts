<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Mobile trading guideline | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/US/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
<script type="text/javascript" src="/resources/US/js/trading_mobile.js"></script>

</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Mobile<br /> Trading</h2>                
            <ul>
                <li onclick="slideshow.pos(0)"><a href="#">Login</a></li>
                <li onclick="slideshow.pos(1)"><a href="#">Full Menu</a></li>
                <li onclick="slideshow.pos(2)"><a href="#">Current Price</a></li>
                <li onclick="slideshow.pos(3)"><a href="#">Stock Order</a></li>
                <li onclick="slideshow.pos(4)"><a href="#">Chart</a></li>
                
            </ul>  
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title trading">Mirae Asset Securities Mobile Trading System</h3>            
            <h4 class="cont_title02">INSTANT ORDER EXECUTION, <br />REAL-TIME DATA AND UNLIMITED ASSET ACCESS.</h4>

			<div class="trading_guide_wrap" >
				<div class="trading_guide01">
					<div class="sldwrap">
						<div id="slider" class="slider">
							<ul>
								<li><img src="/resources/US/images/slider01.gif" alt="" /></li>
								<li><img src="/resources/US/images/slider02.gif" alt="" /></li>
								<li><img src="/resources/US/images/slider03.gif" alt="" /></li>
								<li><img src="/resources/US/images/slider04.gif" alt="" /></li>
								<li><img src="/resources/US/images/slider05.gif" alt="" /></li>
							</ul>	
						</div>
					</div>
				
					<div class="desc_txt" >
						<p>Our investors can get easy to use, many features with more security, 
						intelligent features, anywhere, anytime:</p>
	
						<ul class="list_type">
							<li><a href="#">Stock trading system via Android OS &amp; iSO device</a></li>
							<li><a href="#">Tracking news &amp; realtime price/index,</a></li>
							<li><a href="#">Easy to place orders with best bids/best offers suggestion.</a></li>
							<li><a href="#">Monitor &amp; manage orders status with simple touch.</a></li>
							<li><a href="#">Money Transfer with internal accounts or to bank accounts.</a></li>
							<li><a href="#">Assest Management, Gain/Loss.</a></li>
							<li><a href="#">Order History</a></li>
						</ul>
						
						<ul class="split_list">
							<li><a href="#"><img src="/resources/US/images/btn_app.gif" alt="Download on the App Store" /></a></li>
							<li><a href="#"><img src="/resources/US/images/btn_google.gif" alt="GET IT ON Google Play" /></a></li>
						</ul>
					
					</div>
				</div>
			</div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

<script type="text/javascript">
var slideshow=new TINY.slider.slide('slideshow',{
	id:'slider',
	//auto:3, // 자동롤링적용
	resume:true,
	vertical:false,
	navid:'lnb',
	activeclass:'current',
	position:0
});
	
	$('#lnb ul>li>a').on('click',function(e){
		e.preventDefault();
	});
	
</script>

</body>
</html>