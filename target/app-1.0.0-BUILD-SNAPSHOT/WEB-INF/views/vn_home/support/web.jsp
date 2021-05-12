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
	function downloadFile(kind) {
		$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=" + kind + "&lang=vi";
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
                <li><a href="/home/support/web.do" class="on">Hướng dẫn giao dịch trực tuyến qua website</a></li>
                <li><a href="/home/support/mobile.do">Hướng dẫn giao dịch qua ứng dụng điện thoại</a></li>
                <li><a href="/home/support/fee.do">Biểu phí</a></li>
                <li><a href="/home/subpage/openAccount.do">Hướng dẫn hồ sơ mở tài khoản chứng khoán cơ sở</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Hướng dẫn giao dịch trực tuyến qua website</h3>

            <div class="trading_guide web">
                <div class="guideline">
                    <p>Hướng dẫn giao dịch trực tuyến qua website</p>
                    <!--  
                    <a href="#" onclick="downloadFile(2);return false;">Tải về</a>
                    -->
                    <a href="https://masvn.com/linkDown.do?ids=160E41F3-5592-40FA-BDA1-1F5C6EA5F987">Tải về</a>                    
                </div>
                <div class="guideline">
                    <p>Hướng dẫn giao dịch Phái sinh qua website</p>
                    <a href="https://masvn.com/linkDown.do?ids=380E9949-D912-4E00-A675-38521F2312BE">Tải về</a>
                </div>
                <div class="risk_info" style="margin-left:0px;margin-top:10px;">
                    <p>Bản công bố rủi ro về giao dịch trực tuyến</p>
                    <a href="#" onclick="downloadFile(3);return false;">Tải về</a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>