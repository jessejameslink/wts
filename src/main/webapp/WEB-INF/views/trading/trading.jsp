<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
%>


<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String login = (String) session.getAttribute("login");
	String authenMethod = (String) session.getAttribute("authenMethod");
	String saveAuth = (String) session.getAttribute("saveAuth");
%>

<html>
	<head>
		<script>		
		function stopWorker() { 
			if(worker)	worker.terminate(); 
		}

		//console.log("TRADING JSP HEAD  FIRST");
		var rtsServerIp	=	"${rtsServer}";
		var first = true;
		var firstBid = 1;
		var watchListSelect = false;
		var enterOpenPopupBuySell = false;
		
		
		//delay 500 enter key
		var keyup_timeout;
		var timeout_delay_in_ms = 500;
		
		
		$(document).ready(function() {
			document.title = "MIRAE ASSET WTS | <%= (langCd.equals("en_US") ? "TRADING" : "GIAO DỊCH") %>";
			//console.log("<%=authenMethod%>");	
			//console.log("<%=saveAuth%>");
			
			//mCheckSignVersion6();
			
			$("#tabOrdGrp1").tabs({active : ("<%= session.getAttribute("TAB_IDX1") %>" == "null" ? 0 : "<%= session.getAttribute("TAB_IDX1") %>")});
			$("#tabsGrp").val(("<%= session.getAttribute("TAB_IDX2") %>" == "null" ? 0 : "<%= session.getAttribute("TAB_IDX2") %>"))
			$("#tabOrdGrp3").tabs({active : ("<%= session.getAttribute("TAB_IDX3") %>" == "null" ? 0 : "<%= session.getAttribute("TAB_IDX3") %>")});
			
			
			$("#tabOrdGrp4").tabs({active : ("<%= session.getAttribute("TAB_IDX4") %>" == "null" || "<%= session.getAttribute("TAB_IDX4") %>" == "0" ? 0 : "<%= session.getAttribute("TAB_IDX4") %>")});						
			
			if ("<%= session.getAttribute("TAB_IDX4") %>" == "1") {
				$("#buytab").removeClass("on");
				$("#selltab").addClass("on");
				bsActiveTab(1);
			}
			
			//TAB ERROR RELATE
			$.fn.__tabs = $.fn.tabs;
			$.fn.tabs = function (a, b, c, d, e, f) {
			    var base = location.href.replace(/#.*$/, '');
			    $('ul>li>a[href^="#"]', this).each(function () {
			        var href = $(this).attr('href');
			        $(this).attr('href', base + href);
			    });
			    $(this).__tabs(a, b, c, d, e, f);
			};
						
			$("#buytab").click(function() {
				$("#tabsGrp").val('1');				
				bsActiveTab(0);
			});
			
			$("#selltab").click(function() {
				$("#tabsGrp").val('1');
				
				bsActiveTab(1);
			});
			
			if ("<%= authenMethod %>" != "matrix") {
				if (("<%= authenMethod %>" == "swotp") || ("<%= authenMethod %>" == "hwotp")) {
					if ("<%= login %>" == "login") {
						mCheckOTP();					
						<%session.setAttribute("login", "");%>
					}
				}
			} else {
				if ("<%= login %>" == "login") {
					authCheck();
					<%session.setAttribute("login", "");%>
				}	
			}			
			
			$("#divBidStock").hide();
			
			$(".layer_search_btn .layer_search").hide();
			$('.layer_search_btn button').click(function(e){
				var self = $(this);
				
				if(self.closest('.btn_wrap').length){ // sub layer button
					self.closest('.layer_search').hide();
					$('.layer_search_btn button').removeClass('on');
				} else { // layer toggle button
					if(!self.closest('.search_area').length) {
						self.toggleClass('on');
						$('.layer_search_btn button').not(this).removeClass('on');
						$('.layer_search_btn .layer_search').not($(this).next()).hide();
						self.next().toggle();
						$("#schNamePopS").val("");
						$("#schMarketPopALLS").prop('checked', true);
						if ($('.layer_search_btn button').hasClass('on')) {
							getStockPopS();
						}
					} else {						
						getStockPopS();
					}
				}
			});
			
			//Stock search
			$("#schMarketPopALLS").on('change', function(e) {
				getStockPopMarketS("ALL");
			});
			$("#schMarketPopHOS").on('change', function(e) {			
				getStockPopMarketS("HOSE");
			});
			$("#schMarketPopHAS").on('change', function(e) {
				getStockPopMarketS("HNX");
			});
			$("#schMarketPopOTCS").on('change', function(e) {		
				getStockPopMarketS("UPCOM");
			});
			$("#schMarketPopCWS").on('change', function(e) {			
				getStockPopMarketS("CW");
			});
		});
		
		function mCheckOTP() {
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
						authOtpCheck();
					}
				}
			});	
		}
		
		function mCheckSignVersion6() {
			var param = {
					mvUserID 		: '<%=session.getAttribute("ClientV")%>'
				};
			//console.log("Check checkSignContracts");
			$.ajax({
				url      : "/trading/data/checkSignContracts.do",
				contentType	:	"application/json; charset=utf-8",
				data     : param,
				dataType : "json",
				success  : function(data) {
					//console.log(data);
					if (data.signResponseCheck.result != "0") {
						console.log("Check checkSignContracts");
					}
				}
			});	
		}
		
		function bsActiveTab(tab) {
			var param = {
					mvTab	: tab
			};
			
			//console.log(param);

			$.ajax({
				dataType  : "json",
				cache		: false,
				url       : "/trading/data/bsActiveTab.do",
				data      : param,
				success   : function(data) {
					
				},
				error     :function(e) {					
					console.log(e);
				}
			});		
		}

		/*
			@Function : When selected, all windows event event propagation
		*/
		function trdSelItem(rcod, mark) {
			//console.log("TRD SEL ITEM CALL");
			var tabId1 = $("#tabOrdGrp3 ul li[class*=active]").find("a").attr("id");			
			
			if(tabId1 == "ui-id-37") {
				Ext_SetBID(rcod);
			} else if(tabId1 == "ui-id-21") {
				Ext_SetInfo(rcod);
			}
			
			firstBid = 0;
			$("#dailySymb").val(rcod);
			$("#dailySkey").val("");
			$("#grdDaily").find("tr").remove();
			$("#timelySkey").val("");
			$("#grdTimely").find("tr").remove();
			Ext_SetOrderStock(rcod);
			
			var tabId = $("#tabOrdGrp2 ul li[class*=active]").attr("id");
			if(tabId == "daytab") {
				getDailyList();
			} else if(tabId == "timtab") {
				getTimelyList();
			} else if (tabId == "newstab") {
				searchStockNewsList();
			} else if (tabId == "chrtab") {
				initChart();
			} else if (tabId == "prftab") {
				getAllProfileData();
			} else if (tabId == "indtab") {
				getIndustryPeersCount(1);
			} else if (tabId == "fintab") {
				getFinancialsHeader(1);
			}
			
			watchListSelect = true;
		}

		/*
			@Function : When selected, all windows event event propagation
						No Refresh Enter Order
		*/
		function trdSelItemNoOrd(rcod, mark) {
				
			if (watchListSelect == true) {
				watchListSelect = false;
				return;
			}
			var tabId1 = $("#tabOrdGrp3 ul li[class*=active]").find("a").attr("id");			
			if(tabId1 == "ui-id-37") {
				Ext_SetBID(rcod);
			} else if(tabId1 == "ui-id-21") {
				Ext_SetInfo(rcod);
			}
			firstBid = 0;
			$("#dailySymb").val(rcod);
			$("#dailySkey").val("");
			$("#grdDaily").find("tr").remove();
			$("#timelySkey").val("");
			$("#grdTimely").find("tr").remove();
			
			var tabId = $("#tabOrdGrp2 ul li[class*=active]").attr("id");
			if(tabId == "daytab") {
				getDailyList();
			} else if(tabId == "timtab") {
				getTimelyList();
			} else if (tabId == "newstab") {
				searchStockNewsList();
			} else if (tabId == "chrtab") {
				initChart();
			} else if (tabId == "prftab") {
				getAllProfileData();
			} else if (tabId == "indtab") {
				getIndustryPeersCount(1);
			} else if (tabId == "fintab") {
				getFinancialsHeader(1);
			}
		}
		
		var timelyErrCnt	=	0;
		
		function getTimelyList() {
			
			
			if ($("#timelySkey").val() == "end") {
				return;
			}
			$("#tab25").block({message: "<span>LOADING...</span>"});
			var param = {
				  symb  : $("#dailySymb").val()
				, skey  : $("#timelySkey").val()
			};

			$.ajax({
				url      : "/trading/data/getTimelyList.do",
				data     : param,
				dataType : 'json',
				success  : function(data){
					if(data.timelyList != null) {
						if(data.timelyList.list1 != null) {
							var htmlStr = "";
							for(var i=0; i < data.timelyList.list1.length; i++) {
								var timelyList = data.timelyList.list1[i];
								var cssColor  = displayColor(timelyList.diff.substring(0, 1));
								var cssArrow  = displayArrow(timelyList.diff.substring(0, 1));
								htmlStr += "<tr>";
								htmlStr += "	<td class=\"text_center\">" + getTime(timelyList.mtim) + "</td>"; // Time
								htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(timelyList.curr.substring(1)) + "</td>"; // Current
								htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(timelyList.diff.substring(1)) + "</td>"; // +/-
								if (timelyList.rate.substring(1) == "inf") {
									htmlStr += "	<td class='" + cssColor + "'>" + "0.00" + "</td>"; // %Change
								} else {
									htmlStr += "	<td class='" + cssColor + "'>" + timelyList.rate.substring(1) + "</td>"; // %Change
								}
								var ch = timelyList.lvol.substring(0, 1);
								var vol;
								var volColor	=	upDownColor(timelyList.lvol);								
								htmlStr += "	<td class='" + volColor + "'>" + upDownNumList(timelyList.lvol.substring(1)) + "</td>"; // Volume
								htmlStr += "	<td class=''>" + upDownNumList(timelyList.avol) + "</td>"; // Total Volume.
								htmlStr += "</tr>";
							}
							$("#grdTimely").append(htmlStr);
						}
						if (data.timelyList.skey == "") {
							data.timelyList.skey = "end";
						}
						$("#timelySkey").val(data.timelyList.skey);
					}
					
					$('#timelyTbl').floatThead('reflow');
					
					
					$("#timelyNext").val(data.timelyList.next);
					$("#tab25").unblock();
				},
				error     :function(e) {
					console.log(e);
					$("#tab25").unblock();
					if(timelyErrCnt < 1) {
						getTimelyList();
					}
				}
			});
		}
		
		function Ext_SetEnterOrder(stock, market, price) {
			var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
			console.log("TAB ID CHECK++++++++++++++");
			//console.log(tabId);
			if(tabId == "buytab") {
				bidClearData();
				$("#stockB").val(stock);
				$("#mvMarketIdB").val(displayMarketID(market));
				$("#priceB").val(numIntFormat(numDotComma(price)));
				$("#priceViewB").val(numIntFormat(numDotComma(price)));
				priceChange();
			} else {
				//console.log("SELL CLEAR DATA==>");
				bidClearData();
				$("#tab49").find("#stockS").val(stock);
				$("#tab49").find("#mvMarketIdS").val(displayMarketID(market));
				$("#tab49").find("#priceS").val(numIntFormat(numDotComma(price)));
				$("#tab49").find("#priceViewS").val(numIntFormat(numDotComma(price)));
				priceChange();
			}
		}
		
		function getStockPopS() {
			var param = {
				  stockCd  :  $("#schNamePopS").val()
				, marketId :  $("input[name=schMarketPopS]:checked").val()
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
							stockStr += "<tr onclick=\"selectRowPopS('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
							stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
							stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
							stockStr += "</tr>";
						}
						$("#grdStockPopS").html(stockStr);
					}					
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		function getStockPopMarketS(market) {
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
									stockStr += "<tr onclick=\"selectRowPopS('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
									stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
									stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
									stockStr += "</tr>";
								}	
							} else {
								var stockNm   = ("<%= langCd %>" == "en_US" ? stockList.secNm_en : stockList.secNm_vn);
								stockStr += "<tr onclick=\"selectRowPopS('" + stockList.synm + "')\" style=\"cursor: pointer;\">";
								stockStr += "	<td class=\"text_center\" id=\"trStock\">"  + stockList.synm + "</td>";
								stockStr += "	<td class=\"text_left\"><p class=\"ellipsis\" id=\"trStockNm\">" + stockNm + "</p></td>";
								stockStr += "</tr>";	
							}							
						}
						$("#grdStockPopS").html(stockStr);
					}					
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		function searchStockS(evt) {
			$("#schNamePopS").val($("#schNamePopS").val().toUpperCase());
			if(evt.keyCode == 13) {
				
				//delay enter key
				
				clearTimeout(keyup_timeout); // Clear the previous timeout so that it won't be executed any more. It will be overwritten by a new one below.
		        keyup_timeout = setTimeout(function() {
		            // Perform your magic here.
		        }, timeout_delay_in_ms);
				
				
				getStockPopS();
			}
		}
		
		function selectRowPopS(symb) {
			selItem(symb);
			$(".layer_search_btn .layer_search").hide();
		}
		
	
		/*
			Trading Company changes the entire screen when you select favorite stocks
			@TODO : Full and sole window when the window Add consider when distinguishing code
			@Create Date : 2016/08/31
			@Create By : Temi
			@Modyfy History
			-
		*/
		function selItem(rcod) {
			if (first == true) {
				first = false;
			} else {
			}
			trdSelItem(rcod);                               // Trading Window Action Define
		}
		 
		function realData_B(data) {
			//console.log("@@@@  REAL DATA B CALL");
			//console.log(data);
			if ($("#dailySymb").val() == data.code) {
				bindTprc(data);	
			}
			readTprcWatch(data);
			$('#watchlst').floatThead('reflow');
		}
		
		function realData_H(data) {
			//console.log("@@@@  REAL DATA H CALL");
			//console.log(data);
			if ($("#dailySymb").val() == data.code) {
				bindTprc(data);	
			}
			readTprcWatch(data);
			$('#watchlst').floatThead('reflow');
		}
		
		function realData_C(data) {
			//console.log("@@@@  REAL DATA C CALL");
			readForeignerData(data);
			if ($("#dailySymb").val() == data.code) {
				bindForeigner(data);	
			}
			$('#watchlst').floatThead('reflow');
		}
		
		function realData_Y(data) {			
			readEstimateData(data);
			if ($("#dailySymb").val() == data.code) {
				bindEstimatePrice(data);	
			}
			$('#watchlst').floatThead('reflow');
		}
		
		
		function bindActive() {
			
		}
		
		function bindTopMovers() {
			
		}
		
		function bindDaily(data) {
			var cssColor  = displayColor(data.value["024"].substring(0, 1));
			$("#" + $("#chkDate").val()+"_prev").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor).html(zeroUpDownNumList(data.value["023"].substring(1)));
			$("#" + $("#chkDate").val()+"_diff").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor).html(zeroUpDownNumList(data.value["024"].substring(1)));
			$("#" + $("#chkDate").val()+"_chg").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor).html(zeroUpDownNumList(data.value["033"].substring(1)));
			$("#" + $("#chkDate").val()+"_vol").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor).html(zeroUpDownNumList(data.value["027"]));
			$("#" + $("#chkDate").val()+"_high").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor).html(zeroUpDownNumList(data.value["030"].substring(1)));
			$("#" + $("#chkDate").val()+"_low").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor).html(zeroUpDownNumList(data.value["031"].substring(1)));
			
		}
		
		function readForeignerData(data) {
			//console.log("@@@@  REAL FOREIGNER WATCH");
			if ($("#srow_"+data.code).find("#trFBuy").html() != zeroUpDownNumList(data.value["122"])) {
				$("#srow_"+data.code).find("#trFBuy").html(zeroUpDownNumList(data.value["122"])).removeClass("highlight").toggleClass("highlight rehighlight");	//	현재가
			}
			if ($("#srow_"+data.code).find("#trFSell").html() != zeroUpDownNumList(data.value["121"])) {
			$("#srow_"+data.code).find("#trFSell").html(zeroUpDownNumList(data.value["121"])).removeClass("highlight").toggleClass("highlight rehighlight");		//	체결수량
			}
		}
		
		function readEstimateData(data) {
			//console.log("@@@@  REAL DATA Y CALL");
			//console.log(data);
			
			var cssColor  = displayColorWatch(data.value["223"].substring(0, 1));
			if (data.value["223"].substring(1) != 0) {
				if ($("#srow_"+data.code).find("#trPrice").html() != zeroUpDownNumList(data.value["223"].substring(1))) {
					$("#srow_"+data.code).find("#trPrice").html(zeroUpDownNumList(data.value["223"].substring(1))).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");	//	현재가
				} else {
					$("#srow_"+data.code).find("#trPrice").html(zeroUpDownNumList(data.value["223"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);	//	현재가
				}
				
				if (data.value["227"] == 0) {
					$("#srow_"+data.code).find("#trVol").html("");
				} else {
					if ($("#srow_"+data.code).find("#trVol").html() != zeroUpDownNumList(data.value["227"])) {
						$("#srow_"+data.code).find("#trVol").html(zeroUpDownNumList(data.value["227"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");		//	체결수량
					} else {
						$("#srow_"+data.code).find("#trVol").html(zeroUpDownNumList(data.value["227"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);		//	체결수량
					}
				}
				var updown = Math.abs(parseInt(numDotComma(data.value["223"].substring(1))) - parseInt(numDotComma($("#srow_"+data.code).find("#trRef").html())));
				
				if (updown != 0) {
				if ($("#srow_"+data.code).find("#trUpDown").html() != numIntFormat(updown)) {
					$("#srow_"+data.code).find("#trUpDown").html(numIntFormat(updown)).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");	//	대비				
				} else {
					$("#srow_"+data.code).find("#trUpDown").html(numIntFormat(updown)).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);	//	대비
				}
				} else {
					$("#srow_"+data.code).find("#trUpDown").html("");
				}
				$("#srow_"+data.code).find("#trPer").html("");		//	등락율
			}					
		}
		
		function readTprcWatch(data) {
			//console.log("REAL PRICE WATCH");
			//console.log(data);//td[id='bid_rcod']
			var cssColorB  = displayColorWatch(data.value["071"].substring(0, 1));
			var cssColorB1  = displayColorWatch(data.value["072"].substring(0, 1));
			var cssColorB2  = displayColorWatch(data.value["073"].substring(0, 1));
			var cssColorS  = displayColorWatch(data.value["051"].substring(0, 1));
			var cssColorS1  = displayColorWatch(data.value["052"].substring(0, 1));
			var cssColorS2  = displayColorWatch(data.value["053"].substring(0, 1));
			
			if (data.value["071"].substring(1) != 0) {
				if ($("#srow_"+data.code).find("#trBidPri1").html() != diffNumWatch(data.value["071"])) {
					$("#srow_"+data.code).find("#trBidPri1").html(diffNumWatch(data.value["071"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB).toggleClass("highlight rehighlight");	//	현재가
				} else {
					$("#srow_"+data.code).find("#trBidPri1").html(diffNumWatch(data.value["071"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB);	//	현재가
				}
				if ($("#srow_"+data.code).find("#trBidVol1").html() != zeroUpDownNumList(data.value["061"])) {
				$("#srow_"+data.code).find("#trBidVol1").html(zeroUpDownNumList(data.value["061"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB).toggleClass("highlight rehighlight");		//	체결수량
				} else {
					$("#srow_"+data.code).find("#trBidVol1").html(zeroUpDownNumList(data.value["061"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB);		//	체결수량
				}
			} else {
				var date = new Date();
				var flagT = "";
				if (date.getHours() > 13) {
					flagT = "ATC";
				} else {
					flagT = "ATO";
				}
				if (data.value["072"].substring(1) != 0) {
				if ($("#srow_"+data.code).find("#trBidPri1").html() != diffNumWatch(data.value["071"])) {
					$("#srow_"+data.code).find("#trBidPri1").html(flagT).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower");	//	현재가
				}
				} else {
					if ($("#srow_"+data.code).find("#trBidPri1").html() != diffNumWatch(data.value["071"])) {
						$("#srow_"+data.code).find("#trBidPri1").html(diffNumWatch(data.value["071"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB).toggleClass("highlight rehighlight");	//	현재가
					} else {
						$("#srow_"+data.code).find("#trBidPri1").html(diffNumWatch(data.value["071"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB);	//	현재가
					}
				}
				if ($("#srow_"+data.code).find("#trBidVol1").html() != zeroUpDownNumList(data.value["061"])) {
					$("#srow_"+data.code).find("#trBidVol1").html(zeroUpDownNumList(data.value["061"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").toggleClass("highlight rehighlight");		//	체결수량
				} else {
					$("#srow_"+data.code).find("#trBidVol1").html(zeroUpDownNumList(data.value["061"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower");		//	체결수량
				}
			}
			if ($("#srow_"+data.code).find("#trBidPri2").html() != diffNumWatch(data.value["072"])) {
				$("#srow_"+data.code).find("#trBidPri2").html(diffNumWatch(data.value["072"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB1).toggleClass("highlight rehighlight");	//	현재가
			} else {
				$("#srow_"+data.code).find("#trBidPri2").html(diffNumWatch(data.value["072"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB1);	//	현재가
			}
			if ($("#srow_"+data.code).find("#trBidVol2").html() != zeroUpDownNumList(data.value["062"])) {
			$("#srow_"+data.code).find("#trBidVol2").html(zeroUpDownNumList(data.value["062"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB1).toggleClass("highlight rehighlight");		//	체결수량
			} else {
				$("#srow_"+data.code).find("#trBidVol2").html(zeroUpDownNumList(data.value["062"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB1);		//	체결수량
			}
			if ($("#srow_"+data.code).find("#trBidPri3").html() != diffNumWatch(data.value["073"])) {
				$("#srow_"+data.code).find("#trBidPri3").html(diffNumWatch(data.value["073"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB2).toggleClass("highlight rehighlight");	//	현재가
			} else {
				$("#srow_"+data.code).find("#trBidPri3").html(diffNumWatch(data.value["073"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB2);	//	현재가
			}
			if ($("#srow_"+data.code).find("#trBidVol3").html() != zeroUpDownNumList(data.value["063"])) {
			$("#srow_"+data.code).find("#trBidVol3").html(zeroUpDownNumList(data.value["063"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB2).toggleClass("highlight rehighlight");		//	체결수량
			} else {
				$("#srow_"+data.code).find("#trBidVol3").html(zeroUpDownNumList(data.value["063"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorB2);		//	체결수량
			}
			
			if (data.value["051"].substring(1) != 0) { 
			if ($("#srow_"+data.code).find("#trAskPri1").html() != diffNumWatch(data.value["051"])) {
			$("#srow_"+data.code).find("#trAskPri1").html(diffNumWatch(data.value["051"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS).toggleClass("highlight rehighlight");	//	대비
			} else {
				$("#srow_"+data.code).find("#trAskPri1").html(diffNumWatch(data.value["051"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS);	//	대비
			}
			if ($("#srow_"+data.code).find("#trAskVol1").html() != zeroUpDownNumList(data.value["041"])) {
			$("#srow_"+data.code).find("#trAskVol1").html(zeroUpDownNumList(data.value["041"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS).toggleClass("highlight rehighlight");		//	등락율
			} else {
				$("#srow_"+data.code).find("#trAskVol1").html(zeroUpDownNumList(data.value["041"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS);		//	등락율
			}
			} else {
				var date = new Date();
				var flagT = "";
				if (date.getHours() > 13) {
					flagT = "ATC";
				} else {
					flagT = "ATO";
				}
				if(data.value["052"].substring(1) != 0) {
				if ($("#srow_"+data.code).find("#trAskPri1").html() != diffNumWatch(data.value["051"])) {
					$("#srow_"+data.code).find("#trAskPri1").html(flagT).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower");
				}
				} else {
					if ($("#srow_"+data.code).find("#trAskPri1").html() != diffNumWatch(data.value["051"])) {
						$("#srow_"+data.code).find("#trAskPri1").html(diffNumWatch(data.value["051"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS).toggleClass("highlight rehighlight");	//	대비
						} else {
							$("#srow_"+data.code).find("#trAskPri1").html(diffNumWatch(data.value["051"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS);	//	대비
						}
				}
				if ($("#srow_"+data.code).find("#trAskVol1").html() != zeroUpDownNumList(data.value["041"])) {
					$("#srow_"+data.code).find("#trAskVol1").html(zeroUpDownNumList(data.value["041"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").toggleClass("highlight rehighlight");		//	등락율
				} else {
					$("#srow_"+data.code).find("#trAskVol1").html(zeroUpDownNumList(data.value["041"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower");		//	등락율
				}
			}
			if ($("#srow_"+data.code).find("#trAskPri2").html() != diffNumWatch(data.value["052"])) {
			$("#srow_"+data.code).find("#trAskPri2").html(diffNumWatch(data.value["052"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS1).toggleClass("highlight rehighlight");	//	대비
			} else {
				$("#srow_"+data.code).find("#trAskPri2").html(diffNumWatch(data.value["052"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS1);	//	대비
			}
			if ($("#srow_"+data.code).find("#trAskVol2").html() != zeroUpDownNumList(data.value["042"])) {
			$("#srow_"+data.code).find("#trAskVol2").html(zeroUpDownNumList(data.value["042"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS1).toggleClass("highlight rehighlight");		//	등락율
			} else {
				$("#srow_"+data.code).find("#trAskVol2").html(zeroUpDownNumList(data.value["042"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS1);		//	등락율
			}
			if ($("#srow_"+data.code).find("#trAskPri3").html() != diffNumWatch(data.value["053"])) {
			$("#srow_"+data.code).find("#trAskPri3").html(diffNumWatch(data.value["053"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS2).toggleClass("highlight rehighlight");	//	대비
			} else {
				$("#srow_"+data.code).find("#trAskPri3").html(diffNumWatch(data.value["053"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS2);	//	대비
			}
			if ($("#srow_"+data.code).find("#trAskVol3").html() != zeroUpDownNumList(data.value["043"])) {
			$("#srow_"+data.code).find("#trAskVol3").html(zeroUpDownNumList(data.value["043"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS2).toggleClass("highlight rehighlight");		//	등락율
			} else {
				$("#srow_"+data.code).find("#trAskVol3").html(zeroUpDownNumList(data.value["043"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorS2);		//	등락율
			}
		}
		
		/*
			000	RTS-Type
			034	체결시간
			023	현재가
			024	대비
			033	등락율
			032	체결수량
			027	거래량
			030	고가
			031	저가
		*/
		function timeFormat(str) {
			return str.substring(0, 2) + ":" + str.substring(2, 4) + ":" + str.substring(4, 6);
		}
		
		var finalTot	=	0;
		
		function bindTimely(data) {
			//console.log(data);
			var $setTr	=	$("#grdTimely");
			var htmlStr	=	"";
			var cssColor  = displayColor(data.value["024"].substring(0, 1));
			var cssArrow  = displayArrow(data.value["024"].substring(0, 1));
			
			htmlStr += "<tr>";
			htmlStr += "	<td class=\"text_center\">" + getTime(data.value["034"]) + "</td>"; 						// Time
			htmlStr += "	<td class='" + cssColor + "'>" + zeroUpDownNumList(data.value["023"].substring(1)) + "</td>"; 	// Current
			htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + data.value["024"].substring(1) + "</td>"; 		// +/-
			htmlStr += "	<td class='" + cssColor + "'>" + data.value["033"].substring(1) + "</td>"; 					// %Change
			var ch = data.value["032"].substring(0, 1);
			var vol;
			if (ch == "+" || ch == "-") {
				vol = data.value["032"];
			} else {
				vol = data.value["032"].substring(1);
			}
			
			
			var volColor	=	upDownColor(vol);
			htmlStr += "	<td class='" + volColor + "'>" + zeroUpDownNumList(vol) + "</td>"; // Volume
			htmlStr += "	<td class=''>" + zeroUpDownNumList(data.value["027"], "null") + "</td>";				// Total Volume.
			htmlStr += "</tr>";
			
			if(finalTot != data.value["027"]) {
				$setTr.prepend(htmlStr)
			}
			finalTot	=	data.value["027"];
		}
		
		var trCnt	=	20;
		
		function bindT() {
			var $setTr	=	$("#grdTimely");
			var htmlStr	=	"";
		
			htmlStr += "<tr>";
			htmlStr += "	<td class=\"text_center\">" + trCnt + "</td>"; 					// Time
			htmlStr += "	<td>" + trCnt + "</td>"; 									// Current
			htmlStr += "	<td>" + trCnt + "</td>"; 									// Current
			htmlStr += "	<td>" + trCnt + "</td>"; 									// Current
			htmlStr += "	<td>" + trCnt + "</td>"; 									// Current
			htmlStr += "	<td>" + trCnt + "</td>"; 									// Current
			htmlStr += "</tr>";
			
			trCnt++;
			$("#grdTimely").prepend(htmlStr)
		}
		
		function realData_A(data) {
			//console.log("REAL DATA A");
			//console.log(data);
			//	실시간 데이터 실행시
			realBindWatch(data);
			if ($("#dailySymb").val() == data.code) {
				bindCurr(data);
				bindTimely(data);
				bindDaily(data);
			}
			$('#watchlst').floatThead('reflow');
		}
		
		function realBindWatch(data) {
			
			//console.log("BIND WATCH CALL");
			//console.log(data);
			
			var cssColor  = displayColorWatch(data.value["024"].substring(0, 1));
			var cssColorO  = displayColorWatch(data.value["029"].substring(0, 1));
			var cssColorH  = displayColorWatch(data.value["030"].substring(0, 1));
			var cssColorL  = displayColorWatch(data.value["031"].substring(0, 1));
			if ($("#srow_"+data.code).find("#trPrice").html() != zeroUpDownNumList(data.value["023"].substring(1))) {
				$("#srow_"+data.code).find("#trPrice").html(zeroUpDownNumList(data.value["023"].substring(1))).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");	//	현재가
			} else {
				$("#srow_"+data.code).find("#trPrice").html(zeroUpDownNumList(data.value["023"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);	//	현재가
			}
			if ($("#srow_"+data.code).find("#trVol").html() != zeroUpDownNumList(data.value["032"].substring(1))) {
				$("#srow_"+data.code).find("#trVol").html(zeroUpDownNumList(data.value["032"].substring(1))).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");		//	체결수량
			} else {
				$("#srow_"+data.code).find("#trVol").html(zeroUpDownNumList(data.value["032"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);		//	체결수량
			}
			if ($("#srow_"+data.code).find("#trUpDown").html() != zeroUpDownNumList(data.value["024"].substring(1))) {
				$("#srow_"+data.code).find("#trUpDown").html(zeroUpDownNumList(data.value["024"].substring(1))).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");	//	대비
			} else {
				$("#srow_"+data.code).find("#trUpDown").html(zeroUpDownNumList(data.value["024"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);	//	대비
			}
			if ($("#srow_"+data.code).find("#trPer").html() != zeroUpDownNumList(data.value["033"].substring(1)) && zeroUpDownNumList(data.value["033"].substring(1)) != 100) {
				$("#srow_"+data.code).find("#trPer").html(zeroUpDownNumList(data.value["033"].substring(1))).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");		//	등락율
			} else {
				if (zeroUpDownNumList(data.value["033"].substring(1)) != 100) {
					$("#srow_"+data.code).find("#trPer").html(zeroUpDownNumList(data.value["033"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);		//	등락율
				}
			}
			if ($("#srow_"+data.code).find("#trTotalVol").html() != zeroUpDownNumList(data.value["027"])) {
				$("#srow_"+data.code).find("#trTotalVol").html(zeroUpDownNumList(data.value["027"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor).toggleClass("highlight rehighlight");				//	거래량
			} else {
				$("#srow_"+data.code).find("#trTotalVol").html(zeroUpDownNumList(data.value["027"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);				//	거래량
			}
			
			if ($("#srow_"+data.code).find("#trOpen").html() != diffNumWatch(data.value["029"])) {
				$("#srow_"+data.code).find("#trOpen").html(diffNumWatch(data.value["029"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorO).toggleClass("highlight rehighlight");						//	시가
			} else {
				$("#srow_"+data.code).find("#trOpen").html(diffNumWatch(data.value["029"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorO);						//	시가
			}
			if ($("#srow_"+data.code).find("#trHigh").html() != diffNumWatch(data.value["030"])) {
				$("#srow_"+data.code).find("#trHigh").html(diffNumWatch(data.value["030"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorH).toggleClass("highlight rehighlight");						//	고가
			} else {
				$("#srow_"+data.code).find("#trHigh").html(diffNumWatch(data.value["030"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorH);						//	고가
			}
			if ($("#srow_"+data.code).find("#trLow").html() != diffNumWatch(data.value["031"])) {
				$("#srow_"+data.code).find("#trLow").html(diffNumWatch(data.value["031"])).removeClass("highlight").removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorL).toggleClass("highlight rehighlight");						//	저가
			} else {
				$("#srow_"+data.code).find("#trLow").html(diffNumWatch(data.value["031"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColorL);						//	저가
			}
		}
		
		/*
		000	RTS-Type
		034	체결시간
		023	현재가
		024	대비
		033	등락율
		032	체결수량
		027	거래량
		030	고가
		031	저가
		
		$("#srow_BVH).find("#trPrice")
		*/
		function realData_wat_(data) {
			var cssColor  = displayColorWatch(data.value["024"].substring(0, 1));
			$("#srow_"+data.code).find("#trPrice").html(zeroUpDownNumList(data.value["023"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);	//	현재가
			$("#srow_"+data.code).find("#trVol").html(zeroUpDownNumList(data.value["032"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);		//	체결수량
			$("#srow_"+data.code).find("#trUpDown").html(zeroUpDownNumList(data.value["024"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);	//	대비
			$("#srow_"+data.code).find("#trPer").html(zeroUpDownNumList(data.value["033"].substring(1))).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);		//	등락율
			$("#srow_"+data.code).find("#trTotalVol").html(zeroUpDownNumList(data.value["027"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);				//	거래량
			$("#srow_"+data.code).find("#trHigh").html(diffNum(data.value["030"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);						//	고가
			$("#srow_"+data.code).find("#trLow").html(diffNum(data.value["031"])).removeClass("upper").removeClass("up1").removeClass("same1").removeClass("low1").removeClass("lower").addClass(cssColor);						//	저가
		}
		
		function my(symb, type) {
			var vals = [];
			vals.push(symb);
			if(type == "0") {
				var gubuns = ['A'];
				nexClient.rtsReg({
					pName	:	'BID',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
					GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
					VALUES	: 	vals		//	요청 key value (주식코드,지수 등등..)
				});
				gubuns = ['H'];
				nexClient.rtsReg({
					pName	:	'BIDTP',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
					GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
					VALUES	:	vals		//	요청 key value (주식코드,지수 등등..)
				});
				gubuns = ['C'];
				nexClient.rtsReg({
					pName	:	'FBIDTP',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
					GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
					VALUES	:	vals		//	요청 key value (주식코드,지수 등등..)
				});
				
				gubuns = ['Y'];
				nexClient.rtsReg({
					pName	:	'BID',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
					GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
					VALUES	:	vals		//	요청 key value (주식코드,지수 등등..)
				});
			}
			
			nexClient.pushCurrOn({
				pName	: 'BID',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )
				symb	:	symb ,
				lang	:	("<%= langCd %>" == "en_US" ? "1" : "0"),
				symbols	: 	vals		//요청 심볼 필드
			});
			
			
			nexClient.pushTprcOn({
				pName	:	'BIDTP',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )
				symb	:	symb,
				lang	:	'0',
				symbols	: 	vals		//요청 심볼 필드
			});
		}
		
		
		function regRtsStock(symb) {
			//console.log("regRtsStock regRtsStock regRtsStock CALL");
			var vals = [];
			vals.push(symb);
			var gubuns = ['A'];
			nexClient.rtsReg({
				pName	:	'BID',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
				GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
				VALUES	: 	vals		//	요청 key value (주식코드,지수 등등..)
			});
			gubuns = ['B'];
			nexClient.rtsReg({
				pName	:	'BIDTP',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
				GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
				VALUES	:	vals		//	요청 key value (주식코드,지수 등등..)
			});

			nexClient.pushCurrOn({
				pName	: 'BID',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )
				symb	:	symb ,
				lang	:	("<%= langCd %>" == "en_US" ? "1" : "0"),
				symbols	: 	vals		//요청 심볼 필드
			});
			nexClient.pushTprcOn({
				pName	:	'BIDTP',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )
				symb	:	symb,
				lang	:	'0',
				symbols	: 	vals		//요청 심볼 필드
			});
		}
		
		function myStock(symb) {
			var gubuns = ['A'];
			var vals = [];
			
			
			symb	=	String(symb).split(",");
			for(var i = 0; i < symb.length; i++) {
				//console.log("SYMB==>" + symb[i]);
				vals.push(symb[i]);
			}
			
			/*
			var symbols	=	[];
			symbols.push(symb);
			vals.push(symb);
			*/
			nexClient.rtsReg({
				pName	:	'BID',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
				GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
				VALUES	: 	vals		//	요청 key value (주식코드,지수 등등..)
			});

			nexClient.pushCurrOn({
				pName	: 'BID',		//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )
				symb	:	vals ,
				lang	:	("<%= langCd %>" == "en_US" ? "1" : "0"),
				symbols	: 	vals		//요청 심볼 필드
			});
			
			/*
			gubuns = ['B'];
			
			nexClient.rtsReg({
				pName	:	'BIDTP',		//	실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )						
				GUBUNS	:	gubuns,		//	심볼 카테고리 (정의된 연결 키  A, B Q ...)
				VALUES	:	vals		//	요청 key value (주식코드,지수 등등..)
			});
			
			nexClient.pushTprcOn({
				pName	:	'BIDTP',	//실시간데이터받을 타겟팅ID (미래에셋증권 WTS에서는 화면번호로 적용중 )
				symb	:	symb,
				lang	:	'0',
				symbols	: 	symb		//요청 심볼 필드
			});
			*/
		}
		
		
		
		function authCheck() {
			var param = {
					divId               : "divIdAuthMatrix",
					divType             : ""
			};

			$.ajax({
				type     : "POST",
				url      : "/common/popup/authConfirm.do",
				data     : param,
				dataType : "html",
				success  : function(data){
					$("#divIdAuthMatrix").fadeIn();
					$("#divIdAuthMatrix").html(data);
				},
				error     :function(e) {					
					console.log(e);
				}
			});
		}
		
		
		function authCheckOK(divGubun) {
			$("#divIdAuthMatrix").fadeOut();
		}
		
		function divBidShowHide() {
			if($("#divBidStock").css("display") == "none") {
				$("#divBidStock").show();
			} else {
				$("#divBidStock").hide();
			}
		}
		
		
		function authOtpCheck() {
			var param = {
					divId               : "divIdAuthOtp",
					divType             : ""
			};

			$.ajax({
				type     : "POST",
				url      : "/common/popup/otpConfirm.do",
				data     : param,
				dataType : "html",
				success  : function(data){
					$("#divIdAuthOtp").fadeIn();
					$("#divIdAuthOtp").html(data);
				},
				error     :function(e) {					
					console.log(e);
				}
			});
		}
		
		
		</script>
		<style>
		.wrap_left {float:inherit; margin-right:645px;}
		.left_content01.on {position:relative; z-index:99; margin-right:-53.9%; background-color:#fff;}
		.left_content01 .wts_expand {width:30px; height:20px; background:url(/resources/images/wts_expand_bid.png) no-repeat 0 0; overflow:hidden; text-indent:200%; white-space:nowrap; border:none; margin-left:10px;}
		.left_content01.on .wts_expand {background:url(/resources/images/wts_reduce_bid.png) no-repeat 0 0;}
		</style>
		<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
	</head>
	<body>
		<div class="mdi_container">
			<input type="hidden" id="tabsGrp" name="tabsGrp" value=""/>
			<input type="hidden" id="dailySymb" name="dailySymb" value=""/>
			<input type="hidden" id="dailySkey" name="dailySkey" value=""/>
			<input type="hidden" id="timelySkey" name="timelySkey" value=""/>
			<input type="hidden" id="chkDate" name="chkDate" value="${chkDate}"/>
			<div class="mdi_content">
				
				<!-- 3/16일 수정 -->
				<div class="wrap_left">
					<!-- tabs -->
					<div name="tabs" id="tabOrdGrp1" class="left_content01">
						<ul class="nav nav_tabs">
							<li><a href="/trading/view/watchlst.do"><%= (langCd.equals("en_US") ? "Watch List" : "D.M Quan Tâm") %></a></li>
							<li><a href="/trading/view/sector.do"><%= (langCd.equals("en_US") ? "Most Active" : "Top GD") %></a></li>
							<li><a href="/trading/view/ranking.do"><%= (langCd.equals("en_US") ? "Top Movers" : "Top Tăng/Giảm") %></a></li>
							<li><a href="/trading/view/highlow.do"><%= (langCd.equals("en_US") ? "Highest/Lowest" : "Cao/Thấp Nhất") %></a></li>
							<li><a href="/trading/view/foreignerbuysell.do"><%= (langCd.equals("en_US") ? "Foreigner Info" : "T.Tin NĐT NN") %></a></li>
							<li><a href="/trading/view/newlisted.do"><%= (langCd.equals("en_US") ? "New Listed Stock" : "Cổ phiếu mới") %></a></li>
							<li><a href="/trading/view/sectorlist.do"><%= (langCd.equals("en_US") ? "Sector List" : "D.S Ngành") %></a></li>
							<li><a href="/trading/view/recommendlist.do"><%= (langCd.equals("en_US") ? "Recommend List" : "D.M Khuyến Nghị") %></a></li>
						</ul>
					</div>
					<!-- tabs -->
					<div name="tabs" id="tabOrdGrp2">
						<ul class="nav nav_tabs">
							<li id="ordtab"><a href="/trading/view/orderjournal.do"><%= (langCd.equals("en_US") ? "Order Journal" : "Tra cứu lệnh giao dịch") %></a></li>
							<li id="baltab"><a href="/trading/view/balance.do"><%= (langCd.equals("en_US") ? "Balance" : "Số dư") %></a></li>
							<li id="chrtab"><a href="/trading/view/chart.do"><%= (langCd.equals("en_US") ? "Chart" : "Biểu đồ") %></a></li>
							<li id="daytab"><a href="/trading/view/daily.do"><%= (langCd.equals("en_US") ? "Daily" : "Theo ngày") %></a></li>
							<li id="timtab"><a href="/trading/view/timely.do"><%= (langCd.equals("en_US") ? "Timely" : "Theo thời gian") %></a></li>							
							<li id="prftab"><a href="/trading/view/profile.do"><%= (langCd.equals("en_US") ? "Profile" : "Hồ sơ DN") %></a></li>
							<li id="indtab"><a href="/trading/view/industry.do"><%= (langCd.equals("en_US") ? "Industry Peers" : "DN cùng ngành") %></a></li>
							<li id="fintab"><a href="/trading/view/financials.do"><%= (langCd.equals("en_US") ? "Financials" : "Tài chính") %></a></li>
							<li id="newstab"><a href="/trading/view/stocknews.do"><%= (langCd.equals("en_US") ? "Stock news" : "Tin tức") %></a></li>
							<li id="evttab"><a href="/trading/view/stockevents.do"><%= (langCd.equals("en_US") ? "Events" : "Sự kiện") %></a></li>
						</ul>
					</div>
				</div>
				<!-- //LEFT -->
				<!-- RIGHT -->
				<div class="wrap_right" style="position:absolute; top:0px; right:0px;">
					
					<div class="pull_right stock_search_wts" >
											
						<!-- 2018.03.22 Add search popup -->
						<div>
						<!--   
						<div style="float:left;" class="layer_search_btn">
							<button type="button" class="search_full_stock" style="background:url(/resources/images/bg_search.png) no-repeat 50%;"></button>						
							<div class="layer_search" style="right:100px;width:330px;">
								<h2><%= (langCd.equals("en_US") ? "STOCK SEARCH" : "MÃ TÌM KIẾM") %></h2>
								<div class="search_area">
									<label for="schNamePopS"><%= (langCd.equals("en_US") ? "Name" : "Tên") %></label>
									<div class="input_search" style="display:block;">
										<input style="float:left;width:92%;" type="text" id="schNamePopS" name="schNamePopS" onkeyup="searchStockS(event)">
										<button style="float:right;height:20px;" type="button" id="schStockPopS" name="schStockPopS"></button>
									</div>
								</div>
								<div>
									<div style="position:relative; padding:8px 0;">
										<div>
											<input style="width:12px;" type="radio" id="schMarketPopALLS" name="schMarketPopS" value="ALL" checked="checked"><label style="display:inline;padding-left:5px;" for="schMarketPopALLS">All</label>											
											<input style="width:12px;" type="radio" id="schMarketPopHOS" name="schMarketPopS" value="HOSE"><label style="display:inline;padding-left:5px;" for="schMarketPopHOS">HOSE</label>
											<input style="width:12px;" type="radio" id="schMarketPopHAS" name="schMarketPopS" value="HNX"><label style="display:inline;padding-left:5px;" for="schMarketPopHAS">HNX</label>
											<input style="width:12px;" type="radio" id="schMarketPopOTCS" name="schMarketPopS" value="UPCOM"><label style="display:inline;padding-left:5px;" for="schMarketPopOTCS">UPCOM</label>
											<input style="width:12px;" type="radio" id="schMarketPopCWS" name="schMarketPopS" value="HOSE"><label style="display:inline;padding-left:5px;" for="schMarketPopCWS">CW</label>						
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
													<tbody id="grdStockPopS">
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
						-->
						<!-- 2018.03.22 Add search popup End -->
						
						<!-- 2017.04.11 추가 김정순 -->
						  
							 <div style="float:left;display:none;" id="" class="input_dropdown" >
								<span>
									<input type="text" id="bidStock" name="bidStock" onkeyup="getStock(event)"/>
									<button type="button" onclick="divBidShowHide()"></button>
								</span>
								<div id="divBidStock" class="divBidStockNew" style="z-index:999">
									<ul id="ulBidStock">
									</ul>
								</div>
							</div>
						
						
						<!-- //2017.04.11 추가 김정순 -->
						</div>
						
						
					</div>
					<!-- //2017.04.05 김정순 -->
					
					
					
					<!-- tabs -->
					<div name="tabs" id="tabOrdGrp3" style="/* margin-top:5px; */">
						<ul class="nav nav_tabs1" role="tablist">
							<%-- 2017.04.05 수정 김정순
							<li><a href="/trading/view/bid.do"><%= (langCd.equals("en_US") ? "Stock Price" : "Dữ liệu chứng khoán") %></a></li> --%>
							<li style="display:none;"><a href="/trading/view/bid.do" style="font-size:11px; height:30px;"><%= (langCd.equals("en_US") ? "Bidding" : "Dữ liệu chứng khoán") %></a></li>
							<!-- 2017.04.05 삭제 김정순 -->
							<%-- <li><a href="/trading/view/info.do"><%= (langCd.equals("en_US") ? "Company Info" : "Thông tin công ty") %></a></li> --%>
						</ul>
					</div>
					<!-- tabs -->
					<div name="tabs" id="tabOrdGrp4" class="eo" style="margin-top:0px">
						<ul class="nav nav_tabs tit" role="tablist" style="margin-bottom:4px; border-radius:0;">
							<li id="buytab" name="buytab" class="on"><a href="/trading/view/enterorder.do"><%= (langCd.equals("en_US") ? "BUY" : "MUA") %></a></li>
							<li id="selltab" name="selltab" class="redBorder"><a href="/trading/view/entersell.do"><%= (langCd.equals("en_US") ? "SELL" : "BÁN") %></a></li>
						</ul>
					</div>
				</div>
				<!-- //RIGHT -->
				

				
			</div>
		</div>
		<div id="divIdAuthMatrix" class="modal_wrap"></div>
		<div id="divIdAuthOtp" class="modal_wrap"></div>
	</body>
</html>
