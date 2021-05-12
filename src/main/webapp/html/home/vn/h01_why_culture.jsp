<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Văn hóa &amp; Giá trị | MIRAE ASSET</title>
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
                    <a href="h01_why.jsp" class="on">Vì sao bạn chọn MIRAE ASSET</a>
                    <ul class="lnb_sub">
                        <li><a href="h01_why_investment.jsp">Nguyên tắc đầu tư</a></li>
                        <li><a href="h01_why_culture.jsp" class="on">Văn hóa &amp; Giá trị</a></li>
                        <li><a href="h01_why_core.jsp">Sức mạnh cối lỗi</a></li>
                    </ul>
                </li>
                <li><a href="h01_history.jsp">Lịch sử</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Văn hóa &amp; Giá trị</h3>

            <h4 class="cont_subtitle">Giá trị cốt lỗi</h4>
            <p>Ở Mirae Asset, những tiêu chuẩn quan trọng trong việc ra quyết định của chúng tôi được chỉ dẫn bởi 4 giá trị cốt lõi : Đặt lợi ích của khách hàng lên hàng đầu, Nguyên tắc khách quan, Tinh thần tập thể và Trách nhiệm cộng đồng.</p>

            <h5 class="bullet_title">Đặt lợi ích của khách hàng lên hàng đầu</h5>
            <p class="bullet_padding">Thành công của khách hàng là quan trọng nhất(paramount) - Thành công của khách hàng chính là thành công của chúng tôi. Chúng tôi xây dựng và nuôi dưỡng mối quan hệ lâu dài với khách hàng bằng cách giúp khách hàng để tạo ra sự thịnh vượng chiến lược đầu tư hiệu quả.</p>

            <h5 class="bullet_title">Nguyên tắc khách quan</h5>
            <p class="bullet_padding">Chúng tôi đánh giá cơ hội đầu tư một cách công bằng khách quan. Sự độc lập của chúng tôi sẽ giúp đảm bảo các quyết định của chúng tôi phù hợp với nhu cầu của khách hàng.</p>

            <h5 class="bullet_title">Tinh thần tập thể</h5>
            <p class="bullet_padding">Thành công của Mirae Asset được dựa trên sự tôn trọng mỗi cá nhân và sự tin tưởng vào sức mạnh của tinh thần tập thể. Mục tiêu chúng tôi là tạo dựng một môi trường làm việc mà tài năng và thành quả đạt được sẽ được đánh giá tương xứng với nhau và cơ hội là công bằng cho tất cả các thành viên.</p>

            <h5 class="bullet_title">Trách nhiệm cộng đồng</h5>
            <p class="bullet_padding">Ở Mirae Asset, chúng tôi nhận thức sâu sắc được trách nghiệm của mình. Như một doanh nghiệp tốt, chúng tôi mong muốn góp phần vào việc tri ân cộng đồng và cam kết tiếp tục hỗ trợ các phát minh sáng kiến vì cộng đồng.</p>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>