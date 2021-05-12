<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | <%= (langCd.equals("en_US") ? "Open an account" : "Mở tài khoản") %>";
	});
	function downloadFile(nkind) {
		location.href="https://www.masvn.com/downloadFile.do?ids=" + nkind;
	}
	
</script>

</head>
<body>
	<div id="container" class="sub">
    <div class="sub_container">
        <div id="open_account" class="full_width" style="padding-top:20px;padding-left:20px;padding-right:20px;">
    
        <h3 class="cont_title"><%= (langCd.equals("en_US") ? "Open an account" : "Mở tài khoản") %></h3>
        <h4 class="cont_subtitle"><%= (langCd.equals("en_US") ? "GUIDELINE ON DOSSIERS FOR SECURITIES ACCOUNT OPENING" : "HƯỚNG DẪN HỒ SƠ MỞ TÀI KHOẢN GIAO DỊCH CHỨNG KHOÁN") %></h4>

        <div class="tab_container">
            <div class="tab">
                <div>
                    <a href="#dom_indi" class="on"><%= (langCd.equals("en_US") ? "Customers are<br />domestic individuals" : "Khách hàng cá<br />nhân trong nước") %></a>
                    <a href="#fore_indi"><%= (langCd.equals("en_US") ? "Customers are<br />foreign individuals" : "Khách hàng cá<br />nhân nước ngoài") %></a>
                    <a href="#dom_inst"><%= (langCd.equals("en_US") ? "Customers are<br />domestic institutions" : "Khách hàng tổ<br />chức trong nước") %></a>
                    <a href="#fore_inst"><%= (langCd.equals("en_US") ? "Customers are<br />foreign institutions" : "Khách hàng tổ<br />chức nước ngoài") %></a>
                </div>
            </div>

            <div class="tab_conts">
                <div id="dom_indi" class="on">
                <% if(langCd.equals("en_US")) { %>
                    <table class="table_style_01">
                        <caption>Customers are domestic individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Dossiers for<br />domestic individual</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Request and Contract for opening securities trading account (2 copies)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <!-- <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li> -->
                                         <li>A copy of ID card (not exceeding 15 years);</li>
                                         <li>A letter of attorney must be certified by the notary / state agencies in accordance with the law and a copy of ID of the authorized person (if any);</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% } else { %>
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
                                            Đề nghị mở tài khoản và Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
                                        </li>
                                        <!-- <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
                                        </li> -->
                                        <li>Bản sao CMND (1 bản, không quá 15 năm)</li>
                                        <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND của người được ủy quyền (nếu có) (1 bản)</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% }%>
                </div>
                <!-- // #dons_indi -->

                <div id="fore_indi">
                <% if(langCd.equals("en_US")) { %>
                    <h3 class="sec_title">I. <span class="em">Open securities trading account at the Company.</span> Dossiers include :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Customers haven’t got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Request and Contract for opening securities trading account (2 copies)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <!-- <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li> -->
                                         <li>A notarized copy of passport;</li>
                                         <li>A letter of attorney must be certified by the notary/ state agencies and a copy of identity card or passport of the authorized person (if any);</li>
                                         <li>Application for securities trading code (1 copy).</li>
                                         <li>A power of attorney to the Company to apply for trading code;</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Notes</em>
                                        <p>* Files and documents specified are in foreign language, they must be translated into Vietnamese and certified translations of contents by the Vietnamese public notary (Except for documents in English or English translation version which has been notarized, authenticated in accordance with foreign law).</p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Customers already got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Request and Contract for opening securities trading account (2 copies)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <!-- <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li> -->
                                        <li>A notarized copy of passport;</li>
                                        <li>A letter of attorney must be certified by the notary/ state agencies and a copy of identity card or passport of the authorized person (if any);</li>
                                        <li>A copy of securities trading code certificate.</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">In case Customer closed account at the old depository member, submit more :</p>
                                        <p>* Request for closing account at the old depository member (1 copy);</p>
                                        <p>* Request for some changes of foreign investor (1 copy);</p>
                                        <p>* A power of attorney for depository member to change information;</p>
                                    </div>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Open indirect investment capital account at ACB bank (for non-residence foreign customers) :</span> Please refer procedure at menu SUPPORT</h3>
                <% } else { %>
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
		                                       Đề nghị mở tài khoản và Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
		                                      <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
		                                 </li>
		                                 <!-- <li>
		                                       Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)<br />
		                                      <a href="" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
		                                 </li> -->
                                         <li>Bản sao công chứng hộ chiếu (1 bản)</li>
                                         <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND hoặc hộ chiếu của người được ủy quyền (nếu có) (1 bản)</li>
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
		                                       Đề nghị mở tài khoản và Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
		                                      <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
		                                 </li>
		                                 <!-- <li>
		                                       Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)<br />
		                                      <a href="" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
		                                 </li> -->
                                        <li>Bản sao công chứng hộ chiếu (1 bản)</li>
                                        <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND hoặc hộ chiếu của người được ủy quyền (nếu có) (1 bản)</li>
                                        <li>Bản sao Giấy chứng nhận đăng ký mã số giao dịch chứng khoán (1 bản)</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">Trường hợp tất toán tài khoản tại thành viên lưu ký cũ: cần nộp thêm:</p>
                                        <p>* Giấy đề nghị tất toán tài khoản tại thành viên lưu ký cũ (1 bản)</p>
                                        <p>* Báo cáo về một số thay đổi của nhà đầu tư nước ngoài (1 bản)</p>
                                        <p>* Giấy ủy quyền cho Công ty báo cáo các thay đổi có liên quan (1 bản)</p>
                                    </div>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Mở tài khoản vốn đầu tư gián tiếp tại Ngân hàng ACB (đối với khách hàng nước ngoài không cư trú): </span> Tham khảo thủ tục tại mục HỖ TRỢ</h3>
                <% }%>
                </div>
                <!-- // #fore_indi -->

                <div id="dom_inst">
                <% if(langCd.equals("en_US")) { %>
                    <table class="table_style_01">
                        <caption>Customers are domestic institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Dossiers for<br />domestic institution</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Request and Contract for opening securities trading account (2 copies)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <!-- <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li> -->
                                         <li>A notarized copy of Establishment Decision or Business Registration Certificate;</li>
                                         <li>A notarized copy of Appointing Decision for General Director / Director, Chief Accountant (if any);</li>
                                         <li>A copy of ID card or passport of the representative, the authorized person (if any);</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% } else { %>
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
		                                       Đề nghị mở tài khoản và Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
		                                      <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
		                                 </li>
		                                 <!-- <li>
		                                       Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)<br />
		                                      <a href="" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
		                                 </li> -->
                                         <li>Bản sao công chứng quyết định thành lập hoặc giấy chứng nhận đăng ký kinh doanh (1 bản);</li>
                                         <li>Bản sao công chứng Quyết định bổ nhiệm Tổng giám đốc / Giám đốc, Kế toán trưởng (nếu có);</li>
                                         <li>Bản sao CMND hoặc hộ chiếu của người đại diện, người được ủy quyền (nếu có) (1 bản);</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% }%>
                </div>
                <!-- // #dom_inst -->

                <div id="fore_inst">
                <% if(langCd.equals("en_US")) { %>
                    <h3 class="sec_title">I. <span class="em">Open securities trading account at the Company.</span> Dossiers include :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Customers haven’t got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Request and Contract for opening securities trading account (2 copies)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <!-- <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li> -->
                                         <li>A valid copy of the Establishment Decision or Business Registration Certificate or equivalent document issued by the competent administrative body of the country of domicile which ensures the completion of business registration; License for Establishment of the organization and its branch in Vietnam (for branches of foreign institution locating in Vietnam); or Tax Registration from the national tax authority of the country of domicile, or Other documents as guided by Vietnam Securities Depository ;</li>
                                         <li>An appointment letter of the legal representative;</li>
                                         <li>A notarized copy of passport of the legal representative;</li>
                                         <li>Application for securities trading code made by foreign investors (1 copy);</li>
                                         <li>A power of attorney to the Company to apply for trading code;</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Notes</em>
                                        <p>* The files are made in two (02) sets, one (01) original and one (01) copy.</p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Customers already got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Request and Contract for opening securities trading account (2 copies)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <!-- <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li> -->
                                        <li>A notarized copy of license for establishment and operation or the certificate of business registration;</li>
                                        <li>A copy of passport of the legal representative;</li>
                                        <li>A power of attorney  and 01 copy of passport of authorized person (if any);</li>
                                        <li>A copy of certificate of securities trading code.</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">In case Customer closed account at the old depository member, submit more :</p>
                                        <p>* Request for closing account at the old depository member (1 copy);</p>
                                        <p>* Request for some changes of foreign investor (1 copy);</p>
                                        <p>* A power of attorney for depository member to change information;</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Open indirect investment capital account at ACB bank (for non-residence foreign customers) :</span> Please refer procedure at menu SUPPORT</h3>
                <% } else { %>
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
		                                       Đề nghị mở tài khoản và Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
		                                      <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
		                                 </li>
		                                 <!-- <li>
		                                       Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)<br />
		                                      <a href="" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
		                                 </li> -->
                                         <li>Bản sao hợp lệ giấy phép thành lập và hoạt động hoặc giấy chứng nhận đăng ký kinh doanh hoặc tài liệu tương đương do cơ quan quản lý có thẩm quyền nước ngoài cấp, xác nhận đã hoàn tất việc đăng ký kinh doanh; giấy phép thành lập tổ chức và chi nhánh tại Việt Nam (đối với chi nhánh của tổ chức nước ngoài tại Việt Nam); hoặc Giấy đăng ký thuế của cơ quan thuế nước nơi tổ chức đó thành lập hoặc đăng ký kinh doanh hoặc Tài liệu khác theo hướng dẫn của TTLKCK;</li>
                                         <li>Giấy chỉ định người đại diện theo pháp luật;</li>
                                         <li>Bản sao hộ chiếu của người đại diện theo pháp luật (1 bản).</li>
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
		                                       Đề nghị mở tài khoản và Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
		                                      <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
		                                 </li>
		                                 <!-- <li>
		                                       Hợp đồng mở tài khoản giao dịch chứng khoán (2 copies)<br />
		                                      <a href="" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
		                                 </li> -->
                                        <li>Bản sao công chứng Giấy phép thành lập và hoạt động hoặc Giấy chứng nhận đăng ký kinh doanh</li>
                                        <li>Bản sao hộ chiếu của người đại diện theo pháp luật (1 bản)</li>
                                        <li>Giấy ủy quyền và bản sao Hộ chiếu của người được ủy quyền (nếu có) (1 bản).</li>
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
                <% }%>
                </div>
                <!-- // #fore_inst -->
            </div>
        </div>
    
		</div>
    </div>
	</div>
	
</body>
</html>