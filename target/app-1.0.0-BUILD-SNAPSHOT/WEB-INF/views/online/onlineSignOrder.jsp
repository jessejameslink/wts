<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<HTML>
<head>
	<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
	<script>
		$(document).ready(function(){
			//console.log("<%=authenMethod%>");
			//console.log("<%=saveAuth%>");
			var d = new Date();
			$(".datepicker").datepicker({
				showOn      : "button",
				dateFormat  : "dd/mm/yy",
				changeYear  : true,
				changeMonth : true
			});
			
			$("#toSearch").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
			var newDate = new Date(d.getTime() - (60*60*24*30*1000));
			$("#fromSearch").datepicker("setDate", newDate.getDate() + "/" + (newDate.getMonth() + 1) + "/" + newDate.getFullYear());
		
			getOnlineSignOrderList();
			
			//check select
			$('#checkAll').click(function() {
		        if (!$(this).is(':checked')) {
		        	$('.case').prop('checked', false);
		        	$('#multiCancel').prop('disabled', true);
		        } else {
		        	$('.case').prop('checked', true);
		        	if ($('.case:checked').length <= 1) {
						$('#multiCancel').prop('disabled', true);
					} else {
						$('#multiCancel').prop('disabled', false);
					}
		        }
		    });

			$('body').on('change','#onlineOrderTbl input[type="checkbox"]',function(){
				if($('.case').length == $('.case:checked').length) {
	                $("#checkAll").prop("checked", true);
	            } else {
	                $("#checkAll").prop("checked", false);
	            }
				if ($('.case:checked').length <= 1) {
					$('#multiCancel').prop('disabled', true);
				} else {
					$('#multiCancel').prop('disabled', false);
				}
			});
		});
		
		function authCheckOK(divType){
			if(divType == "submitInCashAdvance"){
				submitAdvancePaymentCreation();
			} else if(divType == "submitCashAdvanceInLoan"){
				submitAdvancePaymentCreationInLoan();
			} else if(divType == "submitInLoanRefund"){
				submitLoanRefundCreation();
			} else if (divType == "submitBankAdvancePayment") {
				submitBankAdvancePayment();
			} else if (divType == "submitInOnlineSignOrder") {
				submitOnlineSignOrder();
			}
		}
		
		function getWeeksInMonth(month, year){
			   var weeks=[],
			       firstDate=new Date(year, month, 1),
			       lastDate=new Date(year, month+1, 0), 
			       numDays= lastDate.getDate();
			   
			   var start=1;
			   var end=7-firstDate.getDay();
			   while(start<=numDays){
			       weeks.push({start:start,end:end});
			       start = end + 1;
			       end = end + 7;
			       if(end>numDays)
			           end=numDays;    
			   }        
			    return weeks;
			} 
		/*
		mvLastAction:ACCOUNT
		mvChildLastAction:SIGNORDERENQUIRY
		mvOrderType:
		mvMarketID:
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
		function getOnlineSignOrderList() {
			$("#tab6").block({message: "<span>LOADING...</span>"});
			var param = {
					mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
					mvOrderType		  :	$("#mvOrderType").val(),
					mvMarketID		  :	$("#mvMarketID").val(),										
					mvStartTime       : $("#fromSearch").val(),
					mvEndTime         : $("#toSearch").val(),
					mvBS              : $("#mvBS").val(),
					mvInstrumentID    : ($("#mvInstrumentID").val() == "" ? "ALL" : $("#mvInstrumentID").val()),
					mvStatus          : "ALL",
					mvSorting         : "InputTime desc",
					start             : ($("#page").val() == "0" ? "0" : (($("#page").val() - 1) * 15)),
					limit             : "15",
					page              : $("#page").val()
			};
			
			//console.log("PARAM");
			//console.log(param);

			$.ajax({
				dataType  : "json",
				url       : "/online/data/getOnlineSignOrderList.do",
				asyc      : true,
				data      : param,
				success   : function(data) {
					$("#tab6").unblock();
					//console.log("GET ONLINE SIGN ORDER");
					//console.log(data);
					setOnlineSignOrder(data);
				},
				error     :function(e) {
					console.log(e);
					$("#tab6").unblock();
				}
			});
		}
		
		var dataList = {};
		function setOnlineSignOrder(oData) {
			//console.log("SET ONLINE SIGN ORDER LIST CALL");
			//console.log(oData);
			//console.log(oData.jsonObj.mvOrderBeanList.length);
			if(oData.jsonObj.mvTotalOrders == 0) {
				$("#trOnlineSignOrder").find("tr").remove();
				$(".pagination").html("");
				return;
			}

			if(oData.jsonObj.mvOrderBeanList != undefined) {
				dataList	=	oData.jsonObj.mvOrderBeanList;
				var trHtml	=	"";
				for(var i = 0; i < dataList.length; i++) {
					var className = "";
		 			(i%2 != 0) ? className = "even" : "";
		 			trHtml 		+= "<tr class='"+className+"'>" + "<td class=\"text_center\">";		 			
		 			trHtml 		+= "<input type='checkbox' class='case' name='case' value='" + i + "'/>";			 			
		 			trHtml 		+= "</td>";
					trHtml		+=	"<td class=\"text_left\">"		+	getAction(dataList[i].mvAction)			+	"</td>";
					trHtml		+=	"<td class=\"text_left\">"		+	dataList[i].mvOrderID					+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	dataList[i].mvTradeTime					+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	dataList[i].mvMarketID					+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	dataList[i].mvStockID					+	"</td>";
					trHtml		+=	"<td class=\"text_center\">"	+	oderBuySellVal(dataList[i].mvBS)		+	"</td>";
					trHtml		+=	"<td class=\"text_right\">"		+	oderTypeVal(dataList[i].mvOrderType)	+	"</td>";
					trHtml		+=	"<td class=\"text_right\">"		+	dataList[i].mvQty						+	"</td>";
					trHtml		+=	"<td class=\"text_right\">"		+	dataList[i].mvPrice						+	"</td>";
					trHtml		+=	"<td class=\"text_right\">"		+	getStatus(dataList[i].mvStatus)			+	"</td>";
					trHtml		+=	"<td class=\"text_right\">"		+	dataList[i].mvFilledQty					+	"</td>";
					//trHtml		+=	"<td  class=\"text_right\">"	+	dataList[i].mvFilledPrice				+	"</td>";
					trHtml		+=	"<td class=\"text_right\">"		+	dataList[i].mvCancelQty					+	"</td>";
					trHtml		+=	"</tr>";
				}
				$("#trOnlineSignOrder").html(trHtml);
			}

			var data		=	oData.jsonObj;
			drawPage(data.mvTotalOrders, data.mvPage);
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
			/////////////////////////////////////////////////////////////
			case "CW":
				if ("<%= langCd %>" == "en_US") {
					action = "Cancel Price Warning";	
				} else {
					action = "Cancel Price Warning";
				}
				break;
			case "FA":
				if ("<%= langCd %>" == "en_US") {
					action = "Fill Auction";	
				} else {
					action = "Fill Auction";
				}
				break;
			case "FC":
				if ("<%= langCd %>" == "en_US") {
					action = "Fully Cancelled";	
				} else {
					action = "Fully Cancelled";	
				}
				break;
			case "FF":
				if ("<%= langCd %>" == "en_US") {
					action = "Fully Filled";	
				} else {
					action = "Fully Filled";
				}
				break;
			case "AD":
				if ("<%= langCd %>" == "en_US") {
					action = "Allocation Done";	
				} else {
					action = "Allocation Done";
				}
				break;
			case "AM":
				if ("<%= langCd %>" == "en_US") {
					action = "Approve OK (Local Modify)";	
				} else {
					action = "Approve OK (Local Modify)";
				}
				break;
			case "AP":
				if ("<%= langCd %>" == "en_US") {
					action = "Approve OK";	
				} else {
					action = "Approve OK";
				}
				break;
			case "AX":
				if ("<%= langCd %>" == "en_US") {
					action = "Disapprove";	
				} else {
					action = "Disapprove";
				}
				break;
			case "BC":
				if ("<%= langCd %>" == "en_US") {
					action = "BIX Locally Cancelled";	
				} else {
					action = "BIX Locally Cancelled";
				}
				break;
			case "BM":
				if ("<%= langCd %>" == "en_US") {
					action = "BIX Locally Modified";	
				} else {
					action = "BIX Locally Modified";
				}
				break;
			case "BR":
				if ("<%= langCd %>" == "en_US") {
					action = "BIX Locally Reduced";	
				} else {
					action = "BIX Locally Reduced";
				}
				break;
			case "CF":
				if ("<%= langCd %>" == "en_US") {
					action = "Notify Client for fully-matched";	
				} else {
					action = "Notify Client for fully-matched";
				}
				break;
			case "":
				if ("<%= langCd %>" == "en_US") {
					action = "";	
				} else {
					action = "";
				}
				break;
			case "CM":
				if ("<%= langCd %>" == "en_US") {
					action = "Cancel Modify Request";	
				} else {
					action = "Cancel Modify Request";
				}
				break;
			case "DA":
				if ("<%= langCd %>" == "en_US") {
					action = "Deactive Order";	
				} else {
					action = "Deactive Order";
				}
				break;
			case "DE":
				if ("<%= langCd %>" == "en_US") {
					action = "Request Deallocation";	
				} else {
					action = "Request Deallocation";
				}
				break;
			case "DI":
				if ("<%= langCd %>" == "en_US") {
					action = "Dehold Inactive";	
				} else {
					action = "Dehold Inactive";
				}
				break;
			case "HF":
				if ("<%= langCd %>" == "en_US") {
					action = "Hold Fund";	
				} else {
					action = "Hold Fund";
				}
				break;
			case "ID":
				if ("<%= langCd %>" == "en_US") {
					action = "Input C.D. Order";
				} else {
					action = "Đặt lệnh C.D";	
				}
				break;
			case "IG":
				if ("<%= langCd %>" == "en_US") {
					action = "Inactivate Today GTD Order";	
				} else {
					action = "Inactivate Today GTD Order";
				}
				break;
			case "IK":
				if ("<%= langCd %>" == "en_US") {
					action = "Input Inactive Conditional Order";	
				} else {
					action = "Input Inactive Conditional Order";
				}
				break;
			case "IM":
				if ("<%= langCd %>" == "en_US") {
					action = "Input Conditional Order (Odd Lot)";	
				} else {
					action = "Input Conditional Order (Odd Lot)";
				}
				break;
			case "IN":
				if ("<%= langCd %>" == "en_US") {
					action = "Input Inactive Con Order(Odd Lot)";	
				} else {
					action = "Input Inactive Con Order(Odd Lot)";
				}
				break;
			case "IP":
				if ("<%= langCd %>" == "en_US") {
					action = "Input Split Order";	
				} else {
					action = "Input Split Order";
				}
				break;
			case "LM":
				if ("<%= langCd %>" == "en_US") {
					action = "Local Modify";	
				} else {
					action = "Local Modify";
				}
				break;
			case "MJ":
				if ("<%= langCd %>" == "en_US") {
					action = "Modify Reject";	
				} else {
					action = "Modify Reject";
				}
				break;
			case "ML":
				if ("<%= langCd %>" == "en_US") {
					action = "Modify Local Order";	
				} else {
					action = "Modify Local Order";
				}
				break;
			case "NA":
				if ("<%= langCd %>" == "en_US") {
					action = "Notify client (No Answer)";	
				} else {
					action = "Notify client (No Answer)";
				}
				break;
			case "OI":
				if ("<%= langCd %>" == "en_US") {
					action = "Order Inputed to host";	
				} else {
					action = "Order Inputed to host";
				}
				break;
			case "PC":
				if ("<%= langCd %>" == "en_US") {
					action = "Partially Cancelled";	
				} else {
					action = "Partially Cancelled";
				}
				break;
			case "PF":
				if ("<%= langCd %>" == "en_US") {
					action = "Partially Filled";	
				} else {
					action = "Partially Filled";
				}
				break;
			case "PM":
				if ("<%= langCd %>" == "en_US") {
					action = "Pending Modify";	
				} else {
					action = "Pending Modify";
				}
				break;
			case "PR":
				if ("<%= langCd %>" == "en_US") {
					action = "Trade Partially Reject";	
				} else {
					action = "Trade Partially Reject";
				}
				break;
			case "PW":
				if ("<%= langCd %>" == "en_US") {
					action = "Price Warning";	
				} else {
					action = "Price Warning";
				}
				break;
			case "RA":
				if ("<%= langCd %>" == "en_US") {
					action = "Request Allocation";	
				} else {
					action = "Request Allocation";
				}
				break;
			case "RB":
				if ("<%= langCd %>" == "en_US") {
					action = "Resubmit for price chasing";	
				} else {
					action = "Resubmit for price chasing";
				}
				break;
			case "RD":
				if ("<%= langCd %>" == "en_US") {
					action = "Reduce Order";	
				} else {
					action = "Reduce Order";
				}
				break;
			case "RJ":
				if ("<%= langCd %>" == "en_US") {
					action = "Host Reject";	
				} else {
					action = "Host Reject";
				}
				break;
			case "RM":
				if ("<%= langCd %>" == "en_US") {
					action = "Reject Modify (Local Modify)";	
				} else {
					action = "Reject Modify (Local Modify)";
				}
				break;
			case "RR":
				if ("<%= langCd %>" == "en_US") {
					action = "Reject Resubmit (Market Close)";	
				} else {
					action = "Reject Resubmit (Market Close)";
				}
				break;
			case "SD":
				if ("<%= langCd %>" == "en_US") {
					action = "Split C.D. Order";	
				} else {
					action = "Split C.D. Order";
				}
				break;
			case "SS":
				if ("<%= langCd %>" == "en_US") {
					action = "Send";	
				} else {
					action = "Send";
				}
				break;
			case "ST":
				if ("<%= langCd %>" == "en_US") {
					action = "Submit Stop Order";	
				} else {
					action = "Submit Stop Order";
				}
				break;
			case "SX":
				if ("<%= langCd %>" == "en_US") {
					action = "Undo Send by Manual Reporting";	
				} else {
					action = "Undo Send by Manual Reporting";
				}
				break;
			case "TB":
				if ("<%= langCd %>" == "en_US") {
					action = "User Manually Unfill Executed Trade";	
				} else {
					action = "User Manually Unfill Executed Trade";
				}
				break;
			case "TM":
				if ("<%= langCd %>" == "en_US") {
					action = "Trade Modify";	
				} else {
					action = "Trade Modify";
				}
				break;
			case "TR":
				if ("<%= langCd %>" == "en_US") {
					action = "Trade Reject";	
				} else {
					action = "Trade Reject";
				}
				break;
			case "TS":
				if ("<%= langCd %>" == "en_US") {
					action = "Trigger Send";	
				} else {
					action = "Trigger Send";
				}
				break;
			case "UC":
				if ("<%= langCd %>" == "en_US") {
					action = "Unsolicited Cancel";	
				} else {
					action = "Unsolicited Cancel";
				}
				break;
			}
			return action;
		}

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
				case "CDE":
					if ("<%= langCd %>" == "en_US") {
						stus = "C.D. Order (Expire)";
					} else {
						stus = "C.D Hết hiệu lực";
					}
					break;
				case "CDF":
					if ("<%= langCd %>" == "en_US") {
						stus = "C.D. Order (Fully Filled)";
					} else {
						stus = "C.D Khớp toàn bộ";
					}
					break;
				case "CDO":
					if ("<%= langCd %>" == "en_US") {
						stus = "C.D. Order";
					} else {
						stus = "C.D";
					}
					break;
				case "CDP":
					if ("<%= langCd %>" == "en_US") {
						stus = "C.D. Order (Pending Mod/Can)";
					} else {
						stus = "C.D chờ Hủy/Sửa";
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
					stus = "Undefined";
					break;
			}
		return stus;
		}
		
		function oderBuySellVal(buysell){
			var bs = "";
 			if (buysell == "B") {
				if ("<%= langCd %>" == "en_US") {
					bs = "Buy";	
				} else {
					bs = "Mua";
				}		    				
			} else {
				if ("<%= langCd %>" == "en_US") {
					bs = "Sell";	
				} else {
					bs = "Bán";
				}		    				
			}
 			return bs;
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
			}
		}
		
		function executeSignOrder() {
			if ($('.case:checked').length < 1) {
				if ("<%= langCd %>" == "en_US") {
					alert("Please select order.");
				} else {
					alert("Vui lòng chọn lệnh.");
				}
				return;
			} else {
				//authCheck();
				if ("<%= authenMethod %>" != "matrix") {
					signOrderCheckOTP();
				} else {
					authCheckSignOrder();
				}
			}			
		}
		
		function authCheckSignOrder() {
			var param = {
					divId   : "divIdAuthSignOrder",
					divType : "submitInOnlineSignOrder"
			}

			$.ajax({
				type     : "POST",
				url      : "/common/popup/authConfirm.do",
				data     : param,
				dataType : "html",
				success  : function(data){
					$("#divIdAuthSignOrder").fadeIn();
					$("#divIdAuthSignOrder").html(data);
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		function submitOnlineSignOrder() {			
			var listData = [];			
			var listSignOrder = [];
		    $('#onlineOrderTbl tr td :checkbox:checked').map(function () {
		       listData.push(dataList[$(this).val()]);
		    });
		    
		    var strParam = [];
			for (var i = 0; i < listData.length; i++) {
				var dataObject = [listData[i].mvOrderID, listData[i].mvIsHistory, listData[i].mvRefID];
				strParam.push(dataObject);
			}
		    
		    $("#tab6").block({message: "<span>LOADING...</span>"});
			var param = {
					mvSubAccountID	: "<%= session.getAttribute("subAccountID") %>",
					mvOrderList      : JSON.stringify(strParam)
			};
			
			//console.log("PARAM");
			//console.log(param);

			$.ajax({
				dataType  : "json",
				url       : "/online/data/submitSignOrder.do",
				asyc      : true,
				data      : param,
				success   : function(data) {
					if (data.jsonObj.mvSuccess == "true") {
						if ("<%= langCd %>" == "en_US") {
							alert("Successful.");
						} else {
							alert("Thành công.");
						}
						$("#page").val(1);
						getOnlineSignOrderList();
						$("#checkAll").prop("checked", false);
					} else if (data.jsonObj.mvSuccess == "false") {
						if ("<%= langCd %>" == "en_US") {
							alert("Failed.");
						} else {
							alert("Thất bại.");
						}
						$("#tab6").unblock();
					}										
				},
				error     :function(e) {					
					console.log(e);
					$("#tab6").unblock();
				}
			});
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
		 	getOnlineSignOrderList();
		 	$("#checkAll").prop("checked", false);
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
			$("#downloadLink").prop("download", "Online Sign Order.xls");
			$("#downloadLink").click(function() {
				ExcellentExport.excel(this, "onlineSignOrder", "datalist");
			});
			$("#downloadLink")[0].click();
		}
		
		function signOrderCheckOTP() {
			var param = {
					mvUserID 		: '<%=session.getAttribute("ClientV")%>'
				};
			$.ajax({
				url      : "/trading/data/mCheckOTP.do",
				contentType	:	"application/json; charset=utf-8",
				data     : param,
				dataType : "json",
				success  : function(data) {
					console.log("Check OTP");
					console.log(data);
					if (data.otpResponseCheck.result != "0") {
						authOtpCheck();
					} else {
						submitOnlineSignOrder();
					}
				}
			});	
		}
				
		function authOtpCheck() {
			var param = {
					divId               : "divIdOTPSignOrder",
					divType             : "submitInOnlineSignOrder"
			};

			$.ajax({
				type     : "POST",
				url      : "/common/popup/otpConfirm.do",
				data     : param,
				dataType : "html",
				success  : function(data){
					$("#divIdOTPSignOrder").fadeIn();
					$("#divIdOTPSignOrder").html(data);
				},
				error     :function(e) {					
					console.log(e);
				}
			});
		}
		function stockUpperStr(){
			// 대문자 변환 & 문자 길이 3 이하로 설정
			$("#mvInstrumentID").val(xoa_dau($("#mvInstrumentID").val().substr(0,3).toUpperCase()));
		}
</script>
</head>
<div class="tab_content account">
 	<input id="page" name="page" type="hidden" value="1"/>

<!-- Order History -->
	<div role="tabpanel" class="tab_pane" id="tab6">
		<div class="search_area in">
			<button class="btn" type="button" onclick="executeSignOrder();"><%= (langCd.equals("en_US") ? "Execute" : "Thực hiện") %></button>
			
			<label for="type"><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></label>
			<span>
				<select name="mvMarketID" id="mvMarketID">
					<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
					<option value="HO">HSX</option>
					<option value="HA">HNX</option>
					<option value="UPCOM">UPCOM</option>
				</select>
			</span>
			
			<label for="type"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></label>
			<span>
				<input name="mvInstrumentID" id="mvInstrumentID" type="text" style="width:80px;" onkeyup="stockUpperStr();">
			</span>
			
			<label for="type"><%= (langCd.equals("en_US") ? "Order type" : "Loại lệnh") %></label>
			<span>
				<select name="mvOrderType" id="mvOrderType">
					<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
					<option value="L"><%= (langCd.equals("en_US") ? "Normal" : "Thường") %></option>
					<option value="O"><%= (langCd.equals("en_US") ? "ATO" : "ATO") %></option>
					<option value="C"><%= (langCd.equals("en_US") ? "ATC" : "ATC") %></option>
					<option value="P"><%= (langCd.equals("en_US") ? "Put through" : "Thỏa thuận") %></option>
					<option value="M"><%= (langCd.equals("en_US") ? "MP" : "Thị trường") %></option>
					<option value="B"><%= (langCd.equals("en_US") ? "MOK" : "MOK") %></option>
					<option value="Z"><%= (langCd.equals("en_US") ? "MAK" : "MAK") %></option>
					<option value="R"><%= (langCd.equals("en_US") ? "MTL" : "MTL") %></option>
				</select>
			</span>

			<label for="type"><%= (langCd.equals("en_US") ? "Sell/Buy" : "Bán/Mua") %></label>
			<span>
				<select name="mvBS" id="mvBS">
					<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
					<option value="S"><%= (langCd.equals("en_US") ? "Sell" : "Bán") %></option>
					<option value="B"><%= (langCd.equals("en_US") ? "Buy" : "Mua") %></option>
				</select>
			</span>
			
			<label for="fromSearch"><%= (langCd.equals("en_US") ? "From" : "") %></label>
			<input id="fromSearch" type="text" class="datepicker" value="${serverTime}"/>

			<label for="toSearch"><%= (langCd.equals("en_US") ? "To" : "") %></label>
			<input id="toSearch" type="text" class="datepicker" value="${serverTime}"/>

			<button class="btn" type="button" onclick="getOnlineSignOrderList();"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
			<button type="button" class="btn_down" title="Download" onclick="donwload();">download</button>
			<a style="display:none;" href="#" id="downloadLink" download="#"></a>
		</div>

		<div class="group_table" id="onlineSignOrder">
			<table class="table no_bbt" id="onlineOrderTbl">
				<caption class="hidden">Online Order List Table</caption>
				<colgroup>
					<col />					
					<col width="10%"/>
					<col />
					<col width="10%"/>
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col width="10%"/>
					<col />					
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" value="None" id="checkAll" name="check"/></th>						
						<th scope="col"><%= (langCd.equals("en_US") ? "Action" : "Loại") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order ID" : "Mã lệnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Date" : "Ngày GD") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Market" : "Sàn") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Buy/Sell" : "Mua/Bán") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Order type" : "Loại lệnh") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Ord.Volume" : "K.Lượng đặt") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Ord.Price" : "Giá đặt") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
						<th scope="col"><%= (langCd.equals("en_US") ? "Matched volume" : "K.Lượng khớp") %></th>
						<!--  
						<th scope="col"><%= (langCd.equals("en_US") ? "Matched value" : "Giá trị khớp") %></th>
						-->
						<th scope="col"><%= (langCd.equals("en_US") ? "Cancel volume" : "K.Lượng hủy") %></th>
					</tr>
				</thead>
				<tbody id="trOnlineSignOrder">
				</tbody>
			</table>
		</div>

		<div class="pagination">
		</div>
	</div>
	<!-- // Order History -->
</div>
</HTML>