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
	function downloadFile() {
		$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=1&lang=en";
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
                <li><a href="/home/support/depositStock.do" class="on">Deposit stock</a></li>
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
                <li><a href="/home/support/web.do">Web trading guideline</a></li>
                <li><a href="/home/support/mobile.do">Mobile trading guideline</a></li>
                <li><a href="/home/support/fee.do">Fee table</a></li>
                <li><a href="/home/subpage/openAccount.do">Guideline on dossiers for securities account opening</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Deposit stock</h3>

            <ul class="step_list">
                <li>
                    <div class="step">
                        step<span>01</span>
                    </div>
                    <div class="body">
                        <p>Client opens a securities trading account if not having an account yet.</p>
                    </div>
                </li>
                <li>
                    <div class="step">
                        step<span>02</span>
                    </div>
                    <div class="body">
                        <p>Client fills in the securities depository form (3 copies), accompanied the shareholder book/ certificate of shares ownership.</p>
                        <a title="Download: the securities depository form" href="" class="btn_attach" onclick="downloadFile();return false;">Download</a>
                    </div>
                </li>
                <li>
                    <div class="step">
                        step<span>03</span>
                    </div>
                    <div class="body">
                        <p>The Company checks information in the securities depository form and shareholder book / certificate of shares ownership and give back to client one copy.</p>
                    </div>
                </li>
                <li>
                    <div class="step">
                        step<span>04</span>
                    </div>
                    <div class="body">
                        <p>The Company will send dossiers to VSD. After receiving the confirmation from VSD, the Company will record  securities balance in the client’s account and notify to client.</p>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>