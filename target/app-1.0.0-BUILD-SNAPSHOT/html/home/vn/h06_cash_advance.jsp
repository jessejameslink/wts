<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Chuyển tiền | MIRAE ASSET</title>
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
                <li><a href="h06_cash_advance.jsp" class="on">Ứng trước tiền bán chứng khoán</a></li>
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
                <li><a href="h06_mobile.jsp">Hướng dẫn giao dịch qua ứng dụng điện thoại</a></li>
                <li><a href="h06_fee.jsp">Biểu phí</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Ứng trước tiền bán chứng khoán</h3>
            <h4 class="cont_subtitle">Mô tả sản phẩm</h4>
            <ul class="data_list type_01">
                <li><span class="em">Lãi suất cho vay:</span><br /> theo lãi suất hiện hành của Công ty ở từng thời điểm.</li>
                <li><span class="em">Thời gian Nhà đầu tư đề nghị vay:</span><br /> ngày T, T+1 của lệnh bán chứng khoán thành công.</li>
                <li><span class="em">Tài sản đảm bảo:</span><br /> số tiền đã bán chứng khoán thành công nhưng chưa tới ngày được thanh toán tiền bán chứng khoán</li>
                <li><span class="em">Hình thức cho vay:</span><br /> khi có lệnh bán chứng khoán thành công, nhà đầu tư có thể chủ động đề nghị vay ứng trước tiền bán chứng khoán thông qua website của Công ty hoặc trực tiếp đến các văn phòng của Công ty làm yêu cầu</li>
                <li><span class="em">Phương thức trả nợ:</span><br /> vào ngày T+2 khi nhà đầu tư được trả tiền bán chứng khoán của ngày T, hệ thống của Công ty sẽ tự động thu nợ và lãi vay (tính theo số ngày vay thực tế) qua tài khoản của nhà đầu tư mở tại Công ty.</li>
            </ul>

            <h4 class="cont_subtitle">Đối tượng và điều kiện vay vốn</h4>
            <ul class="data_list type_01">
                <li>Nhà đầu tư đã mở tài khoản giao dịch chứng khoán tại Công ty</li>
                <li>Có lệnh bán chứng khoán thành công nhưng chưa tới ngày được thanh toán tiền bán chứng khoán.</li>
            </ul>

            <h4 class="cont_subtitle">Ứng trước tiền bán chứng khoán tự động</h4>
            <p>Ứng trước tiền bán chứng khoán tự động là dịch vụ do Công ty cung cấp cho nhà đầu tư ngay sau khi lệnh bán chứng khoán của nhà đầu tư được khớp, theo đó sức mua của nhà đầu tư sẽ tăng lên tương ứng với tổng số tiền bán sau khi đã thanh toán hết các khoản phí, thuế (nếu có). Nhà đầu tư có thể sử dụng phần sức mua tăng lên này ngay lập tức để đặt lệnh, mà không cần làm thủ tục ứng trước trong phiên. Nhà đầu tư chỉ phải trả phí ứng trước khi lệnh mua khớp có sử dụng phần sức mua tăng thêm này</p>

            <div class="box ca_box">
                <p>Để sử dụng dịch vụ ứng trước tiền bán chứng khoán tự động, vui lòng liên hệ đường dây nóng của chúng tôi hotline<br />(+84) 8 3910 2222 / (+84) 4 6273 0541 </p>
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