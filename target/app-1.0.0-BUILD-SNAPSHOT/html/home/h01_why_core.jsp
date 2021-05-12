<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Core Strengths | MIRAE ASSET</title>
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
                        <li><a href="h01_why_investment.jsp">Investment Principles</a></li>
                        <li><a href="h01_why_culture.jsp">Culture &amp; Values</a></li>
                        <li><a href="h01_why_core.jsp" class="on">Core Strengths</a></li>
                    </ul>
                </li>
                <li><a href="h01_history.jsp">History</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Core Strengths</h3>

            <h4 class="cont_subtitle">Global Coverage with Roots in the Emerging Markets</h4>
            <p>Rooted in Asia, Mirae Asset has created a global network with a specific focus on emerging markets. This network enables our teams positioned around the globe to capitalize on market-specific investment opportunities efficiently, as and when they arise, so that we can continually meet our clients’ evolving investment requirements.</p>

            <h4 class="cont_subtitle">Diversified Investment Platform</h4>
            <p>Mirae Asset is dedicated to providing innovative products and solutions across major equity, fixed income, ETF and alternative asset classes, delivered through a diverse set of investment vehicles.</p>

            <h4 class="cont_subtitle">An Independent Asset Managemenet Business</h4>
            <p>At Mirae Asset, asset management is at the heart of our business and our independence enables us to focus on what we are best at. We are not tied to any bank dominated financial groups and our ability to formulate differentiated, leading investment products is not constrained by any responsibility to affiliates.</p>

            <h4 class="cont_subtitle">On-the-Ground, Research-driven Investing</h4>
            <p>Research is the core of our business and we recognize its vital importance to long-term successful investing. Our extensive research capabilities and presence across the emerging markets enable us to formulate views that set us apart from the pack. Furthermore, our size and scale gives us access to best in class market data and insight that we utilize to constantly evaluate our own independently formed investment decisions.</p>

            <h4 class="cont_subtitle">Risk Management and Compliance Structure</h4>
            <p>Research is the core of our business and we recognize its vital importance to long-term successful investing. Our extensive research capabilities and presence across the emerging markets enable us to formulate views that set us apart from the pack. Furthermore, our size and scale gives us access to best in class market data and insight that we utilize to constantly evaluate our own independently formed investment decisions.</p>

            <ol class="risk_mng">
                <li>
                    <p>Defining Risk Factors &amp;<br /> Set Up Risk Controls</p>
                    <ul>
                        <li>Define risk factors for measuring market risk, liquidity risk etc. and set up various risk controls</li>
                        <li>Examine and set up investment guidelines</li>
                        <li>Analyze risk factors at product development stage</li>
                    </ul>
                </li>
                <li>
                    <p>Monitoring &amp;<br />Communication</p>
                    <ul>
                        <li>Monitor risk factors and indicators</li>
                        <li>Performance analysis and risk assessment</li>
                        <li>Communicate with investment management teams and senior management</li>
                    </ul>
                </li>
                <li>
                    <p>Reporting &amp;<br />Decision Making</p>
                    <ul>
                        <li>Report risk and perfomance issues</li>
                        <li>Monitor implementation of the Risk Mgt. Committee decisions</li>
                        <li>Request a breach report if required</li>
                    </ul>
                </li>
            </ol>

        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>