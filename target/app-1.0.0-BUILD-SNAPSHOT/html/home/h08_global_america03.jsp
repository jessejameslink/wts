<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Colombia | MIRAE ASSET</title>
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
                        <li><a href="h08_global_america03.jsp" class="on">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp">USA</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp">Europe</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Colombia</h3>

            <h4 class="cont_subtitle">Horizons ETFs Management (Latam) (Colombia Rep Office)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3977.1651774546895!2d-74.10268694921812!3d4.564309844078647!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e3f98be20d06297%3A0x9d688c7ebe2c27c0!2zNzEsIENyYS4gNyAjMzQgU3VyLTIxLCBCb2dvdMOhLCDsvZzroazruYTslYQ!5e0!3m2!1sko!2skr!4v1473138245963" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Horizons ETFs Management Latam LLC entered the Colombian market in late 2012 and launched its first ETF in the fall of 2013.</p>
                    <p>We are primarily focused on the further development and expansion of the global exchange traded fund business in Latin America and we have identified the Andean region, specifically Colombia, as a strategic entry point.</p>
                    <p>We believe that the Horizons MILA 40 ETF and other new ETFs we have planned for subsequent launch will help to establish a thriving ETF business in Colombia, one that will bring many benefits to local and international investors alike.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Horizons ETFs Management (Latam) (Colombia Rep Office)</h5>
                <p>Carrera 7 # 71-21 Torre B Oficina 1501 <br />Bogotá, Colombia</p>
                <p class="contacts">
                    <em>Tel :</em>
                    57-1-319-2706
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ftorres@horizonsetfs.com">ftorres@horizonsetfs.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://co.horizonsetfs.com">co.horizonsetfs.com</a>
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