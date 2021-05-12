<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {				
		getMainSectorList();		
		scrollDataMore("searchSectorFilterStockA()", $("#stockListFilter > .group_table"));
		
		$('.wrap_left button.wts_expand').on('click',function(){
			var existOn=$(this).parents('.left_content01').hasClass('on');
			var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
			if(existOn){
				$(this).parents('.left_content01').removeClass('on');	
				$(this).text('+ EXPAND');				
			}else{
				$(this).parents('.left_content01').addClass('on');
				$(this).text('- Reduce');
			}
		});
	});
	
	function getMainSectorList() {
		var param = {
			parentID    : "0"
			, lang  	: ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};
		
		$.ajax({
			url      : "/trading/data/getMainSectorList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Main Sector List");
				//console.log(data);
				
				if(data.mainSectorList != null) {
					if(data.mainSectorList.list1 != null) {
						var htmlStr = "";
						for(var i = 0; i < data.mainSectorList.list1.length; i++) {
							var tmp = data.mainSectorList.list1[i];															
							htmlStr += "<label style=\"cursor: pointer;margin-left:0;width:100%;background:#e1e1e1;color:#555;\" onclick=\"searchSectorFilter('" + tmp.ID + "','" + tmp.name + "');\">" + tmp.name + "</label>";							
							htmlStr += "<br/>";
							htmlStr += "<label style=\"cursor: pointer;margin-left:0;padding:0;color:#333;background:#86d673; width:" + tmp.mkCap + "%\" onclick=\"searchSectorFilter('" + tmp.ID + "','" + tmp.name + "');\"></label>";
							htmlStr += "<label style=\"cursor: pointer;float:center;\" onclick=\"searchSectorFilter('" + tmp.ID + "','" + tmp.name + "');\">" + numIntFormat(tmp.MkCap) + " bilion VND</label>";
							htmlStr += "<label style=\"cursor: pointer;float:right;\" onclick=\"searchSectorFilter('" + tmp.ID + "','" + tmp.name + "');\">" + tmp.mkCap + "%</label>";
							htmlStr += "<br/>";
							htmlStr += "<br/>";
							
						}
						$("#grdMainSector").append(htmlStr);
						searchSectorFilter(data.mainSectorList.list1[0].ID, data.mainSectorList.list1[0].name);
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function searchSectorFilter(parentID, name) {
		$("#lbSectorDetail").html(name);		
		$("#stockListFilter > .group_table").scrollTop(0);
		
		var param = {
				parentID    : parentID
				, lang  	: ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
			};
			
			//console.log("PARAM");
			//console.log(param);
			
			$.ajax({
				url      : "/trading/data/getMainSectorList.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("Main Sector List");
					//console.log(data);
					$("#industrySector option").remove();
					if(data.mainSectorList != null) {
						if(data.mainSectorList.list1 != null) {
							for(var i = 0; i < data.mainSectorList.list1.length; i++) {
								var tmp = data.mainSectorList.list1[i];
								$("#industrySector").append("<option value='" + tmp.ID + "'>"+ tmp.name + "</option>");
							}
							$("#industrySector").val(data.mainSectorList.list1[0].ID);
							searchSectorFilterStock();
						}
					}
				},
				error     :function(e) {
					console.log(e);
				}
			});
	}
	
	function searchSectorFilterStock() {		
		$("#grdSectorFilterStock").find("tr").remove();
		$("#filterStockNext").val("");
		$("#filterStockSkey").val("");
		searchSectorFilterStockA();
	}
	
	function searchSectorFilterStockA() {
		$("#filterStockTbl").block({message: "<span>LOADING...</span>"});
		if ($("#filterStockSkey").val() == "end") {
			$("#filterStockTbl").unblock();
			return;
		}
		var param = {
				industryID    : $("#industrySector").val()
				, lang  	  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
				, skey  	  : $("#filterStockSkey").val()
			};
		
		//console.log("PARAM");
		//console.log(param);
		
			$.ajax({
				url      : "/trading/data/getSectorFilter.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("Filter Sector Stock list");
					//console.log(data);
					if(data.sectorFilterList != null) {
						if(data.sectorFilterList.list1 != null) {
							var htmlStr = "";
							for(var i = 0; i < data.sectorFilterList.list1.length; i++) {
								var tmp = data.sectorFilterList.list1[i];								
								var cssColor  = displayColor(tmp.diff.substring(0, 1));
								var cssArrow  = displayArrow(tmp.diff.substring(0, 1));
								htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selItem('" + tmp.symb + "');\">";
								htmlStr += "	<td class=\"text_left c_code\">" + tmp.symb + "</td>";                       // Stock							
								htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(tmp.curr.substring(1)) + "</td>"; // Current							
								htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(tmp.diff.substring(1)) + "</td>"; // +/-
								htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(tmp.rate.substring(1)) + "</td>"; // +/-
								htmlStr += "	<td>" + numIntFormat(tmp.marketCap) + "</td>"; // Date
								htmlStr += "</tr>";
							}
							$("#grdSectorFilterStock").append(htmlStr);
						}
						if (data.sectorFilterList.next == "N") {
							data.sectorFilterList.skey = "end";
						}
						$("#filterStockSkey").val(data.sectorFilterList.skey);
					}
					$("#filterStockNext").val(data.sectorFilterList.next)
					$("#filterStockTbl").unblock();
				},
				error     :function(e) {
					console.log(e);
					$("#filterStockTbl").unblock();
				}
			});
	}
	
</script>
<body>
	<input type="hidden" id="filterStockSkey" name="filterStockSkey" value=""/>
	<input type="hidden" id="filterStockNext" name="filterStockNext" value=""/>

<div class="tab_content" id="sectorListTab">
	<div role="tabpanel" class="tab_pane" id="tab7">
		<div class="table_right">			
			<button class="wts_expand" type="button">+ EXPAND</button>
		</div>
		<div style="height:251px; overflow:auto;">
		<!-- Profile left -->		
		<div class="profile_wrap_left" style="width:40%;">
		<h3 class="profile"><%= (langCd.equals("en_US") ? "SECTOR LIST" : "DANH SÁCH NGÀNH") %></h3>
		<div class="profile_type_01" style="height: 220px;overflow-y: auto; overflow-x: hidden; position: absolute;width: 40%; border-bottom: 1px solid #e1e1e1;">
		<div id="grdMainSector">
		</div>
		</div>
			
		</div>				
		<!-- Profile right -->
		<div id="stockListFilter" class="profile_wrap_right" style="width:59%;">
		<h3 class="profile" id="lbSectorDetail"></h3>
		<div style="padding-top:5px;">
			<span style="float:left;width:50%;">
				<select style="width:100%;" id="industrySector" onchange="searchSectorFilterStock();">
				</select>
			</span>
		</div>
		<div class="group_table" style="height: 191px;overflow-y: auto; margin-top: 23px;position: absolute;width: 59%;">
			<table class="table" id="filterStockTbl">
				<colgroup>
					<col width="10%" />
					<col width="15%"/>
					<col width="25%"/>
					<col width="15%"/>
					<col />
				</colgroup>
				<thead>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<th><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
						<th><%= (langCd.equals("en_US") ? "Chg(+/-)" : "Thay đổi(+/-)") %></th>
						<th><%= (langCd.equals("en_US") ? "Chg(%)" : "Thay đổi(%)") %></th>
						<th><%= (langCd.equals("en_US") ? "Market Cap" : "Vốn hóa") %></th>
					</tr>
				</thead>
				<tbody id="grdSectorFilterStock">
				</tbody>
			</table>
		</div>			
		</div>
		</div>
	</div>
</div>
</body>
</html>