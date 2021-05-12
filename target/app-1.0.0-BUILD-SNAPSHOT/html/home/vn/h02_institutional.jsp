<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Môi giới Khách hàng tổ chức | MIRAE ASSET</title>
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
                <li><a href="h02_institutional.jsp" class="on">Môi giới Khách hàng tổ chức</a></li>
                <li><a href="h02_wealth.jsp">Quản lý tài sản</a></li>
                <li><a href="h02_investment.jsp">Ngân hàng đầu tư</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Môi giới Khách hàng tổ chức</h3>
             <div class="bg_subcont_02 img_02">
                <p>
                    Công ty cung cấp các dịch vụ chuyên sâu giúp tối đa hóa tiện ích cho các nhà đầu tư tổ chức bao gồm hệ thống phần mềm, báo cáo phân tích, biểu đồ, bản tin, hội thảo, hội nghị, các giao dịch khối lượng lớn, gặp gỡ các công ty niêm yết ...
                </p>
                <p>
                    Nhà đầu tư tổ chức sẽ luôn được kết nối với các chuyên viên phân tích nghiên cứu của Công ty thông qua đội ngũ chuyên viên môi giới giàu kinh nghiệm, được hỗ trợ chuyên môn từ bộ phận phân tích nghiên cứu.
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