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
                    	<li><a href="/html/home/h01_what_trading.jsp" class="on">Trading</a></li>
                    	<li><a href="/html/home/h01_what_digitalfinance.jsp">Digital Finance</a></li>
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
            <h3 class="cont_title">Trading</h3>
            <strong class="copyTxt_tit">Mirae Asset Daewoo<br />engages in a broad range of businesses.</strong>
            <!-- <img src="/resources/HOME/images/img_why01.jpg" alt="mirae asset buildings" class="about_img" /> -->
            
            <h4 class="cont_subtitle">Mirae Asset Daewoo’s team of independent investment professionals trades assets linked with our financial product lineup and strives to generate steady returns through proprietary trading.</h4>
            <p>In order to satisfy the varying investment needs of both individual and institutional investors, we have developed a wide array of financial products such as repurchase agreements (RP) and derivative-linked products (ELS, DLS), which offer attractive opportunities to clients and, at the same time, provide hedging opportunities via the trading of underlying assets.</p>
            <p>Leveraging our expansive capital base, we engage in proprietary trading (short-term trading of stocks, bonds, foreign currencies, commodities, and derivatives) and alternative investments (real estate, etc.) to secure stable capital gains.</p>
            
            <h4 class="cont_subtitle">Product-Linked Trading</h4>
            <p>We have developed a variety of derivative-linked products (ELS, DLS) and exchange-traded notes (ETN) with various underlying assets (e.g., stocks, indices, foreign currencies, credit, and commodities), targeting clients seeking medium-risk, medium-return investments in the current ultra-low interest rate environment. These products offer attractive investment opportunities to our clients and also promote increased stability (via the trading of underlying assets).</p>
            <p>We also provide our clients with short-term fixed interest directly or via cash management accounts (CMA) by managing RP assets.</p>
            
            <h4 class="cont_subtitle">Principal Investment</h4>
            <p>Leveraging our expansive global network, we invest in promising properties and competitive companies at home and abroad from a medium- to long-term perspective. These activities, coupled with robust risk management, allow us to generate stable earnings and capital gains.</p>
            <p>In addition, Mirae Asset Daewoo's prop trading business pursues steady capital gains via advanced trading methods in the bond, currency, commodities, and derivatives markets.</p>
            
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>