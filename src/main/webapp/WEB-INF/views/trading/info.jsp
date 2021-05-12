<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String loginId	=	(String) session.getAttribute("ClientV");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>MIRAE ASSET WTS</title>

	<!--
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>
	 -->
	<!-- RTS Relate Script -->
<!-- 
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
	<script type="text/javascript" src="/resources/js/nexClient.js"></script>
	
	<script language="javascript" src="/html/RTS/nexClient_test.js"></script>
	
	<script type="text/javascript" src="/resources/js/socket.io.js"></script>

	<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>

	<link href="/resources/css/common.css" rel="stylesheet">
	
	 -->
	
	<script type="text/javascript">
	
		$(document).ready(function(){
			if ($("#dailySymb").val() != "") {
				getInfo($("#dailySymb").val());	
			}
		});
		
		function getInfo(symbol) {
			$("#tabinfo").block({message: "<span>LOADING...</span>"});
			var param = {
				  symb  : symbol
			};

			$.ajax({
				url      : "/info/data/getInfo.do",
				contentType	:	"application/json; charset=utf-8",
				data     : param,
				dataType : "json",
				success  : function(data){
					setInfo(data);
				}
			});
		}

		function Ext_SetInfo(rcod) {
			getInfo(rcod);
		}

		/*
			Current State Set Data
		*/
		function setInfo(data) {
			//console.log("SET INFO");
			//console.log(data);
			if (data.jsonObj == null) {
				$("#tabinfo").unblock();
				return;
			}
			var info = data.jsonObj.list[0];
			var marketName;
			if (info.marketId == 1) {
				marketName = "HOSE";
			} else if (info.marketId == 2) {
				marketName = "HNX";
			} else if (info.marketId) {
				marketName = "UPCOM";
			}
			$("#tabinfo").find("span[name='bid_rcod']").html(info.symb + "&nbsp;|&nbsp;" + marketName);
			var comName;
			if ("<%= langCd %>" == "en_US") {
				comName = info.nameEN;
			} else {
				comName = info.name;
			}
			$("#tabinfo").find("span[name='bid_snam']").html(comName);
			
			$("#tabinfo").find("td[name='share_outstanding']").html(upDownNum(info.shareoutstanding, $("#tabinfo").find("td[name='share_outstanding']")));
			$("#tabinfo").find("td[name='list_share']").html(upDownNum(info.lstshare, $("#tabinfo").find("td[name='list_share']")));
			
			$("#tabinfo").find("td[name='mkt_cap']").html(upDownNum(info.mktcap, $("#tabinfo").find("td[name='mkt_cap']")));
			$("#tabinfo").find("td[name='52_high']").html(upDownNum(info.high52w, $("#tabinfo").find("td[name='52_high']")));
			$("#tabinfo").find("td[name='52_low']").html(upDownNum(info.low52w, $("#tabinfo").find("td[name='52_low']")));
			$("#tabinfo").find("td[name='52_avg']").html(upDownNum(info.avg52w, $("#tabinfo").find("td[name='52_avg']")));
			
			$("#tabinfo").find("td[name='f_buy']").html(numIntFormat(info.fbuy, $("#tabinfo").find("td[name='f_buy']")));
			$("#tabinfo").find("td[name='f_owned']").html(numIntFormat(info.fowned, $("#tabinfo").find("td[name='f_owned']")));
			$("#tabinfo").find("td[name='dividend']").html(upDownNum(info.dividend, $("#tabinfo").find("td[name='dividend']")));
			$("#tabinfo").find("td[name='dividend_yield']").html(upDownNumZeroList(info.dividendyield, $("#tabinfo").find("td[name='dividend_yield']")));
			$("#tabinfo").find("td[name='beta']").html(upDownNumZeroList(info.beta, $("#tabinfo").find("td[name='beta']")));
			
			$("#tabinfo").find("td[name='eps']").html(upDownNum(info.eps, $("#tabinfo").find("td[name='eps']")));
			$("#tabinfo").find("td[name='pe']").html(upDownNumZeroList(info.pe, $("#tabinfo").find("td[name='pe']")));
			$("#tabinfo").find("td[name='f_pe']").html(upDownNumZeroList(info.fpe, $("#tabinfo").find("td[name='f_pe']")));
			$("#tabinfo").find("td[name='bvps']").html(upDownNum(info.bvps, $("#tabinfo").find("td[name='bvps']")));
			$("#tabinfo").find("td[name='pb']").html(upDownNumZeroList(info.pb, $("#tabinfo").find("td[name='pb']")));
					
			$("#tabinfo").unblock();
		}

		
	</script>
