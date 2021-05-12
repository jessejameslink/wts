<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Việt Nam | MIRAE ASSET</title>
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
                    <a href="h08_global_asia01.jsp" class="on">Châu Á Thái Bình Dương</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_asia01.jsp">Úc</a></li>
                        <li><a href="h08_global_asia02.jsp">Trung Quốc</a></li>
                        <li><a href="h08_global_asia03.jsp">Hồng Kông</a></li>
                        <li><a href="h08_global_asia04.jsp">Ấn Độ</a></li>
                        <li><a href="h08_global_asia05.jsp">Hàn Quốc</a></li>
                        <li><a href="h08_global_asia06.jsp">Đài Loan</a></li>
                        <li><a href="h08_global_asia07.jsp" class="on">Việt Nam</a></li>
                    </ul>
                </li>
                <li>
                    <a href="h08_global_america01.jsp">Châu Mỹ</a>
                    <ul class="lnb_sub">
                        <li><a href="h08_global_america01.jsp">Brazil</a></li>
                        <li><a href="h08_global_america02.jsp">Cananda</a></li>
                        <li><a href="h08_global_america03.jsp">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp">Mỹ</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp">Châu Âu</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Việt Nam</h3>

            <h4 class="cont_subtitle">Mirae Asset Global Investments (Văn phòng đại diện Hồ Chí Minh)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d979.8618992920053!2d106.69875688810077!3d10.77698991696878!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f380d2619e3%3A0x6cd92f1a65c52108!2sSaigon+Royal+Building!5e0!3m2!1sko!2skr!4v1473137715092" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Mirae Asset Global Investments mở Văn phòng Đại diện Việt Nam vào năm 2006.</p>
                    <p>Văn phòng đại diện thực hiện cung cấp các dịch vụ tư vấn vốn và thu nhập cố định cho các quỹ quản lý tài sản của Mirae Asset tại Việt Nam và bước đầu đã tạo dựng được một chỗ đứng quan trọng cho việc thực hiện các dự án đầu tư thay thế khác nhau của chúng tôi trong khu vực.</p>
                    <p>Chúng tôi sẽ tiếp tục tăng cường sự hiện diện trong khu vực ASEAN thông qua Việt Nam để tối ưu hóa các cơ hội cho nhà đầu tư.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">Thông tin liên hệ</h4>

            <div class="global_contact">
                <h5 class="sec_title">MIRAE ASSET Global Investments - HCM Representative Office</h5>
                <p>Saigon Royal Building, 7th Floor, 91  Pasteur, Ben Nghe Ward, District 1, HCMC</p>
                <p class="contacts">
                    <em>Tel :</em>
                    84-08-3824-8229
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