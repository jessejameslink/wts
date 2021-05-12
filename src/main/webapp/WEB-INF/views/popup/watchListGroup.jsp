<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.tablednd.js"></script>

<script>

	
	//delay 500 enter key
	var keyup_timeout;
	var timeout_delay_in_ms = 500;
	
	$(document).ready(function() {
		grpComboPop();

		$(".layer_sub_btn .layer_sub").hide();
		$('.layer_sub_btn button').click(function(e){
			var self = $(this);

			if(self.closest('.btn_wrap').length){ // sub layer button
				self.closest('.layer_sub').hide();
				$('.layer_sub_btn button').removeClass('on');
			} else { // layer toggle button
				self.toggleClass('on');
				$('.layer_sub_btn button').not(this).removeClass('on');
				$('.layer_sub_btn .layer_sub').not($(this).next()).hide();
				self.next().toggle();
			}
		});
		getStockPop();
		
		$("#schMarketPopALL").on('change', function(e) {
			getStockPopMarket("ALL");
		});
		$("#schMarketPopHO").on('change', function(e) {			
			getStockPopMarket("HOSE");
		});
		$("#schMarketPopHA").on('change', function(e) {
			getStockPopMarket("HNX");
		});
		$("#schMarketPopOTC").on('change', function(e) {		
			getStockPopMarket("UPCOM");
		});
		$("#schMarketPopCW").on('change', function(e) {			
			getStockPopMarket("CW");
		});
	});

	function grpComboPop() {
		$("#grdGrpStock").block({message: "<span>LOADING...</span>"});
		var param = {
			  usid  : $("#popUsid").val()
			, func  : "Q"
		};

		$.ajax({
			url      : "/trading/data/getGrpList.do",
			data     : param,
			aync     : true,
			dataType : 'json',
			success  : function(data){
				$("#grdGrpStock").unblock();
				$("#popWatchGrp").find("option").remove();
				if(data.grpList != null) {
					if(data.grpList.list1 != null) {
						for(var i=0; i < data.grpList.list1.length; i++) {
							var grpCode = data.grpList.list1[i];
							$("#popWatchGrp").append("<option value='" + grpCode.grpn + "'>" + grpCode.dscr + "</option>");
						}
					}
					$("#popWatchGrp").val($("#popGrpId").val());
					getWatchListPop();
				}
			},
			error     :function(e) {
				console.log(e);
				$("#grdGrpStock").unblock();
			}
		});
	}

	function searchStock(evt) {
		$("#schNamePop").val(xoa_dau($("#schNamePop").val().toUpperCase()));
		if(evt.keyCode == 13) {
			
			//delay enter key
			clearTimeout(keyup_timeout); // Clear the previous timeout so that it won't be executed any more. It will be overwritten by a new one below.
		        keyup_timeout = setTimeout(function() {
		            // Perform your magic here.
		        }, timeout_delay_in_ms);
			
			
			getStockPop();
		}
	}

	function getStockPop() {
		$("#grdStockPop").block({message: "<span>LOADING...</span>"});
		var param = {
			  stockCd  :  $("#schNamePop").val()
			, marketId :  $("input[name=schMarketPop]:checked").val()
		};

		$.ajax({
			url      : "/trading/data/getMarketStockList.do",
			data     : param,
			aync     : true,
			dataType : 'json',
			success  : function(data){
				$("#grdStockPop").unblock();
				if(data.stockList != null) {
					var stockStr = "";
					for(var i=0; i < data.stockList.length; i++) {
						var stockList = data.stockList[i];
						var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
						stockStr += "<tr class=\"stok_sch_lst\" onclick=\"selectRowPop(this)\" style=\"cursor: pointer;\">";
						stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
						stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
						stockStr += "</tr>";
					}

					$("#grdStockPop").html(stockStr);
				}
								
				$(".stok_sch_lst").dblclick(function() {
					stockChoice();
				});
				
			},
			error     :function(e) {
				console.log(e);
				$("#grdStockPop").unblock();
			}
		});
	}
	
	function getStockPopMarket(market) {
		$("#grdStockPop").block({message: "<span>LOADING...</span>"});
		var sM;
		if (market == "CW") {
			sM = "HOSE"
		} else {
			sM = market;
		}
		
		var param = {
			  stockCd  :  ""
			, marketId :  sM
		};

		$.ajax({
			url      : "/trading/data/getMarketStockList.do",
			data     : param,
			aync     : true,
			dataType : 'json',
			success  : function(data){
				$("#grdStockPop").unblock();
				if(data.stockList != null) {
					var stockStr = "";
					for(var i=0; i < data.stockList.length; i++) {
						var stockList = data.stockList[i];
						if (market == "CW") {
							if (stockList.snum == "W") {
								var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<tr class=\"stok_sch_lst\" onclick=\"selectRowPop(this)\" style=\"cursor: pointer;\">";
								stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
								stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
								stockStr += "</tr>";
							}
						} else {
							var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
							stockStr += "<tr class=\"stok_sch_lst\" onclick=\"selectRowPop(this)\" style=\"cursor: pointer;\">";
							stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
							stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
							stockStr += "</tr>";	
						}						
					}

					$("#grdStockPop").html(stockStr);
				}
								
				$(".stok_sch_lst").dblclick(function() {
					stockChoice();
				});
				
			},
			error     :function(e) {
				console.log(e);
				$("#grdStockPop").unblock();
			}
		});
	}

	function getWatchListPop() {
		$("#grdGrpStock").block({message: "<span>LOADING...</span>"});
		$("#grpName").val($("#popWatchGrp option:selected").text())
		var param = {
			  usid  :  $("#popUsid").val()
			, grpn  :  $("#popWatchGrp").val()
			, lang  : ("<%= langCd %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getWatchList.do",
			data     : param,
			dataType : 'json',
			success  : function(data){
				if(data.watchList != null) {
					if(data.watchList.list1 != null) {
						var stockGrpStr = "";
						for(var i=0; i < data.watchList.list1.length; i++) {
							var watchList = data.watchList.list1[i];
							stockGrpStr += "<tr class=\"toggler_row\" style=\"cursor: move;\">";
							stockGrpStr += "	<td class=\"btn_change text_center\">";							
							stockGrpStr += "	";
							stockGrpStr += "	<td class=\"text_center\">";
							stockGrpStr += "		<button class=\"btn_del\" type=\"button\" onclick=\"deleteStock(this)\">cancel</button>";
							stockGrpStr += "		<input type=\"hidden\" id=\"trGrpFlag\" name=\"trGrpFlag\" value='N'>";
							stockGrpStr += "		<input type=\"hidden\" id=\"trGrpStock\" name=\"trGrpStock\" value='" + watchList.symb + "'>";
							stockGrpStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trGrpStockNm\">" + watchList.symb + " - " + watchList.snam + "</p></td>";
							stockGrpStr += "</tr>";
						}

						$("#grdGrpStock").html(stockGrpStr).tableDnD({onDragClass: "myDragClass"});
					}
				}
				$("#grdGrpStock").unblock();
				
			},
			error     :function(e) {
				console.log(e);
				$("#grdGrpStock").unblock();
			}
		});
	}

	function tagMoveUp(pTr) {
		var prevHtml = $(pTr).closest("tr").prev().html();
		var currHtml = $(pTr).closest("tr").html();

		if(prevHtml == undefined) {
			return;
		}

		$(pTr).closest("tr").prev().html(currHtml);
		$(pTr).closest("tr").html(prevHtml);
	}

	function tagMoveDown(pTr) {
		var nextHtml = $(pTr).closest("tr").next().html();
		var currHtml = $(pTr).closest("tr").html();

		if( nextHtml == undefined) {
			return;
		}

		$(pTr).closest("tr").next().html(currHtml);
		$(pTr).closest("tr").html(nextHtml);
	}

	function selectRowPop(pTr) {
		if($(pTr).closest("tr").attr("class").indexOf("selected") > 0 ) {
			$(pTr).closest("tr").removeClass("selected");
		} else {
			$(pTr).closest("tr").addClass("selected");
		}
	}

	function stockChoice() {
		var stockGrpStr = "";
		var chk_flag	=	true;
		var dup_flag	=	false;
		$(".selected").each(function (i, value){
			var rcod	=	$(this).find("#trStock").text();
			chk_flag	=	true;
			$("#grdGrpStock > tr").each(function() {
				var $trrow	=	this;
				var compRcod	=	$($trrow).find("#trGrpStockNm").html().substring(0,3);
				if(rcod == $(this).find("#trGrpStockNm").html().substring(0,3)) {
					//console.log("RETURN");
					chk_flag	=	false;
					dup_flag	=	true;		// duplicate item 
					return true; 				//continue role
				}
			});
			
			
			if(chk_flag) {
				stockGrpStr += "<tr class=\"toggler_row\" style=\"cursor: move;\">";
				stockGrpStr += "	<td class=\"btn_change text_center\">";							
				stockGrpStr += "	";
				stockGrpStr += "	<td class=\"text_center\">";
				stockGrpStr += "		<button class=\"btn_del\" type=\"button\" onclick=\"deleteStock(this)\">cancel</button>";
				stockGrpStr += "		<input type=\"hidden\" id=\"trGrpFlag\" name=\"trGrpFlag\" value='I'>";
				stockGrpStr += "		<input type=\"hidden\" id=\"trGrpStock\" name=\"trGrpStock\" value='" + $(this).find("#trStock").text() + "'>";
				stockGrpStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trGrpStockNm\">" + $(this).find("#trStock").text() + " - " + $(this).find("#trStockNm").text() + "</p></td>";
				stockGrpStr += "</tr>";
			}
			
			$(this).removeClass("selected");
		});

		if(dup_flag) {
			
			if ("<%= langCd %>" == "en_US") {
				alert("Duplicate items will not be added.");	
			} else {
				alert("Trùng không thể thêm.");
			}
		}
		
		//$("#grdGrpStock").append(stockGrpStr).tableDnD({onDragClass: "myDragClass"});
		$("#grdGrpStock").prepend(stockGrpStr).tableDnD({onDragClass: "myDragClass"});
	}
	
	function stockClearSearch() {
		if ($("#schNamePop").val() == "") {
			return;
		} else {
			$("#schNamePop").val("");
			getStockPop();			
		}
	}

	function deleteStock(pTr) {
		var _this = $(pTr).closest("tr");
		_this.find("#trGrpFlag").val("D");
		_this.remove();
	}

	function grpNameSave() {
		$("#grdGrpStock").block({message: "<span>LOADING...</span>"});
		var selIdx  = $("#popWatchGrp option").index($("#popWatchGrp option:selected"));
		var grpnGrp = "";
		var dscrGrp = "";

		$("#popWatchGrp option").each(function(i) {
			grpnGrp += (i == 0 ? "" : ",") + rpadStr($(this).val(), 2, " ");
			dscrGrp += (i == 0 ? "" : ",") + rpadStr((i == selIdx ? $("#grpName").val() : $(this).text()), 15, " ");
		});
		$("#grpName").val("");

		var grpn = grpnGrp.split(",");
		var dscr = dscrGrp.split(",");

		var param = {
				  usid       : $("#popUsid").val()
				, grpn_0     : grpn[0]
				, dscr_0     : dscr[0]
				, grpn_1     : grpn[1]
				, dscr_1     : dscr[1]
				, grpn_2     : grpn[2]
				, dscr_2     : dscr[2]
				, grpn_3     : grpn[3]
				, dscr_3     : dscr[3]
				, grpn_4     : grpn[4]
				, dscr_4     : dscr[4]
				, grpn_5     : grpn[5]
				, dscr_5     : dscr[5]
				, grpn_6     : grpn[6]
				, dscr_6     : dscr[6]
				, grpn_7     : grpn[7]
				, dscr_7     : dscr[7]
				, grpn_8     : grpn[8]
				, dscr_8     : dscr[8]
				, grpn_9     : grpn[9]
				, dscr_9     : dscr[9]
				, GridCount1 : $("#popWatchGrp option").length
		};

		$.ajax({
			url      : "/trading/data/groupNameSave.do",
			data     : param,
			dataType : 'json',
			success  : function(data){
				$("#grdGrpStock").unblock();
				grpCombo();
				grpComboPop();
			},
			error     :function(e) {
				console.log(e);
				$("#grdGrpStock").unblock();
			}
		});
	}

	function grpComboSave() {
		$("#grdGrpStock").block({message: "<span>LOADING...</span>"});
		var codeNms = "";
		var grpName = $("#grpName").val();
		$("#grpName").val("");
		$("#grdStockPop tr").removeClass("selected");

		$("input[name=trGrpStock]").each(function(key, value) {
			codeNms += rpadStr($(this).val(), 12, " ");
		});

		var param = {
				  usid  :  $("#popUsid").val()
				, func  :  "U"
				, grpn  :  $("#popWatchGrp").val()
				, dscr  :  $("#popWatchGrp option:selected").text()
				, nrec  :  $("input[name=trGrpStock]").length
				, code  :  codeNms
		};

		$.ajax({
			url      : "/trading/data/getGrpList.do",
			data     : param,
			dataType : 'json',
			success  : function(data){
				$("#grdGrpStock").unblock();
				//alert(data.trResult);
				if ("<%= langCd %>" == "en_US") {
					alert("Add stock successful.");	
				} else {
					alert("Thêm thành công.");
				}
				grpCombo();
				cancel();
			},
			error     :function(e) {
				console.log(e);
				$("#grdGrpStock").unblock();
			}
		});
	}

	function cancel() {
		$("#" + $("#divIdGroup").val()).fadeOut();
	}

