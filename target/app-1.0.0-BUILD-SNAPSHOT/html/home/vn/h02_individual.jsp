<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Môi giới Khách hàng cá nhân | MIRAE ASSET</title>
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
                <li><a href="h02_individual.jsp" class="on">Môi giới Khách hàng cá nhân</a></li>
                <li><a href="h02_institutional.jsp">Môi giới Khách hàng tổ chức</a></li>
                <li><a href="h02_wealth.jsp">Quản lý tài sản</a></li>
                <li><a href="h02_investment.jsp">Ngân hàng đầu tư</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Môi giới Khách hàng cá nhân</h3>
            <div class="bg_subcont_02 img_01">
                <p>
                    Công ty cung cấp các dịch vụ môi giới chứng khoán chuyên nghiệp đáp ứng nhu cầu khác biệt của từng nhà đầu tư cá nhân. Với đội ngũ chuyên viên tư vấn kinh nghiệm và tâm huyết, Quý nhà đầu tư sẽ được tận tình hướng dẫn các thủ tục, qui trình, dịch vụ giao dịch chứng khoán toàn diện và được đơn giản hóa thủ tục tối đa, mang lại sự tiện lợi và hài lòng cho Nhà đầu tư
                </p>
                <p>Hoạt động môi giới chứng khoán tại Công ty bao gồm:</p>
                <ul class="data_list type_01">
                    <li>Mở tài khoản giao dịch chứng khoán</li>
                    <li>Lưu ký chứng khoán</li>
                    <li>Nhận và thực hiện lệnh giao dịch của khách hàng</li>
                    <li>Tư vấn đầu tư</li>
                    <li>Các dịch vụ hỗ trợ tài chính như: ứng trước, ký quỹ</li>
                </ul>
            </div>
            <div class="box">
                Xem chi tiết dịch vụ tại danh mục <a href="h06_account.jsp">Hỗ trợ</a> hoặc liên hệ số điện thoại đường dây nóng<br />(+84) 8 3910 2222 / (+84) 4 6273 0541 để được hướng dẫn thêm
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