<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String loginId	=	(String) session.getAttribute("ClientV");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<link href="/resources/css/common.css" rel="stylesheet">

<style>
.modal_layer .code {float:left; letter-spacing:1px}
.modal_layer .code > strong {color:#000}
.modal_layer .name {display:block; text-align:center; color:#000 !important; font-size:13px; font-weight:bold; letter-spacing:1px}

.exclamation_pop {margin-top:12px;}
.exclamation_pop table {}
.exclamation_pop table td {font-size:11px; }

 /* unvisited link */
.link a:link {
    color: green;
}

/* visited link */
.link a:visited {
    color: red;
}

/* mouse over link */
.link a:hover {
    color: hotpink;
}

/* selected link */
.link a:active {
    color: blue;
} 
.link a {
	position: relative;
	padding-left: 8px;
}
</style>
<script>
$(document).ready(function(){
	if ($("#dailySymb").val() != "") {
		//getInfo($("#dailySymb").val());
		getStockType($("#dailySymb").val());
	}
});

function getStockType(symbol) {
	var param = {
			  stockCd  :  symbol
			, marketId :  "ALL"
		};

		$.ajax({
			url      : "/trading/data/getMarketStockList.do",
			data     : param,
			aync     : true,
			dataType : 'json',
			success  : function(data){
				//console.log(data);
				if(data.stockList != null) {
					for (var i = 0; i < data.stockList.length; i++) {
						var stockList = data.stockList[i];
						if (stockList.synm == symbol) {
							if (stockList.snum == "W") {
								$("#stockInfo").css("display", "none");
								$("#cwInfo").css("display", "block");
								getInfoCW(symbol);
							} else {
								$("#stockInfo").css("display", "block");
								$("#cwInfo").css("display", "none");
								getInfo(symbol);
							}
						}
					}
				}				
			},
			error     :function(e) {
				console.log(e);				
			}
		});
}


function cancel() {
	//$("#stockInfo").fadeOut();
	$("#divStockInfoPop").fadeOut();
}

function getInfo(symbol) {
	var param = {
		  symb  : symbol
		 ,lang	: ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
	};

	$.ajax({
		//url      : "/info/data/getInfo.do",
		url      : "/info/data/getPiboInfo.do",
		contentType	:	"application/json; charset=utf-8",
		data     : param,
		dataType : "json",
		success  : function(data){
			//console.log("CHECK DATA");
			//console.log(data);
			setInfo(data);
		}
	});
}

function getInfoCW(symbol) {
	var param = {
		  symb  : symbol
	};

	$.ajax({
		url      : "/info/data/getPiboInfoCW.do",
		contentType	:	"application/json; charset=utf-8",
		data     : param,
		dataType : "json",
		success  : function(data){
			//console.log("CW Data Info");
			//console.log(data);
			setInfoCW(data);
		}
	});
}

function Ext_SetInfo(rcod) {
	//getInfo(rcod);
	getStockType(rcod);
}

function openMoreInformation() {
	switch ("<%= langCd %>") {
    case "vi_VN":
        vW = window.open('http://data.masvn.com/vi/Stock/' + $("#dailySymb").val(), '_blank');
        break;
    case "en_US":
        vW = window.open('http://data.masvn.com/en/Stock/' + $("#dailySymb").val(), '_blank');
        break;
    default:
        vW = window.open('http://data.masvn.com/vi/Stock/' + $("#dailySymb").val(), '_blank');
        break;
	}
}

/*
	Current State Set Data
*/
function setInfo(data) {
	//console.log("SET INFO");
	//console.log(data);
	if (data.piboinfo == null) {
		$("#tabinfo").unblock();
		return;
	}
	//var info = data.jsonObj.list[0];
	var info = data.piboinfo;
	
	//console.log("INFO>>>>>>>>>>>>>>>>>>>>>>");
	//console.log(info);
	
	var marketName;
	if (info.marketId == 1) {
		marketName = "HOSE";
	} else if (info.marketId == 2) {
		marketName = "HNX";
	} else if (info.marketId) {
		marketName = "UPCOM";
	}
	
	$("#tabinfo").find("span[name='bid_rcod']").html($("#dailySymb").val() + "&nbsp;|&nbsp;" + marketName);
	var comName;
	if ("<%= langCd %>" == "en_US") {
		comName = info.nameEN;
	} else {
		comName = info.name;
	}
	
	$("#tabinfo").find("span[name='bid_snam']").html(comName);
	$(".link").css("display", "block");
	
	$("#tabinfo").find("td[name='share_outstanding']").html(upDownNum(info.outstanding, $("#tabinfo").find("td[name='share_outstanding']")));
	$("#tabinfo").find("td[name='list_share']").html(upDownNum(info.listshare, $("#tabinfo").find("td[name='list_share']")));
	var mktcap	=	Math.floor(Math.floor(info.mkcap/10000)/1000)/100
	$("#tabinfo").find("td[name='mkt_cap']").html(numIntFormat(mktcap, $("#tabinfo").find("td[name='mkt_cap']")));
	$("#tabinfo").find("td[name='52_high']").html(upDownNum(info.high52w, $("#tabinfo").find("td[name='52_high']")));
	$("#tabinfo").find("td[name='52_low']").html(upDownNum(info.low52w, $("#tabinfo").find("td[name='52_low']")));
	$("#tabinfo").find("td[name='52_avg']").html(upDownNum(info.avg52w, $("#tabinfo").find("td[name='52_avg']")));
	
	$("#tabinfo").find("td[name='f_buy']").html(numIntFormat(info.fbuy, $("#tabinfo").find("td[name='f_buy']")));
	$("#tabinfo").find("td[name='f_owned']").html(info.fowned, $("#tabinfo").find("td[name='f_owned']"));
	$("#tabinfo").find("td[name='dividend']").html(upDownNum(info.dividend, $("#tabinfo").find("td[name='dividend']")));
	$("#tabinfo").find("td[name='dividend_yield']").html(upDownNumZeroList(info.dividendyield, $("#tabinfo").find("td[name='dividend_yield']")));
	$("#tabinfo").find("td[name='beta']").html(upDownNumZeroList(info.beta, $("#tabinfo").find("td[name='beta']")));
	
	$("#tabinfo").find("td[name='eps']").html(upDownNum(info.eps, $("#tabinfo").find("td[name='eps']")));
	$("#tabinfo").find("td[name='pe']").html(upDownNumZeroList(info.pe, $("#tabinfo").find("td[name='pe']")));
	$("#tabinfo").find("td[name='f_pe']").html(upDownNumZeroList(info.fpe, $("#tabinfo").find("td[name='f_pe']")));
	$("#tabinfo").find("td[name='bvps']").html(upDownNum(info.pvps, $("#tabinfo").find("td[name='bvps']")));
	$("#tabinfo").find("td[name='pb']").html(upDownNumZeroList(info.pb, $("#tabinfo").find("td[name='pb']")));
			
	$("#tabinfo").unblock();
}

/*
Current State Set Data
*/
function setInfoCW(data) {
//console.log("SET INFO");
//console.log(data);
if (data.pibocw01 == null) {
	$("#tabinfo").unblock();
	return;
}

var cw = data.pibocw01;

//console.log("CW INFO>>>>>>>>>>>>>>>>>>>>>>");
//console.log(cw);

$("#tabinfo").find("span[name='bid_snam']").html(cw.symb);
$(".link").css("display", "none");

$("#tabinfo").find("td[name='gsga']").html(upDownNum(cw.gsga, $("#tabinfo").find("td[name='gsga']")));
$("#tabinfo").find("td[name='gratd']").html(upDownNumZeroList(cw.gratd, $("#tabinfo").find("td[name='gratd']")));

$("#tabinfo").find("td[name='cpgb']").html(cw.cpgb);
$("#tabinfo").find("td[name='jjis']").html(numIntFormat(cw.jjis, $("#tabinfo").find("td[name='jjis']")));
$("#tabinfo").find("td[name='listed']").html(upDownNum(cw.listed, $("#tabinfo").find("td[name='listed']")));
$("#tabinfo").find("td[name='valn']").html(cw.valn);

$("#tabinfo").find("td[name='ccil']").html(cw.ccil.substring(0,4) + "/" + cw.ccil.substring(4,6) + "/" + cw.ccil.substring(6,8), $("#tabinfo").find("td[name='ccil']"));
$("#tabinfo").find("td[name='gsgs']").html(cw.gsgs.substring(0,4) + "/" + cw.gsgs.substring(4,6) + "/" + cw.gsgs.substring(6,8), $("#tabinfo").find("td[name='gsgs']"));

$("#tabinfo").find("td[name='uncod']").html(cw.uncod);
$("#tabinfo").find("td[name='uncurr']").html(numIntFormat(cw.uncurr.substring(1), $("#tabinfo").find("td[name='uncurr']")));
$("#tabinfo").find("td[name='unrate']").html(upDownNumZeroList(cw.unrate.substring(1), $("#tabinfo").find("td[name='unrate']")));
		
$("#tabinfo").unblock();
}

</script>





</head>
<body>
<div id="tabinfo" class="modal_layer add total" style="oveflow:hidden;">
	<span class="code" name="bid_rcod"></span>
	<span class="link"><a href="#" onclick="openMoreInformation();"><%= (langCd.equals("en_US") ? "(More Information)" : "(Thông tin thêm)") %></a><strong></span>	
	<span class="name" name="bid_snam"></span>	
	<div class="group_table exclamation_pop" id="stockInfo">
		
			<table class="no_bbt">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col />
				</colgroup>
				<tbody>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Share Outstanding" : "KLCP đang lưu hành") %></th>
					<td name="share_outstanding" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "List Share" : "KL niêm yết hiện tại") %></th>
					<td name="list_share" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Mkt Cap(billion)" : "Vốn hóa(billion)") %></th>
					<td name="mkt_cap" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "52Wk High" : "Cao 52T") %></th>
					<td name="52_high" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "52Wk Low" : "Thấp 52T") %></td>
					<td class="no_bbt" name="52_low">						</td>
					<th><%= (langCd.equals("en_US") ? "52Wk Avg. Vol." : "KLBQ 52T") %></th>
					<td name="52_avg" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Foreign Buy" : "NN mua") %></th>
					<td name="f_buy" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "Foreign Owned (%)" : "% NN sở hữu") %></th>
					<td name="f_owned" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Dividend" : "Cổ tức TM") %></th>
					<td name="dividend" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "Dividend Yield" : "TS cổ tức") %></th>
					<td name="dividend_yield" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Beta" : "Beta") %></th>
					<td name="beta" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "EPS" : "EPS") %></th>
					<td name="eps" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "P/E" : "P/E") %></th>
					<td name="pe" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "F B/E" : "F B/E") %></th>
					<td name="f_pe" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "BVPS" : "BVPS") %></th>
					<td class="no_bbt" name="bvps"></td>
					<th><%= (langCd.equals("en_US") ? "P/B" : "P/B") %></th>
					<td class="no_bbt right" name="pb"></td>
				</tr>
				</tbody>
			</table>
		</div>
		
		<!-- START CW -->
		<div class="group_table exclamation_pop" id="cwInfo" style="display:none;">
		
			<table class="no_bbt">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col />
				</colgroup>
				<tbody>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Exercise Price" : "Giá thực hiện") %></th>
					<td name="gsga" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "Conversion Ratio" : "Tỷ lệ chuyển đổi") %></th>
					<td name="gratd" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Call / Put" : "Loại chứng quyền") %></th>
					<td name="cpgb" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "Remaing Day" : "Ngày còn lại") %></th>
					<td name="jjis" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Listed Share" : "Số lượng chứng quyền niêm yết") %></td>
					<td class="no_bbt" name="listed">						</td>
					<th><%= (langCd.equals("en_US") ? "Issuer" : "Tổ chức phát hành") %></th>
					<td name="valn" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Final Trading Date" : "Ngày GD cuối cùng") %></th>
					<td name="ccil" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "Payment Date" : "Ngày thanh toán") %></th>
					<td name="gsgs" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Underlying Stock Code" : "Mã CK cơ sở") %></th>
					<td name="uncod" class="no_bbt"></td>
					<th><%= (langCd.equals("en_US") ? "Underlying Price" : "Giá CK cơ sở") %></th>
					<td name="uncurr" class="no_bbt right"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Underlying Rate" : "Tỷ lệ") %></th>
					<td name="unrate" class="no_bbt"></td>
				</tr>
				
				</tbody>
			</table>
		</div>
		<!-- END CW -->
		<div class="btn_wrap">
			<button type="button" onclick="cancel();">Close</button>
		</div>
		<button class="close" type="button" onclick="cancel();">close</button>
	</div>
</body>
</html>