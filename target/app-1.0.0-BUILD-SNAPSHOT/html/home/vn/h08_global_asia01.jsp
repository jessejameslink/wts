<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Úc | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/VN/css/miraeasset.css">
<script type="text/javascript" src="/resources/VN/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/VN/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
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
                        <li><a href="h08_global_asia01.jsp" class="on">Úc</a></li>
                        <li><a href="h08_global_asia02.jsp">Trung Quốc</a></li>
                        <li><a href="h08_global_asia03.jsp">Hồng Kông</a></li>
                        <li><a href="h08_global_asia04.jsp">Ấn Độ</a></li>
                        <li><a href="h08_global_asia05.jsp">Hàn Quốc</a></li>
                        <li><a href="h08_global_asia06.jsp">Đài Loan</a></li>
                        <li><a href="h08_global_asia07.jsp">Việt Nam</a></li>
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
            <h3 class="cont_title">Úc</h3>

            <h4 class="cont_subtitle">BetaShares Capital Ltd.</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3312.963294357588!2d151.2039576512851!3d-33.86483682619058!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x6b12ae4119b4c007%3A0x305b00dfdfd23fe!2zNTAgTWFyZ2FyZXQgU3QsIFN5ZG5leSBOU1cgMjAwMCDsmKTsiqTtirjroIjsnbzrpqzslYQ!5e0!3m2!1sko!2skr!4v1473134168253" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>
                <div class="desc">
                    <p>BetaShares là một trong những nhà cung cấp hàng đầu các quỹ ETF và các quỹ giao dịch ASX khác tại Úc, gia nhập Mirae Asset Global Investments vào năm 2011.</p>
                    <p>BetaShares xác định mục tiêu phổ cập cho các nhà đầu tư hiện tại và tiềm năng về lợi thế của việc đầu tư vào quỹ ETF và các thị trường tài chính nói chung theo đúng cam kết luôn tạo ra những sản phẩm mới cho khách hàng của mình.</p>
                    <p>Mục tiêu của BetaShares là mở rộng mọi khả năng đầu tư cho các nhà đầu tư thông qua việc cung cấp các sản phẩm giao dịch hoán đổi cho phép các nhà đầu tư chủ động thực hiện chiến lược đầu tư của họ một cách dễ dàng.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">Thông tin liên hệ</h4>

            <div class="global_contact">
                <h5 class="sec_title">BetaShares Exchange Traded Funds (Australia)</h5>
                <p>50 Margaret Street, Sydney, New South Wales, 2129 Australia</p>
                <p class="contacts">
                    <em>Tel :</em>
                    61-2-9290-6888
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:info@betashares.com.au">info@betashares.com.au</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://www.betashares.com.au">www.betashares.com.au</a>
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