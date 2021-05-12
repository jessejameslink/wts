<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Ngân hàng đầu tư | MIRAE ASSET</title>
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
            <h2>Sản phẩm<br />&amp; Dịch vụ</h2>
            <ul>
                <li><a href="h02_individual.jsp">Môi giới Khách hàng cá nhân</a></li>
                <li><a href="h02_institutional.jsp">Môi giới Khách hàng tổ chức</a></li>
                <li><a href="h02_wealth.jsp">Quản lý tài sản</a></li>
                <li><a href="h02_investment.jsp" class="on">Ngân hàng đầu tư</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Ngân hàng đầu tư</h3>
            <div class="bg_subcont_02 img_04">
                <p>
                    Công ty có đội ngũ chuyên viên được đào tạo chuyên sâu và được phân công phụ trách đến khách hàng của từng ngành công nghiệp, trợ giúp doanh nghiệp xác định cơ cấu vốn tối ưu và lộ trình huy động vốn phù hợp thông qua các dịch vụ:
                </p>
                <ul class="data_list type_01">
                    <li>Tư vấn cổ phần hóa</li>
                    <li>Tư vấn niêm yết</li>
                    <li>Tư vấn Mua bán và Sáp nhập doanh nghiệp</li>
                    <li>Tư vấn Tái cấu trúc doanh nghiệp</li>
                    <li>Tư vấn khác</li>
                </ul>
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