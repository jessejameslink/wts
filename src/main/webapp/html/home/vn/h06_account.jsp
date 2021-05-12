<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Mở tài khoản tiền tại ngân hàng ACB | MIRAE ASSET</title>
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
                <li><a href="h06_account.jsp" class="on">Mở tài khoản tiền tại ngân hàng ACB</a></li>
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
                <li><a href="h06_fee.jsp">Biểu phí</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Mở tài khoản tiền tại ngân hàng ACB</h3>
            <h4 class="cont_subtitle">HƯỚNG DẪN MỞ TÀI KHOẢN TIỀN TẠI NGÂN HÀNG ACB ĐỂ GIAO DỊCH CHỨNG KHOÁN</h4>
            <p>
                Nhằm cung cấp thêm lựa chọn quản lý tài khoản tiền của Nhà đầu tư theo qui định tại điều 50 Thông tư 210/2012/TT-BTC hướng dẫn về thành lập và hoạt động công ty chứng khoán ban hành ngày 30/11/2012, Công ty đã liên kết với ngân hàng ACB triển khai dịch vụ Quản lý Tài khoản Tiền Nhà đầu tư tại Ngân hàng ACB
            </p>
            <h5 class="sub_title">THỦ TỤC ĐĂNG KÝ</h5>
            <p>(Dành cho Nhà đầu tư đã có tài khoản giao dịch chứng khoán tại Công ty)</p>
            <table class="table_style_01">
                <caption>registration procedures : table</caption>
                <colgroup>
                    <col width="25%" />
                    <col />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">1.<br>Khách hàng cá nhân trong nước</th>
                        <td>
                            <ul class="data_list type_02">
                                <li>Giấy giới thiệu mở tài khoản</li>
                                <li>Giấy đề nghị mở tài khoản và đăng ký dịch vụ (theo mẫu ACB)</li>
                                <li>Bản chính hoặc bản sao công chứng chứng minh thư / hộ chiếu</li>
                                <li>Giấy ủy quyền của khách hàng cho Công ty thực hiện truy vấn thông tin tài khoản, phong tỏa, giải tỏa tiền trên tài khoản, chuyển tiền từ tài khoản sang tài khoản của Công ty khi khớp lệnh mua chứng khoán (Bản thỏa thuận ba bên)</li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">2.<br />Khách hàng cá nhân nước ngoài</th>
                        <td>
                            <ul class="data_list type_02">
                                <li>Giấy giới thiệu mở tài khoản</li>
                                <li>Giấy đề nghị mở tài khoản và đăng ký dịch vụ (theo mẫu ACB)</li>
                                <li>Bản chính hoặc bản sao công chứng thẻ thường trú, hoặc thẻ tạm trú</li>
                                <li>Bản chính hoặc bản sao công chứng hộ chiếu, thị thực nhập cảnh còn hiệu lực.</li>
                                <li>Bản chính hoặc bản sao có công chứng các giấy tờ chứng minh tư cách của người đại diện, người giám hộ hợp pháp của người chưa thành niên, người mất năng lực hành vi dân sự, người hạn chế năng lực hành vi dân sự (nếu có)</li>
                                <li>Giấy ủy quyền của khách hàng nước ngoài ủy quyền cho Công ty toàn quyền thực hiện giao dịch trên tài khoản tiền gửi</li>
                                <li>Đề nghị chuyển đổi ngoại tệ sang VND</li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">3.<br />Khách hàng tổ chức trong nước</th>
                        <td>
                            <ul class="data_list type_02">
                                <li>Giấy giới thiệu mở tài khoản</li>
                                <li>Giấy đăng ký thông tin tài khoản (theo mẫu ACB)</li>
                                <li>Bản sao công chứng Giấy đăng ký kinh doanh</li>
                                <li>Bản sao công chứng đăng ký mã số thuế</li>
                                <li>Bảo sao công chứng Quyềt định / Giấy phép thành lập (nếu có)</li>
                                <li>CMND / hộ chiếu của người đại diện theo pháp luật</li>
                                <li>Quyết định bổ nhiệm giám đốc, kế toán trưởng</li>
                                <li>CMND / Hộ chiếu của kế toán trưởng</li>
                                <li>Các giấy tờ ủy quyền và CMND/ Hộ chiếu của người được ủy quyền (nếu có)</li>
                                <li>Bản thỏa thuận ba bên.</li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">4.<br />Khách hàng tổ chức nước ngoài</th>
                        <td>
                            <ul class="data_list type_02">
                                <li>Giấy giới thiệu mở tài khoản</li>
                                <li>Giấy đăng ký thông tin tài khoản (theo mẫu ACB)</li>
                                <li>Giấy tờ chứng minh Công ty được thành lập hợp pháp:
                                    <ul class="data_list type_03">
                                        <li>Bản sao công chứng Giấy phép đầu tư</li>
                                        <li>Bản sao công chứng đăng ký mã số thuế</li>
                                        <li>Các giấy tờ chứng minh tư cách đại diện hợp pháp của chủ tài khoản (theo quy định của ACB)</li>
                                        <li>Bản sao công chứng điều lệ công ty</li>
                                    </ul>
                                </li>
                                <li>Bản sao công chứng hộ chiếu của người đại diện theo pháp luật hoặc người được ủy quyền (nếu có)</li>
                                <li>Bản thỏa thuận ba bên</li>
                                <li>Đề nghị chuyển đổi ngoại tệ sang VND</li>
                            </ul>
                            <div class="support_note">
                                <em>Ghi chú:</em><br />
                                <p>* Hồ sơ, tài liệu quy định nếu bằng tiếng nước ngoài, nhà đầu tư phải dịch sang Tiếng Việt và hợp pháp hóa lãnh sự.</p>
                                <p>* Quy định mở tài khoản có thể thay đổi theo các quy định và chính sách của ACB trong từng thời kỳ.</p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>

            <h5 class="sub_title">QUI ĐỊNH VỀ TIỀN KÝ QUỸ</h5>
            <table class="table_style_01">
                <caption>regulation on cash deposit: table</caption>
                <colgroup>
                    <col width="25%" />
                    <col />
                </colgroup>
                <tbody>
                    <tr class="narrow_line">
                        <th scope="row">Khách hàng cá nhân</th>
                        <td>100,000 VND</td>
                    </tr>
                    <tr class="narrow_line">
                        <th scope="row">Khách hàng tổ chức</th>
                        <td>1,000,000 VND</td>
                    </tr>
                </tbody>
            </table>

            <h5 class="sub_title">LIÊN HỆ MỞ TÀI KHOẢN TIỀN TẠI NGÂN HÀNG ACB</h5>
            <table class="table_style_01">
                <caption>contact points at acb to open a bank Số tài khoản : table</caption>
                <colgroup>
                    <col width="25%" />
                    <col />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Tại TP.HCM</th>
                        <td>
                            <ul class="data_list type_02">
                               <li>ACB – Chi nhánh Sài Gòn<br />Địa chỉ: 41 Mạc Đỉnh Chi, P. Đa Kao, Q.1, TP.HCM<br />Điên thoại: 08 38243770 – Fax: 08 38243946</li>
                               <li>ACB – Phòng Giao Dịch Nguyễn Du<br />Địa chỉ: 94-96 Nguyễn Du, P. Bến Nghé, Q.1, TP.HCM<br />Điên thoại: 08 35218626 – Fax: 08 35218627</li>
                            </ul>
                        </td>
                    </tr>
                    <tr class="narrow_line">
                        <th scope="row">Tại Hà Nội</th>
                        <td>Các phòng giao dịch ACB tại Hà Nội</td>
                    </tr>
                </tbody>
            </table>

            <div class="support_note">
                <em>LƯU Ý</em>
                <p>* Khách hàng đăng ký dịch vụ quản lý tài khoản tiền tại Ngân hàng ACB không được sử dụng dịch vụ giao dịch giao dịch ký quỹ, dịch vụ ứng trước tiền bán chứng khoán tự động và một số dịch vụ hỗ trợ tài chính theo qui định của Công ty trong từng thời kỳ</p>
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