<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var pageCnt;
	$(document).ready(function() {
		//console.log("@@@@@@@@@@@@@STOCK NEWS CALL");
		$('#stocknewsTbl').floatThead('destroy');
		$("#divNewsDetailPop").hide();
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		
		$("#newsSymb").val($("#dailySymb").val());
		
		//alert("VALUE==>" + $("#dailySymb").val());
		if($("#newsSymb").val() != "") {
			searchStockNewsList();
		}
		scrollDataMore("getStockNewsList()", $("#tab26 > .grid_area"));
		
		$('#stocknewsTbl').floatThead({
		    position: 'relative',
		    zIndex: function($table){
		        return 0;
		    },
		    scrollContainer: true
		    //, autoReflow:true
		});
	});

	function searchStockNewsList() {
		//console.log("SEARCH STOCK NEWS LIST");
		$("#grdStockNews").find("tr").remove();
		$("#newsNext").val("");
		$("#newsSkey").val("");
		$("#newsPage").val("1");
		$("#newsSymb").val($("#dailySymb").val());
		pageCnt = 1;
		getStockNewsList();
	}

	function getStockSearch() {
		//console.log("GET STOCK SEARCH CALL");
		$("#tab26").block({message: "<span>LOADING...</span>"});
		var param = {
				type               : "bycode",
				value              : "all"
		};

		$.ajax({
			dataType  : "json",
			url       : "/market/data/getMarketNewsList.do",
			data      : param,
			success   : function(data) {
//console.log("STOCK NEWS CHECK");
//console.log(data);
				$("#ulNewsSymb").find("li").remove();
				if(data.jsonObj != null) {
					if(data.jsonObj.stockSearchList != null) {
						var htmlStr = "";
						for(var i=0; i < data.jsonObj.stockSearchList.length; i++) {
							var rowData = data.jsonObj.stockSearchList[i];
							htmlStr += "<li onclick=\"stockNewsChange('" + rowData.stockCode + "')\" style=\"cursor: pointer;\">" + rowData.stockCode + "</li>";;
						}
						$("#ulNewsSymb").html(htmlStr);
						$("#divNewsSymb").hide();
					}
				}
				$("#tab26").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab26").unblock();
			}
		});
	}
