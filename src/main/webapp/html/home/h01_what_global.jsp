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
                <li><a href="/home/aboutUs/philosophy.do">Vision and Philosophy</a></li>
                <li>
                    <a href="/home/aboutUs/why.do" class="on">What We Do</a>
                    <ul class="lnb_sub">
                    	<li><a href="/home/aboutUs/why.do">Wealth Management</a></li>
                    	<li><a href="/html/home/h01_what_trading.jsp">Trading</a></li>
                    	<li><a href="/html/home/h01_what_digitalfinance.jsp">Digital Finance</a></li>
                    	<li><a href="/html/home/h01_what_wholesale.jsp">Wholesale</a></li>
                    	<li><a href="/html/home/h01_what_global.jsp" class="on">Global</a></li>
                    	<li><a href="/html/home/h01_what_ivbanking.jsp">Investment Banking</a></li>
                    	<li><a href="/html/home/h01_what_iwc.jsp">IWC</a></li>
                        <!-- <li><a href="/home/aboutUs/whyInvestment.do">Investment Principles</a></li>
                        <li><a href="/home/aboutUs/whyCulture.do">Culture &amp; Values</a></li>
                        <li><a href="/home/aboutUs/whyCore.do">Core Strengths</a></li> -->
                    </ul>
                </li>
                <li><a href="/home/aboutUs/history.do">History</a></li>
                <!-- <li><a href="/home/aboutUs/career.do">Careers</a></li> -->
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Global</h3>
            <strong class="copyTxt_tit">Mirae Asset Daewoo<br />engages in a broad range of businesses.</strong>
            <!-- <img src="/resources/HOME/images/img_why01.jpg" alt="mirae asset buildings" class="about_img" /> -->
            
            <h4 class="cont_subtitle">As a group of independent investment professionals, Mirae Asset Daewoo utilizes its superior worldwide network to seek opportunities across a wide range of quality global assets, providing attractive products to clients.</h4>
            <p>Among domestic financial players, we have taken the most aggressive approach in overseas markets, engaging in global brokerage, investment banking, and trading businesses with 600 employees in nine foreign countries. In addition, we are enhancing our global competitiveness by implementing specialized regional strategies and launching financial products based on overseas assets tailored to the needs of our domestic clients.</p>
            
            <h4 class="cont_subtitle">Global Investment Banking</h4>
            <p>We offer domestic investors access to a wide range of global opportunities, developing a vast pool of investment vehicles based on our deep experience in principal and alternative investments in quality global assets. In China, we bridge the gap on cross-border M&A deals and provide advisory services. We also engage in investment banking activities in Indonesia and Vietnam. To strengthen our footholds in these markets, we are bolstering our wholesale and fixed-income sales businesses.</p>
            
            <h4 class="cont_subtitle">Global Brokerage</h4>
            <p>We have Korean equity sales operations in Asia, the United States, and Europe. In addition, we offer overseas equities brokerage platforms in Indonesia, Vietnam, and Hong Kong (for the Shanghai-Hong Kong and Shenzhen-Hong Kong Stock Connect programs). We also provide information on overseas investments based on in-depth research.</p>            
            
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>