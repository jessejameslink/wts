<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<script>
	var dailyfirst	=	true;
	var flagIndex = 1; //1: VN Index 2: Foreigner Index
	var record;
	$(document).ready(function() {
		$('#forTbl').floatThead('destroy');
		$('#dailyTbl').floatThead('destroy');
		vnIndex();
		forIndex();
		
		scrollDataMore("getDailyList()", $("#marketIndex > .group_table"));
		
		$('#forTbl').floatThead({
		    position: 'relative',
		    zIndex: function($table){
		        return 0;
		    },
		    scrollContainer: true
		});
		
		$('#dailyTbl').floatThead({
		    position: 'relative',
		    zIndex: function($table){
		        return 0;
		    },
		    scrollContainer: true
		});
	});
	
	function getDailyList(){
		if (flagIndex == 1) {
			getVnDailyIndex();
		} else if (flagIndex == 2) {
			getForDailyIndex();
		}
	}
	
	function vnIndex() {
		$("#grdVnIndex").find("tr").remove();		
		$("#vnIndexSkey").val("");
		getVnIndex();
	}
	function getVnIndex() {
		$("#marketIndex").block({message: "<span>LOADING...</span>"});
		var param = {
			  skey  : $("#vnIndexSkey").val()
		};

		$.ajax({
			url      : "/trading/data/getVnIndex.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.vnIndexList != null) {
					if(data.vnIndexList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.vnIndexList.list1.length; i++) {
							var vnIndexList = data.vnIndexList.list1[i];
							var cssColor  = displayIndexColor(vnIndexList.diff.substring(0, 1));
							var cssArrow  = displayIndexArrow(vnIndexList.diff.substring(0, 1));
							htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selVnItem('" + vnIndexList.rcod + "');\">";
							htmlStr += "	<td class=\"text_left c_code\">" + vnIndexList.inam + "</td>";                       // Name
							htmlStr += "	<td class=\"text_left c_code dotted " + cssColor + "\">" + upDownNumList(vnIndexList.indx) + "</td>"; // Index
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(vnIndexList.diff) + "</td>"; // +/-
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(vnIndexList.rate) + "</td>"; // %Change
							htmlStr += "</tr>";
							
						}										
						$("#grdVnIndex").append(htmlStr);
					}									
				}
				
				if(dailyfirst && $("#vnIndexSkey").val() == "") {
					if(data.vnIndexList.list1.length != 0 ) {
						selVnItem(data.vnIndexList.list1[0].rcod);
						dailyfirst = false;
					}
				}
				$("#marketIndex").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#marketIndex").unblock();
			}
		});
	}
	
	function selVnItem(rcod) {
		flagIndex = 1;
		record = rcod;
		var captionSymbol = "";
		var thDailyIndex = "";
		if ("<%= langCd %>" == "en_US") {
			captionSymbol = "VN INDEX - " + rcod;
			thDailyIndex = "Volume";
		} else {
			captionSymbol = "CHỈ SỐ INDEX VIỆT NAM - " + rcod;
			thDailyIndex = "Khối lượng";
		}
		$("#captionSymbol").html(captionSymbol);
		$("#thDailyIndex").html(thDailyIndex);
		
		$("#grdDaily").find("tr").remove();
		$("#dailyNext").val("");
		$("#dailySkey").val("");
		getVnDailyIndex(rcod);
		
	}
	
	function getVnDailyIndex() {
		if ($("#dailySkey").val() == "end") {
			return;
		}
		$("#marketIndex").block({message: "<span>LOADING...</span>"});
		var param = {
			  symb  : record
			, func  : 'D'
			, skey  : $("#dailySkey").val()
		};
		
		//console.log("==========");
		//console.log(param);

		$.ajax({
			url      : "/trading/data/getVnDaily.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log(data);
				if(data.vnDailyList != null) {
					if(data.vnDailyList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.vnDailyList.list1.length; i++) {
							var vnDailyList = data.vnDailyList.list1[i];
							var cssColor  = displayIndexColor(vnDailyList.diff.substring(0, 1));
							var cssArrow  = displayIndexArrow(vnDailyList.diff.substring(0, 1));
							htmlStr += "<tr>";
							htmlStr += "	<td class=\"text_center c_code\">" + vnDailyList.date + "</td>";                       // Date
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(vnDailyList.clos)+ "</td>"; // Close
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(vnDailyList.diff) + "</td>"; // Change(+/-)
							htmlStr += "	<td>" + numIntFormat(vnDailyList.tvol) + "</td>"; // Total Volume
							htmlStr += "</tr>";
							
						}
						$("#grdDaily").append(htmlStr);
					}
					
					if (data.vnDailyList.skey == "") {
						data.vnDailyList.skey = "end";
					}
					$("#dailySkey").val(data.vnDailyList.skey);
				}
				
				$('#dailyTbl').floatThead('reflow');
				
				$("#dailyNext").val(data.vnDailyList.next)
				$("#marketIndex").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#marketIndex").unblock();
			}
		});
	}
	
	function forIndex() {
		$("#grdForIndex").find("tr").remove();		
		$("#forIndexSkey").val("");
		getForIndex();
	}
	function getForIndex() {
		$("#marketIndex").block({message: "<span>LOADING...</span>"});
		var param = {
			  skey  : $("#forIndexSkey").val()
		};

		$.ajax({
			url      : "/trading/data/getForIndex.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.forIndexList != null) {
					if(data.forIndexList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.forIndexList.list1.length; i++) {
							var forIndexList = data.forIndexList.list1[i];
							var cssColor  = displayIndexColor(forIndexList.diff.substring(0, 1));
							var cssArrow  = displayIndexArrow(forIndexList.diff.substring(0, 1));
							htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selForItem('" + forIndexList.rcod + "');\">";
							htmlStr += "	<td class=\"text_left c_code\">" + forIndexList.inam + "</td>";                       // Name
							htmlStr += "	<td class=\"text_left c_code dotted " + cssColor + "\">" + upDownNumList(forIndexList.indx) + "</td>"; // Index
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(forIndexList.diff) + "</td>"; // +/-
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(forIndexList.rate) + "</td>"; // %Change
							htmlStr += "</tr>";
							
						}
						$("#grdForIndex").append(htmlStr);
					}									
				}
				$('#forTbl').floatThead('reflow');
				$("#marketIndex").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#marketIndex").unblock();
			}
		});
	}
	
	function selForItem(rcod) {
		flagIndex = 2;
		record = rcod;
		var captionSymbol = "";
		var thDailyIndex = "";
		if ("<%= langCd %>" == "en_US") {
			captionSymbol = "FOREIGNER INDEX - " + rcod;
			thDailyIndex = "Change(%)";
		} else {
			captionSymbol = "CHỈ SỐ INDEX NƯỚC NGOÀI - " + rcod;
			thDailyIndex = "Thay đổi(%)";
		}
		$("#captionSymbol").html(captionSymbol);
		$("#thDailyIndex").html(thDailyIndex);
		
		$("#grdDaily").find("tr").remove();
		$("#dailyNext").val("");
		$("#dailySkey").val("");
		getForDailyIndex(rcod);
	}
	
	function getForDailyIndex() {
		if ($("#dailySkey").val() == "end") {
			return;
		}
		$("#marketIndex").block({message: "<span>LOADING...</span>"});
		var param = {
			  symb  : record
			, func  : 'D'
			, skey  : $("#dailySkey").val()
		};
		
		//console.log("==========");
		//console.log(param);

		$.ajax({
			url      : "/trading/data/getForDaily.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log(data);
				if(data.forDailyList != null) {
					if(data.forDailyList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.forDailyList.list1.length; i++) {
							var forDailyList = data.forDailyList.list1[i];
							var cssColor  = displayIndexColor(forDailyList.diff.substring(0, 1));
							var cssArrow  = displayIndexArrow(forDailyList.diff.substring(0, 1));
							htmlStr += "<tr>";
							htmlStr += "	<td class=\"text_left c_code\">" + forDailyList.date + "</td>";                       // Date
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(forDailyList.clos)+ "</td>"; // Close
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(forDailyList.diff) + "</td>"; // Change(+/-)
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(forDailyList.rate) + "</td>"; // %Change
							htmlStr += "</tr>";
							
						}
						$("#grdDaily").append(htmlStr);
					}
					
					if (data.forDailyList.skey == "") {
						data.forDailyList.skey = "end";
					}
					$("#dailySkey").val(data.forDailyList.skey);
				}
				
				$('#dailyTbl').floatThead('reflow');
				
				$("#dailyNext").val(data.forDailyList.next)
				$("#marketIndex").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#marketIndex").unblock();
			}
		});
	}
	
	function displayIndexColor(a) {
		switch (a) {
			case "+":
				return "up";			
			case "-":
				return "low"
			default :
				return "same"
		}
	}
	
	function displayIndexArrow(a) {
		switch (a) {
		case "+":
			return "arrow up ";
		case "-":
			return "arrow low "
		default :
			return "same ";
		}
	}

	function closePop() {
		$("#" + $("#marketIndexDivId").val()).fadeOut();
	}
