<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	var page = 1;
	var fundType = 0;
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Products & Services";
	});
	
	function pdfReading(ids){		
		window.open("/pdfViewer.do?screen=fundinfo&ids=" + ids, "_blank");
	}
	
	function getFundData(type) {
		fundType = type;
		page = 1;
		getFundDataList(page);
	}
	
	function getFundDataList(page) {
		var param = {
				startDate			:	"1900/01/01",
				endDate				:	"2999/01/01",
				page				:	page,
				nType				:	fundType,
				lang  				: 	"<%= session.getAttribute("LanguageCookie") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/home/productsAndServices/getAllFundInfo.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				//console.log("FUND");
				//console.log(data);
				var fundInfoListStr = "";
				if(data.jsonObj.listSize != 0){
					fundInfoListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].created;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);
						
						fundInfoListStr += "<tr>";
						fundInfoListStr += "	<td>" + date + "</td>"; // Date
						fundInfoListStr += "		<td class=\"headline\"><a href=\"/pdfViewer.do?screen=fundinfo&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">" + data.jsonObj.list[i].title + "</a></td>";
						fundInfoListStr += "		<td><a href=\"/fundInfoFileDown.do?ids=" + data.jsonObj.list[i].id + "\" class=\"btn_down\" onclick=\"fundInfoFileDown('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">report download</a></td>";
						fundInfoListStr += "</tr>";
					}
				} else {
					fundInfoListStr += "<tr><td class=\"no_result\" colspan=\"3\">No data record</td></tr>";
			 	}
				// 리스트 세팅
				if(fundType == "0") {
					$("#fundDoc").html(fundInfoListStr);	
				} else if (fundType == "1") {
					$("#fundReport").html(fundInfoListStr);
				} else {
					$("#navReport").html(fundInfoListStr);
				}		 		

		 		drawPage(data.jsonObj.listSize, 20, (page ? page : 1)); // paging
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function fundInfoFileDown(id){
		location.href="/fundInfoDown.do?ids=" + id;
		
	}
	
	var util 		= 	new PageUtil();
	function drawPage(totCnt, pageSize, curPage) {
		util.totalCnt 	= 	totCnt; 		//	게시물의 총 건수
		util.pageRows 	= 	pageSize; 		// 	한번에 출력될 게시물 수
		util.disPagepCnt= 	5; 				//	화면 출력 페이지 수
		util.curPage 	= 	curPage;  		//	현재 선택 페이지
		util.setTotalPage();
		fn_DrowPageNumber();
	}

	function fn_DrowPageNumber() {
		$(".pagination").html(util.Drow());
	}

	function goPage(pageNo) {
		getFundDataList(pageNo);
	}

	function next() {
		page		=	util.getNext();
		util.curPage    =	page;
		goPage(page);
	}

	function prev() {
		page		=	util.getPrev();
		util.curPage    =	page;
		goPage(page);
	}
	
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Products<br />&amp; Services</h2>
            <ul>
                <li><a href="/home/productsAndServices/individual.do">Individual Brokerage</a></li>
                <li><a href="/home/productsAndServices/institutional.do">Institutional Brokerage</a></li>
                <li><a href="/home/productsAndServices/wealth.do">Wealth Management</a></li>
                <li><a href="/home/productsAndServices/investment.do">Investment Banking</a></li>
                <li>
                	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Funds</a>
                	<ul class="lnb_sub">
                        <li>
                        	<a href="/home/productsAndServices/ofIntroduction.do" class="on">MAGEF Fund</a>
                        	<ul class="lnb_sub1">
	                        	<li>
			                    	<a href="/home/productsAndServices/ofIntroduction.do" class="on">About MAGEF</a>			                    				                   
			                    </li>			                   
			                    <li>
			                    	<a href="/home/productsAndServices/ofInvesInstruction.do">Investment Guide</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInfoDisclosures.do">Report / News</a>			                    	
			                    </li>                        
		                    </ul>
                        </li>                        
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Mirae Asset Vietnam Growth Equity Fund</h3>
			<div>
               <h4 class="cont_subtitle" style="margin-top:10px; font-weight:600;">About MAGEF</h4> 
	           <table class="table_style_01">
	                <caption>Thông tin công ty</caption>
	                <colgroup>
	                    <col width="35%">
	                    <col />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Name</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Mirae Asset Vietnam Growth Equity Fund</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Fund Manager</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>MIRAE ASSET (VIETNAM) FUND MANAGEMENT CO., LTD</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Type /Asset Class</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Open-ended fund / Equity</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Domicile</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Vietnam</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Base Currency</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>VND</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Launch Date</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>July 2019</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Custody & Supervisory Bank</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Standard Chartered Bank (Vietnam) Limited</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Investment Objective</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Aim to achieve long-term capital appreciation through capital gains and income of investments</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Investment Strategy</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Apply active investment strategy by building portfolio focusing on listed stocks with high market capitalization and IPO stocks in Vietnam</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Trading Frequency / Dealing Date</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Weekly / Wednesday (except for public holidays)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Cut-off time</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>11:00 AM on the last working day prior to the Dealing Date (Date T-1)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Subscription Fee</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>0.75% of subscription amount (Exempted during IPO period)</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Management Fee</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>1.75% of Net Asset Value per annum</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Redemption Fee</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>1.25% of redemption amount if investment period is less than or equal to 1yr</p>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th scope="row" style="padding: 20px 10px;border-right:1px solid #ced5e4;">Redemption Settlement</th>
	                        <td style="padding: 20px 10px;border-right:1px solid #ced5e4;">
	                            <p>Within 5 working days after Dealing date</p>
	                        </td>
	                    </tr>
	                </tbody>
	            </table>
            </div>
            <div style="padding-top:15px;">
            	<h4 class="cont_subtitle" style="margin-top:10px; font-weight:600;">Fund performance</h4>
            	<h4 class="cont_subtitle" style="margin-top:5px;">Fund Return</h4>
            	<div class="price_table" style="border:0px;">
                    <table>
                        <colgroup>
                            <col width="50%" />
                            <col width="50%" />
                        </colgroup>                        
                        <tbody>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;">From 2019</br><b>---</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;">----</br><b>---</b></td>
                            </tr>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;">----</br><b>---</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;">----</br><b>---</b></td>
                            </tr>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;border-bottom:1px solid #ced5e4;">----</br><b>---</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            	<h4 class="cont_subtitle" style="margin-top:15px;">Value of NAV/CCQ (VND)</h4>
            	<div class="price_table" style="border:0px;">
                    <table>
                        <colgroup>
                            <col width="50%" />
                            <col width="50%" />
                        </colgroup>                        
                        <tbody>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;">At 20 Aug 2019</br><b>VND 10,077.86</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;">Highest 52w</br><b>VND 10,077.86</b></td>
                            </tr>
                            <tr>
                                <td class="left" style="border-right:0px;border-left:0px;border-bottom:1px solid #ced5e4;">Lowest 52w</br><b>VND 9,849.06</b></td>
                                <td class="left" style="border-right:0px;border-left:0px;"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="tab_container mg">
	            <div class="tab" style="padding-top:20px;">
	                <div>
	                    <a href="#document" class="on" onclick="getFundData(0);">MAGEF Fund Document</a>
	                    <a href="#report" onclick="getFundData(1);">MAGEF Fund Report</a>
	                    <a href="#nav" onclick="getFundData(2);">NAV Report</a>
	                </div>
	            </div>
	            <div class="tab_conts">
	            	<div id="document" class="on">
	            		<div class="board">                    
	                    <table>
		                    <caption>MAGEF Fund Document</caption>
		                    <colgroup>
		                        <col width="200" />
		                        <col width="*" />
		                        <col width="110" />
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">Date</th>
		                            <th scope="col">MAGEF Fund Document</th>
		                            <th scope="col">Download</th>
		                        </tr>
		                    </thead>
		                    <tbody id="fundDoc">
		                    </tbody>
		                </table>
		                </div>
	                </div>
	                <div id="report">
	                    <div class="board">                    
	                    <table>
		                    <caption>MAGEF Fund Report</caption>
		                    <colgroup>
		                        <col width="200" />
		                        <col width="*" />
		                        <col width="110" />
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">Date</th>
		                            <th scope="col">MAGEF Fund Report</th>
		                            <th scope="col">Download</th>
		                        </tr>
		                    </thead>
		                    <tbody id="fundReport">
		                    </tbody>
		                </table>
		                </div>
	                </div>
	                <div id="nav">
	                    <div class="board">                    
	                    <table>
		                    <caption>NAV Report</caption>
		                    <colgroup>
		                        <col width="200" />
		                        <col width="*" />
		                        <col width="110" />
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">Date</th>
		                            <th scope="col">NAV Report</th>
		                            <th scope="col">Download</th>
		                        </tr>
		                    </thead>
		                    <tbody id="navReport">
		                    </tbody>
		                </table>
		                </div>
	                </div>
	            </div>
            </div>
        </div>
        <div class="pagination">
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>