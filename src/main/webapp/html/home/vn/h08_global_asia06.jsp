<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Đài Loan | MIRAE ASSET</title>
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
                        <li><a href="h08_global_asia06.jsp" class="on">Đài Loan</a></li>
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
            <h3 class="cont_title">Đài Loan</h3>

            <h4 class="cont_subtitle">MIRAE ASSET Global Investments (Đài Loan)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3614.4320811386624!2d121.5462822509147!3d25.053340343590357!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3442abe8781b9a97%3A0x395ace974e621a25!2sNo.+102%2C+Dunhua+N+Rd%2C+Songshan+District%2C+Taipei+City%2C+%EB%8C%80%EB%A7%8C+105!5e0!3m2!1sko!2skr!4v1473137518451" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Để tăng cường sự hiện diện của chúng tôi tại Đại Trung Quốc, Mirae Asset Global Investments đã mua TLG Asset Management năm 2011, và chuyển đổi thương hiệu thành Mirae Asset Global Investments (Taiwan).</p>
                    <p>Mirae Asset Global Investments (Taiwan) có khả năng cung cấp các quỹ trong và ngoài nước cho các nhà đầu tư trong nước. Chúng tôi đẩy mạnh các sản phẩm hiện có trong nước trong khi vẫn tiếp tục cung cấp các giải pháp ra nước ngoài dẫn đầu thị trường.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">Thông tin liên hệ</h4>

            <div class="global_contact">
                <h5 class="sec_title">MIRAE ASSET Global Investments (Taiwan)</h5>
                <p>6F, No. 42, Zhongshan N. St, Taipei city 10445, Taiwan</p>
                <p class="contacts">
                    <em>Tel :</em>
                    886-2-7725-7555
                    <br />
                    <em>E-mail :</em>
                    <a href="mailto:ContactUs.Taiwan@MiraeAsset.com">ContactUs.Taiwan@MiraeAsset.com</a>
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.com.tw">investments.miraeasset.com.tw</a>
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