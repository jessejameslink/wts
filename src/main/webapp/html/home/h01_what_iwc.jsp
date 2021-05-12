<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Why Mirae Asset | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>About Us</h2>
            <ul>
                <li><a href="h01_philosophy.jsp">Philosophy</a></li>
                <li>
                   <a href="/home/aboutUs/why.do" class="on">What We Do</a>
                   <ul class="lnb_sub">
                    	<li><a href="/home/aboutUs/why.do">Wealth Management</a></li>
                    	<li><a href="/html/home/h01_what_trading.jsp">Trading</a></li>
                    	<li><a href="/html/home/h01_what_digitalfinance.jsp">Digital Finance</a></li>
                    	<li><a href="/html/home/h01_what_wholesale.jsp">Wholesale</a></li>
                    	<li><a href="/html/home/h01_what_global.jsp">Global</a></li>
                    	<li><a href="/html/home/h01_what_ivbanking.jsp">Investment Banking</a></li>
                    	<li><a href="/html/home/h01_what_iwc.jsp" class="on">IWC</a></li>
                        <!-- <li><a href="/home/aboutUs/whyInvestment.do">Investment Principles</a></li>
                        <li><a href="/home/aboutUs/whyCulture.do">Culture &amp; Values</a></li>
                        <li><a href="/home/aboutUs/whyCore.do">Core Strengths</a></li> -->
                    </ul>
                </li>
                <li><a href="h01_history.jsp">History</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">IWC (Mega-Scale Comprehensive Financial Centers)</h3>
            <strong class="copyTxt_tit">MIRAE ASSET DAEWOO<br />ENGAGES IN A BROARD RANGE OF BUSINESSES.</strong>
        
            <h4 class="cont_subtitle">In 2017, Mirae Asset Daewoo will launch mega-scale comprehensive 
			financial centers called Investment Wealth-management Centers (IWC). 
			These institutions will provide corporate and individual clients 
			with differentiated financial services.</h4>

            <p>IWCs located in Pangyo, Yeouido, Gangnam, Busan, Daegu, Daejeon, and Gwangju will provide comprehensive financial solutions in areas such as pension plans, wealth management, and corporate financing.</p>
            
            <img src="/resources/US/images/img_iwc.gif" alt="mirae asset buildings" class="about_img" />
            
            
             <h4 class="cont_subtitle">Global Brokerage</h4>

            <p>We have Korean equity sales operations in Asia, the United States, and Europe. In addition, we offer overseas equities brokerage platforms in Indonesia, Vietnam, and Hong Kong (for the Shanghai-Hong Kong and Shenzhen-Hong Kong Stock Connect programs). We also provide information on overseas investments based on in-depth research.</p>
            
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>