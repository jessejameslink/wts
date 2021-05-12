<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Why Mirae Asset | MIRAE ASSET</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/US/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/US/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/US/js/mireaasset.js"></script>
</head>
<body>

<%@include file="header.jsp"%>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>About Us</h2>
            <ul>
                <li><a href="/home/aboutUs/philosophy.do">Vision and Philosophy</a></li>
                <li>
                    <a href="/home/aboutUs/why.do" class="on">What We Do</a>
                    <ul class="lnb_sub">
                    	<li><a href="/home/aboutUs/why.do">Wealth Management</a></li>
                    	<li><a href="/html/home/h01_what_trading.jsp">Trading</a></li>
                    	<li><a href="/html/home/h01_what_digitalfinance.jsp">Digital Finance</a></li>
                    	<li><a href="/html/home/h01_what_wholesale.jsp">Wholesale</a></li>
                    	<li><a href="/html/home/h01_what_global.jsp">Global</a></li>
                    	<li><a href="/html/home/h01_what_ivbanking.jsp" class="on">Investment Banking</a></li>
                    	<li><a href="/html/home/h01_what_iwc.jsp">IWC</a></li>
                        <!-- <li><a href="/home/aboutUs/whyInvestment.do">Investment Principles</a></li>
                        <li><a href="/home/aboutUs/whyCulture.do">Culture &amp; Values</a></li>
                        <li><a href="/home/aboutUs/whyCore.do">Core Strengths</a></li> -->
                    </ul>
                </li>
                <li><a href="/home/aboutUs/history.do">History</a></li>
                <!-- <li><a href="/home/aboutUs/career.do">Careers</a></li> -->
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Investment Banking</h3>
            <strong class="copyTxt_tit">MIRAE ASSET DAEWOO<br />ENGAGES IN A BROARD RANGE OF BUSINESSES.</strong>
            <!-- <img src="/resources/HOME/images/img_why01.jpg" alt="mirae asset buildings" class="about_img" /> -->
            
            <h4 class="cont_subtitle">Mirae Asset Daewoo offers corporate financing services for competitive businesses as well as project financing services.</h4>
            <p>We offer a wide array of corporate financing services related to IPOs, rights offerings, and the issuance of convertible bonds, bonds with warrants, exchangeable bonds, and other corporate bonds. Moreover, our highly talented and seasoned accountants, tax experts, and consultants provide advisory services for M&amp;As and financing strategies to help businesses expand enterprise value. We also offer differentiated project financing services (advisory and structured finance) to meet the highly specialized needs of real estate developers.</p>            
            
            
            <div class="price_table ivbaking">
               <table>
                   <caption>Transaction</caption>
                   <colgroup>
                       <col width="27%" />
                       <col width="*" />
                   </colgroup>
                   <thead class="multi_row">
                       <tr class="gray">
                           <th scope="col"><strong>Corporate finance</strong></th>
                           <th scope="col"><strong>Securities underwriting; Identifying investment opportunities; <br />IPO lead manager services; Pre-IPO placements</strong></th>
                       </tr>
                   </thead>
                   <tbody>
                       <tr >
                           <td class="left">Structured finance</td>
                           <td class="left none">Asset securitization services <br />(issuance/underwriting of asset-backed securities, asset-backed commercial paper, etc.)
                           </td> 
                       </tr>
                       <tr class="gray">
                           <td class="left">Corporate loans</td>
                           <td class="left none">Extending corporate loans via the development of new business models to comply with <br />
                           the revised Financial Investment Services and Capital Markets Act</td>
                           
                       </tr>
                       <tr>
                           <td class="left">Underwriting(M&amp;A)</td>
                           <td class="left none">Underwriting, brokerage, business consulting, and M&amp;A solutions; Advisory services for<br /> 
							corporate restructuring activities</td>
                       </tr>
                       <tr class="gray">
                           <td class="left">Real estate development</td>
                           <td class="left none">Project financing and advisory services (for both tangible and intangible assets); <br />
							Real estate development financing; REITs; Real estate funds; <br />
							Asset securitization using project financing vehicles and special purpose entities</td>							                     
                       </tr>
                       <tr>
                           <td class="left">SOC projects</td>
                           <td class="left none">Financial advisory services for power generation and other infrastructure projects;<br /> 
							Establishment and management of private equity funds</td>                     
                       </tr>
                   </tbody>
               </table>
           </div>
            
            
            
            <p>We utilize our expansive capital base to develop our investment banking businesses, actively seeking fresh growth drivers, strategically allocating assets, and providing a wide array of advisory and underwriting services.</p>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<!--footer-->
<%@include file="footer.jsp"%>
<!--footer-->

</body>
</html>