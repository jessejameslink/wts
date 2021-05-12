<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var foreignerfirst	=	true;
	$(document).ready(function(){
		$('#foreignerTbl').floatThead('destroy');		
		
		searchForeignerList();
		getForeignerBuySellByIndex();
		scrollDataMore("getForeignerList()", $("#foreignerBuySell > .grid_area"));
		
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
			$('#foreignerTbl').floatThead('reflow');
		});
		
		
		var $table	=	$('#foreignerTbl');
		$('#foreignerTbl').floatThead({
			position: 'relative',
			zIndex: function($table){
		        return 0;
		    },
			scrollContainer: true
		});
	});

	function searchForeignerList() {
		$("#grdForeigner").find("tr").remove();
		$("#foreignerNext").val("");
		$("#foreignerSkey").val("");
		getForeignerList();
	}

	function getForeignerList() {
		if ($("#foreignerSkey").val() == "end") {
			return;
		}
		$("#foreignerBuySell").block({message: "<span>LOADING...</span>"});
		var param = {
			  mark  : $("#mark2").val()
			, skey  : $("#foreignerSkey").val()
		};
		
		$.ajax({
			url      : "/trading/data/getForeignerList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.foreignerList != null) {
					if(data.foreignerList.list1 != null) {
						var htmlStr = "";
						for(var i=0; i < data.foreignerList.list1.length; i++) {
							var foreignerList = data.foreignerList.list1[i];
							htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selItem('" + foreignerList.symb + "');\">";
							htmlStr += "	<td class=\"text_left c_code\">" + foreignerList.symb + "</td>";                       // Stock
							htmlStr += "	<td>" + upDownNumList(foreignerList.buyf) + "</td>"; // Foreigner Buy
							htmlStr += "	<td>" + upDownNumList(foreignerList.self) + "</td>"; // Foreigner Sell
							htmlStr += "	<td>" + upDownNumList(foreignerList.crom) + "</td>"; // Current Room
							htmlStr += "</tr>";
						}
						$("#grdForeigner").append(htmlStr);
					}
					
					if(foreignerfirst && $("#foreignerSkey").val() == "") {
						if(data.foreignerList.list1.length != 0 ) {
							selItem(data.foreignerList.list1[0].symb);
							foreignerfirst = false;
						}
					}
					
					if (data.foreignerList.skey == "") {
						data.foreignerList.skey = "end";
					}
					if ($("#foreignerSkey").val() != "end") {
						$("#foreignerSkey").val(data.foreignerList.skey);
					}
				}
				
				$('#foreignerTbl').floatThead('reflow');
				
				$("#foreignerNext").val(data.foreignerList.next)
				$("#foreignerBuySell").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#foreignerBuySell").unblock();
			}
		});
	}
	
	function getForeignerBuySellByIndex() {
		$("#grdForeignerBuySellByIndex").find("tr").remove();
		$("#foreignerBuySellIndex").block({message: "<span>LOADING...</span>"});
		var param = {
			  lang  : 1
		};
		
		$.ajax({
			url      : "/trading/data/getForeignerBuySellIndex.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("data foreigner buy sell index");
				//console.log(data);
				//console.log("select type ===" + $("#objType").val());
				if (data.foreignerBuySellIndex != null) {
					if(data.foreignerBuySellIndex.list1 != null) {
						var htmlStr = "";
						var val = $("#objType").val();
						for(var i=0; i < data.foreignerBuySellIndex.list1.length; i++) {
							var foreignerBuySellIndex = data.foreignerBuySellIndex.list1[i];
							htmlStr += "<tr>";
							htmlStr += "<td rowspan=\"3\" style=\"text-align:center;font-weight:bold;\">" + foreignerBuySellIndex.idx + "</td>";
							htmlStr += "<td style=\"text-align:center;\"><%= (langCd.equals("en_US") ? "Buy" : "Mua") %></td>";
							if (val == "val") {
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.dbuy_val) + "</td>";
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.fbuy_val) + "</td>";
							} else {
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.dbuy) + "</td>";
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.fbuy) + "</td>";
							}									
							htmlStr += "</tr>";
							
							htmlStr += "<tr>";
							htmlStr += "<td style=\"text-align:center;\"><%= (langCd.equals("en_US") ? "Sell" : "Bán") %></td>";
							if (val == "val") {
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.dsel_val) + "</td>";
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.fsel_val) + "</td>";
							} else {
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.dsel) + "</td>";
								htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.fsel) + "</td>";
							}			
							htmlStr += "</tr>";
							
							htmlStr += "<tr>";
							htmlStr += "<td style=\"text-align:center;color:red;background:#f4f4f5;\"><%= (langCd.equals("en_US") ? "Net-Buy" : "Mua ròng") %></td>";
							if (val == "val") {
								//htmlStr += "<td> </td>";
								//htmlStr += "<td> </td>";
								if (foreignerBuySellIndex.d_net_value > 0) {
									htmlStr += "<td style=\"color:#35970f;\">" + numIntFormat(foreignerBuySellIndex.d_net_value) + "</td>";
								} else if (foreignerBuySellIndex.d_net_buy < 0) {
									htmlStr += "<td style=\"color:#f5394f;\">" + numIntFormat(foreignerBuySellIndex.d_net_value) + "</td>";
								} else {
									htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.d_net_value) + "</td>";	
								}
								
								if (foreignerBuySellIndex.f_net_value > 0) {
									htmlStr += "<td style=\"color:#35970f;\">" + numIntFormat(foreignerBuySellIndex.f_net_value) + "</td>";
								} else if (foreignerBuySellIndex.f_net_value < 0) {
									htmlStr += "<td style=\"color:#f5394f;\">" + numIntFormat(foreignerBuySellIndex.f_net_value) + "</td>";
								} else {
									htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.f_net_value) + "</td>";	
								}
							} else {
								if (foreignerBuySellIndex.d_net_buy > 0) {
									htmlStr += "<td style=\"color:#35970f;\">" + numIntFormat(foreignerBuySellIndex.d_net_buy) + "</td>";
								} else if (foreignerBuySellIndex.d_net_buy < 0) {
									htmlStr += "<td style=\"color:#f5394f;\">" + numIntFormat(foreignerBuySellIndex.d_net_buy) + "</td>";
								} else {
									htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.d_net_buy) + "</td>";	
								}
								
								if (foreignerBuySellIndex.f_net_buy > 0) {
									htmlStr += "<td style=\"color:#35970f;\">" + numIntFormat(foreignerBuySellIndex.f_net_buy) + "</td>";
								} else if (foreignerBuySellIndex.f_net_buy < 0) {
									htmlStr += "<td style=\"color:#f5394f;\">" + numIntFormat(foreignerBuySellIndex.f_net_buy) + "</td>";
								} else {
									htmlStr += "<td>" + numIntFormat(foreignerBuySellIndex.f_net_buy) + "</td>";	
								}
							}			
							htmlStr += "</tr>";
						}
						$("#grdForeignerBuySellByIndex").append(htmlStr);
					}
				}
				$("#foreignerBuySellIndex").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#foreignerBuySellIndex").unblock();
			}
		});				
	}
