<%@ page contentType = "text/html;charset=utf-8" %>
<head>
</head>

<%
	String chkSession = (String) session.getAttribute("ClientV");
	String   langCd   = (String) (session.getAttribute("LanguageCookie") == null ? "vi_VN" : session.getAttribute("LanguageCookie"));
	
	String flag		=	(String)request.getParameter("flag");
%>

<script>
	$(document).ready(function() {
		$("body").attr("class", ("<%= langCd %>" == "en_US" ? "L_EN" : "L_VI"));
		$("#langSel").val("<%= langCd %>");
	});

	function marketGo(url) {
		$("#frmMarketGo").attr("action", url);
		$("#frmMarketGo").serialize();
		$("#frmMarketGo").submit();
	}

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
					//console.log("LAGUAGE 변경");
					//console.log(data);
					window.history.go(0);			// page Refresh
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function runScript(e) {
        if (e.keyCode == 13) {
            var vStockCode = document.getElementById("searchText").value;
            var vW;
            switch ("<%= langCd %>") {
                case "vi_VN":
                    vW = window.open('http://data.masvn.com/vi/Stock/' + vStockCode, '_blank');
                    break;
                case "en_US":
                    vW = window.open('http://data.masvn.com/en/Stock/' + vStockCode, '_blank');
                    break;
                default:
                    vW = window.open('http://data.masvn.com/vi/Stock/' + vStockCode, '_blank');
                    break;
            }
            vW.focus();
            return false;
        }
        return true;
    }
	
	function stockSearch() {
		var vStockCode = document.getElementById("searchText").value;
        var vW;
        switch ("<%= langCd %>") {
            case "vi_VN":
                vW = window.open('http://data.masvn.com/vi/Stock/' + vStockCode, '_blank');
                break;
            case "en_US":
                vW = window.open('http://data.masvn.com/en/Stock/' + vStockCode, '_blank');
                break;
            default:
                vW = window.open('http://data.masvn.com/vi/Stock/' + vStockCode, '_blank');
                break;
        }
        vW.focus();
        return false;
    }
	
	function loginPop() {
		 
		$.ajax({
			type     : "GET",
			url      : "/loginpop.do",
			data     : "",
			dataType : "html",
			success  : function(data){
				$("#divLoginViewPop").fadeIn();
				$("#divLoginViewPop").html(data);
				$("#divLoginViewPop").css({height: $(document).height()}).show();
				$("#loignPopup").show();
			},
			error     :function(e) {
				console.log(e);
			}
		});
	 	
	}
</script>

