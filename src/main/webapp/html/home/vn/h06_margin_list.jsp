<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>LDanh mục và thông tin cơ bản | MIRAE ASSET</title>
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
                <li><a href="h06_cash_advance.jsp">Ứng trước tiền bán chứng khoán</a></li>
                <li><a href="h06_cash_transfer.jsp">Chuyển tiền</a></li>
                <li>
                    <a href="h06_margin_guideline.jsp" class="on">Giao dịch ký quỹ</a>
                    <ul class="lnb_sub">
                        <li><a href="h06_margin_guideline.jsp">Hướng dẫn</a></li>
                        <li><a href="h06_margin_list.jsp" class="on">LDanh mục và thông tin cơ bản</a></li>
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
            <h3 class="cont_title">Danh mục và thông tin cơ bản</h3>

            <div class="mg_info">
                <h4>1. Thời hạn khoản vay</h4>
                <table>
                    <caption>margin loan term</caption>
                    <colgroup>
                        <col width="260" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Thời hạn tối đa cho 1 khoản vay</th>
                            <td>03 tháng</td>
                        </tr>
                        <tr>
                            <th scope="row">Gia hạn khoản vay</th>
                            <td>Tối đa thêm 1 kỳ 3 tháng</td>
                        </tr>
                    </tbody>
                </table>

                <h4>2. Lãi suất cho vay Giao dịch Ký quỹ</h4>
                <div class="box">
                    <ul class="info_list">
                        <li>
                            <span class="title">Lãi suất ưu đãi cho 5 tháng đầu tiên kể từ ngày ký hợp đồng giao dịch ký quỹ chứng khoán</span>
                            <span class="desc">
                                <span>9.99% / năm</span>
                            </span>
                        </li>
                        <li>
                            <span class="title">Lãi suất thông thường</span>
                            <span class="desc">
                                <span>14% / năm</span>
                            </span>
                        </li>
                        <li>
                            <span class="title">Lãi suất quá hạn</span>
                            <span class="desc">
                                <span>150% lãi suất cho vay thông thường</span>
                            </span>
                        </li>
                    </ul>
                </div>

                <h4>3. Phương thức gọi bổ sung tài sản đảm bảo</h4>
                <p>Gửi tin nhắn SMS hoặc gọi điện thoại theo thông tin Quý Khách hàng đã đăng ký trong Hợp đồng Giao dịch Ký quỹ</p>

                <h4>4. Danh mục chứng khoán giao dịch ký quỹ (Cập nhật ngày dd/mm/yyyy</h4>
                <p>Download danh sách <a href="">Tại Đây</a></p>
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