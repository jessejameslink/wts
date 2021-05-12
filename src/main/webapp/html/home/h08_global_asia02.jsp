<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>China | MIRAE ASSET</title>
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
                    <a href="h08_global_asia01.jsp" class="on">Asia Pacific</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_asia01.jsp">Australia</a></li>
                        <li><a href="h08_global_asia02.jsp" class="on">China</a></li>
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
                <li><a href="h08_global_eu01.jsp">Europe</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">China</h3>

            <h4 class="cont_subtitle">Mirae Asset Global Investments - Shanghai Representative Office</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3411.483156814836!2d121.49828635100883!3d31.235045568209003!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x35b270f0743bfdbf%3A0xe65f2f01d6d53a38!2sMirae+Asset+Tower!5e0!3m2!1sko!2skr!4v1473135947493" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>
                <div class="desc">
                    <p>Mirae Asset Global Investments has a footprint in three local offices in China, serving diverse needs. Our representative office in Shanghai was established in 2007 and Mirae Asset Yicai Investment Consulting opened in 2009. Mirae Asset Hauchen Fund Management, our joint-venture with a local trust company, commenced in 2012.</p>
                    <p>Our Shanghai Representative Office is responsible for our real estate projects in China, most notably the landmark Mirae Asset Shanghai Tower. Mirae Asset Yicai Investment Consulting provides on-the-ground insight into the local financial landscape in mainland China as well as spearheading our QFII operations. Mirae Asset Hauchen Fund Management, our joint-venture with a local fund manager, seeks to cater to needs of the ever-increasing local investors in China.</p>
                    <p>Our goal is to provide investors with access to the Chinese capital and real estate markets for local and foreign investors through various financial vehicles.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Mirae Asset Global Investments (China)</h5>
                <p>5th Floor, Mirae Asset Tower, 166 Lujazui Ring Road, Pudong, Shanghai, China, 200120</p>
                <p class="contacts">
                    <em>Tel :</em>
                    86-21-3135-2088
                </p>

                <h5 class="sec_title">Mirae Asset Huachen Fund Management Co., Ltd</h5>
                <p class="contacts">
                    <em>Tel :</em>
                    86-21-26066812
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:miraechina@hcmiraeasset.com">miraechina@hcmiraeasset.com</a>
                </p>

                <h5 class="sec_title">YiCai Investment Consulting</h5>
                <p class="contacts">
                    <em>Tel :</em>
                    86-21-3135-2083
                    <br />
                    <em>E-mail :</em><a href="mailto:ContactUs.Shanghai@MiraeAsset.com">ContactUs.Shanghai@MiraeAsset.com</a>
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