<header id="header_wrap">
	<div id="header_cont">
	    <form id="frmMarketGo" action="" method="post">
	        <input type="hidden" id="type" name="type" value=""/>
	        <input type="hidden" id="seqn" name="seqn" value=""/>
	        <input type="hidden" id="from" name="from" value=""/>
	        <input type="hidden" id="to" name="to" value=""/>
	        <input type="hidden" id="schSkey" name="schSkey" value=""/>
	        <input type="hidden" id="nxtSkey" name="nxtSkey" value=""/>
	    </form>
	    <h1 class="header_logo">
	        <a href="/"><img src="/resources/US/images/logo.png" alt="Logo" title="Logo" /></a>
	    </h1>
	    <div class="header_util">
	       <%-- 
	        <a href="/home/account/myasset.do" class="my_asset"><%= (langCd.equals("en_US") ? "My Asset" : "Thông tin tài khoản") %></a>
	        --%> 
	        <ul class="util_menu">
	        <%-- 
	            <li><a href="/wts/view/trading.do" target="_blank"><%= (langCd.equals("en_US") ? "Online Trading" : "Giao dịch trực tuyến") %></a></li>
	         --%>	
	            <li><a href="/home/globalNetwork/global.do"><%= (langCd.equals("en_US") ? "Global Network" : "Mạng lưới toàn cầu") %></a></li>
	            <li><a style="padding-right:5px;" href="https://wts.masvn.com" target="_blank"><img src="/resources/US/images/new.gif" alt="New WTS"></a></li>
	            <li style="float:left; border:0px;"><a style="padding-left:0px;" href="https://wts.masvn.com" target="_blank"><%= (langCd.equals("en_US") ? "Web Trading" : "Giao dịch trực tuyến") %></a></li>
	            <li><a href="https://mi-trade.masvn.com/login.action" class="" target="_blank"><%= (langCd.equals("en_US") ? "Web Trading" : "Giao dịch trực tuyến") %></a></li>
	            <%-- 
	            <li><a href="/home/subpage/research.do"><%= (langCd.equals("en_US") ? "Research Reports" : "Báo cáo phân tích") %></a></li>
	            --%>
	            <%--
	            <%
	        	if(!"".equals(chkSession) && chkSession != null) {
	        	%>
	         		<li><a href="/login/logout.do"><%= (langCd.equals("en_US") ? "Logout" : "Đăng xuất") %></a></li>
	        	<%
	        	} else {
	        	%>
	        	<%--  
					<li><a href="#loignPopup" class="open_layer"><%= (langCd.equals("en_US") ? "Login" : "Đăng nhập") %></a></li> 
				 --%>
				 <%-- 
				 	<li><a href="/login.do" class=""><%= (langCd.equals("en_US") ? "Login" : "Đăng nhập") %></a></li>
				 	
				 <li><a href="https://mi-trade.masvn.com/login.action" class="" target="_blank"><%= (langCd.equals("en_US") ? "Login" : "Đăng nhập") %></a></li>
	        	<%
	        	}
	        	%>
	        	--%>
	        	
	        	<!-- @TODO : NEED FOR ONLY TEST -->
	        	<!-- 베트남 테스트를 위해 입시로 코드 추가함. -->
	        	<%
	        	if("TEST".equals(flag)) {
	        	%>
	        	
	        	
	        	<%
	        	if(!"".equals(chkSession) && chkSession != null) {
	        	%>
	        		<li><a href="/login/logout.do"><%= (langCd.equals("en_US") ? "Logout" : "Đăng xuất") %></a></li>
	        	<%
	        	} else {
	        	%>
	        		<li><a href="" onclick="javascript:loginPop();return false;" class="open_layer"><%= (langCd.equals("en_US") ? "Login" : "Đăng nhập") %></a></li> 
	        	<%
	        	}
	        	%>
	        	
	        	<%
	        	}
	        	%>
	        	
	        	
	        </ul>
	        <div class="language">
	        	<a href="javascript:changeLan('en_US');"><img src="/resources/US/images/icon_us.png" alt="English"></a>
	        	<a href="javascript:changeLan('vi_VN');"><img src="/resources/US/images/icon_vn.png" alt="Vietnam"></a>
	        </div>
	        <div class="search_area">
	        	<input id="searchText" name="searchText" onkeypress="return runScript(event);" type="text" placeholder="<%= (langCd.equals("en_US") ? "Stock Search" : "Mã CK") %>">
	        	<a id="myLink" href="#" onclick="stockSearch();return false;"><img src="/resources/US/images/icon_search.png"></a>
	        </div>
			<!-- select id="langSel" class="set_lang" title="select language" onchange="changeLan(this.value);">
	            <option value="en_US">English</option>
	            <option value="vi_VN">Vietnam</option>
	        </select -->

	    </div>
    </div>
    <div class="gnb_wrap">
		<nav id="gnb" class="gnb">
	        <ul class="menu">
	            <li class="menu_about">
	                <a href="/home/aboutUs/philosophy.do" class="menu_title"><%= (langCd.equals("en_US") ? "About Us" : "Giới thiệu") %></a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/aboutUs/philosophy.do"><%= (langCd.equals("en_US") ? "Vision and Philosophy" : "Tầm nhìn và</br>Triết lý") %></a></li>
	                        <li><a href="/home/aboutUs/why.do"><%= (langCd.equals("en_US") ? "What We Do" : "Chúng tôi làm gì") %></a></li>
	                        <li><a href="/home/aboutUs/history.do"><%= (langCd.equals("en_US") ? "History" : "Lịch sử") %></a></li>
	                        <li><a href="/home/aboutUs/career.do"><%= (langCd.equals("en_US") ? "Careers" : "Nghề nghiệp") %></a></li>
	                    </ul>
	                </div>
	            </li>
	            <li class="menu_prd">
	                <a href="/home/productsAndServices/individual.do" class="menu_title"><%= (langCd.equals("en_US") ? "Products &amp; Services" : "Sản phẩm &amp; Dịch vụ") %></a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/productsAndServices/individual.do"><%= (langCd.equals("en_US") ? "Individual Brokerage" : "Môi giới Khách hàng cá nhân") %></a></li>
	                        <li><a href="/home/productsAndServices/institutional.do"><%= (langCd.equals("en_US") ? "Institutional Brokerage" : "Môi giới Khách hàng tổ chức") %></a></li>
	                        <li><a href="/home/productsAndServices/wealth.do"><%= (langCd.equals("en_US") ? "Wealth Management" : "Quản lý tài sản") %></a></li>
	                        <li><a href="/home/productsAndServices/investment.do"><%= (langCd.equals("en_US") ? "Investment Banking" : "Ngân hàng đầu tư") %></a></li>
	                    </ul>
	                </div>
	            </li>
	            <li class="menu_news">
	                <a href="/home/newsAndEvents/mirae.do" class="menu_title"><%= (langCd.equals("en_US") ? "News &amp; Events" : "Tin tức &amp; Sự kiện") %></a>
	                <div class="submenu">
	                    <a href="/home/newsAndEvents/mirae.do" class="submenu_title"><%= (langCd.equals("en_US") ? "News" : "Tin tức") %></a>
	                    <ul>
	                        <li><a href="/home/newsAndEvents/mirae.do"><%= (langCd.equals("en_US") ? "Mirae Asset News" : "Tin Mirae Asset") %></a></li>
	                        <li><a onclick="marketGo('/home/newsAndEvents/market.do')" style="cursor: pointer;"><%= (langCd.equals("en_US") ? "Market News" : "Tin thị trường") %></a></li>
	                    </ul>
	                    <a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/events" class="submenu_title"><%= (langCd.equals("en_US") ? "Events" : "Sự kiện") %></a>
	                </div>
	            </li>
	            <li class="menu_market">
	                <a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/InvestmentTool" class="menu_title"><%= (langCd.equals("en_US") ? "Investment Tools" : "Công cụ đầu tư") %></a>
	                <div class="submenu">
	                    <ul>
	                    	<li><a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/news"><%= (langCd.equals("en_US") ? "News" : "Tin tức") %></a></li>
	                    	<li><a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/transaction_statistics"><%= (langCd.equals("en_US") ? "Trading Statistics" : "Thống kê giao dịch") %></a></li>
	                    	<li><a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/stock_screener"><%= (langCd.equals("en_US") ? "Stock Screener" : "Lọc cổ phiếu") %></a></li>
	                    	<li><a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/compare_stocks"><%= (langCd.equals("en_US") ? "Compare Stocks" : "So sánh cổ phiếu") %></a></li>
	                    	<li><a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/technical_chart_analysis"><%= (langCd.equals("en_US") ? "Technical Chart Analysis" : "Biểu đồ phân tích kĩ thuật") %></a></li>
	                    	<li><a href="http://data.masvn.com/<%= (langCd.equals("en_US") ? "en" : "vi") %>/enterprise_360"><%= (langCd.equals("en_US") ? "Enterprise 360" : "Doanh nghiệp 360") %></a></li>
	                    </ul>
	                </div>
	            </li>
	            
	            <li class="menu_research">
	                <a href="/home/subpage/research.do" class="menu_title"><%= (langCd.equals("en_US") ? "Research" : "Báo cáo &amp; Phân tích") %></a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/subpage/research.do"><%= (langCd.equals("en_US") ? "Daily Report" : "Bản tin thường nhật") %></a></li>
	                        <li><a href="/home/subpage/sector.do"><%= (langCd.equals("en_US") ? "Sector / Company" : "Ngành / Doanh nghiệp") %></a></li>
	                        <li><a href="/home/subpage/macro.do"><%= (langCd.equals("en_US") ? "Macro / Strategy" : "Vĩ mô / Chiến lược") %></a></li>
	                    </ul>
	                </div>
	            </li>
	            
	            <li class="menu_investor">
	                <a href="/home/investorRelations/financial.do" class="menu_title"><%= (langCd.equals("en_US") ? "Information Disclosure" : "Công bố thông tin") %></a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/investorRelations/financial.do"><%= (langCd.equals("en_US") ? "Financial Statement /<br />Annual Report" : "Báo cáo tài chính /<br />Báo cáo thường niên") %></a></li>
	                        <li><a href="/home/investorRelations/information.do"><%= (langCd.equals("en_US") ? "Information Disclosure" : "Công bố thông tin") %></a></li>
	                        <li><a href="/home/investorRelations/company.do"><%= (langCd.equals("en_US") ? "Company's Charter" : "Điều lệ công ty") %></a></li>
	                    </ul>
	                </div>
	            </li>
	            <li class="menu_support">
	                <a href="/home/support/account.do" class="menu_title"><%= (langCd.equals("en_US") ? "Support" : "Hỗ trợ") %></a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/support/account.do"><%= (langCd.equals("en_US") ? "Open cash account in ACB" : "Mở tài khoản tiền tại ngân hàng ACB") %></a></li>
	                        <li><a href="/home/support/depositCash.do"><%= (langCd.equals("en_US") ? "Deposit cash" : "Nộp tiền") %></a></li>
	                        <li><a href="/home/support/depositStock.do"><%= (langCd.equals("en_US") ? "Deposit stock" : "Lưu ký chứng khoán") %></a></li>
	                        <li><a href="/home/support/cashAdvance.do"><%= (langCd.equals("en_US") ? "Cash advance" : "Ứng trước tiền bán chứng khoán") %></a></li>
	                        <li><a href="/home/support/cashTransfer.do"><%= (langCd.equals("en_US") ? "Cash transfer" : "Chuyển tiền") %></a></li>
	                        <li><a href="/home/support/marginGuideline.do"><%= (langCd.equals("en_US") ? "Margin trading" : "Giao dịch ký quỹ") %></a></li>
	                        <li><a href="/home/support/sms.do"><%= (langCd.equals("en_US") ? "SMS" : "SMS") %></a></li>
	                        <li><a href="/home/support/securities.do"><%= (langCd.equals("en_US") ? "Securities Trading Regulation" : "Qui định giao dịch chứng khoán") %></a></li>
	                        <li><a href="/home/support/web.do"><%= (langCd.equals("en_US") ? "Web trading guideline" : "Hướng dẫn giao dịch trực tuyến qua website") %></a></li>
	                        <li><a href="/home/support/mobile.do"><%= (langCd.equals("en_US") ? "Mobile trading guideline" : "Hướng dẫn giao dịch qua ứng dụng điện thoại") %></a></li>
	                        <li><a href="/home/support/fee.do"><%= (langCd.equals("en_US") ? "Fee table" : "Biểu phí") %></a></li>
	                    </ul>
	                </div>
	            </li>
	        </ul>
		</nav>
    </div>
    <!-- // #gnb -->
</header>

<!-- login_pop -->
<!-- 
<div id="loignPopup" class="layer_pop">
    <div class="layer_pop_container">
    	<h2>TRADING ONLINE</h2>
    	<dl class="input_area">
    		<dt><span class="icon_id"></span></dt>
    		<dd><input type="text" value="077C"></dd>
    		<dt><span class="icon_pw"></span></dt>
    		<dd><input type="password" placeholder="Password"></dd>
    		<dt><span class="icon_security"></span></dt>
    		<dd class="security"><input type="text"><div class="code"><img src="/resources/US/images/code_sample.gif"></div></dd>
    	</dl>
    	<div class="button_area">
    		<button type="button" id="loginOn" class="btn_login">Login</button>
    		<button type="button" class="btn_close_pop">Cancel</button>
    	</div>
    	<dl class="login_info">
    		<dt><span></span>HEADQUARTER</dt>
    		<dd><span>TEL  84-8-3-9102222</span><span>Fax  84-8-3-9107222</span></dd>
    		<dt><span></span>HA NOI BRANCH</dt>
    		<dd><span>TEL  84-4-62730541</span><span>Fax  84-4-62730544</span></dd>
    	</dl>
    </div>
</div>
 -->
<!-- // login_pop -->