<%-- 
	function getStockNewsList() {
		$("#tab26").block({message: "<span>LOADING...</span>"});
		var param = {
			  symb  : $("#newsSymb").val()
			, skey  : $("#newsSkey").val()
			, fdat  : $("#fromDate").val()
			, tdat  : $("#toDate").val()
			, word  : $("#newsTitl").val()
			, lang  : ("<%= langCd %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getStockNewsList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.stockNewsList != null) {
					if(data.stockNewsList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.stockNewsList.list1.length; i++) {
							var stockNewsList = data.stockNewsList.list1[i];
							htmlStr += "<tr onclick=\"newsDetail('"+stockNewsList.seqn+"');\" style=\"cursor: pointer;\">";
							htmlStr += "	<td>" + stockNewsList.date + "</td>"; // Date
							htmlStr += "	<td>" + stockNewsList.time + "</td>"; // Time
							htmlStr += "	<td class=\"subject\"><p>" + stockNewsList.titl + "</p></td>"; // Title
							htmlStr += "	<td class=\"writer\"><p>" + stockNewsList.sour + "</p></td>"; // Writer
							htmlStr += "	<td>" + stockNewsList.symb + "</td>"; // Stock Code
							htmlStr += "</tr>";
						}
						$("#grdStockNews").append(htmlStr);
					}
					$("#newsSkey").val(data.stockNewsList.skey);
				}
				$("#newsNext").val(data.stockNewsList.next);
				$("#tab26").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab26").unblock();
			}
		});
	}
 --%>
	 function getStockNewsList() {
			$("#tab26").block({message: "<span>LOADING...</span>"});
			/* 
			var startDate	=	$("#fromDate").val();
			var endDate		=	$("#toDate").val();
			var stDate		=	startDate.split("/");
			var edDate		=	endDate.split("/");
			startDate			=	stDate[1]+"-"+stDate[0]+"-"+stDate[2];
			endDate				=	edDate[1]+"-"+edDate[0]+"-"+edDate[2];
			 */
			var page	=	 $("#newsPage").val();
			if(pageCnt != 1) {
				page	=	Number(page)	+	1;
			}
			
			var param = {
				startDate  	:	''
				, endDate	:	''
				, schItem	:	$("#newsSymb").val()
				, searchKey : 	$("#newsTitl").val()
				, page		:	page
				, lang  	: 	("<%= langCd %>" == "en_US" ? "1" : "0")
			};
	//console.log("PAGE CHECK==>" + page);
	//console.log("~~~~~CHECK NEWS PARAM~~~~~~");
	//console.log(param);
			$.ajax({
				url      : "/market/data/getMarketNewsList.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("STOCK NEWS CHECK+++++++++++");
					//console.log(data);
					var stlist	=	data.jsonObj.list;
					
					if(stlist != null) {
						var htmlStr = "";
						for(var i=0; i < stlist.length; i++) {
							var stockNewsList = stlist[i];
							htmlStr += "<tr onclick=\"newsDetail('"+stockNewsList.articleId+"');\" style=\"cursor: pointer;\">";
							htmlStr += "	<td>" + stockNewsList.crtDate + "</td>"; // Date
							htmlStr += "	<td>" + stockNewsList.crtTime + "</td>"; // Time
							htmlStr += "	<td class=\"subject\"><p>" + stockNewsList.title + "</p></td>"; // Title
							/* htmlStr += "	<td class=\"writer\"><p>" + stockNewsList.source + "</p></td>"; // Writer */
							htmlStr += "	<td>" + stockNewsList.name + "</td>"; // Stock Code
							htmlStr += "</tr>";
						}
						$("#grdStockNews").append(htmlStr);
						var i = parseInt($("#newsPage").val());
						if (pageCnt == 1) {
							$("#newsPage").val(i);
							pageCnt += 1;
						} else {
							$("#newsPage").val(i+1);	
						}
						
						$("#totNewsPage").html(  Math.ceil(Number(data.jsonObj.listSize) / 20));
						
					}
					
					$('#stocknewsTbl').floatThead('reflow');
					$("#tab26").unblock();
				},
				error     :function(e) {
					console.log(e);
					$("#tab26").unblock();
				}
			});
		}
 
		function stockNewsChange(stock) {
			$("#newsSymb").val(stock);
			$("#divNewsSymb").hide();
		}

		function divNewsSymbShowHide() {
			if($("#divNewsSymb").css("display") == "none") {
				$("#divNewsSymb").show();
			} else {
				$("#divNewsSymb").hide();
			}
		}
