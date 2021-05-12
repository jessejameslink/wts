<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Colombia | MIRAE ASSET</title>
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
                        <li><a href="h08_global_america02.jsp">Cananda</a></li>
                        <li><a href="h08_global_america03.jsp" class="on">Colombia</a></li>
                        <li><a href="h08_global_america04.jsp">Mỹ</a></li>
                    </ul>
                </li>
                <li><a href="h08_global_eu01.jsp">Châu Âu</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Colombia</h3>

            <h4 class="cont_subtitle">Horizons ETFs Management (Latam) (Colombia Rep Office)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3977.1651774546895!2d-74.10268694921812!3d4.564309844078647!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e3f98be20d06297%3A0x9d688c7ebe2c27c0!2zNzEsIENyYS4gNyAjMzQgU3VyLTIxLCBCb2dvdMOhLCDsvZzroazruYTslYQ!5e0!3m2!1sko!2skr!4v1473138245963" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Horizons ETFs Management Latam LLC gia nhập thị trường Colombia vào cuối năm 2012 và ra mắt quỹ ETF đầu tiên vào mùa thu năm 2013.</p>
                    <p>Chúng tôi chủ yếu tập trung phát triển và mở rộng kinh doanh quỹ hoán đổi danh mục toàn cầu ở Mỹ Latinh và chúng tôi đã chọn khu vực Andean, Colombia đặc biệt, làm vị trí chiến lược.</p>
                    <p>Chúng tôi tin rằng Horizons Mila 40 ETF và các quỹ ETF mới khác mà chúng tôi đã lên kế hoạch cho ra mắt tiếp theo sẽ giúp chúng tôi trở thành một doanh nghiệp ETF phát triển mạnh ở Colombia, mang lại nhiều lợi ích cho các nhà đầu tư trong nước cũng như quốc tế.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">Thông tin liên hệ</h4>

            <div class="global_contact">
                <h5 class="sec_title">Horizons ETFs Management (Latam) (Colombia Rep Office)</h5>
                <p>Carrera 7 # 71-21 Torre B Oficina 1501 <br />Bogotá, Colombia</p>
                <p class="contacts">
                    <em>Tel :</em>
                    57-1-319-2706
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ftorres@horizonsetfs.com">ftorres@horizonsetfs.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://co.horizonsetfs.com">co.horizonsetfs.com</a>
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