<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Brazil | MIRAE ASSET</title>
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
                        <li><a href="h08_global_america01.jsp" class="on">Brazil</a></li>
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
            <h3 class="cont_title">Brazil</h3>

            <h4 class="cont_subtitle">MIRAE ASSET Global Investments (Brazil)</h4>

            <div class="global_map">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3656.2445183506156!2d-46.68659034893963!3d-23.595562068667228!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x94ce57445377e583%3A0x9de1a4c3393afcb!2sMirae+Asset+Global+Investimentos!5e0!3m2!1sko!2skr!4v1473137945225" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

                <div class="desc">
                    <p>Mirae Asset Global Investments (Brazil) được thành lập vào năm 2008 đã đặt dấu ấn cho sự hiện diện của chúng tôi ở khu vực Mỹ Latin.</p>
                    <p>Chúng tôi tận dụng chuyên môn của mình tại các thị trường mới nổi và sự hiện diện toàn cầu nhằm phát hiện các cơ hội đầu tư và cung cấp cho khách hàng của chúng tôi các giải pháp đầu tư tốt nhất. Ngoài việc cung cấp các giải pháp đầu tư trên tài sản truyền thống, chúng tôi cũng là chuyên gia trong việc cung cấp các giải pháp chiến lược vĩ mô và đa dạng cùng với các khoản đầu tư thay thế, đặc biệt là trong lĩnh vực bất động sản.</p>
                </div>
            </div>

            <h4 class="cont_subtitle">Thông tin liên hệ</h4>

            <div class="global_contact">
                <h5 class="sec_title">MIRAE ASSET Global Investments (Brazil)</h5>
                <p>Rua Olimpiadas, 194/200, 12 andar, CJ 121<br />Vila Olimpia – Sao Paulo – SP – Brazil. CEP 045551-000</p>
                <p class="contacts">
                    <em>Tel :</em>
                    55-11-2608-8500
                    <br />
                    <em>E-mail :</em>
                    ContactUs.Brazil@MiraeAsset.com
                    <br />
                    <em>Website :</em>
                    <a href="http://investments.miraeasset.com.br/en">investments.miraeasset.com.br/en</a>
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