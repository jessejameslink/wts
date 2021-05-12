<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>History | MIRAE ASSET</title>
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
            <h2>About Us</h2>
            <ul>
                <li><a href="h01_philosophy.jsp">Philosophy</a></li>
                <li>
                    <a href="h01_why.jsp">Why Mirae Asset</a>
                    <ul class="lnb_sub">
                        <li><a href="h01_why_investment.jsp">Investment Principles</a></li>
                        <li><a href="h01_why_culture.jsp">Culture &amp; Values</a></li>
                        <li><a href="h01_why_core.jsp">Core Strengths</a></li>
                    </ul>
                </li>
                <li><a href="h01_history.jsp" class="on">History</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">History</h3>

            <div class="history">
                <h4>2015</h4>
                <ol>
                    <li>
                        <p class="date">16 / 12 / 2015</p>
                        <p>SSC approved the conversion of corporate structure of the Company to One Member Limited Liability Company; so that the Company shall become one of the first 100% foreign owned securities company in Vietnam</p>
                    </li>
                    <li>
                        <p class="date">23 / 11 / 2015</p>
                        <p>SSC approved the share transfer transactions for Mirae Asset Wealth Management (HK) Limited to wholly own charter capital of the Company.</p>
                    </li>
                    <li>
                        <p class="date">15 / 04 / 2015</p>
                        <p>Company name was changed to Mirae Asset Wealth Management Securities (Vietnam) JSC</p>
                    </li>
                </ol>

                <h4>2013</h4>
                <ol>
                    <li>
                        <p class="date">18 / 08 / 2013</p>
                        <p>Appointment of new GD / legal representative</p>
                    </li>
                </ol>

                <h4>2011</h4>
                <ol>
                    <li>
                        <p class="date">10 / 03 / 2011</p>
                        <p>Head Office change location<br />New Location : Saigon Royal Building ,Ground Floor, 91 Pasteur, Dist. 1, Ho Chi Minh City</p>
                    </li>
                </ol>

                <h4>2009</h4>
                <ol>
                    <li>
                        <p class="date">02 / 03 / 2009</p>
                        <p>Hanoi Branch was established<br />Location : 4th Floor, 27 Hang Bai, Hoan Kiem Distric, Ha Noi City</p>
                    </li>
                    <li>
                        <p class="date">08 / 04 / 2009</p>
                        <p>Company name was changed to Mirae Asset Securities (Vietnam) JSC</p>
                    </li>
                </ol>

                <h4>2007</h4>
                <ol>
                    <li>
                        <p class="date">18 / 12 / 2007</p>
                        <p>Mirae Asset Securities establishment<br />Chartered Capital : 300.000.000.000 VND<br />Location : No.1-5 Le Duan, Petro Vietnam Tower, Distric 1, Ho Chi Minh City</p>
                    </li>
                </ol>
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