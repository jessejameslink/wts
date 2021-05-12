<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<title>Tin Thị Trường | MIRAE ASSET</title>
</head>
<body>
<script>
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
			$("#searchKey").val('');
			searchMarketVsdNewsList();
		} else {
			$("#fromDate").val("${from}");
			$("#toDate").val("${to}");
			$("#searchKey").val("${searchkey}");
			$("#newsSkey").val("${schSkey}");
			$("#newsSkeyNxt").val("${nxtSkey}");
			searchMarketVsdNewsList("${schSkey}");
		}
	});

	function searchMarketVsdNewsList(str) {
		$("#grdMarketVsdNews").find("tr").remove();
		$("#newsNext").val("");
		$("#newsSkey").val("");
		$("#newsSkeyNxt").val("");
		$("#newsIdx").val("0");
		getMarketVsdNewsList(str);
	}

	function getPreList() {
		var newsIdx  = parseInt($("#newsIdx").val()) - 1;
		var newsSkey = $("#newsSkey").val().split(",");
		var strSkey  = "";

		for(var i=0; i < newsIdx; i++) {
			if(i == 0) {
				strSkey = newsSkey[i];
			} else {
				strSkey = strSkey + "," + newsSkey[i];
			}
		}

		if($("#newsIdx").val() > 0) {
			$("#newsIdx").val(newsIdx);
		}
		$("#newsSkey").val(strSkey);
		$("#newsSkeyNxt").val("");
		if(newsSkey.length > 0) {
			getMarketVsdNewsList(newsSkey[newsIdx - 1]);
		} else {
			getMarketVsdNewsList("");
		}
	}

	function getNextList() {
		var newsIdx = parseInt($("#newsIdx").val()) + 1;
		
		$("#newsIdx").val(newsIdx);
		if($("#newsNext").val() == "Y") {
			getMarketVsdNewsList($("#newsSkeyNxt").val());
		}
	}

	function getMarketVsdNewsList(skey) {
		$("body").block({message: "<span>LOADING...</span>"});
		var param = {
			  symb  : $("#newsSymb").val()
			, skey  : skey
			, fdat  : $("#fromDate").val()
			, tdat  : $("#toDate").val()
			, word  : $("#searchKey").val()
			, mark 	: "4"
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getStockNewsList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.stockNewsList != null) {
					var htmlStr = "";
					if(data.stockNewsList.list1 != null && data.stockNewsList.list1.length > 0) {
						for(var i=0; i < data.stockNewsList.list1.length; i++) {
							var stockNewsList = data.stockNewsList.list1[i];
							htmlStr += "<tr>";
							htmlStr += "	<td>" + stockNewsList.date + "</td>"; // Date
							htmlStr += "	<td>" + stockNewsList.time + "</td>"; // Time
							htmlStr += "	<td class=\"headline\"><a href=\"/home/newsAndEvents/market_view.do?lang=vi&sid=" + stockNewsList.seqn + "\" onclick=\"miraeVsdView('"+stockNewsList.seqn+"');return false;\" style=\"cursor: pointer;\">" + stockNewsList.titl + "</a></td>"; // Title
							htmlStr += "</tr>";
						}
						$("#grdMarketVsdNews").html(htmlStr);
					} else {
						htmlStr += "<tr>";
						htmlStr += "	<td class=\"no_result\" colspan=\"3\">Không tìm thấy dữ liệu</td>";
						htmlStr += "</tr>";
						$("#grdMarketVsdNews").html(htmlStr);
					}
					if($("#newsSkey").val() == "") {
						$("#newsSkey").val($("#newsSkeyNxt").val());
					} else {
						if($("#newsSkeyNxt").val() != "") {
							$("#newsSkey").val($("#newsSkey").val() + "," + $("#newsSkeyNxt").val());
						}
					}
					$("#newsSkeyNxt").val(data.stockNewsList.skey);
				}
				$("#newsNext").val(data.stockNewsList.next);
				$("body").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("body").unblock();
			}
		});
	}

	function miraeVsdView(seqn) {
		/*$("#seqnS").val(seqn);
		$("#fromS").val($("#fromDate").val());
		$("#toS").val($("#toDate").val());
		$("#searchkeyS").val($("#searchKey").val());
		$("#schSkeyS").val($("#newsSkey").val());
		$("#nxtSkeyS").val($("#newsSkeyNxt").val());
		$("#frmMiraeView").serialize();
		$("#frmMiraeView").submit();*/
		location.href="/home/newsAndEvents/market_view.do?lang=vi&sid=" + seqn + "&from=" + $("#fromDate").val() + "&to=" + $("#toDate").val() + "&key=" + $("#searchKey").val() + "&schSkey=" + $("#newsSkey").val() + "&nxtSkey=" +  $("#newsSkeyNxt").val();
	}
</script>

<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmMiraeView" action="/home/newsAndEvents/market_view.do" method="post">
		<input type="hidden" id="typeS" name="type" value="Vsd"/>
		<input type="hidden" id="seqnS" name="seqn" value=""/>
		<input type="hidden" id="fromS" name="from" value=""/>
		<input type="hidden" id="toS" name="to" value=""/>
		<input type="hidden" id="searchkeyS" name="searchkey" value=""/>
		<input type="hidden" id="schSkeyS" name="schSkey" value=""/>
		<input type="hidden" id="nxtSkeyS" name="nxtSkey" value=""/>
	</form>
    <div class="sub_container">
		<input type="hidden" id="newsNext" name="newsNext" value=""/>
		<input type="hidden" id="newsSkey" name="newsSkey" value=""/>
		<input type="hidden" id="newsSkeyNxt" name="newsSkeyNxt" value=""/>
		<input type="hidden" id="newsIdx" name="newsIdx" value="0"/>
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Tin tức<br />&amp; Sự kiện</h2>
            <ul>
                <li>
                    <a href="/home/newsAndEvents/mirae.do" class="on">Tin tức</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/newsAndEvents/mirae.do">Tin Mirae Asset</a></li>
                        <li><a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market.do')" class="on">Tin Thị Trường</a></li>
                    </ul>
                </li>
                <li><a href="/home/newsAndEvents/events.do">Sự kiện</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Tin Thị trường</h3>

            <div class="tab">
                <div>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market.do')">Toàn thị trường</a>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_hose.do')">HOSE</a>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_hnx.do')">HNX</a>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_upcom.do')">UPCOM</a>
                    <a style="cursor: pointer;" onclick="marketGo('/home/newsAndEvents/market_vsd.do')" class="on">VSD</a>
                </div>
            </div>

            <div class="search">
                <form action="">
                    <fieldset class="search_wrap">
                        <legend>Search board</legend>
                        <div class="keyword">
                            <input id="searchKey" type="text" title="keywords" class="input" />
                            <input type="button" value="Tìm kiếm" class="btn_search" onclick="searchMarketVsdNewsList()"/>
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
            <!-- // .search -->

            <div class="board">
                <table>
                    <caption>Tin Thị Trường</caption>
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
                    <tbody id="grdMarketVsdNews">
                    </tbody>
                </table>
            </div>
            <!-- // .board -->
            <div class="page_nav">
                <a class="prev" style="cursor: pointer;" onclick="getPreList()">Prev</a>
                <a class="next" style="cursor: pointer;" onclick="getNextList()">Next</a>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>