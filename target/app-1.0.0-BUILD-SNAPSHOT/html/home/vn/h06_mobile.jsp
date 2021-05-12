<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Hướng dẫn giao dịch qua ứng dụng điện thoại | MIRAE ASSET</title>
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
            <h2>Hỗ trợ</h2>
            <ul>
                <li><a href="h06_account.jsp">Mở tài khoản tiền tại ngân hàng ACB</a></li>
                <li><a href="h06_deposit_cash.jsp">Nộp tiền</a></li>
                <li><a href="h06_deposit_stock.jsp">Lưu ký chứng khoán</a></li>
                <li><a href="h06_cash_advance.jsp">Ứng trước tiền bán chứng khoán</a></li>
                <li><a href="h06_cash_transfer.jsp">Chuyển tiền</a></li>
                <li>
                    <a href="h06_margin_guideline.jsp">Giao dịch ký quỹ</a>
                    <ul class="lnb_sub">
                        <li><a href="h06_margin_guideline.jsp">Hướng dẫn</a></li>
                        <li><a href="h06_margin_list.jsp">LDanh mục và thông tin cơ bản</a></li>
                    </ul>
                </li>
                <li><a href="h06_sms.jsp">SMS</a></li>
                <li><a href="h06_securities.jsp">Qui định giao dịch chứng khoán</a></li>
                <li><a href="h06_web.jsp">Hướng dẫn giao dịch trực tuyến qua website</a></li>
                <li><a href="h06_mobile.jsp" class="on">Hướng dẫn giao dịch qua ứng dụng điện thoại</a></li>
                <li><a href="h06_fee.jsp">Biểu phí</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Hướng dẫn giao dịch qua ứng dụng điện thoại</h3>

            <div class="trading_guide mobile">
                <div class="m_guideline">
                    <p>Hướng dẫn giao dịch qua ứng dụng điện thoại</p>
                    <a href="">Tải về</a>
                </div>
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