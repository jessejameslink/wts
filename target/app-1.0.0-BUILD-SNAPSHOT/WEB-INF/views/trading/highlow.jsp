<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var highlowfirst	=	true;
	$(document).ready(function(){
		$('#highlowTbl').floatThead('destroy');
		
		searchHighLowList();
		scrollDataMore("getHighLowList()", $("#tab4 > .grid_area"));
		
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
			$('#highlowTbl').floatThead('reflow');
		});
		
		
		var $table	=	$('#highlowTbl');
		$('#highlowTbl').floatThead({
			position: 'relative',
			zIndex: function($table){
		        return 0;
		    },
			scrollContainer: true
		});		
	});

	function searchHighLowList() {
		$("#grdHighLow").find("tr").remove();
		$("#highlowNext").val("");
		$("#highlowSkey").val("");
		getHighLowList();
	}

	function getHighLowList() {
		if ($("#highlowSkey").val() == "end") {
			return;
		}
		$("#tab4").block({message: "<span>LOADING...</span>"});
		var param = {			  		
			  mark  : $("#mark1").val()
			, high  : $("#hilo").val()
			, days  : $("#days").val()
			, skey  : $("#highlowSkey").val()
		};
		
		//console.log("days==" + $("#highlow_tab").find("select[id='days']").val());
		//console.log("mark==" + $("#highlow_tab").find("select[id='mark1']").val());
		//console.log("hilo==" + $("#highlow_tab").find("select[id='hilo']").val());
		//console.log("skey==" + $("#highlow_tab").find("input[id='highlowSkey']").val());
		
		$.ajax({
			url      : "/trading/data/getHighLowList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.highlowList != null) {
					if(data.highlowList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.highlowList.list1.length; i++) {
							var highlowList = data.highlowList.list1[i];
							var cssColor  = displayColor(highlowList.diff.substring(0, 1));
							var cssArrow  = displayArrow(highlowList.diff.substring(0, 1));
							htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selItem('" + highlowList.symb + "');\">";
							htmlStr += "	<td class=\"text_left c_code\">" + highlowList.symb + "</td>";                       // Stock
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(highlowList.curr.substring(1)) + "</td>"; // Current							
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(highlowList.diff.substring(1)) + "</td>"; // +/-
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(highlowList.rate.substring(1)) + "</td>"; // %Change
							htmlStr += "	<td>" + numIntFormat(highlowList.avol) + "</td>"; // Volume							
							htmlStr += "	<td>" + upDownNumList(highlowList.high) + "</td>"; // High
							htmlStr += "	<td>" + highlowList.date + "</td>"; // Date
							htmlStr += "</tr>";
						}
						$("#grdHighLow").append(htmlStr);
					}
					
					if(highlowfirst && $("#highlowSkey").val() == "") {
						if(data.highlowList.list1.length != 0 ) {
							selItem(data.highlowList.list1[0].symb);
							highlowfirst = false;
						}
					}
					
					if (data.highlowList.skey == "") {
						data.highlowList.skey = "end";
					}
					if ($("#highlowSkey").val() != "end") {
						$("#highlowSkey").val(data.highlowList.skey);
					}
				}
				
				$('#highlowTbl').floatThead('reflow');
				
				$("#highlowNext").val(data.highlowList.next)
				$("#tab4").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab4").unblock();
			}
		});
	}
	function chgHighLowType(type) {
		if(type == "1") {
			$("#thHighLow").html("<%= (langCd.equals("en_US") ? "Lowest" : "Thấp nhất") %>");
		} else {
			$("#thHighLow").html("<%= (langCd.equals("en_US") ? "Highest" : "Cao nhất") %>");
		}		
	}
</script>

<div class="tab_content" id="highlow_tab">
	<input type="hidden" id="highlowNext" name="highlowNext" value=""/>
	<input type="hidden" id="highlowSkey" name="highlowSkey" value=""/>
	<div role="tabpanel" class="tab_pane" id="tab4">
		<!-- highlow -->
		<div style="float: right;padding-bottom: 5px;">
			<!-- <select id="mark" id="mark" width="150px;"> -->
			<select id="mark1" id="mark1" width="150px;" style="width:82px;">
				<option value="0"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>												
				<option value="3">HOSE</option>
				<option value="2">HNX</option>
				<option value="1">UPCOM</option>
			</select>
			<select id="hilo" id="hilo" style="width:52px;" onchange="chgHighLowType(this.value);">
				<option value="0"><%= (langCd.equals("en_US") ? "High" : "Cao") %></option>
				<option value="1"><%= (langCd.equals("en_US") ? "Low" : "Thấp") %></option>
			</select>
			<select id="days" id="days" style="width:78px;">
				<option value="0"><%= (langCd.equals("en_US") ? "5 Days" : "5 Ngày") %></option>
				<option value="1"><%= (langCd.equals("en_US") ? "20 Days" : "20 Ngày") %></option>
			</select>
			<button class="btn" type="button" onclick="searchHighLowList()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button class="wts_expand" type="button">+ EXPAND</button>
		</div>
		<div class="grid_area" style="height:224px;">
			<div class="group_table">
				<table class="table" id="highlowTbl">
					<colgroup>
						<col width="5%" />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
					</colgroup>
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
							<th><%= (langCd.equals("en_US") ? "Chg(+/-)" : "Thay đổi(+/-)") %></th>
							<th><%= (langCd.equals("en_US") ? "Chg(%)" : "Thay đổi(%)") %></th>
							<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
							<th id="thHighLow"><%= (langCd.equals("en_US") ? "Highest" : "Cao nhất") %></th>
							<th><%= (langCd.equals("en_US") ? "New Date" : "New Date") %></th>							
						</tr>
					</thead>
					<tbody id="grdHighLow">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //highlow -->
	</div>
</div>
</html>
