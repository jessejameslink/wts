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
	var tabBuySell = "buy";	
	$(document).ready(function() {
		$("#divOrdSymbol").hide();
		$("div[name=tabs]").tabs();
		var tabs = $(".place_buy_order .nav_tabs a");
		var btn  = $(".place_buy_order .btn_wrap button");

		tabs.on("click", function(e) {
			var id = $(this).attr("href");
			tabs.parent().removeClass("ui-tabs-active");
			$(this).parent().addClass("ui-tabs-active");
			$("#buySellPL").find("option").remove();

			if(id == "#orderBuy") {
				btn.removeClass("sell").addClass("buy");
				btn.text("<%= (langCd.equals("en_US") ? "BUY" : "MUA") %>");
				$("#thCashbalance").html("<%= (langCd.equals("en_US") ? "Cash balance" : "Số dư tiền mặt") %>");
				$("#buySellPL").append("<option value=''></option>").append("<option value='B'>O</option>");
				$("#tdCashbalance").html(($("#cashbalance").val() != "" ? numIntFormat($("#cashbalance").val()) : ""));
				$("#buySellPL").val("B");
				tabBuySell = "buy";
			} else {
				btn.removeClass("buy").addClass("sell");
				btn.text("<%= (langCd.equals("en_US") ? "SELL" : "BÁN") %>");
				$("#thCashbalance").html("<%= (langCd.equals("en_US") ? "Stock balance" : "Số dư chứng khoán") %>");				
				$("#buySellPL").append("<option value=''></option>").append("<option value='S'>O</option>");
				$("#tdCashbalance").html(($("#tradableStock").val() != "" ? numIntFormat($("#tradableStock").val()) : ""));
				$("#buySellPL").val("S");
				tabBuySell = "sell";
			}
			volumeChange();
			e.preventDefault();
		});
		//getEnterOrderPL();
		symbolChange();
	});
	
	function getTradableStock() {
		var param = {
				mvSubAccountID	: 	"<%= session.getAttribute("subAccountID") %>"
		};

		$.ajax({
				dataType  : "json",
				url       : "/trading/data/enquiryportfolio.do",
				data      : param,
				success   : function(data) {
					//console.log("==getTradableStock==");
					//console.log(data);
					if(data.jsonObj != null) {
						if(data.jsonObj.mvPortfolioBeanList != null) {
							for(var i=0; i < data.jsonObj.mvPortfolioBeanList.length; i++) {
								var rowData = data.jsonObj.mvPortfolioBeanList[i];
								if(rowData.mvStockID == $("#mvInstrumentPL").val()) {
									var vol = rowData.mvTradableQty.replace(/,/g, "");									
									$("#tradableStock").val(vol);
									if (tabBuySell == "sell") {
										$("#tdCashbalance").html(numIntFormat(vol));	
									}
								}
							}
						}
					}
				},
				error     :function(e) {
					console.log(e);
				}
		});
	}	
	function getEnterOrderPL() {
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
				//console.log("genenterorder PL");
				//console.log(data);
				if(data.jsonObj != null) {
					var flag	=	false;
					for(var i = 0; i < data.jsonObj.mvSettlementAccList.length; i++) {
						var obj	=	data.jsonObj.mvSettlementAccList[i];
						if(obj.mvBankID != "" ) {
							$("#mvBankIDPL").val(obj.mvBankID);
							$("#mvBankACIDPL").val(obj.mvBankACID);
							flag = true;
						}
					}
					
					if(flag) {
						$("#bankAccountYnPL").val("Y");
					} else {
						$("#bankAccountYnPL").val("N");
					}
					getAccountbalance();
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
				mvSubAccountID	:	"<%= session.getAttribute("subAccountID") %>",
				loadBank		:   ($("#bankAccountYnPL").val() == "Y" ? true : false)
		}
		$.ajax({
			dataType  : "json",
			url       : "/margin/data/accountbalance.do",
			asyc      : true,
			data	  : param,
			cache	  : false,
			success   : function(data) {
				//console.log("===GET CASH BALANCE===");
				//console.log(data);
				if(data.jsonObj != null) {
					if(data.jsonObj.mvList != null) {
						var cashBalance = "";
						var dataRow = data.jsonObj.mvList[0];
						if ($("#bankAccountYnPL").val() == "N") {							
							if(dataRow.mvAccountType != "M") {
								cashBalance      = numDotComma(formatNumber(dataRow.mvCSettled)) - numDotComma(formatNumber(dataRow.mvPendingBuy)) - numDotComma(formatNumber(dataRow.mvPendingWithdraw)) - numDotComma(formatNumber(dataRow.mvHoldingAmt));
							} else {
								var withAbleAdvan = numDotComma(formatNumber(dataRow.mvWithdrawableAmount)) - numDotComma(formatNumber(dataRow.mvAdvanceableAmount));
								cashBalance = (withAbleAdvan > 0 ? withAbleAdvan : 0);
							}
						} else {
							cashBalance = numDotComma(formatNumber(dataRow.mvBuyingPowerd));
							$("#tdBuyingPower").html(numIntFormat(parseInt(cashBalance)));
						}
						
						$("#cashbalance").val(cashBalance);
						if (tabBuySell == "buy") {
							$("#tdCashbalance").html(numIntFormat(cashBalance));	
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

	function getSymbol(e) {
		$("#mvInstrumentPL").val($("#mvInstrumentPL").val().toUpperCase());
		if($("#mvInstrumentPL").val() == "") {
			$("#divOrdSymbol").hide();
			return;
		}
		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});

		var param = {
				  stockCd  : $("#mvInstrumentPL").val()
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
							$("#mvInstrumentPL").val(stockList.synm);
							$("#mvMarketIdPL").val(displayMarketID(stockList.marketId));
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
		$("#mvInstrumentPL").val(val);
		$("#mvMarketIdPL").val(displayMarketID(market));
		symbolChange();
	}

	function symbolChange() {
		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});
		$("#mvEnableGetStockInfoPL").val("N");
		var marketStatus = "";
		var marketId	=	$("#mvMarketIdPL").val();
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
				//console.log("queryMarketStatusInfo =======");
				//console.log(data);
				if(data != null) {
					if(data.jsonObj.mvMarketID == "HO") {
						marketStatus = data.jsonObj.mvMarketStatus;
					}
					$("#orderTypePL").find("option").remove();
					if(marketId == "HO") {
						if (marketStatus == "T3") {
							$("#orderTypePL").append(new Option("LO", "L", true, true));
							$("#orderTypePL").append(new Option("ATC", "C", true, true));
						} else {
							$("#orderTypePL").append(new Option("LO", "L", true, true));
							$("#orderTypePL").append(new Option("ATO", "O", true, true));
							$("#orderTypePL").append(new Option("ATC", "C", true, true));
							$("#orderTypePL").append(new Option("MP", "M", true, true));
						}
					} else if(marketId == "HA") {
						$("#orderTypePL").append(new Option("LO", "L", true, true));
						$("#orderTypePL").append(new Option("ATC", "C", true, true));
						$("#orderTypePL").append(new Option("MAK", "Z", true, true));
						$("#orderTypePL").append(new Option("MOK", "B", true, true));
						$("#orderTypePL").append(new Option("MTL", "R", true, true));
						$("#orderTypePL").append(new Option("LO(Odd Lot)", "LO", true, true));
					} else if(marketId == "OTC") {
						$("#orderTypePL").append(new Option("LO", "L", true, true));
						$("#orderTypePL").append(new Option("LO(Odd Lot)", "LO", true, true));
					}
					$("#orderTypePL").val($("#orderTypePL option:eq(0)").val());
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
		
		var param = {
				mvSubAccountID	:	"<%= session.getAttribute("subAccountID") %>",
				mvInstrument         : $("#mvInstrumentPL").val(),
				mvMarketID           : $("#mvMarketIdPL").val(),
				mvBS                 : $("#buySellPL").val(),
				mvAction             : $("#mvActionPL").val()
		};
		//console.log("SYMBOL CHANGE===><");
		//console.log(param);
		$.ajax({
			dataType  : "json",
			url       : "/trading/data/stockInfo.do",
			data      : param,
			asyc      : true,
			success   : function(data) {
				//console.log("STOCK INFO CHECK MARGIN");
				//console.log(data);
				$("#divPlcOrd").unblock();
				if(data.jsonObj != null) {
					var stock = data.jsonObj.mvStockInfoBean;
					var buyingPowerd 	= stock.mvBuyingPowerd;
					var marginPercent	=	stock.mvMarginPercentage;					
					buyingPowerd = buyingPowerd.replace(/,/g, "") * 1000;
					if(marginPercent == null || marginPercent == 'null' || marginPercent == "") {
						marginPercent	=	0;
					}
					//buyingPowerd = Math.floor(buyingPowerd / (1 - marginPercent / 100));
					
					$("#mvStockNamePL").val(stock.mvStockName);
					$("#maxMarginPL").val(stock.mvAvailableMarginVol);
					$("#lendingPL").val(parseInt(stock.mvMarginPercentage));
					$("#tdMarginratio").html((stock.mvMarginPercentage == "null" ? 0 : parseInt(stock.mvMarginPercentage)) + "%");
					$("#buyingPowerPL").val(parseInt(buyingPowerd));
					$("#tdBuyingPower").html(numIntFormat(parseInt(buyingPowerd)));
					$("#mvActionPL").val("OI,BP");
					
					//test
					$("#mvCeilingPL").val(stock.mvCeiling);
					$("#mvFloorPL").val(stock.mvFloor);
					
					$("#tdCeiling").html(stock.mvCeiling);
					$("#tdFloor").html(stock.mvFloor);
					$("#tdReference").html(stock.mvReferencePrice);
					
					$("#tdRomm").html(numIntFormat(stock.mvCurrentRoom));

					var captionSymbol = $("#mvStockNamePL").val() + "(" + getMarket($("#mvMarketIdPL").val()) + ")";
					$("#captionSymbol").html(captionSymbol);

					if(stock.mvTemporaryFee != null) {
						$("#mvTemporaryFeePL").val(stock.mvTemporaryFee);
					}					
				}
			},
			error     :function(e) {
				console.log(e);
				$("#divPlcOrd").unblock();
			}
		});
		//getAccountbalance();
		getEnterOrderPL();
		getTradableStock();
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
		var volumeView = $("#volumeViewPL").val().replace(/[,.]/g,'');
		if($("#orderTypePL").val() == "L" || $("#orderTypePL").val() == "LO") {
			if(volumeView > 0) {
				$("#volumePL").val(volumeView);
				$("#volumeViewPL").val(numIntFormat(volumeView));
				volPriceSum();
			} else {
				$("#volumePL").val(0);
				$("#volumeViewPL").val(0);
				volPriceSum();
			}
		} else {
			//매수일경우 상한가로 계산
			if(tabBuySell == "buy") {
				$("#pricePL").val($("#mvCeilingPL").val().replace(/[,.]/g,''));
				$("#priceViewPL").val(numIntFormat($("#mvCeilingPL").val().replace(/[,.]/g,'')));
			} else {
				$("#pricePL").val($("#mvFloorPL").val().replace(/[,.]/g,''));
				$("#priceViewPL").val(numIntFormat($("#mvFloorPL").val().replace(/[,.]/g,'')));
			}
			if(volumeView > 0 ) {
				$("#volumePL").val(Number(volumeView));
				$("#volumeViewPL").val(numIntFormat(volumeView));
				volPriceSum();
			} else if(Number(volumeView) <= 0) {
				$("#volumePL").val(0);
				$("#volumeViewPL").val(0);
			}
		}
	}

	function priceChange(e) {
		if (e != undefined) {
			if(e.which >= 37 && e.which <= 40) return;
		}
		var priceView  = $("#priceViewPL").val().replace(/,/g,'').replace('.','');
		if(priceView.indexOf('.') != -1) {
			var priceSpl = priceView.split(".");
			if(priceSpl[1].length > 1) {
				priceView = priceSpl[0] + "." + priceSpl[1].substring(0, 2);
			}
		}

		if(priceView > 0) {
			$("#pricePL").val(numIntFormat(priceView));
			$("#priceViewPL").val(numIntFormat(priceView));
			volPriceSum();
		} else if(priceView == 0) {
			$("#pricePL").val(0);
			$("#priceViewPL").val(0);
			volPriceSum();
		}
	}

	function volPriceSum() {
		var volume  = $("#volumePL").val();
		var price   = $("#pricePL").val();
		var tmpFee  = $("#mvTemporaryFeePL").val();
		var valSum  = 0;
		var netFee  = 0;
		
		valSum = price.split(",").join("")  * volume.split(",").join("");
		netFee = valSum * tmpFee;
		netFee = Math.round(netFee / 1000, 1) * 10;
		
		$("#valuePL").val(numIntFormat(valSum));
		$("#netFeePL").val(numIntFormat(netFee));
	}

	
	function isNum() {
		var key	=	event.keyCode;
		if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)) {
			event.returnValue	=	false;
		}
	}
	
	function chgOrdType(type) {
		if(type == "L" || type == "LO") {
			$("#priceViewPL").attr("disabled", false);
			$("#priceViewPL").show();
			$("#priceViewPL").val(0);
			$("#pricePL").val(0);
		} else {
			$("#priceViewPL").attr("disabled", true);
			$("#priceViewPL").hide();
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
		$("#stockPL").val($("#mvInstrumentPL").val());
		var priceView  = numDotComma($("#priceViewPL").val());
		var volumeView = numDotComma($("#volumeViewPL").val());
		if($("#stockPL").val() == "") {
			$("#stockPL").focus();
			if ("<%= langCd %>" == "en_US") {
				alert("Please enter the Stock Code!");	
			} else {
				alert("Vui lòng nhập mã chứng khoán!");
			}
			return;
		}
		
		if (priceView == "" || priceView == "0") {
			 if($("#orderTypePL").val() == "L" || $("#orderTypePL").val() == "LO") {
				$("#priceViewPL").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Price!");	
				} else {
					alert("Vui lòng nhập giá!");
				}
				return;
			}
			 }

		if($("#volumePL").val() == 0) {
			$("#volumeViewPL").focus();
			if ("<%= langCd %>" == "en_US") {
				alert("Please enter the Quantity!");	
			} else {
				alert("Vui lòng nhập số lượng!");
			}

			return;
		}

		if(priceView > 0) {
			if($("#mvMarketIdPL").val() == "HO") {
				if(priceView <= 10000) {
					if(priceView % 10 != 0) {
						$("#priceViewPL").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 10.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 10.");
						}
						return;
					}
				} else if(priceView > 10000 && priceView <= 49500) {
					if(priceView % 50 != 0) {
						$("#priceViewPL").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 50.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 50.");
						}
						return;
					}
				} else if(priceView >= 50000) {
					if(priceView % 100 != 0) {
						$("#priceViewPL").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 100.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 100.");
						}
						return;
					}
				}
			} else if($("#mvMarketIdPL").val() == "HA") {
				if(priceView % 10 != 0) {
					$("#priceViewPL").focus();
					if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price ticksize 10.");	
					} else {
						alert("Giá không hợp lệ cho bước giá 10.");
					}
					return;
				}
			} else if($("#mvMarketIdPL").val() == "OTC") {
				if(priceView % 10 != 0) {
					$("#priceViewPL").focus();
					if ("<%= langCd %>" == "en_US") {
						alert("Invalid Price ticksize 10.");	
					} else {
						alert("Giá không hợp lệ cho bước giá 10.");
					}
					return;
				}
			}
		}

		if(numDotComma($("#pricePL").val()) == 0) {
			$("#priceViewPL").focus();
			if ("<%= langCd %>" == "en_US") {
				alert("Please enter the Price!");	
			} else {
				alert("Vui lòng nhập giá!");
			}
			return;
		}

		if(numDotComma($("#pricePL").val()) > 0) {
			if((parseFloat(numDotComma($("#mvFloorPL").val())) > parseFloat(numDotComma($("#pricePL").val()))) || (parseFloat(numDotComma($("#mvCeilingPL").val())) < parseFloat(numDotComma($("#pricePL").val())))) {
				$("#priceViewPL").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Order price is out of price spread (" + $("#mvFloorPL").val() + " to " + $("#mvCeilingPL").val() + "), please input again!");	
				} else {
					alert("Giá đặt nằm ngoài biên độ từ (" + $("#mvFloorPL").val() + " đến " + $("#mvCeilingPL").val() + "), vui lòng nhập lại!");
				}
				return;
			}
		}

		$("#divPlcOrd").block({message: "<span>LOADING...</span>"});
		var param = {
				mvMarketID           : $("#mvMarketIdPL").val(),
				mvSubAccountID	:	"<%= session.getAttribute("subAccountID") %>"
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
		$("#orderTypeNmPL").val($("#orderTypePL option:selected").text());		
		$("#mvStockCode").val($("#mvInstrumentPL").val());
		$("#mvQuantity").val($("#volumePL").val());
		$("#mvPrice").val($("#pricePL").val());
		$("#mvBS").val($("#buySellPL").val());
		$("#mvMarketID").val($("#mvMarketIdPL").val());
		
		//console.log("MB DAA CHECK====");
		//console.log($("#frmPlaceOrder").serialize());
		
		$.ajax({
			type     : "POST",
			url      : "/trading/popup/orderConfirmPL.do",
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

</head>
<body>
	<form id="frmPlaceOrder" autocomplete="Off">
		<input type="hidden" id="divIdPlacePop" name="divIdPlacePop" value="${divId}">
		<input type="hidden" id="mvStockNamePL" name="mvStockNamePL" value="">
		<input type="hidden" id="mvMarketIdPL" name="mvMarketIdPL" value="${marketID}">
		<input type="hidden" id="mvEnableGetStockInfoPL" name="mvEnableGetStockInfoPL" value="">
		<input type="hidden" id="mvActionPL" name="mvActionPL" value="OI,BP,FE">
		<input type="hidden" id="mvTemporaryFeePL" name="mvTemporaryFeePL" value="">
		<input type="hidden" id="maxMarginPL" name="maxMarginPL" value="">
		<input type="hidden" id="lendingPL" name="lendingPL" value="">
		<input type="hidden" id="valuePL" name="valuePL" value="">
		<input type="hidden" id="netFeePL" name="netFeePL" value="">
		<input type="hidden" id="mvBankIDPL" name="mvBankIDPL" value="">
		<input type="hidden" id="mvBankACIDPL" name="mvBankACIDPL" value="">
		<input type="hidden" id="buyingPowerPL" name="buyingPowerPL" value="">
		<input type="hidden" id="orderTypeNmPL" name="orderTypeNmPL" value="">
		<input type="hidden" id="expiryDtPL" name="expiryDtPL" value="">
		<input type="hidden" id="advancedDtPL" name="advancedDtPL" value="">
		<input type="hidden" id="refIdPL" name="refIdPL" value="">
		<input type="hidden" id="mvCeilingPL" name="mvCeilingPL" value="">
		<input type="hidden" id="mvFloorPL" name="mvFloorPL" value="">
		
		<input type="hidden" id="cashbalance" name="cashbalance" value="">
		<input type="hidden" id="tradableStock" name="tradableStock" value="">		
		<input type="hidden" id="buySellPL" name="buySellPL" value="B">
		<input type="hidden" id="volumePL" name="volumePL" value="">
		<input type="hidden" id="pricePL" name="pricePL" value="">
		<input type="hidden" id="stockPL" name="stockPL" value="">
		<input type="hidden" id="divIdPL" name="divIdPL" value="divPlaceOrderPop">

		<input type="hidden" id="mvBs" 		name="mvBS"/>
		<input type="hidden" id="mvStockCode" name="mvStockCode"/>
		<input type="hidden" id="mvQuantity" 	name="mvQuantity"/>
		<input type="hidden" id="mvPrice" 	name="mvPrice"/>
		<input type="hidden" id="mvMarketID" 	name="mvMarketID"/>
		
		<!-- Condition Order -->
		<input type="hidden" id="mvStopPL" name="mvStopPL" value="N">
		<input type="hidden" id="mvStopTypePL" name="mvStopTypePL" value="">
		<input type="hidden" id="mvStopPricePL" name="mvStopPricePL" value="">
		
		<input type="hidden" id="bankAccountYnPL" name="bankAccountYnPL"/>


		<!-- PLACE BUY ORDER -->
		<div id="divPlcOrd" class="modal_layer pbo">
			<h2><%= (langCd.equals("en_US") ? "PLACE BUY ORDER" : "Đặt lệnh mua") %></h2>
			<!-- tabs -->
			<div class="place_buy_order">
				<ul class="nav_tabs">
					<li id="buytab" class="ui-tabs-active"><a href="#orderBuy"><%= (langCd.equals("en_US") ? "BUY" : "MUA") %></a></li>
					<li id="selltab"><a href="#orderSell"><%= (langCd.equals("en_US") ? "SELL" : "BÁN") %></a></li>
				</ul>
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
												<input type="text" id="mvInstrumentPL" name="mvInstrumentPL" onkeyup="getSymbol(event)" style="width: 104px;" value="${symbol}"/>
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
										<select id="orderTypePL" name="orderTypePL" title="Order Type" onchange="chgOrdType(this.value);">
										</select>
									</td>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Price(VND)" : "Giá") %></th>
									<td>
										<input class="text won" type="text" id="priceViewPL" name="priceViewPL" value="0" onkeyup="priceChange(event)" onkeydown="keyDownEvent(this.id, event)" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" maxlength="8" onkeypress="isNum();">
									</td>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
									<td>
										<input class="text won" type="text" id="volumeViewPL" name="volumeViewPL" value="0" onkeyup="volumeChange(event)" onkeydown="keyDownEvent(this.id, event)" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" maxlength="9" onkeypress="isNum();">
									</td>
								</tr>
							</tbody>
						</table>
						<div class="btn_wrap">
							<button class="add buy" type="button" onclick="queryMarketStatusInfo()"><%= (langCd.equals("en_US") ? "BUY" : "MUA") %></button>
						</div>
					</div>
					<div class="wrap_right">
						<div class="group_table">
							<table class="no_bbt">
								<colgroup>
									<col width="33.3%" />
									<col />
								</colgroup>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Buying Power" : "Sức mua") %></th>
									<td id="tdBuyingPower"></td>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Margin Ratio" : "Tỷ lệ ký quỹ") %></th>
									<td id="tdMarginratio"></td>
								</tr>
								<tr>
									<th id="thCashbalance"><%= (langCd.equals("en_US") ? "Cash Balance" : "Số dư tiền mặt") %></th>
									<td id="tdCashbalance"></td>
								</tr>
							</table>
						</div>
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