<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/VN/css/miraeasset.css">
<script type="text/javascript" src="/resources/VN/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/VN/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery.slides.min.js"></script>
<script type="text/javascript" src="/resources/VN/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container-->
<div id="container">
    <!--메인 이미지-->
    <div class="mainImg">
        <p><span>Welcome to</span><br/>
        MIRAE ASSET Wealth Management (VN)<br/>
        Building on Principles.</p>
    </div>
    <!--메인 이미지-->

    <!--dashboard-->
    <div class="dashboard">
        <!--왼쪽 WRAP-->
        <div class="marketNews">
            <!--GET STARTED TRADING WITH US-->
            <h2>GET STARTED TRADING WITH US</h2>
            <div class="get">
                <ul>
                    <li class="get1"><a href="#open_account" class="open_layer">Open An Account</a></li>
                    <li class="get2"><a href="h06_web.jsp">Web trading</a></li>
                    <li class="get3"><a href="h06_mobile.jsp">Mobile trading</a></li>
                </ul>
            </div>
            <!--GET STARTED TRADING WITH US /-->
            <!--Tin Thị trường-->
            <h2>Tin Thị trường</h2>
            <div class="data">
                <table>
                     <caption>Tin Thị trường</caption>
                     <colgroup>
                        <col style="width:20%;" />
                        <col style="width:20%;" />
                        <col style="width:20%;" />
                        <col style="width:20%;" />
                        <col style="width:20%;" />
                     </colgroup>
                     <thead>
                        <tr>
                            <th scope="col">hose</th>
                            <th scope="col">VN30</th>
                            <th scope="col">HNX</th>
                            <th scope="col">HNX30</th>
                            <th scope="col" class="r_line">UPCOM</th>
                        </tr>
                     </thead>
                     <tbody>
                        <tr>
                            <td class="upper">572.34 <p class="upper arrow">0.74 (+0.13%)</p></td>
                            <td class="up">572.34   <p class="up arrow"></span>0.74 (+0.13%)</p></td>
                            <td class="same">572.34 <p class="same arrow"></span>0.74 (+0.13%)</p></td>
                            <td class="low">572.34   <p class="low arrow"></span>0.74 (+0.13%)</p></td>
                            <td class="lower r_line">572.34 <p class="lower arrow">0.74 (+0.13%)</p></td>
                        </tr>
                     </tbody>
                 </table>
            </div>

            <ul class="news_list">
                <li>
                    <a href="#">
                        <p>DNM: Explanation for the difference in the profit after tax 2015 b</p>
                        <span>04/08/2016</span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <p>HNX - DNP: CANCELS ISSUING</p>
                        <span>04/08/2016</span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <p>Client Alert: New Circular Issued on Opening and Us</p>
                        <span>04/08/2016</span>
                    </a>
                </li>
            </ul>

            <a href="#" class="read_more">READ MORE</a>
            <!--Tin Thị trường /-->
        </div>
        <!--왼쪽 WRAP /-->

        <div class="main_aside">
            <!--ELECTRONIC BOARD-->
            <div class="electronic">
                <h2>ELECTRONIC BOARD</h2>
                <a href="#"><span>HSX</span></a>
                <a href="#"><span>HNX</span></a>
                <a href="#"><span>UPCOM</span></a>
            </div>
            <!--SUPPORT-->
            <div class="support">
                <h2>SUPPORT</h2>
                <div class="links">
                    <a href="#">Open cash account in ACB</a>
                    <a href="#">Margin trading</a>
                    <a href="#">Securities Trading Regulation</a>
                </div>
            </div>
        </div>


    </div>
    <!-- // .dashboard -->

    <div class="main_banner">
        <div class="main_banner_wrap">
            <div class="main_banner_item">
                <img src="/resources/VN/images/main_banner1.jpg" alt="innovative, simple solutions to complex problems" />
            </div>
            <div class="main_banner_item">
                <img src="/resources/VN/images/main_banner2.jpg" alt="innovative, simple solutions to complex problems" />
            </div>
        </div>
    </div>

    <!-- main_contents -->
    <div class="main_contents">
        <div class="reports">
            <!--GLOBAL NETWORK-->
            <div class="global">
                <h2>Mạng lưới toàn cầu</h2>
                <ul class="links">
                    <li class="link_au">
                        <i class="dot"></i>
                        <a href="">Úc<span>Go!</span></a>
                    </li>
                    <li class="link_ch">
                        <i class="dot"></i>
                        <a href="">Trung Quốc<span>Go!</span></a>
                    </li>
                    <li class="link_ho">
                        <i class="dot"></i>
                        <a href="">Hồng Kông<span>Go!</span></a>
                    </li>
                    <li class="link_in">
                        <i class="dot"></i>
                        <a href="">Ấn Độ<span>Go!</span></a>
                    </li>
                    <li class="link_ko">
                        <i class="dot"></i>
                        <a href="">Hàn Quốc<span>Go!</span></a>
                    </li>
                    <li class="link_ta">
                        <i class="dot"></i>
                        <a href="">Đài Loan<span>Go!</span></a>
                    </li>
                    <li class="link_vi">
                        <i class="dot"></i>
                        <a href="">Việt Nam<span>Go!</span></a>
                    </li>
                    <li class="link_br">
                        <i class="dot"></i>
                        <a href="">Brazil<span>Go!</span></a>
                    </li>
                    <li class="link_ca">
                        <i class="dot"></i>
                        <a href="">Cananda<span>Go!</span></a>
                    </li>
                    <li class="link_co">
                        <i class="dot"></i>
                        <a href="">Colombia<span>Go!</span></a>
                    </li>
                    <li class="link_us">
                        <i class="dot"></i>
                        <a href="">Mỹ<span>Go!</span></a>
                    </li>
                    <li class="link_uk">
                        <i class="dot"></i>
                        <a href="">Vương quốc Anh<span>Go!</span></a>
                    </li>
                </ul>
                <h3>THE GLOBE</h3>
                <p>We are a global organization with an on-the-ground presence in the markets in which we invest. Explore the regions of our different office locations to view what we may offer to our clients.</p>
            </div>
        </div>

        <div class="news">
            <!--RESEARCH REPORT-->
            <div class="research">
                <h2>BÁO CÁO PHÂN TÍCH</h2>
                <ul class="research_list">
                   <li>
                       <a href="#">CII [BUY +31%] - Post-restructuring solid foun-dation builds new growth phase – Re-Initiation</a>
                   </li>
                   <li>
                       <a href="#">CII [BUY +31%] - Post-restructuring solid foun-dation builds new growth phase – Re-Initiation</a>
                   </li>
                </ul>
                <a href="#" class="read_more">READ MORE</a>
            </div>
            <!--MIRAE ASSET DAEWOO news-->
            <div class="mirae_news">
                <h2>Tin MIRAE ASSET</h2>
                <ul>
                    <li>
                        <a class="layer_link">
                            <p>DNM: Explanation for the difference in the profit after tax 2015 b</p>
                            <span>2016-09-12 10:48:56.0</span>
                        </a>
                        <a class="new_link" title="Read Detail">read detail</a>
                    </li>
                    <li>
                        <a class="layer_link">
                            <p>DNM: Explanation for the difference in the profit after tax 2015 b</p>
                            <span>2016-09-12 10:48:56.0</span>
                        </a>
                        <a class="new_link" title="Read Detail">read detail</a>
                    </li>
                    <li>
                        <a class="layer_link">
                            <p>DNM: Explanation for the difference in the profit after tax 2015 b</p>
                            <span>2016-09-12 10:48:56.0</span>
                        </a>
                        <a class="new_link" title="Read Detail">read detail</a>
                    </li>
                </ul>
                <a href="#" class="read_more">READ MORE</a>
            </div>
        </div>
    </div>
    <!-- // .main_contents -->