</script>

<div class="tab_content" id="foreigner_tab">
	<input type="hidden" id="foreignerNext" name="foreignerNext" value=""/>
	<input type="hidden" id="foreignerSkey" name="foreignerSkey" value=""/>
	<div role="tabpanel" class="tab_pane" id="tab5">
		<!-- Foreigner -->
		<div class="table_right">
			<!-- <select id="mark" id="mark" width="150px;"> -->
			<select id="mark2" id="mark2" width="150px;" style="width:82px;">
				<option value="0"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
				<option value="3">HOSE</option>
				<option value="2">HNX</option>				
				<option value="1">UPCOM</option>
			</select>
			<button class="btn" type="button" onclick="searchForeignerList()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button class="wts_expand" type="button">+ EXPAND</button>
		</div>
		<div id="foreignerBuySell" class="profile_wrap_left" style="width:50%;">
			<h3 class="profile"><%= (langCd.equals("en_US") ? "FOREIGNER BUY/SELL" : "NN MUA/BÁN") %></h3>
			<div class="grid_area" style="height:221px;">
				<div class="group_table">
					<table class="table" id="foreignerTbl">
						<colgroup>
							<col width="5%" />
							<col />
							<col />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Foreigner Buy" : "NN Mua") %></th>
								<th><%= (langCd.equals("en_US") ? "Foreigner Sell" : "NN Bán") %></th>							
								<th><%= (langCd.equals("en_US") ? "Current Room" : "Room Hiện Tại") %></th>
							</tr>
						</thead>
						<tbody id="grdForeigner">
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div id="foreignerBuySellIndex" class="profile_wrap_right" style="width:49%;">
			<h3 class="profile"><%= (langCd.equals("en_US") ? "FOREIGNER INDEX BUY/SELL" : "CHỈ SỐ NN MUA/BÁN") %>
			<span style="float:right;width:30%;background:#f1f1f1;">
					<select style="width:100%;" onchange="getForeignerBuySellByIndex();" id="objType">
						<option value="vol"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></option>
						<option value="val"><%= (langCd.equals("en_US") ? "Value(Milion)" : "Giá trị(Triệu)") %></option>						
					</select>
				</span>
			</h3>			
			<div class="group_table" style="height: 219px;overflow-y: auto; margin-top: 10px;position: absolute;width: 49%;">
			<table class="table" id="foreignerBuySellByIndexTbl">
				<colgroup>
					<col width="20%" />
					<col width="20%"/>
					<col width="30%"/>
					<col width="30%"/>
				</colgroup>
				<thead>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Index" : "Chỉ số") %></th>
						<th><%= (langCd.equals("en_US") ? "" : "") %></th>
						<th><%= (langCd.equals("en_US") ? "Domestic" : "Trong nước") %></th>
						<th><%= (langCd.equals("en_US") ? "Foreigner" : "Nước ngoài") %></th>
					</tr>
				</thead>
				<tbody id="grdForeignerBuySellByIndex">
				</tbody>
			</table>
		</div>
		</div>
		<!-- //Foreigner -->
	</div>
</div>
</html>
