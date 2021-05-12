<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>United Kingdom | MIRAE ASSET</title>
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
                    <a href="h08_global_america01.jsp">Americas</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_america01.jsp">Brazil</a></li>
                        <li><a href="h08_global_america02.jsp">Canada</a></li>
                        <li><a href="h08_global_america03.jsp">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp">USA</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp" class="on">Europe</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">United Kingdom</h3>

            <h4 class="cont_subtitle">Mirae Asset Global Investments (United Kingdom)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2482.985870474699!2d-0.08883704852495054!3d51.5134752179798!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x4876035314323627%3A0xca81f83df604d366!2s6+Royal+Exchange%2C+London+EC3V+3NL+%EC%98%81%EA%B5%AD!5e0!3m2!1sko!2skr!4v1473138574044" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Mirae Asset Global Investments (United Kingdom) was established in 2007, signifying our entry into Europe.</p>
                    <p>Our presence in the United Kingdom underscores our determination to establish a strong presence in the global financial markets by building a European distribution platform and to further solidify our position as an emerging market specialist.</p>
                    <p>We aim to deliver value to our clients in the United Kingdom and throughout Europe with our equity and fixed income cross-border offerings.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Mirae Asset Global Investments (United Kingdom)</h5>
                <p>4-6 Royal Exchange Building London, EC3V 3NL</p>
                <p class="contacts">
                    <em>Tel :</em>
                    44-020-7715-9900
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ContactUs.UK@MiraeAsset.com">ContactUs.UK@MiraeAsset.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.eu">investments.miraeasset.eu</a>
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