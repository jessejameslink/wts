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

<footer id="footer">
    <div class="footer_wrap">
        <div class="hq_info">
            <h2><%= (langCd1.equals("en_US") ? "HEADQUARTER" : "TRỤ SỞ CHÍNH") %></h2>
            <p><%= (langCd1.equals("en_US") ? "7th Floor, Sai Gon Royal building, 91 Pasteur street, Ben Nghe Ward, District 1, Ho Chi Minh" : "Tòa nhà Sài Gòn Royal, Tầng 7, 91 Pasteur, Phường Bến Nghé, Quận 1, Tp. Hồ Chí Minh") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>" : "<span>ĐT: 84-28-39102222</span> <span>Fax: 84-28-39107222</span>") %></p>
        </div>
        <div class="honoi_info">
            <h2><%= (langCd1.equals("en_US") ? "HA NOI BRANCH" : "CHI NHÁNH HÀ NỘI") %></h2>
            <p><%= (langCd1.equals("en_US") ? "8th Floor, SacomBank building, 27 Hang Bai street, Hoan Kiem District, Ha Noi" : "Tòa nhà SacomBank, Tầng 8, 27 Hàng Bài, Quận Hoàn Kiếm, Hà Nội") %></p>
            <p class="tel"><%= (langCd1.equals("en_US") ? "<span>Tel: 84-24-62730541</span> <span>Fax: 84-24-62730544</span>" : "<span>ĐT: 84-24-62730541</span> <span>Fax: 84-24-62730544</span>") %></p>
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
        </div>
    </div>
    <div class="copyright"><%= (langCd1.equals("en_US") ? "© 2017 Mirae Asset Securities (Vietnam) LLC" : "© 2017 Công ty TNHH Chứng khoán Mirae Asset (Việt Nam)") %></div>
    <div class="btn_top">
        <a href=""><img src="/resources/US/images/btn_top.png" alt="go to top" /></a>
    </div>
</footer>

