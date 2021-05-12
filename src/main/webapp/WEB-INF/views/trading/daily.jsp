<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function(){
		$('#dailyTbl').floatThead('destroy');
		
		$("#grdDaily").find("tr").remove();
		$("#dailyNext").val("");
		$("#dailySkey").val("");
		getDailyList();
		scrollDataMore("getDailyList()", $("#tab24 > .grid_area"));
		
		$('#dailyTbl').floatThead({
		    position: 'relative',
		    zIndex: function($table){
		        return 0;
		    },
		    scrollContainer: true
		    //, autoReflow:true
		});
	});

	function getDailyList() {
		if ($("#dailySkey").val() == "end") {
			return;
		}
		$("#tab24").block({message: "<span>LOADING...</span>"});
		var param = {
			  symb  : $("#dailySymb").val()
			, skey  : $("#dailySkey").val()
		};

		//console.log("#########DAILT LIST CHECK###########");
		//console.log(param);
		
		$.ajax({
			url      : "/trading/data/getDailyList.do",
			data     : param,
			dataType : 'json',
			success  : function(data){
				if(data.dailyList != null) {
					if(data.dailyList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.dailyList.list1.length; i++) {
							var dailyList = data.dailyList.list1[i];
							var cssColor  = displayColor(dailyList.diff.substring(0, 1));
							var cssArrow  = displayArrow(dailyList.diff.substring(0, 1));
							var rtId	  =	dailyList.date;
							rtId	=	rtId.split("/").join("");
							 
							htmlStr += "<tr>";
							htmlStr += "	<td id=\""+rtId+"_date\" class=\"text_center\">" + dailyList.date + "</td>"; // Daily
							htmlStr += "	<td id=\""+rtId+"_prev\" class=\""+cssColor+"\">" + diffNum(dailyList.clos) + "</td>"; // Prev Price
							htmlStr += "	<td id=\""+rtId+"_diff\" class='" + cssArrow + "'>" + diffNum(dailyList.diff) + "</td>"; // +/-
							htmlStr += "	<td id=\""+rtId+"_chg\" class='" + cssColor + "'>" + dailyList.rate.substring(1) + "</td>"; // %Change
							htmlStr += "	<td id=\""+rtId+"_vol\" class='" + cssColor + "'>" + numIntFormat(dailyList.lvol) + "</td>"; // Volume
							htmlStr += "	<td id=\""+rtId+"_open\" class=\""+displayColor(dailyList.open.substring(0, 1))+"\">" + numIntFormat(dailyList.open.substring(1)) + "</td>"; // Open
							htmlStr += "	<td id=\""+rtId+"_high\" class=\""+displayColor(dailyList.high.substring(0, 1))+"\">" + numIntFormat(dailyList.high.substring(1)) + "</td>"; // High
							htmlStr += "	<td id=\""+rtId+"_low\" class=\""+displayColor(dailyList.lowe.substring(0, 1))+"\">" + numIntFormat(dailyList.lowe.substring(1)) + "</td>"; // Low
							htmlStr += "	<td id=\""+rtId+"_ave\" class=\""+displayColor(dailyList.avrg.substring(0, 1))+"\">" + numIntFormat(dailyList.avrg.substring(1)) + "</td>"; // Ave. Price
							htmlStr += "</tr>";
						}
						$("#grdDaily").append(htmlStr);
						/*
						if($("#dailySkey").val() == "") {
							$("#grdDaily").html(htmlStr);
						} else {
							$("#grdDaily").append(htmlStr);
						}
						*/
					}
					if (data.dailyList.skey != "") {
					$("#dailySkey").val(data.dailyList.skey);
					} else {
						data.dailyList.skey = "end";
						$("#dailySkey").val(data.dailyList.skey);
					}
				}
				
				$('#dailyTbl').floatThead('reflow');
				$("#dailyNext").val(data.dailyList.next);
				$("#tab24").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab24").unblock();
			}
		});
	}
</script>

<div class="tab_content">
	<input type="hidden" id="dailyNext" name="dailyNext" value=""/>
	<div role="tabpanel" class="tab_pane" id="tab24">
		<!-- Daily -->
		<div class="grid_area" style="height: 435px;">
			<div class="group_table">
				<table class="table" id="dailyTbl">
					<colgroup>
						<col width="11%">
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
							<th><%= (langCd.equals("en_US") ? "Close Price" : "Giá đóng cửa") %></th>
							<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
							<th><%= (langCd.equals("en_US") ? "%Change" : "%Thay đổi") %></th>
							<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
							<th><%= (langCd.equals("en_US") ? "Open" : "Giá mở cửa") %></th>
							<th><%= (langCd.equals("en_US") ? "High" : "Giá cao nhất") %></th>
							<th><%= (langCd.equals("en_US") ? "Low" : "Giá thấp nhất") %></th>
							<th><%= (langCd.equals("en_US") ? "Ave. Price" : "Giá bình quân") %></th>
						</tr>
					</thead>
					<tbody id="grdDaily">
					</tbody>
				</table>
			</div>
		</div>
		<!-- Daily -->
	</div>
</div>
</html>
