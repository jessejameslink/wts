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
<script>
	function downloadFile() {
		$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=1&lang=vi";
		$("body").unblock();
	}
</script>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Hỗ trợ</h2>
            <ul>
                <li><a href="/home/support/account.do">Mở tài khoản tiền tại ngân hàng ACB</a></li>
                <li><a href="/home/support/wooriAccount.do">Mở tài khoản tiền tại ngân hàng Woori</a></li>
                <li><a href="/home/support/depositCash.do">Nộp tiền</a></li>
                <li><a href="/home/support/depositStock.do" class="on">Lưu ký chứng khoán</a></li>
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
            <h3 class="cont_title">Lưu ký chứng khoán</h3>

            <ul class="step_list">
                <li>
                    <div class="step">
                        BƯỚC<span>01</span>
                    </div>
                    <div class="body">
                        <p>Khách hàng mở tài khoản giao dịch chứng khoán nếu chưa có tài khoản</p>
                    </div>
                </li>
                <li>
                    <div class="step">
                        BƯỚC<span>02</span>
                    </div>
                    <div class="body">
                        <p>Khách hàng điền thông tin vào phiếu gửi chứng khoán giao dịch (3 bản), kèm theo sổ cổ đông / giấy chứng nhận sở hữu cổ phần.</p>
                        <a title="Tải xuống: Phiếu gởi chứng khoán giao dịch" href="" class="btn_attach" onclick="downloadFile();return false;">Tải về</a>
                    </div>
                </li>
                <li>
                    <div class="step">
                        BƯỚC<span>03</span>
                    </div>
                    <div class="body">
                        <p>Công ty kiểm tra thông tin trên phiếu với sổ cổ đông / giấy chứng nhận sở hữu cổ phần, trả lại cho Khách hàng 1 bản</p>
                    </div>
                </li>
                <li>
                    <div class="step">
                        BƯỚC<span>04</span>
                    </div>
                    <div class="body">
                        <p>Công ty nộp hồ sơ cho TTLKCK. Sau khi có xác nhận từ TTLKCK, Công ty sẽ hạch toán số dư chứng khoán vào tài khoản và thông báo cho Khách hàng.</p>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>