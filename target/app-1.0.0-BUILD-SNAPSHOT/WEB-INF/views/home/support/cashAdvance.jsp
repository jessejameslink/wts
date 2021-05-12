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
                <li><a href="/home/support/cashAdvance.do" class="on">Cash advance</a></li>
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
            <h3 class="cont_title">Cash advance</h3>
            <h4 class="cont_subtitle">Description</h4>
            <ul class="data_list type_01">
                <li><span class="em">Loan rate :</span><br /> According to current interest rate provided by the Company at each time.</li>
                <li><span class="em">Time when investor can apply for loan :</span><br />The day of T, T+1 of the successful securities sale order.</li>
                <li><span class="em">Collateral assets:</span><br />Money generated from successful securities sale that not yet transferred into investor's account.</li>
                <li><span class="em">Loan procedure:</span><br /> When the securities sale order is successful, the investor may actively requests for securities Loan via our website or come directly to our offices.</li>
                <li><span class="em">Loan payment procedure:</span><br /> on T+2 day when securities sale of T day is paid to the investor, the Company system will automatically collect of debt and loan interest (calculated according to the actual number of loan days) via account of the investor opened at the Company.</li>
            </ul>

            <h4 class="cont_subtitle">Eligible customers</h4>
            <ul class="data_list type_01">
                <li>Have registered for securities transactions via account opened at the Company.</li>
                <li>Have successful securities sale order but money not yet transferred into investor's account.</li>
            </ul>

            <h4 class="cont_subtitle">Automatic cash advance</h4>
            <p>The automatic cash advance from sale of securities is the service provided by the Company to investor as soon as investor's selling
            order matched, according to which the purchasing power of investor will increase proportionally with the total proceeds from the sale
            after payment of all fees, tax (if any). The investor can use this increased purchasing power to place orders immediately, without making
            cash advance procedure in the session. The investor will only pay advance fee when orders are matched by using this extra purchasing
            power.</p>

            <div class="box ca_box">
                <p>To register for automatic cash advance, please contact our hotline<br />Ho Chi Minh: (+84) 28 3910 2222 / Ha Noi: (+84) 24 6273 0541</p>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>