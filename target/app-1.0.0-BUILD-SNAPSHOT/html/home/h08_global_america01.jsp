<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Brazil | MIRAE ASSET</title>
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
                        <li><a href="h08_global_america01.jsp" class="on">Brazil</a></li>
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
            <h3 class="cont_title">Brazil</h3>

            <h4 class="cont_subtitle">Mirae Asset Global Investments (Brazil)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3656.2445183506156!2d-46.68659034893963!3d-23.595562068667228!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x94ce57445377e583%3A0x9de1a4c3393afcb!2sMirae+Asset+Global+Investimentos!5e0!3m2!1sko!2skr!4v1473137945225" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Mirae Asset Global Investments (Brazil) was established in 2008 and has underscored our presence in the Latin American region.</p>
                    <p>We intend to leverage on our emerging markets expertise and global presence in order to discover investment opportunities and provide our clients with the best investment solutions. In addition to providing capabilities across traditional asset classes, we are also fully proficient in multi- and macro strategy solutions alongside alternative investments, notably in real estate.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">CONTACT INFO</h4>

            <div class="global_contact">
                <h5 class="sec_title">Mirae Asset Global Investments (Brazil)</h5>
                <p>Rua Olimpiadas, 194/200, 12 andar, CJ 121<br />Vila Olimpia – Sao Paulo – SP – Brazil. CEP 045551-000</p>
                <p class="contacts">
                    <em>Tel :</em>
                    55-11-2608-8500
                    <br />
                    <em>E-mail :</em>
                    ContactUs.Brazil@MiraeAsset.com
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.com.br/en">investments.miraeasset.com.br/en</a>
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