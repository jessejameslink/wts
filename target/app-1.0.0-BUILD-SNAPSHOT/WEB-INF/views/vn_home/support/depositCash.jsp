<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Hỗ trợ";
	});
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Hỗ trợ</h2>
            <ul>
                <li><a href="/home/support/account.do">Mở tài khoản tiền tại ngân hàng ACB</a></li>
                <li><a href="/home/support/wooriAccount.do">Mở tài khoản tiền tại ngân hàng Woori</a></li>
                <li><a href="/home/support/depositCash.do" class="on">Nộp tiền</a></li>
                <li><a href="/home/support/depositStock.do">Lưu ký chứng khoán</a></li>
                <li><a href="/home/support/cashAdvance.do">Ứng trước tiền bán chứng khoán</a></li>
                <li><a href="/home/support/cashTransfer.do">Chuyển tiền</a></li>
                <li>
                    <a href="/home/support/marginGuideline.do">Giao dịch ký quỹ</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/support/marginGuideline.do">Hướng dẫn</a></li>
                        <li><a href="/home/support/marginList.do">LDanh mục và thông tin cơ bản</a></li>
                    </ul>
                </li>
                <li><a href="/home/support/sms.do">SMS</a></li>
                <li><a href="/home/support/securities.do">Qui định giao dịch chứng khoán</a></li>
                <li><a href="/home/support/web.do">Hướng dẫn giao dịch trực tuyến qua website</a></li>
                <li><a href="/home/support/mobile.do">Hướng dẫn giao dịch qua ứng dụng điện thoại</a></li>
                <li><a href="/home/support/fee.do">Biểu phí</a></li>
                <li><a href="/home/subpage/openAccount.do">Hướng dẫn hồ sơ mở tài khoản chứng khoán cơ sở</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Nộp tiền</h3>

            <div class="dps_cash">
                <!-- <h4 class="cont_subtitle">DANH SÁCH TÀI KHOẢN NGÂN HÀNG CHO KHÁCH HÀNG NỘP TIỀN</h4>
                <h5 class="sml_title">Áp dụng từ ngày 27 tháng 09 năm 2017</h5>                 
                <p>Quý khách có thể nộp tiền vào các tài khoản sau của Công ty TNHH Chứng Khoán Mirae Asset (Việt Nam):</p>
				-->
				<div class="deposit_cash_top_vn">
                </div>
				<p>*Thông tin người thụ hưởng, số tài khoản của Mirae Asset tại các ngân hàng:</p> 
                <div class="price_table">
                    <table>
                        <caption>bank Số tài khoản</caption>
                        <colgroup>
                            <col width="55" />
                            <col width="250" />
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
                                    Người thụ hưởng: Công ty TNHH Chứng khoán Mirae Asset (Việt Nam)
                                </td>
                            </tr>
                            <tr class="first">
                                <td class="no">1</td>
                                <td>130.10000.428432</td>
                                <td>Ngân hàng Đầu Tư và Phát Triển Việt Nam - Sở giao dịch 2</td>
                            </tr>
                            <tr>
                                <td class="no">2</td>
                                <td>119.10000.667667</td>
                                <td>Ngân hàng Đầu Tư và Phát Triển Việt Nam - Chi nhánh NKKN</td>
                            </tr>
                            <tr>
                                <td class="no">3</td>
                                <td>122.1000.699.5555</td>
                                <td>BIDV - PGD Lê Đại Hành - CN Hà Thành- Hà Nội</td>
                            </tr>
                            <tr>
                                <td class="no">4</td>
                                <td>741.10000.775266</td>
                                <td>BIDV - CN Cần Thơ</td>
                            </tr>
                            <tr>
                                <td class="no">5</td>
                                <td>100912046537</td>
                                <td>Woori Bank Viet Nam - Chi nhánh Hồ Chí Minh</td>
                            </tr>
                            <tr>
                                <td class="no">6</td>
                                <td>700-000-315906</td>
                                <td>Shinhan Viet Nam Bank - Chi nhánh Hồ Chí Minh</td>
                            </tr>
                            <tr>
                                <td class="no">7</td>
                                <td>0071-0009-45-205</td>
                                <td>Vietcombank - Ngân hàng TMCP Ngoại Thương Việt Nam - Phòng giao dịch số 3</td>
                            </tr>
                            <tr>
                                <td class="no">8</td>
                                <td>031-704-070000-359</td>
                                <td>HDBank - Ngân hàng TMCP Phát triển Nhà Thành phố Hồ Chí Minh - Phòng giao dịch Duy Tân</td>
                            </tr>
                            <tr>
                                <td class="no">9</td>
                                <td>673.999.89</td>
                                <td>ACB - Ngân hàng TMCP Á Châu - Chi nhánh Sài Gòn</td>
                            </tr>
                            <tr>
                                <td class="no">10</td>
                                <td>2001-150560-00020</td>
                                <td>Eximbank - Ngân hàng TMCP Xuất Nhập Khẩu Việt Nam - Phòng giao dịch Bến Thành</td>
                            </tr>
                            <tr>
                                <td class="no">11</td>
                                <td>6263812-001</td>
                                <td>Indovina Bank - Ngân hàng TNHH Indovina - Chi nhánh Chợ Lớn</td>
                            </tr>
                            <tr>
                                <td class="no">12</td>
                                <td>9999.9714.9999</td>
                                <td>LienVietPostBank - Ngân hàng TMCP Bưu điện Liên Việt - Phòng giao dịch Sài Gòn</td>
                            </tr>
                            <tr>
                                <td class="no">13</td>
                                <td>810.00110.0000.875</td>
                                <td>Kookmin Bank - Chi nhánh Hồ Chí Minh</td>
                            </tr>
                            <tr>
                                <td class="no">14</td>
                                <td>126.000.035.468</td>
                                <td>Vietin Bank - Chi nhánh Hồ Chí Minh</td>
                            </tr>
                            <tr>
                                <td class="no">15</td>
                                <td>1912.1799.215.031</td>
                                <td>Techcombank - Chi nhánh Hồ Chí Minh</td>
                            </tr>
                            <tr>
                                <td class="no">16</td>
                                <td>4637937</td>
                                <td>ACB- PGD TTTM Vũng Tàu- Bà Rịa Vũng Tàu</td>
                            </tr>
                            <tr>
                                <td class="no">17</td>
                                <td>03053899003</td>
                                <td>Tien Phong Bank – CN Bến Thành</td>
                            </tr>
                            <tr>
                                <td class="no">18</td>
                                <td>0602 2964 5555</td>
                                <td>Sacombank – CN Trung Tâm</td>
                            </tr>
                            <tr>
                                <td colspan="3" class="inner_info">
                                    <span class="loc">Tại Hà Nội</span>
                                    Người thụ hưởng : Công ty TNHH Chứng khoán Mirae Asset (Việt Nam) - Chi nhánh Hà Nội
                                </td>
                            </tr>
                            <tr class="first">
                                <td class="no">1</td>
                                <td>160.10.00.000841.7</td>
                                <td>BIDV - Ngân hàng Đầu Tư và Phát Triển Việt Nam - Sở giao dịch 3</td>
                            </tr>
                            <tr>
                                <td class="no">2</td>
                                <td>100920065668</td>
                                <td>Woori Bank Viet Nam - Chi nhánh Hà Nội</td>
                            </tr>
                            <tr>
                                <td class="no">3</td>
                                <td>020040425226</td>
                                <td>Sacombank - Ngân hàng TMCP Sài Gòn Thương Tín - Chi nhánh Hàng Bài</td>
                            </tr>
                            <tr>
                                <td class="no">4</td>
                                <td>0011004019439</td>
                                <td>Vietcombank - Ngân hàng TMCP Ngoại Thương Việt Nam - Sở giao dịch Hà Nội</td>
                            </tr>
                            <tr>
                                <td class="no">5</td>
                                <td>0571103960007</td>
                                <td>MB Bank - Ngân hàng TMCP Quân đội - Chi nhánh Hoàn Kiếm</td>
                            </tr>
                            <tr>
                                <td class="no">6</td>
                                <td>19131444557018</td>
                                <td>Techcombank - Ngân hàng TMCP Kỹ Thương Việt Nam</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="deposit_cash_bottom_vn"></div>
				<!--  
                <div class="info">
                    <p>Quý khách vui lòng thông báo cho Công ty biết bằng điện thoại hay fax để chúng tôi cập nhật vào tài khoản giao dịch chứng khoán của quý khách kịp thời.<br />
                    Điện thoại: (08) 3.910.2222/ 3.911.0971<br />
                    Số fax: (08) 3.910.7222- gửi Ms. Hoang Anh/ Ms. Theu – Phòng Kế toán.</p>

                    <p>Nội dung cần điền vào phiếu nộp tiền tại ngân hàng:<br />
                    “Nộp tiền vào TK chứng khoán số …………………, của Ông/Bà…………………….”</p>
                    
                    <p>Trân trọng.</br>Phòng Kế toán.</p>
                </div>
                -->
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>