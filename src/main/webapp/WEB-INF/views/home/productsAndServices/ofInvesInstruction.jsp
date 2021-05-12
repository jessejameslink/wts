<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Products & Services";
		$("#divOpenFormPop").hide();
		$("#divOrderFormPop").hide();
		$("#divCashFormPop").hide();
		$("#divCancelFormPop").hide();
	});
	
	function hideAllDlg() {
		$("#divOpenFormPop").hide();
		$("#divOrderFormPop").hide();
		$("#divCashFormPop").hide();
		$("#divCancelFormPop").hide();		
	}
	
	function divOpenFormPop(){
		$("#divOpenFormPop").fadeIn();
	}
	
	function closeOpenFormPop(){
		$("#divOpenFormPop").fadeOut();
	}
	
	function divOrderFormPop(){
		$("#divOrderFormPop").fadeIn();
	}
	
	function closeOrderFormPop(){
		$("#divOrderFormPop").fadeOut();
	}
	
	function divCashFormPop(){
		$("#divCashFormPop").fadeIn();
	}
	
	function closeCashFormPop(){
		$("#divCashFormPop").fadeOut();
	}
	
	function divCancelFormPop(){
		$("#divCancelFormPop").fadeIn();
	}
	
	function closeCancelFormPop(){
		$("#divCancelFormPop").fadeOut();
	}
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Products<br />&amp; Services</h2>
            <ul>
                <li><a href="/home/productsAndServices/individual.do">Individual Brokerage</a></li>
                <li><a href="/home/productsAndServices/institutional.do">Institutional Brokerage</a></li>
                <li><a href="/home/productsAndServices/wealth.do">Wealth Management</a></li>
                <li><a href="/home/productsAndServices/investment.do">Investment Banking</a></li>
                <li>
                	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Funds</a>
                	<ul class="lnb_sub">
                        <li>
                        	<a href="/home/productsAndServices/ofIntroduction.do" class="on">MAGEF Fund</a>
                        	<ul class="lnb_sub1">
	                        	<li>
			                    	<a href="/home/productsAndServices/ofIntroduction.do">About MAGEF</a>
			                    				                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInvesInstruction.do" class="on">Investment Guide</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInfoDisclosures.do">Report / News</a>			                    	
			                    </li>                        
		                    </ul>
                        </li>                        
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Investment Guide</h3>
			<div class="tab_container mg">
            <div class="tab">
                <div>
                	<a href="#openacc"  class="on" onclick="hideAllDlg();">Open an account in 3 steps</a>
                    <a href="#method" onclick="hideAllDlg();">Investment method</a>                    
                    <a href="#form">Forms and downloads</a>
                </div>
            </div>
            <div class="tab_conts">
            	<div id="method">
            		<div class="of_order_buy_en"></div>                    
                    <div class="of_order_sell_en"></div>
                </div>
                <div id="openacc" class="on">
                    <div class="of_open_account_en"></div>
                </div>
                <div id="form">
                    <div>
						<div>
							<button class="of_open_account_form_en" onclick="divOpenFormPop()"></button>
						</div>
						<div>
							<button class="of_order_form_en" onclick="divOrderFormPop()"></button>
						</div>
						<div>
							<button class="of_transfer_form_en" onclick="divCashFormPop()"></button>
						</div>
						<div>
							<button class="of_cancel_form_en" onclick="divCancelFormPop()"></button>
						</div>
			        </div>
                </div>
            </div>
            
            <!-- POPUP 1 -->
			<div id="divOpenFormPop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid #aaaaab;overflow:auto;height:400px; top:35%;left:60%;width:830px;">
					<div class="total_wrap" style="width:100%;">
						<h2>Application Forms</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">Customers please download the forms below as required.</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">OPEN TRADING ACCOUNT</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=11CE8EE1-1D2B-4261-9A78-6F482BC9DC7A" style="color:#0075c1;">Open-ended fund account opening application form</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">INSTITUTIONAL CUSTOMERS</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=46C14C28-39AA-4F4F-B099-7008C267C6A0" style="color:#0075c1;">Additional information of institutional investor form</a>
						</div>
					</div>
					<button class="close" type="button" onclick="closeOpenFormPop()">Huy</button>
				</div>
			</div>
			
			<!-- POPUP 2 -->
			<div id="divOrderFormPop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid #aaaaab;overflow:auto;height:400px; top:35%;left:60%;width:830px;">
					<div class="total_wrap" style="width:100%;">
						<h2>Subscription/Redemption/ Switching Forms</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">Customers please download the forms below as required.</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">SUBSCRIPTION</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=937ADFAA-4B5F-4DE5-B1DE-7750E8A1542B" style="color:#0075c1;">Subscription Form</a>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=99F52640-39B6-425A-A811-A45F49E4132D" style="color:#0075c1;">SIP form</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">REDEMPTION</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=92B087C3-22FE-4AC2-9217-2A2169AC670E" style="color:#0075c1;">Redemption Form</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">SWITCHING / TRANSFER</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=BF7FC6F5-A167-450A-BA2D-1F7B791F993F" style="color:#0075c1;">Switching form</a>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=2516FC73-7234-48F6-9EB2-0E5961C604C6" style="color:#0075c1;">Transfer form</a>
						</div>						
					</div>
					<button class="close" type="button" onclick="closeOrderFormPop()">Huy</button>
				</div>
			</div>
			
			<!-- POPUP 3 -->
			<div id="divCashFormPop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid #aaaaab;overflow:auto;height:400px; top:35%;left:60%;width:830px;">
					<div class="total_wrap" style="width:100%;">
						<h2>Money transfer instruction</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">Investor transfers subscription amount in VND directly into MAGEF’s account at Custodian bank:</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">Information for bank transfer:</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Account’s Name: MAGEF</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Account’s Number: 90359462901</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Bank: Standard Chartered Bank (Vietnam) Limited</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Amount: Subscription amount</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Content: [Trading account number] - [Investor’s Full name] Buy MAGEF</label>
							</div>
						</div>
					</div>
					<button class="close" type="button" onclick="closeCashFormPop()">Huy</button>
				</div>
			</div>
			
			<!-- POPUP 4 -->
			<div id="divCancelFormPop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid #aaaaab;overflow:auto;height:400px; top:35%;left:60%;width:830px;">
					<div class="total_wrap" style="width:100%;">
						<h2>Order cancellation and Information update form</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">Customers please download the forms below as required.</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">ORDER CANCELLATION</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=EB187B16-F390-4087-8105-AD58B0A8A41E" style="color:#0075c1;">Cancellation form</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">UPDATE INFORMATION</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=FAB7C29C-DAE1-43DF-ACCD-156F0EB95D97" style="color:#0075c1;">Change of investor registration details form</a>
						</div>
					</div>
					<button class="close" type="button" onclick="closeCancelFormPop()">Huy</button>
				</div>
			</div>
			
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>