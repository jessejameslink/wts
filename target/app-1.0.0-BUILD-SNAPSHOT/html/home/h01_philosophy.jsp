<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Philosophy | MIRAE ASSET</title>
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
                <li><a href="h01_philosophy.jsp" class="on">Philosophy</a></li>
                <li>
                    <a href="h01_why.jsp">Why Mirae Asset</a>
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
            <h3 class="cont_title">Philosophy</h3>
            <div class="plsp_header">
                <div>
                    <h4>Originating from Asia,</h4>
                    <p>Mirae Asset was founded in 1997 in the wake of the Asian currency crisis. Today, Mirae Asset encompasses the global capability to deliver our best ideas to investors around the world via <span class="em">on-the-ground presence in 12 countries across 5 continents</span>. Our goal is to provide our clients with insightful financial strategies and consistent performance through our diversified product offering.</p>
                </div>
            </div>
            <h4 class="cont_subtitle">BUSINESS PHILOSOPHY</h4>
            <p>Putting our clients’ needs first, we aspire to be a consistent partner. Business philosophy is what guides us and is a never-changing value of Mirae Asset.
            <br />
            <span class="em">We value our people and embrace the future with an open mind.</span>
            </p>
            <h4 class="cont_subtitle">VISION</h4>
            <p>Our renewed vision, announced in June 2012, presents our evolving role and strategy beyond the emerging market boundaries, as a global investment company.
            <br />
            <span class="em">As emerging market experts with a global perspective, we pursue excellence in investment management to help our clients achieve their long-term objectives.</span>
            </p>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>