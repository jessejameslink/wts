<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Hệ thống GD bằng PC";
	});
	
	function downloadCounter() {
		$.ajax({
			url      : "/home/support/downloadCounter.do",			
			dataType : "json",
			success  : function(data){
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
</script>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
<script type="text/javascript" src="/resources/US/js/trading_mobile.js"></script>

</head>
<body>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Hệ thống GD<br /> bằng PC</h2>                
            <ul>
            </ul>  
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title trading">Hệ thống GD bằng PC</h3>
            
            <div class="home_trading_vn"></div>
            
			<h5 class="sub_title" style="font-weight:600;">ĐẶT LỆNH NHANH CHÓNG, DỮ LIỆU CẬP NHẬT LIÊN TỤC, TRUY CẬP TÀI KHOẢN </h5>
            <ul class="data_list type_01">
                <li>Nhà đầu tư dễ dàng truy cập sử dụng, ứng dụng có nhiều tính năng giao dịch thông minh được bảo mật cao, thuận tiện giao dịch mọi lúc mọi nơi.</li>
                <li>Truy xuất tin tức, dữ liệu giá / chỉ số index theo dữ liệu thực tế.</li>
                <li>Dễ dàng đặt lệnh với các giao dịch chào mua, chào bán tốt nhất.</li>
                <li>Theo dõi & quản lý tình trạng lệnh với thao tác đơn giản.</li>
                <li>Chuyển tiền qua tài khoản ngân hàng.</li>
                <li>Quản lý tài sản, theo dõi Lãi / lỗ.</li>
                <li>Lịch sử đặt lệnh.</li>
            </ul>
            
            <h5 class="sub_title" style="font-weight:600;">TẢI GÓI CÀI ĐẶT ỨNG DỤNG</h5>
            <a href="https://masvn.com/linkDown.do?ids=7D73EFBB-F674-476E-869E-2DD5E05674D6" onclick="downloadCounter();">
            	<div class="home_trading_app_vn"></div>
            </a>
            
            <h5 class="sub_title" style="font-weight:600;">TẢI GÓI HƯỚNG DẪN CÀI ĐẶT ỨNG DỤNG</h5>            
            <a href="https://masvn.com/linkDown.do?ids=4A0CDCA8-5102-4083-9134-5C8D11FAC09D">
            	<div class="home_trading_setup_vn"></div>
            </a>
            <h5 class="sub_title" style="font-weight:600;">TẢI HƯỚNG DẪN SỬ DỤNG ỨNG DỤNG</h5>
            <a href="https://masvn.com/linkDown.do?ids=90570B05-FAD6-453C-B93D-BF3462CF53D0">
            	<div class="home_trading_doc_vn"></div>
            </a>
        </div>
    </div>
</div>



</body>
</html>