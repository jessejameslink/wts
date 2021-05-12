<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Global Network | MIRAE ASSET</title>
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
            <h2>Global<br />Network</h2>
            <ul>
                <li>
                    <a href="h08_global_asia01.jsp">Asia Pacific</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_asia02.jsp">Australia</a></li>
                        <li><a href="h08_global_asia03.jsp">China</a></li>
                        <li><a href="h08_global_asia04.jsp">Hong Kong</a></li>
                        <li><a href="h08_global_asia05.jsp">India</a></li>
                        <li><a href="h08_global_asia06.jsp">Korea</a></li>
                        <li><a href="h08_global_asia07.jsp">Taiwan</a></li>
                        <li><a href="h08_global_asia08.jsp">Vietnam</a></li>
                    </ul>
                </li>
                <li>
                    <a href="h08_global_america01.jsp">Americas</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_america01.jsp">Brazil</a></li>
                        <li><a href="h08_global_america02.jsp">Canada</a></li>
                        <li><a href="h08_global_america03.jsp">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp">USA</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp">Europe</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Global Network</h3>

            <div class="global_main">
                <p class="title">
                    We are a global organization originating from Asia with<br />
                    <span class="em">on-the-ground presence in the markets in which we invest.</span>
                </p>
                <p>Mirae Asset’s presence now extends far beyond the capital markets of the Asia Pacific region to the major developed markets across the globe. Our offices are strategically situated across 12 countries, from Hong Kong, China, India and the USA to the UK. This global network of offices enables us to successfully diversify the risks in our portfolios and identify and secure sources of future return.</p>
                <p>Explore the regions of our different office locations to view what we may offer to our clients.</p>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>