<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<HTML>
<head>
	<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
	<script>
		var totalRecordCount = 0;
		$(document).ready(function(){
			var d = new Date();			
			var fd	=	new Date();			
			fd.setDate(fd.getDate() - 7);
			
			$(".datepicker").datepicker({
				showOn      : "button",
				dateFormat  : "dd/mm/yy",
				changeYear  : true,
				changeMonth : true
			});
			
			$("#fromSearch").datepicker("setDate", fd.getDate() + "/" + (fd.getMonth() + 1) + "/" + fd.getFullYear())
			$("#toSearch").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear())
						
			getOrderHist();
		});		

		/*
		mvLastAction:ACCOUNT
		mvChildLastAction:ORDERHISTORYENQUIRY
		mvStartTime:01/01/2016
		mvEndTime:21/09/2016
		mvBS:A
		mvInstrumentID:ALL
		mvStatus:ALL
		mvSorting:InputTime desc
		key:1474443260539
		_dc:1474443260547
		start:0
		limit:15
		page:1
		*/
		function getOrderHist() {
			$("#tab2").block({message: "<span>LOADING...</span>"});
			var param = {
					mvSubAccountID	  : "<%= session.getAttribute("subAccountID") %>",					
					mvBS              : $("#mvBS").val(),
					mvStartTime       : $("#fromSearch").val(),
					mvEndTime         : $("#toSearch").val(),
					mvInstrumentID    : ($("#mvStock").val() == "" ? "" : $("#mvStock").val()),
					limit             : "15",
					start             : ($("#page").val() == "0" ? "0" : (($("#page").val() - 1) * 15)),
					page              : $("#page").val()
			};

			$.ajax({
				dataType  : "json",
				url       : "/accInfo/getOrdHist.do",
				asyc      : true,
				data      : param,
				cache	  : false,
				success   : function(data) {
					$("#tab2").unblock();
					//console.log("GET ORDER HIST");
					//console.log(data);
					setOrderHist(data);
				},
				error     :function(e) {
					console.log(e);
					$("#tab2").unblock();
				}
			});
		}

		function setOrderHist(oData) {
			//console.log("SET ORDER LIST CALL");
			//console.log(oData);
			//console.log(oData.jsonObj.mvOrderBeanList.length);
			if(oData.jsonObj.mvTotalOrders == 0) {
				$(".oh_table02").find("tbody").html("");
				$(".pagination").html("");
				return;
			}

			if(oData.jsonObj.mvOrderBeanList != undefined) {
				var data	=	oData.jsonObj.mvOrderBeanList;
				var trHtml	=	"";
				for(var i = 0; i < data.length; i++) {
					trHtml		+=	"<tr>";
					trHtml		+=	"<td class=\"text_center\">" 	+ 	data[i].mvInputTime	+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	data[i].mvStockID	+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	data[i].mvBS		+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	oderTypeVal(data[i].mvOrderType)	+	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	numIntFormat(data[i].mvQty)		+	"</div>";
					trHtml		+=	"<div>"	+	numIntFormat(numDotComma(data[i].mvPrice))		+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	numIntFormat(data[i].mvFilledQty)	+	"</div>";
					trHtml		+=	"<div>"	+	numIntFormat(numDotComma(data[i].mvFilledPrice))	+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	numIntFormat(numDotComma(data[i].mvAvgPriceValue))	+	"</div>";
					trHtml		+=	"<div>"	+	numIntFormat(data[i].mvCancelQty)	+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	getStatus(trim(data[i].mvStatus))	+	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	trim(data[i].mvOrderID)	+	"</div>";
					trHtml		+=	"<div>"	+	trim(data[i].mvOrderGroupID)	+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td  class=\"text_center\">"	+	data[i].mvChannelID	+	"</td>";
					trHtml		+=	"</tr>";
				}
				$(".oh_table02").find("tbody").html("");
				$(".oh_table02").find("tbody").append(trHtml);
			}

			var data		=	oData.jsonObj;			
			totalRecordCount = data.mvTotalOrders;
			drawPage(data.mvTotalOrders, data.mvPage);
		}
		
		//Full Download
		function getOrderHistFull() {
			$("#tab2").block({message: "<span>LOADING...</span>"});
			var param = {
					mvSubAccountID	  : "<%= session.getAttribute("subAccountID") %>",					
					mvBS              : $("#mvBS").val(),
					mvStartTime       : $("#fromSearch").val(),
					mvEndTime         : $("#toSearch").val(),
					mvInstrumentID    : ($("#mvStock").val() == "" ? "" : $("#mvStock").val()),
					limit             : totalRecordCount,
					start             : 0,
					page              : 1
			};

			$.ajax({
				dataType  : "json",
				url       : "/accInfo/getOrdHist.do",
				asyc      : true,
				data      : param,
				success   : function(data) {
					$("#tab2").unblock();
					//console.log("GET ORDER HIST2");
					//console.log(data);
					setOrderHistFull(data);
				},
				error     :function(e) {
					console.log(e);
					$("#tab2").unblock();
				}
			});
		}

		function setOrderHistFull(oData) {
			//console.log("SET ORDER LIST CALL");
			//console.log(oData);
			//console.log(oData.jsonObj.mvOrderBeanList.length);
			if(oData.jsonObj.mvTotalOrders == 0) {
				$(".oh_table02_full").find("tbody").html("");
				return;
			}

			if(oData.jsonObj.mvOrderBeanList != undefined) {
				var data	=	oData.jsonObj.mvOrderBeanList;
				var trHtml	=	"";
				for(var i = 0; i < data.length; i++) {
					trHtml		+=	"<tr>";
					trHtml		+=	"<td class=\"text_center\">" 	+ 	data[i].mvInputTime	+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	data[i].mvStockID	+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	data[i].mvBS		+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	oderTypeVal(data[i].mvOrderType)	+	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	numIntFormat(data[i].mvQty)		+	"</div>";
					trHtml		+=	"<div>"	+	numIntFormat(numDotComma(data[i].mvPrice))		+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	numIntFormat(data[i].mvFilledQty)	+	"</div>";
					trHtml		+=	"<div>"	+	numIntFormat(numDotComma(data[i].mvFilledPrice))	+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	numIntFormat(numDotComma(data[i].mvAvgPriceValue))	+	"</div>";
					trHtml		+=	"<div>"	+	numIntFormat(data[i].mvCancelQty)	+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	getStatus(trim(data[i].mvStatus))	+	"</td>";
					trHtml		+=	"<td>";
					trHtml		+=	"<div>"	+	trim(data[i].mvOrderID)	+	"</div>";
					trHtml		+=	"<div>"	+	trim(data[i].mvOrderGroupID)	+	"</div>";
					trHtml		+=	"</td>";
					trHtml		+=	"<td  class=\"text_center\">"	+	data[i].mvChannelID	+	"</td>";
					trHtml		+=	"</tr>";
				}
				$(".oh_table02_full").find("tbody").html("");
				$(".oh_table02_full").find("tbody").append(trHtml);
			}
			downloadHisFull();
		}
		//End

		function getStatus(stus) {
			switch(stus){
			case "SOI":
				if ("<%= langCd %>" == "en_US") {
					stus = "Stop Inactive Order";	
				} else {
					stus = "Chưa kích hoạt";
				}
				break;
			case "IAV":
				if ("<%= langCd %>" == "en_US") {
					stus = "Inactive";
				} else {
					stus = "Chưa kích hoạt";
				}
				break;
			case "SOR":
				if ("<%= langCd %>" == "en_US") {
					stus = "Stop Ready";
				} else {
					stus = "Lệnh dừng";
				}
				break;
			case "PAP":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PAM":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PAS":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PAI":
				if ("<%= langCd %>" == "en_US") {
					stus = "Pending Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "PSB":
				if ("<%= langCd %>" == "en_US") {
				stus = "Ready To Send";
				} else {
					stus = "Sẵn sàng gửi";
				}
				break;
			case "STB":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "WRN":
				if ("<%= langCd %>" == "en_US") {
				stus = "Price Warning";
				} else {
					stus = "Cảnh báo giá";
				}
				break;
			case "BIX":
				if ("<%= langCd %>" == "en_US") {
				stus = "Queue";
				} else {
					stus = "Chờ khớp";
				}
				break;
			case "ACK":
				if ("<%= langCd %>" == "en_US") {
				stus = "Queue";
				} else {
					stus = "Chờ khớp";
				}
				break;
			case "AMS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Modify Sent";
				} else {
					stus = "Đã gửi sửa";
				}
				break;
			case "ACS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Cancel Sent";
				} else {
					stus = "Đã gửi hủy"
				}
				break;
			case "BPM":
				if ("<%= langCd %>" == "en_US") {
				stus = "Watting Cancel";
				} else {
					stus = "Chờ hủy";
				}
				break;
			case "BMS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "BSS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "REJ":
				if ("<%= langCd %>" == "en_US") {
				stus = "Reject";
				} else {
					stus = "Đã từ chối";
				}
				break;
			case "CAN":
				if ("<%= langCd %>" == "en_US") {
				stus = "Cancelled";
				} else {
					stus = "Đã hủy";
				}
				break;
			case "WA":
				if ("<%= langCd %>" == "en_US") {
					stus = "Waiting";
				} else {
					stus = "Chờ xác nhận";
				}
				break;
			case "FEX":
				if ("<%= langCd %>" == "en_US") {
					stus = "Fully Executed";
				} else {
					stus = "Khớp toàn bộ";
				}
				break;
			case "PEX":
				if ("<%= langCd %>" == "en_US") {
					stus = "Partially Filled";
				} else {
					stus = "Khớp một phần";
				}
				break;
			case "Q":
				if ("<%= langCd %>" == "en_US") {
					stus = "Queued";
				} else {
					stus = "Chờ khớp";
				}
				break;
			case "WC":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Cancel";
				} else {
					stus = "Chờ hủy";
				}
				break;
			case "WM":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Modify";
				} else {
					stus = "Chờ sửa";
				}
				break;
			case "KLL":
				if ("<%= langCd %>" == "en_US") {
				stus = "Killed";
				} else {
					stus = "Đã từ chối";
				}
				break;				
			case "FLL":
				if ("<%= langCd %>" == "en_US") {
				stus = "Fully Filled";
				} else {
					stus = "Khớp toàn bộ";
				}
				break;
			case "FLC":
				if ("<%= langCd %>" == "en_US") {
				stus = "Partial Filled (Partial Cancel)";
				} else {
					stus = "Khớp 1 phần (Hủy 1 phần)";
				}
				break;
			case "FAK":
				if ("<%= langCd %>" == "en_US") {
				stus = "Filled and Killed";
				} else {
					stus = "Khớp và hủy";
				}
				break;
			case "MPA":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Approval";
				} else {
					stus = "Chờ duyệt";
				}
				break;
			case "MPS":
				if ("<%= langCd %>" == "en_US") {
				stus = "Waiting Modify";
				} else {
					stus = "Chờ sửa";
				}
				break;
			case "MSD":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gửi";
				}
				break;
			case "WRR":
				if ("<%= langCd %>" == "en_US") {
				stus = "Price Warning";
				} else {
					stus = "Cảnh báo giá";
				}
				break;
			case "CPD":
				if ("<%= langCd %>" == "en_US") {
				stus = "Completed";
				} else {
					stus = "Đã hoàn thành";
				}
				break;
			case "EXP":
				if ("<%= langCd %>" == "en_US") {
				stus = "Expired";
				} else {
					stus = "Hết hiệu lực";
				}
				break;
			case "PXP":
				if ("<%= langCd %>" == "en_US") {
				stus = "Partially Expire";
				} else {
					stus = "Hết hạn 1 phần";
				}
				break;
			case "CON":
				if ("<%= langCd %>" == "en_US") {
				stus = "Conditional";
				} else {
					stus = "Lệnh điều kiện";
				}
				break;
			case "COI":
				if ("<%= langCd %>" == "en_US") {
				stus = "COI";
				} else {
					stus = "COI";
				}
				break;
			case "OCO":
				if ("<%= langCd %>" == "en_US") {
				stus = "OCO";
				} else {
					stus = "OCO";
				}
				break;
			case "OCI":
				if ("<%= langCd %>" == "en_US") {
				stus = "OCI";
				} else {
					stus = "OCI";
				}
				break;
			case "ALF":
				if ("<%= langCd %>" == "en_US") {
				stus = "Be Allocated";
				} else {
					stus = "Be Allocated (Fully Filled)";
				}
				break;
			case "UND":
				if ("<%= langCd %>" == "en_US") {
				stus = "Undefined";
				} else {
					stus = "Undefined";
				}
				break;
			case "NEW":
				if ("<%= langCd %>" == "en_US") {
					stus = "New";	
				} else {
					stus = "Chờ xử lý";
				}
				break;
			case "IAT":
				if ("<%= langCd %>" == "en_US") {
				stus = "Inactive";
				} else {
					stus = "Không hiệu lực";
				}
				break;
			case "SND":
				if ("<%= langCd %>" == "en_US") {
				stus = "Sending";
				} else {
					stus = "Đang gởi";
				}
				break;
			case "TRIG":
				if ("<%= langCd %>" == "en_US") {
				stus = "Trigger Order";
				} else {
					stus = "Lệnh điều kiện";
				}
				break;
			default:
				stus = "";
				break;
			}
			return stus;
		}

		function oderTypeVal(oderType){
			switch (oderType) {
				case "L":
					if ("<%= langCd %>" == "en_US") {
					return "Normal";
					} else {
						return "Thường";
					}
				case "F":
					if ("<%= langCd %>" == "en_US") {
					return "Odd Lot";
					} else {
						return "Lô Lẻ)";
					}
				case "D":
					if ("<%= langCd %>" == "en_US") {
					return "CD.Order";
					} else {
						return "CD";
					}
				case "O":
					return "ATO";
				case "C":
					return "ATC";
				case "P":
					if ("<%= langCd %>" == "en_US") {
					return "Put through";
					} else {
						return "Thỏa thuận";
					}
				case "M":
					if ("<%= langCd %>" == "en_US") {
					return "MP";
					} else {
						return "Thị trường";
					}
				case "B":
					return "MOK";
				case "Z":
					return "MAK";
				case "R":
					return "MTL";
				case "J":
					return "PLO";
			}
		}

		var util 		= 	new PageUtil();
		function drawPage(totCnt, mvPage, curPage) {
			util.totalCnt 	= 	totCnt; 				//	ê²ìë¬¼ì ì´ ê±´ì
			util.pageRows 	= 	mvPage.pageSize; 		// 	íë²ì ì¶ë ¥ë  ê²ìë¬¼ ì
			util.disPagepCnt= 	5; 						//	íë©´ ì¶ë ¥ íì´ì§ ì
			util.curPage 	= 	mvPage.pageIndex;  		//	íì¬ ì í íì´ì§
			util.setTotalPage();
			fn_DrowPageNumber();
		}


		function fn_DrowPageNumber() {
			$(".pagination").html(util.Drow());
		}

		function goPage(pageNo) {			
		 	$("#page").val(pageNo);
		 	getOrderHist();
		}

		function next() {
			var page		=	util.getNext();
			util.curPage    =	page;
			goPage(page);
		}

		function prev() {
			var page		=	util.getPrev();
			util.curPage    =	page;
			goPage(page);
		}

		function donwload() {
			$("#downloadLink").prop("download", "Order History.xls");
			$("#downloadLink").click(function() {
				ExcellentExport.excel(this, "ordHist", "datalist");
			});
			$("#downloadLink")[0].click();
		}
		
		function downloadHisFull() {
			$("#downloadLink").prop("download", "Order History.xls");
			$("#downloadLink").click(function() {
				ExcellentExport.excel(this, "ordHistFull", "datalist");
			});
			$("#downloadLink")[0].click();
		}
		
		function stockUpperStr(){
			// 대문자 변환 & 문자 길이 3 이하로 설정
			$("#mvStock").val(xoa_dau($("#mvStock").val().substr(0,3).toUpperCase()));
		}
	</script>