</script>
<style type="text/css">
.myDragClass {
    background-color: yellow;
    font-size: 14pt;
}
</style>
</head>
<body>
	<!-- //WATCH LIST GROUP -->
	<div class="modal_layer add total">
		<input type="hidden" id="divIdGroup" name="divIdGroup" value="${formData.divId}">
		<input type="hidden" id="popGrpId" name="popGrpId" value="${formData.grpId}">
		<input type="hidden" id="popUsid" name="popUsid" value="${formData.watUsid}">
		<input type="hidden" id="popFunc" name="popFunc" value="">
		<input type="hidden" id="popGrpn" name="popGrpn" value="">
		<input type="hidden" id="popDscr" name="popDscr" value="">
		<input type="hidden" id="popNrec" name="popNrec" value="">
		<input type="hidden" id="popCode" name="popCode" value="">
		<!-- //CODE SEARCH -->
		<div class="total_wrap">
			<h2><%= (langCd.equals("en_US") ? "STOCK SEARCH" : "Mã TÌM KIẾM") %></h2>
			<div class="search_area">
				<label for="schNamePop"><%= (langCd.equals("en_US") ? "Name" : "Tên") %></label>
				<div class="input_search">
					<input type="text" id="schNamePop" name="schNamePop" onkeyup="searchStock(event)">
					<button type="button" id="schStockPop" name="schStockPop" onclick="getStockPop()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
				</div>
			</div>
			<div class="under_wrap">
				<div class="mdi_search">
					<div class="radio_area">
						<input type="radio" id="schMarketPopALL" name="schMarketPop" value="ALL" checked="checked"><label for="schMarketPopALL">All</label>
						<!-- 
						<input type="radio" id="schMarketPopVN" name="schMarketPop" value="VN"><label for="schMarketPopVN">VN</label>
						 -->
						<input type="radio" id="schMarketPopHO" name="schMarketPop" value="HOSE"><label for="schMarketPopHO">HOSE</label>
						<input type="radio" id="schMarketPopHA" name="schMarketPop" value="HNX"><label for="schMarketPopHA">HNX</label>
						<!-- 
						<input type="radio" id="schMarketPopHSX" name="schMarketPop" value="HSX"><label for="schMarketPopHSX">HSX</label>
						-->
						<input type="radio" id="schMarketPopOTC" name="schMarketPop" value="UPCOM"><label for="schMarketPopOTC">UPCOM</label>
						<input type="radio" id="schMarketPopCW" name="schMarketPop" value="HOSE"><label for="schMarketPopOTC">CW</label>						
					</div>
				</div>
				<div class="inner">
					<div class="table_outer">
						<div class="group_table type1" style="overflow-x: hidden;">
							<table class="table">
								<colgroup>
									<col width="80">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
										<th><%= (langCd.equals("en_US") ? "Name" : "Tên Công ty") %></th>
									</tr>
								</thead>
								<tbody id="grdStockPop">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="btn_wrap">
				<button class="add" type="button" onclick="stockChoice()"><%= (langCd.equals("en_US") ? "Add" : "Thêm") %></button>
				<button type="button" onclick="stockClearSearch()"><%= (langCd.equals("en_US") ? "Clear" : "Xóa") %></button>
			</div>
		</div>
		<!-- //CODE SEARCH -->

		<!-- WATCH LIST GROUP -->
		<div class="total_wrap">
			<h2><%= (langCd.equals("en_US") ? "WATCH LIST GROUP" : "NHÓM DANH MỤC QUAN TÂM") %></h2>
			<div class="stock_search">
				<select style="width:100%;" id="popWatchGrp" name="popWatchGrp" onchange="getWatchListPop()">
				</select>
			</div>
			<div class="under_wrap">
				<div class="mdi_search">
					<div class="btn_area layer_sub_btn">
						<!-- //layer_sub -->
						<button type="button">· <%= (langCd.equals("en_US") ? "Name Change" : "Đổi Tên Nhóm") %></button>
						<!-- layer_sub -->
						<div class="layer_sub">
							<h3><%= (langCd.equals("en_US") ? "Group Name Change" : "Đổi Tên Nhóm") %></h3>
							<div>
								<label for=""><%= (langCd.equals("en_US") ? "Name" : "Tên") %></label>
								<input id="grpName" name="grpName" type="text" value="">
							</div>
							<div class="btn_wrap">
								<button class="add" type="button" onclick="grpNameSave()"><%= (langCd.equals("en_US") ? "OK" : "OK") %></button>
								<button type="button"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
							</div>
						</div>
						<!-- //layer_sub -->
					</div>
				</div>
				<div class="inner">
					<div class="table_outer">
						<div class="group_table type1" style="overflow-x: hidden;">
							<table id="grdMainGrpStock" class="table"
        data-table="grdGrpStock"
        data-ondragstart="$(table).parent().find('.result').text('data-ondragstart');"
        data-ondrop="inline_sprintlist_ondrop(table, row);"
        data-serializeregexp="^.*sprints$|[^\_]*$"
        data-ondragclass="sprintlist-drag"
        data-ondragstyle=""
        data-ondropstyle=""
        data-scrollamount="100"
        data-sensitivity="1"
        data-hierarchylevel="2"
        data-indentartifact="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        data-autowidthadjust="1"
        data-autocleanrelations="1"
        data-jsonpretifyseparator="    "
        data-serializeparamname="sprintlist"
        data-draghandle="">
								<colgroup>
									<col width="43">
									<col width="72">
									<col>
								</colgroup>
								<thead id="sprintlist_header">
									<tr>
										<th style="width:50px;"><%= (langCd.equals("en_US") ? "" : "") %></th>
										<th style="width:80px;"><%= (langCd.equals("en_US") ? "Del" : "Xóa") %></th>
										<th><%= (langCd.equals("en_US") ? "Name" : "Tên Công ty") %></th>
									</tr>
								</thead>
								<tbody id="grdGrpStock">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="btn_wrap">
				<button class="add" type="button" onclick="grpComboSave()"><%= (langCd.equals("en_US") ? "Save" : "Lưu lại") %></button>
				<button type="button" onclick="cancel()"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
			</div>
		</div>
		<!-- WATCH LIST GROUP -->
		<button class="close" type="button" onclick="cancel()">close</button>
	</div>
	<!-- //WATCH LIST GROUP -->
</body>
</html>