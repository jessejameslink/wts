<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Lịch sử | MIRAE ASSET</title>
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
            <h2>Giới thiệu</h2>
            <ul>
                <li><a href="h01_philosophy.jsp">Triết lý</a></li>
                <li>
                    <a href="h01_why.jsp">Vì sao bạn chọn MIRAE ASSET</a>
                    <ul class="lnb_sub">
                        <li><a href="h01_why_investment.jsp">Nguyên tắc đầu tư</a></li>
                        <li><a href="h01_why_culture.jsp">Văn hóa &amp; Giá trị</a></li>
                        <li><a href="h01_why_core.jsp"">Sức mạnh cối lỗi</a></li>
                    </ul>
                </li>
                <li><a href="h01_history.jsp" class="on">Lịch sử</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Lịch sử</h3>

            <div class="history">
                <h4>2015</h4>
                <ol>
                    <li>
                        <p class="date">16 / 12 / 2015</p>
                        <p>UBCKNN chấp thuận việc chuyển đổi loại hình doanh nghiệp của Công ty thành Công ty TNHH một thành viên; do đó Công ty sẽ là một trong những công ty chứng khoán 100% vốn nước ngoài đầu   tiên tại Việt Nam </p>
                    </li>
                    <li>
                        <p class="date">23 / 11 / 2015</p>
                        <p>UBCKNN chấp thuận giao dịch chuyển nhượng cổ phần để Mirae Asset Wealth Management (HK) Limited sở hữu toàn bộ vốn điều lệ của Công ty.</p>
                    </li>
                    <li>
                        <p class="date">15 / 04 / 2015</p>
                        <p>Đổi tên thành Công ty Cổ phần Chứng khoán Mirae Asset Wealth Management (Việt Nam)</p>
                    </li>
                </ol>

                <h4>2013</h4>
                <ol>
                    <li>
                        <p class="date">18 / 08 / 2013</p>
                        <p>Bổ nhiệm Tổng Giám Đốc / Đại diện theo pháp luật mới</p>
                    </li>
                </ol>

                <h4>2011</h4>
                <ol>
                    <li>
                        <p class="date">10 / 03 / 2011</p>
                        <p>Thay đổi địa điểm trụ sở chính tại TPHCM<br />Trụ sở mới: Tòa nhà Saigon Royal , Tầng trệt, 91 Pasteur, Quận 1 , Tp. HCM</p>
                    </li>
                </ol>

                <h4>2009</h4>
                <ol>
                    <li>
                        <p class="date">02 / 03 / 2009</p>
                        <p>Thành lập chi nhánh ở Hà Nội<br />Địa chỉ: Tòa nhà Phương Nam Bank, lầu 4, 27 Hàng Bài, Q. Hoàn Kiếm, Hà Nội</p>
                    </li>
                    <li>
                        <p class="date">08 / 04 / 2009</p>
                        <p>Đổi tên thành Công ty Cổ phần chứng khoán Mirae Asset (Việt Nam)</p>
                    </li>
                </ol>

                <h4>2007</h4>
                <ol>
                    <li>
                        <p class="date">18 / 12 / 2007</p>
                        <p>Thành lập Công ty cổ phần chứng khoán Mirae Asset<br />Vốn Điều lệ: 300.000.000.000 VND<br />Địa chỉ : Tòa nhà Petro Vietnam, 1-5 Lê Duẩn, Quận 1, Tp. HCM</p>
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