</div>
<!--container/-->

<div id="open_account" class="layer_pop">
    <div class="layer_pop_container">
        <h2 class="cont_title">Mở tài khoản</h2>
        <h3 class="cont_subtitle">HƯỚNG DẪN HỒ SƠ MỞ TÀI KHOẢN GIAO DỊCH CHỨNG KHOÁN</h3>

        <div class="tab_container">
            <div class="tab">
                <div>
                    <a href="#dom_indi" class="on">Khách hàng cá<br />nhân trong nước</a>
                    <a href="#fore_indi">Khách hàng cá<br />nhân nước ngoài</a>
                    <a href="#dom_inst">Khách hàng tổ<br />chức trong nước</a>
                    <a href="#fore_inst">Khách hàng tổ<br />chức nước ngoài</a>
                </div>
            </div>

            <div class="tab_conts">
                <div id="dom_indi" class="on">
                    <table class="table_style_01">
                        <caption>Customers are domestic individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Hồ sơ mở tài khoản cho Khách hàng cá nhân trong nước bao gồm</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                        </li>
                                        <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                        </li>
                                        <li>Bản sao CMND (1 bản, không quá 15 năm)</li>
                                        <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND của người được ủy quyền (nếu có)     (1 bản)</li>
                                        <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- // #dons_indi -->

                <div id="fore_indi">
                    <h3 class="sec_title">I. <span class="em">Mở tài khoản giao dịch chứng khoán tại Công ty.</span> Hồ sơ bao gồm :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Khách hàng chưa có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                         </li>
                                         <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                         </li>
                                         <li>Bản sao công chứng hộ chiếu (1 bản)</li>
                                         <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND hoặc hộ chiếu của người được ủy quyền (nếu có) (1 bản)</li>
                                         <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                         <li>Giấy đăng ký mã số giao dịch (1 bản)</li>
                                         <li>Giấy ủy quyền cho Công ty thực hiện đăng ký mã số giao dịch</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Ghi chú</em>
                                        <p>* Ngoại trừ tài liệu bằng tiếng Anh hoặc bản dịch tiếng Anh đã được công chứng hoặc chứng thực theo pháp luật nước ngoài, tài liệu bằng các tiếng nước ngoài khác phải được dịch ra tiếng Việt bởi tổ chức dịch thuật hoạt động hợp pháp tại Việt Nam</p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Khách hàng đã có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                        </li>
                                        <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                        </li>
                                        <li>Bản sao công chứng hộ chiếu (1 bản)</li>
                                        <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND hoặc hộ chiếu của người được ủy quyền (nếu có) (1 bản)</li>
                                        <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                        <li>Bản sao Giấy chứng nhận đăng ký mã số giao dịch chứng khoán (1 bản)</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">Trường hợp tất toán tài khoản tại thành viên lưu ký cũ: cần nộp thêm:</p>
                                        <p>* Giấy đề nghị tất toán tài khoản tại thành viên lưu ký cũ (01 bản)</p>
                                        <p>* Báo cáo về một số thay đổi của nhà đầu tư nước ngoài (1 bản)</p>
                                        <p>* Giấy ủy quyền cho Công ty báo cáo các thay đổi có liên quan (1 bản)</p>
                                    </div>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Mở tài khoản vốn đầu tư gián tiếp tại Ngân hàng ACB (đối với khách hàng nước ngoài không cư trú): </span> Tham khảo thủ tục tại mục HỖ TRỢ</h3>
                </div>
                <!-- // #fore_indi -->

                <div id="dom_inst">
                    <table class="table_style_01">
                        <caption>Customers are domestic institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Hồ sơ mở tài khoản cho Khách hàng tổ chức trong nước bao gồm</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                         </li>
                                         <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                         </li>
                                         <li>Bản sao công chứng quyết định thành lập hoặc giấy chứng nhận đăng ký kinh doanh (1 bản);</li>
                                         <li>Bản sao công chứng Quyết định bổ nhiệm Tổng giám đốc / Giám đốc, Kế toán trưởng (nếu có);</li>
                                         <li>Bản sao CMND hoặc hộ chiếu của người đại diện, người được ủy quyền (nếu có) (1 bản);</li>
                                         <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- // #dom_inst -->

                <div id="fore_inst">
                    <h3 class="sec_title">I. <span class="em">Mở tài khoản giao dịch chứng khoán tại Công ty.</span> Hồ sơ bao gồm :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Khách hàng chưa có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                         </li>
                                         <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                         </li>
                                         <li>Bản sao hợp lệ giấy phép thành lập và hoạt động hoặc giấy chứng nhận đăng ký kinh doanh hoặc tài liệu tương đương do cơ quan quản lý có thẩm quyền nước ngoài cấp, xác nhận đã hoàn tất việc đăng ký kinh doanh; giấy phép thành lập tổ chức và chi nhánh tại Việt Nam (đối với chi nhánh của tổ chức nước ngoài tại Việt Nam); hoặc Giấy đăng ký thuế của cơ quan thuế nước nơi tổ chức đó thành lập hoặc đăng ký kinh doanh hoặc Tài liệu khác theo hướng dẫn của TTLKCK;</li>
                                         <li>Giấy chỉ định người đại diện theo pháp luật;</li>
                                         <li>Bản sao hộ chiếu của người đại diện theo pháp luật (1 bản).</li>
                                         <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                         <li>Giấy đăng ký mã số giao dịch chứng khoán (1 bản);</li>
                                         <li>Giấy ủy quyền cho Công ty thực hiện đăng ký mã số giao dịch</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Lưu ý</em>
                                        <p>* Hồ sơ được lập thành hai (02) bộ: một (01) bộ gốc và một (01) bộ sao. </p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Khách hàng đã có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                        </li>
                                        <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)
                                            <a href="" class="btn_attach">Attach pdf file</a>
                                        </li>
                                        <li>Bản sao công chứng Giấy phép thành lập và hoạt động hoặc Giấy chứng nhận đăng ký kinh doanh</li>
                                        <li>Bản sao hộ chiếu của người đại diện theo pháp luật (1 bản)</li>
                                        <li>Giấy ủy quyền và bản sao Hộ chiếu của người được ủy quyền (nếu có) (1 bản).</li>
                                        <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                        <li>Bản sao Giấy chứng nhận đăng ký mã số giao dịch chứng khoán (1 bản)</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">Trường hợp tất toán tài khoản tại thành viên lưu ký cũ: cần nộp thêm</p>
                                        <p>* Giấy đề nghị tất toán tài khoản tại thành viên lưu ký cũ (1 bản);</p>
                                        <p>* Báo cáo về một số thay đổi của nhà đầu tư nước ngoài (1 bản);</p>
                                        <p>* Giấy ủy quyền cho Công ty báo cáo các thay đổi có liên quan (1 bản)</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Mở tài khoản vốn đầu tư gián tiếp tại một ngân hàng lưu ký hoặc tại ngân hàng ACB (đối với khách hàng nước ngoài không cư trú) :</span> Tham khảo thủ tục tại mục HỖ TRỢ</h3>
                </div>
                <!-- // #fore_inst -->
            </div>
        </div>

        <button type="button" class="btn_close_pop">close layerpopup</button>
    </div>
</div>
<!-- // .layer_pop -->

<div id="detail" class="layer_pop">
    <div class="layer_pop_container">
        <h2 class="cont_title">News detail</h2>
        <div class="board">
            <table>
                <tbody>
                    <tr>
                        <th>title</th>
                        <td>slfajlfjasdlfia</td>
                    </tr>
                    <tr>
                        <th>date</th>
                        <td>11:11</td>
                    </tr>
                    <tr>
                        <th>content</th>
                        <td>
                            <textarea name="" id="" cols="30" rows="10"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <button type="button" class="btn_close_pop">close layerpopup</button>
    </div>
</div>

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>