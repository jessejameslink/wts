<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	var pTranID = "";
	var pStatus = "";
	
	function checkAuthMethod(divGubun, tranID, status) {
		if($("#tab4").find("#ent_stock option:selected").val() == "" || $("#tab4").find("#ent_stock option:selected").val() == undefined) {			
			if ("<%= langCd %>" == "en_US") {
				alert("Please select stock code.");	
			} else {
				alert("Vui lòng chọn mã CK.");
			}
			return;
		}
		
		
		var rqTy	=	$("#rqty").val();
		
		if($("#rqty").val() == "") {
			if ("<%= langCd %>" == "en_US") {
				alert("Register Qty can't empty.");	
			} else {
				alert("Số lượng đăng ký không thể trống.");
			}
			return;
		}

		if($("#rqty").val() < 1) {
			if ("<%= langCd %>" == "en_US") {
				alert("Register Qty is greater than 1.");	
			} else {
				alert("Số lượng đăng ký lớn hơn 1.");
			}

			return;
		}
		
		var cashBalance	=	Number($("#cashBalance").html().replace(/[,.]/g,''));
		var amount	=	Number($("#amount").html().replace(/[,.]/g,''));
		var availableQty	=	Number($("#availableQty").html().replace(/[,.]/g,''));
		var rqty	=	Number($("#rqty").val());
		
		if(cashBalance < 1) {
			if ("<%= langCd %>" == "en_US") {
				alert("Amount don't enough for buying Stock.");	
			} else {
				alert("Số dư tiền mặt không đủ để mua.");
			}
			return;
		}
		if(cashBalance < amount) {
			if ("<%= langCd %>" == "en_US") {
				alert("Buying don't enough money.");	
			} else {
				alert("Số dư tiền mặt nhỏ hơn tiền mua.");
			}
			return;
		}
		if(availableQty < rqty) {
			if ("<%= langCd %>" == "en_US") {
				alert("Sock over volumn.");	
			} else {
				alert("Đăng ký vượt quá số lượng.");
			}
			return;
		}
		
		if ("<%= authenMethod %>" != "matrix") {
			entitlementOnlineCheckOTP();
		} else {
			authCheckEtitlement(divGubun, tranID, status);
		}
	}

	function authCheckEtitlement(divGubun, tranID, status) {
		pTranID = tranID;
		pStatus = status;
		var param = {
				divId               : "divIdAuthEtitlement",
				divType             : divGubun
		};
		$.ajax({
			type     : "POST",
			url      : "/common/popup/authConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdAuthEtitlement").fadeIn();
				$("#divIdAuthEtitlement").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function authCheckOK(divGubun) {
		if(divGubun == "submit") {
			doReg();
		} else if(divGubun == "cancel") {
			doCancel();
		}
	}
	
	function doReg() {
		$("#tab4").block({message: "<span>LOADING...</span>"});
		var dataLst	=	$("#ent_stock > option:selected").val().split("|");
		var	StockId		=	dataLst[0];
		var MarketId	=	dataLst[1];
		var EntitlementId = dataLst[2];
		var LocationId	=	dataLst[3];
		
		var rqTy	=	$("#rqty").val();
		rqTy		=	rqTy.replace(/[,.]/g,'');
		
		var isBank = -1;
		if ($("#backAccountList").val() != "MAS") {
			var bankData = JSON.parse($("#backAccountList").val());
			isBank = bankData.mvInterfaceSeq
		}
		
		var param = {
			mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
			, mvStockId : StockId
			, mvEntitlementId : EntitlementId
			, mvMarketId : MarketId
			, mvLocationId : LocationId
			, mvQuantity : rqTy
			, mvInterfaceSeq : isBank
		};
		
		//console.log("+++++++++PARAM +++++++++++");
		//console.log(param)
		
		$.ajax({
			type     : "POST",
			url      : "/online/data/setRegisterExercise.do",
			data     : param,
			dataType : "json",
			cache	 : false,
			success  : function(data){
				//console.log("++++++setRegisterExercise+++++++");
				//console.log(data);
								
				if(data.jsonObj.mainResult == "FAILED") {
					//FAIL CASE
					alert(data.jsonObj.errorMessage);
				} else {
					//SUCCESS CASE
					//alert(data.jsonObj.message);
					if ("<%= langCd %>" == "en_US") {
						alert("Successful.");
					} else {
						alert("Thành công.");
					}
					clearData();
				}
				getAllRightList();
				getAdditionIssueShareInfo();
				getEntitlementHistory();
				queryBankInfo();
				$("#tab4").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#tab4").unblock();
			}
		});
		
	}
	
	function clearData() {
		$("#availableQty").html("");
		$("#actionPrice").html("");
		$("#regQty").html("");
		$("#amount").html("");
		$("#ent_stock").val($("#ent_stock option:first").val());
	}
	
	function doCancel() {
		alert("test cancel");
	}
	
	
	$(document).ready(function() {
		var d = new Date();
		$(".datepicker").datepicker({
			showOn      : "button",
			dateFormat  : "dd/mm/yy",
			changeYear  : true,
			changeMonth : true
		});
		$(".datepicker").datepicker("setDate", d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear());
		//console.log("<%=authenMethod%>");
		//console.log("<%=saveAuth%>");
		
		var ye = 0 ;
		var mo = 0;
		if((d.getMonth() - 6) < 0){
			ye = 1;
			mo = ((d.getMonth() - 6) + 12);
		}
		$("#mvStartDate1").datepicker("setDate", d.getDate() + "/" + (mo + 1) + "/" + (d.getFullYear() - ye));
		
		getEntitlementStockList();
		queryBankInfo();
		
		getAllRightList();
		getAdditionIssueShareInfo();
		getEntitlementHistory();
		
		
		
	});

	function queryBankInfo(){	
		// 1. 정의 불확실. 값을 알 수 없다.		2. Bank Account 계좌 리스트. -> 업데이트 해준다.
		$("#divEntitlementPlace").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/queryBankInfo.do",
			asyc      : true,
			data      : param,
			cache	  : false,
			success   : function(data){
				//console.log("===Bank info===");
			 	//console.log(data);			 	
				// 옵션 초기화 - 전체 삭제
			 	$("#backAccountList option").remove();
			 	$("#backAccountList").append("<option value='MAS'>MAS</option>");
			 	
				if(data.jsonObj.mvBankInfoList != null) {
					for(var i = 0; i < data.jsonObj.mvBankInfoList.length; i++){
						if (data.jsonObj.mvBankInfoList[i].mvIsDefault == true) {
							$("#backAccountList").append("<option value='" + JSON.stringify(data.jsonObj.mvBankInfoList[i]) + "'>"+ data.jsonObj.mvBankInfoList[i].mvSettlementAccountDisplayName + "</option>");
							$("#backAccountList").val($("#backAccountList option:eq(1)").val());
							$("#backAccountList").prop("disabled", true );
						}						
					}
				}
				$("#divEntitlementPlace").unblock();
				accountBalance("");
			},
			error     :function(e) {
				console.log(e);
				$("#divEntitlementPlace").unblock();
			}
		});
	}

	function accountBalance(bankInfoData) {
		$("#divEntitlementPlace").block({message: "<span>LOADING...</span>"});

		if (bankInfoData == "MAS") {
			bankInfoData = "";
		}
		
		if(bankInfoData != ""){
			var bankData = JSON.parse(bankInfoData);
		}

		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>",
				bankId		: bankInfoData != "" ? bankData.mvBankID : "",
				bankAcId	: bankInfoData != "" ? bankData.mvBankACID : "",
				loadBank	: bankInfoData != "" ? true : false
		};
		
		//console.log(param);

		$.ajax({
			dataType  : "json",
			url       : "/margin/data/accountbalance.do",
			asyc      : true,
			data      : param,
			success   : function(data){
				var cashBalance = 0;
				var cashAvailable = 0;
				var buyingPower = 0;
				
				//console.log("===select bank===");
				//console.log(data);
				
				if(data.jsonObj != null && data.jsonObj.mvList != null && data.jsonObj.mvList.length > 0) {					
					if( data.jsonObj.mvList[0].mvBankId == null || data.jsonObj.mvList[0].mvBankId == ""  ) {
						if(data.jsonObj.mvList[0].mvBankId == null || data.jsonObj.mvList[0].mvBankId == ""){
							cashAvailable = numDotCommaFormat( parseFloat(nullCheck(data.jsonObj.mvList[0].mvWithdrawableAmount).replace(/,/g,'')) );
						}

						if(data.jsonObj.mvList[0].mvAccountType == "M"){
							//cashBalance  = numDotCommaFormat(nullCheck(data.jsonObj.mvList[0].mvManualReserve));
							var withAbleAdvanMargin = (parseFloat(nullCheck(data.jsonObj.mvList[0].mvWithdrawableAmount).replace(/,/g,'')) );
							withAbleAdvanMargin = withAbleAdvanMargin - (parseFloat(nullCheck(data.jsonObj.mvList[0].mvAdvanceableAmount).replace(/,/g,'')) );
							cashBalance = (withAbleAdvanMargin > 0 ? numDotCommaFormat(withAbleAdvanMargin) : 0);
						} else {
							//cashBalance  = numDotCommaFormat(nullCheck(data.jsonObj.mvList[0].mvCSettled));
							
							var withAbleAdvan = (parseFloat(nullCheck(data.jsonObj.mvList[0].mvCSettled).replace(/,/g,'')) );
							withAbleAdvan = withAbleAdvan - (parseFloat(nullCheck(data.jsonObj.mvList[0].mvPendingBuy).replace(/,/g,'')) );
							withAbleAdvan = withAbleAdvan - (parseFloat(nullCheck(data.jsonObj.mvList[0].mvPendingWithdraw).replace(/,/g,'')) );
							withAbleAdvan = withAbleAdvan - (parseFloat(nullCheck(data.jsonObj.mvList[0].mvHoldingAmt).replace(/,/g,'')) );
							
							cashBalance = (withAbleAdvan > 0 ? numDotCommaFormat(withAbleAdvan) : 0);
						}
					} else if(data.jsonObj.mvList[0].mvBankId != "" ) {
						cashBalance  = numDotCommaFormat(nullCheck(data.jsonObj.mvList[0].mvBuyingPowerd).replace(/,/g,''));
						cashAvailable = numDotCommaFormat(nullCheck(data.jsonObj.mvList[0].mvBuyingPowerd).replace(/,/g,''));
					}

					buyingPower =  numDotCommaFormat(data.jsonObj.mvList[0].mvBuyingPowerd.replace(/,/g,''));			// 소수점 에러가 있을 수 있다.

					//$("#cashBalance").html(cashBalance);
					$("#cashBalance").html(numDotCommaFormat(nullCheck(data.jsonObj.mvList[0].mvRemainReserve).replace(/,/g,'')));
					//$("#cashBalance").html(numDotCommaFormat(nullCheck(data.jsonObj.mvList[0].mvCashBalance).replace(/,/g,'')));
					$("#cashAvailable").html(cashAvailable);
					//$("#cashAvailable").html(data.jsonObj.mvList[0].mvAdvanceableAmount).replace(/,/g,''));
					$("#buyingPower").html(buyingPower);
				}
				$("#divEntitlementPlace").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divEntitlementPlace").unblock();
			}
		});
	}

	// Stock Code 선택시 실행(?)
	function getEntitlementData(obj) {
		//console.log("@@@@@@@@@@@@@@@GET ENTITLEMENT DATAT@@@@@@@@@@");
		//console.log(obj);
		var dataLst	=	obj.value.split("|");
		
		
		var	StockId		=	dataLst[0];
		var MarketId	=	dataLst[1];
		var EntitlementId = dataLst[2];
		var LocationId	=	dataLst[3];		
		
		var param = {
				mvStockId			:	StockId
				, mvMarketId		:	MarketId
				, mvEntitlementId	:	EntitlementId
				, mvLocationId		:	LocationId
				, mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType: "json",
			url		: "/online/data/getEntitlementData.do",
			asyc    : true,
			data    : param,
			success : function(data){
				console.log("======getEntitlementData=====");
				console.log(data);
				var dataObj	=	data.jsonObj.stockEntitlementInfo;				
				var abalQty	=	Math.floor(parseInt(dataObj.maxQtyCanBuy.replace(/,/g, "")) * parseFloat(dataObj.perStockRate) / parseFloat(dataObj.perRightRate));
				var actPrice	=	numIntFormat(String(Number(dataObj.price.split(",").join(""))*1000));
				
				$("#availableQty").html(numIntFormat(abalQty));
				$("#actionPrice").html(actPrice);
				$("#regQty").html("<input type='text' id='rqty' name='rqty' onkeyup='chgQty()' onkeypress='isNum();' class='text won'/>");
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function chgQty() {
		//console.log("key up");
		var volumeView = $("#rqty").val().replace(/[,.]/g,'');
		//console.log(volumeView);
		if(volumeView > 0 ) {
			$("#rqty").val(numIntFormat(volumeView));
			var actionPrice	=	$("#actionPrice").html().replace(/[,.]/g,'');
			var amt			=	volumeView * Number(actionPrice);
			amt				=	numIntFormat(String(amt));
			//console.log("MAT--->" + amt);
			$("#amount").html(amt);
		} else if(Number(volumeView) <= 0) {
			$("#rqty").val(0);
			$("#amount").html(0);
		}
	}

	function isNum() {
		//console.log("key press");
		var volumeView = $("#rqty").val().replace(/[,.]/g,'');
		//console.log(volumeView);
		
		var key	=	event.keyCode;
		if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)) {
			event.returnValue	=	false;
		} else {
			if(volumeView == 0) {
				$("#rqty").val("");
			}
		}
	}
	
	
	function getEntitlementStockList() {
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType : "json",
			url      : "/online/data/getEntitlementStockList.do",
			asyc     : true,
			data     : param,
			cache	 : false,
			success  : function(data){				
				//console.log("========getEntitlementStockList=======>");
				//console.log(data);
				
				if(data.jsonObj.stockCmbList != null) {
					if(data.jsonObj.stockCmbList.length > 0){
						stLst	=	data.jsonObj.stockCmbList;
						var inHtml	=	"";
						for(var i = 0; i < stLst.length; i++) {
							inHtml	+=	"<option value=\""+stLst[i].stockId+"|"+ stLst[i].marketId+"|" + stLst[i].entitlementId+"|" + stLst[i].locationId+ "\">"+stLst[i].tradeStockCode+"</option>";
						}						
						$("#ent_stock").append(inHtml);
					}					
				} else {

				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function getAllRightList() {
		$("#divStockCode1").hide();
		$("#divRightList").block({message: "<span>LOADING...</span>"});
		
		var param = {
				mvActionType	: $("#mvActionType").val(),	// Selected ActionType
				mvStockId		: ($("#st_code1").val() == "" ? "ALL" : $("#st_code1").val()),		// Selected StockCode
				mvStartDate		: $("#mvStartDate1").val(),
				mvEndDate		: $("#mvEndDate").val(),
				mvSubAccountID	: "<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url      : "/online/data/getAllRightList.do",
			asyc      : true,
			data     : param,
			success  : function(data){
				//console.log("=====getAllRightList=======");
				//console.log(data);
				if(data.jsonObj.rightList != null) {
					var rightListStr = "";
					for(var i=0; i < data.jsonObj.rightList.length; i++) {
						rightListStr += "<tr>";
						rightListStr += "<td class=\"text_center\">" + data.jsonObj.rightList[i].stockId + "</td>";			// Stock						
						var actionTp	=	"";
						if(data.jsonObj.rightList[i].issueType == "I") {
							if ("<%= langCd %>" == "en_US") {
							actionTp	=	"Stock Dividend";
							} else {
								actionTp	=	"Chia cổ tức bằng cổ phiếu";
							}
						} else if(data.jsonObj.rightList[i].issueType == "1") {
							if ("<%= langCd %>" == "en_US") {
							actionTp	=	"Cash Dividend";
							} else {
								actionTp	= "Chia cổ tức bằng tiền";
							}
						} else if(data.jsonObj.rightList[i].issueType == "B") {
							if ("<%= langCd %>" == "en_US") {
							actionTp	=	"Bonus Share";
							} else {
								actionTp	= "Chia cổ phiếu thưởng";
							}
						} else if(data.jsonObj.rightList[i].issueType == "D") {
							if ("<%= langCd %>" == "en_US") {
							actionTp	=	"Additional Issue";
							} else {
								actionTp	= "Quyền mua";
							}
						} else {
							actionTp	=	data.jsonObj.rightList[i].typeDescription;
						}
						
						rightListStr += "<td class=\"text_center\">" + actionTp + "</td>";
						
						
						rightListStr += "	<td>" + data.jsonObj.rightList[i].bookCloseDate + "</td>";						// Record Date
						rightListStr += "	<td>" + data.jsonObj.rightList[i].bookCloseQty + "</td>";					// Owning Volume
						/* rightListStr += "	<td>" + ( ( data.jsonObj.rightList[i].cashRate != null && data.jsonObj.rightList[i].cashRate.length > 0 ) ? data.jsonObj.rightList[i].cashRate : numDotCommaFormat(data.jsonObj.rightList[i].issueRatioDelivery / data.jsonObj.rightList[i].issueRatioPer)) + "</td>";// Rate Cash (VND/Share) */
						rightListStr += "	<td>" + (data.jsonObj.rightList[i].issueRatioPer) + ":" + (data.jsonObj.rightList[i].issueRatioDelivery) + "</td>";						// Rate (Stock)
						rightListStr += "	<td>" + numDotCommaFormat(parseFloat(data.jsonObj.rightList[i].price.split(",").join(""))) + "</td>";						// Par value
						rightListStr += "	<td>" + numDotCommaFormat(data.jsonObj.rightList[i].totalScript.replace(/,/g,'')) + "</td>";						// Received Cash
						rightListStr += "	<td>" + data.jsonObj.rightList[i].totalStock + "</td>";						// Received Stock
						rightListStr += "	<td>" + changeStatus(data.jsonObj.rightList[i].status) + "</td>";						// Status
						rightListStr += "	<td>" + data.jsonObj.rightList[i].payableDate + "</td>";						// Payable Date
						rightListStr += "	<td>" + data.jsonObj.rightList[i].paidDate + "</td>";						// Paid Date
						rightListStr += "</tr>";
					}

					$("#rightList").html(rightListStr);
				}
				$("#divRightList").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divRightList").unblock();
			}
		});
	}

	function getAdditionIssueShareInfo() {
		$("#divAddIssueInfoList").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url      : "/online/data/getAdditionIssueShareInfo.do",
			asyc      : true,
			data     : param,
			success  : function(data){
				//console.log("===getAdditionIssueShareInfo===");
				//console.log(data);
				if(data.jsonObj.additionList != null) {
					var addIssueListStr = "";
					for(var i=0; i < data.jsonObj.additionList.length; i++) {
						addIssueListStr += "<tr>";
	 					addIssueListStr += "	<td class=\"text_center\">" + data.jsonObj.additionList[i].tradeStockCode + "</td>";
	 					addIssueListStr += "	<td class=\"text_center\">" + data.jsonObj.additionList[i].bookCloseDate + "</td>";
	 					addIssueListStr += "	<td>" + data.jsonObj.additionList[i].totalStock + "</td>";
	 					addIssueListStr += "	<td>" + data.jsonObj.additionList[i].rightRate + "</td>";
	 					var abalQty	=	Math.floor(parseInt(data.jsonObj.additionList[i].maxQtyCanBuy.replace(/,/g, "")) * parseFloat(data.jsonObj.additionList[i].perStockRate) / parseFloat(data.jsonObj.additionList[i].perRightRate));
	 					
	 					addIssueListStr += "	<td>" + parseFloat(data.jsonObj.additionList[i].perRightRate) + " : " + parseFloat(data.jsonObj.additionList[i].perStockRate) + "</td>";
	 					addIssueListStr += "	<td>" + numIntFormat(abalQty) + "</td>";
	 					addIssueListStr += "	<td>" + numDotCommaFormat(parseFloat(data.jsonObj.additionList[i].price)) + "</td>";
	 					addIssueListStr += "	<td>" + data.jsonObj.additionList[i].startDate + "</td>";
	 					addIssueListStr += "	<td>" + data.jsonObj.additionList[i].transenddate + "</td>";
	 					addIssueListStr += "	<td>" + data.jsonObj.additionList[i].endDate + "</td>";
						addIssueListStr += "</tr>";
					}

					$("#addIssueInfoList").html(addIssueListStr);
				} else {

				}
				$("#divAddIssueInfoList").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divAddIssueInfoList").unblock();
			}
		});
	}

	function getEntitlementHistory() {
		$("#divStockCode2").hide();
		$("#divEntitlementHistoryList").block({message: "<span>LOADING...</span>"});

		var param = {
				mvSubAccountID		: "<%= session.getAttribute("subAccountID") %>",
				mvStockId			: $("#st_code2").val(),
				mvStartDate			: $("#mvStartDate2").val(),
				mvEndDate			: $("#mvEndDate2").val()
		};

		$.ajax({
			dataType  : "json",
			url       : "/online/data/getEntitlementHistory.do",
			asyc      : true,
			data      : param,
			success   : function(data){
				//console.log("===buying history===");
				//console.log(data);
				if(data.jsonObj.historyList != null) {
					var entHistoryStr = "";
					for(var i=0; i < data.jsonObj.historyList.length; i++) {
						entHistoryStr += "<tr>";
						entHistoryStr += "	<td class=\"text_center\">" + data.jsonObj.historyList[i].createTime + "</td>";
						entHistoryStr += "	<td class=\"text_center\">" + data.jsonObj.historyList[i].tradeStockCode + "</td>";
						entHistoryStr += "	<td>" + data.jsonObj.historyList[i].resultQty + "</td>";
						entHistoryStr += "	<td>" + numDotCommaFormat(parseFloat(data.jsonObj.historyList[i].price)) + "</td>";
						entHistoryStr += "	<td>" + data.jsonObj.historyList[i].appliedAmt + "</td>";
						entHistoryStr += "	<td>" + data.jsonObj.historyList[i].comfirmedDate + "</td>";
						entHistoryStr += "	<td>" + changeEntHistoryStatus(data.jsonObj.historyList[i].status) + "</td>";
						entHistoryStr += "</tr>";
					}

					$("#entHistory").html(entHistoryStr);
				} else {

				}
				$("#divEntitlementHistoryList").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divEntitlementHistoryList").unblock();
			}
		});
	}

	function changeStatus(stus){
		switch(stus){
			case "0":
				if ("<%= langCd %>" == "en_US") {
					stus = "Processing";
				} else {
					stus = "Đang xử lý";
				}
				break;
			case "1":
				if ("<%= langCd %>" == "en_US") {				
				stus = "Confirmed";
				} else {
					stus = "Đã phân bổ";
				}
				break;
			case "I":
				if ("<%= langCd %>" == "en_US") {
				stus = "Open";
				} else {
					stus = "Mới mở";
				}
				break;
			case "W":
				if ("<%= langCd %>" == "en_US") {
				stus = "Processing";
				} else {
					stus = "Đang xử lý";
				}
				break;
			case "D":
				if ("<%= langCd %>" == "en_US") {
				stus = "Confirmed";
				} else {
					stus = "Đã phân bổ";
				}
				break;

		}
		return stus;
	}

	function changeEntHistoryStatus(stus){
		switch(stus){
			case "W":
				if ("<%= langCd %>" == "en_US") {
				stus = "Deducted";
				} else {
					stus = "Khấu trừ";
				}
				break;
			case "D":
				if ("<%= langCd %>" == "en_US") {
				stus = "Paid";
				} else {
					stus = "Đã thanh toán";
				}
				break;
			case "I":
				if ("<%= langCd %>" == "en_US") {
				stus = "Input only";
				} else {
					stus = "Chỉ nhập";
				}
				break;
		}
		return stus;
	}

	// Null 체크
	function nullCheck(value){
		if(value == null){
			value = "0";
		}
		return value;
	}

	function divStockCodeShowHide(divList){
		if($("#" + divList).css("display") == "none") {
			$("#" + divList).show();
		} else {
			$("#" + divList).hide();
		}
	}

	function stockUpperStr(codeTxt, e, divList){
		$("#" + codeTxt).val(xoa_dau($("#" + codeTxt).val().toUpperCase()));		
	}
	
	function entitlementOnlineCheckOTP() {
		var param = {
				mvUserID 		: '<%=session.getAttribute("ClientV")%>'
			};
		$.ajax({
			url      : "/trading/data/mCheckOTP.do",
			contentType	:	"application/json; charset=utf-8",
			data     : param,
			dataType : "json",
			success  : function(data) {
				//console.log("Check OTP");
				//console.log(data);
				if (data.otpResponseCheck.result != "0") {
					authOtpCheckEtitlement();
				} else {					
					doReg();
				}
			}
		});	
	}
	
	function authOtpCheckEtitlement() {		
		var param = {
				divId               : "divIdOTPEtitlement",
				divType             : "submitEntilementOnline"
		};

		$.ajax({
			type     : "POST",
			url      : "/common/popup/otpConfirm.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divIdOTPEtitlement").fadeIn();
				$("#divIdOTPEtitlement").html(data);
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}

</script>
<div class="tab_content online">
	<div role="tabpanel" class="tab_pane" id="tab4">
		<div class="wrap_left">
			<div id="divEntitlementPlace" class="group_table">
				<table class="table no_bbt list_type_01">
					<caption><%= (langCd.equals("en_US") ? "Entitlement Place" : "Đăng ký thực hiện quyền") %></caption>
					<colgroup>
						<col width="150" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Bank Account" : "Số Tài khoản Ngân hàng") %></th>
							<td>
								<select id="backAccountList" onchange="accountBalance(this.value);">
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Cash balance" : "Số dư tiền mặt") %></th>
							<td id="cashBalance"></td>
						</tr>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Cash available" : "Số dư khả dụng") %></th>
							<td id="cashAvailable"></td>
						</tr>
						<%-- <tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Buying power" : "Sức mua tối đa") %></th>
							<td id="buyingPower"></td>
						</tr> --%>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Stock Code" : "Mã CK") %></th>
							<td>
								<select id="ent_stock" name="ent_stock" onchange="getEntitlementData(this);">
								<!--  
									<option value=""><%= (langCd.equals("en_US") ? "Select stock code" : "Chọn mã CK") %></option>
								-->
									<option style="display:none">
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Available Qty" : "Số lượng được phép mua") %></th>
							<td id="availableQty"></td>
						</tr>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Register Qty" : "Số lượng đăng ký") %></th>
							<td id="regQty"></td>
						</tr>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Action price" : "Giá thực hiện") %></th>
							<td id="actionPrice"></td>
						</tr>
						<tr>
							<th scope="row"><%= (langCd.equals("en_US") ? "Amount (VND)" : "Số tiền (VND)") %></th>
							<td id="amount"></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="mdi_bottom">
				<input class="color" type="button" value="<%= (langCd.equals("en_US") ? "Execute" : "Thực hiện") %>" onclick="checkAuthMethod('submit', '', '');">
				<input type="reset" value="<%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %>">
			</div>
		</div>
		<!-- // .wrap_left -->

		<div class="wrap_right">
			<div class="search_area in">
				<label for="ac_type"><%= (langCd.equals("en_US") ? "Action type" : "Loại") %></label>
				<div class="input_dropdown">
					<span>
						<select id="mvActionType" style="width:100px;">
							<option value="ALL"><%= (langCd.equals("en_US") ? "All" : "Tất cả") %></option>
							<option value="1"><%= (langCd.equals("en_US") ? "Cash Dividend" : "Chia cổ tức bằng tiền") %></option>
							<option value="I"><%= (langCd.equals("en_US") ? "Stock Divided" : "Chia cổ tức bằng cổ phiếu") %></option>
							<option value="B"><%= (langCd.equals("en_US") ? "Bonus Share" : "Chia cổ phiếu thưởng") %></option>
							<option value="D"><%= (langCd.equals("en_US") ? "Additional Issuance" : "Quyền mua") %></option>
						</select>
					</span>
				</div>
				<label for="st_code"><%= (langCd.equals("en_US") ? "Stock code" : "Mã CK") %></label>				
				<span>
					<input type="text" id="st_code1" onkeyup="stockUpperStr('st_code1')" style="width:80px;" placeholder="<%= (langCd.equals("en_US") ? "All" : "Tất cả") %>"/>						
				</span>					
				

				<label for="fromSearch1"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
				<input id="mvStartDate1" name="mvStartDate1" type="text" class="datepicker" />

				<label for="toSearch1"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
				<input id="mvEndDate" name="mvEndDate" type="text" class="datepicker" />

				<input class="confirm" type="submit" value="<%= (langCd.equals("en_US") ? "Execute" : "Tra cứu") %>" onclick="getAllRightList();">
			</div>

			<div id="divRightList" class="grid_area" style="height:190px;">
				<div class="group_table">
					<table class="table">
						<caption><%= (langCd.equals("en_US") ? "Corporate Action List" : "Danh sách quyền") %></caption>
						<thead>
							<tr>
								<th scope="col"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Action type" : "Loại") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Record Date" : "Ngày chốt quyền") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Owning Volume" : "Số lượng CK sở hữu") %></th>
								<%-- <th scope="col"><%= (langCd.equals("en_US") ? "Rate Cash (VND/Share)" : "Tỷ lệ Tiền (VND/CP)") %></th> --%>
								<th scope="col"><%= (langCd.equals("en_US") ? "Rate" : "Tỷ lệ") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Par value" : "Giá mua") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Received Cash" : "Số tiền") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Received Stock" : "Số lượng CK") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Payable Date" : "Ngày phân bố dự kiến") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Paid Date" : "Ngày phân bố") %></th>
							</tr>
						</thead>
						<tbody id="rightList">
						</tbody>
					</table>
				</div>
			</div>

			<div id="divAddIssueInfoList" class="grid_area" style="height:186px;">
				<div class="group_table">
					<table class="table">
						<caption><%= (langCd.equals("en_US") ? "Additional Issue Shares Information" : "Thông tin mua cố phiếu phát hành thêm") %></caption>
						<thead>
							<tr>
								<th scope="col"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Record Date" : "Ngày chốt quyền") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Owning Volume" : "Số lượng CK sở hữu") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Right Rate" : "Tỷ lệ quyền") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Action Rate" : "Tỷ lệ thực hiện") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Available quantity" : "Số lượng CK được mua") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Action price" : "Giá mua") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Start Date" : "Ngày bắt đầu ĐK/CN") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Transfer Deadline" : "Ngày hết hạn chuyển nhượng") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Register Deadline" : "Ngày hết hạn đăng ký") %></th>
							</tr>
						</thead>
						<tbody id="addIssueInfoList">
						</tbody>
					</table>
				</div>
			</div>

			<div class="search_area in">
				<label for="st_code"><%= (langCd.equals("en_US") ? "Stock code" : "Mã CK") %></label>				
				<span>
					<input type="text" id="st_code2" onkeyup="stockUpperStr('st_code2')" style="width:80px;" placeholder="<%= (langCd.equals("en_US") ? "All" : "Tất cả") %>"/>						
				</span>					
				

				<label for="fromSearch2"><%= (langCd.equals("en_US") ? "From" : "Từ ngày") %></label>
				<input id="mvStartDate2" name="mvStartDate" type="text" class="datepicker" />

				<label for="toSearch2"><%= (langCd.equals("en_US") ? "To" : "Đến ngày") %></label>
				<input id="mvEndDate2" name="mvEndDate" type="text" class="datepicker" />

				<input class="confirm" type="button" value="<%= (langCd.equals("en_US") ? "Execute" : "Tra cứu") %>" onclick="getEntitlementHistory();">
			</div>

			<div id="divEntitlementHistoryList" class="grid_area" style="height:186px;">
				<div class="group_table">
					<table class="table">
						<caption><%= (langCd.equals("en_US") ? "Additional Issue Shares Buying History" : "Tra cứu lịch sử giao dịch mua cố phiếu phát hành thêm") %></caption>
						<thead>
							<tr>
								<th scope="col"><%= (langCd.equals("en_US") ? "Register Date" : "Ngày đăng ký mua") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Volume" : "Số lượng CK mua") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Action price" : "Gía thực hiện") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Amount(* 1,000)" : "Số tiền(* 1.000)") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Paid Date" : "Ngày phân bố") %></th>
								<th scope="col"><%= (langCd.equals("en_US") ? "Status" : "Trạng thái") %></th>
							</tr>
						</thead>
						<tbody id="entHistory">
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!-- // .wrap_right -->
	</div>
</div>
</html>
