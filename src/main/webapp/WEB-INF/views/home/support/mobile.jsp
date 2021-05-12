<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Support";
	});
</script>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
<script type="text/javascript" src="/resources/US/js/trading_mobile.js"></script>

</head>
<%
String param	=	request.getParameter("link");
%>


<body>
<script>
	$(document).ready(function() {
		if("<%=param%>" != null ) {
			slideshow.pos("<%=param%>");
		}
	});
	
	function downloadFile() {
		//$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=10&lang=en";
		//$("body").unblock();
	}
</script>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Mobile<br /> Trading</h2>                
            <ul>
                <li onclick="slideshow.pos(0)"><a href="#">Login</a></li>
                <li onclick="slideshow.pos(1)"><a href="#">All Menu</a></li>
                <!--<li onclick="slideshow.pos(2)"><a href="#">Current Price</a></li> -->
                <li onclick="slideshow.pos(2)"><a href="#">Stock Order</a></li>
                <li onclick="slideshow.pos(3)"><a href="#">Stock Order from </br>Watch List</a></li>
                <li onclick="slideshow.pos(4)"><a href="#">Stock Order from </br>Price Board</a></li>
                <li onclick="slideshow.pos(5)"><a href="#">Chart</a></li>
                <li onclick="slideshow.pos(6)"><a href="#">Stock Statistic</a></li>
                <li onclick="slideshow.pos(7)"><a href="#">Cash/Loan Service</a></li>
                <li onclick="slideshow.pos(8)"><a href="#">Portfolio Management</a></li>
                <li onclick="slideshow.pos(9)"><a href="#">Market News</a></li>
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
								<li><img src="/resources/US/images/slider01.png" alt="" /></li>
								<li><img src="/resources/US/images/slider02.png" alt="" /></li>
								<li><img src="/resources/US/images/slider04.png" alt="" /></li>
								<li><img src="/resources/US/images/slider06.png" alt="" /></li>
								<li><img src="/resources/US/images/slider07.png" alt="" /></li>
								
								<li><img src="/resources/US/images/slider05.png" alt="" /></li>
								<li><img src="/resources/US/images/slider08.png" alt="" /></li>
								<li><img src="/resources/US/images/slider09.png" alt="" /></li>
								<li><img src="/resources/US/images/slider10.png" alt="" /></li>
								<li><img src="/resources/US/images/slider11.png" alt="" /></li>
							</ul>	
						</div>
					</div>
				
					<div class="desc_txt" >
						<p>Our investors can get easy to use, many features with more security, 
						intelligent features, anywhere, anytime...</p>
	
						<ul class="list_type">
							<li><a href="#">Stock trading system via Android OS &amp; iOS device.</a></li>
							<li><a href="#">Tracking news &amp; real-time price/index.</a></li>
							<li><a href="#">Easy to place orders with best bids/best offers suggestion.</a></li>
							<li><a href="#">Monitor &amp; manage orders status with simple touch.</a></li>
							<li><a href="#">Money Transfer bank accounts.</a></li>
							<li><a href="#">Asset Management, Gain/Loss.</a></li>
							<li><a href="#">Order History</a></li>
						</ul>
						<!--  
						<ul class="split_list">
							<li><a href="http://itunes.apple.com/app/id1197941600?mt=8" target="_blank"><img src="/resources/US/images/btn_app.gif" alt="Download on the App Store" /></a></li>
							<li><a href="https://play.google.com/store/apps/details?id=com.masvn&hl=vn" target="_blank"><img src="/resources/US/images/btn_google.gif" alt="GET IT ON Google Play" /></a></li>
						</ul>
					 	-->
					 	<ul class="list_type">
							<li>
                            	<b>Installation guide "My Asset" application by App Store/Google Store pages: </b>
                                <a href="/home/support/mobileinstall.do" style="color:#0075c1;">Here</a>
                            </li>
                            <li>
                                <b>Download detail user guide at here: </b>
                                <a href="#" class="btn_attach" onclick="downloadFile(10);return false;">Download</a>
                            </li>
						</ul>
					</div>
				</div>
			</div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->


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