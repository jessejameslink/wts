
	<div id="header_cont">
	    <form id="frmMarketGo" action="" method="post">
	        <input id="type" name="type" value="" type="hidden">
	        <input id="seqn" name="seqn" value="" type="hidden">
	        <input id="from" name="from" value="" type="hidden">
	        <input id="to" name="to" value="" type="hidden">
	        <input id="schSkey" name="schSkey" value="" type="hidden">
	        <input id="nxtSkey" name="nxtSkey" value="" type="hidden">
	    </form>
	    <h1 class="header_logo">
	        <a href="/"><img src="/resources/US/images/logo.png" alt="Logo" title="Logo"></a>
	    </h1>
	    <div class="header_util">
	        
	        <ul class="util_menu">
	            
	         	<li><a href="https://mi-trade.masvn.com/login.action" class="" target="_blank">Online Trading</a></li>
	            <li><a href="/home/globalNetwork/global.do">Global Network</a></li>
	            
	            
	        	
				 	
				 <li><a href="https://mi-trade.masvn.com/login.action" class="" target="_blank">Login</a></li>
	        	
	        </ul>
	        <div class="language">
	        	<a href="javascript:changeLan('en_US');"><img src="/resources/US/images/icon_us.png" alt="English"></a>
	        	<a href="javascript:changeLan('vi_VN');"><img src="/resources/US/images/icon_vn.png" alt="Vietnam"></a>
	        </div>
	        <div class="search_area">
	        	<input id="searchText" name="searchText" onkeypress="return runScript(event);" placeholder="Stock Search" type="text">
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
	                <a href="/home/aboutUs/philosophy.do" class="menu_title">About Us</a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/aboutUs/philosophy.do">Philosophy</a></li>
	                        <li><a href="/home/aboutUs/why.do"> What We Do</a></li>
	                        <li><a href="/home/aboutUs/history.do">History</a></li>
	                        <!-- <li><a href="/home/aboutUs/career.do">Careers</a></li> -->
	                    </ul>
	                </div>
	            </li>
	            <li class="menu_prd">
	                <a href="/home/productsAndServices/individual.do" class="menu_title">Products &amp; Services</a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/productsAndServices/individual.do">Individual Brokerage</a></li>
	                        <li><a href="/home/productsAndServices/institutional.do">Institutional Brokerage</a></li>
	                        <li><a href="/home/productsAndServices/wealth.do">Wealth Management</a></li>
	                        <li><a href="/home/productsAndServices/investment.do">Investment Banking</a></li>
	                    </ul>
	                </div>
	            </li>
	            <li class="menu_news">
	                <a href="/home/newsAndEvents/mirae.do" class="menu_title">News &amp; Events</a>
	                <div class="submenu">
	                    <a href="/home/newsAndEvents/mirae.do" class="submenu_title">News</a>
	                    <ul>
	                        <li><a href="/home/newsAndEvents/mirae.do">Mirae Asset News</a></li>
	                        <li><a onclick="marketGo('/home/newsAndEvents/market.do')" style="cursor: pointer;">Market News</a></li>
	                    </ul>
	                    <a href="http://data.masvn.com/en/events" class="submenu_title">Events</a>
	                </div>
	            </li>
	            <li class="menu_market">
	                <a href="http://data.masvn.com/en/InvestmentTool" class="menu_title">Investment Tools</a>
	                <div class="submenu">
	                    <ul>
	                    	<li><a href="http://data.masvn.com/en/news">News</a></li>
	                    	<li><a href="http://data.masvn.com/en/transaction_statistics">Trading Statistics</a></li>
	                    	<li><a href="http://data.masvn.com/en/stock_screener">Stock Screener</a></li>
	                    	<li><a href="http://data.masvn.com/en/compare_stocks">Compare Stocks</a></li>
	                    	<li><a href="http://data.masvn.com/en/technical_chart_analysis">Technical Chart Analysis</a></li>
	                    	<li><a href="http://data.masvn.com/en/enterprise_360">Enterprise 360</a></li>
	                    </ul>
	                </div>
	            </li>
	            
	            <li class="menu_research">
	                <a href="/home/subpage/research.do" class="menu_title">Research</a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/subpage/research.do">Daily Report</a></li>
	                        <li><a href="/home/subpage/sector.do">Sector / Company</a></li>
	                        <li><a href="/home/subpage/macro.do">Macro / Strategy</a></li>
	                    </ul>
	                </div>
	            </li>
	            
	            <li class="menu_investor">
	                <a href="/home/investorRelations/financial.do" class="menu_title">Information Disclosure</a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/investorRelations/financial.do">Financial Statement /<br>Annual Report</a></li>
	                        <li><a href="/home/investorRelations/information.do">Information Disclosure</a></li>
	                        <li><a href="/home/investorRelations/company.do">Company's Charter</a></li>
	                    </ul>
	                </div>
	            </li>
	            <li class="menu_support">
	                <a href="/home/support/account.do" class="menu_title">Support</a>
	                <div class="submenu">
	                    <ul>
	                        <li><a href="/home/support/account.do">Open cash account in ACB</a></li>
	                        <li><a href="/home/support/depositCash.do">Deposit cash</a></li>
	                        <li><a href="/home/support/depositStock.do">Deposit stock</a></li>
	                        <li><a href="/home/support/cashAdvance.do">Cash advance</a></li>
	                        <li><a href="/home/support/cashTransfer.do">Cash transfer</a></li>
	                        <li><a href="/home/support/marginGuideline.do">Margin trading</a></li>
	                        <li><a href="/home/support/sms.do">SMS</a></li>
	                        <li><a href="/home/support/securities.do">Securities Trading Regulation</a></li>
	                        <li><a href="/home/support/web.do">Web trading guideline</a></li>
	                        <li><a href="/home/support/mobile.do">Mobile trading guideline</a></li>
	                        <li><a href="/home/support/fee.do">Fee table</a></li>
	                    </ul>
	                </div>
	            </li>
	        </ul>
		</nav>
    </div>
    <!-- // #gnb -->
