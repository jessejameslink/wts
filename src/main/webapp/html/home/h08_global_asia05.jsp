<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Korea | MIRAE ASSET</title>
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
                        <li><a href="h08_global_asia05.jsp" class="on">Korea</a></li>
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
            <h3 class="cont_title">Korea</h3>

            <h4 class="cont_subtitle">MIRAE ASSET Global Investments</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3162.4800915163014!2d126.98301095112973!3d37.56731123174159!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x357ca2ef41d06591%3A0x5605f7fca752bb5c!2sRegus+Seoul!5e0!3m2!1sko!2skr!4v1473136854795" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Mirae Asset Global Investments was established in 1997 and has been recognized as a pioneer in the Korean financial services industry.</p>
                    <p>Mirae Asset Global Investments is the asset management arm of Mirae Asset Financial Group and executes the firm’s core passion of investing in emerging markets. We work across our entire financial services platform to generate the most benefit for our clients.</p>
                    <p>As emerging market experts with a global perspective, we pursue excellence in investment management to help our clients achieve their long-term objectives.</p>
                </div>
            </div>

            <h5 class="sec_title">TIGER ETFs</h5>
            <p>The inception of TIGER ETFs occurred in 2006 when Mirae Asset Global Investments launched the first ETF under the brand.We have continuously introduced and managed a variety of new ETF products into the Korea market including global, sector, regional, thematic and style ETFs.</p>
            <p>Although an increasing number of ETF providers have recently emerged, we have been at the forefront of educating the investor community on ETFs and boosting the domestic ETF market.</p>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Mirae Asset Global Investments</h5>
                <p>East Tower 36F, Mirae Asset CENTER1 Bldg, 67, Suha-dong, Jung-gu, Seoul, Korea (100-210)</p>
                <p class="contacts">
                    <em>Tel :</em>
                    82-2-3774-2222
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ContactUs.Korea@MiraeAsset.com">ContactUs.Korea@MiraeAsset.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.com">investments.miraeasset.com</a>
                </p>

                <h5 class="sec_title">TIGER ETFs</h5>
                <p>East Tower 36F, Mirae Asset CENTER1 Bldg, 67, Suha-dong, Jung-gu, Seoul, Korea (100-210)</p>
                <p class="contacts">
                    <em>Tel :</em>
                    82-2-3774-2297
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:gmsd@miraeasset.com">gmsd@miraeasset.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://www.tigeretf.com/eng/index.do">www.tigeretf.com/eng/index.do</a>
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