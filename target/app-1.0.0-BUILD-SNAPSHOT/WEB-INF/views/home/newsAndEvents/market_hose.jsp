<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Market News | MIRAE ASSET</title>
</head>
<body>
<script>
	var page	=	1;
	$(document).ready(function() {
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		
		if("${type}" == null || "${type}" == "") {
			$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
			$("#fromDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth()) + "/" + d.getFullYear());
			$("#searchKey").val('');
			searchMarketHoseNewsList();
		} else {
			$("#fromDate").val("${from}");
			$("#toDate").val("${to}");
			$("#searchKey").val("${searchkey}");
			/*var trPage	=	"${trPage}";
			if(trPage == "" || trPage == "null") {
				trPage = 1;
			}
			$("#trPage").val(trPage);*/
			searchMarketHoseNewsList("${trPage}");
		}
	});

	function searchMarketHoseNewsList(page) {
		$("#grdMarketHoseNews").find("tr").remove();
		getMarketHoseNewsList(page);
	}

	function getMarketHoseNewsList(page) {
		$("body").block({message: "<span>LOADING...</span>"});
		
		var startDate	=	$("#fromDate").val();
		var endDate		=	$("#toDate").val();
		var stDate		=	startDate.split("/");
		var edDate		=	endDate.split("/");
		startDate			=	stDate[1]+"-"+stDate[0]+"-"+stDate[2];
		endDate				=	edDate[1]+"-"+edDate[0]+"-"+edDate[2];
		
		var param = {
			startDate 	: startDate
			, endDate  	: endDate
			, searchKey : $("#searchKey").val()
			, marketId	: "hose"											//	hose   
			, lang  	: ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
			, page		: page
		};

		$.ajax({
			url      : "/market/data/getMarketNewsList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				var list	=	data.jsonObj.list;
				if(list != null) {
					var htmlStr = "";
					if(list != null && list.length > 0) {
						for(var i=0; i < list.length; i++) {
							var stockNewsList = list[i];
							htmlStr += "<tr>";
							htmlStr += "	<td>" + stockNewsList.crtDate + "</td>"; // Date
							htmlStr += "	<td>" + stockNewsList.crtTime + "</td>"; // Time
							htmlStr += "	<td class=\"headline\"><a href=\"/home/newsAndEvents/market_view.do?lang=en&sid=" + stockNewsList.articleId + "\" onclick=\"miraeHoseView('"+stockNewsList.articleId+"');return false;\" style=\"cursor: pointer;\">" + stockNewsList.title + "</a></td>"; // Title
							htmlStr += "</tr>";
						}
						$("#grdMarketHoseNews").html(htmlStr);
						
						drawPage(data.jsonObj.listSize, 20, (page ? page : 1)); // paging
					} else { 
						htmlStr += "<tr>";
						htmlStr += "	<td class=\"no_result\" colspan=\"3\">No results found</td>";
						htmlStr += "</tr>";
						$("#grdMarketHoseNews").html(htmlStr);
					}
				}
				
				$("body").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("body").unblock();
			}
		});
	}

	function miraeHoseView(seqn) {
		/*$("#seqnS").val(seqn);
		$("#fromS").val($("#fromDate").val());
		$("#toS").val($("#toDate").val());
		$("#searchkeyS").val($("#searchKey").val());
		$("#frmMiraeView").serialize();
		$("#frmMiraeView").submit();*/
		location.href="/home/newsAndEvents/market_view.do?lang=en&sid=" + seqn + "&from=" + $("#fromDate").val() + "&to=" + $("#toDate").val() + "&key=" + $("#searchKey").val() + "&page=" + page;
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
		$("#trPage").val(pageNo);
		getMarketHoseNewsList(pageNo);
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
	
	function runSearch(e) {
        if (e.keyCode == 13) {
        	searchMarketHoseNewsList();
            return false;
        }
        return true;
    }
</script>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmMiraeView" action="/home/newsAndEvents/market_view.do" method="post">
		<input type="hidden" id="type" name="type" value="Hos"/>
		<input type="hidden" id="sid" name="seqn" value=""/>
		<input type="hidden" id="from" name="from" value=""/>
		<input type="hidden" id="to" name="to" value=""/>
		<input type="hidden" id="searchkey" name="searchkey" value=""/>
		<input type="hidden" id="trPage" name="trPage" value=""/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>News<br />&amp; Events</h2>
            <ul>
                <li>
                    <a href="/home/newsAndEvents/mirae.do" class="on">News</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/newsAndEvents/mirae.do">Mirae Asset News</a></li>
                        <li><a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market.do')" class="on">Market News</a></li>
                    </ul>
                </li>
                <li><a href="/home/investorRelations/financial.do">Information Disclosure</a></li>
                <li><a href="http://data.masvn.com/en/events">Events</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Market News</h3>

            <div class="tab">
                <div>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market.do')">All Market</a>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_hose.do')" class="on">HOSE</a>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_hnx.do')">HNX</a>
                    <!--
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_upcom.do')">UPCOM</a>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_vsd.do')">VSD</a>
                    -->
                </div>
            </div>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search board</legend>
                        <div class="keyword">
                            <input id="searchKey" type="text" title="keywords" class="input" onkeypress="return runSearch(event);"/>
                            <input type="button" value="Search" class="btn_search" onclick="searchMarketHoseNewsList()"/>
                        </div>

                        <div class="date">
                            <span class="date_box">
                                <input type="text" id="fromDate" name="fromDate" title="search start date" class="datepicker"/>
                                <button type="button">Open Calendar</button>
                            </span>
                            <span class="tide">~</span>
                            <span class="date_box">
                                <input type="text" id="toDate" name="toDate" title="search end date" class="datepicker"/>
                                <button type="button">Open Calendar</button>
                            </span>
                        </div>
                    </fieldset>
                </form>
            </div>
            <!-- // .search  -->

            <div class="board">
                <table>
                    <caption>Market News</caption>
                    <colgroup>
                        <col width="125" />
                        <col width="105" />
                        <col width="*" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Time</th>
                            <th scope="col">Headline</th>
                        </tr>
                    </thead>
                    <tbody id="grdMarketHoseNews">
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