<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Triết lý | MIRAE ASSET</title>
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
                <li><a href="h01_philosophy.jsp" class="on">Triết lý</a></li>
                <li>
                    <a href="h01_why.jsp">Vì sao bạn chọn MIRAE ASSET</a>
                    <ul class="lnb_sub">
                        <li><a href="h01_why_investment.jsp">Nguyên tắc đầu tư</a></li>
                        <li><a href="h01_why_culture.jsp">Văn hóa &amp; Giá trị</a></li>
                        <li><a href="h01_why_core.jsp">Sức mạnh cối lỗi</a></li>
                    </ul>
                </li>
                <li><a href="h01_history.jsp">Lịch sử</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Triết lý</h3>
            <div class="plsp_header">
                <div>
                    <h4>Có nguồn gốc từ châu Á,</h4>
                    <p>Mirae Asset được thành lập vào năm 1997 trong sự trỗi dậy của cuộc khủng hoảng tài chính châu Á. Hiện nay, Mirae Asset đã phủ sóng toàn cầu để cung cấp những ý tưởng tuyệt vời nhất cho các nhà đầu tư trên toàn thế giới thông <span class="em">qua mạng lưới phủ sóng ở 12 quốc gia trên khắp 5 châu lục.</span> Mục tiêu của chúng tôi là cung cấp cho khách hàng những chiến lược tài chính sáng suốt và nhất quán thông qua những sản phẩm đa đạng của chúng tôi.</p>
                </div>
            </div>
            <h4 class="cont_subtitle">TRIẾT LÝ KINH DOANH</h4>
            <p>Với phương châm đặt nhu cầu của khách hàng lên hàng đầu, chúng tôi mong muốn trở thành đối tác đáng tin cậy. Triết lý kinh doanh cũng là kim chỉ nam cho mọi hoạt động của chúng tôi và là giá trị không bao giờ thay đổi của Mirae Asset.
            <br />
            <span class="em">Chúng tôi coi trọng yếu tố con người và nắm bắt tương lai với một tầm nhìn rộng mở.</span>
            </p>
            <h4 class="cont_subtitle">TẦM NHÌN</h4>
            <p>Với tầm nhìn mới được thay đổi và công bố vào tháng 6 năm 2012. Chúng tôi nêu ra những bước phát triển và vai trò chiến lược hướng đến sự vươn tầm và vượt ra ngoài phạm vi thị trường mới nổi để trở thành một công ty mang vị thế đầu tư toàn cầu.
            <br />
            <span class="em">Là chuyên gia trên thị trường mới nổi với tầm nhìn toàn cầu, chúng tôi theo đuổi chiến lược quản lý đầu tư hiệu quả tối ưu để giúp khách hàng đạt được mục tiêu dài hạn.</span>
            </p>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>