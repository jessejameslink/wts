<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Canada | MIRAE ASSET</title>
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
                        <li><a href="h08_global_asia01.jsp">Australia</a></li>
                        <li><a href="h08_global_asia02.jsp">China</a></li>
                        <li><a href="h08_global_asia03.jsp">Hong Kong</a></li>
                        <li><a href="h08_global_asia04.jsp">India</a></li>
                        <li><a href="h08_global_asia05.jsp">Korea</a></li>
                        <li><a href="h08_global_asia06.jsp">Taiwan</a></li>
                        <li><a href="h08_global_asia07.jsp">Vietnam</a></li>
                    </ul>
                </li>
                <li>
                    <a href="h08_global_america01.jsp" class="on">Americas</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_america01.jsp">Brazil</a></li>
                        <li><a href="h08_global_america02.jsp" class="on">Canada</a></li>
                        <li><a href="h08_global_america03.jsp">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp">USA</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp">Europe</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Canada</h3>

            <h4 class="cont_subtitle">Horizons ETFs Management (Canada) Inc.</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2886.991881011196!2d-79.37800484873242!3d43.64833726066038!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89d4cb2df31d0909%3A0x392373a9d3707e2f!2zMjYgV2VsbGluZ3RvbiBTdCBFICM3MDAsIFRvcm9udG8sIE9OIE01RSAxUzIg7LqQ64KY64uk!5e0!3m2!1sko!2skr!4v1473138072289" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Horizons ETFs Management (Canada) Inc., formerly BetaPro Management Inc., manages the Horizons Exchange Traded Funds Inc. (“Horizons ETFs”) family of ETFs of Mirae Asset Global Investments.</p>
                    <p>The Horizons ETFs family of ETFs includes a broadly diversified range of investment tools with solutions for investors of all experience levels to meet their investment objectives in a variety of market conditions</p>
                    <p>We believe that every investor, regardless of portfolio size, should have access to the best investment strategies and money managers at the best possible price. Our Canadian suite of exchange traded funds includes innovative tools and solutions for tactical trading, index exposure, and active management.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Horizons ETFs Management (Canada)</h5>
                <p>26 Wellington Street E., Suite 700/608, Toronto, Ontario, M5E 1S2</p>
                <p class="contacts">
                    <em>Tel :</em>
                    866-299-7929
                    <br />
                    <em>Website :</em>
                    <a href="http://www.horizonsetfs.com">www.horizonsetfs.com</a>
                </p>
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