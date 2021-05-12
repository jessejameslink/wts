<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");	
	String sub = (String) session.getAttribute("subAccountID");
%>

<HTML>
<head>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	//var strBankID = "";
	var subOrderJo		=	"<%=sub%>";
	$(document).ready(function() {
		$('#orderTbl').floatThead('destroy');
		$("#divCancelModifyPop").hide();
		$("#divRejectReasonDetailPop").hide();
		
		
		//getBankInformationJ();			
		
		enquiryorder("ALL", "", "", "", sub);
		$('#orderTbl').floatThead({
		    position: 'relative',
		    zIndex: function($table){
		        return 0;
		    },
		    scrollContainer: true
		    //, autoReflow:true
		});
		
		//Multi cancel function
		$('#checkAll').click(function() {
	        if (!$(this).is(':checked')) {
	        	$('.case').prop('checked', false);
	        	$('#multiCancel').prop('disabled', true);
	        	$('#multiCancel').removeClass('btn');
	        } else {
	        	$('.case').prop('checked', true);
	        	//console.log($('.case:checked').length);
	        	if ($('.case:checked').length <= 1) {
					$('#multiCancel').prop('disabled', true);
					$('#multiCancel').removeClass('btn');
				} else {
					$('#multiCancel').prop('disabled', false);
					$('#multiCancel').addClass('btn');
				}
	        }
	    });

		$('body').on('change','#orderTbl input[type="checkbox"]',function(){
			//console.log($('.case').length);
			//console.log($('.case:checked').length);
			if($('.case').length == $('.case:checked').length) {
                $("#checkAll").prop("checked", true);
            } else {
                $("#checkAll").prop("checked", false);
            }
			if ($('.case:checked').length <= 1) {
				$('#multiCancel').prop('disabled', true);
				$('#multiCancel').removeClass('btn');
			} else {
				$('#multiCancel').prop('disabled', false);
				$('#multiCancel').addClass('btn');
			}
		});
	});
	
	function getBankInformationJ() {
		$("#tab21").block({message: "<span>LOADING...</span>"});
		$.ajax({
			dataType  : "json",
			cache: false,
			url       : "/trading/data/genenterorder.do",
			asyc      : true,
			success   : function(data) {
				//console.log("GET RESULT ENTER ORDER");
				//console.log(data);
				if(data.jsonObj != null) {
					for(var i = 0; i < data.jsonObj.mvSettlementAccList.length; i++) {
						var obj	=	data.jsonObj.mvSettlementAccList[i];
						if(obj.mvBankID != "" ) {							
							strBankID = obj.mvBankID;
						}
					}
					enquiryorder("ALL", "", "", "", sub);
				}
				$("#tab21").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab21").unblock();
			}
		});
	}

	var dataList = {};

	function multiCancelOrder() {
		//alert("multiCancelOrder Click");
		var listData = [];
	    $('#orderTbl tr td :checkbox:checked').map(function () {
	       listData.push(dataList[$(this).val()]);
	    });
	    $("#multiDataList").val(JSON.stringify(listData));
		$.ajax({
			type     : "POST",
			url      : "/trading/popup/multiCancelConfirm.do",
			cache: false,
			data     : $("#frmCancelModifyOrder").serialize(),
			dataType : "html",
			success  : function(data){
				$("#divMultiCancelPop").fadeIn();
				$("#divMultiCancelPop").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function showAccountSummary() {
		//alert("multiCancelOrder Click");
		var param = {
					divId   	: "divAccountSummaryPop"
			}
		$.ajax({
			type     : "POST",
			url      : "/trading/popup/accountSummary.do",
			data	 : param,
			cache: false,
			dataType : "html",
			success  : function(data){
				$("#divAccountSummaryPop").fadeIn();
				$("#divAccountSummaryPop").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function ttlOrderChk() {
		$.ajax({
			url:'/ttl/ttlcomet.do',
			cache: false,
			data:{chk:"ordercheck"},
			dataType: 'json',
			success: function(data){},
			error:function(e){}
		});
	}
	
	function enquiryorder(status, orderType, orderBS, stockID, sub) {
		$("#tab21").block({message: "<span>LOADING...</span>"});
		sub = $("#ojSubAccount option:selected").text();
		
		var param = {
				 mvStatus 		:	status
				,mvOrderType	:	orderType
				,mvOrderBS		: 	orderBS
				,mvStockID		:	stockID
				,mvSubAccountID	: 	subOrderJo
				
		};
		//console.log("111111111111111");
		//console.log(subOrderJo);
		var strList = "";
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/enquiryorder.do",
			cache: false,
			data      : param,
			success   : function(data) {
			 	
				//console.log("ORDER JOURNAL DATA CHECK-=---->");
				//console.log(data);
			 	// 옵션 초기화 - 전체 삭제
			 	//$("#ojSel1 option").remove();

			 	// ComboBox List 세팅
			 	// - ## mvOrderStatusList 값이 1개만 리턴되면  ORDERSTATUS_OPTION_DISPLAY_ORDERSTATUS_OPTION_LIST
			 	// 라는 값이 출력됨
		 		
			 	//if(data != null && data.jsonObj.mvOrderStatusList != null && data.jsonObj.mvOrderStatusList.length > 1){
			 	//TODO : 에러로 인해 임시 변경함.
			 	if(data.jsonObj != null && data.jsonObj.mvOrderStatusList != null && data.jsonObj.mvOrderStatusList.length > 1){
		 			var i = 0;
		 			$("#ojSel1 option").remove();
		 			while(data.jsonObj.mvOrderStatusList.length>i){
		 				if(data.jsonObj.mvOrderStatusList[i].mvOptionValue != "NONE") {
		 					$("#ojSel1").append("<option value='" + data.jsonObj.mvOrderStatusList[i].mvOptionValue + "'>"+ data.jsonObj.mvOrderStatusList[i].mvOptionDisplay + "</option>");
		 				}
		 				i++;
		 			}
		 			$("#ojSel1").val(status);
		 		}

		 		// TotalFeeTax 값 세팅
		 		if(data.jsonObj.mvTotalTaxFee != null){
		 			//$("#totalFeeTax").html(data.mvTotalTaxFee);
		 			$("#totalFeeTax").html("<%= (langCd.equals("en_US") ? "Total (Fee + Tax) : " : "Tổng (Phí+Thuê) : ") %>" + numDotCommaFormat(data.jsonObj.mvTotalTaxFee.replace(/[,]/g, "")));
		 		} else {
		 			$("#totalFeeTax").html("<%= (langCd.equals("en_US") ? "Total (Fee + Tax) : 0" : "Tổng (Phí+Thuê) : 0") %>");
		 		}
			 	//	@TODO : TEMP LOGIC
			 	if(data.jsonObj.mvOrderBeanList != null && data.jsonObj.mvOrderBeanList.length != 0){

			 		dataList = data.jsonObj.mvOrderBeanList;

			 		for(var i = 0; i<dataList.length; i++){
			 			var className = "";

			 			(i%2 != 0) ? className = "even" : "";
			 			strList += "<tr class='"+className+" id='"+dataList[i].mvOrderID+"'>"
			 			+ "<td>";
			 			if (dataList[i].mvUserID != "PHUONG.TH" && dataList[i].mvUserID != "LIEN.NT" && dataList[i].mvUserID != "VU.TQ" && dataList[i].mvUserID != "THUY.DTB") {
				 			if(dataList[i].cancelable){
				 				strList += "<input type='checkbox' class='case' name='case' value='"+i+"'/>";			 			
				 			}
			 			}
			 			strList += "</td>"
			 			+ "<td>";
			 			
			 			if (dataList[i].mvUserID != "PHUONG.TH" && dataList[i].mvUserID != "LIEN.NT" && dataList[i].mvUserID != "VU.TQ" && dataList[i].mvUserID != "THUY.DTB") {
				 			if(dataList[i].cancelable){			 				
				 				strList += "<div><button class='btn_s' type='button' onclick='orderListCancelModify("+i+", \"cancel\");'><img src='<%= (langCd.equals("en_US") ? "/resources/images/btn_s_cancel.png" : "/resources/images/btn_s_huy.png") %>' alt='<%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %>'></button></div>";
				 			}			 			
				 			if(dataList[i].modifiable){			 			
				 				strList += "<div><button class='btn_s' type='button' onclick='orderListCancelModify("+i+", \"modify\");'><img src='<%= (langCd.equals("en_US") ? "/resources/images/btn_s_modify.png" : "/resources/images/btn_s_sua.png") %>' alt='<%= (langCd.equals("en_US") ? "Modify" : "Sửa") %>'></button></div>";
				 			}
			 			}
			 			
			 			var ord_tp	=	"";
			 			if(dataList[i].mvOrderType == "L") {
			 				ord_tp	=	"<%= (langCd.equals("en_US") ? "Normal" : "Thường") %>";
			 			} else if(dataList[i].mvOrderType == "C") {
			 				ord_tp	=	"ATC";
			 			} else if(dataList[i].mvOrderType == "O") {
			 				ord_tp	=	"ATO";
			 			} else if(dataList[i].mvOrderType == "PT") {
			 				ord_tp	=	"<%= (langCd.equals("en_US") ? "Put through" : "Thỏa thuận") %>";
			 			}else if(dataList[i].mvOrderType == "P") {
			 				ord_tp	=	"<%= (langCd.equals("en_US") ? "Stop" : "Lệnh dừng") %>";
			 			} else if(dataList[i].mvOrderType == "M") {
			 				ord_tp	=	"<%= (langCd.equals("en_US") ? "MP" : "Thị trường") %>";
			 			} else if(dataList[i].mvOrderType == "F") {
			 				ord_tp	=	"<%= (langCd.equals("en_US") ? "Odd Lot" : "Lô lẻ") %>";
			 			} else if(dataList[i].mvOrderType == "J") {
			 				ord_tp	=	"PLO";
			 			} else if(dataList[i].mvOrderType == "B") {
			 				ord_tp	=	"MOK";
			 			} else if(dataList[i].mvOrderType == "Z") {
			 				ord_tp	=	"MAK";
			 			} else if(dataList[i].mvOrderType == "R") {
			 				ord_tp	=	"MTL";
			 			} else {
			 				ord_tp	=	dataList[i].mvOrderType;
			 			}
			 			var bs = "";
			 			if (dataList[i].mvBS == "B") {
		    				
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
			 			
			 			var detail = "";
			 			if ("<%= langCd %>" == "en_US") {
			 				detail = "<td class=\"text_center\">" + "<button type=\"button\" class=\"btn\" onclick=\"viewOrderDetail('" + i + "')\">View</button>" + "</td>";
		    			} else {
		    				detail = "<td class=\"text_center\">" + "<button type=\"button\" class=\"btn\" onclick=\"viewOrderDetail('" + i + "')\">Xem</button>" + "</td>";
		    			}
			 			
			 			strList += "</td>"			 				
							+ "<td style=\"cursor: pointer;\" onclick=\"Ext_SetOrderStock('" + dataList[i].mvStockID + "');\">" 		+ dataList[i].mvStockID 	+ "</td>"
							+ detail
							+ "<td><div>" 	+ bs			+ "</div>"
							+ "<div>" 		+ (ord_tp == "PLO" ? "PLO" : numDotCommaFormat(dataList[i].mvPrice.replace(/[,]/g, ""))) + "</div></td>"
							+ "<td><div>" 	+ dataList[i].mvQty 		+ "</div>"					// vol - 불확실
							//+ "<div>"		+ dataList[i].mvPendingQty 	+ "</div></td>"	// Oebdubg vol - 불확실
							+ "<div>"		+ dataList[i].mvOSQty 	+ "</div></td>"	
							+ "<td><div>" 	+ dataList[i].mvFilledQty 	+ "</div>"				// Executed Vol. - 불확실
							+ "<div>" 		+ numDotCommaFormat(dataList[i].mvAvgPrice.replace(/[,]/g, "")) 	+ "</div></td>"			// Avg Price.
							+ "<td>"		+ statusChange(dataList[i].mvStatus) 		+ "</td>"				// Status
							+ "<td><div>"	+ ord_tp 	+ "</div>"				// Type
							+ "<div>"
							+ numDotCommaFormat(dataList[i].mvBS == "B" ? dataList[i].mvNetAmt - dataList[i].mvGrossAmt : dataList[i].mvGrossAmt - dataList[i].mvNetAmt)
							+ "</div></td>"								// Fee + Tax - 산출식 ?
							+ "<td><div>"	+ (dataList[i].mvStopOrder == true ? getStopType(dataList[i].mvStopOrderType) : "") 	+ "</div>"				// Stop Type
							+ "<div>"
							+ (dataList[i].mvStopOrder == true ? numDotCommaFormat(dataList[i].mvStopPrice.replace(/[,]/g, "")) : "")
							+ "</div></td>"								// Stop Price
							+ "<td><div>"	+ (dataList[i].mvRejectReason?("<a href=\"javascript:openRejectReasonDetailPop('" + rejectReasonDetail(dataList[i].mvRejectReason) + "');\">" + "<%= (langCd.equals("en_US") ? "Reject Reason" : "Lý do từ chối") %>" + "</a>"):"-") + "</div>"	// Reject Reason

							/* + "<div>" 	+ dataList[i].mvInputTime +"</div></td>" 	//  mvInputTime or mvModifiedTime */
							+ "<div>" 	+ dataList[i].mvModifiedTime +"</div></td>" 	//  mvInputTime or mvModifiedTime
							+ "</tr>";
			 		}

			 	}else{
					if (data.jsonObj.mvMessage == "undefined" || data.jsonObj.mvMessage === undefined){
						if ("<%= langCd %>" == "en_US") {
							strList += "<tr><td colspan='11'>" + "No Record Found!"	+ "</td></tr>";							
						} else {
							strList += "<tr><td colspan='11'>" +  "Không tìm thấy dữ liệu!" + "</td></tr>";	
						}
					}else{
						strList += "<tr><td colspan='11'>" + data.jsonObj.mvMessage + "</td></tr>";
					}
				}
				// 리스트 세팅
				
		 		$("#orderList").html(strList);
		 		$("#downloadOrderList").html(strList);
		 		$('#orderTbl').floatThead('reflow');
		 		$("#tab21").unblock();
		 		//ttlOrderChk();
		    },
			error     :function(e) {
				console.log(e);
				$("#tab21").unblock();
			}

		});
	}
	
	function rejectReasonDetail(detail) {
		if ("<%= langCd %>" == "vi_VN") {
			if (detail.indexOf("Non-trading") >= 0) {
				detail = "Hết giờ giao dịch";
			} else if (detail.indexOf("Order price") >= 0) {
				var tmp = detail.substring(detail.indexOf("("), detail.indexOf(")") + 1).replace("to", "đến");
				detail = "Giá nằm ngoài biên độ " + tmp + ", vui lòng nhập lại.";
			} else if (detail.indexOf("Margin Limit") >= 0) {
				detail = "Ký quỹ vượt quá giới hạn. Vui lòng kiểm tra lại hạn mức.";
			}
		}		
		return detail;
	}
	
	function viewOrderDetail(i) {
		//console.log(dataList[i].mvOrderGroupID);
		
		$("#mvGroupOrderID").val(dataList[i].mvOrderGroupID);
		$.ajax({
			type : "POST",
			url : "/trading/popup/viewOrderDetail.do",
			data : $("#frmOrderDetail").serialize(),
			dataType : "html",
			success : function(data) {
				$("#divOrderDetailPop").fadeIn();
				$("#divOrderDetailPop").html(data);
			},
			error : function(e) {
				console.log(e);
			}
		});
	}
	
	function getStopType(type) {
		switch(type){
		case "U":
			type = "Up";
			break;
		case "D":
			type = "Down";
			break;
		}
		return type;
	}

	function statusChange(stus){
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

	function stockUpperStr(){
		// 대문자 변환 & 문자 길이 3 이하로 설정
		$("#stockInp").val(xoa_dau($("#stockInp").val().substr(0,3).toUpperCase()));
	}

	function searchOrder(e){
		if( (e != null && e.keyCode == 13) || (e == null) ) {
			if($("#stockInp").val().length < 3 && $("#stockInp").val().length > 0){
				if ("<%= langCd %>" == "en_US") {
					alert("length is 1 or 2");	
				} else {
					alert("chiều dài là 1 hoặc 2");
				}
			} else {
				if($("#stockInp").val().length > 0){
					enquiryorder($("#ojSel1").val(), $("#ojSel2").val(), $("#ojSel3").val(),$("#stockInp").val());
				} else if( $("#stockInp").val().length <= 0) {
					enquiryorder($("#ojSel1").val(), $("#ojSel2").val(), $("#ojSel3").val(), "");
				}
			}
		}
	}

	function orderListCancelModify(i, actionNm){
		//console.log("DATA LIST CHECK==>");
		//console.log(dataList[i]);
		$("#dataList").val(JSON.stringify(dataList[i]));
		$("#cancelModify").val(actionNm);

		$.ajax({
			type     : "POST",
			url      : "/trading/popup/cancelModifyConfirm.do",
			cache: false,
			data     : $("#frmCancelModifyOrder").serialize(),
			dataType : "html",
			success  : function(data){
				$("#divCancelModifyPop").fadeIn();
				$("#divCancelModifyPop").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});

	}

	function openRejectReasonDetailPop(msg){
		$("#rejectReasonMsg").html(msg);
		$("#divRejectReasonDetailPop").fadeIn();
	}

	function closeRejectReasonDetailPop(){
		$("#divRejectReasonDetailPop").fadeOut();
	}
	
	function donwload() {
		$("#downloadLink").prop("download", "Order Journal.xls");
		$("#downloadLink").click(function() {
			ExcellentExport.excel(this, "downloadOrderTbl", "datalist");
		});
		$("#downloadLink")[0].click();
	}
</script>
</head>
	<div class="tab_content">
		<div role="tabpanel" class="tab_pane" id="tab21">
			<!-- Order Journal -->
			<form id="frmOrderDetail" autocomplete="Off">
				<input type="hidden" id="mvGroupOrderID" name="mvGroupOrderID" value="">
			</form>
			<form id="frmCancelModifyOrder" action="" onsubmit="return false;" onkeyup="searchOrder(event);" method="POST">
				<div class="search_area in total">
					<input type="hidden" id="dataList" name="dataList" value="">
					<input type="hidden" id="multiDataList" name="multiDataList" value="">
					<input type="hidden" id="cancelModify" name="cancelModify" value="">
					<input type="hidden" id="divIdCM" name="divIdCM" value="divCancelModifyPop">
					<input type="hidden" id="divIdMulti" name="divIdMulti" value="divMultiCancelPop">
					<button type="button" class="btn_down" title="Download" onclick="donwload();">download</button>
					<a style="display:none;" href="#" id="downloadLink" download="#"></a>

					<div class="pull_left">
						<label for="ojSel1"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></label>
						<select id="ojSel1" onchange="searchOrder();">
							<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "ALL") %></option>
							<option value="FULLYFILLED"><%= (langCd.equals("en_US") ? "Fully Executed" : "Khớp toàn bộ") %></option>
							<option value="QUEUE"><%= (langCd.equals("en_US") ? "Queued" : "Chờ khớp") %></option>
							<option value="PARTIALLYFILL"><%= (langCd.equals("en_US") ? "Partially Filled" : "Khớp một phần") %></option>
							<option value="REJECTED"><%= (langCd.equals("en_US") ? "Rejected" : "Không hợp lệ") %></option>
							<option value="CANCELLED"><%= (langCd.equals("en_US") ? "Cancelled" : "Đã huỷ") %></option>
							<option value="READYTOSEND"><%= (langCd.equals("en_US") ? "New" : "Chờ xử lý") %></option>
							<option value="SENDING"><%= (langCd.equals("en_US") ? "Sending" : "Đang gửi") %></option>
							<option value="PENDINGAPPROVAL"><%= (langCd.equals("en_US") ? "Waiting" : "Chờ xác nhận") %></option>
							<option value="STOP"><%= (langCd.equals("en_US") ? "Trigger Order" : "Lệnh điều kiện") %></option>
							<option value="WAITINGCANCEL"><%= (langCd.equals("en_US") ? "Waiting Cancel" : "Chờ huỷ") %></option>
							<option value="WAITINGMODIFY"><%= (langCd.equals("en_US") ? "Waiting Modify" : "Chờ sửa") %></option>
							<option value="INACTIVE"><%= (langCd.equals("en_US") ? "Inactive" : "Không hiệu lực") %></option>
							<option value="EXPIRED"><%= (langCd.equals("en_US") ? "Expired" : "Hết hiệu lực") %></option>
						</select>
						<label for="ojSel2"><%= (langCd.equals("en_US") ? "Type" : "Loại lệnh") %></label>
						<select id="ojSel2" onchange="searchOrder();">
							<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
							<option value="L"><%= (langCd.equals("en_US") ? "Normal" : "Thường") %></option>
							<option value="O">ATO</option>
							<option value="C">ATC</option>
							<option value="P"><%= (langCd.equals("en_US") ? "Put through" : "Thỏa thuận") %></option>
							<option value="M"><%= (langCd.equals("en_US") ? "MP" : "Thị trường") %></option>
							<option value="J">PLO</option>
							<option value="B">MOK</option>
							<option value="Z">MAK</option>
							<option value="R">MTL</option>
						</select>
						<label for="ojSel3"><%= (langCd.equals("en_US") ? "Buy/Sell" : "Mua/Bán") %></label>
						<select id="ojSel3" onchange="searchOrder();">
							<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
							<option value="B"><%= (langCd.equals("en_US") ? "Buy" : "Mua") %></option>
							<option value="S"><%= (langCd.equals("en_US") ? "Sell" : "Bán") %></option>
						</select>
						<button type="button" id="multiCancel" disabled="disabled" style="margin-left:10px;" onclick="multiCancelOrder();"><%= (langCd.equals("en_US") ? "Multi Cancel" : "Hủy nhiều lệnh") %></button>
						<button type="button" style="margin-left:10px;" onclick="showAccountSummary();" class="btn"><%= (langCd.equals("en_US") ? "Show Account Summary" : "Tổng quan tài khoản") %></button>
					</div>
					<div class="pull_right">
						<label for="stockInp"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></label>
						<div class="input_search">
							<input id="stockInp" type="text" style="width:100px;" onkeyup="stockUpperStr();">
							<button type="button" onclick="searchOrder();"><%= (langCd.equals("en_US") ? "Search" : "Tra cứu") %></button>
						</div>

					</div>
				</div>
				<div class="grid_area oj_grid" style="height:370px;z-index:0;">
					<div class="group_table center double">
						<table class="table" id="orderTbl">
							<thead>
								<tr>
									<th rowspan="2"><input type="checkbox" value="None" id="checkAll" name="check"/></th>
									<th><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></th>
									<th rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
									<th rowspan="2"><%= (langCd.equals("en_US") ? "Order Detail" : "Chi tiết lệnh") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Buy/Sell" : "Mua/Bán") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Vol" : "Số lượng") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Executed Vol." : "Số lượng khớp") %></th>
									<th rowspan="2"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Order Type" : "Loại lệnh") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Stop Type" : "Loại lệnh dừng") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Reject Reason" : "Lý do từ chối") %></th>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Modify" : "Sửa") %></th>
									<th><%= (langCd.equals("en_US") ? "Price (VND)" : "Giá (VND)") %></th>
									<th><%= (langCd.equals("en_US") ? "Pending Vol." : "S.L chờ khớp") %></th>
									<th><%= (langCd.equals("en_US") ? "Avg Price." : "Giá TB") %></th>
									<th><%= (langCd.equals("en_US") ? "Fee + Tax" : "Phí+Thuế") %></th>
									<th><%= (langCd.equals("en_US") ? "Stop Price" : "Giá dừng") %></th>
									<th><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
								</tr>
							</thead>
							<tbody id="orderList"></tbody>
						</table>
					</div>
					
					<!-- Hidden table to download -->
					<div class="group_table center double" style="display:none;" id="downloadOrderTbl">
						<table class="table">
							<thead>
								<tr>
									<th rowspan="2"><input type="checkbox" value="None" id="checkAll" name="check"/></th>
									<th><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></th>
									<th rowspan="2"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
									<th rowspan="2"><%= (langCd.equals("en_US") ? "Order Detail" : "Chi tiết lệnh") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Buy/Sell" : "Mua/Bán") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Vol" : "Số lượng") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Executed Vol." : "Số lượng khớp") %></th>
									<th rowspan="2"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Order Type" : "Loại lệnh") %></th>
									<th class="bd_bt2"><%= (langCd.equals("en_US") ? "Reject Reason" : "Lý do từ chối") %></th>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Modify" : "Sửa") %></th>
									<th><%= (langCd.equals("en_US") ? "Price (VND)" : "Giá (VND)") %></th>
									<th><%= (langCd.equals("en_US") ? "Pending Vol." : "S.L chờ khớp") %></th>
									<th><%= (langCd.equals("en_US") ? "Avg Price." : "Giá TB") %></th>
									<th><%= (langCd.equals("en_US") ? "Fee + Tax" : "Phí+Thuế") %></th>
									<th><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
								</tr>
							</thead>
							<tbody id="downloadOrderList"></tbody>
						</table>
					</div>
					<!-- End -->
				</div>

				<div id="totalFeeTax" class="order_total">
					<%= (langCd.equals("en_US") ? "Total (Fee + Tax)" : "Tổng (Phí+Thuê)") %> :<span> 0</span>					
				</div>				
			</form>
			<!-- //Order Journal -->
		</div>
	</div>

	<div id="divCancelModifyPop" class="modal_wrap"></div>
	<div id="divMultiCancelPop" class="modal_wrap"></div>
	<div id="divAccountSummaryPop" class="modal_wrap"></div>
	<div id="divOrderDetailPop" class="modal_wrap"></div>

	<div id="divRejectReasonDetailPop" class="modal_wrap">
		<div class="modal_layer add total">
			<div class="total_wrap">
				<h2><%= (langCd.equals("en_US") ? "Reject Reason Detail" : "Chi tiết lý do từ chối") %></h2>
				<div class="search_area">
					<div class="input_search">
						<label id="rejectReasonMsg"></label>
					</div>
				</div>
			</div>
			<button class="close" type="button" onclick="closeRejectReasonDetailPop()"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
		</div>
	</div>
</HTML>