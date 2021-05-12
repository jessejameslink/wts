<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Hong Kong | MIRAE ASSET</title>
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
                        <li><a href="h08_global_asia03.jsp" class="on">Hong Kong</a></li>
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
            <h3 class="cont_title">Hong Kong</h3>

            <h4 class="cont_subtitle">Mirae Asset Global Investments (Hong Kong)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3692.0245475598963!2d114.1660929508802!3d22.277059949294873!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3404005d5e6a93df%3A0xddeffbb5de78bec!2sThe+Executive+Centre!5e0!3m2!1sko!2skr!4v1473136282315" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Mirae Asset Global Investments (Hong Kong) was established in 2003 and serves as the hub of Asia for Mirae Asset Global Investments.</p>
                    <p>We manage equity products that invest in the Asia Pacific region, including single country and regional equity funds. The office is also the distribution center for retail and institutional investors based in the Greater China and Southeast Asia regions.</p>
                    <p>From our strategic position in Hong Kong, we strive to offer worldwide investors best-in-class cross-border Asia equity and global / emerging market fixed income funds.</p>
                </div>
            </div>

            <h5 class="sec_title">Horizons Exchange Traded Funds</h5>
            <p>The Horizons Exchange Traded Funds brand of Mirae Asset Global Investments (Hong Kong) launched its first ETF in 2011.We are dedicated to offering Asia-focused and exceptionally cost-effective ETFs to our clients. We will continue to efficiently capture investment opportunities around the world, strengthen our aptitude for innovation and create products to meet the evolving needs of our investors in Hong Kong.</p>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Mirae Asset Global Investments (Hong Kong)</h5>
                <p>Level 15, Three Pacific Place, 1 Queen’s Road East</p>
                <p class="contacts">
                    <em>Tel :</em>
                    852-2295-1500
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ContactUs.HongKong@MiraeAsset.com">ContactUs.HongKong@MiraeAsset.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.com.hk">investments.miraeasset.com.hk</a>
                </p>

                <h5 class="sec_title">Horizons Exchange Traded Funds</h5>
                <p>Level 15, Three Pacific Place, 1 Queen’s Road East, Hong Kong, HK </p>
                <p class="contacts">
                    <em>Tel :</em>
                    852-2295-1500
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:etf@horizonsetfs.com.hk">etf@horizonsetfs.com.hk</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://www.horizonsetfs.com.hk">www.horizonsetfs.com.hk</a>
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