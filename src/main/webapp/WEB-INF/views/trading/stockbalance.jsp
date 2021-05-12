<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
	        response.setHeader("Cache-Control", "no-cache");
	response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Content-Style-Type" content="text/css"/>
		<meta http-equiv="Cache-Control" content="no-cache" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="-1" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />


<style>
.label_balance1 {position:relative;display:inline-block;height:25px;line-height:25px;vertical-align:middle;color:#666;background: #d9d9d9;border: 1px solid #d7d7d7;margin-left:10px;padding:0 3px 0 3px;border-top-left-radius:10px;border-bottom-left-radius:10px;}
.label_balance2 {position:relative;display:inline-block;height:25px;line-height:25px;vertical-align:middle;color:#666;border: 1px solid #d7d7d7;margin:-6px;padding:0 5px 0 10px;border-top-right-radius:10px;border-bottom-right-radius:10px;}
</style>
</head>
<script>
	$(document).ready(function() {
		getStockInfoListMini();
	});
	
	function getStockInfoListMini() {
		//$("#tab22").block({message: "<span>LOADING...</span>"});
		var param = {
				mvLastAction      : "PORTFOLIOENQUIRY",
				mvChildLastAction : "PORTFOLIO"
		};

		$.ajax({
			dataType  : "json",
			url       : "/trading/data/enquiryportfolio.do",
			data      : param,
			cache: false,
			success   : function(data) {
				//console.log("데이터 확인+++++++++++++++++++++++++++++++");
				//console.log(data);
				if(data.jsonObj != null) {
					if(data.jsonObj.mvPortfolioAccSummaryBean != null) {
						var accSum = data.jsonObj.mvPortfolioAccSummaryBean;
						
						$("#stockValue1").html(numIntFormat(numDotComma(accSum.stockValue)));
						$("#totalPL1").html(numIntFormat(numDotComma(data.jsonObj.totalPL)));
						$("#PLPercent1").html(accSum.PLPercent + "%");
						
						if(Number(accSum.PLPercent) > 0) {
							$("#totalPL1").addClass("up");
							$("#PLPercent1").addClass("up");
						} else if(Number(accSum.PLPercent) < 0) {
							$("#totalPL1").addClass("low");
							$("#PLPercent1").addClass("low");
						}
					}
					if(data.jsonObj.mvPortfolioBeanList != null) {
						var htmlStr    = "";
						$("#grdStockBalMini").find("tr").remove();
						
						var sortList = data.jsonObj.mvPortfolioBeanList.slice(0);
						sortList.sort(function(a,b) {
						    var x = a.mvStockID.toLowerCase();
						    var y = b.mvStockID.toLowerCase();
						    return x < y ? -1 : x > y ? 1 : 0;
						});
						for(var i=0; i < sortList.length; i++) {
							var rowData = sortList[i];							

							var totalVolume = parseInt(numDotComma(rowData.mvTSettled)) - parseInt(numDotComma(rowData.mvPdSell));
							totalVolume    += (parseInt(numDotComma(rowData.mvTTodayConfirmBuy)) + parseInt(numDotComma(rowData.mvTTodayUnsettleBuy)));
							totalVolume    += parseInt(numDotComma(rowData.mvTT1UnsettleBuy)) + parseInt(numDotComma(rowData.mvTT2UnsettleBuy));
							totalVolume    += parseInt(numDotComma(rowData.mvTDueBuy)) + parseInt(numDotComma(rowData.mvTEntitlementQty)) - parseInt(numDotComma(rowData.mvTTodayConfirmSell));
							
							var t0Buy       = parseInt(numDotComma(rowData.mvTTodayConfirmBuy)) + parseInt(numDotComma(rowData.mvTTodayUnsettleBuy));
							var tdSell 		= parseInt(numDotComma(rowData.mvTTodayConfirmSell)) + parseInt(numDotComma(rowData.mvTTodayUnsettleSell));
							
							htmlStr += "<tr style=\"cursor:pointer\" onclick=\"balanceItem('" + rowData.mvStockID + "');\"" + (i % 2 == 0 ? "" : "class='even'") + ">";	
							htmlStr += "	<td class=\"text_center\">" + rowData.mvStockID + "</td>"; // Stock Code
							htmlStr += "	<td>" + numIntFormat(totalVolume) + "</td>"; // Volume - Total volume
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvTradableQty)) + "</td>"; // Volume - Usable
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvAvgPrice)) + "</td>";    // Price - Avg. price
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvMarketPrice)) + "</td>"; // Price - Current price
							htmlStr += "	<td>" + numIntFormat(numDotComma(rowData.mvPL)) + "</td>";        // Portfolio Assessment - Profit/Loss							
							if(Number(rowData.mvPLPercent.replace(/[,]/g, "")) > 0) {
								htmlStr	+=	"<td class=\"up\">";
							} else if(Number(rowData.mvPLPercent.replace(/[,]/g, "")) < 0) {
								htmlStr	+=	"<td class=\"low\">";
							} else {
								htmlStr	+=	"<td>";
							}							
							htmlStr +=  rowData.mvPLPercent + "</td>"; // Portfolio Assessment - %Profit/Loss
							
							htmlStr += "	<td>" + numIntFormat(t0Buy) + "</td>";   // Volume - Today Buy
							htmlStr += "	<td>" + numIntFormat(tdSell) + "</td>";   // Volume - Today Sell
							
							htmlStr += "</tr>";							
						}

						$("#grdStockBalMini").html(htmlStr);
					}
					//$("#tab22").unblock();
				} else {
					if ("<%= langCd %>" == "en_US") {
					 alert("No Search Data"); 
					} else {
					 alert("Không tìm thấy dữ liệu");
					}
					//$("#tab22").unblock();
					
				}
			},
			error     :function(e) {
				console.log(e);
				//$("#tab22").unblock();
			}
		});
	}

	function balanceItem(rcod) {
		$('#selltab a[href="/trading/view/entersell.do"]').trigger('click');
		$("#tab31").find("span[name='bid_rcod']").html(rcod);		
		trdSelItem(rcod, "");
	}
	
	function formatNumber(num) {
		if(num.indexOf('.') != -1) {
			var priceSpl = num.split(".");
			if(priceSpl[1].length == 1) {
				num = priceSpl[0] + "." + priceSpl[1] + "00";
			} else if (priceSpl[1].length == 2) {
				num = priceSpl[0] + "." + priceSpl[1] + "0";
			} else if (priceSpl[1].length > 3) {
				num = parseFloat(num.replace(/,/g,'')).toFixed(3);
			}
		} else {
			num = num + ".000" ;
		}
		return num;
	}
