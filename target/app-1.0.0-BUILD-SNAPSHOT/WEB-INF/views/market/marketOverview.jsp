<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="langCd" value='<%= session.getAttribute("LanguageCookie") %>'></c:set>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());

// 		getMarketOverview();
	});

	function getMarketOverview() {
		$("#tab1").block({message: "<span>LOADING...</span>"});
		var param = {
				mvStartDate       : $("#mvStartDate").val(),
				mvEndDate         : $("#mvEndDate").val(),
				start             : ($("#page").val() == "0" ? "1" : (($("#page").val() - 1) * 15) + 1),
				limit			  : 14,
				page              : $("#page").val()
		};

		$.ajax({
			dataType  : "json",
			url       : "/accInfo/data/queryCashTranHisReport.do",
			asyc      : true,
			data      : param,
			success   : function(data) {
				if(data.jsonObj != null) {
					var cashStatements = "";
					if(data.jsonObj.list != null) {
						for(var i=0; i < data.jsonObj.list.length; i++) {
							var state = data.jsonObj.list[i];
							cashStatements += "<tr>";
							cashStatements += "	<td class=\"text_center\">" + state.ROWNUM + "</td>";   // Order No.
							cashStatements += "	<td class=\"text_center\">" + state.TRANDATE + "</td>"; // Date
							cashStatements += "	<td class=\"text_left\">" + state.REMARKS + "</td>";    // Description
							cashStatements += "	<td>" + numIntFormat(parseInt(state.BALBF)) + "</td>";     // Beginning
							cashStatements += "	<td>" + numIntFormat(parseInt(state.CREDITAMT)) + "</td>"; // Credit
							cashStatements += "	<td>" + numIntFormat(parseInt(state.DEBITAMT)) + "</td>";  // Debit amount
							cashStatements += "	<td>" + numIntFormat(parseInt(state.BALCF)) + "</td>";     // Ending balance
							cashStatements += "</tr>";
						}
					}

					$("#trCashStatements").html(cashStatements);
				}
				drawPage(data.jsonObj.totalCount, "15", (parseInt($("#page").val()) == "0" ? "1" : parseInt($("#page").val())));
				$("#tab1").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab1").unblock();
			}
		});
	}
</script>

<div class="tab_content market">
	<!-- Market Overview -->
	<div role="tabpanel" class="tab_pane" id="tab1">
		<div style="height:500px; background:#a9a9a9; line-height:500px; font-size:20px; color:#fff; text-align:center; font-weight:700;">chart</div>
	</div>
	<!-- // Market Overview -->
</div>
</html>
