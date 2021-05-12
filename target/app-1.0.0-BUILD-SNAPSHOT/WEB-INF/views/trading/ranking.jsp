<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var rankfirst	=	true;
	$(document).ready(function(){
		$('#rankTbl').floatThead('destroy');
		
		var d 	= 	new Date();
		var fd	=	new Date();
		
		fd.setDate(fd.getDate() - 5);
		
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		
		//$("#fromSearch").datepicker("setDate", d.getDate()-5 + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		//$("#fromSearch").datepicker("setDate", d.getDate() + "/" + (d.getMonth() - 3) + "/" + d.getFullYear());
		$("#fromSearch").datepicker("setDate", fd.getDate() + "/" + (fd.getMonth() + 1) + "/" + fd.getFullYear());
		
		searchRankingList();
		scrollDataMore("getRankingList()", $("#tab3 > .grid_area"));
		
		$('.wrap_left button.wts_expand').on('click',function(){
			var existOn=$(this).parents('.left_content01').hasClass('on');
			var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
			if(existOn){
				$(this).parents('.left_content01').removeClass('on');	
				$(this).text('+ EXPAND');
				/*if(tabId == "buytab") {
					$("#tab41").find("#bid_rcod").show();
					$("#tab41").find("#ent_sch_stock").hide();
				} else {
					$("#tab49").find("#bid_rcod").show();
					$("#tab49").find("#ent_sch_stock").hide();
				}*/
			}else{
				$(this).parents('.left_content01').addClass('on');
				$(this).text('- Reduce');
				/*if(tabId == "buytab") {
					$("#tab41").find("#bid_rcod").hide();
					$("#tab41").find("#ent_sch_stock").show();
				} else {
					$("#tab49").find("#bid_rcod").hide();
					$("#tab49").find("#ent_sch_stock").show();
				}*/
			}
			$('#rankTbl').floatThead('reflow');
		});
		
		
		var $table	=	$('#rankTbl');
		$('#rankTbl').floatThead({
			position: 'relative',
			zIndex: function($table){
		        return 0;
		    },
			scrollContainer: true
		    //, autoReflow:true
		});
		
		
		
		//$(".ui-datepicker").
	});

	function searchRankingList() {
		$("#grdRanking").find("tr").remove();
		$("#rankingNext").val("");
		$("#rankingSkey").val("");
		getRankingList();
	}

	function getRankingList() {
		if ($("#rankingSkey").val() == "end") {
			return;
		}
		$("#tab3").block({message: "<span>LOADING...</span>"});
		var param = {
			  fymd  : $("#fromSearch").val()
			, tymd  : $("#toSearch").val()
			, mark  : $("#mark").val()
			, updn  : $("#updn").val()
			, skey  : $("#rankingSkey").val()
		};
		//console.log($("#mark").val());
		$.ajax({
			url      : "/trading/data/getRankingList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.rankingList != null) {
					if(data.rankingList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.rankingList.list1.length; i++) {
							var rankingList = data.rankingList.list1[i];
							if (parseFloat(upDownNumList(rankingList.advr)) == 0) {
								$("#rankingSkey").val("end");
								break;
							}
							var cssColor  = displayColor(rankingList.diff.substring(0, 1));
							var cssArrow  = displayArrow(rankingList.diff.substring(0, 1));
							htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selItem('" + rankingList.symb + "');\">";
							htmlStr += "	<td class=\"text_left c_code\">" + rankingList.symb + "</td>";                       // Stock
							htmlStr += "	<td class=\"text_left c_code dotted\">" + rankingList.mark + "</td>";               // Market
							
							//htmlStr += "	<td>" + upDownNumList(rankingList.curr.substring(1)) + "</td>"; // Current
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(rankingList.curr.substring(1)) + "</td>"; // Current
							
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(rankingList.diff.substring(1)) + "</td>"; // +/-
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(rankingList.rate.substring(1)) + "</td>"; // %Change
							htmlStr += "	<td>" + numIntFormat(rankingList.avol) + "</td>"; // Volume
							/* 
							htmlStr += "	<td>" + rankingList.advr + "</td>"; // Advanced Ratio
							htmlStr += "	<td>" + upDownNumList(rankingList.advn, "null") + "</td>"; // Advanced Range
							 */
							var ratioColor	=	upDownColor(rankingList.advr);
							htmlStr += "	<td class='" + ratioColor + "'>" + upDownNumList(rankingList.advr) + "</td>"; // Advanced Ratio							
							
							var rangeColor	=	upDownColor(rankingList.advn);
							htmlStr += "	<td class='" + rangeColor + "'>" + upDownNumList(rankingList.advn) + "</td>"; // Advanced Range

							htmlStr += "	<td>" + upDownNumList(rankingList.flst) + "</td>"; // start Date
							htmlStr += "	<td>" + upDownNumList(rankingList.tlst) + "</td>"; // End Date
							htmlStr += "</tr>";
						}
						$("#grdRanking").append(htmlStr);
					}
					
					if(rankfirst && $("#rankingSkey").val() == "") {
						if(data.rankingList.list1.length != 0 ) {
							selItem(data.rankingList.list1[0].symb);
							rankfirst = false;
						}
					}
					
					if (data.rankingList.skey == "") {
						data.rankingList.skey = "end";
					}
					if ($("#rankingSkey").val() != "end") {
						$("#rankingSkey").val(data.rankingList.skey);
					}
				}
				
				$('#rankTbl').floatThead('reflow');
				
				$("#rankingNext").val(data.rankingList.next)
				$("#tab3").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab3").unblock();
			}
		});
	}
