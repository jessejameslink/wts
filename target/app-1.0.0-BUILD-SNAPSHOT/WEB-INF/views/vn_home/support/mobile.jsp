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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
<script type="text/javascript" src="/resources/US/js/trading_mobile.js"></script>

</head>
<body>
<script>
	function downloadFile() {
		//$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=10&lang=vi";
		//$("body").unblock();
	}
</script>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Giao dịch bằng<br /> điện thoại</h2>                
            <ul>
                <li onclick="slideshow.pos(0)"><a href="#">Đăng nhập</a></li>
                <li onclick="slideshow.pos(1)"><a href="#">Tất cả Menu</a></li>
                <!--<li onclick="slideshow.pos(2)"><a href="#">Giá hiện tại</a></li> -->
                <li onclick="slideshow.pos(2)"><a href="#">Giao dịch chứng khoán</a></li>
                <li onclick="slideshow.pos(3)"><a href="#">Giao dịch từ </br>Danh Mục Quan Tâm</a></li>
                <li onclick="slideshow.pos(4)"><a href="#">Giao dịch từ </br>Bảng Giá</a></li>
                <li onclick="slideshow.pos(5)"><a href="#">Biểu đồ</a></li>
                <li onclick="slideshow.pos(6)"><a href="#">Thống kê giao dịch</a></li>
                <li onclick="slideshow.pos(7)"><a href="#">Dịch vụ Tiền/Vay</a></li>
                <li onclick="slideshow.pos(8)"><a href="#">Doanh mục đầu tư</a></li>
                <li onclick="slideshow.pos(9)"><a href="#">Tin tức thị trường</a></li>
                
            </ul>  
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title trading">Hệ thống giao dịch bằng điện thoại</h3>            
            <h4 class="cont_title02">ĐẶT LỆNH NHANH CHÓNG, DỮ LIỆU CẬP NHẬT LIÊN TỤC, <br />TRUY CẬP TÀI KHOẢN KHÔNG HẠN CHẾ.</h4>

			<div class="trading_guide_wrap" >
				<div class="trading_guide01">
					<div class="sldwrap">
						<div id="slider" class="slider">
							<ul>
								<li><img src="/resources/VN/images/slider01.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider02.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider04.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider06.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider07.png" alt="" /></li>
								
								<li><img src="/resources/VN/images/slider05.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider08.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider09.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider10.png" alt="" /></li>
								<li><img src="/resources/VN/images/slider11.png" alt="" /></li>
							</ul>	
						</div>
					</div>
				
					<div class="desc_txt" >
						<p>Nhà đầu tư dễ dàng truy cập sử dụng, ứng dụng có nhiều tính năng giao dịch thông minh được bảo mật cao, thuận tiện giao dịch mọi lúc mọi nơi...</p>
	
						<ul class="list_type">
							<li><a href="#">Hệ thống giao dịch chứng khoán thông qua thiết bị có hệ điều hành Android &amp; iOS.</a></li>
							<li><a href="#">Truy xuất tin tức, dữ liệu giá / chỉ số index theo dữ liệu thực tế.</a></li>
							<li><a href="#">Dễ dàng đặt lệnh với các giao dịch chào mua, chào bán tốt nhất.</a></li>
							<li><a href="#">Theo dõi &amp; quản lý tình trạng lệnh với thao tác đơn giản.</a></li>
							<li><a href="#">Chuyển tiền qua tài khoản ngân hàng.</a></li>
							<li><a href="#">Quản lý tài sản, theo dõi Lãi / lỗ.</a></li>
							<li><a href="#">Lịch sử đặt lệnh.</a></li>
						</ul>
						<!-- 
						<ul class="split_list">
							<li><a href="http://itunes.apple.com/app/id1197941600?mt=8" target="_blank"><img src="/resources/US/images/btn_app.gif" alt="Download on the App Store" /></a></li>
							<li><a href="https://play.google.com/store/apps/details?id=com.masvn&hl=vn" target="_blank"><img src="/resources/US/images/btn_google.gif" alt="GET IT ON Google Play" /></a></li>
						</ul>
						-->
						<ul class="list_type">
							<li>
                            	<b>Hướng dẫn cài đặt ứng dụng "My Asset" thông qua trang chủ App Store/Google Store: </b>
                                <a href="/home/support/mobileinstall.do" style="color:#0075c1;">Tại đây</a>
                            </li>
                            <li>
                                <b>Tải hướng dẫn sử dụng chi tiết tại đây: </b>
                                <a href="#" class="btn_attach" onclick="downloadFile(10);return false;">Tải về</a>
                            </li>
						</ul>
					
					</div>
				</div>
			</div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->


<script type="text/javascript">
var slideshow=new TINY.slider.slide('slideshow',{
	id:'slider',
	//auto:3, // 자동롤링적용
	resume:true,
	vertical:false,
	navid:'lnb',
	activeclass:'current',
	position:0
});
	
	$('#lnb ul>li>a').on('click',function(e){
		e.preventDefault();
	});
	
</script>


</body>
</html>