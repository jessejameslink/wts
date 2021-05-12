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
		if("${type}" == null || "${type}" == "") {
			getAllInvestorList();
		} else {
			getAllInvestorList("${page}");
		}
	});
	
	var page = 1;
	function getAllInvestorList(page){
		var param = {
				startDate			:	"1900/01/01",
				endDate				:	"2999/01/01",
				page				:	page,
				nType				:	2,
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
						var time = datetime.substring(idx + 1);
						var idx1 = time.indexOf(".");
						if (idx1 >= 0) {
							time = time.substring(0, idx1);
						}
						investorListStr += "<tr>";
						investorListStr += "	<td>" + date + "</td>"; // Date
						investorListStr += "	<td>" + time + "</td>"; // Time
						investorListStr += "	<td class=\"headline\"><a href=\"/home/investorRelations/information_view.do?lang=en&sid=" + data.jsonObj.list[i].id + "\" onclick=\"investorDetailView('"+data.jsonObj.list[i].id+"');return false;\" style=\"cursor: pointer;\">" + data.jsonObj.list[i].title + "</a></td>"; // Title
						investorListStr += "</tr>";
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
	
	function investorDetailView(sid) {
		//$("#sid").val(sid);
		//$("#pageS").val(page);
		//$("#frmInformationView").serialize();
		//$("#frmInformationView").submit();
		location.href="/home/investorRelations/information_view.do?lang=en&sid=" + sid + "&page=" + page;
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmInformationView" action="/home/investorRelations/information_view.do" method="post">
		<input type="hidden" id="type" name="type" value="${type}"/>
		<input type="hidden" id="sid" name="sid" value="${sid}"/>
		<input type="hidden" id="page" name="page" value="${page}"/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>News<br />&amp; Events</h2>
            <li><a href="/home/newsAndEvents/mirae.do">News</a></li>
            <li>
            	<a href="/home/newsAndEvents/mirae.do" class="on">Information Disclosure</a>
	            <ul class="lnb_sub">
	                <li><a href="/home/investorRelations/financial.do">Financial Statement /<br />Annual Report</a></li>
	                <li><a href="/home/investorRelations/information.do" class="on">Information Disclosure</a></li>
	                <li><a href="/home/investorRelations/company.do">Company's Charter</a></li>
	            </ul>
            </li>
            <li><a href="http://data.masvn.com/en/events">Events</a></li>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Information Disclosure</h3>

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