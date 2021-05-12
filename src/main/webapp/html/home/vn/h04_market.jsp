<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Thống kê thị trường | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/VN/css/miraeasset.css">
<script type="text/javascript" src="/resources/VN/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/VN/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/VN/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Công cụ<br />đầu tư</h2>
            <ul>
                <li><a href="h04_market.jsp" class="on">Thống kê thị trường</a></li>
                <li><a href="h04_price.jsp">Lich sử giá</a></li>
                <li><a href="h04_trading.jsp">Kết quả giao dịch</a></li>
                <li><a href="h04_foreigner.jsp">Giao dịch NDT nước ngoài</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Thống kê thị trường</h3>

            <div class="market_chart">
                <div style="padding-top:300px; height:400px; background:#ccc; text-align:center; font-size:18px;">차트영역</div>
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