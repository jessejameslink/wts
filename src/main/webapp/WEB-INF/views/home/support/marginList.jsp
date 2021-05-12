<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Support";
		getMarginList();

	});

	function pdfReading(ids){		
		window.open("/pdfViewer.do?screen=margin&ids=" + ids, "_blank");
	}
	
	function getMarginList(page){		
		var param = {
				page				:	page
		};

		$.ajax({
			dataType  : "json",
			url       : "/marginListRead.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				var marginListStr = "";
				if(data.jsonObj != null && data.jsonObj.listSize != 0){
					marginListStr += "";
					for(var i=0; i < data.jsonObj.list.length; i++){
						var datetime = data.jsonObj.list[i].created;
						var idx = datetime.indexOf(" ");
						var date = datetime.substring(0, idx);
						marginListStr += "	<tr>";
						marginListStr += "		<td>" + date + "</td>";
						marginListStr += "		<td class=\"headline\"><a href=\"/pdfViewer.do?screen=margin&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">" + data.jsonObj.list[i].title + "</a></td>";
						marginListStr += "		<td><a href=\"/marginListDown.do?ids=" + data.jsonObj.list[i].id + "\" class=\"btn_down\" onclick=\"marginFileDown('" + data.jsonObj.list[i].id + "');return false;\" style=\"cursor:pointer;\">report download</a></td>";
						marginListStr += "	</tr>";
					}
				}else{
					marginListStr += "<tr><td class=\"no_result\" colspan=\"3\">No results found</td></tr>";
			 	}
				// 리스트 세팅
		 		$("#marginList").html(marginListStr);

		 		drawPage(data.jsonObj.listSize, 4, (page ? page : 1)); // paging
			},
			error     :function(e) {
				console.log(e);
			}

		});
	}
	
	function marginFileDown(id){
		location.href="/marginListDown.do?ids=" + id;
		
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
		getMarginList(pageNo);
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
</script>
</head>
<body>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Support</h2>
            <ul>
                <li><a href="/home/support/account.do">Open cash account in ACB</a></li>
                <li><a href="/home/support/depositCash.do">Deposit cash</a></li>
                <li><a href="/home/support/depositStock.do">Deposit stock</a></li>
                <li><a href="/home/support/cashAdvance.do">Cash advance</a></li>
                <li><a href="/home/support/cashTransfer.do">Cash transfer</a></li>
                <li>
                    <a href="/home/support/marginGuideline.do" class="on">Margin trading</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/support/marginGuideline.do">Guideline</a></li>
                        <li><a href="/home/support/marginList.do" class="on">List and Basic Information</a></li>
                    </ul>
                </li>
                <li><a href="/home/support/sms.do">SMS</a></li>
                <li><a href="/home/support/securities.do">Securities Trading Regulation</a></li>
                <li><a href="/home/support/web.do">Web trading guideline</a></li>
                <li><a href="/home/support/mobile.do">Mobile trading guideline</a></li>
                <li><a href="/home/support/fee.do">Fee table</a></li>
                <li><a href="/home/subpage/openAccount.do">Guideline on dossiers for securities account opening</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">List and Basic Information</h3>

            <div class="mg_info">
                <h4>1. Margin loan term</h4>
                <table>
                    <caption>margin loan term</caption>
                    <colgroup>
                        <col width="210" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Maximum term for a loan</th>
                            <td>03 months</td>
                        </tr>
                        <tr>
                            <th scope="row">Loan term extension</th>
                            <td>Maximum one more 03 months</td>
                        </tr>
                    </tbody>
                </table>

                <h4>2. Interest rate for Margin trading service</h4>
                <div class="box">
                    <ul class="info_list">
                        <li>
                            <span class="title">Normal interest rate</span>
                            <span class="desc">
                                <span>12% / year</span>
                            </span>
                        </li>
                        <li>
                            <span class="title">Overdue interest rate</span>
                            <span class="desc">
                                <span>150% normal interest rate</span>
                            </span>
                        </li>
                    </ul>
                </div>

                <h4>3.  Margin call notice method</h4>
                <p>Send SMS or directly call the registered telephone number in Margin trading contract.</p>

                <h4>4.  Marginable portfolio</h4>
            </div>
            <div class="board">
                <table>
                    <caption>List margin</caption>
                    <colgroup>
                        <col width="200" />
                        <col width="*" />
                        <col width="110" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">List Margin</th>
                            <th scope="col">Download</th>
                        </tr>
                    </thead>
                    <tbody id="marginList">
                    </tbody>
                </table>
            </div>

            <div class="pagination">
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>