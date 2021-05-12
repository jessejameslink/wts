<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var iTotalPage = 1;
	$(document).ready(function() {		
		$("#newsSymb").val($("#dailySymb").val());
		$('#prev').prop('disabled', true);
		getIndustryPeersCount();		
	});
	
	function getIndustryPeersCount(type) {
		if (type == 1) {
			$("#page").val(1);
		}
		var param = {
				  symb  : $("#dailySymb").val()
				, smkt  : $('#ojMkt').val()
			};			
			//console.log("PARAM");
			//console.log(param);			
			$.ajax({
				url      : "/trading/data/getIndustryPeersCount.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("Industry Peers Count");
					//console.log(data);
					var count = data.industryPeersCount.cntTotal;
					$('#totalCount').html(count);
					if (count > 0) {
						var idiv = Math.floor(count / 15);
						var imod = count % 15;					
						if (imod > 0) {
							iTotalPage = idiv + 1;
						} else {
							iTotalPage = idiv;	
						}					
					} else {
						iTotalPage = 1;
					}
					if (iTotalPage == 1) {
						$('#next').prop('disabled', true);
					} else {
						$('#next').prop('disabled', false);
					}
					$('#totalPage').html(iTotalPage);
					getIndustryPeersList();
				},
				error     :function(e) {
					console.log(e);
				}
			});		
	}
	
	function getIndustryPeersList() {
		$("#tab28").block({message: "<span>LOADING...</span>"});
		$("#grdIndustry").find("tr").remove();
		var param = {
				  symb  : $("#dailySymb").val()
				, smkt  : $('#ojMkt').val()
				, pinx	: $('#page').val()
				, psiz	: '15'
			};			
			//console.log("PARAM");
			//console.log(param);			
			$.ajax({
				url      : "/trading/data/getIndustryPeersList.do",
				data     : param,
				dataType : "json",
				success  : function(data){
					//console.log("Industry Peers List");
					//console.log(data);		
					var htmlStr = "";
					for (var i = 0; i < data.industryPeersList.list1.length; i++) {
						var tmp = data.industryPeersList.list1[i];
						var color = "0";
						if (tmp.color == 2) {
							color = "1";
						} else if (tmp.color == 1) {
							color = "2";
						} else if (tmp.color == 0) {
							color = "3";
						} else if (tmp.color == -2) {
							color = "4";
						} else if (tmp.color == -1) {
							color = "5";
						}
						var cssColor  = displayColor(color);						
						var cssArrow  = displayArrow(color);						
						htmlStr += "<tr style=\"cursor: pointer;\" onclick=\"selItem('" + tmp.stockcode + "');\">";
						htmlStr += "	<td>" + tmp.stockcode + "</td>";                       // Stock							
						htmlStr += "	<td class='" + cssColor + "'>" + numIntFormat(tmp.lastprice) + "</td>"; // Last price							
						htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + tmp.perchange + "</td>"; // %Change
						htmlStr += "	<td>" + numIntFormat(tmp.highprice) + "</td>"; // High price
						htmlStr += "	<td>" + numIntFormat(tmp.lowprice) + "</td>"; // Low price
						htmlStr += "	<td>" + numIntFormat(tmp.totalvol) + "</td>"; //  Total Volume
						var val	=	Math.floor(Math.floor(tmp.totalval/10)/1000)/100;
						htmlStr += "	<td>" + numIntFormat(val) + "</td>"; // Total Value
						htmlStr += "	<td>" + numIntFormat(tmp.fbuyvol) + "</td>"; // Foreigner buy
						htmlStr += "	<td>" + numIntFormat(tmp.fsellvol) + "</td>"; // Foreigner sell
						var mktcap	=	Math.floor(Math.floor(tmp.mkcap/10000)/1000)/100
						htmlStr += "	<td>" + numIntFormat(mktcap) + "</td>"; // Date
						htmlStr += "	<td>" + upDownNumZeroList(tmp.pe) + "</td>"; // Date
						htmlStr += "	<td>" + upDownNumZeroList(tmp.pb) + "</td>"; // Date
						htmlStr += "</tr>";					
					}
					$("#grdIndustry").append(htmlStr);
					$("#tab28").unblock();
				},
				error     :function(e) {
					$("#tab28").unblock();
					console.log(e);
				}
			});		
	}
	
	function searchIndustryPeers(value) {
		getIndustryPeersCount(1);
	}
	
	function previousClicked() {
		$('#next').prop('disabled', false);
		var tmp = parseInt($('#page').val()) - 1;
		$('#page').val(tmp);
		getIndustryPeersList();
		if(tmp == 1) {
			$('#prev').prop('disabled', true);
		}
	}
	
	function nextClicked() {
		$('#prev').prop('disabled', false);
		var tmp = parseInt($('#page').val()) + 1;
		$('#page').val(tmp);
		getIndustryPeersList();
		if(tmp == iTotalPage) {
			$('#next').prop('disabled', true);
		}
	}
	
</script>
<div class="tab_content" id="industryTab">
	<div role="tabpanel" class="tab_pane" id="tab28">
		<!-- Industry -->
		<div class="search_area in">
			<div class="input_search" style="float:left;">
				<select id="ojMkt" onchange="searchIndustryPeers(this.value);">
					<option value="0">HOSE & HNX & UPCOM</option>
					<option value="1">HOSE</option>
					<option value="2">HNX</option>
					<option value="3">UPCOM</option>					
				</select>				
				
				<label><span id="totalCount"></span><%= (langCd.equals("en_US") ? " companies" : " doanh nghiệp cùng ngành") %></label>
				<!-- //layer_newest -->
			</div>
			
			<div style="float:right;padding-right:10px;">								
				<label style="position:initial; margin:0;"><%= (langCd.equals("en_US") ? "Page " : "Trang ") %></label>					
				<button id="prev" onclick="previousClicked();">-</button>
				<input style="width: 30px; text-align: center;" id="page" name="page" value="1" disabled/></span>
				<button id="next" onclick="nextClicked();">+</button>
				<label style="position:initial; margin:0;"><%= (langCd.equals("en_US") ? " of " : " của ") %><span id="totalPage"></span></label>				
			</div>
		</div>
		<div class="grid_area" style="height:400px;">
			<div class="group_table center news_table">
				<table class="table" id="industryTbl">
					<thead>
						<tr>
							<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
							<th><%= (langCd.equals("en_US") ? "Close" : "Đóng cửa") %></th>
							<th><%= (langCd.equals("en_US") ? "%Change" : "%Thay đổi") %></th>
							<th><%= (langCd.equals("en_US") ? "High" : "Cao nhất") %></th>
							<th><%= (langCd.equals("en_US") ? "Low" : "Thấp nhất") %></th>
							<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
							<th><%= (langCd.equals("en_US") ? "Value(mVND)" : "Giá trị(Tr.VND)") %></th>
							<th><%= (langCd.equals("en_US") ? "Foreign Buy" : "NN Mua") %></th>
							<th><%= (langCd.equals("en_US") ? "Foreign Sell" : "NN Bán") %></th>
							<th><%= (langCd.equals("en_US") ? "Marker Cap (Bilion VND)" : "Vốn hóa thị trường (Tỷ. VND)") %></th>
							<th>P/E</th>
							<th>P/B</th>							
						</tr>
					</thead>
					<tbody id="grdIndustry">
					</tbody>
				</table>
			</div>
		</div>
		<!-- //Industry -->
	</div>
</div>
</html>