<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {				
		getAllProfileData();
	});
	
	function getAllProfileData() {
		var rcod	=	$("#dailySymb").val();
		getBasicInformation(rcod);
		
	}
	
	function getBasicInformation(rcod) {
		$("#tab27").block({message: "<span>LOADING...</span>"});
		var param = {
			  skey  : rcod
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};
		
		//console.log("PARAM");
		//console.log(param);
		
		$.ajax({
			url      : "/trading/data/getBasic.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Basic Information");
				//console.log(data);
				if(data.basicList != null) {
					$("#tdBasic1").html(data.basicList.scope);
					$("#tdBasic2").html(data.basicList.mileStone);
				}							
			},
			error     :function(e) {
				console.log(e);
			}
		});
		getSectorInformation(rcod);
	}
	
	function getSectorInformation(rcod) {
		var param = {
			  skey  : rcod
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};
		
		//console.log("PARAM");
		//console.log(param);
		
		$.ajax({
			url      : "/trading/data/getSectorInfo.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Sector Information");
				//console.log(data);
				if(data.sectorInfoList != null) {
					$("#tdSecL1").html(data.sectorInfoList.sector1);
					$("#tdSecL2").html(data.sectorInfoList.sector2);
					$("#tdSecL3").html(data.sectorInfoList.sector3);
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
		getListingInformation(rcod);
	}
	function getListingInformation(rcod) {
		var param = {
			symb  : rcod			
		};
		
		//console.log("PARAM");
		//console.log(param);
		
		$.ajax({
			url      : "/trading/data/getListingInfo.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Listing Information");
				//console.log(data);
				if(data.listingInfoList != null) {
					$("#tdList1").html(data.listingInfoList.listingDate);
					$("#tdList2").html(numIntFormat(data.listingInfoList.firstTradePrice));
					$("#tdList3").html(numIntFormat(data.listingInfoList.firstListingVol));
					$("#tdList4").html(numIntFormat(data.listingInfoList.listedShare));
					$("#tdList5").html(numIntFormat(data.listingInfoList.outStanding));
				}								
			},
			error     :function(e) {
				console.log(e);
			}
		});
		getPriceChange(rcod);
	}
	function getPriceChange(rcod) {
		var param = {
			symb  : rcod			
		};
		
		//console.log("PARAM");
		//console.log(param);
		
		$.ajax({
			url      : "/trading/data/getPriceChg.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Price Change");
				//console.log(data);
				if(data.priceChgList != null) {
					if(data.priceChgList.list1 != null) {
						//1 week
						var wk =  (data.priceChgList.list1[0].lastPrice - data.priceChgList.list1[1].lastPrice) / data.priceChgList.list1[1].lastPrice * 100;						
						$("#tdPrice1").html(wk.toFixed(2) + "%");
						//1 month
						var mo =  (data.priceChgList.list1[0].lastPrice - data.priceChgList.list1[2].lastPrice) / data.priceChgList.list1[2].lastPrice * 100;						
						$("#tdPrice2").html(mo.toFixed(2) + "%");
						//1 quater
						var qa =  (data.priceChgList.list1[0].lastPrice - data.priceChgList.list1[3].lastPrice) / data.priceChgList.list1[3].lastPrice * 100;						
						$("#tdPrice3").html(qa.toFixed(2) + "%");
						//1 year
						var yr =  (data.priceChgList.list1[0].lastPrice - data.priceChgList.list1[4].lastPrice) / data.priceChgList.list1[4].lastPrice * 100;						
						$("#tdPrice4").html(yr.toFixed(2) + "%");
						//listing date
						var ld =  (data.priceChgList.list1[0].lastPrice - data.priceChgList.list1[5].lastPrice) / data.priceChgList.list1[5].lastPrice * 100;						
						$("#tdPrice5").html(ld.toFixed(2) + "%");
					}
				}							
			},
			error     :function(e) {
				console.log(e);
			}
		});
		getOwnerStructure(rcod);
	}
	
	function getOwnerStructure(rcod) {
		$("#grdOwner").find("tr").remove();
		var param = {
			symb  : rcod
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};
		
		//console.log("PARAM");
		//console.log(param);
		
		$.ajax({
			url      : "/trading/data/getOwnerStc.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Owner Share");
				//console.log(data);
				if(data.ownerStcList != null) {
					if(data.ownerStcList.list1 != null) {
						$("#priceDate").html(" (" + data.ownerStcList.closeDate + ")");
						var htmlStr = "";
						for (var i = 0; i < data.ownerStcList.list1.length; i++) {
							var tmp = data.ownerStcList.list1[i];
							
							if (i < data.ownerStcList.list1.length - 1) {
								htmlStr += "<tr>";
								htmlStr += "<td class=\"b_left\">" + tmp.holder + "</td>";
								htmlStr += "<td class=\"n_right\">" + numIntFormat(tmp.share) + "</td>";
								htmlStr += "<td class=\"b_right\">" + tmp.rate + "%</td>";
								htmlStr += "</tr>";
							} else {
								htmlStr += "<tr>";
								htmlStr += "<td class=\"b_left_bottom\">" + tmp.holder + "</td>";
								htmlStr += "<td class=\"n_right_bottom\">" + numIntFormat(tmp.share) + "</td>";
								htmlStr += "<td class=\"b_right_bottom\">" + tmp.rate + "%</td>";
								htmlStr += "</tr>";
							}
						}
						$("#grdOwner").append(htmlStr);
					}
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
		getMajorShareholder(rcod);
	}
	
	function getMajorShareholder(rcod) {
		$("#grdMajor").find("tr").remove();
		var param = {
			symb  : rcod
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};
		
		//console.log("PARAM");
		//console.log(param);
		
		$.ajax({
			url      : "/trading/data/getMajorShare.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				//console.log("Major Share");
				//console.log(data);
				if(data.majorShareList != null) {
					$("#majorDate").html(" (" + data.majorShareList.closeDate + ")");
					var htmlStr = "";
					for (var i = 0; i < data.majorShareList.list1.length; i++) {
						var tmp = data.majorShareList.list1[i];
						if (i < data.majorShareList.list1.length - 1) {
							htmlStr += "<tr>";
							htmlStr += "<td class=\"b_left\">" + tmp.holder + "</td>";
							htmlStr += "<td class=\"n_right\">" + numIntFormat(tmp.share) + "</td>";
							htmlStr += "<td class=\"b_right\">" + tmp.rate + "%</td>";
							htmlStr += "</tr>";
						} else {
							htmlStr += "<tr>";
							htmlStr += "<td class=\"b_left_bottom\">" + tmp.holder + "</td>";
							htmlStr += "<td class=\"n_right_bottom\">" + numIntFormat(tmp.share) + "</td>";
							htmlStr += "<td class=\"b_right_bottom\">" + tmp.rate + "%</td>";
							htmlStr += "</tr>";
						}
					}
					$("#grdMajor").append(htmlStr);
				}
				$("#tab27").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab27").unblock();
			}
		});
	}
</script>
<div class="tab_content" id="profileTab">
	<div role="tabpanel" class="tab_pane" id="tab27">
		<div style="height:435px; overflow:auto;">
		<!-- Profile left -->		
		<div class="profile_wrap_left">
			<h3 class="profile"><%= (langCd.equals("en_US") ? "Basic Information" : "Thông tin thành lập") %></h3>
			<h3 class="title"><%= (langCd.equals("en_US") ? "Main business scope" : "Ngành nghề kinh doanh chính") %></h3>
			<table style="table-layout:fixed;" class="profile_type_01">
				<colgroup>
					<col />
				</colgroup>
				<tbody>					
					<tr>
						<td style="border-left:1px solid #e1e1e1;border-right:1px solid #e1e1e1;text-align:left;word-break: break-all;word-wrap: break-word;white-space:normal;" id="tdBasic1"></td>
					</tr>
				</tbody>
			</table>
			<h3 class="title"><%= (langCd.equals("en_US") ? "Milestones" : "Mốc lịch sử") %></h3>
			<table style="table-layout:fixed;" class="profile_type_01">
				<colgroup>
					<col />
				</colgroup>
				<tbody>				
					<tr>
						<td style="border:1px solid #e1e1e1;border-top:none;text-align:left;word-break: break-all;word-wrap: break-word;white-space:normal;" id="tdBasic2"></td>
					</tr>
				</tbody>
			</table>
			
			<h3 class="profile"><%= (langCd.equals("en_US") ? "Sector Information" : "Thông tin ngành") %></h3>
			<table class="profile_type_01">
				<colgroup>
					<col width="60" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "Level 1 :" : "Cấp 1 :") %></th>
						<td style="text-align:left;" id="tdSecL1"></td>
					</tr>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "Level 2 :" : "Cấp 2 :") %></th>
						<td style="text-align:left;" id="tdSecL2"></td>
					</tr>
					<tr>
						<th style="border-bottom:1px solid #e1e1e1;" scope="row"><%= (langCd.equals("en_US") ? "Level 3 :" : "Cấp 3 :") %></th>
						<td style="border-bottom:1px solid #e1e1e1;text-align:left;" id="tdSecL3"></td>
					</tr>
				</tbody>
			</table>
			<h3 class="profile"><%= (langCd.equals("en_US") ? "Listing Information" : "Cổ phiếu niêm yết và lưu hành") %></h3>
			<table class="profile_type_01">
				<colgroup>
					<col width="130" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "List date" : "Ngày niêm yết") %></th>
						<td id="tdList1"></td>
					</tr>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "First trading day price" : "Giá ngày GD đầu tiên") %></th>
						<td id="tdList2"></td>
					</tr>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "First listed volume" : "KL niêm yết lần đầu") %></th>
						<td id="tdList3"></td>
					</tr>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "Listed shares" : "KL niêm yết hiện tại") %></th>
						<td id="tdList4"></td>
					</tr>
					<tr>
						<th style="border-bottom:1px solid #e1e1e1;" scope="row"><%= (langCd.equals("en_US") ? "Shares outstanding" : "KL cổ phiếu đang lưu hành") %></th>
						<td style="border-bottom:1px solid #e1e1e1;" id="tdList5"></td>
					</tr>
				</tbody>
			</table>
		</div>				
		<!-- Profile right -->
		<div class="profile_wrap_right">
			<h3 class="profile"><%= (langCd.equals("en_US") ? "Price Change" : "Biến động giá giao dịch") %></h3>
			<table class="profile_type_01">
				<colgroup>
					<col width="130" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "+/- 1 week" : "+/- Qua 1 tuần") %></th>
						<td id="tdPrice1"></td>
					</tr>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "+/- 1 month" : "+/- Qua 1 tháng") %></th>
						<td id="tdPrice2"></td>
					</tr>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "+/- 1 quarter" : "+/- Qua 1 quý") %></th>
						<td id="tdPrice3"></td>
					</tr>
					<tr>
						<th scope="row"><%= (langCd.equals("en_US") ? "+/- 1 year" : "+/- Qua 1 năm") %></th>
						<td id="tdPrice4"></td>
					</tr>
					<tr>
						<th style="border-bottom:1px solid #e1e1e1;" scope="row"><%= (langCd.equals("en_US") ? "+/- From listing date" : "+/- Niêm yết") %></th>
						<td style="border-bottom:1px solid #e1e1e1;" id="tdPrice5"></td>
					</tr>
				</tbody>
			</table>
			<h3 class="profile"><%= (langCd.equals("en_US") ? "Ownership Structure" : "Cơ cấu sở hữu") %><span id="priceDate"></span></h3>
			<table class="profile_type_02">
				<colgroup>
					<col width="30%" />
					<col />
					<col width="15%" />
				</colgroup>
				<thead>
					<tr>
						<th class="b_left" scope="col"><%= (langCd.equals("en_US") ? "Share Holder" : "Cổ đông") %></th>
						<th class="n_right" scope="col"><%= (langCd.equals("en_US") ? "Share" : "Cổ phần") %></th>
						<th class="b_right" scope="col"><%= (langCd.equals("en_US") ? "% Holding" : "Tỷ lệ %") %></th>
					</tr>
				</thead>
				<tbody id="grdOwner">				
				</tbody>
			</table>
			<h3 class="profile"><%= (langCd.equals("en_US") ? "Major Shareholders" : "Cổ đông lớn") %><span id="majorDate"></span></h3>
			<table class="profile_type_02">
				<colgroup>
					<col width="30%" />
					<col />
					<col width="15%" />
				</colgroup>
				<thead>
					<tr>
						<th class="b_left" scope="col"><%= (langCd.equals("en_US") ? "Share Holder" : "Cổ đông") %></th>
						<th class="n_right" scope="col"><%= (langCd.equals("en_US") ? "Share" : "Cổ phần") %></th>
						<th class="b_right" scope="col"><%= (langCd.equals("en_US") ? "% Holding" : "Tỷ lệ %") %></th>
					</tr>
				</thead>
				<tbody id="grdMajor">					
				</tbody>
			</table>
		</div>
		</div>
	</div>
</div>
</html>