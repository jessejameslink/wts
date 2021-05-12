<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
	        response.setHeader("Cache-Control", "no-cache");
	response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>
<%
	/* 
		THIS PAGE USED TAB41
	*/
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<script>
		var accBuyingPower	=	"";
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
		    	
		        if($('#ui-id-40').css('display') == 'block')
				{
		        	if($("#volumeB").val() == 0) {
						return;
					}
					if(numDotComma($("#priceB").val()) == 0) {
						return;
					}
					if(enterOpenPopupBuySell == true) {
						return;
					}	
		        	enterOrderSubmit();
				}
				else if($('#ui-id-42').css('display') == 'block'){
					if($("#volumeS").val() == 0) {
						return;
					}
					if(numDotComma($("#priceViewS").val()) == 0) {
						return;
					}
					if(enterOpenPopupBuySell == true) {
						return;
					}
					enterSellSubmit();
				}
		    }
		});
		$(document).ready(function(){
			//console.log("<%=authenMethod%>");
			/* 2017.04.06 추가 김정순 */
			$('.wrap_right .tit li a').on('click',function() {
				$(this).parent().addClass('on').siblings().removeClass('on');
			});
			$("#tabOrdGrp2").tabs({active : $("#tabsGrp").val()});
			$("#divEnterOrderPop").hide();
			$("#divOrdStock").hide();
			
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
			
			getSubAccountB();			
			$("#accNameB").val('<%= session.getAttribute("ClientName") %>');
			
			$(".layer_search_EB .layer_EB").hide();
			$('.layer_search_EB button').click(function(e){
				var self = $(this);
				
				if(self.closest('.btn_wrap').length){ // sub layer button
					self.closest('.layer_EB').hide();
					$('.layer_search_EB button').removeClass('on');
				} else { // layer toggle button
					if(!self.closest('.search_area').length) {
						self.toggleClass('on');
						$('.layer_search_EB button').not(this).removeClass('on');
						$('.layer_search_EB .layer_EB').not($(this).next()).hide();
						self.next().toggle();
						$("#schNamePopEB").val("");
						$("#schMarketPopALLEB").prop('checked', true);
						if ($('.layer_search_EB button').hasClass('on')) {
							getStockPopEB();
						}
					} else {						
						getStockPopEB();
					}
				}
			});
			
			$("#schMarketPopALLEB").on('change', function(e) {
				getStockPopMarketEB("ALL");
			});
			$("#schMarketPopHOEB").on('change', function(e) {			
				getStockPopMarketEB("HOSE");
			});
			$("#schMarketPopHAEB").on('change', function(e) {
				getStockPopMarketEB("HNX");
			});
			$("#schMarketPopOTCEB").on('change', function(e) {		
				getStockPopMarketEB("UPCOM");
			});
			$("#schMarketPopCWEB").on('change', function(e) {			
				getStockPopMarketEB("CW");
			});
		});
		
		function getSubAccountB() {
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
						$("#subAccountB option").remove();
						//$("#subAccountBshow option").remove();
						$("#accTypeNameB").text('');
						for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
							$("#subAccountB").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + "</option>");
							//$("#subAccountBshow").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID + " - " + data.jsonObj.mainResult[i].subAccountID + "</option>");
							$("#subAccountTypeNameB").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].investorTypeName + "</option>");
						}
						$("#subAccountB").val(<%= session.getAttribute("tradingAccSeq") %>);
						$("#subAccountTypeNameB").val(<%= session.getAttribute("tradingAccSeq") %>)
						$("#accTypeNameB").text($("#subAccountTypeNameB option:selected").text());
						
					},
					error     :function(e) {					
						console.log(e);
					}
				});
		}
		
		function chgTypeNameB(val)
		{
			$("#subAccountTypeNameB").val(val)
			$("#accTypeNameB").text($("#subAccountTypeNameB option:selected").text());
		}
		
		function chgSubAccountB(val) {
			chgTypeNameB(val);
			changeSubAccount1($("#subAccountB option:selected").text(), val);
		}
		
		function getStockPopEB() {
			var param = {
				  stockCd  :  $("#schNamePopEB").val()
				, marketId :  $("input[name=schMarketPopEB]:checked").val()
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
							stockStr += "<tr onclick=\"selectRowPopEB('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
							stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
							stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
							stockStr += "</tr>";
						}
						$("#grdStockPopEB").html(stockStr);
					}					
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		function getStockPopMarketEB(market) {
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
									stockStr += "<tr onclick=\"selectRowPopEB('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
									stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
									stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
									stockStr += "</tr>";
								}
							} else {
								var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<tr onclick=\"selectRowPopEB('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
								stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
								stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
								stockStr += "</tr>";	
							}							
						}
						$("#grdStockPopEB").html(stockStr);
					}					
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		function searchStockEB(evt) {
			$("#schNamePopEB").val($("#schNamePopEB").val().toUpperCase());
			if(evt.keyCode == 13) {
				
				//deplay enter key
				clearTimeout(keyup_timeout); // Clear the previous timeout so that it won't be executed any more. It will be overwritten by a new one below.
		        keyup_timeout = setTimeout(function() {
		            // Perform your magic here.
		        }, timeout_delay_in_ms);
				
				getStockPopEB();
			}
		}
		
		function selectRowPopEB(symb) {
			selItem(symb);
			$(".layer_search_EB .layer_EB").hide();
		}
		
		function Ext_SetOrderStock(stock, sub) {
			//console.log("EXT SET ORDER STOCK CALL");
			clearData();
			if (sub != undefined) {
				subAcc = sub;
			}
			//getEnterOrder();
			$("#stockB").val(stock);
			$("#tab41").find("span[name='b_bid_mark']").html($("#tab31").find("span[name='bid_mark']").html());
			$("#tab41").find("span[name='b_bid_divi']").html($("#tab31").find("span[name='bid_divi']").html());
			//@TODO : event 로 호출시 오류 발생함
			//getStock(event);
			getStock();
		}
	
		function chkExpiryDate() {
			if($("#chkExpiryB").is(":checked")) {
				$("#tab41").find("#chkExpiryB").val("on");
				$("#tab41").find("#expiryDate").attr("disabled", false);
				$("#tab41").find("#expiryDate").datepicker("enable");				
				if($("#chkConditionB").is(":checked")) {
					$('#chkConditionB').prop('checked', false);
					$("#tab41").find("#ojCondTypeB").attr("disabled", true);
					$("#tab41").find("#stopPriceViewB").attr("disabled", true);
					
					$("#tab41").find("#chkConditionB").val("N");
					$("#tab41").find("#ojCondTypeB").val("U");
					$("#tab41").find("#stopPriceViewB").val("0");					
				}
			} else {
				$("#tab41").find("#chkExpiryB").val("off");
				$("#tab41").find("#expiryDate").attr("disabled", true);
				$("#tab41").find("#expiryDate").datepicker("disable");
			}
		}
		
		function chkOrderCondition() {
			if($("#chkConditionB").is(":checked")) {
				$("#tab41").find("#ojCondTypeB").attr("disabled", false);
				$("#tab41").find("#stopPriceViewB").attr("disabled", false);
				
				if($("#chkExpiryB").is(":checked")) {
					$('#chkExpiryB').prop('checked', false);
					$("#tab41").find("#chkExpiryB").val("off");
					$("#tab41").find("#expiryDate").attr("disabled", true);
					$("#tab41").find("#expiryDate").datepicker("disable");
				}
			} else {
				$("#tab41").find("#ojCondTypeB").attr("disabled", true);
				$("#tab41").find("#stopPriceViewB").attr("disabled", true);
				
				$("#tab41").find("#chkConditionB").val("N");
				$("#tab41").find("#ojCondTypeB").val("U");
				$("#tab41").find("#stopPriceViewB").val("0");			
			}
		}
	
		function chkAdvancedDate() {
			if($("#chkAdvanced").is(":checked")) {
				$("#chkAdvanced").val("on");
				$("#advancedDate").attr("disabled", false);
			} else {
				$("#chkAdvanced").val("off");
				$("#advancedDate").attr("disabled", true);
			}
		}
	
		function getEnterOrder() {
			$("#tab41").block({message: "<span>LOADING...</span>"});
			var param	=	{
					mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>")
			};
			$.ajax({
				dataType  : "json",
				url       : "/trading/data/genenterorder.do",
				asyc      : true,
				cache	  : false,
				data	  : param,
				success   : function(data) {
					//console.log("GET RESULT ENTER ORDER");
					//console.log(data);
					if(data.jsonObj != null) {
						var entOrd = data.jsonObj.genEnterOrderBean;
						if ($("#mvMarketId").val() == "") {
							$("#mvMarketIdB").val(entOrd.mvMarketID);
						}
						
						$("#mvActionB").val("OI,BP,FE");
						$("#todayB").val(entOrd.mvDateTime.substring(0, 10));
						$("#tab41").find("#expiryDate").datepicker({
							showOn      : "button",
							dateFormat  : "dd/mm/yy",
							changeYear  : true,
							changeMonth : true
						});
						$("#tab41").find("#expiryDate").datepicker("setDate", entOrd.mvDateTime.substring(0, 10));
						$("#tab41").find("#expiryDate").attr("disabled", true);
						$("#tab41").find("#expiryDate").datepicker("disable");
						var flag	=	false;
						for(var i = 0; i < data.jsonObj.mvSettlementAccList.length; i++) {
							var obj	=	data.jsonObj.mvSettlementAccList[i];
							if(obj.mvBankID != "" ) {
								flag	=	true;
								$("#mvBankIDB").val(obj.mvBankID);
								$("#mvBankACIDB").val(obj.mvBankACID);
							}
						}
						
						if(flag) {
							$("#bankAccountYnB").val("Y");
							trueAccountBal();
						} else {
							$("#bankAccountYnB").val("N");
						}
					}
					$("#tab41").unblock();
				},
				error     :function(e) {
					console.log(e);
					$("#tab41").unblock();
				}
			});
		}
	
		function getStock(e) {
			
			var $this;
			var $tab;
			var	$layer;
			var $ulblock;
			
			
			var tabid	=	"";
			console.log("EVENT CHECK=====Ext_SetEnterOrder>");
			//console.log(e.target.id);
			if(e == undefined) {
				$this	=	$("#stockB");
				$tab	=	$("#tab41");
				$layer	=	$("#divOrdStock");
				$ulblock=	$("#ulOrdStock");
				
				tabid	=	"stock";
			} else {
				if(e.target.id == "bidStock") {
					$this	=	$("#bidStock");
					$tab	=	$("#tab31");
					$layer	=	$("#divBidStock");
					$ulblock=	$("#ulBidStock");
					
					tabid	=	"bidStock";
				} else {
					$this	=	$("#stockB");
					$tab	=	$("#tab41");
					$layer	=	$("#divOrdStock");
					$ulblock=	$("#ulOrdStock");
					
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
						idx = $('#divOrdStock').find("li.active").index();
					}
					var stockList = tmpData[idx];
					stockSelected(stockList.synm, stockList.marketId, tabid);
					$this.blur(); 
					return;
				}
				else if ( key == 40 ) // Down key
			    {
			    	if(e.target.id != "bidStock") {
			    		if ($('#divOrdStock').find("li:last").hasClass("active")) {
			    			$("#divOrdStock li.active").removeClass("active");
			    			$('#divOrdStock').find("li:first").focus().addClass("active");
			    		} else {
					    	if($("#divOrdStock li.active").length!=0) {				    		
				                var storeTarget = $('#divOrdStock').find("li.active").next();
				                $("#divOrdStock li.active").removeClass("active");
				                storeTarget.focus().addClass("active");
				                $('#divOrdStock').animate({
				                    scrollTop: storeTarget.position().top + $("#divOrdStock").scrollTop()
				                }, 'slow');
				            }
				            else {
				                $('#divOrdStock').find("li:first").focus().addClass("active");
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
			    		if ($('#divOrdStock').find("li:first").hasClass("active")) {
			    			$("#divOrdStock li.active").removeClass("active");
			    			$('#divOrdStock').find("li:last").focus().addClass("active");
			    		} else {
					    	if($("#divOrdStock li.active").length!=0) {
				                var storeTarget = $('#divOrdStock').find("li.active").prev();
				                $("#divOrdStock li.active").removeClass("active");
				                storeTarget.focus().addClass("active");
				                $('#divOrdStock').animate({
				                    scrollTop: storeTarget.position().top + $("#divOrdStock").scrollTop()
				                }, 'slow');
				            }
				            else {
				                $('#divOrdStock').find("li:last").focus().addClass("active");
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
							var stockNm   = ("<%=langCd%>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
							stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
							$layer.hide();
							$this.val(stockList.synm);
							$('#mvMarketIdB').attr("value", displayMarketID(stockList.marketId));
							watchListSelect = false;
							if(tabid == 'bidStock') {
								selItem(stockList.synm);
							} else {
								//stockChange();								
								trueAccountBal();
							}							
							} else {
								var stockList = data.stockList[0];
								var stockNm   = ("<%=langCd%>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
								$tab.unblock();
							}
						} else if(data.stockList.length > 1) {
							for(var i=0; i < data.stockList.length; i++) {
								var stockList = data.stockList[i];
								var stockNm   = ("<%=langCd%>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
							}
							if (e == undefined) {
								for(var i=0; i < data.stockList.length; i++) {
									var stockList = data.stockList[i];
									if (stockList.synm == $this.val()) {
										var stockNm   = ("<%=langCd%>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
										stockStr += "<li><a onclick=\"stockSelected('" + stockList.synm + "', '" + stockList.marketId + "', '" + tabid + "')\" style=\"cursor: pointer;\">" + stockList.synm + " - " + stockNm + "</a></li>";
										$layer.hide();
										$this.val(stockList.synm);
										$('#mvMarketIdB').attr("value", displayMarketID(stockList.marketId));
										watchListSelect = false;
										if(tabid == 'bidStock') {
											selItem(stockList.synm);
										} else {
											trueAccountBal();											
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
						$("#ulOrdStock").html(stockStr);
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
		};		

		function stockSelected(val, market, tabid) {
			if (market == "" || market == null || market == "null" || market == undefined) {
				selItem(val);
			} else {
				if(tabid == undefined) {
					$("#divOrdStock").hide();
					$("#stockB").val(val);
					$('#mvMarketIdB').attr("value", displayMarketID(market));
					watchListSelect = false;
				} else {
					var targetId	=	tabid;
					if(targetId == 'bidStock') {
						$("#divBidStock").hide();
						$("#bidStock").val(val);
						selItem(val);
					} else {
						$("#divOrdStock").hide();
						$("#stockB").val(val);
						$('#mvMarketIdB').attr("value", displayMarketID(market));
						watchListSelect = false;
						trueAccountBal();
					}
				}
			}
		}
	
		
		
		function divOrdShowHide() {
			if($("#divOrdStock").css("display") == "none") {
				$("#divOrdStock").show();
			} else {
				$("#divOrdStock").hide();
			}
		}
	
		function setOrderType(marketId) {
			$("#tab49").find("#orderTypeS").find("option").remove();
			
			var marketStatus = "";
			var param = {
					mvMarketID           : marketId
					,mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>")
			};

			$.ajax({
				dataType  : "json",
				url       : "/margin/data/queryMarketStatusInfo.do",
				data      : param,
				asyc      : true,
				success   : function(data) {
					$("#orderTypeB").find("option").remove();
					if(data != null) {
						if(data.jsonObj.mvMarketID == "HO") {
							marketStatus = data.jsonObj.mvMarketStatus;
						}
						if(marketId == "HO") {							
							if (marketStatus == "T3") {
								$("#orderTypeB").append(new Option("LO", "L", true, true));
								$("#orderTypeB").append(new Option("ATC", "C", true, true));
							} else {
								$("#orderTypeB").append(new Option("LO", "L", true, true));
								$("#orderTypeB").append(new Option("ATO", "O", true, true));
								$("#orderTypeB").append(new Option("ATC", "C", true, true));
								$("#orderTypeB").append(new Option("MP", "M", true, true));
							}
						} else if(marketId == "HA") {
							$("#orderTypeB").append(new Option("LO", "L", true, true));
							$("#orderTypeB").append(new Option("ATC", "C", true, true));
							$("#orderTypeB").append(new Option("MAK", "Z", true, true));
							$("#orderTypeB").append(new Option("MOK", "B", true, true));
							$("#orderTypeB").append(new Option("MTL", "R", true, true));
							$("#orderTypeB").append(new Option("PLO", "J", true, true));
							$("#orderTypeB").append(new Option("LO(Odd Lot)", "LO", true, true));
						} else if(marketId == "OTC") {
							$("#orderTypeB").append(new Option("LO", "L", true, true));
							$("#orderTypeB").append(new Option("LO(Odd Lot)", "LO", true, true));
						}
						$("#orderTypeB").val($("#orderTypeB option:eq(0)").val());
					}
				},
				error     :function(e) {
					console.log(e);
				}
			});			
		}
	
		
		
		function trueAccountBal() {
			var isBank = false;
			//console.log("bank : " + $("#bankAccountYnB").val());
			//if($("#bankAccountYnB").val() == "") {
			//	return;
			//}
			if ($("#bankAccountYnB").val() == "Y") {
				isBank = true;
			} else {
				isBank = false;
			}
			
			var param	=	{
					mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>"),
					loadBank		: isBank,
					isFO			: true
			};
			
			$.ajax({
				dataType  : "json",
				cache: false,
				data	  : param,
				url       : "/margin/data/accountbalance.do",
				asyc      : true,
				success   : function(data) {
					//console.log("CHECK THE BALANCE Enter");
					//console.log(data);
					$("#tab22").unblock();
					if(data.jsonObj != null) {
						accBuyingPower	=	data.jsonObj.mvList[0].mvBuyingPowerd;
						setCookieResign('accountBankHid',accBuyingPower,1);
					}
					stockChange();
				},
				error     :function(e) {
					//console.log(e);
					stockChange();
					$("#tab22").unblock();
					setCookieResign('accountBankHid',0,1);
				}
			});
		}
		
		function stockChange() {
			//console.log("+++Stock null CHECK+++");
			if($("#stockB").val() == ""){
				//console.log("+++Stock null CHECK+++");
				return;
			}
			
			setOrderType($("#mvMarketIdB").val());
			$("#mvInstrumentB").val($("#stockB").val());
			
			
			var param = {
					mvSubAccountID		 : 	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>"),
					mvInstrument         : $("#mvInstrumentB").val(),
					mvMarketID           : $("#mvMarketIdB").val(),
					mvBS                 : "B",
					mvAction             : $("#mvActionB").val()
			};
			
			//console.log("STOCK CHANGE++++++++++++++++++++++++++++++++");
			//console.log(param);
			$("#tab41").block({message: "<span>LOADING...</span>"});
			$.ajax({
				dataType  : "json",
				url       : "/trading/data/stockInfo.do",
				data      : param,
				asyc      : true,
				cache	  : false,
				success   : function(data) {
					//console.log("+++DATA CHECK+++");
					//console.log(data);
					if(data.jsonObj != null) {
						var stock = data.jsonObj.mvStockInfoBean;
						var buyingPowerd	=	accBuyingPower;
						buyingPowerd = buyingPowerd.replace(/,/g, "") * 1000;
	
						var marginPercent	=	stock.mvMarginPercentage;
						if(marginPercent == null || marginPercent == "null" || marginPercent == "") {
							marginPercent	=	0;
						}
						
						if($("#bankAccountYnB").val() == "Y") {
							buyingPowerd = buyingPowerd;
							setCookieResign('accountBankHid',buyingPowerd,1);
						} else {
							buyingPowerd = Math.floor(buyingPowerd / (1 - marginPercent / 100));
							setCookieResign('accountBankHid',0,1);
						}
						/*
						if (marginPercent != 0) {
							buyingPowerd = Math.floor(buyingPowerd - 0.01 * buyingPowerd);
						}
						*/
						
						$("#mvStockNameB").val(stock.mvStockName);
						$("#mvCeilingB").val(numDotComma(stock.mvCeiling));
						$("#mvFloorB").val(numDotComma(stock.mvFloor));
						$("#maxMarginB").val(stock.mvAvailableMarginVol);
						$("#trMaxMargin").html(stock.mvAvailableMarginVol);
						$("#lendingB").val(parseInt(marginPercent));
						$("#lbLending").html(parseInt(marginPercent) + "%");
						$("#buyingPowerB").val(numIntFormat(parseInt(buyingPowerd)));
						$("#trBuyingPower").html(numIntFormat(parseInt(buyingPowerd)));
						$("#mvActionB").val("OI,BP");
	
						if(stock.mvTemporaryFee != null) {
							$("#mvTemporaryFeeB").val(stock.mvTemporaryFee);
						}
		
						var bef_rcod	=	$("#tab31").find("span[name='bid_rcod']").html();
						if(bef_rcod != "" && bef_rcod != null) {
							bef_rcod	=	bef_rcod.substring(0,3);
							if(bef_rcod != $("#stockB").val()) {
								trdSelItemNoOrd($("#mvInstrumentB").val(), $("#mvMarketIdB").val());	
							}
						} else {
							trdSelItemNoOrd($("#mvInstrumentB").val(), $("#mvMarketIdB").val());
						}
						$("#tab41").find("span[name='bid_rcod']").html($("#stockB").val() + "&nbsp;|&nbsp;" + convMarketId($("#mvMarketIdB").val()));											
						var bef_sname = $("#tab31").find("span[name='bid_snam']").html();
						$("#tab41").find("span[name='bid_snam']").html(bef_sname);
						 
						$("#ordMarketB").val(stock.spreadTableCode);
						maxVolumeBuy();
						
					} else {
						$("#mvStockNameB").val("");
						$("#mvCeilingB").val("");
						$("#mvFloorB").val("");
						$("#maxMarginB").val("");
						$("#trMaxMargin").html("");
						$("#lendingB").val("");
						$("#lbLending").html("");
						$("#buyingPowerB").val("");
						$("#trBuyingPower").html("");
						setCookieResign('accountBankHid',0,1);
						$("#mvActionB").val("OI,BP");
						$("#mvTemporaryFeeB").val(0);
						$("#maxVolume").val(0);
						var bef_rcod	=	$("#tab31").find("span[name='bid_rcod']").html();
						if(bef_rcod != "" && bef_rcod != null) {
							bef_rcod	=	bef_rcod.substring(0,3);
							if(bef_rcod != $("#stockB").val()) {
								trdSelItemNoOrd($("#mvInstrumentB").val(), $("#mvMarketIdB").val());	
							}
						} else {
							trdSelItemNoOrd($("#mvInstrumentB").val(), $("#mvMarketIdB").val());
						}
						$("#tab41").find("span[name='bid_rcod']").html($("#stockB").val() + "&nbsp;|&nbsp;" + convMarketId($("#mvMarketIdB").val()));						
						var bef_sname = $("#tab31").find("span[name='bid_snam']").html();
						$("#tab41").find("span[name='bid_snam']").html(bef_sname);
					}
					$("#tab41").unblock();
				},
				error     :function(e) {
					console.log(e);
					$("#tab41").unblock();
					setCookieResign('accountBankHid',0,1);
					var bef_rcod	=	$("#tab31").find("span[name='bid_rcod']").html();
					if(bef_rcod != "" && bef_rcod != null) {
						bef_rcod	=	bef_rcod.substring(0,3);
						if(bef_rcod != $("#stockB").val()) {
							trdSelItemNoOrd($("#mvInstrumentB").val(), $("#mvMarketIdB").val());	
						}
					}
					$("#tab41").unblock();
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
			if($("#" + tagId).val() == "0") {
				$("#" + tagId).val('');
			}
		}
	
		function onFocusOut(tagId) {
			if($("#" + tagId).val() == "") {
				$("#" + tagId).val('');
			}
		}
	
		function volumeChange(e) {
			if (e != undefined) {
				if (e.which >= 37 && e.which <= 40) return;
			}
			var volumeView = $("#volumeViewB").val().replace(/[,.]/g,'');
			
			if($("#orderTypeB").val() == "L" || $("#orderTypeB").val() == "LO") {
				if(volumeView > 0 ) {
					$("#volumeB").val(Number(volumeView));
					$("#volumeViewB").val(numIntFormat(volumeView));
					volPriceSum();
				} else if(Number(volumeView) <= 0) {
					$("#volumeB").val(0);
					$("#volumeViewB").val('');
				}
			} else {
				//매수일경우 상한가로 계산
				$("#priceB").val($("#mvCeilingB").val().replace(/[,.]/g,''));
				$("#priceViewB").val(numIntFormat($("#mvCeilingB").val().replace(/[,.]/g,'')));
				if(volumeView > 0 ) {
					$("#volumeB").val(Number(volumeView));
					$("#volumeViewB").val(numIntFormat(volumeView));
					volPriceSum();
				} else if(Number(volumeView) <= 0) {
					$("#volumeB").val(0);
					$("#volumeViewB").val('');
				}
			}
		}
		
		function maxVolumeChange() {
			var maxVolume = $("#maxVolume").val().replace(/[,.]/g,'');			
			if(maxVolume > 0 ) {
				$("#maxVolume").val(numIntFormat(maxVolume));
			} else if(Number(maxVolume) <= 0) {
				$("#maxVolume").val(0);
			}
			
		}
	
		function priceChange(e) {
			if (e != undefined) {
				if (e.which >= 37 && e.which <= 40) return;
			}
			var priceView  = $("#priceViewB").val().replace(/,/g,'').replace('.','');
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
				$("#priceB").val(numIntFormat(priceView));
				$("#priceViewB").val(numIntFormat(priceView));
				$("#priceViewB").focus();
				volPriceSum();
			} else if(priceView == 0) {
				$("#priceB").val(0);
				$("#priceViewB").val('');
				volPriceSum();
			}
			//console.log("Không đủ tiền");
			maxVolumeBuy();
		}
		
		function stopPriceChange(e) {
			var sPriceView  = $("#stopPriceViewB").val().replace(/,/g,'').replace('.','');
			if(sPriceView > 0) {
				$("#stopPriceViewB").val(numIntFormat(sPriceView));
			} else {
				$("#stopPriceViewB").val(0);
			}
		}
	
		function isNum() {
			var key	=	event.keyCode;
			if(!(key==8||key==9||key==13||key==46||key==144||(key>=48&&key<=57)||key==110||key==190)) {
				event.returnValue	=	false;
			}
		}
		
		function volPriceSum() {			
			var price   = numDotComma($("#priceB").val());
			var volume  = numDotComma($("#volumeB").val());
			var tmpFee  = $("#mvTemporaryFeeB").val();
			var valSum  = 0;
			var netFee  = 0;
	
			valSum = price  * volume;
			netFee = valSum * tmpFee;
			netFee = Math.round(netFee / 100, 1);
			$("#valueB").val(numIntFormat(valSum));
			$("#trValue").html(numIntFormat(valSum));
			$("#netFeeB").val(numIntFormat(netFee));
			$("#trNetFee").html(numIntFormat(netFee));
		}
	
		function clearData(flag) {
			if (flag == 1) {
				//re-calculate buying power
				var tmpbuying = $("#buyingPowerB").val().split(",").join("") - $("#valueB").val().split(",").join("") - $("#netFeeB").val().split(",").join("");
				$("#buyingPowerB").val(numIntFormat(parseInt(tmpbuying)));
				$("#trBuyingPower").html(numIntFormat(parseInt(tmpbuying)));		
				$("#valueB").val(0);
				$("#netFeeB").val(0);
			}		
			$("#orderTypeB").val($("#orderTypeB option:eq(0)").val());
			chgOrdType($("#orderTypeB option:eq(0)").val());
			$("#volumeB").val("");
			$("#priceB").val("");
			$("#trValue").html("0");
			$("#trNetFee").html("0.00");
			$("#volumeViewB").val('');
			$("#priceViewB").val('');
			$("#maxVolume").val("0");
			$("#chkExpiryB").val("off").attr("checked", false);
			$("#tab41").find("#chkExpiryB").attr("disabled", false);
			$("chkAdvanced").val("off").attr("checked", false);
			$("#tab41").find("#expiryDate").datepicker("setDate", $("#todayB").val());
			
			$("#chkConditionB").attr("checked", false);
			$("#tab41").find("#chkConditionB").attr("disabled", false);
			$("#tab41").find("#ojCondTypeB").attr("disabled", true);
			$("#tab41").find("#stopPriceViewB").attr("disabled", true);
			$("#chkConditionB").val("N");
			$("#ojCondTypeB").val("U");
			$("#stopPriceViewB").val("0");
		}
		
		function bidClearData() {
			$("#priceB").val("");
			$("#trValue").html("0");
			$("#priceViewB").val('');
			$("#chkExpiryB").val("off").attr("checked", false);
			$("chkAdvanced").val("off").attr("checked", false);
			$("#tab41").find("#expiryDate").datepicker("setDate", $("#todayB").val());
		}
		
	
		function enterOrderSubmit() {
			//@TODO : 확인필요함(stock info는 종목명이 베트남어로만 나옴)
			$("#mvStockNameB").val($("#tab31").find("span[name='bid_snam']").html());
			enterOpenPopupBuySell = true;
			var priceView  = numDotComma($("#priceViewB").val());
			var volumeView = numDotComma($("#volumeViewB").val());
						
				//MAX CHECK
				var buyingPwd	=	$("#trBuyingPower").html();
				var price		=	$("#priceViewB").val().split(",").join("");
				if(price == "" || price == "0") {					
					if($("#orderTypeB").val() == "L" || $("#orderTypeB").val() == "LO") {
						$("#priceViewB").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Please enter the Price!");	
						} else {
							alert("Vui lòng nhập giá!");
						}
						return;
					}
				}
				var maxMargin	=	$("#maxMarginB").val();
				if(maxMargin == "") {
					maxMargin	=	0;
				}
				var setPrice	=	price*1.005*(1-maxMargin/100);
				var vol			=	Number(buyingPwd.split(",").join(""))/setPrice;
				if($("#ordMarketB").val() == "HO" || $("#ordMarketB").val() == "HO_ETF") {
					vol		=	Math.floor(vol/10)*10;
				} else {
					vol		=	Math.floor(vol/100)*100;
				}
				
				<%-- if(volumeView > vol) {
					//console.log("Không đủ tiền");
					if ("<%= langCd %>" == "en_US") {
						alert("Insufficient fund");	
					} else {
						alert("Không đủ tiền");
					}

					return;
				} --%>
			
			if($("#orderTypeB").val() == "" || $("#orderTypeB").val() == "null" ||  $("#orderTypeB").val() == null) {
				$("#orderTypeB").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please select the Order Type!");	
				} else {
					alert("Vui lòng chọn loại lệnh!");
				}
				return;
			}
			
			if($("#stockB").val() == "") {
				$("#stockB").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Stock Code!");	
				} else {
					alert("Vui lòng nhập mã chứng khoán!");
				}

				return;
			}
			
			if($("#chkConditionB").is(":checked")) {
				if ($("#stopPriceViewB").val() == "" || $("#stopPriceViewB").val() == "0"){
					if ("<%= langCd %>" == "en_US") {
						alert("Please enter stop price!");	
					} else {
						alert("Vui lòng nhập giá dừng!");
					}
					return;
				}
			}
			
			if($("#volumeB").val() == 0) {
				$("#volumeViewB").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Quantity!");	
				} else {
					alert("Vui lòng nhập số lượng!");
				}
				return;
			}
			
			if($("#orderTypeB").val() == "LO") {
				if($("#mvMarketIdB").val() == "HA" || $("#mvMarketIdB").val() == "OTC") {
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
	
		if($("#orderTypeB").val() == "L" || $("#orderTypeB").val() == "LO") {
			if(priceView > 0) {
				if($("#mvMarketIdB").val() == "HO") {
					if ($("#ordMarketB").val() == "HO_ETF") {
						if(priceView <= 10000) {
							if(priceView % 10 != 0) {
								$("#priceViewB").focus();
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
								$("#priceViewB").focus();
								if ("<%= langCd %>" == "en_US") {
									alert("Invalid Price ticksize 10.");	
								} else {
									alert("Giá không hợp lệ cho bước giá 10.");
								}
								return;
							}
						} else if(priceView > 10000 && priceView <= 49500) {
							if(priceView % 50 != 0) {
								$("#priceViewB").focus();
								if ("<%= langCd %>" == "en_US") {
									alert("Invalid Price ticksize 50.");	
								} else {
									alert("Giá không hợp lệ cho bước giá 50.");
								}
								return;
							}
						} else if(priceView >= 50000) {
							if(priceView % 100 != 0) {
								$("#priceViewB").focus();
								if ("<%= langCd %>" == "en_US") {
									alert("Invalid Price ticksize 100.");	
								} else {
									alert("Giá không hợp lệ cho bước giá 100.");
								}
								return;
							}
						}
					}
				} else if($("#mvMarketIdB").val() == "HA") {
					if(priceView % 10 != 0) {
						$("#priceViewB").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Invalid Price ticksize 10.");	
						} else {
							alert("Giá không hợp lệ cho bước giá 10.");
						}
						return;
					}
				} else if($("#mvMarketIdB").val() == "OTC") {
					if(priceView % 10 != 0) {
						$("#priceViewB").focus();
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
	
			if(numDotComma($("#priceB").val()) == 0) {
				if($("#orderTypeB").val() == "L" || $("#orderTypeB").val() == "LO") {
				$("#priceViewB").focus();
				if ("<%= langCd %>" == "en_US") {
					alert("Please enter the Price!");	
				} else {
					alert("Vui lòng nhập giá!");
				}

				return;
				}
			}
			
			var ex = $("#expiryDate").val();
			var a = ex.split('/');
			var date = new Date (a[2], a[1] - 1,a[0]);//using a[1]-1 since Date object has month from 0-11
			var Today = new Date();
			if (date > Today && $("#chkExpiryB").is(":checked")) {
				
			} else {
				if(numDotComma($("#priceB").val()) > 0) {
					if((parseFloat($("#mvFloorB").val()) > parseFloat(numDotComma($("#priceB").val()))) || (parseFloat($("#mvCeilingB").val()) < parseFloat(numDotComma($("#priceB").val())))) {
						$("#priceViewB").focus();
						if ("<%= langCd %>" == "en_US") {
							alert("Order price is out of price spread (" + numIntFormat($("#mvFloorB").val()) + " to " + numIntFormat($("#mvCeilingB").val()) + "), please input again!");	
						} else {
							alert("Giá đặt nằm ngoài biên độ từ (" + numIntFormat($("#mvFloorB").val()) + " đến " + numIntFormat($("#mvCeilingB").val()) + "), vui lòng nhập lại!");
						}
						return;
					}
				}
			}			

		if ($("#chkExpiryB").is(":checked")) {
			orderOpen();
		} else {
			queryMarketStatusInfo();
		}
	}

	function queryMarketStatusInfo() {
		$("#tab41").block({
			message : "<span>LOADING...</span>"
		});
		
		var marketId	=	$("#mvMarketIdB").val();
		if(marketId == "" || marketId == "null" || marketId == null) {
			var bef_rmark	=	$("#tab31").find("input[name='bidMark']").val();
			marketId	=	displayMarketID(bef_rmark);
		}
		
		console.log(marketId); 
		
		var param = {
			mvMarketID : marketId
			,mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>")
		};
		
		

		$.ajax({
					dataType : "json",
					url : "/margin/data/queryMarketStatusInfo.do",
					data : param,
					asyc : true,
					cache : false,
					success : function(data) {
						//console.log(data);
						if (data.jsonObj != null) {
							$("#tab41").unblock();
							if (data.jsonObj.mvMarketID == "HO") {
								if (data.jsonObj.mvMarketStatus == "T1"
										|| data.jsonObj.mvMarketStatus == "T2"
										|| data.jsonObj.mvMarketStatus == "T3"
										|| data.jsonObj.canEnterOrder  == "true") {
									orderOpen();
								} else {
									if ("<%= langCd %>" == "en_US") {
										alert("Out of time for order in " + displayMarketCode(data.jsonObj.mvMarketID));
									} else {
										alert("Hết thời gian đặt lệnh " + displayMarketCode(data.jsonObj.mvMarketID));
									}
								}
							} else if (data.jsonObj.mvMarketID == "HA") {
								if (data.jsonObj.mvMarketStatus == null
										|| data.jsonObj.mvMarketStatus == "13") {
									if ("<%= langCd %>" == "en_US") {
										alert("Out of time for order in " + displayMarketCode(data.jsonObj.mvMarketID));
									} else {
										alert("Hết thời gian đặt lệnh " + displayMarketCode(data.jsonObj.mvMarketID));
									}
								} else {
									orderOpen();
								}
							} else if (data.jsonObj.mvMarketID == "OTC") {
								if (data.jsonObj.mvMarketStatus == null
										|| data.jsonObj.mvMarketStatus == "13") {
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
					error : function(e) {
						console.log(e);
						$("#tab41").unblock();
					}
				});
	}

	function orderOpen() {		
		var expiryDate = ($("#chkExpiryB").is(":checked") ? $("#expiryDate").val() : "");
		var advancedDate = ($("#chkAdvanced").is(":checked") ? $("#advancedDate").val() : "");
		$("#orderTypeNmB").val($("#orderTypeB option:selected").text());
		$("#expiryDtB").val(expiryDate);
		$("#advancedDtB").val(advancedDate);
		
		if ($("#chkConditionB").is(":checked")) {			
			$("#mvStopB").val("Y");
			$("#mvStopTypeB").val($("#ojCondTypeB").val());
			$("#mvStopPriceB").val($("#stopPriceViewB").val());			
		} else {
			$("#mvStopB").val("N");
			$("#mvStopTypeB").val("");
			$("#mvStopPriceB").val("");
		}
		
		//fix bug market ID = ""
		var marketId	=	$("#mvMarketIdB").val();
		if(marketId == "" || marketId == "null" || marketId == null) {
			//marketId	=	$("#ordMarketB").val();
			var bef_rmark	=	$("#tab31").find("input[name='bidMark']").val();
			marketId	=	displayMarketID(bef_rmark);
			$("#mvMarketIdB").val(marketId);
		}
		enterOpenPopupBuySell = true;
		$.ajax({
			type : "POST",
			url : "/trading/popup/orderConfirm.do",
			data : $("#frmEnterOrder").serialize(),
			dataType : "html",
			success : function(data) {
				$("#divEnterOrderPop").fadeIn();
				$("#divEnterOrderPop").html(data);
				enterOpenPopupBuySell = true;
			},
			error : function(e) {
				console.log(e);
				enterOpenPopupBuySell = false;
			}
		});
	}

	function buyClick() {
		$("#tab41").find("input[name='volumeB']").val(0);
		$("#tab41").find("input[name='priceB']").val(0);
		$("#tab41").find("input[name='volumeViewB']").val('');
		$("#tab41").find("input[name='priceViewB']").val('');

		volumeChange();
		priceChange();

		$("#ent_tbl").removeClass("sell");
		$("#tabOrdGrp2").tabs({
			active : 1
		});
	}

	function buyAllClick() {
		$("#ent_tbl").removeClass("sell");
		//$("#tabOrdGrp2").tabs({
		//	active : 1
		//});

		//	buying 파워 가져오기
		//	현재가 있는지 확인하기 없으면 1호가 가져오기
		//	buying 파워/입력가 = 수량 입력하기
		var buyingPwd = $("#trBuyingPower").html();
		var price = $("#priceViewB").val().split(",").join("");
/*
		if (price == "" || price == "0") {
			//price = $("#tab31").find("td[name='t_curr']").html();
			
			if (price == "" || price == "0" || price == undefined) {
				return;
			} else {
				price = price.split(",").join("");
			}
		}

		var maxMargin = $("#maxMarginB").val();
		if (maxMargin == "") {
			maxMargin = 0;
		}

		var setPrice = price * 1.005 * (1 - maxMargin / 100);
		var vol = Number(buyingPwd.split(",").join("")) / setPrice;

		if ($("#ordMarketB").val() == "HO" || $("#ordMarketB").val() == "HO_ETF") {
			vol = Math.floor(vol / 10) * 10;
		} else {
			vol = Math.floor(vol / 100) * 100;
		}
*/
		if ($("#mvInstrumentB").val() == "") {
			return;
		}
/*
		if (price == "" || price == "0") {
			price = $("#tab31").find("td[name='ceil']").html();
			if (price == "" || price == "0" || price == undefined) {
				return;
			} else {
				price = price.split(",").join("");
			}
		}
*/
		
		if($("#orderTypeB").val() != "L" && $("#orderTypeB").val() != "LO") {
			price = "";
		}
		if (price == "" || price == "0" || price == undefined) {
			price = $("#tab31").find("td[name='ceil']").html();
			$("#priceViewB").val(price);
		}
		
		var param = {
				mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>"),
			mvInstrument         : $("#mvInstrumentB").val(),
			mvMarketID           : $("#mvMarketIdB").val(),
			mvPrice				 : (price == "" ? "" : price / 1000),
			mvBuyingPower		 : Number(buyingPwd.split(",").join("")) / 1000
		};
		
		//console.log("Buy All Param 111111");
		//console.log(param);
		
		$.ajax({
			url:'/trading/data/genBuyAll.do',
			data:param,
			cache: false,
		  	dataType: 'json',
		  	success: function(data){
		  		//console.log("=====genBuyAll Data=======");
		  		//console.log(data);
		  		if (data.jsonObj.mvResult == "success") {
		  			$("#tab41").find("input[name='volumeViewB']").val(data.jsonObj.maxQty);
		  			volumeChange();

		  			$("#tab41").find("input[name='priceViewB']").val(price);
		  			priceChange();
		  			
		  		} else {
		  			$("#tab41").find("input[name='volumeViewB']").val('');
		  			volumeChange();

		  			$("#tab41").find("input[name='priceViewB']").val(price);
		  			priceChange();
		  		}
		  	}
		});
	}
	
	function maxVolumeBuy() {
		$("#ent_tbl").removeClass("sell");
		//$("#tabOrdGrp2").tabs({
		//	active : 1
		//});

		//	buying 파워 가져오기
		//	현재가 있는지 확인하기 없으면 1호가 가져오기
		//	buying 파워/입력가 = 수량 입력하기
		var buyingPwd = $("#trBuyingPower").html();
		var price = $("#priceViewB").val().split(",").join("");			
/*
		if (price == "" || price == "0") {
			//price = $("#tab31").find("td[name='t_curr']").html();
			price = $("#tab31").find("td[name='t_curr']").html();
			if (price == "" || price == "0" || price == undefined) {
				return;
			} else {
				price = price.split(",").join("");
			}
		}

		var maxMargin = $("#maxMarginB").val();
		if (maxMargin == "") {
			maxMargin = 0;
		}

		var setPrice = price * 1.005 * (1 - maxMargin / 100);
		var vol = Number(buyingPwd.split(",").join("")) / setPrice;
		
		if ($("#ordMarketB").val() == "HO" || $("#ordMarketB").val() == "HO_ETF") {
			vol = Math.floor(vol / 10) * 10;
		} else {
			vol = Math.floor(vol / 100) * 100;
		}
*/
		if ($("#mvInstrumentB").val() == "") {
			return;
		}
/*
		if (price == "" || price == "0") {
			price = $("#tab31").find("td[name='ceil']").html();			
			if (price == "" || price == "0" || price == undefined) {
				return;
			} else {
				price = price.split(",").join("");
			}
		}
*/		
		if($("#orderTypeB").val() != "L" && $("#orderTypeB").val() != "LO") {
			price = "";
		}
		if (price == "" || price == "0" || price == undefined) {
			price == "";
		}
		
		var param = {
				mvSubAccountID	:	(subAcc != undefined ? subAcc : "<%= session.getAttribute("subAccountID") %>"),
			mvInstrument         : $("#mvInstrumentB").val(),
			mvMarketID           : $("#mvMarketIdB").val(),
			mvPrice				 : (price == "" ? "" : price / 1000),
			mvBuyingPower		 : Number(buyingPwd.split(",").join("")) / 1000
		};
		
		//console.log("Buy All Param");
		//console.log(param);
		
		$.ajax({
			url:'/trading/data/genBuyAll.do',
			data:param,
			cache: false,
		  	dataType: 'json',
		  	success: function(data){
		  		//console.log("=====genBuyAll Data=======");
		  		//console.log(data);
		  		if (data.jsonObj.mvResult == "success") {
		  			$("#tab41").find("input[name='maxVolume']").val(data.jsonObj.maxQty);
		  			maxVolumeChange();
		  		} else {
		  			$("#tab41").find("input[name='maxVolume']").val(0);
		  			maxVolumeChange();
		  		}
		  	}
		});			
	}

	//주문타입 변경시 action 정의
	function chgOrdType(type) {
		if (type == "L" || type == "O" || type == "C" || type == undefined) {
			$("#tab41").find("#chkExpiryB").attr("disabled", false);
			$("#tab41").find("#chkConditionB").attr("disabled", false);
		} else {
			$('#chkExpiryB').prop('checked', false);
			$("#tab41").find("#chkExpiryB").attr("disabled", true);
			$("#tab41").find("#chkExpiryB").val("off");
			$("#tab41").find("#expiryDate").attr("disabled", true);
			$("#tab41").find("#expiryDate").datepicker("disable");
			
			$('#chkConditionB').prop('checked', false);
			$("#tab41").find("#chkConditionB").attr("disabled", true);
			$("#tab41").find("#ojCondTypeB").attr("disabled", true);
			$("#tab41").find("#stopPriceViewB").attr("disabled", true);
			
			$("#tab41").find("#chkConditionB").val("N");
			$("#tab41").find("#ojCondTypeB").val("U");
			$("#tab41").find("#stopPriceViewB").val("0");
		}
		if(type == "L" || type == "LO" || type == undefined) {
			$("#priceViewB").attr("disabled", false);
			$("#priceViewB").show();
			$("#priceViewB").val('');
			$("#priceB").val("");
		} else {
			$("#priceViewB").attr("disabled", true);
			$("#priceViewB").hide();
			volumeChange();
		}
		maxVolumeBuy();
	}
	
	// Key Event
	function keyDownEvent(id, e) {		
		if (e.keyCode == "13") {
			enterOrderSubmit()
		} else {
		if ($("#" + id).val() == "0") {
			if (e.keyCode == "190") {
				$("#" + id).val("0");
			} else {
				$("#" + id).val("");
			}
		}
		}
	}
</script>
<style>
/* 2017.04.10 추가 김정순*/
.eo_table {
	
}

.eo_table th {
	/*background: #17a668;*/
	background: #edf6e9;
}

#divOrdStock li.active { background:#d0d0d0;}
#divBidStock li.active { background:#d0d0d0;}
</style>
</head>

<body class="mdi">
	<div class="tab_content margin_top_0">
		<div role="tabpanel" class="tab_pane" id="tab41">
			<form id="frmEnterOrder" autocomplete="Off"> 
				<input type="hidden" id="mvEnableOrderTypeB" name="mvEnableOrderTypeB" value=""> 
				<input type="hidden" id="mvInstrumentB" name="mvInstrumentB" value=""> 
				<input type="hidden" id="mvStockNameB" name="mvStockNameB" value=""> 
				<input type="hidden" id="mvMarketIdB" name="mvMarketIdB" value=""> 
				<input type="hidden" id="mvMarketIdListB" name="mvMarketIdListB" value="">
				<input type="hidden" id="mvEnableGetStockInfoB" name="mvEnableGetStockInfoB" value=""> 
				<input type="hidden" id="mvActionB" name="mvActionB" value="OI,BP,FE"> 
				<input type="hidden" id="mvTemporaryFeeB" name="mvTemporaryFeeB" value="">
				<input type="hidden" id="maxMarginB" name="maxMarginB" value="">
				<input type="hidden" id="lendingB" name="lendingB" value=""> 
				<input type="hidden" id="valueB" name="valueB" value=""> 
				<input type="hidden" id="netFeeB" name="netFeeB" value=""> 
				<input type="hidden" id="mvBankIDB" name="mvBankIDB" value=""> 
				<input type="hidden" id="mvBankACIDB" name="mvBankACIDB" value=""> 
				<input type="hidden" id="buyingPowerB" name="buyingPowerB" value="">
				<input type="hidden" id="orderTypeNmB" name="orderTypeNmB" value="">
				<input type="hidden" id="expiryDtB" name="expiryDtB" value="">
				<input type="hidden" id="advancedDtB" name="advancedDtB" value="">
				<input type="hidden" id="refIdB" name="refIdB" value=""> 
				<input type="hidden" id="mvCeilingB" name="mvCeilingB" value=""> 
				<input type="hidden" id="mvFloorB" name="mvFloorB" value=""> 
				<input type="hidden" id="divIdB" name="divIdB" value="divEnterOrderPop">
				<input type="hidden" id="todayB" name="todayB" value=""> 
				<input type="hidden" id="ordMarketB" name="ordMarketB" />
				<!-- Order Market -->
				<input type="hidden" id="buySellB" name="buySellB" value="B" />
				<input type="hidden" id="bankAccountYnB" name="bankAccountYnB"/>
				
				<!-- Condition Order -->
				<input type="hidden" id="mvStopB" name="mvStopB" value="N">
				<input type="hidden" id="mvStopTypeB" name="mvStopTypeB" value="">
				<input type="hidden" id="mvStopPriceB" name="mvStopPriceB" value="">

				<!-- 2017.04.05 new 김정순 -->
				<div class="group_table  margin_top_0 radius_top abced"
					style="border: none;">
					<table class="eo_table no_bbt" id="ent_tbl"
						style="border-top: 1px solid #c9d1d5; border-left: 1px solid #c9d1d5; border-bottom: 1px solid #c9d1d5; border-radius: 4px 4px 4px 4px;">
						<colgroup>
							<col style="width: auto;"/>
							<col />
						</colgroup>
						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Account" : "Tài khoản")%>
								<select id="subAccountTypeNameB" name="subAccountTypeNameB" title="Sub Account Name" style="display : none;"></select>
								<span id="accTypeNameB" name="accTypeNameB" style="font-weight: bold;font-size: larger;color:blue !important;"></span>
							</th>
							<td>
								<!-- <select id="subAccountBshow" name="subAccountBshow" onchange="chgSubAccountBshow(this.value);" title="Sub Account" style="width: auto;color: blue;min-height: 35px;font-weight: bold;font-size: larger;"></select> -->
								<select id="subAccountB" name="subAccountB" onchange="chgSubAccountB(this.value);" title="Sub Account" style="width: auto;color: blue;min-height: 35px;font-weight: bold;font-size: larger;"></select>
								<input type="text" id="accNameB" name="accNameB" style="width: auto;min-height: 35px;font-weight: bold;font-size: larger;" disabled>
							</td>
						</tr>
						<tr>
							<th style="height: 20px; border-radius: 3px 0 0 0"><%=(langCd.equals("en_US") ? "Stock" : "Mã CK")%></th>
							<td style="border-radius: 0 3px 0 0;">
							 <!-- Add search full stock -->
								<div style="float:left;" class="layer_search_EB">
									<button type="button" class="search_full_stock" style="background:url(/resources/images/bg_search.png) no-repeat 50%;top:-3px;"></button>						
									<div class="layer_EB" style="right:100px;width:330px;">
										<h2><%= (langCd.equals("en_US") ? "STOCK SEARCH" : "MÃ TÌM KIẾM") %></h2>
										<div class="search_area">
											<label for="schNamePopEB"><%= (langCd.equals("en_US") ? "Name" : "Tên") %></label>
											<div class="input_search" style="display:block;top:5px;">
												<input style="float:left;width:92%;" type="text" id="schNamePopEB" name="schNamePopEB" onkeyup="searchStockEB(event)">
												<button style="float:right;height:20px;top:-2px;" type="button" id="schStockPopEB" name="schStockPopEB"></button>
											</div>
										</div>
										<div>
											<div style="position:relative; padding:8px 0;">
												<div>
													<input style="width:12px;" type="radio" id="schMarketPopALLEB" name="schMarketPopEB" value="ALL" checked="checked"><label style="display:inline;padding-left:5px;" for="schMarketPopALLEB">All</label>											
													<input style="width:12px;" type="radio" id="schMarketPopHOEB" name="schMarketPopEB" value="HOSE"><label style="display:inline;padding-left:5px;" for="schMarketPopHOEB">HOSE</label>
													<input style="width:12px;" type="radio" id="schMarketPopHAEB" name="schMarketPopEB" value="HNX"><label style="display:inline;padding-left:5px;" for="schMarketPopHAEB">HNX</label>
													<input style="width:12px;" type="radio" id="schMarketPopOTCEB" name="schMarketPopEB" value="UPCOM"><label style="display:inline;padding-left:5px;" for="schMarketPopOTCEB">UPCOM</label>
													<input style="width:12px;" type="radio" id="schMarketPopCWEB" name="schMarketPopEB" value="HOSE"><label style="display:inline;padding-left:5px;" for="schMarketPopCWEB">CW</label>						
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
															<tbody id="grdStockPopEB">
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
								<div id="ent_sch_stock" class="input_dropdown">
									<!-- style="display: none"> -->
									<span> <input type="text" id="stockB" name="stockB" onkeyup="getStock(event)" />
										<button tabindex=-1 type="button" onclick="divOrdShowHide()"></button>
									</span>
									<div id="divOrdStock">
										<ul id="ulOrdStock">
										</ul>
									</div>
								</div>								
								<span id="lbLending"></span>								
								<span class="code" name="b_bid_mark"></span>
								<button type="button" class="btn" onclick="stockInfoPop();">!</button>
								<span style="color:red!important;" name="b_bid_divi"></span>
								</td>
						</tr>
						<tr >
							<th><%=(langCd.equals("en_US") ? "Company name" : "Tên công ty")%></th>
							<td>
							<span class="name" name="bid_snam" id="bid_sname"></span>
							</td>
						</tr>
						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Order Type" : "Loại lệnh")%></th>
							<td><select id="orderTypeB" name="orderTypeB" onchange="chgOrdType(this.value);" title="Order Type" style="width: 60%;">
							</select></td>
						</tr>
						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Price" : "Giá")%></th>
							<td><input type="hidden" id="priceB" name="priceB" value="">
								<input class="text won" type="text" id="priceViewB"	name="priceViewB" value="" onkeyup="priceChange(event)" onkeydown="keyDownEvent(this.id, event)" onchange="keyDownEvent(this.id, event)" onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)"	style="width: 60% !important">
								<label style="color:red !important; display: none;"><%=(langCd.equals("en_US") ? "Max Vol:" : "Max KL:")%></label>
								<input tabindex=-1 value="0" id="maxVolume" name="maxVolume" style="color:#959595 !important; display: none;">
							</td>
						</tr>
						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Volume" : "Khối lượng")%></th>
							<td><input type="hidden" id="volumeB" name="volumeB" value="">
								<input class="text won" type="text" id="volumeViewB" name="volumeViewB" value="" onkeyup="volumeChange(event)"	onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)" onkeypress="isNum();" style="width: 60% !important">
								<!-- <button type="button" class="all_btn">all</button> -->
								<button type="button" class="all_btn" onclick="buyAllClick();">all</button>								
							</td>
						</tr>
						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Expiry date" : "Lệnh đến hạn")%></th>
							<td><input type="checkbox" id="chkExpiryB" name="chkExpiryB"
								onclick="chkExpiryDate()" value="off" style="margin-right: 5px">
								<input type="text" id="expiryDate" name="expiryDate"
								class="datepicker" disabled="disabled" style="color: #000">
							</td>
						</tr>
						<%-- 
						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Order Condition" : "Lệnh điều kiện")%></th>
							<td>
								<input type="checkbox" id="chkConditionB" name="chkConditionB" onclick="chkOrderCondition()" value="off" style="margin-right: 5px">
								<select id="ojCondTypeB" style="width:100px;" disabled="disabled">									
									<option value="U">Up</option>
									<option value="D">Down</option>
								</select>
								<label><%=(langCd.equals("en_US") ? "Price" : "Giá")%></label>
								<input class="text won" type="text" id="stopPriceViewB"
								name="stopPriceViewB" value="" onkeyup="stopPriceChange(event)"
								onkeydown="keyDownEvent(this.id, event)"
								onfocus="onFocusIn(this.id)" onBlur="onFocusOut(this.id)"
								style="width: 25% !important" disabled="disabled">
							</td>
						</tr>
						 --%>
						<tr style="display: none;">
							<th><%=(langCd.equals("en_US") ? "Max margin volume" : "SLCK cho vay t?i đa (S?c mua)")%></th>
							<td id="trMaxMargin" class="right"></td>
						</tr>

						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Buying Power" : "Sức mua dự kiến")%></th>
							<td id="trBuyingPower" class="right"></td>
						</tr>

						<tr>
							<th style="height: 20px;"><%=(langCd.equals("en_US") ? "Buy Value" : "Giá trị")%></th>
							<td id="trValue" class="right">0</td>
						</tr>
						<%-- 
						<tr>
							<th style="height: 20px; border-radius: 0 0 0 3px;"><%=(langCd.equals("en_US") ? "Net fee" : "Phí tạm tính")%></th>
							<td id="trNetFee" class="right" style="border-radius: 0 0 3px 0">0.00</td>
						</tr>
 						--%>
					</table>
				</div>


				<div class="mdi_bottom cb" style="text-align: right;">
					<input type="button" class="color"
						value="<%=(langCd.equals("en_US") ? "BUY" : "MUA")%>"
						onclick="enterOrderSubmit()"> <input type="button"
						value="<%=(langCd.equals("en_US") ? "Clear" : "Xóa")%>"
						onclick="clearData()">
				</div>
			</form>
			<!-- //BUY -->
		</div>
	</div>
	<!-- orderConfirm pop -->
	<div id="divEnterOrderPop" class="modal_wrap"></div>
	<!-- orderConfirm pop -->
</body>
<script>
$("#tab41").unblock();

</script>
</html>