</head>


<div class="tab_content margin_top_0">
	<div role="tabpanel" class="tab_pane" id="tabinfo">
		<!-- BID -->
		<div class="group_table bid_table radius_top">
			<table class="table no_bbt">
				<caption>
					<span class="code" name="bid_rcod"></span>
					<span style="color:#000!important;" class="name" name="bid_snam"></span>
				</caption>
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tbody>
					<tr>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "Share Outstanding" : "KLCP đang lưu hành") %></td>
						<td name="share_outstanding" class="no_bbt"></td>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "List Share" : "KL niêm yết hiện tại") %></td>
						<td name="list_share" class="no_bbt right"></td>
					</tr>
					<tr>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "Mkt Cap" : "Vốn hóa") %></td>
						<td name="mkt_cap" class="no_bbt"></td>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "52Wk High" : "Cao 52T") %></td>
						<td name="52_high" class="no_bbt right"></td>
					</tr>
					<tr>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "52Wk Low" : "Thấp 52T") %></td>
						<td class="no_bbt" name="52_low">						</td>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "52Wk Avg. Vol." : "KLBQ 52T") %></td>
						<td name="52_avg" class="no_bbt right"></td>
					</tr>
					<tr>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "Foreign Buy" : "NN mua") %></td>
						<td name="f_buy" class="no_bbt"></td>
						<td class="no_bbt left bg01"><%= (langCd.equals("en_US") ? "Foreign Owned (%)" : "% NN sở hữu") %></td>
						<td name="f_owned" class="no_bbt right"></td>
					</tr>

					<tr>
						<td class="no_bbt left bg01"><%= (langCd.equals("en_US") ? "Dividend" : "Cổ tức TM") %></td>
						<td name="dividend" class="no_bbt"></td>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "Dividend Yield" : "TS cổ tức") %></td>
						<td name="dividend_yield" class="no_bbt right"></td>
					</tr>
					<tr>
						<td class="no_bbt left bg01"><%= (langCd.equals("en_US") ? "Beta" : "Beta") %></td>
						<td name="beta" class="no_bbt"></td>
						<td class="no_bbt bg01 left"><%= (langCd.equals("en_US") ? "EPS" : "EPS") %></td>
						<td name="eps" class="no_bbt right"></td>
					</tr>
					<tr>
						<td class="no_bbt left bg01"><%= (langCd.equals("en_US") ? "P/E" : "P/E") %></td>
						<td name="pe" class="no_bbt"></td>
						<td class="no_bbt left bg01"><%= (langCd.equals("en_US") ? "F B/E" : "F B/E") %></td>
						<td name="f_pe" class="no_bbt right"></td>
					</tr>
					 
					<tr>
						<td class="no_bbt left bg01"><%= (langCd.equals("en_US") ? "BVPS" : "BVPS") %></td>
						<td class="no_bbt" name="bvps"></td>
						<td class="no_bbt left bg01"><%= (langCd.equals("en_US") ? "P/B" : "P/B") %></td>
						<td class="no_bbt right" name="pb"></td>
					</tr>
					<tr>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
					</tr>
				</tbody>
			</table>
		</div>
		<!-- //BID -->
	</div>	
</div>
</html>