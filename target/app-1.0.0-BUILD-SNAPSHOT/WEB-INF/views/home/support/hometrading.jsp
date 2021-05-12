<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Home Trading System";
	});
	
	function downloadCounter() {
		$.ajax({
			url      : "/home/support/downloadCounter.do",			
			dataType : "json",
			success  : function(data){
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
</script>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
<script type="text/javascript" src="/resources/US/js/trading_mobile.js"></script>

</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Home Trading System</h2>                
            <ul>
                
            </ul>  
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title trading">Home Trading System</h3>

			<div class="home_trading_en"></div>
            
			<h5 class="sub_title" style="font-weight:600;">INSTANT ORDER EXECUTION, REAL-TIME DATA AND UNLIMITED ASSET ACCESS</h5>
            <ul class="data_list type_01">
                <li>Our investors can get easy to use, many features with more security, intelligent features, anywhere, anytime.</li>
                <li>Tracking news & real-time price/index.</li>
                <li>Easy to place orders with best bids/best offers suggestion.</li>
                <li>Monitor & manage orders status with simple touch.</li>
                <li>Money Transfer bank accounts.</li>
                <li>Asset Management, Gain/Loss.</li>
                <li>Order History</li>
            </ul>
            
            <h5 class="sub_title" style="font-weight:600;">DOWNLOAD HOME TRADING SYSTEM (SETUP APPLICATION)</h5>
            <a href="https://masvn.com/linkDown.do?ids=7D73EFBB-F674-476E-869E-2DD5E05674D6" onclick="downloadCounter();">
            	<div class="home_trading_app_en"></div>
            </a>
            
            <h5 class="sub_title" style="font-weight:600;">DOWNLOAD HOME TRADING SYSTEM (SETUP GUIDE)</h5>            
            <a href="https://masvn.com/linkDown.do?ids=BA6E8C60-EEC1-494F-B1FB-DABEE53359E1">
            	<div class="home_trading_setup_en"></div>
            </a>
            
            <h5 class="sub_title" style="font-weight:600;">DOWNLOAD HOME TRADING SYSTEM USER GUIDE</h5>
            <a href="https://masvn.com/linkDown.do?ids=C44B03E0-3728-49A0-9CD4-3617C64A8399">
            	<div class="home_trading_doc_en"></div>
            </a>
        </div>
    </div>
</div>


</body>
</html>