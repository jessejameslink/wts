<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Investment Principles | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/US/css/miraeasset.css">
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
                    <a href="h01_why.jsp" class="on">Why Mirae Asset</a>
                    <ul class="lnb_sub">
                        <li><a href="h01_why_investment.jsp" class="on">Investment Principles</a></li>
                        <li><a href="h01_why_culture.jsp">Culture &amp; Values</a></li>
                        <li><a href="h01_why_core.jsp">Core Strengths</a></li>
                    </ul>
                </li>
                <li><a href="h01_history.jsp">History</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Investment Principles</h3>
            <h4 class="cont_subtitle">OUR PRINCIPLES ARE OUR PROMISE</h4>
            <p>Mirae Asset’s Investment Principles are consistent. All Mirae Asset employees should have a clear understanding of our Investment Principles and put into practice for all business activities. Our investment Principle is a promise to our clients and should be firmly adhered to at all times.</p>

            <h5 class="bullet_title">MIRAE ASSET identifies the sustainable competitiveness of companies</h5>
            <p class="bullet_padding">At MIRAE ASSET we seek companies with specific qualities ­– such as a commanding market share, comparative advantages to competitors, a differentiated business model and high levels of transparency and corporate governance. We believe that the companies that exhibit these qualities will sustain their competitiveness and provide continuous and stable earnings growth. It is our long-held belief that share prices will, over time, converge with earnings growth and the subsequent cash flow.</p>

            <h5 class="bullet_title">MIRAE ASSET invests with a long-term perspective</h5>
            <p class="bullet_padding">A long-term perspective is key when determining sustainable competitiveness. Though share prices may be volatile over the short-term, long-term price movements are driven mainly by earnings growth. Investing in companies that are intrinsically competitive and generate stable cash flow is the essence of MIRAE ASSET’s long-term approach to investment.</p>

            <h5 class="bullet_title">MIRAE ASSET assesses investment risks with expected return</h5>
            <p class="bullet_padding">At MIRAE ASSET every investment risk is assessed with expected return. Valuations, liquidity and corporate governance are constantly monitored for their potential to inflict damage on long-term competitiveness. It is our aim to limit our exposure to such investment risk while our Risk Management Division constantly monitors whether our investments adhere to our investment principles.</p>

            <h5 class="bullet_title">MIRAE ASSET values a team-based approach to decision-making</h5>
            <p class="bullet_padding">MIRAE ASSET’s portfolio creation and successful investment management is achieved through a team-based approach to decision-making, with extensive discussion and a firm commitment to firmly adhere to our investment principles and process.</p>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>