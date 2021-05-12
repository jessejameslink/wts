<%@ page contentType = "text/html;charset=utf-8" %>
<head>
</head>

<%
	String chkSession1 = (String) session.getAttribute("ClientV");
	String   langCd1   = (String) (session.getAttribute("LanguageCookie") == null ? "vi_VN" : session.getAttribute("LanguageCookie"));
%>



<div id="divLoginViewPop" class="layer_pop">
</div>

<script>
	$(document).ready(function() {
		$("body").attr("class", ("<%= langCd1 %>" == "en_US" ? "L_EN" : "L_VI"));
		$("#langSel").val("<%= langCd1 %>");
	});
/* 
	function changeLan(str) {
		var param = {
			mvCurrentLanguage	:	""
			, request_locale	:	""
		};
		param.mvCurrentLanguage	=	str;
		param.request_locale	=	str;

		$.ajax({
			dataType  : "json",
			url       : "/home/changelanguage.do",
			data      : param,
			success   : function(data) {
				if(data != null) {
					console.log("LAGUAGE 변경");
					console.log(data);
					history.go(0);			// page Refresh
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	 */
</script>
<div id="container_footer">
<footer id="footer">
    <div class="footer_wrap">
        <div class="hq_info">
            <h2><%= (langCd1.equals("en_US") ? "HEADQUARTER" : "TRỤ SỞ CHÍNH") %></h2>
            <p><%= (langCd1.equals("en_US") ? "7th Floor,  Le Meridien building, 3C Ton Duc Thang street, Ben Nghe Ward, District 1, Ho Chi Minh" : "Tòa nhà Le Meridien, Tầng 7, 3C Tôn Đức Thắng, Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>" : "<span>ĐT: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>") %></p>
            </br>
            <h2><%= (langCd1.equals("en_US") ? "HCM BRANCH" : "CHI NHÁNH HỒ CHÍ MINH") %></h2>
            <p><%= (langCd1.equals("en_US") ? "7th Floor, Sai Gon Royal building, 91 Pasteur street, Ben Nghe Ward, District 1, Ho Chi Minh" : "Tòa nhà Sài Gòn Royal, Tầng 7, 91 Pasteur, Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>" : "<span>ĐT: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>") %></p>            
            </br>
            <h2><%= (langCd1.equals("en_US") ? "SAI GON BRANCH" : "CHI NHÁNH SÀI GÒN") %></h2>
            <p><%= (langCd1.equals("en_US") ? "16th Floor, Green Power building, 35 Ton Duc Thang street, Ben Nghe Ward, District 1, Ho Chi Minh" : "Tòa nhà Green Power, Tầng 16, 35 Tôn Đức Thắng, Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>" : "<span>ĐT: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>") %></p>            
            </br>
            <h2><%= (langCd1.equals("en_US") ? "VUNG TAU BRANCH" : "CHI NHÁNH VŨNG TÀU") %></h2>
            <p><%= (langCd1.equals("en_US") ? "5th Floor, Giao Chau building, 102A Le Hong Phong, Ward 4, Vung Tau City, Ba Ria - Vung Tau Province" : "Tòa nhà Giao Châu, Tầng 5, 102A Lê Hồng Phong, Phường 4, Tp. Vũng Tàu, Tỉnh Bà Rịa - Vũng Tàu") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-254-7303968</span> <span>Fax: 84-254-7303968</span>" : "<span>ĐT: 84-254-7303968</span> <span>Fax: 84-254-7303968</span>") %></p>                       
        </div>
        <div class="hcm_info">
            <h2><%= (langCd1.equals("en_US") ? "HA NOI BRANCH" : "CHI NHÁNH HÀ NỘI") %></h2>
            <p><%= (langCd1.equals("en_US") ? "3rd Floor, HCO building, 44B Ly Thuong Kiet street, </br>Hoan Kiem District, Ha Noi" : "Tòa nhà HCO, Tầng 3, 44B Lý Thường Kiệt, </br>Quận Hoàn Kiếm, Hà Nội") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-24-73093968</span> <span>Fax: 84-24-39387198</span>" : "<span>ĐT: 84-24-73093968</span> <span>Fax: 84-24-39387198</span>") %></p>
            </br>
            <h2><%= (langCd1.equals("en_US") ? "THANG LONG BRANCH" : "CHI NHÁNH THĂNG LONG") %></h2>
            <p><%= (langCd1.equals("en_US") ? "14th Floor, Gelex building, 52 Le Dai Hanh street, Le Dai Hanh Ward, Hai Ba Trung District, Ha Noi" : "Tòa nhà Gelex, Tầng 14, 52 Lê Đại Hành, Phường Lê Đại Hành, Quận Hai Bà Trưng, Hà Nội") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-24-73083968</span> <span>Fax: 84-24-32151002</span>" : "<span>ĐT: 84-24-73083968</span> <span>Fax: 84-24-32151002</span>") %></p>
            </br>
            <h2><%= (langCd1.equals("en_US") ? "DA NANG BRANCH" : "CHI NHÁNH ĐÀ NẴNG") %></h2>
            <p><%= (langCd1.equals("en_US") ? "Ground Floor, Vinh Trung Plaza building, 255-257 Hung Vuong, Vinh Trung Ward, Thanh Khe District, Da Nang City" : "Tòa nhà Vĩnh Trung Plaza, Tầng Trệt, 255-257 Hùng Vương, Phường Vĩnh Trung, Quận Thanh Khê, Tp. Đà Nẵng") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-236-7303968</span> <span>Fax: 84-236-7303968</span>" : "<span>ĐT: 84-236-7303968</span> <span>Fax: 84-236-7303968</span>") %></p>
            </br>
            <h2><%= (langCd1.equals("en_US") ? "CAN THO BRANCH" : "CHI NHÁNH CẦN THƠ") %></h2>
            <p><%= (langCd1.equals("en_US") ? "5th Floor, VCCI Can Tho building, 12 Hoa Binh, An Cu Ward, Ninh Kieu District, Can Tho City" : "Tầng 5, Tòa nhà VCCI Cần Thơ, 12 Hòa Bình, Phường An Cư, Quận Ninh Kiều, Tp. Cần Thơ") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-292-7303968</span> <span>Fax: 84-28-39107222</span>" : "<span>ĐT: 84-292-7303968</span> <span>Fax: 84-28-39107222</span>") %></p>
        </div>
        <div class="footer_links">
            <ul class="footer_menu">
                <li><a href="/home/subpage/contact.do"><%= (langCd1.equals("en_US") ? "CONTACT US" : "LIÊN HỆ") %></a></li>
                <li><a href="/home/subpage/sitemap.do"><%= (langCd1.equals("en_US") ? "SITEMAP" : "SƠ ĐỒ WEBSITE") %></a></li>
                <li><a href="/home/subpage/private.do"><%= (langCd1.equals("en_US") ? "PRIVACY POLICY" : "BẢO MẬT") %></a></li>
                <li><a href="/home/subpage/terms.do"><%= (langCd1.equals("en_US") ? "TERMS OF USE" : "ĐIỀU KHOẢN SỬ DỤNG") %></a></li>
             </ul>
             <ul class="footer_sns">
                <li><a href="https://www.linkedin.com/company/mirae-asset-global-investments/" target="_blank"><img src="/resources/US/images/icon_linkedin.png" alt="linked in" /></a></li>
                <li><a href="https://twitter.com/miraeasset" target="_blank"><img src="/resources/US/images/icon_twitter.png" alt="twitter" /></a></li>
                <li><a href="https://www.youtube.com/user/miraeasset" target="_blank"><img src="/resources/US/images/icon_youtube.png" alt="youtube" /></a></li>
            </ul>
            <ul class="footer_face">
                <li>
				<iframe src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fm.facebook.com%2FchungkhoanMiraeAsset&tabs&width=340&height=130&small_header=false&adapt_container_width=false&hide_cover=false&show_facepile=false&appId" width="340" height="130" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowTransparency="true" allow="encrypted-media"></iframe>
				</li>
            </ul>
        </div>
    </div>
    <div class="copyright"><%= (langCd1.equals("en_US") ? "© Mirae Asset Securities (Vietnam) LLC" : "© Công ty TNHH Chứng khoán Mirae Asset (Việt Nam)") %></div>
    
</footer>
<div class="btn_top">
        <a href=""><img src="/resources/US/images/btn_top.png" alt="go to top" /></a>
    </div>
</div>
