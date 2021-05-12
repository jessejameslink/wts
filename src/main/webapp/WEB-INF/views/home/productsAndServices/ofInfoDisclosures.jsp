<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
</head>
<body>
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Products & Services";
		if("${type}" == null || "${type}" == "") {
			getAllFundInfoList();
		} else {
			getAllFundInfoList("${page}");
		}
	});
	
	var page = 1;
	function getAllFundInfoList(page){
		var param = {
				startDate			:	"1900/01/01",
				endDate				:	"2999/01/01",
				page				:	page,
				nType				:	3,
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
						var time = datetime.substring(idx + 1);
						var idx1 = time.indexOf(".");
						if (idx1 >= 0) {
							time = time.substring(0, idx1);
						}
						fundInfoListStr += "<tr>";
						fundInfoListStr += "	<td>" + date + "</td>"; // Date
						fundInfoListStr += "	<td>" + time + "</td>"; // Time
						fundInfoListStr += "	<td class=\"headline\"><a href=\"/home/productsAndServices/ofInfoDisclosures_view.do?lang=en&sid=" + data.jsonObj.list[i].id + "\" onclick=\"fundInfoDetailView('"+data.jsonObj.list[i].id+"');return false;\" style=\"cursor: pointer;\">" + data.jsonObj.list[i].title + "</a></td>"; // Title
						fundInfoListStr += "</tr>";
					}
				}else{
					fundInfoListStr += "<tr><td class=\"no_result\" colspan=\"3\">No data record.</td></tr>";
			 	}
				// 리스트 세팅
		 		$("#fundInfoListStr").html(fundInfoListStr);

		 		drawPage(data.jsonObj.listSize, 20, (page ? page : 1)); // paging
			},
			error     :function(e) {
				console.log(e);
			}
		});
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
	
	function fundInfoDetailView(sid) {
		location.href="/home/productsAndServices/ofInfoDisclosures_view.do?lang=en&sid=" + sid + "&page=" + page;
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmInformationView" action="/home/productsAndServices/ofInfoDisclosures_view.do" method="post">
		<input type="hidden" id="type" name="type" value="${type}"/>
		<input type="hidden" id="sid" name="sid" value="${sid}"/>
		<input type="hidden" id="page" name="page" value="${page}"/>
	</form>
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
			                    	<a href="/home/productsAndServices/ofIntroduction.do">About MAGEF</a>
			                    				                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInvesInstruction.do">Investment Guide</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInfoDisclosures.do" class="on">Report / News</a>			                    	
			                    </li>                        
		                    </ul>
                        </li>                        
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Report / News</h3>

            <div class="board">
                <table>
                    <caption>Information</caption>
                    <colgroup>
                        <col width="125" />
                        <col width="105" />
                        <col width="*" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Time</th>
                            <th scope="col">Contents</th>
                        </tr>
                    </thead>
                    <tbody id="fundInfoListStr">
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