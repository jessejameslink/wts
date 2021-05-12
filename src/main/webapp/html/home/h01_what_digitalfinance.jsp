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
                    	<li><a href="/html/home/h01_what_digitalfinance.jsp" class="on">Digital Finance</a></li>
                    	<li><a href="/html/home/h01_what_wholesale.jsp">Wholesale</a></li>
                    	<li><a href="/html/home/h01_what_global.jsp">Global</a></li>
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
            <h3 class="cont_title">Digital Finance</h3>
            <strong class="copyTxt_tit">Mirae Asset Daewoo<br />engages in a broad range of businesses.</strong>
            <!-- <img src="/resources/HOME/images/img_why01.jpg" alt="mirae asset buildings" class="about_img" /> -->
            
            <h4 class="cont_subtitle">Mirae Asset Daewoo provides state-of-the-art digital financial services to our clients. We are committed to helping clients secure asset growth and comfortable retirements with a plethora of digital wealth management solutions.</h4>
            <p>Mirae Asset Daewoo offers services and products-encompassing global asset allocation, financial products, and pension plans-optimized for our clients' diverse financial needs. To help clients meet their investment goals, we provide a comprehensive investment platform (including home and mobile trading systems) and differentiated services based on big data.</p>
            
            <h4 class="cont_subtitle">Competitive Investment Solutions</h4>
            <p>To provide on-the-spot comprehensive financial services, we have launched a wide array of investment solutions. Our highly regarded KAIROS home trading system remains the industry standard, and we made history with Smart Neo, Korea’s first mobile trading system. These two systems have won broad praise for their ease of use and investment content, and moreover, we are developing advanced global asset allocation solutions.</p>
            
            <h4 class="cont_subtitle">Differentiated Customer Service</h4>
            <p>Drawing upon big data analysis, we offer extensive investment information on topics ranging from global investments to complex financial products and pension plans. We also provide financial services optimized for individual investors, including customized product recommendations.</p>
            
            <h4 class="cont_subtitle">Leading Innovation in Digital Finance</h4>
            <p>We are committed to identifying innovative digital financial models and developing differentiated financial services. In the rapidly changing market environment, we provide our clients with an entirely new financial experience through groundbreaking digital solutions.</p>
            
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>