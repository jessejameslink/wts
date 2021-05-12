<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Institutional Brokerage | MIRAE ASSET</title>
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
            <h2>Products<br />&amp; Services</h2>
            <ul>
                <li><a href="h02_individual.jsp">Individual Brokerage</a></li>
                <li><a href="h02_institutional.jsp" class="on">Institutional Brokerage</a></li>
                <li><a href="h02_wealth.jsp">Wealth Management</a></li>
                <li><a href="h02_investment.jsp">Investment Banking</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Institutional Brokerage</h3>
             <div class="bg_subcont_02 img_02">
             	<p>
             		The Company provides a special range of services that help maximize value for institutional investors include software, investment research, charts, newsletters, seminars, conferences, block trading services, meeting with listed companies ...
             	</p>
             	<p>
             		Institutional investors shall always be connected with the research analysts of the Company through our highly experienced brokers with professional assistance from our research department
             	</p>
             </div>
        </div>

    </div>
</div>
<!-- // container : 서브페이지 컨텐츠 -->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>