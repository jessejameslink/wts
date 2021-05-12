<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>

    var totalPage = 1;
	$(document).ready(function() {				
		getFinancialsHeader();
	});
	
	function getFinancialsHeader(type) {
		if (type == 1) {
			$("#pageIndex").val(1);
		}
		
		var param = {
				  symb  : $("#dailySymb").val()
				, type  : $("#oj").val()
				, pinx  : $("#pageIndex").val()
			};			
			//console.log("PARAM");
			//console.log(param);			
			$.ajax({
				url      : "/trading/data/getFinancialsHeader.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("Financials Header");
					//console.log(data);					
					if (data.financialsHeader.list1.length > 0) {
						getTotalPage(data.financialsHeader.list1[0].total);
					}
					
					if ($("#pageIndex").val() == 1) {
						$('#btnNext').prop('disabled', true);
					}
					if (totalPage == 1) {
						$('#btnPrev').prop('disabled', true);
					}
					if (data.financialsHeader.list1.length > 0) {
						if ($("#oj").val() == 1) {
							setYearHeader(data);
						} else if ($("#oj").val() == 2) {
							setQuaterHeader(data);
						}
						} else {
							$("#tbKQKD").find("tr").remove();
							$("#tbCDKT").find("tr").remove();
							$("#tbCSTC").find("tr").remove();
							return;
						}
					getFinancialsData();					
				},
				error     :function(e) {
					console.log(e);
				}
			});		
	}
	
	function getFinancialsData() {
		$("#tab29").block({message: "<span>LOADING...</span>"});
		$("#tbKQKD").find("tr").remove();
		$("#tbCDKT").find("tr").remove();
		$("#tbCSTC").find("tr").remove();
		var param = {
				  symb  : $("#dailySymb").val()
				, type  : $("#oj").val()
				, pinx  : $("#pageIndex").val()
				, retype  : 'BCTQ'
			};			
			//console.log("PARAM");
			//console.log(param);			
			$.ajax({
				url      : "/trading/data/getFinancialsData.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("Financials Data");
					//console.log(data);
					var htmlKQKDStr = "";
					var htmlCDKTStr = "";
					var htmlCSTCStr = "";
					for (var i = 0; i < data.financialsData.list1.length; i++) {
						var tmp = data.financialsData.list1[i];
						if (tmp.component.indexOf("Income Statement") >= 0) {
							var name = "";
							if ("<%= langCd %>" == "en_US") {
								name = tmp.nameE;	
							} else {
								name = tmp.name;
							}
							htmlKQKDStr += "<tr>";							
							htmlKQKDStr += "    <th scope=\"row\" style=\"white-space:pre-line;\">" + name + "</th>";
							htmlKQKDStr += "	<td>" + numIntFormat(tmp.val4) + "</td>";							
							htmlKQKDStr += "	<td>" + numIntFormat(tmp.val3) + "</td>";							
							htmlKQKDStr += "	<td>" + numIntFormat(tmp.val2) + "</td>";
							htmlKQKDStr += "	<td>" + numIntFormat(tmp.val1) + "</td>";
							htmlKQKDStr += "</tr>"													
						} else if (tmp.component.indexOf("Balance Sheet") >= 0) {
							var name = "";
							if ("<%= langCd %>" == "en_US") {
								name = tmp.nameE;	
							} else {
								name = tmp.name;
							}
							htmlCDKTStr += "<tr>";							
							htmlCDKTStr += "    <th scope=\"row\" style=\"white-space:pre-line;\">" + name + "</th>";
							htmlCDKTStr += "	<td>" + numIntFormat(tmp.val4) + "</td>";							
							htmlCDKTStr += "	<td>" + numIntFormat(tmp.val3) + "</td>";							
							htmlCDKTStr += "	<td>" + numIntFormat(tmp.val2) + "</td>";
							htmlCDKTStr += "	<td>" + numIntFormat(tmp.val1) + "</td>";
							htmlCDKTStr += "</tr>"
						} else if (tmp.component.indexOf("Ratios") >= 0 || tmp.component.indexOf("RATIOS") >= 0) {
							var name = "";
							if ("<%= langCd %>" == "en_US") {
								name = tmp.nameE;	
							} else {
								name = tmp.name;
							}
							htmlCSTCStr += "<tr>";							
							htmlCSTCStr += "    <th scope=\"row\" style=\"white-space:pre-line;\">" + name + "</th>";
							htmlCSTCStr += "	<td>" + numIntFormat(tmp.val4) + "</td>";							
							htmlCSTCStr += "	<td>" + numIntFormat(tmp.val3) + "</td>";							
							htmlCSTCStr += "	<td>" + numIntFormat(tmp.val2) + "</td>";
							htmlCSTCStr += "	<td>" + numIntFormat(tmp.val1) + "</td>";
							htmlCSTCStr += "</tr>"
						}
					}
					$("#tbKQKD").append(htmlKQKDStr);
					$("#tbCDKT").append(htmlCDKTStr);
					$("#tbCSTC").append(htmlCSTCStr);
					$("#tab29").unblock();
				},
				error     :function(e) {
					$("#tab29").unblock();
					console.log(e);
				}
			});		
	}
	
	function setYearHeader(data) {
		if (data.financialsHeader.list1.length > 0) {
			if (data.financialsHeader.list1[3] != null) {
				$("#tdh1val1").html(data.financialsHeader.list1[3].yearperiod);		
				$("#tdh2val1").html(data.financialsHeader.list1[3].yearperiod);
				$("#tdh3val1").html(data.financialsHeader.list1[3].yearperiod);
			} else {
				$("#tdh1val1").html("");		
				$("#tdh2val1").html("");
				$("#tdh3val1").html("");
			}
			if (data.financialsHeader.list1[2] != null) {
				$("#tdh1val2").html(data.financialsHeader.list1[2].yearperiod);
				$("#tdh2val2").html(data.financialsHeader.list1[2].yearperiod);
				$("#tdh3val2").html(data.financialsHeader.list1[2].yearperiod);				
			} else {
				$("#tdh1val2").html("");
				$("#tdh2val2").html("");
				$("#tdh3val2").html("");	
			}
			
			if (data.financialsHeader.list1[1] != null) {
				$("#tdh1val3").html(data.financialsHeader.list1[1].yearperiod);
				$("#tdh2val3").html(data.financialsHeader.list1[1].yearperiod);
				$("#tdh3val3").html(data.financialsHeader.list1[1].yearperiod);
			} else {
				$("#tdh1val3").html("");
				$("#tdh2val3").html("");
				$("#tdh3val3").html("");
			}
			
			if (data.financialsHeader.list1[0] != null) {
				$("#tdh1val4").html(data.financialsHeader.list1[0].yearperiod);
				$("#tdh2val4").html(data.financialsHeader.list1[0].yearperiod);
				$("#tdh3val4").html(data.financialsHeader.list1[0].yearperiod);		
			} else {
				$("#tdh1val4").html("");
				$("#tdh2val4").html("");
				$("#tdh3val4").html("");
			}
		}
	}
	
	function setQuaterHeader(data) {
		if (data.financialsHeader.list1.length > 0) {
			if (data.financialsHeader.list1[3] != null) {
				$("#tdh1val1").html(data.financialsHeader.list1[3].termcode + "/" + data.financialsHeader.list1[3].yearperiod);
				$("#tdh2val1").html(data.financialsHeader.list1[3].termcode + "/" + data.financialsHeader.list1[3].yearperiod);
				$("#tdh3val1").html(data.financialsHeader.list1[3].termcode + "/" + data.financialsHeader.list1[3].yearperiod);
			} else {
				$("#tdh1val1").html("");		
				$("#tdh2val1").html("");
				$("#tdh3val1").html("");
			}
			
			if (data.financialsHeader.list1[2] != null) {
				$("#tdh1val2").html(data.financialsHeader.list1[2].termcode + "/" + data.financialsHeader.list1[2].yearperiod);
				$("#tdh2val2").html(data.financialsHeader.list1[2].termcode + "/" + data.financialsHeader.list1[2].yearperiod);
				$("#tdh3val2").html(data.financialsHeader.list1[2].termcode + "/" + data.financialsHeader.list1[2].yearperiod);
			} else {
				$("#tdh1val2").html("");
				$("#tdh2val2").html("");
				$("#tdh3val2").html("");	
			}
			
			if (data.financialsHeader.list1[1] != null) {
				$("#tdh1val3").html(data.financialsHeader.list1[1].termcode + "/" + data.financialsHeader.list1[1].yearperiod);
				$("#tdh2val3").html(data.financialsHeader.list1[1].termcode + "/" + data.financialsHeader.list1[1].yearperiod);
				$("#tdh3val3").html(data.financialsHeader.list1[1].termcode + "/" + data.financialsHeader.list1[1].yearperiod);
			} else {
				$("#tdh1val3").html("");
				$("#tdh2val3").html("");
				$("#tdh3val3").html("");
			}
			
			if (data.financialsHeader.list1[0] != null) {
				$("#tdh1val4").html(data.financialsHeader.list1[0].termcode + "/" + data.financialsHeader.list1[0].yearperiod);
				$("#tdh2val4").html(data.financialsHeader.list1[0].termcode + "/" + data.financialsHeader.list1[0].yearperiod);
				$("#tdh3val4").html(data.financialsHeader.list1[0].termcode + "/" + data.financialsHeader.list1[0].yearperiod);
			} else {
				$("#tdh1val4").html("");
				$("#tdh2val4").html("");
				$("#tdh3val4").html("");
			}
		}
	}
	
	function getTotalPage(total) {
		var idiv = Math.floor(total / 4);
		var imod = total % 4;
		if (imod > 0) {
			totalPage = idiv + 1;
		} else {
			totalPage = idiv;	
		}
	}
	
	function searchFinancials(value) {
		getFinancialsHeader(1);		
	}
	
	function btnPreviousClicked() {
		$('#btnNext').prop('disabled', false);
		var tmp = parseInt($('#pageIndex').val()) + 1;
		$('#pageIndex').val(tmp);
		getFinancialsHeader(2);
		if($('#pageIndex').val() == totalPage) {
			$('#btnPrev').prop('disabled', true);
		}
	}
	
    function btnNextClicked() {
    	$('#btnPrev').prop('disabled', false);
    	var tmp = parseInt($('#pageIndex').val()) - 1;
		$('#pageIndex').val(tmp);
		getFinancialsHeader(2);
		if($('#pageIndex').val() == 1) {
			$('#btnNext').prop('disabled', true);
		}
	}