</script>
<div class="tab_content" style="margin-top:0px;">
	<div role="tabpanel" class="tab_pane" id="tab30">
		<!-- Balance -->		
		<div class="s_table_mini" style="">						
			<div class="grid_area radius_top margin_top_0" style="height:284px;">
				<div class="group_table type2 radius_top">
					<table class="table ">
						<colgroup>
							<col />
							<col width="12%" />
							<col width="12%" />
							<col width="12%" />
							<col width="12%" />
							<col width="16%" />
							<col width="8%" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Portfolio Assessment" : "Đánh giá danh mục") %></th>
								<th scope="colgroup" colspan="2"><%= (langCd.equals("en_US") ? "Trade in day" : "Giao dịch trong ngày") %></th>
							</tr>
							<tr>
								<th scope="col"><%= (langCd.equals("en_US") ? "Total Volume" : "Tổng KL") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Usable" : "Số dư GD") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Avg. Price" : "Giá TB") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Current Price" : "Giá hiện tại") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "P/L" : "Lãi/Lỗ") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "% P/L" : "% Lãi/Lỗ") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Bought" : "Đã mua") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Sold" : "Đã bán") %></th>
							</tr>
						</thead>
						<tbody id="grdStockBalMini">
						</tbody>
					</table>
				</div>
			</div>
			<div style="height:35px; border-bottom: none; border-radius: 3px 3px 0 0;line-height: 35px;margin-top:7px;">
			<label class="label_balance1"><%= (langCd.equals("en_US") ? "Stock value" : "Giá trị CK") %>			
			</label>
			<label class="label_balance2" id="stockValue1"></label>
			<label class="label_balance1"><%= (langCd.equals("en_US") ? "P/L" : "Lãi/Lỗ") %>
			</label>
			<label class="label_balance2" id="totalPL1"></label>
			<label class="label_balance1"><%= (langCd.equals("en_US") ? "%P/L" : "%Lãi/Lỗ") %>			
			</label>
			<label class="label_balance2" id="PLPercent1"></label>
			</div>
		</div>
		<!-- //Balance -->
	</div>
</div>
</HTML>