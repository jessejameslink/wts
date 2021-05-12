<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Quản lý tài sản | MIRAE ASSET</title>
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
                <li><a href="h02_wealth.jsp" class="on">Quản lý tài sản</a></li>
                <li><a href="h02_investment.jsp">Ngân hàng đầu tư</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Quản lý tài sản</h3>
            <div class="bg_subcont_02 img_03">
                <p>
                    Công ty có đội ngũ chuyên viên được đào tạo chuyên sâu và hệ thống giao dịch quản lý tài sản riêng biệt giúp nhà đầu tư hoàn toàn yên tâm trong việc ủy thác tài sản.<br />Với dịch vụ này, nhà đầu tư có thể hoàn toàn chủ động thiết lập cơ cấu danh mục đầu tư  hoặc thông qua các chuyên gia tư vấn của Công ty để được hỗ trợ xây dưng và quản lý tài sản của mình một cách hiệu quả nhất

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