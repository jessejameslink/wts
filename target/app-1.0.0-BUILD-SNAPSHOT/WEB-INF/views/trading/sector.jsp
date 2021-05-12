<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<HTML>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	
	var sectorfirst	=	true;
	
	$(document).ready(function(){
		//$('#mostActTbl').floatThead('destroy');
		/*var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());*/
		searchSectorList();
		scrollDataMore("getSectorList()", $("#tab2 > .grid_area"));
		
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
			$('#mostActTbl').floatThead('reflow');
		});
		
		$('#mostActTbl').floatThead({
			position: 'relative',
			zIndex: function($table){
		        return 0;
		    },
			scrollContainer: true
		    //, autoReflow:true
		});
		
		$('#mostActTbl').floatThead('reflow');
		
	});

	function searchSectorList() {
		$("#grdSector").find("tr").remove();
		$("#sectorNext").val("");
		$("#sectorSkey").val("");
		getSectorList();
	}

	function getSectorList() {
		if ($("#sectorSkey").val() == "end") {
			return;
		}
		$("#tab2").block({message: "<span>LOADING...</span>"});
		var param = {
			  fymd  : $("#fromSearch").val()
			, tymd  : $("#toSearch").val()
			, mark  : $("#mark").val()
			, updn  : $("#updn").val()
			, skey  : $("#sectorSkey").val()
		};

		$.ajax({
			url      : "/trading/data/getSectorList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.sectorList != null) {
					if(data.sectorList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.sectorList.list1.length; i++) {
							var sectorList = data.sectorList.list1[i];
							var cssColor  = displayColor(sectorList.diff.substring(0, 1));
							var cssArrow  = displayArrow(sectorList.diff.substring(0, 1));
							htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selItem('" + sectorList.symb + "');\">";
							htmlStr += "	<td class=\"text_left c_code\">" + sectorList.symb + "</td>";                       // Stock
							htmlStr += "	<td class=\"text_left c_code dotted\">" + sectorList.mark + "</td>";               // Market
							//htmlStr += "	<td class=\"\">" + upDownNumList(sectorList.curr.substring(1))+ "</td>"; // Current
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(sectorList.curr.substring(1))+ "</td>"; // Current
//console.log("CHK ORI==>" + sectorList.curr + ", DI CHECK=>" + sectorList.curr.substring(1) + ", DIFF ORI=>" + sectorList.diff + " ,DI F=>" + sectorList.diff.substring(1));
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(sectorList.diff.substring(1)) + "</td>"; // +/-
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(sectorList.rate.substring(1)) + "</td>"; // %Change
							htmlStr += "	<td>" + numIntFormat(sectorList.avol) + "</td>"; // Volume
							htmlStr += "	<td>" + numIntFormat(sectorList.aval) + "</td>"; // Value
							htmlStr += "</tr>";
							
						}
						$("#grdSector").append(htmlStr);
					}
					
					if(sectorfirst && $("#sectorSkey").val() == "") {
						if(data.sectorList.list1.length != 0 ) {
							selItem(data.sectorList.list1[0].rcod);
							sectorfirst = false;
						}
					}
					
					if (data.sectorList.skey == "") {
						data.sectorList.skey = "end";
					}
					$("#sectorSkey").val(data.sectorList.skey);
				}
				
				$('#mostActTbl').floatThead('reflow');
				
				$("#sectorNext").val(data.sectorList.next)
				$("#tab2").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab2").unblock();
			}
		});
	}
</script>

<div class="tab_content">
	<input type="hidden" id="sectorNext" name="sectorNext" value=""/>
	<input type="hidden" id="sectorSkey" name="sectorSkey" value=""/>
	<div role="tabpanel" class="tab_pane" id="tab2">
		<!-- Sector -->
		<div class="table_right">
			<select id="mark" id="mark" onchange="searchSectorList()" style="width: 100px;">
				<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
				<option value="VN">VN</option>
				<option value="VN30">VN30</option>
				<option value="HNX">HNX</option>
				<option value="HOSE">HOSE</option>
				<option value="UPCOM">UPCOM</option>
			</select>
			<button class="wts_expand" type="button">+ EXPAND</button>
		</div>
		<div class="grid_area" style="height: 251px;">
			<div class="group_table">
				<table class="table" id="mostActTbl">
					<colgroup>
						<col width="5%" />
						<col width="5%" />
						<col />
						<col />
						<col />
						<col />
						<col />
					</colgroup>
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></th>
							<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
							<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
							<th><%= (langCd.equals("en_US") ? "%Change" : "%Thay đổi") %></th>
							<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
							<th><%= (langCd.equals("en_US") ? "Value" : "Giá trị") %></th>
						</tr>
					</thead>
					<tbody id="grdSector">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //Sector -->
	</div>
</div>
</HTML>