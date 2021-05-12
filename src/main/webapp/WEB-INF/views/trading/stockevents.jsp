<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {	
		var d 	= 	new Date();
		var fd	=	new Date();
		
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		$("#fromSearch").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		getStockEvents();		
	});
	
	function getStockEvents() {
		$("#tab30").block({message: "<span>LOADING...</span>"});
		$("#grdEvents").find("tr").remove();
		var param = {
				  symb  : $("#stockSymb").val()
				, kind  : $("#ojKind").val()
				, fymd  : $("#fromSearch").val()
				, tymd  : $("#toSearch").val()
				, lang  : ("<%= langCd %>" == "en_US" ? "1" : "0")
			};			
			//console.log("EVENT PARAM");
			//console.log(param);			
			$.ajax({
				url      : "/trading/data/getStockEvents.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("getStockEvents");
					//console.log(data);
					var htmlStr = "";
					for (var i = 0; i < data.evtList.list1.length; i++) {
						var tmp = data.evtList.list1[i];
						var color = "0";
						if (tmp.ColorID == 2) {
							color = "1";
						} else if (tmp.ColorID == 1) {
							color = "2";
						} else if (tmp.ColorID == 0) {
							color = "3";
						} else if (tmp.ColorID == -2) {
							color = "4";
						} else if (tmp.ColorID == -1) {
							color = "5";
						}
						var cssColor  = displayColor(color);						
						var cssArrow  = displayArrow(color);
						
						var className = "";
						(tmp.GDKHQDate != "") ? className = "events" : "";
						
						htmlStr += "<tr class='"+className+"'>";
						htmlStr += "	<td>" + tmp.GDKHQDate + "</td>";                       // Stock	
						htmlStr += "	<td>" + tmp.NDKCCDate + "</td>";                       // Stock
						htmlStr += "	<td>" + tmp.NDKTHDate + "</td>";                       // Stock
						htmlStr += "	<td>" + tmp.CompanyName + "</td>";                       // Stock
						htmlStr += "	<td>" + tmp.Exchange + "</td>";                       // Stock
						htmlStr += "	<td class=\"subject\"><p>" + tmp.Note + "</p></td>";                       // Stock
						htmlStr += "	<td class='" + cssColor + "'>" + numIntFormat(tmp.LastPrice) + "</td>"; // Last price
						htmlStr += "	<td class='" + cssColor + "'>" + numIntFormat(parseInt(tmp.PerChange).toFixed(0)) + "</td>"; // Last price
						htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + tmp.Change + "</td>"; // %Change						
						htmlStr += "</tr>";					
					}
					$("#grdEvents").append(htmlStr);
					$("#tab30").unblock();
				},
				error     :function(e) {
					$("#tab30").unblock();
					console.log(e);
				}
			});		
	}
	
	function getMSymbol(e) {	
		$("#stockSymb").val(xoa_dau($("#stockSymb").val().toUpperCase()));		
	}
	
</script>
<div class="tab_content" id="evtTab">
	<div role="tabpanel" class="tab_pane" id="tab30">
		<!-- Events -->
		<div class="search_area in">
			<label><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></label>
			<input id="stockSymb" type="text" style="width:80px;" onkeyup="getMSymbol(event);">
			<label><%= (langCd.equals("en_US") ? "Kind" : "Thể loại") %></label>
			<select id="ojKind">
				<option value="-1"><%= (langCd.equals("en_US") ? "--All--" : "--Tất cả--") %></option>
				<option value="1"><%= (langCd.equals("en_US") ? "Auction" : "Đấu giá cổ phần") %></option>
				<option value="10"><%= (langCd.equals("en_US") ? "Introduction to public release" : "Giới thiệu phát hành ra công chúng") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Shareholders' meeting" : "Đại hội cổ đông") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Dividend: Ex-Rights Date" : "Chia cổ tức: Ngày giao dịch không hưởng quyền") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Dividend: Dividend day" : "Chia cổ tức: Ngày chia cổ tức") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Additional Issue: Ex-Rights Date" : "Phát hành thêm: Ngày giao dịch không hưởng quyền") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Additional Issue: On additional listing" : "Phát hành thêm: Ngày niêm yết bổ sung") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Share consolidation: Ex-Rights Date" : "Gộp cổ phiếu: Ngày giao dịch không hưởng quyền") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Share consolidation: On the listing of new shares" : "Gộp cổ phiếu: Ngày niêm yết số lượng cổ phiếu mới") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Bonus shares: Ex-Rights Date" : "Thưởng cổ phiếu: Ngày giao dịch không hưởng quyền") %></option>
				<option value="20"><%= (langCd.equals("en_US") ? "Bonus shares: On the listing of new shares" : "Thưởng cổ phiếu: Ngày niêm yết số lượng cổ phiếu mới") %></option>
				<option value="0"><%= (langCd.equals("en_US") ? "Others" : "Khác") %></option>					
			</select>
			
			<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "Từ") %></label>
			<input id="fromSearch" type="text" class="datepicker" id="fromDate" name="fromDate">
			<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "Đến") %></label>
			<input id="toSearch" type="text" class="datepicker" id="toDate" name="toDate">
			<button class="btn" type="button" onclick="getStockEvents()"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>			
		</div>
		<div class="grid_area" style="height:400px;">
			<div class="group_table center news_table">
				<table class="table" id="evtTbl">
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Ex-right date" : "Ngày GDKHQ") %></th>
							<th><%= (langCd.equals("en_US") ? "Last Register Date" : "Ngày ĐKCC") %></th>
							<th><%= (langCd.equals("en_US") ? "Exercise Date	" : "Ngày thực hiện") %></th>
							<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th><%= (langCd.equals("en_US") ? "Exchange" : "Sàn") %></th>
							<th><%= (langCd.equals("en_US") ? "Events" : "Sự kiện") %></th>
							<th><%= (langCd.equals("en_US") ? "Current price" : "Giá hiện tại") %></th>
							<th><%= (langCd.equals("en_US") ? "Change" : "Thay đổi") %></th>
							<th><%= (langCd.equals("en_US") ? "%Change" : "%Thay đổi") %></th>				
						</tr>
					</thead>
					<tbody id="grdEvents">
					</tbody>
				</table>
			</div>
		</div>
		<!-- Events -->
	</div>
</div>
</html>