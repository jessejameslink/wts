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
                    	<li><a href="/html/home/h01_what_wholesale.jsp" class="on">Wholesale</a></li>
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
            <h3 class="cont_title">Wholesale</h3>
            <strong class="copyTxt_tit">Mirae Asset Daewoo<br />engages in a broad range of businesses.</strong>
            <!-- <img src="/resources/HOME/images/img_why01.jpg" alt="mirae asset buildings" class="about_img" /> -->
            
            <h4 class="cont_subtitle">We offer comprehensive financial solutions that meet the evolving needs of institutional investors and corporations at home and abroad, providing research on equities, fixed income, derivatives, and other investment products as well as a variety of timely strategies.</h4>
            
            <h4 class="cont_subtitle">Equity Brokerage</h4>
            <p>Widely regarded as one of the top equity brokerages in Korea, we assist domestic institutional investors in making and implementing the best investment decisions based on our differentiated client service, high-quality research, and stable execution.</p>
            
            <h4 class="cont_subtitle">Derivatives-linked Products</h4>
            <p>We provide top-notch service in brokering domestic and foreign derivatives, creating and redeeming exchange-traded funds (ETF), and serving as a liquidity provider for ETFs and derivatives-linked products. We continue to strengthen our product development and brokering capabilities, operating a Delta One trading desk for our domestic and foreign clients and implementing strategies such as index swaps.</p>
            
            <h4 class="cont_subtitle">Fixed-Income Brokerage</h4>
            <p>We have established a strong reputation as one of the best fixed-income brokerages in the country by providing clear guidance on domestic and global interest rates and excellent client service to institutional investors. We are moving beyond borders to become a leading global fixed-income brokerage by enhancing our capabilities in brokering foreign bonds for a number of central banks and institutional investors abroad.</p>
            
            <h4 class="cont_subtitle">Financial Products</h4>
            <p>We offer a broad range of financial products to domestic institutional investors and corporations, including trusts, wrap accounts, mutual funds, derivatives-linked products, and alternative investments, most notably real estate and aircraft funds. We are continuously striving to identify new products tailored to client needs in order to provide the best wealth management solutions.</p>
            
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>