</script>
<style>
.th_header {font-weight:bold;color:#02498b;background:none;border-right:none;text-align:left;border-bottom:none;}
.td_header {font-weight:bold;color:#02498b;border-right:none;border-left:none;}
</style>
<div class="tab_content" id="financialsTab">
	<div role="tabpanel" class="tab_pane" id="tab29">
	    <input type="hidden" id="pageIndex" name="pageIndex" value="1">
		<!-- Financials -->
		<div class="search_area in" style="margin-bottom:10px;">
			<div class="input_search" style="float:left;">
				<select id="oj" onchange="searchFinancials(this.value);">
					<option value="1"><%= (langCd.equals("en_US") ? "Annual" : "Xem theo năm") %></option>
					<option value="2"><%= (langCd.equals("en_US") ? "Quarterly" : "Xem theo quý") %></option>					
				</select>
			</div>
			
			<div class="financial">
				<div class="move_area">
					<button type="button" id="btnPrev" onclick="btnPreviousClicked();" class="btn_prev"></button>
					<button type="button" id="btnNext" onclick="btnNextClicked();" class="btn_next"></button>
				</div>
			</div>
		</div>
		<div style="height:400px; overflow:auto;">
		<table class="financial_type_01" style="table-layout: fixed;">
			<colgroup>
				<col />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
			</colgroup>
			<thead>
				<tr>
					<th class="th_header" scope="row"><%= (langCd.equals("en_US") ? "INCOME STATEMENT" : "KẾT QUẢ KINH DOANH") %></th>
					<td class="td_header" id="tdh1val1"></td>
					<td class="td_header" id="tdh1val2"></td>
					<td class="td_header" id="tdh1val3"></td>
					<td class="td_header" id="tdh1val4"></td>
				</tr>
			</thead>
			<tbody id="tbKQKD">			
			</tbody>
		</table>
		
		<table class="financial_type_01" style="table-layout: fixed;">
				<colgroup>
					<col />
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
				</colgroup>
				<thead>
				   <tr>
						<th class="th_header" scope="row"><%= (langCd.equals("en_US") ? "BALANCE SHEET" : "CÂN ĐỐI KẾ TOÁN") %></th>
						<td class="td_header" id="tdh2val1"></td>
						<td class="td_header" id="tdh2val2"></td>
						<td class="td_header" id="tdh2val3"></td>
						<td class="td_header" id="tdh2val4"></td>
					</tr>
				</thead>
				<tbody id="tbCDKT">
				</tbody>
			</table>
			<table class="financial_type_01" style="table-layout: fixed;">
			<colgroup>
				<col />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
			</colgroup>
			<thead>
			   <tr>
					<th class="th_header" scope="row"><%= (langCd.equals("en_US") ? "RATIOS" : "CHỈ SỐ TÀI CHÍNH") %></th>
					<td class="td_header" id="tdh3val1"></td>
					<td class="td_header" id="tdh3val2"></td>
					<td class="td_header" id="tdh3val3"></td>
					<td class="td_header" id="tdh3val4"></td>
				</tr>
			</thead>
			<tbody id="tbCSTC">				
			</tbody>
		</table>
		</div>		
		<!-- Financials -->
	</div>
</div>
</html>