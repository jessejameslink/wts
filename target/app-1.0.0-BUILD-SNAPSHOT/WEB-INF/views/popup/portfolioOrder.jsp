<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script>
	$(document).ready(function() {
		$("#divOrdSymbol").hide();
		$("div[name=tabs]").tabs();
		var tabs = $(".place_buy_order .nav_tabs a");
		var btn  = $(".place_buy_order .btn_wrap button");
		
		btn.removeClass("buy").addClass("sell");
		btn.text("<%= (langCd.equals("en_US") ? "SELL" : "BÁN") %>");
		$("#thCashbalance").html("<%= (langCd.equals("en_US") ? "Stock balance" : "Số dư chứng khoán") %>");
		$("#buyAll").html("<%= (langCd.equals("en_US") ? "Sell All" : "Bán tất cả") %>");
		$("#buySell").append("<option value=''></option>").append("<option value='S'>O</option>");
		$("#tdCashbalance").html("");
		$("#buySell").val("S");
		//getEnterOrderPO();
		//getAccountbalance();
		symbolChange();
	});
	
	function getEnterOrderPO() {
		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});
		var param	=	{
				mvSubAccountID	:	"<%= session.getAttribute("subAccountID") %>"
		};
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/genenterorder.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				//console.log("genenterorder PORT");
				//console.log(data);
				if(data.jsonObj != null) {
					for(var i = 0; i < data.jsonObj.mvSettlementAccList.length; i++) {
						var obj	=	data.jsonObj.mvSettlementAccList[i];
						if(obj.mvBankID != "" ) {
							$("#mvBankID").val(obj.mvBankID);
							$("#mvBankACID").val(obj.mvBankACID);
						}
					}
				}
				$("#divPlcOrd").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divPlcOrd").unblock();
			}
		});
	}

	function getAccountbalance() {
		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});
		var param = {
				mvSubAccountID	:	"<%= session.getAttribute("subAccountID") %>"
		}

		$.ajax({
			dataType  : "json",
			url       : "/margin/data/accountbalance.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				//console.log("accountbalance PORT");
				//console.log(data);
				if(data.jsonObj != null) {
					if(data.jsonObj.mvList != null) {
						var cashBalance = "";
						if(data.jsonObj.mvList.mvAccountType != "M") {
							cashBalance = data.jsonObj.mvList.mvCSettled - data.jsonObj.mvList.mvPendingBuy - data.jsonObj.mvList.mvPendingWithdraw - data.jsonObj.mvList.mvHoldingAmt;
						} else {
							var withAbleAdvan = data.jsonObj.mvList.mvWithdrawableAmount - data.jsonObj.mvList.mvAdvanceableAmount;
							cashBalance = (withAbleAdvan > 0 ? withAbleAdvan : 0);
						}

						$("#cashbalance").html(cashBalance);
						$("#tdCashbalance").html(numIntFormat(cashBalance));
					}
					symbolChange();
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divPlcOrd").unblock();
			}
		});
	}

	function getSymbol(e) {
		$("#mvInstrument").val($("#mvInstrument").val().toUpperCase());
		if($("#mvInstrument").val() == "") {
			$("#divOrdSymbol").hide();
			return;
		}
		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});

		var param = {
				  stockCd  : $("#mvInstrument").val()
				, marketId : "ALL"
		};

		$.ajax({
			url      : "/trading/data/getMarketStockList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				$("#divOrdSymbol").show();
				if(data.stockList != null) {
					var stockStr = "";
					if(data.stockList.length == 1) {
						var stockList = data.stockList[0];
						var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
						stockStr += "<li><a onclick=\"symbolSelected('" + stockList.synm + "', '" + stockList.marketId + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
						$("#divOrdSymbol").hide();
						if(e.keyCode != 8) {
							$("#mvInstrument").val(stockList.synm);
							$("#mvMarketId").val(displayMarketID(stockList.marketId));
							symbolChange();
						}
					} else {
						for(var i=0; i < data.stockList.length; i++) {
							var stockList = data.stockList[i];
							var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
							stockStr += "<li><a onclick=\"symbolSelected('" + stockList.synm + "', '" + stockList.marketId + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
						}
					}

					$("#ulOrdSymbol").html(stockStr);
					$("#divPlcOrd").unblock();
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divPlcOrd").unblock();
			}
		});
	}

	function divOrdShowHide() {
		if($("#divOrdSymbol").css("display") == "none") {
			$("#divOrdSymbol").show();
		} else {
			$("#divOrdSymbol").hide();
		}
	}

	function symbolSelected(val, market) {
		$("#divOrdSymbol").hide();
		$("#mvInstrument").val(val);
		$("#mvMarketId").val(displayMarketID(market));
		symbolChange();
	}

	function symbolChange() {
		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});
		$("#mvEnableGetStockInfo").val("N");
		var marketStatus = "";
		var marketId	=	$("#mvMarketId").val();
		var param = {
				mvMarketID           : marketId,
				mvSubAccountID	:	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/margin/data/queryMarketStatusInfo.do",
			data      : param,
			asyc      : true,
			success   : function(data) {
				if(data != null) {
					if(data.jsonObj.mvMarketID == "HO") {
						marketStatus = data.jsonObj.mvMarketStatus;
					}
					$("#orderType").find("option").remove();
					if(marketId == "HO") {
						if (marketStatus == "T3") {
							$("#orderType").append(new Option("LO", "L", true, true));
							$("#orderType").append(new Option("ATC", "C", true, true));
						} else {
							$("#orderType").append(new Option("LO", "L", true, true));
							$("#orderType").append(new Option("ATO", "O", true, true));
							$("#orderType").append(new Option("ATC", "C", true, true));
							$("#orderType").append(new Option("MP", "M", true, true));
						}
					} else if(marketId == "HA") {
						$("#orderType").append(new Option("LO", "L", true, true));
						$("#orderType").append(new Option("ATC", "C", true, true));
						$("#orderType").append(new Option("MAK", "Z", true, true));
						$("#orderType").append(new Option("MOK", "B", true, true));
						$("#orderType").append(new Option("MTL", "R", true, true));
						$("#orderType").append(new Option("LO(Odd Lot)", "LO", true, true));
					} else if(marketId == "OTC") {
						$("#orderType").append(new Option("LO", "L", true, true));
						$("#orderType").append(new Option("LO(Odd Lot)", "LO", true, true));
					}		
					$("#orderType").val($("#orderType option:eq(0)").val());
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
		
		var param = {
				mvSubAccountID		 : 	"<%= session.getAttribute("subAccountID") %>",
				mvInstrument         : $("#mvInstrument").val(),
				mvMarketID           : $("#mvMarketId").val(),
				mvBS                 : "B",
				mvAction             : $("#mvAction").val()
		};
		//console.log("SYMBOL CHANGE===><");
		//console.log(param);
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/stockInfo.do",
			data      : param,
			asyc      : true,
			success   : function(data) {
				//console.log("STOCK INFO CHECK PORT");
				//console.log(data);
				$("#divPlcOrd").unblock();
				if(data.jsonObj != null) {
					var stock = data.jsonObj.mvStockInfoBean;					
					
					//console.log("2=>" + buyingPowerd);
					$("#mvStockName").val(stock.mvStockName);
					$("#maxMargin").val(stock.mvAvailableMarginVol);
					$("#tdMaxMarginVolume").html(stock.mvAvailableMarginVol);
					$("#lending").val(parseInt(stock.mvMarginPercentage));
					$("#tdMarginratio").html("");
					$("#buyingPower").val("");
					$("#tdBuyingPower").html("");
					$("#mvAction").val("OI,BP");
					
					//test
					$("#mvCeiling").val(stock.mvCeiling);
					$("#mvFloor").val(stock.mvFloor);
					
					$("#tdCeiling").html(stock.mvCeiling);
					$("#tdFloor").html(stock.mvFloor);
					$("#tdReference").html(stock.mvReferencePrice);
					
					$("#tdRomm").html(numIntFormat(stock.mvCurrentRoom));

					var captionSymbol = $("#mvStockName").val() + "(" + getMarket($("#mvMarketId").val()) + ")";
					$("#captionSymbol").html(captionSymbol);

					if(stock.mvTemporaryFee != null) {
						$("#mvTemporaryFee").val(stock.mvTemporaryFee);
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divPlcOrd").unblock();
			}
		});
	}

	function onFocusIn(tagId) {
		if($("#" + tagId).val() == "0") {
			$("#" + tagId).val("");
		}
	}

	function onFocusOut(tagId) {
		if($("#" + tagId).val() == "") {
			$("#" + tagId).val("0");
		}
	}

	function volumeChange(e) {
		if (e != undefined) {
			if(e.which >= 37 && e.which <= 40) return;
		}
		var volumeView = $("#volumeView").val().replace(/[,.]/g,'');
		if($("#orderType").val() == "L" || $("#orderType").val() == "LO") {
			if(volumeView > 0) {
				$("#volume").val(volumeView);
				$("#volumeView").val(numIntFormat(volumeView));
			} else {
				$("#volume").val(0);
				$("#volumeView").val(0);
			}
		} else {
			//매수일경우 상한가로 계산
			$("#price").val($("#mvFloor").val().replace(/[,.]/g,''));
			$("#priceView").val(numIntFormat($("#mvFloor").val().replace(/[,.]/g,'')));
			if(volumeView > 0 ) {
				$("#volume").val(Number(volumeView));
				$("#volumeView").val(numIntFormat(volumeView));
			} else if(Number(volumeView) <= 0) {
				$("#volume").val(0);
				$("#volumeView").val(0);
			}
		}
	}

	function priceChange(e) {
		if (e != undefined) {
			if(e.which >= 37 && e.which <= 40) return;
		}
		var priceView  = $("#priceView").val().replace(/,/g,'').replace('.','');
		if(priceView.indexOf('.') != -1) {
			var priceSpl = priceView.split(".");
			if(priceSpl[1].length > 1) {
				priceView = priceSpl[0] + "." + priceSpl[1].substring(0, 2);
			}
		}

		if(priceView > 0) {
			$("#price").val(numIntFormat(priceView));
			$("#priceView").val(numIntFormat(priceView));
		} else if(priceView == 0) {
			$("#price").val(0);
			$("#priceView").val(0);
		}
	}

	
	function isNum() {
		var key	=	event.keyCode;
		if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)) {
			event.returnValue	=	false;
		}
	}
	
	function chgOrdType(type) {
		if(type == "L" || type == "LO") {
			$("#priceView").attr("disabled", false);
			$("#priceView").show();
			$("#priceView").val(0);
			$("#price").val(0);
		} else {
			$("#priceView").attr("disabled", true);
			$("#priceView").hide();
			volumeChange();
		}
	}
	
	// Key Event
	function keyDownEvent(id, e){
		if (e.keyCode == "13") {
			queryMarketStatusInfo()
		} else {
		if($("#" + id).val() == "0"){
			if(e.keyCode == "190"){
				$("#" + id).val("0");	
			}else{
				$("#" + id).val("");				
			}
		}
		}
	}
	
	
	function queryMarketStatusInfo() {
		$("#stock").val($("#mvInstrument").val());
		var priceView  = numDotComma($("#priceView").val());
		var volumeView = numDotComma($("#volumeView").val());
		if($("#stock").val() == "") {
			$("#stock").focus();
			if ("<%= langCd %>" == "en_US") {
				alert("Please enter the Stock Code!");	
			} else {
				alert("Vui lòng nhập mã chứng khoán!");
			}
			return;
		}
		
		if (priceView == "" || priceView == "0") {
			 if($("#orderType").val() == "L" || $("#orderType").val() == "LO") {
				$("#priceView").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Price!");	
				} else {
					alert("Vui lòng nhập giá!");
				}
				return;
			}
			 }

		if($("#volume").val() == 0) {
			$("#volumeView").focus();
			if ("<%= langCd %>" == "en_US") {
				alert("Please enter the Quantity!");	
			} else {
				alert("Vui lòng nhập số lượng!");
			}

			return;
		}

		if(priceView > 0) {
			if($("#mvMarketId").val() == "HO") {
				if(priceView <= 10000) {
					if(priceView % 10 != 0) {
						$("#priceView").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 10.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 10.");
						}
						return;
					}
				} else if(priceView > 10000 && priceView <= 49500) {
					if(priceView % 50 != 0) {
						$("#priceView").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 50.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 50.");
						}
						return;
					}
				} else if(priceView >= 50000) {
					if(priceView % 100 != 0) {
						$("#priceView").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 100.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 100.");
						}
						return;
					}
				}
			} else if($("#mvMarketId").val() == "HA") {
				if(priceView % 10 != 0) {
					$("#priceView").focus();
					if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price ticksize 10.");	
					} else {
						alert("Giá không hợp lệ cho bước giá 10.");
					}
					return;
				}
			} else if($("#mvMarketId").val() == "OTC") {
				if(priceView % 10 != 0) {
					$("#priceView").focus();
					if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price ticksize 10.");	
					} else {
						alert("Giá không hợp lệ cho bước giá 10.");
					}
					return;
				}
			}
		}

		if(numDotComma($("#price").val()) == 0) {
			$("#priceView").focus();
			if ("<%= langCd %>" == "en_US") {
				alert("Please enter the Price!");	
			} else {
				alert("Vui lòng nhập giá!");
			}
			return;
		}

		if(numDotComma($("#price").val()) > 0) {
			if((parseFloat(numDotComma($("#mvFloor").val())) > parseFloat(numDotComma($("#price").val()))) || (parseFloat(numDotComma($("#mvCeiling").val())) < parseFloat(numDotComma($("#price").val())))) {
				$("#priceView").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Order price is out of price spread (" + $("#mvFloor").val() + " to " + $("#mvCeiling").val() + "), please input again!");	
				} else {
					alert("Giá đặt nằm ngoài biên độ từ (" + $("#mvFloor").val() + " đến " + $("#mvCeiling").val() + "), vui lòng nhập lại!");
				}
				return;
			}
		}

		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});
		var param = {
				mvMarketID           : $("#mvMarketId").val(),
				mvSubAccountID		 : "<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
			dataType  : "json",
			url       : "/margin/data/queryMarketStatusInfo.do",
			data      : param,
			asyc      : true,
			cache : false,
			success   : function(data) {
				if(data != null) {
					$("#divPlcOrd").unblock();
					if(data.jsonObj.mvMarketID == "HO") {
								if (data.jsonObj.mvMarketStatus == "T1"	|| data.jsonObj.mvMarketStatus == "T2" || data.jsonObj.mvMarketStatus == "T3" || data.jsonObj.canEnterOrder  == "true") {
							orderOpen();
						} else {
							if ("<%= langCd %>" == "en_US") {
								alert("Out of time for order in " + displayMarketCode(data.jsonObj.mvMarketID));
							} else {
										alert("Hết thời gian đặt lệnh " + displayMarketCode(data.jsonObj.mvMarketID));
							}
						}
					} else if(data.jsonObj.mvMarketID == "HA") {
						if(data.jsonObj.mvMarketStatus == null || data.jsonObj.mvMarketStatus == "13") {
							if ("<%= langCd %>" == "en_US") {
								alert("Out of time for order in " + displayMarketCode(data.jsonObj.mvMarketID));
							} else {
										alert("Hết thời gian đặt lệnh " + displayMarketCode(data.jsonObj.mvMarketID));
							}
						} else {
							orderOpen();
						}
					} else if(data.jsonObj.mvMarketID == "OTC") {
						if(data.jsonObj.mvMarketStatus == null || data.jsonObj.mvMarketStatus == "13") {
							if ("<%= langCd %>" == "en_US") {
								alert("Out of time for order in " + displayMarketCode(data.jsonObj.mvMarketID));
							} else {
										alert("Hết thời gian đặt lệnh " + displayMarketCode(data.jsonObj.mvMarketID));
							}
						} else {
							orderOpen();
						}
					}
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divPlcOrd").unblock();
			}
		});
	}

	function orderOpen() {
		$("#orderTypeNm").val($("#orderType option:selected").text());
		$("#mvStockCode").val($("#mvInstrument").val());
		$("#mvQuantity").val($("#volume").val());
		$("#mvPrice").val($("#price").val());
		$("#mvBS").val($("#buySell").val());
		$("#mvMarketID").val($("#mvMarketId").val());
		
		//console.log("MB DAA CHECK====");
		//console.log($("#frmPlaceOrder").serialize());
		
		$.ajax({
			type     : "POST",
			url      : "/trading/popup/orderConfirmP.do",
			data     : $("#frmPlaceOrder").serialize(),
			dataType : "html",
			success  : function(data){
				$("#divPlaceOrderPop").fadeIn();
				$("#divPlaceOrderPop").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function getMarket(marketID) {
		switch (marketID) {
			case "HO":
				return "HSX";
			case "HA":
				return "HNX";
			case "UPCOM":
				return "UPCOM";
			default :
				return ""
		}
	}

	function cancelPlace() {
		$("#" + $("#divIdPlacePop").val()).fadeOut();
	}
	
	//setInterval(updateStock, 3000);
</script>

</head>
<body>
	<form id="frmPlaceOrder" autocomplete="Off">
		<input type="hidden" id="divIdPlacePop" name="divIdPlacePop" value="${divId}">
		<input type="hidden" id="mvStockName" name="mvStockName" value="">
		<input type="hidden" id="mvMarketId" name="mvMarketId" value="${marketID}">
		<input type="hidden" id="mvEnableGetStockInfo" name="mvEnableGetStockInfo" value="">
		<input type="hidden" id="mvAction" name="mvAction" value="OI,BP,FE">
		<input type="hidden" id="mvTemporaryFee" name="mvTemporaryFee" value="">
		<input type="hidden" id="maxMargin" name="maxMargin" value="">
		<input type="hidden" id="lending" name="lending" value="">
		<input type="hidden" id="value" name="value" value="">
		<input type="hidden" id="netFee" name="netFee" value="">
		<input type="hidden" id="mvBankID" name="mvBankID" value="">
		<input type="hidden" id="mvBankACID" name="mvBankACID" value="">
		<input type="hidden" id="buyingPower" name="buyingPower" value="">
		<input type="hidden" id="orderTypeNm" name="orderTypeNm" value="">
		<input type="hidden" id="expiryDt" name="expiryDt" value="">
		<input type="hidden" id="advancedDt" name="advancedDt" value="">
		<input type="hidden" id="refId" name="refId" value="">
		<input type="hidden" id="mvCeiling" name="mvCeiling" value="">
		<input type="hidden" id="mvFloor" name="mvFloor" value="">
		
		<input type="hidden" id="cashbalance" name="cashbalance" value="">
		<input type="hidden" id="buySell" name="buySell" value="B">
		<input type="hidden" id="volume" name="volume" value="">
		<input type="hidden" id="price" name="price" value="">
		<input type="hidden" id="stock" name="stock" value="">
		<input type="hidden" id="divId" name="divId" value="divPlaceOrderPop">

		<input type="hidden" id="mvBs" 		name="mvBS"/>
		<input type="hidden" id="mvStockCode" name="mvStockCode"/>
		<input type="hidden" id="mvQuantity" 	name="mvQuantity"/>
		<input type="hidden" id="mvPrice" 	name="mvPrice"/>
		<input type="hidden" id="mvMarketID" 	name="mvMarketID"/>
		
		<!-- Condition Order -->
		<input type="hidden" id="mvStop" name="mvStop" value="N">
		<input type="hidden" id="mvStopType" name="mvStopType" value="">
		<input type="hidden" id="mvStopPrice" name="mvStopPrice" value="">


		<!-- PLACE BUY ORDER -->
		<div id="divPlcOrd" class="modal_layer pbo">
			<h2><%= (langCd.equals("en_US") ? "PORTFOLIO SELL ORDER" : "Đặt lệnh bán") %></h2>
			<!-- tabs -->
			<div class="place_buy_order">
				<div class="pbo_container">
					<div class="wrap_left">
						<table>
							<colgroup>
								<col width="95">
								<col >
							</colgroup>
							<tbody>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Symbol" : "Mã CK") %></th>
									<td>
										<div class="input_dropdown">
											<span>
												<input type="text" id="mvInstrument" name="mvInstrument" onkeyup="getSymbol(event)" style="width: 104px;" value="${symbol}"/>
												<button type="button" onclick="divOrdShowHide()"></button>
											</span>
											<div id="divOrdSymbol">
												<ul id="ulOrdSymbol">
												</ul>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Order Type" : "Loại lệnh") %></th>
									<td>
										<select id="orderType" name="orderType" title="Order Type" onchange="chgOrdType(this.value);">
										</select>
									</td>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Price(VND)" : "Giá") %></th>
									<td>
										<input class="text won" type="text" id="priceView" name="priceView" value="0" onkeyup="priceChange(event)" onkeydown="keyDownEvent(this.id, event)" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" maxlength="8" onkeypress="isNum();">
									</td>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
									<td>
										<input class="text won" type="text" id="volumeView" name="volumeView" value="0" onkeyup="volumeChange(event)" onkeydown="keyDownEvent(this.id, event)" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" maxlength="9" onkeypress="isNum();">
									</td>
								</tr>
							</tbody>
						</table>
						<div class="btn_wrap">
							<button class="add buy" type="button" onclick="queryMarketStatusInfo()"><%= (langCd.equals("en_US") ? "SELL" : "BÁN") %></button>
						</div>
					</div>
					<div class="wrap_right">						
						<div class="group_table">
							<table class="no_bbt">
								<caption id="captionSymbol"></caption>
								<colgroup>
									<col width="33.3%">
									<col width="33.3%">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th class="ceiling"><%= (langCd.equals("en_US") ? "Ceiling" : "Giá trần") %></th>
										<th class="reference"><%= (langCd.equals("en_US") ? "Reference" : "Giá tham chiếu") %></th>
										<th class="floor"><%= (langCd.equals("en_US") ? "Floor" : "Giá sàn") %></th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th colspan="2"><%= (langCd.equals("en_US") ? "F.Room" : "KL NDT NN được phép mua") %></th>
										<td id="tdRomm"></td>
									</tr>
								</tfoot>								
								<tbody>
									<tr>
										<td class="ceiling" id="tdCeiling"></td>
										<td class="reference" id="tdReference"></td>
										<td class="floor" id="tdFloor"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<button class="close" type="button" onclick="cancelPlace()">close</button>
		</div>
		<!-- //PLACE BUY ORDER -->
	</form>

	<!-- orderConfirm pop -->
	<div id="divPlaceOrderPop" class="layer_on_modal"></div>
	<!-- orderConfirm pop -->
</body>
</html>