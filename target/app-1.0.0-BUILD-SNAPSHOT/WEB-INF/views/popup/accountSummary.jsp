<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>


<html>
<head>

<script>	
	$(document).ready(function() {		
		getAccountSummary();
		$("#clientId").html('<%=session.getAttribute("subAccountID") %>');
	});
	
	function getAccountSummary() {
		var param = {
				 mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};
		$.ajax({
			dataType  : "json",
			cache: false,
			url       : "/trading/data/getAccountSummary.do",
			asyc      : true,
			data	  : param,
			success   : function(data) {
				//console.log("Account Summary Data");
				//console.log(data);
				var htmlStr = "";
				var totalCon = 0;
				for(var i = 0; i < data.jsonObj.mvSummaryList.length; i++){
					var rowData = data.jsonObj.mvSummaryList[i];
					htmlStr += "<tr style=\"cursor:pointer\"" + (i % 2 == 0 ? "" : "class='even'") + ">";	
					htmlStr += "	<td class=\"text_center\">" + rowData.stockID + "</td>";
					htmlStr += "	<td class=\"text_center\">" + rowData.bs + "</td>";
					htmlStr += "	<td>" + rowData.totalOSQty + "</td>";
					htmlStr += "	<td>" + rowData.totalFilledQty + "</td>";
					htmlStr += "	<td>" + rowData.avgPrice + "</td>";
					var con = parseInt(rowData.totalFilledQty.replace(/[,]/g, "")) * parseFloat(rowData.avgPrice.replace(/[,]/g, ""))*1000;					
					htmlStr += "	<td>" + numIntFormat(con.toFixed(0)) + "</td>";
					htmlStr += "</tr>";
					
					totalCon = totalCon + con;				
				}
				$("#grdAccountSummary").html(htmlStr);
				$("#totalConsideration").html(numIntFormat(totalCon.toFixed(0)));
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function cancel() {
		var tagId = '<%=request.getParameter("divId")%>';
		$("#" + tagId).fadeOut();
	}

</script>

</head>
<body class="mdi">
	<form action="" autocomplete="Off">
		<div class="modal_layer mult">			
			<h2 id="cancelModifyTitle"><%= (langCd.equals("en_US") ? "Account Summary" : "Tổng quan tài khoản") %></h2>
			<div id="divCanModConf">				
				<div class="group_table" style="height: 384px;overflow-y: auto;">
					<table>
						<colgroup>
							<col width="10%">
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Buy/Sell" : "Mua/Bán") %></th>
								<th><%= (langCd.equals("en_US") ? "OS Qty" : "K.L còn lại") %></th>
								<th><%= (langCd.equals("en_US") ? "Ex. Qty" : "K.L khớp") %></th>
								<th><%= (langCd.equals("en_US") ? "Average Price" : "Giá TB") %></th>
								<th><%= (langCd.equals("en_US") ? "Consideration" : "Giá trị thuần") %></th>
							</tr>
						</thead>				
						<tbody id="grdAccountSummary">							
						</tbody>
					</table>
				</div>
				<div style="height:35px; line-height: 35px;">
					<label style="color:#666666;font-weight: 600;"><%= (langCd.equals("en_US") ? "Client ID" : "Client ID") %></label>					
					<label class="label_balance2" id="clientId">0</label>
					<label style="color:#666666;font-weight: 600;"><%= (langCd.equals("en_US") ? "Total Consideration (VND)" : "Tổng giá trị thuần (VND)") %></label>
					<label class="label_balance2" id="totalConsideration"></label>									
				</div>
				
				<div class="btn_wrap">					
					<button type="button" onclick="cancel()"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
				</div>
			</div>
		</div>
	</form>
</body>

</html>