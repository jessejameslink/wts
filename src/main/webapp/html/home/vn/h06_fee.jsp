<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Biểu phí | MIRAE ASSET</title>
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
                <li><a href="h06_fee.jsp" class="on">Biểu phí</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Biểu phí</h3>

            <div class="fee">
                <h4 class="cont_subtitle">BIỂU PHÍ DỊCH VỤ CHỨNG KHOÁN</h4>
                <h5 class="sml_title">Áp dụng từ 01 tháng 05 năm 2016</h5>

                <h6 class="sec_title">I. PHÍ GIAO DỊCH CHỨNG KHOÁN </h6>
                <ul class="data_list type_01">
                    <li>
                        <span class="em">Giao dịch cổ phiếu, chứng chỉ quỹ niêm yết trên HSX, HNX, UPCOM<br />(bao gồm cả phương thức giao dịch khớp lệnh và thỏa thuận)</span>

                        <div class="price_table">
                            <table>
                                <caption>Transaction</caption>
                                <colgroup>
                                    <col width="145">
                                    <col width="*">
                                    <col width="180">
                                    <col width="180">
                                </colgroup>
                                <thead class="multi_row">
                                    <tr>
                                        <th scope="col" rowspan="2">Khách hàng</th>
                                        <th scope="col" rowspan="2">Giá trị giao dịch</th>
                                        <th scope="col" colspan="2">Mức phí</th>
                                    </tr>
                                    <tr>
                                        <th scope="col">Giao dịch qua sàn / ĐT</th>
                                        <th scope="col">Giao dịch qua Internet</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="left">Khách hàng nước ngoài</td>
                                        <td></td>
                                        <td class="center">0.40%</td>
                                        <td class="center">0.15%</td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="left">Khách hàng trong nước</td>
                                        <td class="left">Dưới 100 triệu đồng</td>
                                        <td class="center">0.25%</td>
                                        <td class="center">0.15%</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Từ 100 triệu đồng trở lên</td>
                                        <td class="center">0.20%</td>
                                        <td class="center">0.15%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>
                    <li>
                        <span class="em">Giao dịch trái phiếu</span><br />
                        Phí thỏa thuận (từ 0.02% đến 0.1% trên tổng giá trị giao dịch)
                    </li>
                </ul>

                <h6 class="sec_title">II. PHÍ DỊCH VỤ TÀI CHÍNH</h6>

                <div class="box">
                    <ul class="info_list">
                        <li>
                            <span class="title">Dịch vụ ứng trước tiền bán chứng khoán</span>
                            <span class="desc">
                                <span>14% / năm</span>
                            </span>
                        </li>
                        <li>
                            <p class="title">Dịch vụ giao dịch ký quỹ</p>
                            <p><span class="title bu01">Lãi suất cho vay trong hạn (*)</span></p>
                            <p>
                                <span class="title bu02">Lãi suất ưu đãi (5 tháng đầu tiên)</span>
                                <span class="desc">
                                    <span>9.99% / năm</span>
                                </span>
                            </p>
                            <p>
                                <span class="title bu02">Lãi suất thông thường (sau ưu đãi)</span>
                                <span class="desc">
                                    <span>14% / năm</span>
                                </span>
                            </p>
                            <p>
                                <span class="title bu01">Lãi suất quá hạn</span>
                                <span class="desc">
                                    <span>150% x (*)</span>
                                </span>
                            </p>
                        </li>
                    </ul>
                </div>

                <h6 class="sec_title">III. PHÍ NỘP TRUNG TÂM LƯU KÝ CHỨNG KHOÁN VIỆT NAM (VSD)</h6>

                <ul class="data_list type_01">
                    <li>
                        <span class="em">Phí lưu ký chứng khoán</span>

                        <table class="info_table">
                            <caption>margin loan term</caption>
                            <colgroup>
                                <col width="240" />
                                <col width="*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Cổ phiếu, chứng chỉ quỹ</th>
                                    <td>0,4 đồng/cổ phiếu, chứng chỉ quỹ/tháng</td>
                                </tr>
                                <tr>
                                    <th scope="row">Trái phiếu</th>
                                    <td>0,2 đồng/trái phiếu/tháng</td>
                                </tr>
                            </tbody>
                        </table>
                    </li>
                    <li>
                        <span class="em">Phí chuyễn khoản chứng khoán</span> do nhà đầu tư tất toán tài khoản hoặc theo yêu cầu của khách hàng<br />
                        0,5 đồng/CK/1 lần chuyển khoản/1 mã chứng khoán (tối đa 500.000 đồng/1 lần/1 mã chứng khoán)
                    </li>
                    <li>
                        <span class="em">Phí chuyển quyền sở hữu chứng khoán không qua hệ thống giao dịch của Sở giao dịch chứng khoán</span><br />
                        Theo mức thu của VSD tại thời điểm thực hiện giao dịch
                    </li>
                </ul>

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