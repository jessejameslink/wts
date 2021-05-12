<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Wealth Management | MIRAE ASSET</title>
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
                <li><a href="h02_institutional.jsp">Institutional Brokerage</a></li>
                <li><a href="h02_wealth.jsp" class="on">Wealth Management</a></li>
                <li><a href="h02_investment.jsp">Investment Banking</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Wealth Management</h3>
			<div class="bg_subcont_02 img_03">
				<p>
					The Company has a team of intensive trained brokers and a separate asset management system allows investors to feel secure in the assets entrustment. With this service, investors can fully active set the investment portfolio structure or through consultants of the Company to construct and manage their assets most effectively
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