<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Taiwan | MIRAE ASSET</title>
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
                        <li><a href="h08_global_asia02.jsp">China</a></li>
                        <li><a href="h08_global_asia03.jsp">Hong Kong</a></li>
                        <li><a href="h08_global_asia04.jsp">India</a></li>
                        <li><a href="h08_global_asia05.jsp">Korea</a></li>
                        <li><a href="h08_global_asia06.jsp" class="on">Taiwan</a></li>
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
            <h3 class="cont_title">Taiwan</h3>

            <h4 class="cont_subtitle">Mirae Asset Global Investments (Taiwan)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3614.4320811386624!2d121.5462822509147!3d25.053340343590357!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3442abe8781b9a97%3A0x395ace974e621a25!2sNo.+102%2C+Dunhua+N+Rd%2C+Songshan+District%2C+Taipei+City%2C+%EB%8C%80%EB%A7%8C+105!5e0!3m2!1sko!2skr!4v1473137518451" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>To strengthen our presence in Greater China, Mirae Asset Global Investments acquired TLG Asset Management in 2011, which has since been rebranded to Mirae Asset Global Investments (Taiwan).</p>
                    <p>Mirae Asset Global Investments (Taiwan) has the capabilities to provide both onshore and offshore funds to local investors. The entity will seek to bolster its existing range of onshore products while continuing to offer market-leading offshore solutions.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Mirae Asset Global Investments (Taiwan)</h5>
                <p>6F, No. 42, Zhongshan N. St, Taipei city 10445, Taiwan</p>
                <p class="contacts">
                    <em>Tel :</em>
                    886-2-7725-7555
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ContactUs.Taiwan@MiraeAsset.com">ContactUs.Taiwan@MiraeAsset.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.com.tw">investments.miraeasset.com.tw</a>
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