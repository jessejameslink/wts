<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>


<html>
<head>

<script>
	var msgResult = "";
	$(document).ready(function() {		
		initDataSetting();
	});
	
	function initDataSetting() {
		$("#tittleName").html('<%= (langCd.equals("en_US") ? "Order Audit - Order Group ID: " : "Lịch sử lệnh - Mã lệnh: ") %>' + $("#mvOrderGroupID").val());
		param = {				
				mvSubAccountID		: "<%= session.getAttribute("subAccountID") %>",				
				mvOrderGroupID		: $("#mvOrderGroupID").val(),				
				mvIsHistory			: false
		};
		//console.log(param);
		
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/getOrderDetail.do",
			data      : param,
			aync      : true,
			success   : function(data) {
				//console.log("ORDER DETAIL");
				//console.log(data);
				if (data.jsonObj.mainResult != null) {
		    		var htmlStr = "";
					for(var i=0; i < data.jsonObj.mainResult.length; i++) {
						var tradeInfo = data.jsonObj.mainResult[i];
						htmlStr += "<tr style=\"cursor:pointer\" " + (i % 2 == 0 ? "" : "class='even'") + ">";			
						htmlStr += "<td style=\"text-align:center;\">" + tradeInfo.actionTime + "</td>"
						htmlStr += "<td style=\"text-align:center;\">" + tradeInfo.orderID + "</td>"
						htmlStr += "<td style=\"text-align:center;\">" + getAction(tradeInfo.actionType) + "</td>"
						htmlStr += "<td style=\"text-align:center;\">" + tradeInfo.stockID + "</td>"
						
						if (tradeInfo.bs == "Buy") {
		    				var bs = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					bs = "Buy";	
		    				} else {
		    					bs = "Mua";
		    				}
		    				htmlStr += "<td style=\"background:#009900;color:#fff;text-align:center;\">" + bs + "</td>";
		    			} else {
		    				var bs = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					bs = "Sell";	
		    				} else {
		    					bs = "Bán";
		    				}
		    				htmlStr += "<td style=\"background:#e5322d;color:#fff;text-align:center;\">" + bs + "</td>";
		    			}
						htmlStr += "<td>" + numIntFormat(parseFloat(tradeInfo.price).toFixed(2)) + "</td>"
						htmlStr += "<td>" + tradeInfo.qty + "</td>"
						if (tradeInfo.orderStatus == "FLL") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Matched";	
		    				} else {
		    					st = "Khớp";
		    				}
		    				htmlStr += "<td style=\"background:#96ff96;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "CAN") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Canceled";	
		    				} else {
		    					st = "Hủy";
		    				}
		    				htmlStr += "<td style=\"background:#ffbedc;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "REJ") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Rejected";	
		    				} else {
		    					st = "Bị từ chối";
		    				}
		    				htmlStr += "<td style=\"background:#F09191;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "PSB") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Ready To Send";	
		    				} else {
		    					st = "Sẵn sàng gửi";
		    				}
		    				htmlStr += "<td style=\"background:#ffffb4;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "MPA") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Modify Pending Approval";	
		    				} else {
		    					st = "Sữa chờ duyệt";
		    				}
		    				htmlStr += "<td style=\"background:#ffffb4;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "PAP") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Pending Approve";	
		    				} else {
		    					st = "Chờ duyệt";
		    				}
		    				htmlStr += "<td style=\"background:#ffffb4;text-align:center;\">" + st + "</td>";

		    			} else if (tradeInfo.orderStatus == "IAV") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Inactive";	
		    				} else {
		    					st = "Chưa kích hoạt";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "ACK") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Queue";	
		    				} else {
		    					st = "Chờ khớp";
		    				}
		    				htmlStr += "<td style=\"background:#ffc87d;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "STB") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Sending";	
		    				} else {
		    					st = "Đang gởi";
		    				}
		    				htmlStr += "<td style=\"background:#ffc87d;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "AMS") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Modify Sending";	
		    				} else {
		    					st = "Đang gởi sửa";
		    				}
		    				htmlStr += "<td style=\"background:#ffc87d;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "ACS") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Cancel Sending";	
		    				} else {
		    					st = "Đang gởi hủy";
		    				}
		    				htmlStr += "<td style=\"background:#ffc87d;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "BPM") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Waiting Cancel";	
		    				} else {
		    					st = "Chờ hủy";
		    				}
		    				htmlStr += "<td style=\"background:#fffefe;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "BMS") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Modify Sent";	
		    				} else {
		    					st = "Hàng đợi sữa đã gởi";
		    				}
		    				htmlStr += "<td style=\"background:#fffefe;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "MPS") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Waiting Modify";	
		    				} else {
		    					st = "Chờ sửa";
		    				}
		    				htmlStr += "<td style=\"background:#fffefe;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "SOR") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Stop Ready";	
		    				} else {
		    					st = "Lệnh dừng sẵn sàng gởi";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "SOS") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Stop Sent";	
		    				} else {
		    					st = "Lệnh dừng đã gởi";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "SOI") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Stop Inactive";	
		    				} else {
		    					st = "Lệnh dừng chưa kích hoạt";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "BIX") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Queue";	
		    				} else {
		    					st = "Đã vào hàng đợi";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "PEX") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Partially Filled";	
		    				} else {
		    					st = "Đã khớp một phần";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "UND") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Undefined";	
		    				} else {
		    					st = "Chưa rõ";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "UND") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Pending Approval (Inactive)";	
		    				} else {
		    					st = "Chờ duyệt";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";
		    			} else if (tradeInfo.orderStatus == "PRB") {
		    				var st = "";
		    				if ("<%= langCd %>" == "en_US") {
		    					st = "Pending Report to BIX";	
		    				} else {
		    					st = "Chờ duyệt gởi đi";
		    				}
		    				htmlStr += "<td style=\"background:#87a5f0;text-align:center;\">" + st + "</td>";

		    			} else {
		    				htmlStr += "<td>" + tradeInfo.orderStatus + "</td>";
		    			}
						
						htmlStr += "<td style=\"text-align:center;\">" + tradeInfo.orderType + "</td>"
						htmlStr += "</tr>";
					}
					$("#grdDetailOrder").html(htmlStr);
		    	}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	function fullOrderType(type, vali){
		switch(type){
			case "L":
				type = "LO";	
				break;
			case "K":
				type = "MTL";	
				break;
			case "M":
				if (vali == "Fok") {
					type = "MOK";	
				} else {
					type = "MAK";
				}					
				break;
			case "A":
				type = "ATO";
				break;
			case "C":
				type = "ATC";
				break;
		}
		return type;
	}
	
	function getAction(action) {
		switch(action) {
		case "IC":
			if ("<%= langCd %>" == "en_US") {
				action = "Input Order";	
			} else {
				action = "Đặt lệnh";
			}
			break;
		case "AS":
			if ("<%= langCd %>" == "en_US") {
				action = "ACK Success";	
			} else {
				action = "Chờ khớp";
			}
			break;
		case "PE":
			if ("<%= langCd %>" == "en_US") {
				action = "Executed";	
			} else {
				action = "Khớp lệnh";
			}
			break;
		case "MC":
			if ("<%= langCd %>" == "en_US") {
				action = "Modify Order";	
			} else {
				action = "Sửa lệnh";
			}
			break;
		case "MS":
			if ("<%= langCd %>" == "en_US") {
				action = "Modify Order Success";	
			} else {
				action = "Sửa lệnh";
			}
			break;
		case "FL":
			if ("<%= langCd %>" == "en_US") {
				action = "Fully Filled";	
			} else {
				action = "Khớp toàn bộ";
			}
			break;
		case "MO":
			if ("<%= langCd %>" == "en_US") {
				action = "Modify Order";	
			} else {
				action = "Sửa lệnh";
			}
			break;
		case "AF":
			if ("<%= langCd %>" == "en_US") {
				action = "ACK Failed";	
			} else {
				action = "Từ chối lệnh";
			}
			break;
		case "CO":
			if ("<%= langCd %>" == "en_US") {
				action = "Cancel Order";	
			} else {
				action = "Hủy lệnh";
			}
			break;
		case "DC":
			if ("<%= langCd %>" == "en_US") {
				action = "Cancel Order";	
			} else {
				action = "Hủy lệnh";
			}
			break;
		case "AZ":
			if ("<%= langCd %>" == "en_US") {
				action = "Ack Filled";	
			} else {
				action = "Hủy phần còn lại";
			}
			break;
		case "IS":
			if ("<%= langCd %>" == "en_US") {
				action = "Input Order";	
			} else {
				action = "Đặt lệnh";
			}
			break;
		case "CI":
			if ("<%= langCd %>" == "en_US") {
				action = "Change to Inactive";	
			} else {
				action = "Chuyển về chưa kích hoạt";
			}
			break;
		case "CA":
			if ("<%= langCd %>" == "en_US") {
				action = "Activate Inactive Order";	
			} else {
				action = "Kích hoạt lệnh";
			}
			break;
		case "KL":
			if ("<%= langCd %>" == "en_US") {
				action = "Reject by Exchange";	
			} else {
				action = "Bị từ chối";
			}
			break;
		case "II":
			if ("<%= langCd %>" == "en_US") {
				action = "Input Inactive Order";	
			} else {
				action = "Đặt lệnh";
			}
			break;
		case "SC":
			if ("<%= langCd %>" == "en_US") {
				action = "Active Stop Order";	
			} else {
				action = "Kích hoạt lệnh dừng";
			}
			break;
		case "EX":
			if ("<%= langCd %>" == "en_US") {
				action = "Expire Order";	
			} else {
				action = "Từ chối phần còn lại";
			}
			break;
		case "CS":
			if ("<%= langCd %>" == "en_US") {
				action = "Cancel Success";	
			} else {
				action = "Hủy lệnh thành công";
			}
			break;
		case "IJ":
			if ("<%= langCd %>" == "en_US") {
				action = "Input Order";	
			} else {
				action = "Đặt lệnh";
			}
			break;
		case "IA":
			if ("<%= langCd %>" == "en_US") {
				action = "Input Order";	
			} else {
				action = "Đặt lệnh";
			}
			break;
		default:
			action = "";
			break;
		}
		return action;
	}
	
	function cancel() {		
		$("#divOrderDetailPop").fadeOut();
	}
</script>

</head>
<body class="mdi">
	<form action="" autocomplete="Off">
		<div class="modal_layer mult">			
			<h2 id="tittleName" style="text-align:center;"></h2>
			<div id="divDetailOrderConf">
				<input type="hidden" id="mvOrderGroupID" name="mvOrderGroupID" value="${groupOrderID}">			
				<div class="group_table" style="height: 240px;overflow-y: auto;">
					<table>
						<thead>
							<tr>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Trade Time" : "Thời gian GD") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Order ID" : "Mã lệnh") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Action" : "Thao tác") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Stock ID" : "Mã CK") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Buy/Sell" : "Mua/Bán") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Price(VND)" : "Giá(VND)") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Qty" : "Khối lượng") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
								<th class="fos_table"><%= (langCd.equals("en_US") ? "Type" : "Loại lệnh") %></th>
							</tr>
						</thead>				
						<tbody id="grdDetailOrder">							
						</tbody>
					</table>
				</div>
				<div class="btn_wrap">					
					<button type="button" onclick="cancel()"><%= (langCd.equals("en_US") ? "Close" : "Đóng") %></button>
				</div>
			</div>
		</div>
	</form>
</body>

</html>