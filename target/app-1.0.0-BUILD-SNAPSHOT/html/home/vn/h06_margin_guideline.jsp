<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Guideline | MIRAE ASSET</title>
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
                        <li><a href="h06_margin_guideline.jsp" class="on">Hướng dẫn</a></li>
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
            <h3 class="cont_title">Hướng dẫn</h3>

            <div class="tab_container mg">
                <div class="tab">
                    <div>
                        <a href="#registration" class="on">Đăng ký sử dụng dịch<br />vụ giao dịch ký quỹ</a>
                        <a href="#process">Đăng ký sử dụng dịch<br />vụ giao dịch ký quỹ trực tuyến</a>
                        <a href="#notice">Một số lưu ý cần thiết<br />của dịch vụ giao dịch ký quỹ</a>
                        <a href="#cease">Ngừng sử dụng dịch<br />vụ giao dịch ký quỹ</a>
                    </div>
                </div>

                <div class="tab_conts">
                    <div id="registration" class="on">
                        <h4 class="hidden">Đăng ký sử dụng dịch vụ giao dịch ký quỹ</h4>
                        <p>Khách hàng ký “Hợp đồng Mở Tài khoản Giao dịch ký quỹ” (Hợp đồng) tại Trụ sở hoặc chi nhánh Hà Nội</p>
                    </div>
                    <!-- // #registration -->

                    <div id="process">
                        <h4 class="hidden">Đăng ký sử dụng dịch vụ giao dịch ký quỹ trực tuyến</h4>
                        <p>Trình tự đăng ký sử dụng dịch vụ giao dịch ký quỹ trực tuyến gồm các bước sau:</p>

                        <ul class="step_list">
                            <li>
                                <div class="step">
                                    BƯỚC<span>01</span>
                                </div>
                                <div class="body">
                                    <p>Ký Phụ lục hợp đồng “Thỏa thuận sử dụng tiện ích giao dịch chứng khoán”</p>
                                    <p class="mg_note">
                                        <em>Lưu ý:</em><br />
                                        * Đối với trường hợp Quý Khách hàng đã đăng ký sử dụng dịch vụ trực tuyến thì không cần thực hiện bước này
                                    </p>
                                </div>
                            </li>
                            <li>
                                <div class="step">
                                    BƯỚC<span>02</span>
                                </div>
                                <div class="body">
                                    <p>
                                        Đăng nhập vào tài khoản trên website <em><a href="http://www.masvn.com">www.masvn.com</a></em> tại mục "GIAO DỊCH TRỰC TUYỀN" bằng tên truy cập và mật khẩu được cấp. Để đảm bảo an toàn trong quá trình giao dịch, chúng tôi đề nghị Quý Khách hàng đổi mật khẩu mới sau lần đăng nhập đầu tiên.
                                    </p>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <!-- // #process -->

                    <div id="notice">
                        <h4 class="hidden">Một số lưu ý cần thiết của dịch vụ giao dịch ký quỹ</h4>

                        <h5 class="em">Điều kiện đặt lệnh giao dịch mua ký quỹ</h5>
                        <ul class="data_list type_01">
                            <li>Quý Khách hàng đã hoàn thành việc đăng ký sử dụng dịch vụ Giao dịch ký quỹ</li>
                            <li>Mã chứng khoán mà Quý Khách hàng đặt lệnh giao dịch phải nằm trong Danh mục chứng khoán được phép giao dịch ký quỹ do Công ty công bố theo từng thời điểm.</li>
                            <li>Giá trị đặt lệnh trong hạn mức cho vay của Khách hàng theo quy định của Công ty theo từng thời điểm</li>
                        </ul>

                        <h5 class="em">Trả nợ vay ký quỹ trước hạn</h5>
                        <p>Khách hàng có thể lựa chọn hình thức trả nợ tự động hoặc trả nợ theo yêu cầu</p>
                        <ul class="data_list type_01">
                            <li>
                                Trả nợ tự động :
                                <p>Hệ thống sẽ tự động thu nợ một phần hay toàn bộ khoản vay nếu cuối ngày giao dịch tài khoản của Khách hàng có dư tiền chưa dùng tới (Vui lòng liên hệ số điện thoại đường dây nóng (+84) 8 3910 2222 / (+84) 4 6273 0541 để đăng ký sử dụng)</p>
                            </li>
                            <li>
                                Trả nợ theo yêu cầu :
                                <p>Trường hợp Khách hàng có tiền mặt trong tài khoản và có nhu cầu trả nợ một phần hoặc toàn bộ tiền vay ký quỹ, khách hàng điền vào “Giấy đề nghị trả nợ vay ký quỹ trước hạn” nộp trực tiếp tại quầy giao dịch; Hoặc Quý Khách hàng có thể đăng nhập tài khoản giao dịch trực tuyến, vào mục Dịch vụ/Hoàn trả vay ký quỹ và nhập số tiền cần hoàn trả</p>
                            </li>
                        </ul>

                        <h5 class="em">Thông báo lệnh gọi ký quỹ</h5>
                        <ul class="data_list type_01">
                            <li>Trường hợp tỷ lệ ký quỹ nhỏ hơn tỷ lệ ký quỹ duy trì do giá trị tài sản đảm bảo bị sụt giảm khi chứng khoán trong tài khoản của khách hàng bị loại khỏi danh mục chứng khoán được phép giao dịch ký quỹ theo quy định của Công ty, Quý khách hàng được yêu cầu bổ sung tài sản đảm bảo trong thời hạn T+5 ngày làm việc, sao cho tỷ lệ ký quỹ về mức an toàn;</li>
                            <li>Trường hợp tỷ lệ ký quỹ nhỏ hơn tỷ lệ ký quỹ duy trì do các nguyên nhân khác (giá trị tài sản đảm bảo bị sụt giảm theo cung cầu thị trường, trong ngày giao dịch không hưởng quyền, …), Quý Khách hàng được yêu cầu bổ sung tài sản đảm bảo trong thời hạn T+2 ngày làm việc, sao cho tỷ lệ ký quỹ về mức an toàn;</li>
                            <li>Trường hợp đến hạn khoản vay mà Khách hàng chưa hoàn trả tiền vay: Quý Khách hàng được yêu cầu thanh toán toàn bộ tiền vay trong thời hạn T + 7 ngày làm việc; hoặc theo thời hạn quy định nếu tỷ lệ ký quỹ nhỏ hơn tỷ lệ ký quỹ duy trì của danh mục.</li>
                        </ul>

                        <h5 class="em">Phương thức thông báo Lệnh gọi ký quỹ</h5>
                        <ul class="data_list type_01">
                            <li>Công ty thông báo Lệnh gọi ký quỹ cho Quý Khách hàng bằng điện thoại, tin nhắn SMS hoặc các phương thức khác thỏa thuận trong Hợp đồng.</li>
                        </ul>

                        <h5 class="em">Phương thức bổ sung tài sản đảm bảo khi Tài khoản có Lệnh gọi ký quỹ</h5>
                        <ul class="data_list type_01">
                            <li>Bổ sung tài sản bằng việc bán chứng khoán để đảm bảo Tỷ lệ ký quỹ lớn hơn hoặc bằng Tỷ lệ ký quỹ duy trì bắt buộc</li>
                            <li>Bổ sung tài sản bằng cách nộp tiền mặt hoặc chuyển khoản vào Tài khoản ký quỹ để đảm bảo Tỷ lệ ký quỹ hơn hoặc bằng Tỷ lệ ký quỹ duy trì bắt buộc</li>
                        </ul>

                        <h5 class="em">Giá tham chiếu của chứng khoán thực hiện quyền</h5>
                        <ul class="data_list type_01">
                            <li>Tại ngày giao dịch không hưởng quyền, giá tham chiếu của chứng khoán thực hiện quyền sẽ tự động giảm (nếu có) theo qui định của các Sở giao dịch chứng khoán.</li>
                        </ul>

                        <h5 class="em">Trường hợp chứng khoán bị đưa vào diện kiểm soát hoặc diện cảnh báo, ngừng giao dịch và hủy niêm yết</h5>
                        <ul class="data_list type_01">
                            <li>Đối với trường hợp chứng khoán bị đưa vào diện kiểm soát, bị đưa vào diện cảnh báo, ngừng giao dịch và hủy niêm yết, tỉ lệ ký quỹ và tỉ lệ cho vay của chứng khoán sẽ bị điều chỉnh về 0 ngay khi có thông tin chính thức các Sở giao dịch chứng khoán.</li>
                        </ul>

                        <h5 class="em">Trường hợp chứng khoán bị loại khỏi danh mục được phép giao dịch ký quỹ của Công ty</h5>
                        <ul class="data_list type_01">
                            <li>Sau khi Công ty thông báo chứng khoán bị loại khỏi danh mục chứng khoán được phép giao dịch ký quỹ, tỉ lệ ký quỹ và tỉ lệ cho vay của chứng khoán sẽ được điều chỉnh về 0.</li>
                            <li>Quý Khách hàng cần chủ động theo dõi và có phương án điều chỉnh danh mục chứng khoán nhằm hạn chế khả năng Tài khoản giao dịch ký quỹ bị gọi ký quỹ.</li>
                        </ul>

                        <h5 class="em">Gia hạn thời hạn cho vay giao dịch ký quỹ</h5>
                        <ul class="data_list type_01">
                            <li>Về nguyên tắc, Thời hạn các khoản vay là ba (03) tháng tính từ ngày giải ngân khoản vay, Khách hàng cần hoàn trả vốn vay, lãi vay và các chi phí khác có liên quan (nếu có) tại ngày đáo hạn.</li>
                            <li>Thời hạn các khoản vay có thể được MAS đồng ý gia hạn thêm tối đa một kỳ ba (03) tháng tiếp theo trên cơ sở giấy đề nghị của Quý Khách hàng.</li>
                        </ul>

                    </div>
                    <!-- // #notice -->

                    <div id="cease">
                        <h4 class="hidden">Ngừng sử dụng dịch vụ giao dịch ký quỹ</h4>

                        <p class="em">Ngừng sử dụng dịch vụ giao dịch ký quỹ</p>

                        <ul class="step_list">
                            <li>
                                <div class="step">
                                    BƯỚC<span>01</span>
                                </div>
                                <div class="body">
                                    <p>Quý Khách hàng liên hệ với Nhân viên môi giới hoặc giao dịch viên để thực hiện đầy đủ nghĩa vụ có liên quan đến Hợp đồng đã ký.</p>
                                </div>
                            </li>
                            <li>
                                <div class="step">
                                    BƯỚC<span>02</span>
                                </div>
                                <div class="body">
                                    <p>Trên cơ sở xác nhận về việc thực hiện đầy đủ nghĩa vụ quy định trong Hợp đồng, Quý Khách hàng ký “Giấy đề nghị tất toán tài khoản giao dịch ký quỹ chứng khoán”</p>
                                </div>
                            </li>
                            <li>
                                <div class="step">
                                    BƯỚC<span>03</span>
                                </div>
                                <div class="body">
                                    <p>Công ty xác nhận ngừng cung cấp dịch vụ Giao dịch mua ký quỹ với Quý Khách hàng</p>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <!-- // #cease -->
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