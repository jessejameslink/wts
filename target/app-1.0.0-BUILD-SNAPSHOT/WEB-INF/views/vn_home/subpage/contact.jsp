<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Liên hệ";
		Captcha();
		setInterval(Captcha, 600000);
	});
	function goMaps(a,b) {
		$("#dialog").dialog({
            modal: true,
            title: "Google Map",
            width: 600,
            hright: 450,
            buttons: {
                Close: function () {
                    $(this).dialog('close');
                }
            },
            open: function () {
            	var latlng = new google.maps.LatLng(a, b);
                var mapOptions = {
                    center: latlng,
                    zoom: 17,
                    scrollwheel: false,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                }
                var map = new google.maps.Map($("#dvMap")[0], mapOptions);
                /*var myMarker = new google.maps.Marker(
                {
                    position: latlng,
                    map: map,
                    title:"Local"
                });*/
                var marker = new google.maps.Marker({
                    position: map.getCenter(),
                    map: map,
                    animation: google.maps.Animation.BOUNCE
                });
            }
        });
	}
	
	function sendContactEmail() {
		//Check captcha
		if (!ValidCaptcha()) {
			alert("Hãy nhập chính xác các ký tự trong hình.");			
			$("#cpt").focus();
			return;
		}
		var param = {
				name              : $("#name").val(),
				phone             : $("#phone").val(),
				email             : $("#email").val(),
				content			  : $("#cont").val()
		};

		$.ajax({
			type     : "POST",
			url      : "/home/subpage/contact.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.trResult != null) {
					if (data.trResult == "error") {
						alert("Có lỗi khi gởi mail.");
					} else if (data.trResult == "success") {
						alert("Chúng tôi sẽ liên lạc sớm. Cảm ơn!");
						clearInfo();
						Captcha();
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	function clearInfo() {
		$("#name").val("");
		$("#phone").val("");
		$("#email").val("");
		$("#cont").val("");
		$("#cpt").val("");
	}
	
	function Captcha(){
	    var alpha = new Array('0','1','2','3','4','5','6','7','8','9');
	    var i;
	    for (i=0;i<6;i++){
	        var a = alpha[Math.floor(Math.random() * alpha.length)];
	        var b = alpha[Math.floor(Math.random() * alpha.length)];
	        var c = alpha[Math.floor(Math.random() * alpha.length)];
	        var d = alpha[Math.floor(Math.random() * alpha.length)];
	                     }
	        var code = a + ' ' + b + ' ' + ' ' + c + ' ' + d;
			$("#captcha").val(code);
	      }
	function ValidCaptcha(){
	    var string1 = removeSpaces($("#captcha").val());
	    var string2 = $("#cpt").val();
	    if (string1 == string2){
	           return true;
	    } else {        
	         return false;
	    }
	}
	function removeSpaces(string){
	    return string.split(' ').join('');
	}
</script>
<style type="text/css">
</style>
</head>
<body>
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBgvmpa6i6TM2hf3X3Prn_sLc0UhZkl_9c&region=KR" type="text/javascript"></script>
<!--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/jquery-ui.js" type="text/javascript"></script>
<link href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.9/themes/blitzer/jquery-ui.css" rel="stylesheet" type="text/css" />-->
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <div id="contents" class="full_width">
            <h3 class="cont_title">Liên Hệ</h3>

            <div class="contact_us">
                <div class="addr">
                    <div class="hq">
                        <h4>TRỤ SỞ CHÍNH</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà Le Meridien , Tầng 7, 3C Tôn Đức Thắng,<br />Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-28-39102222</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(10.7797548,106.7075786)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>
                    
                    <div class="hcm">
                        <h4>CHI NHÁNH HỒ CHÍ MINH</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà Sài Gòn Royal , Tầng 7, 91 Pasteur,<br />Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-28-39102222</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            
                            <input class="btnMap" type="button" onclick="goMaps(10.7769886,106.6993054)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>
                    
                    <div class="sg">
                        <h4>CHI NHÁNH SÀI GÒN</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà Green Power , Tầng 16, 35 Tôn Đức Thắng,<br />Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-28-39102222</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            
                            <input class="btnMap" type="button" onclick="goMaps(10.783691, 106.704086)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>

                    <div class="hanoi">
                        <h4>CHI NHÁNH HÀ NỘI</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà HCO, Tầng 3, 44B Lý Thường Kiệt,</br>Quận Hoàn Kiếm, Hà Nội</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-24-73093968</dd>
                            <dt>Fax</dt>
                            <dd>84-24-39387198</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" type="button" onclick="goMaps(21.023161,105.85281)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>
                    
                    <div class="vungtau">
                        <h4>CHI NHÁNH VŨNG TÀU</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>102A Lê Hồng Phong, Phường 4<br />Tp. Vũng Tàu, Tỉnh Bà Rịa - Vũng Tàu</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-254-7303968</dd>
                            <dt>Fax</dt>
                            <dd>84-254-7303968</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(10.359080,107.078730)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>
                    
                    <div class="thanglong">
                        <h4>CHI NHÁNH THĂNG LONG</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà Gelex, 52 Lê Đại Hành, Phường Lê Đại Hành, Quận Hai Bà Trưng, Hà Nội</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-24-73083968</dd>
                            <dt>Fax</dt>
                            <dd>84-24-32151002</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(21.010010,105.849800)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>
                    
                    <div class="danang">
                        <h4>CHI NHÁNH ĐÀ NẴNG</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà Vĩnh Trung Plaza, 255-257 Hùng Vương, Phường Vĩnh Trung, Quận Thanh Khê, Tp. Đà Nẵng</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-236-7303968</dd>
                            <dt>Fax</dt>
                            <dd>84-236-7303968</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(16.066910,108.212260)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>
                    
                    <div class="cantho">
                        <h4>CHI NHÁNH CẦN THƠ</h4>
                        <dl>
                            <dt>Địa chỉ</dt>
                            <dd>Tòa nhà VCCI Cần Thơ, 12 Hòa Bình, Phường An Cư, Quận Ninh Kiều, Tp. Cần Thơ</dd>
                            <dt>Điện thoại</dt>
                            <dd>84-292-7303968</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(10.034322,105.784931)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">Xem bản đồ</p>
                        </dl>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
</div>
<div id="dialog" style="display: none">
<div id="dvMap" style="height: 380px; width: 580px;">
</div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>