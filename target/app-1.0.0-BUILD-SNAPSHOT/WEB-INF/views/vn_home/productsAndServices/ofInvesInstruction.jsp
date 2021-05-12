<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Sản phẩm & Dịch vụ";
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
            <h2>Sản phẩm<br />&amp; Dịch vụ</h2>
            <ul>
                <li><a href="/home/productsAndServices/individual.do">Môi giới Khách hàng cá nhân</a></li>
                <li><a href="/home/productsAndServices/institutional.do">Môi giới Khách hàng tổ chức</a></li>
                <li><a href="/home/productsAndServices/wealth.do">Quản lý tài sản</a></li>
                <li><a href="/home/productsAndServices/investment.do">Ngân hàng đầu tư</a></li>
                <li>
                	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Quỹ</a>
                	<ul class="lnb_sub">
                        <li>
                        	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Quỹ MAGEF</a>
                        	<ul class="lnb_sub1">
	                        	<li>
			                    	<a href="/home/productsAndServices/ofIntroduction.do">Thông tin quỹ</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInvesInstruction.do" class="on">Hướng dẫn đầu tư</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInfoDisclosures.do">Công bố thông tin</a>			                    	
			                    </li>                        
		                    </ul>
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/ofbIntroduction.do">VFMVFB</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/ofcIntroduction.do">VFMVFC</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/of1Introduction.do">VFMVF1</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/of4Introduction.do">VFMVF4</a>                        	
                        </li>                        
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Hướng dẫn đầu tư</h3>
            <div class="tab_container mg">
            <div class="tab">
                <div>
                	<a href="#openacc" class="on" onclick="hideAllDlg();">Mở tài khoản qua 3 bước</a>
                    <a href="#method" onclick="hideAllDlg();">Cách thức đầu tư</a>                    
                    <a href="#form">Biểu mẫu dành cho nhà đầu tư</a>
                </div>
            </div>
            <div class="tab_conts">
            	<div id="method" class="on">
            		<div class="of_order_buy_vn"></div>                    
                    <div class="of_order_sell_vn"></div>
                </div>
                <div id="openacc">
                    <div class="of_open_account_vn"></div>
                </div>
                <div id="form">
                    <div>
						<div>
							<button class="of_open_account_form_vn" onclick="divOpenFormPop()"></button>
						</div>
						<div>
							<button class="of_order_form_vn" onclick="divOrderFormPop()"></button>
						</div>
						<div>
							<button class="of_transfer_form_vn" onclick="divCashFormPop()"></button>
						</div>
						<div>
							<button class="of_cancel_form_vn" onclick="divCancelFormPop()"></button>
						</div>
			        </div>
                </div>
            </div>
            </div>
            
            <!-- POPUP 1 -->
			<div id="divOpenFormPop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid #aaaaab;overflow:auto;height:400px; top:35%;left:60%;width:830px;">
					<div class="total_wrap" style="width:100%;">
						<h2>Biểu mẫu mở tài khoản</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">Khách hàng cá nhân và Khách hàng tổ chức vui lòng tải các biểu mẫu dưới đây theo nhu cầu.</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">MỞ TÀI KHOẢN</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=11CE8EE1-1D2B-4261-9A78-6F482BC9DC7A" style="color:#0075c1;">Giấy đăng ký mở tài khoản giao dịch chứng chỉ quỹ mở</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">NHÀ ĐẦU TƯ TỔ CHỨC</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=46C14C28-39AA-4F4F-B099-7008C267C6A0" style="color:#0075c1;">Phiếu thông tin bổ sung của nhà đầu tư tổ chức</a>
						</div>
					</div>
					<button class="close" type="button" onclick="closeOpenFormPop()">Huy</button>
				</div>
			</div>
			
			<!-- POPUP 2 -->
			<div id="divOrderFormPop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid #aaaaab;overflow:auto;height:400px; top:35%;left:60%;width:830px;">
					<div class="total_wrap" style="width:100%;">
						<h2>Biểu mẫu đặt lệnh mua/bán/chuyển đổi</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">Khách hàng vui lòng tải các biểu mẫu dưới đây theo nhu cầu.</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">LỆNH MUA</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=937ADFAA-4B5F-4DE5-B1DE-7750E8A1542B" style="color:#0075c1;">Biểu mẫu mua CCQ</a>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=99F52640-39B6-425A-A811-A45F49E4132D" style="color:#0075c1;">Đầu tư định kỳ SIP</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">LỆNH BÁN</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=92B087C3-22FE-4AC2-9217-2A2169AC670E" style="color:#0075c1;">Biểu mẫu bán CCQ</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">CHUYỂN ĐỔI / CHUYỂN NHƯỢNG</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=BF7FC6F5-A167-450A-BA2D-1F7B791F993F" style="color:#0075c1;">Biểu mẫu chuyển đổi</a>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=2516FC73-7234-48F6-9EB2-0E5961C604C6" style="color:#0075c1;">Biểu mẫu chuyển nhượng</a>
						</div>						
					</div>
					<button class="close" type="button" onclick="closeOrderFormPop()">Huy</button>
				</div>
			</div>
			
			<!-- POPUP 3 -->
			<div id="divCashFormPop" class="modal_wrap">
				<div class="modal_layer add total" style="padding: 20px 40px; border:1px solid #aaaaab;overflow:auto;height:400px; top:35%;left:60%;width:830px;">
					<div class="total_wrap" style="width:100%;">
						<h2>Hướng dẫn chuyển tiền đầu tư</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">Nhà Đầu Tư/ Người được nhà đầu tư ủy quyền nộp tiền mua Chứng Chỉ Quỹ bằng cách chuyển khoản vào tài khoản của Quỹ tại Ngân Hàng Giám Sát bằng đồng Việt Nam. Phí dịch vụ chuyển tiền do Nhà Đầu Tư trả. Thông tin về tài khoản của Quỹ tại Ngân Hàng Giám Sát sẽ được cung cấp bởi Đại Lý Phân Phối. Nội dung chuyển tiền của nhà đầu tư chuyển tới ngân hàng như sau:</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Tên tài khoản:   	MAGEF</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Số tài khoản:   		90359462905</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Tên ngân hàng:	Standard Chartered Bank (VN) Limited</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Số tiền:   			Số tiền đăng ký mua</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">- Nội dung: [Số tài khoản giao dịch CCQ mở]-[Họ tên nhà đầu tư]-[MAGEFN001] (Ví dụ: 077CAxxxxx-Nguyen Van A-MAGEFN001)</label>
							</div>
						</div>
						
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;">Thời hạn thanh toán: Việc thanh toán sẽ được thực hiện trước ngày kết thúc đợt phát hành.</label>
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
						<h2>Phiếu yêu cầu hủy lệnh hoặc thay đổi thông tin</h2>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">Khách hàng vui lòng tải các biểu mẫu dưới đây theo nhu cầu.</label>
							</div>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">LỆNH HỦY</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=EB187B16-F390-4087-8105-AD58B0A8A41E" style="color:#0075c1;">Biểu mẫu hủy lệnh</a>
						</div>
						<div class="search_area" style="text-align:left;width:100%;margin-top:10px;">
							<div class="input_search">
								<label style="color:#333;display:inline;font-weight:600;">THAY ĐỔI THÔNG TIN</label>
							</div>
						</div>
						<div style="padding-top:10px;">
							<a href="https://masvn.com/linkDown.do?ids=FAB7C29C-DAE1-43DF-ACCD-156F0EB95D97" style="color:#0075c1;">Biểu mẫu thay đổi thông tin</a>
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