<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Support";
	});
</script>
</head>
<body>
<script>
	function downloadFile(kind) {
		$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=" + kind + "&lang=en";
		$("body").unblock();
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Support</h2>
            <ul>
                <li><a href="/home/support/account.do">Open cash account in ACB</a></li>
                <li><a href="/home/support/depositCash.do">Deposit cash</a></li>
                <li><a href="/home/support/depositStock.do">Deposit stock</a></li>
                <li><a href="/home/support/cashAdvance.do">Cash advance</a></li>
                <li><a href="/home/support/cashTransfer.do">Cash transfer</a></li>
                <li>
                    <a href="/home/support/marginGuideline.do">Margin trading</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/support/marginGuideline.do">Guideline</a></li>
                        <li><a href="/home/support/marginList.do">List and Basic Information</a></li>
                    </ul>
                </li>
                <li><a href="/home/support/sms.do">SMS</a></li>
                <li><a href="/home/support/securities.do">Securities Trading Regulation</a></li>
                <li><a href="/home/support/web.do" class="on">Web trading guideline</a></li>
                <li><a href="/home/support/mobile.do">Mobile trading guideline</a></li>
                <li><a href="/home/support/fee.do">Fee table</a></li>
                <li><a href="/home/subpage/openAccount.do">Guideline on dossiers for securities account opening</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Web trading guideline</h3>

            <div class="trading_guide web">
                <div class="guideline">
                    <p>Web trading guideline</p>
                    <!--  
                    <a href="#" onclick="downloadFile(2);return false;">Download</a>
                    -->
                    <a href="https://masvn.com/linkDown.do?ids=27E5A128-DF4D-4D79-8542-EB9845ED7369">Download</a>                    
                </div>
                <div class="guideline">
                    <p>Derivaties trading guideline</p>
                    <a href="https://masvn.com/linkDown.do?ids=A0BC2CF1-8651-45BF-AF92-DD5EB0276AB2">Download</a>
                </div>
                <div class="risk_info" style="margin-left:0px;margin-top:10px;">
                    <p>Risk Information about<br />online trading</p>
                    <a href="#" onclick="downloadFile(3);return false;">Download</a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>