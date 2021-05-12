<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>

<!-- 
<style>
.pdfobject-container {
    width: 100%;
    max-width: 100%;
    height: 800px;
    margin: 2em 0;
}
 
.pdfobject { border: solid 1px #666; }
</style>
 -->
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Research";
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
		getResearchList();

	});

	function pdfReading(ids){
		/*$("#pdfIds").val(ids);
		$("#pdfScreen").val('research');
		
		$("#frmPDFIds").attr("target", "pdfV");
		$("#frmPDFIds").submit();*/
		window.open("/pdfViewer.do?screen=research&ids=" + ids, "_blank");
	}
	
	function unlockScroll(){
		$("html").css("overflow-y", "visible");
	}
	
	function getResearchList(page){
		var startDate 	= $("#mvStartDate").val().split("/");
		var endDate 	= $("#mvEndDate").val().split("/");
		var schKey 		= $("#searchKey").val();
		
		var param = {
				startDate			:	startDate[2] + "/" + startDate[1] + "/" +startDate[0],
				endDate				:	endDate[2] + "/" + endDate[1] + "/" +endDate[0],
				page				:	page,
				nType				:	1,
				searchKey			:	schKey,
				lang  				: 	"<%= session.getAttribute("LanguageCookie") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/researchRead.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				var researchListStr = "";
				if(data.jsonObj != null && data.jsonObj.listSize != 0){
					researchListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].created;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);
						researchListStr += "	<tr>";
						researchListStr += "		<td>" + date + "</td>";
						researchListStr += "		<td class=\"headline\"><a href=\"/pdfViewer.do?screen=research&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">" + data.jsonObj.list[i].code + "</a></td>";
						researchListStr += "		<td><a href=\"/researchDown2.do?ids=" + data.jsonObj.list[i].id + "\" class=\"btn_down\" onclick=\"researchFileDown('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">report download</a></td>";
						researchListStr += "	</tr>";
					}
				}else{
					researchListStr += "<tr><td class=\"no_result\" colspan=\"3\">No results found</td></tr>";
			 	}
				// 리스트 세팅
		 		$("#researchList").html(researchListStr);

		 		drawPage(data.jsonObj.listSize, 20, (page ? page : 1)); // paging
			},
			error     :function(e) {
				console.log(e);
			}

		});
	}
	
	function researchFileDown(id){
		location.href="/researchDown2.do?ids=" + id;
		
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
		getResearchList(pageNo);
	}

	function next() {
		var page		=	util.getNext();
		util.curPage    =	page;
		goPage(page);
	}

	function prev() {
		var page		=	util.getPrev();
		util.curPage    =	page;
		goPage(page);
	}
	
	function runSearch(e) {
        if (e.keyCode == 13) {
        	getResearchList();
            return false;
        }
        return true;
    }
</script>

</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
    	<!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Research</h2>
            <ul>
                <li><a href="/home/subpage/research.do" class="on">Daily Report</a></li>
                <li><a href="/home/subpage/sector.do">Sector / Equity</a></li>
                <li><a href="/home/subpage/macro.do">Macro / Strategy</a></li>
            </ul>
        </div>
        <!-- // lnb -->
        <div id="contents">
        	<h3 class="cont_title">Daily Report</h3>
			<div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search report</legend>
						<div class="keyword">
                            <input id="searchKey" name="searchKey" type="text" title="keywords" class="input" onkeypress="return runSearch(event);"/>
                            <input type="button" value="Search" class="btn_search" onclick="getResearchList();">
                        </div>
                        <div class="date">
                            <span class="date_box">
                                <input id="mvStartDate" name="mvStartDate" type="text" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                            <span class="tide">~</span>
                            <span class="date_box">
                                <input id="mvEndDate" name="mvEndDate" type="text" class="datepicker" />
                                <button type="button">Open Calendar</button>
                            </span>
                        </div>
                    </fieldset>
                </form>
            </div>

            <div class="board">
                <table>
                    <caption>Research Reports</caption>
                    <colgroup>
                        <col width="200" />
                        <col width="*" />
                        <col width="110" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Report name</th>
                            <th scope="col">Download</th>
                        </tr>
                    </thead>
                    <tbody id="researchList">
                    </tbody>
                </table>
            </div>

            <div class="pagination">
            </div>

        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

<div id="divLayerPop" class="layer_pop">
	<div id="divLayerPopContainer" class="layer_pop_container">
	  	<div id="pdf"></div>
	  	<button type="button" class="btn_close_pop" onclick="unlockScroll();">close layerpopup</button>
  	</div>
</div>
    
</body>
</html>