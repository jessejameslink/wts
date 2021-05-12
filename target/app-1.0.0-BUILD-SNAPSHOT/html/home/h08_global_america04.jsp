<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>USA | MIRAE ASSET</title>
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
                        <li><a href="h08_global_america02.jsp">Canada</a></li>
                        <li><a href="h08_global_america03.jsp">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp" class="on">USA</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp">Europe</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">USA</h3>

            <h4 class="cont_subtitle">Mirae Asset Global Investments (USA)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3021.9774345202213!2d-73.97995544880035!3d40.762521042358365!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c258f98fb5db9f%3A0xbdecfcf0adc4c4f2!2s1350+6th+Ave%2C+New+York%2C+NY+10019!5e0!3m2!1sko!2skr!4v1473138428563" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Established in 2008, Mirae Asset Global Investments (USA) is a Registered Investment Advisor firm committed to providing clients with global access to investment opportunities around the world.</p>
                    <p>We focus on emerging markets and active, bottom-up Asia-centric strategies that leverage our emerging market heritage and on-the-ground presence to deliver high-conviction portfolios and quality long-term performance. Our aim is to deliver tailored solutions through the use of retail mutual funds and institutional separate accounts focusing on our emerging market expertise.</p>
                </div>
            </div>

            <h5 class="sec_title">Horizons ETFs Management (USA)</h5>

            <p>Established in 2012, Horizons ETFs Management (USA) LLC (“Horizons ETFs”) is a registered investment adviser acting as sub-adviser to the Horizons products trading on the New York Stock Exchange (NYSE : HSPX). We strive to offer innovative ETF solutions for our clients with index exposure to a range of sectors and regions as we continue to build out our suite of offerings. Our goal is to capitalize on our expanding range of ETFs and demonstrate commitment to our valued investors in the American market.</p>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Mirae Asset Global Investments (USA)</h5>
                <p>1350 Avenue of the Americas, 33rd Floor, New York, NY, 10019, USA</p>
                <p class="contacts">
                    <em>Tel :</em>
                    1-212-205-8300
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ContactUs.US@MiraeAsset.com">ContactUs.US@MiraeAsset.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.us">investments.miraeasset.us</a>
                </p>

                <h5 class="sec_title">Horizons ETFs Management (USA)</h5>
                <p>1350 Avenue of the Americas, 33rd Floor, New York, NY, 10019, USA</p>
                <p class="contacts">
                    <em>Tel :</em>
                    1-212-205-8381
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:jcunningham@horizonsetfs.com">jcunningham@horizonsetfs.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://us.horizonsetfs.com">us.horizonsetfs.com</a>
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