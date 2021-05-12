<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {
		document.title = "MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "MARGIN STOCK LIST" : "DANH MỤC KÝ QUỸ") %>";		
		getAvaiablemarginList();
	});

	function getAvaiablemarginList() {
		$(".mdi_container").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				mvInstrumentID    : $("#msymbol").val(),
				mvMarketID        : "",
				mvLending         : "",
				start             : ($("#page").val() == 0 ? 0 : (($("#page").val() - 1) * 15)),
				page              : $("#page").val()
		};

		$.ajax({
			dataType  : "json",
			url       : "/margin/data/avaiablemarginlist.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				//console.log("===avaiablemarginlist===");
				//console.log(data);
				$("#trMarginStock").find("tr").remove();
				if(data.jsonObj != null) {
					if(data.jsonObj.list != null) {
						var htmlStr = "";
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var rowData = data.jsonObj.list[i];
							htmlStr += "<tr>";
							htmlStr += "	<td>" + rowData.mvRowNum + "</td>"; // No.
							htmlStr += "	<td>" + rowData.mvInstrumentID + "</td>"; // Stock Symbol
							htmlStr += "	<td class=\"text_left\">" + rowData.mvInstrumentName + "</td>"; // Company Name
							htmlStr += "	<td>" + getMarket(trim(rowData.mvMarketID)) + "</td>"; // Market
							htmlStr += "	<td>" + rowData.mvLendPercent + "%</td>"; // Margin ratio							
							htmlStr += "	<td><a onclick=\"placeOrder('" + trim(rowData.mvInstrumentID) + "','" + trim(rowData.mvMarketID) + "')\" class=\"btn buy\" style=\"cursor: pointer;\">" + "<%= (langCd.equals("en_US") ? "Buy" : "Mua") %>" + "</a></td>"; // Place Order
							htmlStr += "</tr>";
						}
					}
					drawPage(data.jsonObj.totalCount, "15", (parseInt($("#page").val()) == 0 ? 1 : parseInt($("#page").val())));
					$("#trMarginStock").html(htmlStr);
					setInitEvt();
				}
				$("#divMSymbol").hide();
				$(".mdi_container").unblock();
			},
			error     :function(e) {
				console.log(e);
				$(".mdi_container").unblock();
			}
		});
	}

	function placeOrder(stock, marketID) {
		var param = {
				symbol              : stock,
				marketID            : marketID,
				divId               : "divPlaceOrder"
		};

		$.ajax({
			type     : "POST",
			url      : "/margin/popup/placeOrder.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divPlaceOrder").fadeIn();
				$("#divPlaceOrder").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function getMarket(marketID) {
		switch (marketID) {
			case "HO":
				return "HSX";
			case "HA":
				return "HNX";
			case "UPCOM":
				return "UPCOM";
			default :
				return ""
		}
	}

	function divMSymbolShowHide() {
		if($("#divMSymbol").css("display") == "none") {
			$("#divMSymbol").show();
		} else {
			$("#divMSymbol").hide();
		}
	}

	function getMSymbol(e) {
		//console.log("GET SYMBOL CHECK~~~~~~~~~~~");		
		$("#msymbol").val(xoa_dau($("#msymbol").val().toUpperCase()));		
	}

	function setInitEvt() {
		$('.group_table').each(function() {
			var table = $(this).find('table'),
				tbody = table.find('tbody');

			if(!tbody.find('th').length) {
				tbody.find('tr:odd').addClass('even');
			}

			if(table.height() >= $(this).parent().height()) {
				table.addClass('no_bbt');
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
	}

	function goPage(pageNo) {
		$("#page").val(pageNo);
		getAvaiablemarginList();
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
<body class="mdi">
	<input type="hidden" id="page" name="page" value="0"/>
		<!-- 템플릿 사용부분 -->
		<div class="mdi_container">
			<div class="mg">
				<div class="search_area in">
					<label for="symbol"><%= (langCd.equals("en_US") ? "Symbol" : "Mã CK") %></label>
					<span>
						<input type="text" class="text" id="msymbol" name="msymbol" style="width:80px;" onkeyup="getMSymbol(event);"/>
					</span>
					<button class="btn" type="button" onclick="getAvaiablemarginList()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>

					<span class="initial_group" style="display: none;">
						<a href="" class="current">ALL</a>
						<a href="">A</a>
						<a href="">B</a>
						<a href="">C</a>
						<a href="">D</a>
						<a href="">E</a>
						<a href="">F</a>
						<a href="">G</a>
						<a href="">H</a>
						<a href="">I</a>
						<a href="">J</a>
						<a href="">K</a>
						<a href="">L</a>
						<a href="">M</a>
						<a href="">N</a>
						<a href="">O</a>
						<a href="">P</a>
						<a href="">Q</a>
						<a href="">R</a>
						<a href="">S</a>
						<a href="">T</a>
						<a href="">U</a>
						<a href="">V</a>
						<a href="">W</a>
						<a href="">X</a>
						<a href="">Y</a>
						<a href="">Z</a>
					</span>

					<a href="" class="btn_rescan" style="display: none;">Rescan</a>
				</div>

				<div class="group_table mg_table">
					<table class="table no_bbt">
						<caption class="hidden">Margin Stock table</caption>
						<colgroup>
							<col width="50" />
							<col width="90" />
							<col />
							<col />
							<col />
							<!-- 
							<col />
							 -->
							<col width="80" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><%= (langCd.equals("en_US") ? "No" : "Số TT") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Stock Symbol" : "Mã CK") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Company Name" : "Tên công ty") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Margin ratio" : "Tỷ lệ cho vay") %></th>
								<%-- 
								<th scope="col"><%= (langCd.equals("en_US") ? "Max margin volume" : "SLCK cho vay tối đa") %></th>
								 --%>
								<th scope="col"><%= (langCd.equals("en_US") ? "Place Order" : "Đặt lệnh") %></th>
							</tr>
						</thead>
						<tbody id="trMarginStock">
						</tbody>
					</table>
				</div>

				<div class="pagination">
				</div>
			</div>
		</div>
		<!-- //템플릿 사용부분 -->

	<div id="divPlaceOrder" class="modal_wrap"></div>
</body>
</html>