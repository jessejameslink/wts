<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Why Mirae Asset | MIRAE ASSET</title>
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
                        <li><a href="h01_why_core.jsp">Core Strengths</a></li>
                    </ul>
                </li>
                <li><a href="h01_history.jsp">History</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Why Mirae Asset</h3>
            <h4 class="cont_subtitle">Mirae Asset Global Investments is one of the world’s most prominent emerging market investors and one of Asia’s largest independent financial services groups.</h4>
            <p>As emerging market experts with a global perspective, we pursue excellence in investment management to help our clients achieve their long-term objectives.</p>
            <p class="total_aum">As of March 31, 2016, our total AUM stood at US$ 83 billion.</p>

            <img src="/resources/US/images/img_why01.jpg" alt="mirae asset buildings" class="about_img" />

            <h4 class="cont_subtitle">A Global Perspective With Local Expertise</h4>
            <p>Mirae Asset Global Investments is a global investment management firm originating from Asia with offices, clients and business lines across the world's major markets (Australia, Brazil, Canada, China, Colombia, Hong Kong, India, Korea, Taiwan, the U.K., the United States and Vietnam). We provide asset management services through a diversified platform that offers market-leading franchises in traditional equity and fixed income products, ETFs and alternative strategies such as real estate, private equity and hedge funds.</p>
            <h4 class="cont_subtitle">Client Focus</h4>
            <p>We have a singular, overriding focus and that is assisting our clients to best achieve their long-term financial objectives. We devote all our considerable global resources to performing in-depth, bottom-up research to fulfill our promise of offering best in class investment products and building lasting relationships with our partners. As we continue to expand into new markets we look forward to serving new clients as we have always done, by building on principles.</p>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>