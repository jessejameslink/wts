<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<html>
	<head>
	<script>
		var tmpData;
		var subAcc;
		
		//delay 500 enter key
		var keyup_timeout;
		var timeout_delay_in_ms = 500;
		
		$(document).keypress(function (e) {
		    if (e.which == 13) {
		    	
		    	//deplay enter key
				clearTimeout(keyup_timeout); // Clear the previous timeout so that it won't be executed any more. It will be overwritten by a new one below.
		        keyup_timeout = setTimeout(function() {
		            // Perform your magic here.
		        }, timeout_delay_in_ms);
		    	
		    }
		});
		
		$(document).ready(function() {
			
			$("#tabOrdGrp2").tabs({active : $("#tabsGrp").val()});
			$("#tab49").find("#divEnterSellPop").hide();
			$("#tab49").find("#divOrdStock").hide();
			getEnterOrder();
						
			try {
				var rcod	=	'';
				if($("#tab31").find("span[name='bid_rcod']").html().substring(0,3) != undefined) {
					rcod	=	$("#tab31").find("span[name='bid_rcod']").html().substring(0,3);
				}
				Ext_SetOrderStock(rcod);
			} catch(e) {
				console.log(e);
			}
			
			getSubAccountS();			
			$("#accNameS").val('<%= session.getAttribute("ClientName") %>');
			
			$(".layer_search_ES .layer_ES").hide();
			$('.layer_search_ES button').click(function(e){
				var self = $(this);
				
				if(self.closest('.btn_wrap').length){ // sub layer button
					self.closest('.layer_ES').hide();
					$('.layer_search_ES button').removeClass('on');
				} else { // layer toggle button
					if(!self.closest('.search_area').length) {
						self.toggleClass('on');
						$('.layer_search_ES button').not(this).removeClass('on');
						$('.layer_search_ES .layer_ES').not($(this).next()).hide();
						self.next().toggle();
						$("#schNamePopES").val("");
						$("#schMarketPopALLES").prop('checked', true);
						if ($('.layer_search_ES button').hasClass('on')) {
							getStockPopES();
						}
					} else {						
						getStockPopES();
					}
				}
			});
			
			$("#schMarketPopALLES").on('change', function(e) {
				getStockPopMarketES("ALL");
			});
			$("#schMarketPopHOES").on('change', function(e) {			
				getStockPopMarketES("HOSE");
			});
			$("#schMarketPopHAES").on('change', function(e) {
				getStockPopMarketES("HNX");
			});
			$("#schMarketPopOTCES").on('change', function(e) {		
				getStockPopMarketES("UPCOM");
			});
			$("#schMarketPopCWES").on('change', function(e) {			
				getStockPopMarketES("CW");
			});
		});
		
		function getSubAccountS() {
			var param = {
					mvClientID	:	"<%= session.getAttribute("clientID") %>"
				};

				$.ajax({
					dataType  : "json",
					cache		: false,
					url       : "/trading/data/getSubAccount.do",
					data      : param,
					success   : function(data) {
						//console.log("Sub Account List");
						//console.log(data);
						$("#subAccountS option").remove();
						$("#accTypeNameS").text('');
						for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
							$("#subAccountS").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + "</option>");
							$("#subAccountTypeNameS").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].investorTypeName + "</option>");
						}
						$("#subAccountS").val(<%= session.getAttribute("tradingAccSeq") %>);
						$("#subAccountTypeNameS").val(<%= session.getAttribute("tradingAccSeq") %>)
						$("#accTypeNameS").text($("#subAccountTypeNameS option:selected").text());
					},
					error     :function(e) {					
						console.log(e);
					}
				});
		}
		
		function chgTypeNameS(val)
		{
			$("#subAccountTypeNameS").val(val)
			$("#accTypeNameS").text($("#subAccountTypeNameS option:selected").text());
		}
		function chgSubAccountS(val) {			
			chgTypeNameS(val);
			changeSubAccount1($("#subAccountS option:selected").text(), val);						
		}
		
		function getStockPopES() {
			var param = {
				  stockCd  :  $("#schNamePopES").val()
				, marketId :  $("input[name=schMarketPopES]:checked").val()
			};	
			//console.log(param);
			$.ajax({
				url      : "/trading/data/getMarketStockList.do",
				data     : param,
				aync     : true,
				dataType : 'json',
				success  : function(data){
					if(data.stockList != null) {
						var stockStr = "";
						for(var i=0; i < data.stockList.length; i++) {
							var stockList = data.stockList[i];
							var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
							stockStr += "<tr onclick=\"selectRowPopES('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
							stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
							stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
							stockStr += "</tr>";
						}
						$("#grdStockPopES").html(stockStr);
					}					
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		function getStockPopMarketES(market) {
			var sM;
			if (market == "CW") {
				sM = "HOSE"
			} else {
				sM = market;
			}
			
			var param = {
				  stockCd  :  ""
				, marketId :  sM
			};	
			//console.log(param);
			$.ajax({
				url      : "/trading/data/getMarketStockList.do",
				data     : param,
				aync     : true,
				dataType : 'json',
				success  : function(data){
					if(data.stockList != null) {
						var stockStr = "";
						for(var i=0; i < data.stockList.length; i++) {
							var stockList = data.stockList[i];
							if (market == "CW") {
								if (stockList.snum == "W") {
									var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
									stockStr += "<tr onclick=\"selectRowPopES('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
									stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
									stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
									stockStr += "</tr>";
								}
							} else {
								var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<tr onclick=\"selectRowPopES('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
								stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
								stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
								stockStr += "</tr>";
							}
						}
						$("#grdStockPopES").html(stockStr);
					}					
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		function searchStockES(evt) {
			$("#schNamePopES").val($("#schNamePopES").val().toUpperCase());
			
			if(evt.keyCode == 13) {
				clearTimeout(keyup_timeout); // Clear the previous timeout so that it won't be executed any more. It will be overwritten by a new one below.
		        keyup_timeout = setTimeout(function() {
		            // Perform your magic here.
		        }, timeout_delay_in_ms);
				
				getStockPopES();
			}
		}
		
		function selectRowPopES(symb) {
			selItem(symb);
			$(".layer_search_ES .layer_ES").hide();
		}

		function Ext_SetOrderStock(stock, sub) {
			
			clearData();
			if (sub != undefined) {
				subAcc = sub;
			}
			$("#tab49").find("#stockS").val(stock);
			$("#tab49").find("span[name='s_bid_mark']").html($("#tab31").find("span[name='bid_mark']").html());
			$("#tab49").find("span[name='s_bid_divi']").html($("#tab31").find("span[name='bid_divi']").html());
			getStock();
		}
	
		function chkExpiryDate() {
			if($("#tab49").find("#chkExpiryS").is(":checked")) {
				$("#tab49").find("#chkExpiryS").val("on");
				$("#tab49").find("#expiryDateS").attr("disabled", false);
				$("#tab49").find("#expiryDateS").datepicker("enable");
				
				if($("#chkConditionS").is(":checked")) {
					$('#chkConditionS').prop('checked', false);
					$("#tab49").find("#ojCondTypeS").attr("disabled", true);
					$("#tab49").find("#stopPriceViewS").attr("disabled", true);
					
					$("#tab49").find("#chkConditionS").val("N");
					$("#tab49").find("#ojCondTypeS").val("U");
					$("#tab49").find("#stopPriceViewS").val("0");
				}
				
			} else {
				$("#tab49").find("#chkExpiryS").val("off");
				$("#tab49").find("#expiryDateS").attr("disabled", true);
				$("#tab49").find("#expiryDateS").datepicker("disable");
			}
		}
		
		function chkOrderConditionS() {
			if($("#chkConditionS").is(":checked")) {
				$("#tab49").find("#ojCondTypeS").attr("disabled", false);
				$("#tab49").find("#stopPriceViewS").attr("disabled", false);								
				
				if($("#chkExpiryS").is(":checked")) {
					$('#chkExpiryS').prop('checked', false);
					$("#tab49").find("#chkExpiryS").val("off");
					$("#tab49").find("#expiryDateS").attr("disabled", true);
					$("#tab49").find("#expiryDateS").datepicker("disable");
				}
			} else {
				$("#tab49").find("#ojCondTypeS").attr("disabled", true);
				$("#tab49").find("#stopPriceViewS").attr("disabled", true);
				
				$("#tab49").find("#chkConditionS").val("N");
				$("#tab49").find("#ojCondTypeS").val("U");
				$("#tab49").find("#stopPriceViewS").val("0");
			}
		}
	
		function chkAdvancedDate() {
			if($("#tab49").find("#chkAdvanced").is(":checked")) {
				$("#tab49").find("#chkAdvanced").val("on");
				$("#tab49").find("#advancedDate").attr("disabled", false);
			} else {
				$("#tab49").find("#chkAdvanced").val("off");
				$("#tab49").find("#advancedDate").attr("disabled", true);
			}
		}
	
		function getEnterOrder() {
			$("#tab49").block({message: "<span>LOADING...</span>"});
			var param = {
					mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>")					
			};
			$.ajax({
				dataType  : "json",
				url       : "/trading/data/genenterorder.do",
				asyc      : true,
				cache	  : false,
				data	  : param,
				success   : function(data) {
					if(data.jsonObj != null) {
						var entOrd = data.jsonObj.genEnterOrderBean;						
						if ($("#tab49").find("#mvMarketId").val() == "") {
							$("#tab49").find("#mvMarketIdS").val(entOrd.mvMarketID);
						}
						
						$("#tab49").find("#mvActionS").val("OI,BP,FE");
						$("#tab49").find("#todayS").val(entOrd.mvDateTime.substring(0, 10));
						$("#tab49").find("#expiryDateS").datepicker({
							showOn      : "button",
							dateFormat  : "dd/mm/yy",
							changeYear  : true,
							changeMonth : true
						});
						$("#tab49").find("#expiryDateS").datepicker("setDate", entOrd.mvDateTime.substring(0, 10));
						$("#tab49").find("#expiryDateS").attr("disabled", true);
						$("#tab49").find("#expiryDateS").datepicker("disable");
						
						for(var i = 0; i < data.jsonObj.mvSettlementAccList.length; i++) {
							var obj	=	data.jsonObj.mvSettlementAccList[i];
							if(obj.mvBankID != "" ) {
								$("#tab49").find("#mvBankIDS").val(obj.mvBankID);
								$("#tab49").find("#mvBankACIDS").val(obj.mvBankACID);
								$("#tab49").find("#bankAccountYn").val("Y");
							}
						}
					}
					$("#tab49").unblock();
				},
				error     :function(e) {
					console.log(e);
					$("#tab49").unblock();
				}
			});
		}
	
		function getStock(e) {
			var $this;
			var $tab;
			var	$layer;
			var $ulblock;
			var tabid	=	"";
			if(e == undefined) {
				$this	=	$("#tab49").find("#stockS");
				$tab	=	$("#tab49");
				$layer	=	$("#tab49").find("#divOrdStock");
				$ulblock=	$("#tab49").find("#ulOrdStock");
				
				tabid	=	"stock";
			} else {
				if(e.target.id == "bidStock") {
					$this	=	$("#bidStock");
					$tab	=	$("#tab31");
					$layer	=	$("#divBidStock");
					$ulblock=	$("#ulBidStock");
					tabid	=	"bidStock";
				} else {
					$this	=	$("#tab49").find("#stockS");
					$tab	=	$("#tab49");
					$layer	=	$("#tab49").find("#divOrdStock");
					$ulblock=	$("#tab49").find("#ulOrdStock");
					tabid	=	"stock";
				}
			}
			
			
			if (e != undefined) {
				var key = e.keyCode;
				if (key == 13) {
					var idx;
					if(e.target.id == "bidStock") {
						idx = $('#divBidStock').find("li.active").index();
					} else {
						idx = $("#tab49").find('#divOrdStock').find("li.active").index();
					}
					var stockList = tmpData[idx];
					stockSelected(stockList.synm, stockList.marketId, tabid);
					$this.blur(); 
					return;
				}
				else if ( key == 40 ) // Down key
			    {
			    	if(e.target.id != "bidStock") {
			    		if ($("#tab49").find('#divOrdStock').find("li:last").hasClass("active")) {
			    			$("#tab49").find("#divOrdStock li.active").removeClass("active");
			    			$("#tab49").find('#divOrdStock').find("li:first").focus().addClass("active");
			    		} else {
					    	if($("#tab49").find("#divOrdStock li.active").length!=0) {				    		
				                var storeTarget = $("#tab49").find('#divOrdStock').find("li.active").next();
				                $("#tab49").find("#divOrdStock li.active").removeClass("active");
				                storeTarget.focus().addClass("active");
				                $("#tab49").find('#divOrdStock').animate({
				                    scrollTop: storeTarget.position().top + $("#tab49").find("#divOrdStock").scrollTop()
				                }, 'slow');
				            }
				            else {
				                $("#tab49").find('#divOrdStock').find("li:first").focus().addClass("active");
				            }
			    		}
			    	} else {
			    		if ($('#divBidStock').find("li:last").hasClass("active")) {
			    			$("#divBidStock li.active").removeClass("active");
			    			$('#divBidStock').find("li:first").focus().addClass("active");
			    		} else {
				    		if($("#divBidStock li.active").length!=0) {
				                var storeTarget = $('#divBidStock').find("li.active").next();
				                $("#divBidStock li.active").removeClass("active");
				                storeTarget.focus().addClass("active");
				                $('#divBidStock').animate({
				                    scrollTop: storeTarget.position().top + $("#divBidStock").scrollTop()
				                }, 'slow');
				            }
				            else {
				                $('#divBidStock').find("li:first").focus().addClass("active");
				            }
			    		}
			    	}
			    	e.preventDefault();
		            return ;
			    }
			    else if ( key == 38 ) // Up key
			    {
			    	if(e.target.id != "bidStock") {
			    		if ($("#tab49").find('#divOrdStock').find("li:first").hasClass("active")) {
			    			$("#tab49").find("#divOrdStock li.active").removeClass("active");
			    			$("#tab49").find('#divOrdStock').find("li:last").focus().addClass("active");
			    		} else {
					    	if($("#tab49").find("#divOrdStock li.active").length!=0) {
				                var storeTarget = $("#tab49").find('#divOrdStock').find("li.active").prev();
				                $("#tab49").find("#divOrdStock li.active").removeClass("active");
				                storeTarget.focus().addClass("active");
				                $("#tab49").find('#divOrdStock').animate({
				                    scrollTop: storeTarget.position().top + $("#tab49").find("#divOrdStock").scrollTop()
				                }, 'slow');
				            }
				            else {
				                $("#tab49").find('#divOrdStock').find("li:last").focus().addClass("active");
				            }
			    		}
			    	} else {
			    		if ($('#divBidStock').find("li:first").hasClass("active")) {
			    			$("#divBidStock li.active").removeClass("active");
			    			$('#divBidStock').find("li:last").focus().addClass("active");
			    		} else {
				    		if($("#divBidStock li.active").length!=0) {
				                var storeTarget = $('#divBidStock').find("li.active").prev();
				                $("#divBidStock li.active").removeClass("active");
				                storeTarget.focus().addClass("active");
				                $('#divBidStock').animate({
				                    scrollTop: storeTarget.position().top + $("#divBidStock").scrollTop()
				                }, 'slow');
				            }
				            else {
				                $('#divBidStock').find("li:last").focus().addClass("active");
				            }
			    		}
			    	}
			    	e.preventDefault();
		            return ;
			    }
			    
			}

			$this.val(xoa_dau($this.val().toUpperCase()));
			if($this.val() == "") {
				$layer.hide();
				return;
			}
			
			$tab.block({message: "<span>LOADING...</span>"});
			var param	=	{
					stockCd	:	$this.val()
					, marketId	:	"ALL"
			};
			
			$.ajax({
				url      : "/trading/data/getMarketStockList.do",
				data     : param,
				dataType : 'json',
				success  : function(data){
					$layer.show();	
					if(data.stockList.length != null) {
						var stockStr	=	"";
						tmpData = data.stockList;
						if(data.stockList.length == 1) {
							if ($this.val().length > 2) {
							var stockList = data.stockList[0];
							var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
							stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
							$layer.hide();
							$this.val(stockList.synm);
							$("#tab49").find('#mvMarketIdS').attr("value", displayMarketID(stockList.marketId));
							watchListSelect = false;
							if(tabid == 'bidStock') {
								selItem(stockList.synm);
							} else {
								//trueAccountBal();
								stockChange();
							}
							} else {
								var stockList = data.stockList[0];
								var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
								$tab.unblock();
							}
						} else if(data.stockList.length > 1) {
							for(var i=0; i < data.stockList.length; i++) {
								var stockList = data.stockList[i];
								var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
							}
							if (e == undefined) {
								for(var i=0; i < data.stockList.length; i++) {
									var stockList = data.stockList[i]; 
									if (stockList.synm == $this.val()) {
										var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
										stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
										$layer.hide();
										$this.val(stockList.synm);
										$("#tab49").find('#mvMarketIdS').attr("value", displayMarketID(stockList.marketId));
										watchListSelect = false;
										if(tabid == 'bidStock') {
											selItem(stockList.synm);
										} else {
											//trueAccountBal();
											stockChange();
										}
									}									
								}
								$layer.hide();
							}
							$tab.unblock();
						} else {
							if ("<%= langCd %>" == "en_US") {
								alert($this.val() + " is not exist,please enter again!");	
							} else {
								alert($this.val() + " không tồn tại, vui lòng nhập lại!");
							}
							$this.val("").focus();
							$layer.hide();
							$tab.unblock();
						}
						$("#tab49").find("#ulOrdStock").html(stockStr);
						$("#ulBidStock").html(stockStr);
					} else {
						$tab.unblock();
					}
				},
				error     :function(e) {
					console.log(e);
					tab.unblock();
				}
			});
		}
	
		function divOrdShowHide() {
			if($("#tab49").find("#divOrdStock").css("display") == "none") {
				$("#tab49").find("#divOrdStock").show();
			} else {
				$("#tab49").find("#divOrdStock").hide();
			}
		}
	
		function stockSelected(val, market, tabid) {
			if (market == "" || market == null || market == "null"|| market == undefined) {
				selItem(val);
			} else {
				if(tabid == undefined) {
					$("#tab49").find("#divOrdStock").hide();
					$("#tab49").find("#stockS").val(val);
					$("#tab49").find('#mvMarketIdS').attr("value", displayMarketID(market));
					watchListSelect = false;
					stockChange();
				} else {
					var targetId	=	tabid;
					if(targetId == 'bidStock') {
						$("#divBidStock").hide();
						$("#bidStock").val(val);
						selItem(val);
					} else {
						$("#tab49").find("#divOrdStock").hide();
						$("#tab49").find("#stockS").val(val);
						$("#tab49").find('#mvMarketIdS').attr("value", displayMarketID(market));
						watchListSelect = false;
						stockChange();
					}
				}
			}
		}
	
		function setOrderTypeS(marketId) {
			$("#tab41").find("#orderTypeB").find("option").remove();
			
			//ATC, ATO, MAK, MOK, MTL, MP일때 최고가 대비 value, net fee 계산함
			var marketStatus = "";
			var param = {
					mvMarketID           : marketId,
					mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>")
			};

			$.ajax({
				dataType  : "json",
				url       : "/margin/data/queryMarketStatusInfo.do",
				data      : param,
				asyc      : true,
				success   : function(data) {
					$("#orderTypeS").find("option").remove();
					if(data != null) {
						if(data.jsonObj.mvMarketID == "HO") {
							marketStatus = data.jsonObj.mvMarketStatus;
						}
						if(marketId == "HO") {							
							if (marketStatus == "T3") {
								$("#tab49").find("#orderTypeS").append(new Option("LO", "L", true, true));
								$("#tab49").find("#orderTypeS").append(new Option("ATC", "C", true, true));
							} else {
								$("#tab49").find("#orderTypeS").append(new Option("LO", "L", true, true));
								$("#tab49").find("#orderTypeS").append(new Option("ATO", "O", true, true));
								$("#tab49").find("#orderTypeS").append(new Option("ATC", "C", true, true));
								$("#tab49").find("#orderTypeS").append(new Option("MP", "M", true, true));
							}
						} else if(marketId == "HA") {
							$("#tab49").find("#orderTypeS").append(new Option("LO", "L", true, true));
							$("#tab49").find("#orderTypeS").append(new Option("ATC", "C", true, true));
							$("#tab49").find("#orderTypeS").append(new Option("MAK", "Z", true, true));
							$("#tab49").find("#orderTypeS").append(new Option("MOK", "B", true, true));
							$("#tab49").find("#orderTypeS").append(new Option("MTL", "R", true, true));
							$("#tab49").find("#orderTypeS").append(new Option("PLO", "J", true, true));
							$("#tab49").find("#orderTypeS").append(new Option("LO(Odd Lot)", "LO", true, true));
						} else if(marketId == "OTC") {
							$("#tab49").find("#orderTypeS").append(new Option("LO", "L", true, true));
							$("#tab49").find("#orderTypeS").append(new Option("LO(Odd Lot)", "LO", true, true));
						}
						$("#tab49").find("#orderTypeS").val($("#orderTypeS option:eq(0)").val());
					}
				},
				error     :function(e) {
					console.log(e);
				}
			});			
		}
	
		function stockChange() {
			//console.log("+++Stock null CHECK+++");
			if($("#tab49").find("#stockS").val() == ""){
				//console.log("+++Stock null CHECK+++");
				return;
			}
			
			setOrderTypeS($("#tab49").find("#mvMarketIdS").val());
			$("#tab49").find("#mvInstrumentS").val($("#tab49").find("#stockS").val());
			$("#tab49").find("#mvEnableGetStockInfoS").val("N");
	
			var param = {
					mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>"),
					mvInstrument         : $("#tab49").find("#mvInstrumentS").val(),
					mvMarketID           : $("#tab49").find("#mvMarketIdS").val(),
					mvBS                 : "S",
					mvAction             : $("#tab49").find("#mvActionS").val()
			};
			//console.log("STOCK CHNge");
			//console.log(param)
			$("#tab49").block({message: "<span>LOADING...</span>"});
			$.ajax({
				dataType  : "json",
				url       : "/trading/data/stockInfo.do",
				data      : param,
				asyc      : true,
				cache	  : false,
				success   : function(data) {
					//console.log("++++++++++++SELL STOCK CHANGE CHECK++++++");
					//console.log("+++DATA CHECK SELL+++");
					//console.log(data);
					if(data.jsonObj != null) {
						var stock = data.jsonObj.mvStockInfoBean;	
						
						$("#tab49").find("#mvStockNameS").val(stock.mvStockName);
						$("#tab49").find("#mvCeilingS").val(numDotComma(stock.mvCeiling));
						$("#tab49").find("#mvFloorS").val(numDotComma(stock.mvFloor));
						$("#tab49").find("#maxMarginS").val(stock.mvAvailableMarginVol);
						$("#tab49").find("#trMaxMargin").html(stock.mvAvailableMarginVol);
						$("#tab49").find("#lendingS").val("");
						$("#tab49").find("#lbLending").html("");
						$("#tab49").find("#buyingPowerS").val("");
						$("#tab49").find("#trBuyingPower").html("");
						$("#tab49").find("#mvActionS").val("OI,BP");
	
						if(stock.mvTemporaryFee != null) {
							$("#tab49").find("#mvTemporaryFeeS").val(stock.mvTemporaryFee);
						}
						
						var bef_rcod	=	$("#tab31").find("span[name='bid_rcod']").html();
						if(bef_rcod != "" && bef_rcod != null) {
							bef_rcod	=	bef_rcod.substring(0,3);
							if(bef_rcod != $("#tab49").find("#stockS").val()) {
								trdSelItemNoOrd($("#tab49").find("#mvInstrumentS").val(), $("#tab49").find("#mvMarketIdS").val());	
							}
						} else {
							trdSelItemNoOrd($("#tab49").find("#mvInstrumentS").val(), $("#tab49").find("#mvMarketIdS").val());
						}
						$("#tab49").find("span[name='bid_rcod']").html($("#tab49").find("#stockS").val() + "&nbsp;|&nbsp;" + convMarketId($("#tab49").find("#mvMarketIdS").val()));
						var bef_sname = $("#tab31").find("span[name='bid_snam']").html();
						$("#tab49").find("span[name='bid_snam']").html(bef_sname);
						
						$("#tab49").find("#ordMarketS").val(stock.spreadTableCode);
					} else {
						$("#tab49").find("#mvStockNameS").val("");
						$("#tab49").find("#mvCeilingS").val("");
						$("#tab49").find("#mvFloorS").val("");
						$("#tab49").find("#maxMarginS").val("");
						$("#tab49").find("#trMaxMargin").html("");
						$("#tab49").find("#lendingS").val("");
						$("#tab49").find("#lbLending").html("");
						$("#tab49").find("#buyingPowerS").val("");
						$("#tab49").find("#trBuyingPower").html("");
						$("#tab49").find("#mvActionS").val("OI,BP");
						$("#tab49").find("#mvTemporaryFeeS").val(0);
						var bef_rcod	=	$("#tab31").find("span[name='bid_rcod']").html();
						if(bef_rcod != "" && bef_rcod != null) {
							bef_rcod	=	bef_rcod.substring(0,3);
							if(bef_rcod != $("#tab49").find("#stockS").val()) {
								trdSelItemNoOrd($("#tab49").find("#mvInstrumentS").val(), $("#tab49").find("#mvMarketIdS").val());	
							}
						} else {
							trdSelItemNoOrd($("#tab49").find("#mvInstrumentS").val(), $("#tab49").find("#mvMarketIdS").val());
						}
						$("#tab49").find("span[name='bid_rcod']").html($("#tab49").find("#stockS").val() + "&nbsp;|&nbsp;" + convMarketId($("#tab49").find("#mvMarketIdS").val()));
						var bef_sname = $("#tab31").find("span[name='bid_snam']").html();
						$("#tab49").find("span[name='bid_snam']").html(bef_sname);
						if(bef_rcod != "" && bef_rcod != null) {
							bef_rcod	=	bef_rcod.substring(0,3);
							if(bef_rcod != $("#tab49").find("#stockS").val()) {
								trdSelItemNoOrd($("#tab49").find("#mvInstrumentS").val(), $("#tab49").find("#mvMarketIdS").val());	
							}
						}
					}
					$("#tab49").unblock();
				},
				error     :function(e) {
					//console.log(e);
					$("#tab49").unblock();
					
					var bef_rcod	=	$("#tab31").find("span[name='bid_rcod']").html();
					if(bef_rcod != "" && bef_rcod != null) {
						bef_rcod	=	bef_rcod.substring(0,3);
						if(bef_rcod != $("#tab49").find("#stockS").val()) {
							trdSelItemNoOrd($("#tab49").find("#mvInstrumentS").val(), $("#tab49").find("#mvMarketIdS").val());	
						}
					}
					$("#tab49").unblock();
				}
			});
		}
		
		function convMarketId(markId) {
			switch(markId) {
				case	"HO":
					markId	=	"HOSE";
					break;
				case	"HA":
					markId	=	"HNX";
					break;
				case	"OTC":
					markId	=	"UPCOM";
					break;
			}
			return markId;
		}
	
		function onFocusIn(tagId) {
			if($("#tab49").find("#" + tagId).val() == "0") {
				$("#tab49").find("#" + tagId).val('');
			}
		}
	
		function onFocusOut(tagId) {
			if($("#tab49").find("#" + tagId).val() == "") {
				$("#tab49").find("#" + tagId).val('');
			}
		}
	
		function volumeChange(e) {
			if (e != undefined) {
				if (e.which >= 37 && e.which <= 40) return;
			}
			var volumeView = $("#tab49").find("#volumeViewS").val().replace(/[,.]/g,'');			
			if (volumeView.indexOf('0') == 0) {
				volumeView = volumeView.substring(1);
			}
			
			if($("#tab49").find("#orderTypeS").val() == "L" || $("#tab49").find("#orderTypeS").val() == "LO") {
				if(volumeView > 0 ) {
					$("#tab49").find("#volumeS").val(Number(volumeView));
					$("#tab49").find("#volumeViewS").val(numIntFormat(volumeView));
					volPriceSum();
				} else if(Number(volumeView) <= 0) {
					$("#tab49").find("#volumeS").val(0);
					$("#tab49").find("#volumeViewS").val('');
				}
			} else {
				//매수일경우 상한가로 계산
				$("#tab49").find("#priceS").val($("#tab49").find("#mvFloorS").val().replace(/[,.]/g,''));
				$("#tab49").find("#priceViewS").val(numIntFormat($("#tab49").find("#mvFloorS").val().replace(/[,.]/g,'')));
				if(volumeView > 0 ) {
					$("#tab49").find("#volumeS").val(Number(volumeView));
					$("#tab49").find("#volumeViewS").val(numIntFormat(volumeView));
					volPriceSum();
				} else if(Number(volumeView) <= 0) {
					$("#tab49").find("#volumeS").val(0);
					$("#tab49").find("#volumeViewS").val('');
				}
			}
		}
	
		function priceChange(e) {
			if (e != undefined) {
				if (e.which >= 37 && e.which <= 40) return;
			}
			var priceView  = $("#tab49").find("#priceViewS").val().replace(/,/g,'').replace('.','');
			if(priceView.indexOf('.') != -1) {
				var priceSpl = priceView.split(".");
				if(priceSpl[1].length > 1) {
					priceView = priceSpl[0] + "." + priceSpl[1].substring(0, 2);
				}
			} else {
				if (priceView.indexOf('0') == 0) {
					priceView = priceView.substring(1);
				}
			}
	
			if(priceView > 0) {
				$("#tab49").find("#priceS").val(numIntFormat(priceView));
				$("#tab49").find("#priceViewS").val(numIntFormat(priceView));
				volPriceSum();
			} else if(priceView == 0) {
				$("#tab49").find("#priceS").val(0);
				$("#tab49").find("#priceViewS").val('');
				volPriceSum();
			}
		}
		
		function stopPriceChange(e) {
			var sPriceView  = $("#stopPriceViewS").val().replace(/,/g,'').replace('.','');
			if(sPriceView > 0) {
				$("#stopPriceViewS").val(numIntFormat(sPriceView));
			} else {
				$("#stopPriceViewS").val(0);
			}
		}
	
		function isNum() {
			var key	=	event.keyCode;
			if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)) {
				event.returnValue	=	false;
			}
		}
		
		
		function volPriceSum() {
			var price   = numDotComma($("#tab49").find("#priceS").val());
			var volume  = numDotComma($("#tab49").find("#volumeS").val());
			var tmpFee  = $("#tab49").find("#mvTemporaryFeeS").val();
			var valSum  = 0;
			var netFee  = 0;
	
			valSum = price  * volume;
			netFee = valSum * tmpFee;
			netFee = Math.round(netFee / 100, 1);
			$("#tab49").find("#valueS").val(numIntFormat(valSum));
			$("#tab49").find("#trValue").html(numIntFormat(valSum));
			$("#tab49").find("#netFeeS").val(numIntFormat(netFee));
			$("#tab49").find("#trNetFee").html(numIntFormat(netFee));
		}
	
		function clearData() {
			$("#tab49").find("#orderTypeS").val($("#tab49").find("#orderTypeS option:eq(0)").val());
			chgOrdType($("#orderTypeS option:eq(0)").val());
			$("#tab49").find("#volumeS").val("");
			$("#tab49").find("#priceS").val("");
			$("#tab49").find("#stockS").val("");
			$("#tab49").find("#trValue").html("0");
			$("#tab49").find("#trNetFee").html("0.00");
			$("#tab49").find("#volumeViewS").val('');
			$("#tab49").find("#priceViewS").val('');
			$("#tab49").find("#chkExpiryS").attr("disabled", false);
			$("#tab49").find("#chkExpiryS").val("off").attr("checked", false);
			$("#tab49").find("chkAdvanced").val("off").attr("checked", false);
	
			$("#tab49").find("#expiryDateS").datepicker("setDate", $("#tab49").find("#todayS").val());
			
			$("#chkConditionS").attr("checked", false);
			$("#tab49").find("#chkConditionS").attr("disabled", false);
			$("#tab49").find("#ojCondTypeS").attr("disabled", true);
			$("#tab49").find("#stopPriceViewS").attr("disabled", true);
			$("#chkConditionS").val("N");
			$("#ojCondTypeS").val("U");
			$("#stopPriceViewS").val("0");
		}
		
		function bidClearData() {
			$("#tab49").find("#priceS").val("");
			$("#tab49").find("#trValue").html("0");
			$("#tab49").find("#trNetFee").html("0.00");
			
			$("#tab49").find("#priceViewS").val('');
			$("#tab49").find("#chkExpiryS").val("off").attr("checked", false);
			$("#tab49").find("chkAdvanced").val("off").attr("checked", false);
	
			$("#tab49").find("#expiryDateS").datepicker("setDate", $("#tab49").find("#todayS").val());
		}
	
		function enterSellSubmit() {
			$("#tab49").find("#mvStockNameS").val($("#tab31").find("span[name='bid_snam']").html());
			enterOpenPopupBuySell = true;
			var priceView  = numDotComma($("#tab49").find("#priceViewS").val());
			var volumeView = numDotComma($("#tab49").find("#volumeViewS").val());
			
			 if (priceView == "" || priceView == "0") {
			 if($("#tab49").find("#orderTypeS").val() == "L" || $("#tab49").find("#orderTypeS").val() == "LO") {
				$("#tab49").find("#priceViewS").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Price!");	
				} else {
					alert("Vui lòng nhập giá!");
				}
				return;
			}
			 }
			 
			if($("#tab49").find("#orderTypeS").val() == "" || $("#tab49").find("#orderTypeS").val() == "null" ||  $("#tab49").find("#orderTypeS").val() == null) {
				$("#tab49").find("#orderTypeS").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please select the Order Type!");	
				} else {
					alert("Vui lòng chọn loại lệnh!");
				}
				return;
			}
			
			if($("#tab49").find("#stockS").val() == "") {
				$("#tab49").find("#stockS").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Stock Code!");	
				} else {
					alert("Vui lòng nhập mã chứng khoán!");
				}
				return;
			}
			
			if($("#chkConditionS").is(":checked")) {
				if ($("#stopPriceViewS").val() == "" || $("#stopPriceViewS").val() == "0"){
					if ("<%= langCd %>" == "en_US") {
						alert("Please enter stop price!");	
					} else {
						alert("Vui lòng nhập giá dừng!");
					}
					return;
				}
			}
	
			if($("#tab49").find("#volumeS").val() == 0) {
				$("#tab49").find("#volumeViewS").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Quantity!");	
				} else {
					alert("Vui lòng nhập số lượng!");
				}
				return;
			}
			
			if($("#tab49").find("#orderTypeS").val() == "LO") {
				if($("#tab49").find("#mvMarketIdS").val() == "HA" || $("#tab49").find("#mvMarketIdS").val() == "OTC") {
					if (volumeView >= 100) {
						if ("<%= langCd %>" == "en_US") {
							alert("Can not odd lot order with this volume. Volume have to less than 100!");	
						} else {
							alert("Không thể đặt lệnh lô lẻ với khối lượng này. Khối lượng phải nhỏ hơn 100!");
						}
						return;
					}					
				}
			}
	
		if($("#tab49").find("#orderTypeS").val() == "L" || $("#tab49").find("#orderTypeS").val() == "LO") {
			if(priceView > 0) {
				if($("#tab49").find("#mvMarketIdS").val() == "HO") {
					if ($("#tab49").find("#ordMarketS").val() == "HO_ETF") {
						if(priceView <= 10000) {
							if(priceView % 10 != 0) {
								$("#tab49").find("#priceViewS").focus();
								if ("<%= langCd %>" == "en_US") {
									alert("Invalid Price ticksize 10.");	
								} else {
									alert("Giá không hợp lệ cho bước giá 10.");
								}
								return;
							}
						}
					} else {
					if(priceView <= 10000) {
						if(priceView % 10 != 0) {
							$("#tab49").find("#priceViewS").focus();
							if ("<%= langCd %>" == "en_US") {
								alert("Invalid Price ticksize 10.");	
							} else {
								alert("Giá không hợp lệ cho bước giá 10.");
							}
							return;
						}
					} else if(priceView > 10000 && priceView <= 49500) {
						if(priceView % 50 != 0) {
							$("#tab49").find("#priceViewS").focus();
							if ("<%= langCd %>" == "en_US") {
								alert("Invalid Price ticksize 50.");	
							} else {
								alert("Giá không hợp lệ cho bước giá 50.");
							}
							return;
						}
					} else if(priceView >= 50000) {
						if(priceView % 100 != 0) {
							$("#tab49").find("#priceViewS").focus();
							if ("<%= langCd %>" == "en_US") {
								alert("Invalid Price ticksize 100.");	
							} else {
								alert("Giá không hợp lệ cho bước giá 100.");
							}
							return;
						}
					}
					
					}
				} else if($("#tab49").find("#mvMarketIdS").val() == "HA") {
					if(priceView % 10 != 0) {
						$("#tab49").find("#priceViewS").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 10.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 10.");
						}
						return;
					}
				} else if($("#tab49").find("#mvMarketIdS").val() == "OTC") {
					if(priceView % 10 != 0) {
						$("#tab49").find("#priceViewS").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 10.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 10.");
						}
						return;
					}
				}
			}

	
		}
			if(numDotComma($("#tab49").find("#priceS").val()) == 0) {
				$("#tab49").find("#priceViewS").focus();
				alert("Please enter the Price!");
				return;
			}
		
			var ex = $("#tab49").find("#expiryDateS").val();
			var a = ex.split('/');
			var date = new Date (a[2], a[1] - 1,a[0]);//using a[1]-1 since Date object has month from 0-11
			var Today = new Date();
			if (date > Today && $("#tab49").find("#chkExpiryS").is(":checked")) {
				
			} else {			
				if(numDotComma($("#tab49").find("#priceS").val()) > 0) {
					if((parseFloat($("#tab49").find("#mvFloorS").val()) > parseFloat(numDotComma($("#tab49").find("#priceS").val()))) || (parseFloat($("#tab49").find("#mvCeilingS").val()) < parseFloat(numDotComma($("#tab49").find("#priceS").val())))) {
						$("#tab49").find("#priceViewS").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Order price is out of price spread (" + numIntFormat($("#tab49").find("#mvFloorS").val()) + " to " + numIntFormat($("#tab49").find("#mvCeilingS").val()) + "), please input again!");	
						} else {
							alert("Giá đặt nằm ngoài biên độ từ (" + numIntFormat($("#tab49").find("#mvFloorS").val()) + " đến " + numIntFormat($("#tab49").find("#mvCeilingS").val()) + "), vui lòng nhập lại!");
						}
						return;
					}
				}
			}

			if($("#tab49").find("#chkExpiryS").is(":checked")) {
				sellOpen();
			} else {
				queryMarketStatusInfo();
			}
		}
	
		function queryMarketStatusInfo() {
			$("#tab49").find("#tab49").block({message: "<span>LOADING...</span>"});
			//fix bug market ID = ""
			var marketId	=	$("#tab49").find("#mvMarketIdS").val();
			if(marketId == "" || marketId == "null" || marketId == null) {			
				var bef_rmark	=	$("#tab31").find("input[name='bidMark']").val();
				marketId	=	displayMarketID(bef_rmark);
				$("#tab49").find("#mvMarketIdS").val(marketId);
			}
			var param = {
					mvMarketID           : $("#tab49").find("#mvMarketIdS").val(),
					mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>")
			};
			
			//console.log("queryMarketStatusInfo");
			//console.log(param);
	
			$.ajax({
				dataType  : "json",
				url       : "/margin/data/queryMarketStatusInfo.do",
				data      : param,
				asyc      : true,
				cache 	  : false,
				success   : function(data) {
					//console.log("queryMarketStatusInfo Result");
					//console.log(data);
					if(data.jsonObj != null) {
						$("#tab49").unblock();
						if(data.jsonObj.mvMarketID == "HO") {
							if(data.jsonObj.mvMarketStatus == "T1" || data.jsonObj.mvMarketStatus == "T2" || data.jsonObj.mvMarketStatus == "T3"|| data.jsonObj.canEnterOrder  == "true") {
								sellOpen();
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
								sellOpen();
							}
						} else if(data.jsonObj.mvMarketID == "OTC") {
							if(data.jsonObj.mvMarketStatus == null || data.jsonObj.mvMarketStatus == "13") {
								if ("<%= langCd %>" == "en_US") {
									alert("Out of time for order in " + displayMarketCode(data.jsonObj.mvMarketID));
								} else {
									alert("Hết thời gian đặt lệnh " + displayMarketCode(data.jsonObj.mvMarketID));
								}
							} else {
								sellOpen();
							}
						}
					}
				},
				error     :function(e) {
					console.log(e);
					$("#tab49").unblock();
				}
			});
		}
	
		function sellOpen() {
			var expiryDate   = ($("#tab49").find("#chkExpiryS").is(":checked") ? $("#tab49").find("#expiryDateS").val() : "");
			var advancedDate = ($("#tab49").find("#chkAdvanced").is(":checked") ? $("#tab49").find("#advancedDate").val() : "");
			$("#tab49").find("#orderTypeNmS").val($("#tab49").find("#orderTypeS option:selected").text());
			$("#tab49").find("#expiryDtS").val(expiryDate);
			$("#tab49").find("#advancedDtS").val(advancedDate);
			
			if ($("#chkConditionS").is(":checked")) {			
				$("#mvStopS").val("Y");
				$("#mvStopTypeS").val($("#ojCondTypeS").val());
				$("#mvStopPriceS").val($("#stopPriceViewS").val());
			} else {
				$("#mvStopS").val("N");
				$("#mvStopTypeS").val("");
				$("#mvStopPriceS").val("");
			}
			
			//fix bug market ID = ""
			var marketId	=	$("#tab49").find("#mvMarketIdS").val();
			if(marketId == "" || marketId == "null" || marketId == null) {
				var bef_rmark	=	$("#tab31").find("input[name='bidMark']").val();
				marketId	=	displayMarketID(bef_rmark);
				$("#tab49").find("#mvMarketIdS").val(marketId);
			}
			enterOpenPopupBuySell = true;
			$.ajax({
				type     : "POST",
				url      : "/trading/popup/sellConfirm.do",
				data     : $("#tab49").find("#frmEnterSell").serialize(),
				dataType : "html",
				success  : function(data){
					$("#divEnterSellPop").fadeIn();
					$("#divEnterSellPop").html(data);
					enterOpenPopupBuySell = true;
				},
				error     :function(e) {
					console.log(e);
					enterOpenPopupBuySell = false;
				}
			});
		}
	
		function sellClick() {
			$("#tab49").find("input[name='volumeS']").val(0);
			$("#tab49").find("input[name='priceS']").val(0);
			$("#tab49").find("input[name='volumeViewS']").val('');
			$("#tab49").find("input[name='priceViewS']").val('');
			
			volumeChange();
			priceChange();
			
			$("#tab49").find("#ent_tbl").addClass("sell");
			$("#tabOrdGrp2").tabs({active : 1});
		}
		
		function sellAllClick() {
			$("#tab49").unblock();
			
			$("#tab49").find("input[name='volumeS']").val(0);
			$("#tab49").find("input[name='volumeViewS']").val('');
			volumeChange();
			priceChange();
			
			$("#tab49").find("#tabOrdGrp2").tabs({active : 1});
			//현재 종목을 보유 했는지 확인
			//보유 종목이면 현재 보유 수량을 찍어 준다.
			var sel_stock = $("#tab49").find("input[name='stockS']").val();

			var param = {
					mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>")
			};
	
			$.ajax({
					dataType  : "json",
					url       : "/trading/data/enquiryportfolio.do",
					data      : param,
					success   : function(data) {
						//console.log("==GET MAX SELL VOLUME==");
						//console.log(data);
						$("#tab49").unblock();
						if(data.jsonObj != null) {
							if(data.jsonObj.mvPortfolioBeanList != null) {
								for(var i=0; i < data.jsonObj.mvPortfolioBeanList.length; i++) {
									var rowData = data.jsonObj.mvPortfolioBeanList[i];
									if(rowData.mvStockID == sel_stock) {
										var vol = rowData.mvTradableQty.replace(/,/g, "");
										if($("#ordMarketS").val() == "HO" || $("#ordMarketS").val() == "HO_ETF") {
											vol		=	(Math.floor(vol/10))*10;
										} else {
											vol		=	(Math.floor(vol/100))*100;
										}
										$("#tab49").find("input[name='volumeViewS']").val(vol);
										volumeChange();
										var price		=	$("#tab49").find("#priceViewS").val().split(",").join("");
										if(price == "" || price == "0") {
											price	=	$("#tab31").find("td[name='t_curr']").html();
											if(price == "" || price == "0" || price == undefined) {
												return;
											} else {
												price	=	price.split(",").join("");
											}
										}
										
										if(price == "" || price == "0" || price == undefined) {
											priceChange();
											return;
										} else {
											$("#tab49").find("input[name='priceViewS']").val(price);
											priceChange();
										}
									}
								}
							}
						}
					},
					error     :function(e) {
						console.log(e);
						$("#tab22").unblock();
					}
			});
		}
		

		//주문타입 변경시 action 정의
		function chgOrdType(type) {
			if (type == "L" || type == undefined) {
				$("#tab49").find("#chkExpiryS").attr("disabled", false);
				$("#tab49").find("#chkConditionS").attr("disabled", false);
			} else {
				$('#chkExpiryS').prop('checked', false);
				$("#tab49").find("#chkExpiryS").attr("disabled", true);
				$("#tab49").find("#chkExpiryS").val("off");
				$("#tab49").find("#expiryDateS").attr("disabled", true);
				$("#tab49").find("#expiryDateS").datepicker("disable");
				
				$('#chkConditionS').prop('checked', false);
				$("#tab49").find("#chkConditionS").attr("disabled", true);
				$("#tab49").find("#ojCondTypeS").attr("disabled", true);
				$("#tab49").find("#stopPriceViewS").attr("disabled", true);
				
				$("#tab49").find("#chkConditionS").val("N");
				$("#tab49").find("#ojCondTypeS").val("U");
				$("#tab49").find("#stopPriceViewS").val("0");
			}
			
			if(type == "L" || type == "LO" || type == undefined) {
				$("#tab49").find("#priceViewS").attr("disabled", false);
				$("#tab49").find("#priceViewS").show();
				$("#tab49").find("#priceViewS").val('');
				$("#tab49").find("#priceS").val("");
			} else {
				$("#tab49").find("#priceViewS").attr("disabled", true);
				$("#tab49").find("#priceViewS").hide();
				volumeChange();
			}
		}
		
		// Key Event
		function keyDownEvent(id, e){
			if (e.keyCode == "13") {
				enterSellSubmit()
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
	</script>
	<style>
	/* 2017.04.10 추가 */
	.sellBg {}
	/*.sellBg th {background:#e807a1;}*/
	.sellBg th {background:#feeff1;}
	
	#divOrdStock li.active { background:#d0d0d0;}
	#divBidStock li.active { background:#d0d0d0;}
	
	</style>
</head>

<body class="mdi" >
<div class="tab_content margin_top_0">
	<div role="tabpanel" class="tab_pane" id="tab49">
		<form id="frmEnterSell" autocomplete="Off">
			<input type="hidden" id="mvEnableOrderTypeS" name="mvEnableOrderTypeS" value="">
			<input type="hidden" id="mvInstrumentS" name="mvInstrumentS" value="">
			<input type="hidden" id="mvStockNameS" name="mvStockNameS" value="">
			<input type="hidden" id="mvMarketIdS" name="mvMarketIdS" value="">
			<input type="hidden" id="mvMarketIdListS" name="mvMarketIdListS" value="">
			<input type="hidden" id="mvEnableGetStockInfoS" name="mvEnableGetStockInfoS" value="">
			<input type="hidden" id="mvActionS" name="mvActionS" value="OI,BP,FE">
			<input type="hidden" id="mvTemporaryFeeS" name="mvTemporaryFeeS" value="">
			<input type="hidden" id="maxMarginS" name="maxMarginS" value="">
			<input type="hidden" id="lendingS" name="lendingS" value="">
			<input type="hidden" id="valueS" name="valueS" value="">
			<input type="hidden" id="netFeeS" name="netFeeS" value="">
			<input type="hidden" id="mvBankIDS" name="mvBankIDS" value="">
			<input type="hidden" id="mvBankACIDS" name="mvBankACIDS" value="">
			<input type="hidden" id="buyingPowerS" name="buyingPowerS" value="">
			<input type="hidden" id="orderTypeNmS" name="orderTypeNmS" value="">
			<input type="hidden" id="expiryDtS" name="expiryDtS" value="">
			<input type="hidden" id="advancedDtS" name="advancedDtS" value="">
			<input type="hidden" id="refIdS" name="refIdS" value="">
			<input type="hidden" id="mvCeilingS" name="mvCeilingS" value="">
			<input type="hidden" id="mvFloorS" name="mvFloorS" value="">
			<input type="hidden" id="divIdS" name="divIdS" value="divEnterSellPop">
			<input type="hidden" id="todayS" name="todayS" value="">

			<input type="hidden" id="ordMarketS" name="ordMarketS"/>				<!-- Order Market -->
			<input type="hidden" id="buySellS" name="buySellS" value="S"/>
			
			<!-- Condition Order -->
			<input type="hidden" id="mvStopS" name="mvStopS" value="N">
			<input type="hidden" id="mvStopTypeS" name="mvStopTypeS" value="">
			<input type="hidden" id="mvStopPriceS" name="mvStopPriceS" value="">
			
			
			<!-- 2017.04.05 new 김정순 -->
			<div class="group_table  margin_top_0 radius_top" style="border:none;">
				<table class="eo_table no_bbt sellBg" id="ent_tbl"  style="border-top: 1px solid #c9d1d5;border-left: 1px solid #c9d1d5; border-bottom: 1px solid #c9d1d5; border-radius: 4px 4px 4px 4px;">
					<colgroup>
						<col style="width: auto;"/>
						<col />
					</colgroup>
					<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Account" : "Tài khoản")%>
								<select id="subAccountTypeNameS" name="subAccountTypeNameS" title="Sub Account Name" style="display : none;">
								</select>
								<span id="accTypeNameS" name="accTypeNameS" style="font-weight: bold;font-size: larger;color:blue !important;"></span>
							</th>
							<td>
								<select id="subAccountS" name="subAccountS" onchange="chgSubAccountS(this.value);" title="Sub Account" style="width: auto;color: blue;min-height: 35px;font-weight: bold;font-size: larger;">
								</select>
								<input type="text" id="accNameS" name="accNameS" style="width: auto;min-height: 35px;font-weight: bold;font-size: larger;" disabled>
							</td>
						</tr>
					<tr>
						<th style="height:30px; border-radius:3px 0 0 0"><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
						<td style="border-radius:0 3px 0 0;">
							<div style="float:left;" class="layer_search_ES">
									<button type="button" class="search_full_stock" style="background:url(/resources/images/bg_search.png) no-repeat 50%;top:-3px;"></button>						
									<div class="layer_ES" style="right:100px;width:330px;">
										<h2><%= (langCd.equals("en_US") ? "STOCK SEARCH" : "MÃ TÌM KIẾM") %></h2>
										<div class="search_area">
											<label for="schNamePopES"><%= (langCd.equals("en_US") ? "Name" : "Tên") %></label>
											<div class="input_search" style="display:block;top:5px;">
												<input style="float:left;width:92%;" type="text" id="schNamePopES" name="schNamePopES" onkeyup="searchStockES(event)">
												<button style="float:right;height:20px;top:-2px;" type="button" id="schStockPopES" name="schStockPopES"></button>
											</div>
										</div>
										<div>
											<div style="position:relative; padding:8px 0;">
												<div>
													<input style="width:12px;" type="radio" id="schMarketPopALLES" name="schMarketPopES" value="ALL" checked="checked"><label style="display:inline;padding-left:5px;" for="schMarketPopALLES">All</label>											
													<input style="width:12px;" type="radio" id="schMarketPopHOES" name="schMarketPopES" value="HOSE"><label style="display:inline;padding-left:5px;" for="schMarketPopHOES">HOSE</label>
													<input style="width:12px;" type="radio" id="schMarketPopHAES" name="schMarketPopES" value="HNX"><label style="display:inline;padding-left:5px;" for="schMarketPopHAES">HNX</label>
													<input style="width:12px;" type="radio" id="schMarketPopOTCES" name="schMarketPopES" value="UPCOM"><label style="display:inline;padding-left:5px;" for="schMarketPopOTCES">UPCOM</label>
													<input style="width:12px;" type="radio" id="schMarketPopCWES" name="schMarketPopES" value="HOSE"><label style="display:inline;padding-left:5px;" for="schMarketPopCWES">CW</label>						
												</div>
											</div>
											<div>
												<div class="table_outer">
													<div class="group_table type1" style="overflow-x: hidden;">
														<table class="table">
															<colgroup>
																<col width="80">
																<col>
															</colgroup>
															<thead>
																<tr>
																	<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
																	<th><%= (langCd.equals("en_US") ? "Name" : "Tên Công ty") %></th>
																</tr>
															</thead>
															<tbody id="grdStockPopES">
															</tbody>
														</table>
													</div>
												</div>
											</div>
										</div>
										<div class="btn_wrap" style="text-align:center;">
											<button type="button"><%= (langCd.equals("en_US") ? "Cancel" : "Hủy") %></button>
										</div>
									</div>							
								</div>
							<!--<span class="code" name="bid_rcod" id="bid_rcod"></span>-->
							<div id="ent_sch_stock" class="input_dropdown"><!--style="display:none">--> 
								<span>
									<input type="text" id="stockS" name="stockS" onkeyup="getStock(event)"/>
									<button tabindex=-1 type="button" onclick="divOrdShowHide()"></button>
								</span>
								<div id="divOrdStock">
									<ul id="ulOrdStock">
									</ul>
								</div>
							</div>
							
							<span class="code" name="s_bid_mark"></span>
							<button type="button" class="btn" onclick="stockInfoPop();">!</button>
							<span style="color:red!important;" name="s_bid_divi"></span>
							
							<!--<span class="name" name="bid_snam" id="bid_sname"></span>-->
						</td>					
					</tr>
					<tr>
						<th><%= (langCd.equals("en_US") ? "Company name" : "Tên công ty") %></th>
						<td>
							<span class="name" name="bid_snam" id="bid_sname"></span>
						</td>
						
					</tr>
					<tr>
						<th style="height:30px;"><%= (langCd.equals("en_US") ? "Order Type" : "Loại lệnh") %></th>
						<td>
							<select id="orderTypeS" name="orderTypeS" title="Order Type" style="width: 70%;" onchange="chgOrdType(this.value);">
							</select>
						</td>
					</tr>
					<tr>
						<th style="height:30px;"><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
						<td>
							<input type="hidden" id="priceS" name="priceS" value="">
							<input class="text won" type="text" id="priceViewS" name="priceViewS" value="" onkeyup="priceChange(event)" onkeydown="keyDownEvent(this.id, event)" onfocus="onFocusIn(this.id)"  onBlur="onFocusOut(this.id)" style="width:70% !important">
						</td>
					</tr>
					<tr>
						<th style="height:30px;"><%= (langCd.equals("en_US") ? "Volume" : "Khối lượng") %></th>
						<td>
							<input type="hidden" id="volumeS" name="volumeS" value="">
							<input class="text won" type="text" id="volumeViewS" name="volumeViewS" value="" onkeyup="volumeChange(event)" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" onkeypress="isNum();" style="width:70% !important">
							<!-- <button type="button" class="all_btn">all</button> -->
							<button type="button" class="all_btn" onclick="sellAllClick();">all</button>
						</td>
					</tr>
					<tr>
						<th style="height:30px;"><%= (langCd.equals("en_US") ? "Expiry date" : "Lệnh đến hạn") %></th>
						<td>
							<input type="checkbox" id="chkExpiryS" name="chkExpiryS" onclick="chkExpiryDate()" value="off" style="margin-right:5px">
							<input type="text" id="expiryDateS" name="expiryDateS" class="datepicker" disabled="disabled" style="color:#000">
						</td>
					</tr>
					<%-- 
					<tr>
						<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Order Condition" : "Lệnh điều kiện")%></th>
						<td>
							<input type="checkbox" id="chkConditionS" name="chkConditionS" onclick="chkOrderConditionS()" value="off" style="margin-right: 5px">
							<select id="ojCondTypeS" style="width:100px;" disabled="disabled">									
								<option value="U">Up</option>
								<option value="D">Down</option>
							</select>
							<label><%=(langCd.equals("en_US") ? "Price" : "Giá")%></label>
							<input class="text won" type="text" id="stopPriceViewS"
							name="stopPriceViewS" value="0" onkeyup="stopPriceChange(event)"
							onkeydown="keyDownEvent(this.id, event)"
							onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)"
							style="width: 25% !important" disabled="disabled">
						</td>
					</tr>
					 --%>
					<tr style="display:none;">
						<th style="height:30px;"><%= (langCd.equals("en_US") ? "Buying Power" : "Dự kiến") %></th>
						<td id="trBuyingPower" class="right"></td>
					</tr>
					
					<tr>
						<th style="height:30px;"><%= (langCd.equals("en_US") ? "Sell Value" : "Giá trị") %></th>
						<td id="trValue" class="right">0 </td>
					</tr>
					<%-- 
					<tr>
						<th style="height:30px; border-radius:0 0 0 3px;"><%= (langCd.equals("en_US") ? "Net fee" : "Phí tạm tính") %></th>
						<td id="trNetFee" class="right" style="border-radius:0 0 3px 0">0.00</td>
					</tr>
					 --%>
				</table>
			</div>
			

			<div class="mdi_bottom cb" style="text-align:right;">
				<input type="button" class="color" value="<%= (langCd.equals("en_US") ? "SELL" : "BÁN") %>" onclick="enterSellSubmit()">
				<input type="button" value="<%= (langCd.equals("en_US") ? "Clear" : "Xóa") %>" onclick="clearData()">
			</div>
		</form>
		<!-- //BUY -->
	</div>
</div>
<!-- orderConfirm pop -->
<div id="divEnterSellPop" class="modal_wrap"></div>
<!-- orderConfirm pop -->
</body>
</html>
