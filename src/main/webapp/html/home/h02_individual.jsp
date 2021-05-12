<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Individual Brokerage | MIRAE ASSET</title>
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
                <li><a href="h02_individual.jsp" class="on">Individual Brokerage</a></li>
                <li><a href="h02_institutional.jsp">Institutional Brokerage</a></li>
                <li><a href="h02_wealth.jsp">Wealth Management</a></li>
                <li><a href="h02_investment.jsp">Investment Banking</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Individual Brokerage</h3>
            <div class="bg_subcont_02 img_01">
            	<p>
            		The Company provides professional securities brokerage services to meet the different needs of each individual investor. With a team of experienced and enthusiastic consultants, all the investors will be thoroughly guided the procedures, processes, comprehensive securities trading services and be utmost simplified procedures, bring convenience and satisfaction to investors
            	</p>
            	<p>Securities brokerage operation in the Company include:</p>
            	<ul class="data_list type_01">
            		<li>Open securities trading account</li>
            		<li>Securities Depository</li>
            		<li>Receive and execute customer’s trading orders</li>
            		<li>Investment Consulting</li>
            		<li>Financial support services such as cash advance, margin</li>
            	</ul>
            </div>
            <div class="box">
           		To view detail services, please access <a href="h06_account.jsp">Support</a> menu or contact our hotline<br>
           		(+84) 8 3910 2222 / (+84) 4 6273 0541 for more guidance
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