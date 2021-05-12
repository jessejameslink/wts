<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
</head>
<body>
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | News & Events";
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
	
		d.setMonth(d.getMonth() - 2);
		$("#mvStartDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		getAllInvestorList();	
	
	});
	
	function pdfReading(ids){
		/*$("#pdfIds").val(ids);
		$("#pdfScreen").val('investor');
		
		$("#frmPDFIds").attr("target", "pdfV");
		$("#frmPDFIds").submit();*/
		window.open("/pdfViewer.do?screen=investor&ids=" + ids, "_blank");
	}
	
	var page = 1;
	function getAllInvestorList(page){
		var startDate 	= $("#mvStartDate").val().split("/");
		var endDate 	= $("#mvEndDate").val().split("/");
		
		var param = {
				startDate			:	startDate[2] + "/" + startDate[1] + "/" +startDate[0],
				endDate				:	endDate[2] + "/" + endDate[1] + "/" +endDate[0],
				page				:	page,
				nType				:	3,
				lang  				: 	"<%= session.getAttribute("LanguageCookie") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/home/investorRelations/getAllInvestor.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				var investorListStr = "";
				if(data.jsonObj.listSize != 0){
					investorListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].created;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);
						investorListStr += "	<tr>";
						investorListStr += "		<td>" + date + "</td>";
						investorListStr += "		<td class=\"headline\"><a href=\"/pdfViewer.do?screen=investor&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">" + data.jsonObj.list[i].title + "</a></td>";
						investorListStr += "		<td>" + data.jsonObj.list[i].docsize + "(KB)</td>";
						investorListStr += "		<td><a href=\"/investorDown.do?ids=" + data.jsonObj.list[i].id + "\" class=\"btn_down\" onclick=\"investorFileDown('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">report download</a></td>";
						investorListStr += "	</tr>";
					}
				}else{
					investorListStr += "<tr><td class=\"no_result\" colspan=\"3\">No results found</td></tr>";
			 	}
				// 리스트 세팅
		 		$("#investorList").html(investorListStr);

		 		drawPage(data.jsonObj.listSize, 20, (page ? page : 1)); // paging
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function investorFileDown(id){
		location.href="/investorDown.do?ids=" + id;
		
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
		page = util.curPage;
	}

	function goPage(pageNo) {
		getAllInvestorList(pageNo);
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
<%-- 
<form id="frmPDFIds" action="/pdfViewer.do" method="post">
	<input type="hidden" id="pdfIds" name="pdfIds" value="" />
	<input type="hidden" id="pdfScreen" name="pdfScreen" value="" />
</form>
--%>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>News<br />&amp; Events</h2>
            <li><a href="/home/newsAndEvents/mirae.do">News</a></li>
            <li>
            	<a href="/home/newsAndEvents/mirae.do" class="on">Information Disclosure</a>
	            <ul class="lnb_sub">
	                <li><a href="/home/investorRelations/financial.do">Financial Statement /<br />Annual Report</a></li>
	                <li><a href="/home/investorRelations/information.do">Information Disclosure</a></li>
	                <li><a href="/home/investorRelations/company.do" class="on">Company's Charter</a></li>
	            </ul>
            </li>
            <li><a href="http://data.masvn.com/en/events">Events</a></li>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Company's Charter</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search board</legend>
                        <div class="date">
                            <span class="date_box">
                                <input id="mvStartDate" name="mvStartDate" type="text" title="search start date" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                            <span class="tide">~</span>
                            <span class="date_box">
                                <input id="mvEndDate" name="mvEndDate" type="text" title="search end date" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                        </div>
                        <input type="button" value="View" class="btn_search" onclick="getAllInvestorList();"/>
                    </fieldset>
                </form>
            </div>
            <!-- // .search -->

            <div class="board">
                <table>
                    <caption>Financial Statement</caption>
                    <colgroup>
                        <col width="110" />
                        <col width="*" />
                        <col width="110" />
                        <col width="110" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Contents</th>
                            <th scope="col">Size</th>
                            <th scope="col">Download</th>
                        </tr>
                    </thead>
                    <tbody id="investorList">
                    </tbody>
                </table>
            </div>
            <!-- // .board -->

            <div class="pagination">
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>