</head>
<div class="tab_content account">
 	<input id="page" name="page" type="hidden" value="1"/>

<!-- Order History -->
	<div role="tabpanel" class="tab_pane" id="tab2">
		<div class="search_area in">
			<label for="type"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></label>
			<span>
				<input name="mvStock" id="mvStock" type="text" style="width:80px;" onkeyup="stockUpperStr();">
			</span>


			<label for="type"><%= (langCd.equals("en_US") ? "Sell/Buy" : "Bán/Mua") %></label>
			<span>
				<select name="mvBS" id="mvBS">
					<option value="A"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
					<option value="S"><%= (langCd.equals("en_US") ? "Sell" : "Bán") %></option>
					<option value="B"><%= (langCd.equals("en_US") ? "Buy" : "Mua") %></option>
				</select>
			</span>

			<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "") %></label>
			<input id="fromSearch" type="text" class="datepicker" value="${serverTime}"/>

			<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "") %></label>
			<input id="toSearch" type="text" class="datepicker" value="${serverTime}"/>

			<button class="btn" type="button" onclick="getOrderHist();"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button type="button" class="btn_down" title="Download" onclick="donwload();">download</button>
			<button type="button" class="btn_down" title="Download All Pages" onclick="getOrderHistFull();">download</button>
			<a style="display:none;" href="#" id="downloadLink" download="#"></a>
		</div>

		<div class="group_table double oh_table02" id="ordHist">
			<table class="table no_bbt">
				<caption class="hidden">Order History table</caption>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Sell/Buy" : "Bán/Mua") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Order type" : "Loại lệnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order volume" : "KL đặt") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Executed volume" : "KL khớp") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Executed amount" : "Giá trị khớp") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order No." : "Số hiệu lệnh") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Channel Type" : "Kênh đặt lệnh") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order Price" : "Giá đặt") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Executed Price" : "Giá khớp") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Cancel volume" : "KL hủy") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Org. Order No." : "Số hiệu lệnh gốc") %></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		
		<div class="group_table double oh_table02_full" style="display:none;" id="ordHistFull">
			<table class="table no_bbt">
				<caption class="hidden">Order History table</caption>
				<thead>
					<tr>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Sell/Buy" : "Bán/Mua") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Order type" : "Loại lệnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order volume" : "KL đặt") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Executed volume" : "KL khớp") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Executed amount" : "Giá trị khớp") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order No." : "Số hiệu lệnh") %></th>
						<th scope="col" rowspan="2"><%= (langCd.equals("en_US") ? "Channel Type" : "Kênh đặt lệnh") %></th>
					</tr>
					<tr>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order Price" : "Giá đặt") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Executed Price" : "Giá khớp") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Cancel volume" : "KL hủy") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Org. Order No." : "Số hiệu lệnh gốc") %></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>

		<div class="pagination">
		</div>
	</div>
	<!-- // Order History -->
</div>
</HTML>