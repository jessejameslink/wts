<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

</head>
<body>
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Tin tức & Sự kiện";
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		if("${type}" == null || "${type}" == "") {
			$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		
			d.setMonth(d.getMonth() - 2);
			$("#mvStartDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
			$("#searchKey").val('');
			//console.log("111");
			getAllMiraeNewsList();	
		} else {
			$("#mvStartDate").val("${from}");
			$("#mvEndDate").val("${to}");
			$("#searchKey").val("${searchkey}");
			//console.log("222");
			getAllMiraeNewsList("${page}");
		}
	});
	
	var page = 1;
	function getAllMiraeNewsList(page){
		var startDate 	= $("#mvStartDate").val().split("/");
		var endDate 	= $("#mvEndDate").val().split("/");
		var schKey 		= $("#searchKey").val();
		
		var param = {
				startDate			:	startDate[2] + "/" + startDate[1] + "/" +startDate[0],
				endDate				:	endDate[2] + "/" + endDate[1] + "/" +endDate[0],
				page				:	page,
				searchKey			:	schKey,
				lang  				: 	"<%= session.getAttribute("LanguageCookie") %>"
		};
		
		//console.log("====PARAM=====");
		//console.log(param);

		$.ajax({
			dataType  : "json",
			url       : "/getAllInvestmentEdu.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				//console.log("====DATA=====");
				//console.log(data);
				var miraeNewsListStr = "";
				if(data.jsonObj.listSize != 0){
					miraeNewsListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].created;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);
						var time = datetime.substring(idx + 1);
						var idx1 = time.indexOf(".");
						if (idx1 >= 0) {
							time = time.substring(0, idx1);
						}
						miraeNewsListStr += "<tr>";
						miraeNewsListStr += "	<td>" + date + "</td>"; // Date
						miraeNewsListStr += "	<td>" + time + "</td>"; // Time
						miraeNewsListStr += "	<td class=\"headline\"><a href=\"/home/newsAndEvents/investmentedu_view.do?lang=vi&sid=" + data.jsonObj.list[i].id + "\" onclick=\"miraeNewsDetailView('"+data.jsonObj.list[i].id+"');return false;\" style=\"cursor: pointer;\">" + data.jsonObj.list[i].title + "</a></td>"; // Title
						miraeNewsListStr += "</tr>";
					}
				}else{
					miraeNewsListStr += "<tr><td class=\"no_result\" colspan=\"3\">Không tìm thấy dữ liệu</td></tr>";
			 	}
				// 리스트 세팅
		 		$("#miraeNewsList").html(miraeNewsListStr);

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
		getAllMiraeNewsList(pageNo);
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
	
	function miraeNewsDetailView(sid) {
		//$("#sid").val(sid);
		//$("#fromS").val($("#mvStartDate").val());
		//$("#toS").val($("#mvEndDate").val());
		//$("#searchKeyS").val($("#searchKey").val());
		//$("#pageS").val(page);
		//$("#frmMiraeView").serialize();
		//$("#frmMiraeView").submit();
		location.href="/home/newsAndEvents/investmentedu_view.do?lang=vi&sid=" + sid + "&from=" + $("#mvStartDate").val() + "&to=" + $("#mvEndDate").val() + "&key=" + $("#searchKey").val() + "&page=" + page;
	}
	
	function runSearch(e) {
        if (e.keyCode == 13) {
        	getAllMiraeNewsList();
            return false;
        }
        return true;
    }
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmMiraeView" action="/home/newsAndEvents/investmentedu_view.do" method="post">
		<input type="hidden" id="type" name="type" value="${type}"/>
		<input type="hidden" id="sid" name="sid" value="${sid}"/>
		<input type="hidden" id="from" name="from" value="${from}"/>
		<input type="hidden" id="to" name="to" value="${to}"/>
		<input type="hidden" id="page" name="page" value="${page}"/>
		<input type="hidden" id="searchkey" name="searchkey" value="${searchkey}"/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Tin tức<br />&amp; Sự kiện</h2>
            <ul>
                <li>
                    <a href="/home/newsAndEvents/mirae.do">Tin tức</a>
                </li>
                <li><a href="/home/investorRelations/financial.do">Công bố thông tin</a></li>
                <li><a href="http://data.masvn.com/vi/events">Sự kiện</a></li>
                <li><a href="/home/newsAndEvents/investmentedu.do" class="on">Đào Tạo Nhà đầu tư</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Đào tạo Nhà đầu tư</h3>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search board</legend>
                        <div class="keyword">
                            <input id="searchKey" name="searchKey" type="text" title="keywords" class="input" onkeypress="return runSearch(event);"/>
                            <input type="button" value="Tìm kiếm" class="btn_search" onclick="getAllMiraeNewsList();"/>
                        </div>

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
                    </fieldset>
                </form>
            </div>
            <!-- // .search -->

            <div class="board">
                <table>
                    <caption>DT NDT</caption>
                    <colgroup>
                        <col width="125" />
                        <col width="105" />
                        <col width="*" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Ngày</th>
                            <th scope="col">Thời gian</th>
                            <th scope="col">Tin nổi bật</th>
                        </tr>
                    </thead>
                    <tbody id="miraeNewsList">
                    </tbody>
                </table>
            </div>
            <!-- // .board -->

            <!-- <a href="" class="btn_more">MORE (20)</a> -->

            <div class="pagination">
            </div>

        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>