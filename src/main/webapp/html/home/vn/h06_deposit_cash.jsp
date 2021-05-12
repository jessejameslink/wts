<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Lưu ký chứng khoán | MIRAE ASSET</title>
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
                <li><a href="h06_deposit_cash.jsp" class="on">Nộp tiền</a></li>
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
                <li><a href="h06_fee.jsp">Biểu phí</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Nộp tiền</h3>

            <div class="dps_cash">
                <h4 class="cont_subtitle">DANH SÁCH TÀI KHOẢN NGÂN HÀNG CHO KHÁCH HÀNG NỘP TIỀN</h4>
                <h5 class="sml_title">Áp dụng từ ngày 20 tháng 01 năm 2016</h5>
                <p>Quý khách có thể nộp tiền vào các tài khoản sau của Mirae Asset:</p>

                <div class="price_table">
                    <table>
                        <caption>bank Số tài khoản</caption>
                        <colgroup>
                            <col width="55" />
                            <col width="345" />
                            <col width="*" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">STT</th>
                                <th scope="col">Số tài khoản</th>
                                <th scope="col">Tại Ngân hàng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="3" class="inner_info">
                                    <span class="loc">Tại TP.HCM</span>
                                    Người thụ hưởng: Công ty trách nhiệm hữu hạn chứng khoán Mirae Asset Wealth Management (Việt Nam)
                                </td>
                            </tr>
                            <tr class="first">
                                <td class="no">1</td>
                                <td>1301.0000.428.432</td>
                                <td>BIDV – SGD II</td>
                            </tr>
                            <tr>
                                <td class="no">2</td>
                                <td>DDA.912.046537</td>
                                <td>Woori Bank – HCM Branch</td>
                            </tr>
                            <tr>
                                <td class="no">3</td>
                                <td>700-000-315906</td>
                                <td>Shinhan Viet Nam Bank – HCM</td>
                            </tr>
                            <tr>
                                <td class="no">4</td>
                                <td>0764-000440-20-002</td>
                                <td>IBK Bank – HCM</td>
                            </tr>
                            <tr>
                                <td class="no">5</td>
                                <td>0071-0009-45-205</td>
                                <td>VCB – PGD số 3 – HCM</td>
                            </tr>
                            <tr>
                                <td class="no">6</td>
                                <td>031-704-070000-359</td>
                                <td>HDBank – PGD Duy Tân – HCM</td>
                            </tr>
                            <tr>
                                <td class="no">7</td>
                                <td>673.999.89</td>
                                <td>ACB – CN Sài gòn – HCM</td>
                            </tr>
                            <tr>
                                <td class="no">8</td>
                                <td>2001-150560-00020</td>
                                <td>Eximbank – PGD Bến Thành – HCM</td>
                            </tr>
                            <tr>
                                <td class="no">9</td>
                                <td>6263812-001</td>
                                <td>Indovina Bank – Chợ lớn Branch</td>
                            </tr>
                            <tr>
                                <td class="no">10</td>
                                <td>9999.9714.9999</td>
                                <td>Buu Dien Lien Viet Bank – PGD Sài Gòn –  HCM</td>
                            </tr>
                            <tr>
                                <td colspan="3" class="inner_info">
                                    <span class="loc">Tại Hà Nội</span>
                                    Người thụ hưởng : Công ty TNHH Chứng khoán Mirae Asset Wealth Management (Việt Nam) – chi nhánh Hà Nội
                                </td>
                            </tr>
                            <tr class="first">
                                <td class="no">1</td>
                                <td>160.10.00.000841.7</td>
                                <td>BIDV – SGD III</td>
                            </tr>
                            <tr>
                                <td class="no">2</td>
                                <td>DDA920065668</td>
                                <td>Woori Bank – Hà nội Branch</td>
                            </tr>
                            <tr>
                                <td class="no">3</td>
                                <td>020040425226</td>
                                <td>Sacombank – Hàng Bài Branch</td>
                            </tr>
                            <tr>
                                <td class="no">4</td>
                                <td>0011004019439</td>
                                <td>VCB – SGD  – HN</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="info">
                    <p>Quý khách vui lòng thông bằng điện thoại hay fax sau khi nộp tiền để Mirae Asset cập nhật vào tài khoản giao dịch chứng khoán của Quý khách kịp thời.<br />
                    Điện thoại: (08) 3.910.2222/ 3.911.0971<br />
                    Số fax: (08) 3.911.0678 - gửi Ms. Quyên – phòng Kế toán</p>

                    <p>Nội dung cần điền vào phiếu nộp tiền tại ngân hàng:<br />
                    “Nộp tiền theo hợp đồng số …………………, của Ông/Bà…………………….”</p>
                </div>
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