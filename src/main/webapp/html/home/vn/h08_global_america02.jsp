<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Cananda | MIRAE ASSET</title>
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
            <h2>Mạng lưới<br />toàn cầu</h2>
            <ul>
                <li>
                    <a href="h08_global_asia01.jsp">Châu Á Thái Bình Dương</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_asia01.jsp">Úc</a></li>
                        <li><a href="h08_global_asia02.jsp">Trung Quốc</a></li>
                        <li><a href="h08_global_asia03.jsp">Hồng Kông</a></li>
                        <li><a href="h08_global_asia04.jsp">Ấn Độ</a></li>
                        <li><a href="h08_global_asia05.jsp">Hàn Quốc</a></li>
                        <li><a href="h08_global_asia06.jsp">Đài Loan</a></li>
                        <li><a href="h08_global_asia07.jsp">Việt Nam</a></li>
                    </ul>
                </li>
                <li>
                    <a href="h08_global_america01.jsp" class="on">Châu Mỹ</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_america01.jsp">Brazil</a></li>
                        <li><a href="h08_global_america02.jsp" class="on">Cananda</a></li>
                        <li><a href="h08_global_america03.jsp">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp">Mỹ</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp">Châu Âu</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Cananda</h3>

            <h4 class="cont_subtitle">Horizons ETFs Management (Canada) Inc.</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2886.991881011196!2d-79.37800484873242!3d43.64833726066038!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89d4cb2df31d0909%3A0x392373a9d3707e2f!2zMjYgV2VsbGluZ3RvbiBTdCBFICM3MDAsIFRvcm9udG8sIE9OIE01RSAxUzIg7LqQ64KY64uk!5e0!3m2!1sko!2skr!4v1473138072289" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Horizons ETFs Management (Canada) Inc., tiền thân là BetaPro Management Inc, quản lý Horizons Exchange Traded Funds Inc. (“Horizons ETFs”) ("Horizons ETFs") family of ETFs của Mirae Asset Global Investments.</p>
                    <p>The Horizons ETFs family of ETFs bao gồm một loạt các công cụ đầu tư đa dạng và rộng khắp với các giải pháp cho các nhà đầu tư thuộc nhiều cấp độ kinh nghiệm để đáp ứng các mục tiêu đầu tư của họ tương ứng với các điều kiện thị trường khác biệt.</p>
                    <p>Chúng tôi tin rằng tất cả các nhà đầu tư, bất kể qui mô danh mục đầu tư, nên được tiếp cận các chiến lược đầu tư tốt nhất và các nhà quản lý tiền tệ ở mức giá tốt nhất có thể. Sản phẩm giao dịch hoán đổi thiết kế cho thị trường Canada của chúng tôi bao gồm các công cụ và giải pháp cải tiến cho các giao dịch chiến thuật, giao dịch chỉ số, và quản lý chủ động.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">Thông tin liên hệ</h4>

            <div class="global_contact">
                <h5 class="sec_title">Horizons ETFs Management (Canada)</h5>
                <p>26 Wellington Street E., Suite 700/608, Toronto, Ontario, M5E 1S2</p>
                <p class="contacts">
                    <em>Tel :</em>
                    866-299-7929
                    <br />
                    <em>Website :</em>
                    <a href="http://www.horizonsetfs.com">www.horizonsetfs.com</a>
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