</script>

<style>
</style>

</head>
<body>	
	<input type="hidden" id="marketIndexDivId" name="marketIndexDivId" value="${marketIndexDivId}">
	<input type="hidden" id="vnIndexSkey" name="vnIndexSkey" value=""/>
	<input type="hidden" id="forIndexSkey" name="forIndexSkey" value=""/>	
	<input type="hidden" id="dailySkey" name="dailySkey" value=""/>
	<input type="hidden" id="dailyNext" name="dailyNext" value=""/>
		
	<div id="marketIndex" class="modal_layer mkt">
		<h2><%= (langCd.equals("en_US") ? "Market Index" : "Chỉ số Index") %></h2>
		<div class="mkt_container">
			<div class="wrap_left">
				<div class="group_table">
					<table class="no_bbt">
						<caption><%= (langCd.equals("en_US") ? "VN INDEX" : "CHỈ SỐ INDEX VIỆT NAM") %></caption>
						<colgroup>
							<col width="35%">
							<col width="25%">
							<col width="25%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Index" : "Chỉ số") %></th>
								<th><%= (langCd.equals("en_US") ? "Close" : "Đóng") %></th>
								<th><%= (langCd.equals("en_US") ? "Chg(+/-)" : "Thay đổi(+/-)") %></th>
								<th><%= (langCd.equals("en_US") ? "Chg(%)" : "Thay đổi(%)") %></th>
							</tr>
						</thead>						
						<tbody id="grdVnIndex">
							
						</tbody>
					</table>
				</div>
			</div>
			<div class="wrap_right">
				<div class="group_table" style="height: <%= (langCd.equals("en_US") ? "310px" : "320px") %>;overflow-y: auto; margin-top: 0;">
					<table class="no_bbt" id="forTbl">
						<caption><%= (langCd.equals("en_US") ? "FOREIGNER INDEX" : "CHỈ SỐ INDEX NƯỚC NGOÀI") %></caption>
						<colgroup>
							<col width="35%">
							<col width="25%">
							<col width="25%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Index" : "Chỉ số") %></th>
								<th><%= (langCd.equals("en_US") ? "Close" : "Đóng") %></th>
								<th><%= (langCd.equals("en_US") ? "Chg(+/-)" : "Thay đổi(+/-)") %></th>
								<th><%= (langCd.equals("en_US") ? "Chg(%)" : "Thay đổi(%)") %></th>
							</tr>
						</thead>						
						<tbody id="grdForIndex">
							
						</tbody>
					</table>
				</div>				
			</div>					
		</div>
		<div class="group_table" style="height: 384px;overflow-y: auto;">
			<table class="no_bbt" id="dailyTbl">
				<caption id="captionSymbol">INDEX</caption>
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
						<th><%= (langCd.equals("en_US") ? "Close" : "Đóng") %></th>
						<th><%= (langCd.equals("en_US") ? "Chg(+/-)" : "Thay đổi(+/-)") %></th>
						<th id="thDailyIndex"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
					</tr>
				</thead>				
				<tbody id="grdDaily">
					
				</tbody>
			</table>
		</div>
		<button class="close" type="button" onclick="closePop()">close</button>
	</div>
</body>
</html>