</script>

<div class="tab_content" id="rank_tab">
	<input type="hidden" id="rankingNext" name="rankingNext" value=""/>
	<input type="hidden" id="rankingSkey" name="rankingSkey" value=""/>
	<div role="tabpanel" class="tab_pane" id="tab3">
		<!-- Ranking -->
		<div style="float: right;padding-bottom: 5px;">
			<!-- <select id="mark" id="mark" width="150px;"> -->
			<select id="mark" name="mark" width="150px;" style="width:52px;">
				<option value="0"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
				<option value="4">VN</option>
				<option value="5">VN30</option>
				<option value="2">HNX</option>
				<option value="3">HOSE</option>
				<option value="1">UPCOM</option>
			</select>
			<select id="updn" id="updn" style="width:52px;">
				<option value="0"><%= (langCd.equals("en_US") ? "Up" : "Tăng") %></option>
				<option value="1"><%= (langCd.equals("en_US") ? "Down" : "Giảm") %></option>
			</select>
			<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "Từ") %></label>
			<input id="fromSearch" type="text" class="datepicker" id="fromDate" name="fromDate">
			<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "Đến") %></label>
			<input id="toSearch" type="text" class="datepicker" id="toDate" name="toDate">
			<button class="btn" type="button" onclick="searchRankingList()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button class="wts_expand" type="button">+ EXPAND</button>
		</div>
		<div class="grid_area" style="height:224px;">
			<div class="group_table">
				<table class="table" id="rankTbl">
					<colgroup>
						<col width="5%" />
						<col width="5%" />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col width="11%" />
						<col width="11%" />
					</colgroup>
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></th>
							<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
							<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
							<th><%= (langCd.equals("en_US") ? "%Change" : "%Thay đổi") %></th>
							<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
							<th><%= (langCd.equals("en_US") ? "Average Ratio" : "Tỷ lệ tăng") %></th>
							<th><%= (langCd.equals("en_US") ? "Average Range" : "Giá trị tăng") %></th>
							<th><%= (langCd.equals("en_US") ? "Start Date" : "Giá đóng cửa ( Ngày bắt đầu )") %></th>
							<th><%= (langCd.equals("en_US") ? "End Date" : "Giá đóng cửa ( Ngày kết thúc )") %></th>
						</tr>
					</thead>
					<tbody id="grdRanking">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //Ranking -->
	</div>
</div>
</html>