/*
	function getNewsSymb(e) {
		$("#newsSymb").val($("#newsSymb").val().toUpperCase());
		$("#ulNewsSymb > li").show();
		if($("#newsSymb").val() == "") {
			$("#divNewsSymb").hide();
		} else {
			$("#divNewsSymb").show();
			var count = 0;
			var stock = "";
			$("#ulNewsSymb > li").each(function (i, item){
				var newsSymb = $(this).text();
				if(newsSymb.search($("#newsSymb").val()) == -1) {
					$(this).hide();
				} else {
					count++;
					stock = newsSymb;
				}
			});
			if(count == 1) {
				$("#divNewsSymb").hide();
				if(e.keyCode != 8) {
					$("#newsSymb").val(stock);
				}
				if(e.keyCode == 13) {
					if($("#newsSymb").val() != "") {
						getStockNewsList();
					}
				}
			}
		}
	}
*/


	function setNewsCode(rcod, mark) {
		$("#divNewsSymb").hide();
		$("#ulNewsSymb").html("");
		$("#newsSymb").val(rcod);
	}

	function getNewsSymb(e) {
		$("#newsSymb").val($("#newsSymb").val().toUpperCase());
		
		if($("#newsSymb").val() == "") {
			$("#divNewsSymb").hide();
			return;
		}
		
		$("#stockNewsTab").block({message: "<span>LOADING...</span>"});
		var param = {
			stockCd  : $("#newsSymb").val()
			, marketId : "ALL"
		};
		
		
		
		$.ajax({
			url      : "/trading/data/getMarketStockList.do",
			data     : param,
			dataType : 'json',
			success  : function(data){
				$("#divNewsSymb").show();
				if(data.stockList != null) {
					$("#stockNewsTab").unblock();
					var stockStr = "";
					if(data.stockList.length == 1) {
						var stockList = data.stockList[0];
						var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
						stockStr += "<li><a onclick=\"setNewsCode('" + stockList.synm + "', '" + stockList.marketId + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
						$("#divNewsSymb").hide();	
					} else if(data.stockList.length > 1) {
						for(var i=0; i < data.stockList.length; i++) {
							var stockList = data.stockList[i];
							var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
							stockStr += "<li><a onclick=\"setNewsCode('" + stockList.synm + "', '" + stockList.marketId + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
						}
					} else {
						alert($("#stock").val() + " is not exist,please enter again!");
						if ("<%= langCd %>" == "en_US") {
							alert($("#stock").val() + " is not exist,please enter again!");	
						} else {
							alert($("#stock").val() + " không tồn tại, vui lòng nhập lại!");
						}
						$("#newsSymb").val("").focus();
						$("#divNewsSymb").hide();
					}

					$("#ulNewsSymb").html(stockStr);
				}
			},
			error     :function(e) {
				console.log(e);
				$("#stockNewsTab").unblock();
			}
		});
	}



	function newsDetail(seqn) {
		var param = {
			  seqn  : seqn
			, divId : "divNewsDetailPop"
		};

		$.ajax({
			type     : "POST",
			url      : "/trading/popup/newsDetail.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divNewsDetailPop").fadeIn();
				$("#divNewsDetailPop").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
</script>
<div class="tab_content" id="stockNewsTab">
	<div role="tabpanel" class="tab_pane" id="tab26">
		<!-- Stock news -->
		<div class="search_area in">
			<div class="input_search">
				<div class="input_dropdown">
					<span>
						<input type="text" class="text" id="newsSymb" name="newsSymb"  onkeyup="getNewsSymb(event)" disabled/>
						<button type="button" onclick="divNewsSymbShowHide()" disabled></button>
						
					</span>
					<!-- layer_newest -->
					<div class="layer_newest" style="display:none;" id="divNewsSymb">
						<ul id="ulNewsSymb">
						</ul>
					</div>
				</div>
				<!-- //layer_newest -->
			</div>
			<span class="stock_search">
				<input style="width:200px;" class="text" type="text" id="newsTitl" name="newsTitl" placeholder="<%= (langCd.equals("en_US") ? "Title search" : "Tìm kiếm theo tiêu đề") %>">
			</span>
			<%-- 
			<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
			<input type="text" id="fromDate" name="fromDate" class="datepicker" />
			<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
			<input type="text" id="toDate" name="toDate" class="datepicker" />
			 --%>
			<button class="btn" type="button" onclick="searchStockNewsList()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<!-- 
			<span style="float:right;"><span>total</span>&nbsp;<span id="totNewsPage"></span><span>&nbsp;page of &nbsp;</span>
			 -->
			<input style="float:right; width: 40px; text-align: center;" type="hidden" id="newsPage" name="newsPage" value="1" disabled/></span>
		</div>
		<div class="grid_area" style="height:400px;">
			<div class="group_table center news_table">
				<table class="table" id="stocknewsTbl">
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
							<th><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
							<th><%= (langCd.equals("en_US") ? "Title" : "Nội dung") %></th>
							<%-- <th><%= (langCd.equals("en_US") ? "Source" : "Nguồn") %></th> --%>
							<th><%= (langCd.equals("en_US") ? "Category" : "Thể loại") %></th>
						</tr>
					</thead>
					<tbody id="grdStockNews">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //Stock news -->
	</div>
</div>
<!-- news Detail pop -->
<div id="divNewsDetailPop" class="modal_wrap"></div>
<!-- news Detail pop -->
</html>