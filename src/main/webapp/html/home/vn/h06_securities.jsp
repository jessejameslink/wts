<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Qui định giao dịch chứng khoán | MIRAE ASSET</title>
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
                <li><a href="h06_securities.jsp" class="on">Qui định giao dịch chứng khoán</a></li>
                <li><a href="h06_web.jsp">Hướng dẫn giao dịch trực tuyến qua website</a></li>
                <li><a href="h06_mobile.jsp">Hướng dẫn giao dịch qua ứng dụng điện thoại</a></li>
                <li><a href="h06_fee.jsp">Biểu phí</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Qui định giao dịch chứng khoán</h3>

            <div class="tab_container sec">
                <div class="tab">
                    <div>
                        <a href="#general" class="on">Qui định chung</a>
                        <a href="#hcm">Chứng khoán niêm yết trên HSX</a>
                        <a href="#hni">Chứng khoán niêm yết trên HNX</a>
                        <a href="#upcom">Chứng khoán đăng ký giao dịch UPCOM</a>
                        <a href="#g_bond">Trái phiếu chính phủ niêm yết trên HNX</a>
                        <a href="#g_foreign">Trái phiếu chính phủ bằng ngoại tệ niêm yết trên HNX</a>
                    </div>
                </div>

                <div class="tab_conts">
                    <div id="general" class="on">
                        <h4 class="hidden">Qui định chung</h4>

                        <h5 class="sec_title">1. Ký quỹ tiền</h5>
                        <p>Khi mua chứng khoán, nhà đầu tư phải ký quỹ 100% số tiền mua cộng với các khoản phí phát sinh.</p>

                        <h5 class="sec_title">2. Ký quỹ chứng khoán</h5>
                        <p>Khi bán chứng khoán, tài khoản lưu ký chứng khoán của nhà đầu tư mở tại Công ty phải có đủ số lượng chứng khoán muốn bán.</p>

                        <h5 class="sec_title">3. Phương thức giao dịch</h5>
                        <ul class="data_list type_01">
                            <li>Giao dịch tại quầy</li>
                            <li>Giao dịch qua điện thoại: 08.39102222 / 04.62730541</li>
                            <li>Giao dịch trực tuyến qua website: <em><a href="http://wts.masvn.com">wts.masvn.com</a></em></li>
                            <li>Giao dịch qua ứng dụng điện thoại di động: mts.masvn.com</li>
                        </ul>

                        <h5 class="sec_title">4. Qui định về thanh toán bù trừ</h5>
                        <div class="price_table">
                            <table>
                                <caption>Qui định về thanh toán bù trừ</caption>
                                <colgroup>
                                    <col width="50%" />
                                    <col width="50%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Loại chứng khoán</th>
                                        <th scope="col">Thời gian thanh toán bù trừ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="center">Cổ phiếu và chứng chỉ quỹ</td>
                                        <td class="center">T+2</td>
                                    </tr>
                                    <tr>
                                        <td class="center">Trái phiếu</td>
                                        <td class="center">T+1</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">5. Giao dịch của nhà đầu tư nước ngoài :</h5>
                        <table class="table_style_01">
                            <caption>Giao dịch của nhà đầu tư nước ngoài : table</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Trong thời gian giao dịch khớp lệnh:</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Khối lượng cổ phiếu, chứng chỉ quỹ đóng mua của nhà đầu tư nước ngoài được trừ vào khối lượng còn được phép mua ngay sau khi lệnh mua được thực hiện;</li>
                                            <li>Khối lượng cổ phiếu, chứng chỉ quỹ đóng bán của nhà đầu tư nước ngoài được cộng vào khối lượng cổ phiếu, chứng chỉ quỹ còn được phép mua ngay sau khi kết thúc việc thanh toán giao dịch (T+2)</li>
                                            <li>Lệnh mua hoặc một phần lệnh mua của nhà đầu tư nước ngoài chưa được thực hiện sẽ tự động bị hủy nếu khối lượng cổ phiếu, chứng chỉ quỹ đóng còn được phép mua đã hết và lệnh mua được nhập tiếp vào hệ thống giao dịch không được chấp nhận.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Trong thời gian giao dịch thỏa thuận:</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Khối lượng cổ phiếu, chứng chỉ quỹ đóng còn được phép mua của nhà đầu tư nước ngoài sẽ được giảm xuống ngay khi giao dịch thoản thuận được thực hiện nếu giao dịch đó là giữa một nhà đầu tư nước ngoài mua với một nhà đầu tư trong nước bán;</li>
                                            <li>Khối lượng cổ phiếu, chứng chỉ quỹ đóng còn được phép mua của nhà đầu tư nước ngoài được tăng lên ngay sau khi kết thúc việc thanh toán giao dịch nếu giao dịch đó là giữa một nhà đầu tư nước ngoài bán với một nhà đầu tư trong nước mua;</li>
                                            <li>Khối lượng cổ phiếu, chứng chỉ quỹ đóng được phép mua của nhà đầu tư nước ngoài sẽ không thay đổi nếu giao dịch thỏa thuận được thực hiện giữa hai nhà đầu tư nước ngoài với nhau</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Qui định khác</h5>
                        <ul class="data_list type_01">
                            <li>
                                <span class="em">Mỗi nhà đầu tư chỉ có thể mở 1 tài khoản tại 1 công ty chứng khoán và được phép mở nhiều tài khoản ở nhiều công ty chứng khoán.</span>
                            </li>
                            <li>
                                <span class="em">Nhà đầu tư được thực hiện các giao dịch ngược chiều (mua, bán) cùng một loại chứng khoán trong ngày giao dịch, khi đáp ứng các điều kiện sau :</span>
                                <ul class="data_list type_03">
                                    <li>Sử dụng một loại tài khoản mở tại một công ty chứng khoán để thực hiện cả lệnh mua và bán;</li>
                                    <li>Chỉ được mua hoặc bán một loại chứng khoán nếu lệnh bán hoặc lệnh mua của chứng khoán cùng loại trước đó đã được thực hiện và lệnh giao dịch phải đáp ứng yêu cầu tỷ lệ ký quỹ</li>
                                </ul>
                                </li>
                            <li>
                                <span class="em">Nhà đầu tư không được phép :</span>
                                <ul class="data_list type_03">
                                    <li>Thực hiện giao dịch mà không dẫn đến việc thay đổi quyền sở hữu chứng khoán;</li>
                                    <li>Đồng thời đặt lệnh mua và bán cùng 1 loại chứng khoán trong từng lần khớp lệnh trên cùng một loại tài khoản hoặc các tài khoản khác nhau mà nhà đầu tư đứng tên sở hữu.</li>
                                </ul>
                            </li>
                            <li>
                                <span class="em">Trong thời gian nghỉ giữa phiên giao dịch:</span>
                                <p>nhà đầu tư có thể đặt lệnh mới cho phiên giao dịch buổi chiều. Các lệnh này sẽ được lưu giữ trong hệ thống giao dịch của Công ty và chuyển vào hệ thống giao dịch của Sở khi bắt đầu phiên giao dịch buổi chiều. Nhà đầu tư có thể hủy/sửa các lệnh trên khi lệnh chưa được chuyển vào hệ thống giao dịch của Sở.</p>
                            <li>
                                <span class="em">Công bố thông tin :</span>
                                <ul class="data_list type_03">
                                    <li>Tổ chức, cá nhân, nhóm người có liên quan nắm giữ từ 5% trở lên số cổ phiếu có quyền biểu quyết/ chứng chỉ quỹ của một quỹ đại chúng dạng đóng hoặc khi không còn là cổ đông lớn phải báo cáo về sở hữu cho công ty đại chúng, UBCKNN, SGDCK (trường hợp là tổ chức niêm yết, đăng ký giao dịch) theo Phụ lục VI theo Thông tư 155/2015/TT-BTC)  trong thời hạn 07 ngày, kể từ ngày trở thành/không còn là cổ đông lớn.</li>
                                    <li>Tổ chức, cá nhân, nhóm người có liên quan nắm giữ từ 5% trở lên số cổ phiếu có quyền biểu quyết /chứng chỉ quỹ của một quỹ đại chúng dạng đóng: khi giao dịch làm thay đổi về số lượng cổ phiếu/chứng chỉ quỹ sở hữu vượt quá các ngưỡng một phần trăm (1%) số lượng cổ phiếu/chứng chỉ quỹ (kể cả trường hợp cho hoặc được cho, tặng hoặc được tặng, thừa kế, chuyển nhượng hoặc nhận chuyển nhượng quyền mua cổ phiếu phát hành thêm… hoặc không thực hiện giao dịch cổ phiếu/chứng chỉ quỹ) phải thực hiện báo cáo trong thời hạn bảy (07) ngày, kể từ ngày có sự thay đổi trên theo Phụ lục VII Thông tư 155/2015/TT-BTC) cho công ty đại chúng, UBCKNN, SGDCK.</li>
                                    <li>Cổ đông nội bộ (Thành viên HĐQT, Ban Giám đốc, Kế toán trưởng, Thành viên ban kiểm soát, cổ đông lớn, người công bố thông tin và người có liên quan của những người này) của tổ chức niêm yết/ tổ chức đăng ký giao dịch có ý định giao dịch cổ phiếu của chính tổ chức niêm yết/ tổ chức đăng ký giao dịch phải báo cáo bằng văn bản cho UBCKNN, SGDCK, và tổ chức niêm yết/ tổ chức đăng ký giao dịch ít nhất 03 ngày làm việc trước ngày dự kiến thực hiện giao dịch và chỉ được tiến hành sau 24 giờ kể từ khi có công bố thông tin từ SGDCK. Cổ đông nội bộ phải báo cáo cho UBCKNN, SGDCK và tổ chức niêm yết/ tổ chức đăng ký giao dịch về kết quả thực hiện giao dịch trong vòng 03 ngày làm việc kể từ ngày hoàn tất giao dịch hoặc kể từ khi hết thời hạn dự kiến giao dịch.</li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                    <!-- // #general -->

                    <div id="hcm">
                        <h4 class="cont_subtitle">Chứng khoán niêm yết trên HSX</h4>

                        <h5 class="sec_title">1. Chứng khoán giao dịch:</h5>
                        <p>Bao gồm: cổ phiếu (CP), chứng chỉ quỹ đóng, chứng chỉ quỹ ETF (gọi chung là CCQ), trái phiếu (TP Doanh nghiệp) và các loại chứng khoán khác sau khi có sự chấp thuận của Ủy ban Chứng khoán Nhà nước (UBCKNN)</p>

                        <h5 class="sec_title">2. Thời gian giao dịch:</h5>
                        <p>Từ thứ Hai đến thứ Sáu hàng tuần, trừ các ngày nghỉ theo quy định của Bộ Luật Lao động</p>
                        <p class="bu_arrow">Cổ phiếu, chứng chỉ quỹ đóng, chứng chỉ quỹ ETF</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="165" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Phiên</th>
                                        <th scope="col">Phương thức giao dịch</th>
                                        <th scope="col">Giờ giao dịch</th>
                                        <th scope="col">Loại lệnh</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Thị trường đóng cửa</td>
                                        <td class="center">15:00</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td rowspan="3" class="left">Phiên sáng</td>
                                        <td class="left">Khớp lệnh định kỳ mở cửa</td>
                                        <td class="center">09:00 ~ 09:15</td>
                                        <td class="center">LO, ATO</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Khớp lệnh liên tục I</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td class="center">LO, MP</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">09:15 ~ 11:30</td>
                                        <td class="center">LO, MP</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Nghỉ</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td rowspan="3" class="left">Phiên chiều</td>
                                        <td class="left">Khớp lệnh liên tục II</td>
                                        <td class="center">13:00 ~ 14:30</td>
                                        <td class="center">LO, MP</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Khớp lệnh định kỳ đóng cửa</td>
                                        <td class="center">14:30 ~ 14:45</td>
                                        <td class="center">LO, ATC</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <p class="bu_arrow">Trái phiếu</p>
                        <div class="price_table">
                            <table>
                                <caption>Bonds</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Phiên</th>
                                        <th scope="col">Phương thức giao dịch</th>
                                        <th scope="col">Giờ giao dịch</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Thị trường đóng cửa</td>
                                        <td class="center">15:00</td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td class="left">Phiên sáng</td>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">09:15 ~ 11:30</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Nghỉ</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Phiên chiều</td>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Phương thức giao dịch:</h5>
                        <table class="table_style_01">
                            <caption>Phương thức giao dịch</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Phương thức giao dịch khớp lệnh</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Phương thức khớp lệnh định kỳ:<br />Là phương thức giao dịch được thực hiện trên cơ sở so khớp các lệnh mua và lệnh bán chứng khoán của khách hàng tại một thời điểm xác định. Nguyên tắc xác định giá thực hiện như sau:
                                                <ul class="data_list type_03">
                                                    <li>Là mức giá thực hiện đạt khối lượng giao dịch lớn nhất.</li>
                                                    <li>Nếu có nhiều mức giá thỏa mãn điều kiện ở trên thì mức giá trùng hoặc gần với giá thực hiện của lần khớp lệnh gần nhất sẽ được chọn.</li>
                                                </ul>
                                            </li>
                                            <li>Phương thức khớp lệnh liên tục:<br />So khớp ngay khi lệnh được nhập vào hệ thống giao dịch.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Phương thức giao dịch thỏa thuận</th>
                                    <td>
                                        <p>Các bên mua bán thỏa thuận với nhau về các điều kiện giao dịch. Sau đó, giao dịch sẽ được công ty chứng khoán thành viên bên bán và mua nhập vào hệ thống giao dịch để ghi nhận kết quả.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">4. Nguyên tắc khớp lệnh:</h5>
                        <table class="table_style_01">
                            <caption>Nguyên tắc khớp lệnh</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Ưu tiên về giá</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Lệnh mua có mức giá cao hơn được ưu tiên thực hiện trước;</li>
                                            <li>Lệnh bán có mức giá thấp hơn được ưu tiên thực hiện trước</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Ưu tiên về thời gian</th>
                                    <td>
                                        <p>Trường hợp các lệnh mua hoặc lệnh bán có cùng mức giá thì lệnh nhập vào hệ thống giao dịch trước sẽ được ưu tiên thực hiện trước.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">5. Đơn vị giao dịch và đơn vị yết giá</h5>
                        <table class="table_style_01">
                            <caption>Đơn vị giao dịch và đơn vị yết giá</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Đơn vị giao dịch</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Đơn vị giao dịch khớp lệnh lô chẵn: 10 cố phiếu, chứng chỉ quỹ đầu tư</li>
                                            <li>Khối lượng giao dịch thỏa thuận: từ 20.000 cổ phiếu, chứng chỉ quỹ trở lên</li>
                                            <li>Không quy định đơn vị giao dịch đối với giao dịch thỏa thuận.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Đơn vị yết giá</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>
                                                Đối với phương thức khớp lệnh
                                                <table class="table_style_02">
                                                    <caption>order matching method</caption>
                                                    <colgroup>
                                                        <col width="25%" />
                                                        <col width="25%" />
                                                        <col width="25%" />
                                                        <col width="25%" />
                                                    </colgroup>
                                                    <thead>
                                                        <tr>
                                                            <th scope="rowgroup" class="bg">Mức giá (VND)</th>
                                                            <th scope="col">≤ 49,900</th>
                                                            <th scope="col">50,000 ~ 99,500</th>
                                                            <th scope="col">≥ 100,000</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <th scope="row" class="bg">Đơn vị yết giá (VND)</th>
                                                            <td>100</td>
                                                            <td>500</td>
                                                            <td>1,000</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </li>
                                            <li>Đối với phương thức giao dịch thỏa thuận: không quy định đơn vị yết giá</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Biên độ dao động giá:</h5>
                        <table class="table_style_01">
                            <caption>Trading band</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Cổ phiếu, chứng chỉ quỹ đầu tư</th>
                                    <td>
                                        <p>Biên độ dao động giá đối với cổ phiếu, chứng chỉ trong ngày giao dịch ±7%</p>
                                        <ul class="data_list type_02">
                                            <li>Giới hạn dao động giá của cổ phiếu, chứng chỉ quỹ trong ngày giao dịch được xác định như sau:
                                                <ul class="data_list type_03">
                                                    <li>Giá trần = Giá tham chiếu + 7%</li>
                                                    <li>Giá sàn  = Giá tham chiếu – 7%</li>
                                                </ul>
                                            </li>
                                            <li>Trường hợp giá trần và giá sàn của cổ phiếu, chứng chỉ quỹ điều chỉnh theo biên độ giao động giá bằng với giá tham chiếu, giá trần và giá sàn sẽ được thực hiện điều chỉnh như sau:
                                                <ul class="data_list type_03">
                                                    <li>Giá trần điều chỉnh = Giá tham chiếu + một đơn vị yết giá</li>
                                                    <li>Giá sàn điều chỉnh = Giá tham chiếu - một đơn vị yết giá</li>
                                                </ul>
                                            </li>
                                            <li>Trường hợp giá sàn điều chỉnh bằng không (0), giá trần và giá sàn được điều chỉnh như sau:
                                                <ul class="data_list type_03">
                                                    <li>Giá trần điều chỉnh = Giá tham chiếu + một đơn vị yết giá</li>
                                                    <li>Giá sàn điều chỉnh = Giá tham chiếu</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Cổ phiếu, chứng chỉ quỹ đầu tư trong ngày giao dịch đầu tiên</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Tổ chức niêm yết và tổ chức tư vấn (nếu có) phải đưa ra mức giá dự kiến để làm giá tham chiếu trong ngày giao dịch đầu tiên</li>
                                            <li>Biên độ dao động giá trong ngày giao dịch đầu tiên tối thiểu là ± 20% so với giá tham chiếu.</li>
                                            <li>Trong ngày giao dịch đầu tiên, không cho phép thực hiện giao dịch thỏa thuận</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Trái phiếu</th>
                                    <td>
                                       <p>Không áp dụng biên độ dao động giá đối với giao dịch trái phiếu.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">7. Giá tham chiếu</h5>
                        <ul class="data_list type_01">
                            <li>Giá tham chiếu của cổ phiếu, chứng chỉ quỹ là giá đóng cửa của ngày giao dịch gần nhất trước đó.</li>
                            <li>Trường hợp giao dịch cổ phiếu, chứng chỉ quỹ không được hưởng cổ tức hoặc các quyền kèm theo, giá tham chiếu tại ngày giao dịch không hưởng quyền được xác định theo nguyên tác lấy giá đóng cửa của ngày giao dịch gần nhất điều chỉnh theo giá trị cổ tức được nhận hoặc giá trị các quyền kèm theo.</li>
                            <li>Trường hợp giá phát hành quyền mua CP, CCQ lớn hơn giá đóng cửa CP, CCQ trước ngày không hưởng quyền, Sở GDCK TP.HCM sẽ không điều chỉnh giá tham chiếu của CP, CCQ trong ngày giao dịch không hưởng quyền.</li>
                            <li>Trường hợp phát hành trái phiếu chuyển đổi, phát hành chứng khoán riêng lẻ, chào bán chứng khoán cho nhà đầu tư không phải là cổ đông hiện hữu, phát hành CP theo chương trình lựa chọn cho người lao động trong công ty: không thực hiện điều chỉnh giá tham chiếu của chứng khoán vào ngày giao dịch không hưởng quyền</li>
                        </ul>

                        <h5 class="sec_title">8. Lệnh giao dịch:</h5>
                        <table class="table_style_01">
                            <caption>Type of orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Lệnh ATO/ATC</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Là lệnh đặt mua (bán) chứng khoán tại mức giá mở cửa (đóng cửa).</li>
                                            <li>Là lệnh không ghi giá cụ thể, ghi ATO/ATC</li>
                                            <li>Lệnh được ưu tiên trước lệnh giới hạn (LO) trong khi so khớp lệnh.</li>
                                            <li>Sau thời điểm xác định giá mở cửa (đóng cửa), lệnh ATO (ATC) không được thực hiện hoặc phần còn lại của lệnh không được thực hiện sẽ tự động hủy.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Lệnh giới hạn (LO)</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Là lệnh mua (bán) chứng khoán tại một mức giá xác định hoặc tốt hơn.</li>
                                            <li>Là lệnh có ghi giá cụ thể.</li>
                                            <li>Hiệu lực của lệnh: kể từ khi lệnh được nhập vào hệ thống giao dịch cho đến lúc kết thúc ngày giao dịch hoặc đến khi lệnh được hủy bỏ.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Lệnh thị trường (MP)</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Là lệnh mua chứng khoán tại mức giá bán thấp nhất hoặc lệnh bán chứng khoán tại mức giá cao nhất hiện có trên thị trường.</li>
                                            <li>Nếu sau khi so khớp lệnh theo nguyên tắc trên mà khối lượng đặt lệnh của lệnh MP vẫn chưa được thực hiện hết thì lệnh MP sẽ được xem là lệnh mua tại mức giá bán cao hơn hoặc lệnh bán tại mức giá mua thấp hơn tiếp theo hiện có trên thi trường và tiếp tục so khớp.</li>
                                            <li>Nếu khối lượng đặt lệnh của lệnh MP vẫn còn sau khi giao dịch theo nguyên tắc trên và không thể tiếp tục khớp được nữa thì lệnh MP sẽ được chuyển thành lệnh LO mua tại mức giá cao hơn một đơn vị yết giá so với giá thực hiện cuối cùng trước đó hoặc lệnh giới hạn bán tại mức giá thấp hơn một đơn vị yết giá so với giá thực hiện cuối cùng trước đó.</li>
                                            <li>Trường hợp giá thực hiện cuối cùng là giá trần đối với lệnh MP mua hoặc giá sàn đối với lệnh MP bán thì lệnh MP sẽ chuyển thành lện LO mua tại giá trần hoặc lệnh LO bán tại giá sàn.</li>
                                            <li>Lệnh MP được nhập vào hệ thống giao dịch trong thời gian khớp lệnh liên tục.</li>
                                            <li>Lệnh MP sẽ bị hủy bỏ khi không có lệnh LO đối ứng tại thời điểm nhập lệnh vào hệ thống giao dịch.</li>
                                            <li>Lệnh không ghi giá cụ thể, ghi MP</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">9. Hủy lệnh giao dịch:</h5>
                        <table class="table_style_01">
                            <caption>Cancellation of orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Trong phiên khớp lệnh định kỳ</th>
                                    <td>
                                        <p>Nhà đầu tư không được hủy lệnh giao dịch đã đặt trong cùng đợt khớp lệnh định kỳ</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Trong phiên khớp lệnh liên tục</th>
                                    <td>
                                         <p>Nhà đầu tư có thể hủy lệnh nếu lệnh hoặc phần còn lại của lệnh chưa được thực hiện, kể cả các lệnh hoặc phần còn lại của lệnh chưa được thực hiện ở lần khớp lệnh định kỳ hoặc liên tục trước đó</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- // #hcm -->

                    <div id="hni">
                        <h4 class="cont_subtitle">Chứng khoán niêm yết trên HNX</h4>

                        <h5 class="sec_title">1. Chứng khoán giao dịch :</h5>
                        <p>Bao gồm: cổ phiếu, trái phiếu và các loại chứng khoán khác sau khi có sự chấp thuận của Ủy ban Chứng khoán Nhà nước (UBCKNN)</p>

                        <h5 class="sec_title">2. Thời gian giao dịch :</h5>
                        <p>Từ thứ Hai đến thứ Sáu hàng tuần, trừ các ngày nghỉ theo quy định của Bộ Luật Lao động</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="165" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Phiên</th>
                                        <th scope="col">Phương thức giao dịch</th>
                                        <th scope="col">Giờ giao dịch</th>
                                        <th scope="col">Loại lệnh</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Thị trường đóng cửa</td>
                                        <td class="center">15:00</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td rowspan="2" class="left">Phiên sáng</td>
                                        <td class="left">Khớp lệnh liên tục</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td class="center">LO, MTL, MAK, MOK</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td class="left">Nghỉ</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td rowspan="3" class="left">Phiên chiều</td>
                                        <td class="left">Khớp lệnh liên tục</td>
                                        <td class="center">13:00 ~ 14:30</td>
                                        <td class="center">LO, MTL, MAK, MOK</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Khớp lệnh định kỳ đóng cửa</td>
                                        <td class="center">14:30 ~ 14:45</td>
                                        <td class="center">LO, ATC</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Phương thức giao dịch :</h5>
                        <table class="table_style_01">
                            <caption>Trading methods</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Phương thức khớp lệnh</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Phương thức khớp lệnh định kỳ:<br />Là phương thức giao dịch được thực hiện trên cơ sở so khớp các lệnh mua và lệnh bán chứng khoán của khách hàng tại một thời điểm xác định. Nguyên tắc xác định giá thực hiện như sau:
                                                <ul class="data_list type_03">
                                                    <li>Là mức giá thực hiện đạt khối lượng giao dịch lớn nhất.</li>
                                                    <li>Nếu có nhiều mức giá thỏa mãn điều kiện ở trên thì mức giá trùng hoặc gần với giá thực hiện của lần khớp lệnh gần nhất sẽ được chọn.</li>
                                                </ul>
                                            </li>
                                            <li>Phương thức khớp lệnh liên tục:<br />So khớp ngay khi lệnh được nhập vào hệ thống giao dịch.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Phương thức thỏa thuận</th>
                                    <td>
                                        <p>Các bên mua bán thỏa thuận với nhau về các điều kiện giao dịch. Sau đó, giao dịch sẽ được công ty chứng khoán thành viên bên bán và mua nhập vào hệ thống giao dịch để ghi nhận kết quả</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">4. Nguyên tắc khớp lệnh :</h5>
                        <table class="table_style_01">
                            <caption>Matching principles</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Ưu tiên về giá</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Lệnh mua có mức giá cao hơn được ưu tiên thực hiện trước</li>
                                            <li>Lệnh bán có mức giá thấp hơn được ưu tiên thực hiện trước</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Ưu tiên về thời gian</th>
                                    <td>
                                        <p>Trường hợp các lệnh mua hoặc lệnh bán có cùng mức giá thì lệnh nhập vào hệ thống giao dịch trước sẽ được ưu tiên thực hiện trước</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">5. Đơn vị giao dịch và đơn vị yết giá :</h5>
                        <table class="table_style_01">
                            <caption>Trading unit and Price tick</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Đơn vị giao dịch</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Đơn vị giao dịch khớp lệnh lô chẵn: 100 cổ phiếu/trái phiếu</li>
                                            <li>Không quy định đơn vị giao dịch đối với giao dịch thỏa thuận cổ phiếu/trái phiếu</li>
                                            <li>Khối lượng giao dịch thỏa thuận cổ phiếu: Từ 5.000 cổ phiếu trở lên</li>
                                            <li>Khối lượng giao dịch thỏa thuận trái phiếu: Từ 1.000 trái phiếu trở lên</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Đơn vị yết giá</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Đơn vị yết giá qui định đối với cổ phiếu là 100 đồng</li>
                                            <li>Không quy định đơn vị yết giá đối với giao dịch thỏa thuận cổ phiếu</li>
                                            <li>Trái phiếu: không quy định đơn vị yết giá</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Biên độ dao động giá :</h5>
                        <table class="table_style_01">
                            <caption>Trading band</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Biên độ dao động giá cổ phiếu trong ngày giao dịch</th>
                                    <td>
                                        <p>Biên độ dao động giá đối với cổ phiếu trong ngày giao dịch: ±10% so với giá tham chiếu</p>
                                        <ul class="data_list type_02">
                                            <li>Giới hạn dao động giá của cổ phiếu được xác định như sau:
                                                <ul class="data_list type_03">
                                                    <li>Giá trần = Giá tham chiếu + (Giá tham chiếu x Biên độ dao động giá)</li>
                                                    <li>Giá sàn = Giá tham chiếu – (Giá tham chiếu x Biên độ dao động giá)</li>
                                                </ul>
                                            </li>
                                            <li>Trường hợp sau khi tính toán, giá trần và giá sàn của cổ phiếu bằng với giá tham chiếu, giới hạn dao động giá được xác định lại như sau:
                                                <ul class="data_list type_03">
                                                    <li>Giá trần điều chỉnh = Giá tham chiếu + một đơn vị yết giá</li>
                                                    <li>Giá sàn điều chỉnh = Giá tham chiếu - một đơn vị yết giá</li>
                                                </ul>
                                            </li>
                                            <li>Trường hợp giá tham chiếu bằng 100 đồng, giá trần và giá sàn được điều chỉnh như sau:
                                                <ul class="data_list type_03">
                                                    <li>Giá trần điều chỉnh = Giá tham chiếu + một đơn vị yết giá</li>
                                                    <li>Giá sàn điều chỉnh = Giá tham chiếu</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Biên độ dao động giá cổ phiếu trong ngày giao dịch đầu tiên</th>
                                    <td>
                                        <p>Biên độ dao động giá trong ngày giao dịch đầu tiên của cổ phiếu mới niêm yết và ngày đầu tiên giao dịch trở lại đối với cổ phiếu tạm ngừng giao dịch trên 25 ngày giao dịch: ±30% so với giá tham chiếu.</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Trái phiếu</th>
                                    <td>
                                        <p>Không áp dụng biên độ dao động giá đối với giao dịch trái phiếu.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">7. Giá tham chiếu</h5>
                        <ul class="data_list type_01">
                            <li>Giá tham chiếu của cổ phiếu là giá đóng cửa của ngày giao dịch gần nhất trước đó.</li>
                            <li>Giá tham chiếu đối với cổ phiếu mới trong ngày giao dịch đầu tiên do tổ chức niêm yết và tổ chức tư vấn niêm yết (nếu có) đề xuất.</li>
                            <li>Trường hợp cổ phiếu tạm ngừng giao dịch trên 25 ngày giao dịch, khi được giao dịch trở lại, giá tham chiếu do HNX quyết định sau khi được sự chấp thuận của UBCKNN.</li>
                            <li>Trường hợp giao dịch cổ phiếu không được hưởng cổ tức và các quyền kèm theo, giá tham chiếu tại ngày không hưởng quyền được xác định theo nguyên tắc lấy giá đóng cửa của ngày giao dịch gần nhất điều chỉnh theo giá trị cổ tức hoặc giá trị của các quyền kèm theo, ngoại trừ các trường hợp sau:</li>
                            <li>Doanh nghiệp phát hành trái phiếu chuyển đổi;</li>
                            <li>Doanh nghiệp phát hành thêm cổ phiếi với giá cao hơn giá đóng cửa của cổ phiếu trong ngày giao dịch liền trước ngày không hưởng quyền sau khi đã điều chỉnh theo các quyền (nếu có).</li>
                            <li>Trường hợp tách hoặc gộp cổ phiếu, giá tham chiếu tại ngày giao dịch trở lại được xác định theo nguyên tác lấy giá đóng cửa của ngày giao dịch trước ngày tách, gộp điều chỉnh theo tỷ lệ tách, gộp cổ phiếu.</li>
                        </ul>

                        <h5 class="sec_title">8. Lệnh giao dịch:</h5>
                        <table class="table_style_01">
                            <caption>Type of orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Lệnh ATC</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Là lệnh đặt mua (bán) chứng khoán tại mức giá đóng cửa)</li>
                                            <li>Là lệnh không ghi giá cụ thể, ghi  ATC</li>
                                            <li>Lệnh được ưu tiên trước lệnh giới hạn (LO) trong khi so khớp lệnh.</li>
                                            <li>Sau thời điểm xác định giá đóng cửa, lệnh ATC không được thực hiện hoặc phần còn lại của lệnh không được thực hiện sẽ tự động hủy.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Lệnh giới hạn (LO)</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Là lệnh mua (bán) chứng khoán tại một mức giá xác định hoặc tốt hơn.</li>
                                            <li>Là lệnh có ghi giá cụ thể.</li>
                                            <li>Được phép nhập vào hệ thống giao dịch trong phiên khớp lệnh liên tục và phiên khớp lệnh định kỳ;</li>
                                            <li>Hiệu lực của lệnh: kể từ khi lệnh được nhập vào hệ thống giao dịch cho đến lúc kết thúc ngày giao dịch hoặc đến khi lệnh được hủy bỏ.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Lệnh thị trường giới hạn (MTL)</th>
                                    <td>
                                        <p>là lệnh thị trường nếu không được thực hiện toàn bộ thì phần còn lại của lệnh được chuyển thành lệnh LO mua với mức giá cao hơn mức giá khớp lệnh cuối cùng một đơn vị yết giá hoặc mức giá trần nếu mức giá khớp lệnh cuối cùng là giá trần (đối với lệnh mua) hoặc lệnh LO bán với mức giá thấp hơn mức giá khớp cuối cùng một đơn vị yết giá hoặc mức giá sàn nếu mức giá khớp lệnh cuối cùng là giá sàn (đối với lệnh bán); Lệnh MTL được chuyển thành lệnh LO phải tuân thủ các quy định về sửa, hủy đối với lệnh LO.</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Lệnh thị trường khớp toàn bộ hoặc hủy (MOK)</th>
                                    <td>
                                        <p>là lệnh thị trường nếu không được thực hiện toàn bộ thì bị hủy trên hệ thống giao dịch ngay sau khi nhập</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Lệnh thị trường khớp và hủy (MAK)</th>
                                    <td>
                                        <p>là lệnh thị trường có thể thực hiện toàn bộ hoặc một phần, phần còn lại của lệnh sẽ bị hủy ngay sau khi khớp lệnh.</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">9. Hủy, sửa lệnh giao dịch :</h5>
                        <ul class="data_list type_01">
                            <li>Việc sửa, hủy lệnh chỉ có hiệu lực đối với lệnh chưa được thực hiện hoặc phần còn lại của lệnh chưa được thực hiện.</li>
                            <li>Lệnh LO được phép sửa giá, khối lượng và hủy lệnh trong thởi gian giao dịch. Thứ tự ưu tiên của lệnh sau khi sửa như sau:
                                <ul class="data_list type_03">
                                    <li>Thứ tự ưu tiên của lệnh không đổi nếu chỉ sửa giảm khối lượng.</li>
                                    <li>Thứ tự ưu tiên của lệnh được tính kể từ khi lệnh sửa được nhập vào hệ thống giao dịch đối với các trưởng hợp sửa tăng khối lượng và/ hoặc sửa giá.</li>
                                </ul>
                            </li>
                            <li>Lệnh ATC không được phép sửa, chỉ được phép hủy trong thời gian giao dịch.</li>
                            <li>Các loại lệnh giao dịch không được sửa, hủy trong năm (05) phút cuối cùng của phiên khớp lệnh định kỳ.</li>
                        </ul>

                        <h5 class="sec_title">10. Giao dịch lô lẻ :</h5>
                        <ul class="data_list type_01">
                            <li>Giao dịch cổ phiếu / trái phiếu có khối lượng từ 1-99 (lô lẻ) có thể thực hiện theo phương thức khớp lệnh liên tục và phương thức thỏa thuận trên hệ thống giao dịch hoặc các hình thức khác theo quy định của pháp luật.</li>
                            <li>Chỉ được nhập lệnh LO đối với giao dịch lô lẻ và phải tuân thủ quy định sửa, hủy lệnh LO tương tự đối với giao dịch lô chẵn.</li>
                            <li>Đơn vị giao dịch lô lẻ: 01 cổ phiếu/trái phiếu</li>
                            <li>Giá giao dịch:
                                <ul class="data_list type_03">
                                    <li>Giá của lệnh giao dịch lô lẻ phải tuân thủ theo các quy định về giá giao dịch tương tự giao dịch lô chẵn.</li>
                                    <li>Các lệnh giao dịch lô lẻ không được sử dụng để xác định giá tham chiếu, giá tính chỉ số.</li>
                                </ul>
                            </li>
                            <li>Giao dịch lô lẻ không được thực hiện trong ngày giao dịch đầu tiên của cổ phiếu/ trái phiếu mới niêm yết hoặc ngày giao dịch trở lại sau khi bị tạm ngừng giao dịch 25 ngày.</li>
                        </ul>
                    </div>
                    <!-- // #hni -->

                    <div id="upcom">
                        <h4 class="cont_subtitle">Chứng khoán đăng ký giao dịch UPCOM</h4>

                        <h5 class="sec_title">1. Chứng khoán giao dịch:</h5>
                        <p>Bao gồm: cổ phiếu, trái phiếu và các loại chứng khoán khác sau khi có sự chấp thuận của Ủy ban Chứng khoán Nhà nước (UBCKNN) </p>

                        <h5 class="sec_title">2. Thời gian giao dịch:</h5>
                        <p>Từ thứ Hai đến thứ Sáu hàng tuần, trừ các ngày nghỉ theo quy định của Bộ Luật Lao động</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185" />
                                    <col width="*" />
                                    <col width="165" />
                                    <col width="160" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Phiên</th>
                                        <th scope="col">Phương thức giao dịch</th>
                                        <th scope="col">Giờ giao dịch</th>
                                        <th scope="col">Loại lệnh</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Thị trường đóng cửa</td>
                                        <td class="center">15:00</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td rowspan="2" class="left">Phiên sáng</td>
                                        <td class="left">Khớp lệnh liên tục</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td class="center">LO</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">09:00 ~ 11:30</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td class="left">Nghỉ</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td rowspan="3" class="left">Phiên chiều</td>
                                        <td class="left">Khớp lệnh liên tục</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td class="center">LO</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">13:00 ~ 15:00</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Phương thức giao dịch :</h5>
                        <table class="table_style_01">
                            <caption>Trading methods</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Phương thức khớp lệnh liên tục</th>
                                    <td>
                                        <p>Là phương thức giao dịch được thực hiện trên cơ sở so khớp các lệnh mua và lệnh bán chứng khoán ngay khi lệnh được nhập vào hệ thống UPCOM.</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Phương thức thỏa thuận</th>
                                    <td>
                                        <p>Là phương thức giao dịch trong đó các điều kiện giao dịch được các bên tham gia thoả thuận với nhau và xác nhận thông qua hệ thống UPCOM</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">4. Nguyên tắc khớp lệnh :</h5>
                        <table class="table_style_01">
                            <caption>Matching principles</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Ưu tiên về giá</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Lệnh mua có mức giá cao hơn được ưu tiên thực hiện trước</li>
                                            <li>Lệnh bán có mức giá thấp hơn được ưu tiên thực hiện trước</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Ưu tiên về thời gian</th>
                                    <td>
                                        <p>Trường hợp các lệnh mua hoặc lệnh bán có cùng mức giá thì lệnh nhập vào hệ thống giao dịch UPCOM trước sẽ được ưu tiên thực hiện trước</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">5. Đơn vị giao dịch và đơn vị yết giá :</h5>
                        <table class="table_style_01">
                            <caption>Trading unit and Price tick</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Đơn vị giao dịch</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Đơn vị giao dịch khớp lệnh liên tục là 100 chứng khoán</li>
                                            <li>Không quy định đơn vị giao dịch đối với giao dịch thỏa thuận</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Đơn vị yết giá</th>
                                    <td>
                                        <ul class="data_list type_02">
                                            <li>Đơn vị yết giá quy định đối với cổ phiếu là 100 đồng</li>
                                            <li>Không quy định đơn vị yết giá đối với giao dịch thỏa thuận và chứng khoán khác</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">6. Biên độ dao động giá :</h5>
                        <table class="table_style_01">
                            <caption>Trading band</caption>
                            <colgroup>
                                <col width="25%">
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">Biên độ dao động giá cổ phiếu trong ngày giao dịch</th>
                                    <td>
                                        <p>Biên độ dao động giá đối với cổ phiếu trong ngày giao dịch: ±15% so với giá tham chiếu</p>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Biên độ dao động giá cổ phiếu trong ngày giao dịch đầu tiên</th>
                                    <td>
                                        <p>Biên độ dao động giá trong ngày giao dịch đầu tiên của cổ phiếu mới niêm yết và ngày đầu tiên giao dịch trở lại đối với cổ phiếu tạm ngừng giao dịch trên 25 ngày giao dịch: ±40% so với giá tham chiếu</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">7. Giá tham chiếu</h5>
                        <ul class="data_list type_01">
                            <li>Đối với cổ phiếu mới đăng ký giao dịch, việc xác định giá tham chiếu của ngày giao dịch đầu tiên do tổ chức đăng ký giao dịch đề xuấtvà được SGDCKHN chấp thuận.</li>
                            <li>Giá tham chiếu của cổ phiếu đang giao dịch là bình quân gia quyền của các giá giao dịch lô chẵn thực hiện theo phương thức khớp lệnh liên tục của ngày có giao dịch khớp lệnh liên tục gần nhất trước đó.</li>
                            <li>Trường hợp giao dịch chứng khoán không được hưởng cổ tức và các quyền kèm theo, giá tham chiếu tại ngày không hưởng quyền được xác định theo nguyên tắc lấy giá bình quân gia quyền của ngày giao dịch gần nhất điều chỉnh theo giá trị cổ tức được nhận hoặc giá trị của các quyền kèm theo, ngoại trừ các trường hợp sau:
                                <ul class="data_list type_03">
                                    <li>Doanh nghiệp phát hành trái phiếu chuyển đổi;</li>
                                    <li>Doanh nghiệp phát hành thêm cổ phiếu với giá phát hành cao hơn giá bình quân gia quyền của ngày giao dịch liền trước ngày không hưởng quyền sau khi đã điều chỉnh các quyền khác (nếu có).</li>
                                </ul>
                            </li>
                            <li>Trường hợp tách hoặc gộp cổ phiếu, giá tham chiếu tại ngày giao dịch trở lại được xác định theo nguyên tắc lấy giá bình quân gia quyền của ngày giao dịch trước ngày tách, gộp điều chỉnh theo tỷ lệ tách, gộp cổ phiếu.</li>
                        </ul>

                        <h5 class="sec_title">8. Sửa, hủy lệnh giao dịch :</h5>
                        <ul class="data_list type_01">
                            <li>Việc sửa và huỷ lệnh chỉ có hiệu lực đối với lệnh gốc chưa được thực hiện hoặc phần còn lại của lệnh gốc chưa được thực hiện. </li>
                            <li>Nhà đầu tư được phép sửa giá, khối lượng và hủy lệnh trong thời gian giao dịch. Thứ tự ưu tiên của lệnh sau khi sửa được xác định như sau:
                                <ul class="data_list type_03">
                                    <li>Thứ tự ưu tiên của lệnh không đổi nếu chỉ sửa giảm khối lượng;</li>
                                    <li>Thứ tự ưu tiên của lệnh được tính kể từ khi lệnh sửa được nhập vào hệ thống giao dịch đối với các trường hợp sửa tăng khối lượng và hoặc sửa giá.</li>
                                </ul>
                            </li>
                            <li>Giao dịch thoả thuận đã thực hiện trên hệ thống không được phép huỷ bỏ.</li>
                            <li>Trong thời gian giao dịch, trường hợp đại diện giao dịch nhập sai giao dịch thỏa thuận của nhà đầu tư, đại diện giao dịch được phép sửa giao dịch thỏa thuận nhưng phải xuất trình lệnh gốc của nhà đầu tư; phải được bên đối tác chấp thuận việc sửa đó và được SGDCKHN chấp thuận việc sửa giao dịch thoả thuận. Việc sửa giao dịch thoả thuận của thành viên phải tuân thủ Quy trình sửa giao dịch thỏa thuận do SGDCKHN ban hành.</li>
                        </ul>
                    </div>
                    <!-- // #upcom -->

                    <div id="g_bond">
                        <h4 class="cont_subtitle">Trái phiếu chính phủ niêm yết trên HNX</h4>

                        <h5 class="sec_title">1. Loại trái phiếu giao dịch :</h5>
                        <ul class="data_list type_01">
                            <li>Trái phiếu chính phủ có kỳ hạn danh nghĩa trên một (01) năm do Kho bạc Nhà nước (KBNN) phát hành.</li>
                            <li>Tín phiếu kho bạc do KBNN hoặc Ngân hàng Nhà nước (NHNN) phát hành, có kỳ hạn danh nghĩa không vượt quá 52 tuần.</li>
                            <li>Trái phiếu chính quyền địa phương, trái phiếu được Chính phủ bảo lãnh</li>
                        </ul>

                        <h5 class="sec_title">2. Thời gian giao dịch :</h5>
                        <p>Từ thứ Hai đến thứ Sáu hàng tuần, trừ các ngày nghỉ theo quy định của Bộ Luật Lao động</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185">
                                    <col width="*">
                                    <col width="160">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Phiên</th>
                                        <th scope="col">Phương thức giao dịch</th>
                                        <th scope="col">Giờ giao dịch</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Thị trường đóng cửa</td>
                                        <td class="center">14:15</td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td class="left">Phiên sáng</td>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">08:30 ~ 11:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Nghỉ</td>
                                        <td></td>
                                        <td class="center">11:30 ~ 13:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Phiên chiều</td>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">13:00 ~ 14:15</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">3. Đơn vị giao dịch :</h5>
                        <p>01 (một) trái phiếu</p>

                        <h5 class="sec_title">4. Đơn vị yết giá :</h5>
                        <p>01 (một) VND</p>

                        <h5 class="sec_title">5. Mệnh giá trái phiếu :</h5>
                        <p>100.000 VND/trái phiếu</p>

                        <h5 class="sec_title">6. Giao dịch mua bán cùng phiên :</h5>
                        <p>Nhà đầu tư chỉ được thực hiện đồng thời vừa mua vừa bán một mã TPCP trong một phiên giao dịch khi việc mua bán này có phát sinh chuyển giao quyền sở hữu đối với TPCP giao dịch</p>

                        <h5 class="sec_title">7. Lệnh giao dịch :</h5>
                        <table class="table_style_01">
                            <caption>Trading orders</caption>
                            <colgroup>
                                <col width="25%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2" scope="row">Giao dịch thông thường</th>
                                    <td>
                                        <p class="em">Hình thức thoả thuận điện tử</p>
                                        <ul class="data_list type_02">
                                            <li>Lệnh thỏa thuận điện tử toàn thị trường:<br />là các lệnh chào mua, chào bán với cam kết chắc chắn có hiệu lực trong ngày được chào công khai trên hệ thống.</li>
                                            <li>Lệnh thỏa thuận điện tử tùy chọn: gồm 2 loại lệnh sau:
                                                <ul class="data_list type_03">
                                                    <li>Lệnh yêu cầu chào giá:<br />là lệnh có tính chất quảng cáo, được sử dụng khi nhà đầu tư chưa xác định được đối tác trong giao dịch. Lệnh yêu cầu chào giá có thể gửi đến một, một nhóm thành viên hoặc toàn thị trường.</li>
                                                    <li>Lệnh chào mua, chào bán với cam kết chắc chắn:<br />Lệnh chào với cam kết chắc chắn được sử dụng để chào đối ứng với lệnh yêu cầu chào giá. Lệnh chào với cam kết chắc chắn chỉ được gửi đích danh cho thành viên gửi Lệnh yêu cầu chào giá.</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p class="em">Hình thức thỏa thuận thông thường</p>
                                        <ul class="data_list type_02">
                                            <li>Lệnh báo cáo giao dịch trong ngày :<br />Lệnh báo cáo được sử dụng để nhập giao dịch vào hệ thống trong trường hợp giao dịch đã được các bên thoả thuận xong về các điều kiện trong giao dịch.
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th rowspan="2" scope="row">Giao dịch mua bán lại</th>
                                    <td>
                                        <p class="em">Hình thức thoả thuận điện tử</p>
                                        <ul class="data_list type_02">
                                            <li>Lệnh yêu cầu chào giá:<br />là lệnh có tính chất quảng cáo, được sử dụng khi nhà đầu tư chưa xác định được đối tác trong giao dịch. Lệnh yêu cầu chào giá có thể gửi đến một, một nhóm thành viên hoặc toàn thị trường.</li>
                                            <li>Lệnh chào mua, chào bán với cam kết chắc chắn:<br />Lệnh chào với cam kết chắc chắn được sử dụng để chào đối ứng với lệnh yêu cầu chào giá. Lệnh chào với cam kết chắc chắn chỉ được gửi đích danh cho thành viên gửi Lệnh yêu cầu chào giá.</li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p class="em">Hình thức thỏa thuận thông thường</p>
                                        <ul class="data_list type_02">
                                            <li>Lệnh báo cáo giao dịch trong ngày:<br />Lệnh báo cáo được sử dụng để nhập giao dịch vào hệ thống trong trường hợp giao dịch đã được các bên thoả thuận xong về các điều kiện trong giao dịch.</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <h5 class="sec_title">8. Khối lượng giao dịch tối thiểu :</h5>
                        <ul class="data_list type_01">
                            <li>Giao dịch thông thường :
                                <ul class="data_list type_03">
                                    <li>Hình thức thỏa thuận điện tử: 100 TPCP</li>
                                    <li>Hình thức thỏa thuận thông thường: 10.000 TPCP</li>
                                </ul>
                            </li>
                            <li>Giao dịch mua bán lại: 100 TPCP</li>
                        </ul>

                        <h5 class="sec_title">9. Sửa, hủy lệnh :</h5>
                        <ul class="data_list type_01">
                            <li>NĐT được phép sửa hoặc hủy lệnh thỏa thuận đối với lệnh giao dịch gốc chưa được thực hiện.</li>
                            <li>Giao dịch thoả thuận đã xác lập trên hệ thống không được phép huỷ bỏ.</li>
                            <li>Đối với giao dịch mua bán lại lần 2: được phép sửa thời gian giao dịch mua bán lại đã thực hiện. Việc sửa giao dịch mua bán lại lần 2 chưa đến hạn thanh toán hoặc đến hạn thanh toán như sau:
                                <ul class="data_list type_03">
                                    <li>Đối vớu trái phiếu Chính phủ: được phép sửa thời gian giao dịch Repos, lãi suất Repos, lãi suất trên lãi Coupon</li>
                                    <li>Đối với Tín phiếu Kho bạc: được phép sửa thời hạn giao dịch và lãi suất Repos.</li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                    <!-- // #g_bond -->

                    <div id="g_foreign">
                        <h4 class="cont_subtitle">Trái phiếu chính phủ bằng ngoại tệ niêm yết trên HNX</h4>

                        <h5 class="sec_title">1. Thời gian giao dịch :</h5>
                        <p>Từ thứ Hai đến thứ Sáu hàng tuần, trừ các ngày nghỉ theo quy định của Bộ Luật Lao động</p>
                        <div class="price_table">
                            <table>
                                <caption>Trading time</caption>
                                <colgroup>
                                    <col width="185">
                                    <col width="*">
                                    <col width="160">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">Phiên</th>
                                        <th scope="col">Phương thức giao dịch</th>
                                        <th scope="col">Giờ giao dịch</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" class="left">Thị trường đóng cửa</td>
                                        <td class="center">14:15</td>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <tr>
                                        <td class="left">Phiên sáng</td>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">08:30 ~ 11:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Nghỉ</td>
                                        <td></td>
                                        <td class="center">11:00 ~ 13:00</td>
                                    </tr>
                                    <tr>
                                        <td class="left">Phiên chiều</td>
                                        <td class="left">Giao dịch thỏa thuận</td>
                                        <td class="center">13:00 ~ 14:15</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h5 class="sec_title">2. Đơn vị giao dịch và khối lượng giao dịch tối thiểu :</h5>
                        <p>Không qui định</p>

                        <h5 class="sec_title">3. Đơn vị yết giá :</h5>
                        <p>01 (một) cent (1 USD = 100 cents)</p>

                        <h5 class="sec_title">4. Mệnh giá :</h5>
                        <p>100 USD/TPCP</p>

                        <h5 class="sec_title">5. Phương thức thanh toán :</h5>
                        <ul class="data_list type_01">
                            <li>
                            hanh toán trực tiếp với thời gian thanh toán là 01 (một) ngày làm việc sau ngày giao dịch (T+1) bằng Đô la Mỹ.</li>
                            <li>Tỉ giá quy đổi cho thanh toán giao dịch TPCP bằng ngoại tệ là tỉ giá liên ngân hàng do Ngân hàng Nhà nước Việt Nam công bố vào ngày giao dịch.</li>
                        </ul>
                    </div>
                    <!-- // #g_foreign -->
                </div>
            </div>
            <!-- // .tab_container -->
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>