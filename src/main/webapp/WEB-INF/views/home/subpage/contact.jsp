<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Contact";
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
			alert("Let's input right character same the picture.");			
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
						alert("Error in Sending Email!");
					} else if (data.trResult == "success") {
						alert("We will be in touch soon. Thank you!");
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
            <h3 class="cont_title">Contact Us</h3>

            <div class="contact_us">
                <div class="addr">
                    <div class="hq">
                        <h4>HEADQUARTER</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>7th Floor, Le Meridien building, 3C Ton Duc Thang street, Ben Nghe Ward, District 1, Ho Chi Minh</dd>
                            <dt>Tel</dt>
                            <dd>84-28-39102222</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(10.7797548,106.7075786)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
                        </dl>
                    </div>
                    
                    <div class="hcm">
                        <h4>HO CHI MINH BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>7th Floor, Sai Gon Royal building, 91 Pasteur street,<br />Ben Nghe Ward, District 1, Ho Chi Minh</dd>
                            <dt>Tel</dt>
                            <dd>84-28-39102222</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" type="button" onclick="goMaps(10.7769886,106.6993054)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
                        </dl>
                    </div>
                    
                    <div class="sg">
                        <h4>SAI GON BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>16th Floor, Green Power building, 35 Ton Duc Thang street,<br />Ben Nghe Ward, District 1, Ho Chi Minh</dd>
                            <dt>Tel</dt>
                            <dd>84-28-39102222</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" type="button" onclick="goMaps(10.783691, 106.704086)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
                        </dl>
                    </div>

                    <div class="hanoi">
                        <h4>HA NOI BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>3rd Floor, HCO building, 44B Ly Thuong Kiet street,<br />Hoan Kiem District, Ha Noi</dd>
                            <dt>Tel</dt>
                            <dd>84-24-73093968</dd>
                            <dt>Fax</dt>
                            <dd>84-24-39387198</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" type="button" onclick="goMaps(21.023161,105.85281)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
                        </dl>
                    </div>
                    
                    <div class="vungtau">
                        <h4>VUNG TAU BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>102A Le Hong Phong, Ward 4<br />Vung Tau City, Ba Ria - Vung Tau Province</dd>
                            <dt>Tel</dt>
                            <dd>84-254-7303968</dd>
                            <dt>Fax</dt>
                            <dd>84-254-7303968</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(10.359080,107.078730)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
                        </dl>
                    </div>
                    <div class="thanglong">
                        <h4>THANG LONG BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>Gelex building, 52 Le Dai Hanh, Le Dai Hanh Ward, Hai Ba Trung District, Ha Noi City</dd>
                            <dt>Tel</dt>
                            <dd>84-24-73083968</dd>
                            <dt>Fax</dt>
                            <dd>84-24-32151002</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(21.010010,105.849800)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
                        </dl>
                    </div>
                    <div class="danang">
                        <h4>DA NANG BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>Vinh Trung Plaza building, 255-257 Hung Vuong, Vinh Trung Ward, Thanh Khe District, Da Nang City</dd>
                            <dt>Tel</dt>
                            <dd>84-236-7303968</dd>
                            <dt>Fax</dt>
                            <dd>84-236-7303968</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(16.066910,108.212260)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
                        </dl>
                    </div>
                    
                    <div class="cantho">
                        <h4>CAN THO BRANCH</h4>
                        <dl>
                            <dt>Address</dt>
                            <dd>VCCI Can Tho building, 12 Hoa Binh, An Cu Ward, Ninh Kieu District, Can Tho City</dd>
                            <dt>Tel</dt>
                            <dd>84-292-7303968</dd>
                            <dt>Fax</dt>
                            <dd>84-28-39107222</dd>
                            <dt>E-mail</dt>
                            <dd><a style="text-decoration: underline; color: blue" href="mailto:cs@miraeasset.com.vn">cs@miraeasset.com.vn</a></dd>
                            <input class="btnMap" onclick="goMaps(10.034322,105.784931)"/>
                            <p style="float:right; margin-right:5px;margin-top:-5px">View Maps</p>
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