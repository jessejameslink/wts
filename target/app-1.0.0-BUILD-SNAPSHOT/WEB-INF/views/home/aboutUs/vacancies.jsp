<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
</head>
<body>
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | About Us";
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		
		if("${type}" == null || "${type}" == "") {
			$(".datepicker").datepicker("setDate", (d.getDate() + 1) + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		
			d.setMonth(d.getMonth() - 6);
			$("#mvStartDate").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
			getAllJobTitleList();
		} else {
			$("#mvStartDate").val("${from}");
			$("#mvEndDate").val("${to}");
			getAllJobTitleList("${page}");
		}
	});
	
	var page = 1;
	function getAllJobTitleList(page){
		var startDate 	= $("#mvStartDate").val().split("/");
		var endDate 	= $("#mvEndDate").val().split("/");
		
		var param = {
				startDate			:	startDate[2] + "/" + startDate[1] + "/" +startDate[0],
				endDate				:	endDate[2] + "/" + endDate[1] + "/" +endDate[0],
				page				:	page,
				lang  				: 	"<%= session.getAttribute("LanguageCookie") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/home/aboutUs/getAllJobTitle.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				var jobTitleListStr = "";
				if(data.jsonObj.listSize != 0){
					jobTitleListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].lastdate;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);						
						jobTitleListStr += "<tr>";
						jobTitleListStr += "	<td class=\"headline\"><a href=\"/home/aboutUs/jobtitle_view.do?lang=en&sid=" + data.jsonObj.list[i].id + "\" onclick=\"jobTitleDetailView('"+data.jsonObj.list[i].id+"');return false;\" style=\"cursor: pointer;\">" + data.jsonObj.list[i].title + "</a></td>"; // Title
						jobTitleListStr += "	<td>" + data.jsonObj.list[i].location + "</td>"; // Location
						jobTitleListStr += "	<td>" + date + "</td>"; // Time
						jobTitleListStr += "</tr>";
					}
				}else{
					jobTitleListStr += "<tr><td class=\"no_result\" colspan=\"3\">No results found</td></tr>";
			 	}
				// 리스트 세팅
		 		$("#jobTitleList").html(jobTitleListStr);

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
		getAllJobTitleList(pageNo);
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
	
	function jobTitleDetailView(sid) {
		/*$("#sid").val(sid);
		$("#fromS").val($("#mvStartDate").val());
		$("#toS").val($("#mvEndDate").val());
		$("#pageS").val(page);
		
		$("#frmJobTitleView").serialize();
		$("#frmJobTitleView").submit();*/
		location.href="/home/aboutUs/jobtitle_view.do?lang=en&sid=" + sid + "&from=" + $("#mvStartDate").val() + "&to=" + $("#mvEndDate").val() + "&page=" + page;
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmJobTitleView" action="/home/aboutUs/jobtitle_view.do" method="post">
		<input type="hidden" id="typeS" name="type" value="All"/>
		<input type="hidden" id="sid" name="sid" value=""/>
		<input type="hidden" id="fromS" name="from" value=""/>
		<input type="hidden" id="toS" name="to" value=""/>
		<input type="hidden" id="pageS" name="page" value=""/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>About Us</h2>
            <ul>
            	<li><a href="/home/aboutUs/philosophy.do">Vision and Philosophy</a></li>
            	<li><a href="/home/aboutUs/why.do">What We Do</a></li>
            	<li><a href="/home/aboutUs/history.do">History</a></li>
                <li>
                    <a href="/home/aboutUs/career.do" class="on">Careers</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/aboutUs/vacancies.do" class="on">Vacancies</a></li>
                        <li><a href="/home/aboutUs/applyonline.do">Apply Online</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Vacancies</h3>
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
                        <div class="keyword">
                            <input type="button" value="Search" class="btn_search" onclick="getAllJobTitleList();"/>
                        </div>
                    </fieldset>
                </form>
            </div>
            <!-- End search -->
            <div class="board">
                <table>
                    <caption>List jobs title</caption>
                    <colgroup>
                        <col width="*" />
                        <col width="125" />
                        <col width="130" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Job Title</th>
                            <th scope="col">Location</th>
                            <th scope="col">Last Date</th>
                        </tr>
                    </thead>
                    <tbody id="jobTitleList">
                    </tbody>
                </table>
            </div>
            <!-- End board -->

            <div class="pagination">
            </div>
            <!-- End paging -->
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>