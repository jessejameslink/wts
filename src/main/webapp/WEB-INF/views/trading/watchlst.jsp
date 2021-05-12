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
	String langCd 	= 	(String) session.getAttribute("LanguageCookie");
	String loginId	=	(String) session.getAttribute("ClientV");
%>

<HTML>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Content-Style-Type" content="text/css"/>
		<meta http-equiv="Cache-Control" content="no-cache" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="-1" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
		
		<script>
			//var rcodObj	=	'';
			var stockcodeArray = [];
			$(document).ready(function() {
				/*3.16 수정*/		
				$('.wrap_left button.wts_expand').on('click',function(){
					var existOn=$(this).parents('.left_content01').hasClass('on');
					var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
					if(existOn){						
						//hide 3 price
						hide3Price();
						
						$(this).parents('.left_content01').removeClass('on');	
						$(this).text('+ EXPAND');
						/*if(tabId == "buytab") {
							$("#tab41").find("#bid_rcod").show();
							$("#tab41").find("#ent_sch_stock").hide();
						} else {
							$("#tab49").find("#bid_rcod").show();
							$("#tab49").find("#ent_sch_stock").hide();
						}*/
						//$("#grdWat").css("height", "251px");
					}else{
						//show 3 price
						show3Price();
						
						$(this).parents('.left_content01').addClass('on');
						$(this).text('- Reduce');
						/*if(tabId == "buytab") {
							$("#tab41").find("#bid_rcod").hide();
							$("#tab41").find("#ent_sch_stock").show();
						} else {
							$("#tab49").find("#bid_rcod").hide();
							$("#tab49").find("#ent_sch_stock").show();
						}*/
						//$("#grdWat").css("height", "670px");
						//$("#grdWat").css("background", "white");
					}
					$('#watchlst').floatThead('reflow');
				});
				/*3.16 수정*/
				if(!nexClient.socketConnection) {
					nexClient.webSocketDisconnect();
					nexClient.webSocketConnect(window.RTS_IP);
				}
				nexClient.pushViewOff('BID','BID');
				nexClient.pushViewOff('BIDTP','BIDTP');
				$("#divAddStockPop").hide();
				grpCombo();
				$('.layer_sub_btn .layer_sub').hide();
				$('.layer_sub_btn button').click(function(e){
					var self = $(this);
					if(self.closest('.btn_wrap').length){ // sub layer button
						self.closest('.layer_sub').hide();
						$('.layer_sub_btn button').removeClass('on');
					} else { // layer toggle button
						self.toggleClass('on');
						$('.layer_sub_btn button').not(this).removeClass('on');
						$('.layer_sub_btn .layer_sub').not($(this).next()).hide();
						self.next().toggle();
					}
				});				
			});
			
			var watErrFlag	=	0;
			function grpCombo() {
				$("#grdWat").block({message: "<span>LOADING...</span>"});
				var param = {
					  usid  : $("#watUsid").val()
					, func  : "Q"
				};

				$.ajax({
					url      : "/trading/data/getGrpList.do",
					data     : param,
					async	: true, 
					dataType : 'json',
					success  : function(data){
						$("#grdWat").unblock();
						$("#watchGrp").find("option").remove();
						if(data.grpList != null) {
							if(data.grpList.list1 != null) {
								for(var i=0; i < data.grpList.list1.length; i++) {
									var grpCode = data.grpList.list1[i];
									$("#watchGrp").append("<option value='" + grpCode.grpn + "'>" + grpCode.dscr + "</option>");
								}
							}
							$("#grdWat").unblock();
							if($("#grpId").val() != "") {
								$("#watchGrp").val($("#grpId").val());
								$("#grpId").val("");
							}
							getWatchList();
						}
					},
					error     :function(e) {
						$("#grdWat").unblock();
						console.log(e);
						//not connect bp server retry 2
						if(e.status == "404") {
							if(watErrFlag > 2) {
								alert("Please re-search.....");
								return;
							} else {
								grpCombo();
								watErrFlag++;
							}
						}
					}
				});
			}
			
			function hide3Price() {
				//Set colspan
				$('#thBuyHeader').attr('colspan',2);
				$('#thSellHeader').attr('colspan',2);
				$('#thForeignHeader').attr('colspan',2);
				//th
				$("#thBuyPrice3").addClass('hide');
				$("#thBuyVol3").addClass('hide');
				$("#thBuyPrice2").addClass('hide');
				$("#thBuyVol2").addClass('hide');
				$("#thSellPrice3").addClass('hide');
				$("#thSellVol3").addClass('hide');
				$("#thSellPrice2").addClass('hide');
				$("#thSellVol2").addClass('hide');
				$("#thRoom").addClass('hide');
				//td
				$('#watchlst  td#trBidPri3').addClass('hide');
				$('#watchlst  td#trBidVol3').addClass('hide');
				$('#watchlst  td#trBidPri2').addClass('hide');
				$('#watchlst  td#trBidVol2').addClass('hide');
				$('#watchlst  td#trAskPri3').addClass('hide');
				$('#watchlst  td#trAskVol3').addClass('hide');
				$('#watchlst  td#trAskPri2').addClass('hide');
				$('#watchlst  td#trAskVol2').addClass('hide');
				$('#watchlst  td#trRoom').addClass('hide');
			}
			
			function show3Price() {
				//Set colspan
				$('#thBuyHeader').attr('colspan',6);
				$('#thSellHeader').attr('colspan',6);
				$('#thForeignHeader').attr('colspan',3);
				//th
				$("#thBuyPrice3").removeClass('hide');
				$("#thBuyVol3").removeClass('hide');
				$("#thBuyPrice2").removeClass('hide');
				$("#thBuyVol2").removeClass('hide');
				$("#thSellPrice3").removeClass('hide');
				$("#thSellVol3").removeClass('hide');
				$("#thSellPrice2").removeClass('hide');
				$("#thSellVol2").removeClass('hide');
				$("#thRoom").removeClass('hide');
				//td
				$('#watchlst  td#trBidPri3').removeClass('hide');
				$('#watchlst  td#trBidVol3').removeClass('hide');
				$('#watchlst  td#trBidPri2').removeClass('hide');
				$('#watchlst  td#trBidVol2').removeClass('hide');
				$('#watchlst  td#trAskPri3').removeClass('hide');
				$('#watchlst  td#trAskVol3').removeClass('hide');
				$('#watchlst  td#trAskPri2').removeClass('hide');
				$('#watchlst  td#trAskVol2').removeClass('hide');
				$('#watchlst  td#trRoom').removeClass('hide');
			}

			////var today = new Date();
			
			function getWatchList() {
				//$('#watchlst').floatThead('destroy');
				$("#grdWat").block({message: "<span>LOADING...</span>"});
				nexClient.pushViewOff('BID','BID');
				nexClient.pushViewOff('BIDTP','BIDTP');
				
				var date1 = new Date();
				var date2 = new Date();
				date2.setHours(10);
				var flagT = "";
				if (date1.getTime() < date2.getTime()) {
					flagT = "ATO";
				} else {
					flagT = "ATC";
				}
				
				var param = {
					  usid  : $("#watUsid").val()
					, grpn  : $("#watchGrp").val()
					, lang  : ("<%= langCd %>" == "en_US" ? "1" : "0")
				};

				$.ajax({
					url      : "/trading/data/getWatchList.do",
					data     : param,
					dataType : 'json',
					success  : function(data){
						//console.log("///////////////////////////getWatchList///////////////////////");
						//console.log(data);
						$("#grdWat").unblock();
						if(data.watchList != null) {
							if(data.watchList.list1 != null) {
								var watchStr = "";
								var symbols	=	[];
								//rcodObj	=	data;														//	time out call
								/*var sortList = data.watchList.list1.slice(0);
								sortList.sort(function(a,b) {
								    var x = a.rcod.toLowerCase();
								    var y = b.rcod.toLowerCase();
								    return x < y ? -1 : x > y ? 1 : 0;
								});*/
								stockcodeArray.length = 0;
								var sortList = data.watchList.list1;
								for(var i=0; i < sortList.length; i++) {
									var watchList = sortList[i];
									var cssColor  = displayColorWatch(watchList.diff.substring(0, 1));
									var cssColorB  = displayColorWatch(watchList.buye.substring(0, 1));
									var cssColorB2  = displayColorWatch(watchList.buye2.substring(0, 1));
									var cssColorB3  = displayColorWatch(watchList.buye3.substring(0, 1));
									var cssColorS  = displayColorWatch(watchList.sell.substring(0, 1));
									var cssColorS2  = displayColorWatch(watchList.sell2.substring(0, 1));
									var cssColorS3  = displayColorWatch(watchList.sell3.substring(0, 1));
									//watchStr += "<tr id=\"srow_"+watchList.rcod+"\" onclick=\"selItem('" + watchList.rcod + "');\">";
									watchStr += "<tr id=\"srow_"+watchList.rcod+"\">";
									//watchStr += "	<td onclick=\"selItem('" + watchList.rcod + "');\" style=\"cursor: pointer;\" class=\"text_left c_code\" id='trStock'>" + watchList.rcod + "<span onclick=\"openTechChart('" + watchList.rcod + "');\" class=\"btn_chart\"></span></td>";                       			// Stock
									watchStr += "	<td style=\"text-align:center !important;\"><button class=\"btn_del\" type=\"button\" onclick=\"removeStockCode('" + watchList.rcod + "');\"></button></td>";
									watchStr += " <td>";
									watchStr += " <div style=\"display: flex;\">";
									watchStr += " <div onclick=\"selItem('" + watchList.rcod + "');\" style=\"cursor: pointer;\" class=\"text_left c_code\" id='trStock'>" + watchList.rcod;
									watchStr += " </div>";
									watchStr += " <div onclick=\"openTechChart('" + watchList.rcod + "');\" class=\"btn_chart\" style=\"cursor: pointer;\">";
									watchStr += " </div>";
									watchStr += " </div>";
									watchStr += " </td>";
									watchStr += "	<td style=\"cursor: pointer;\" class=\"text_left c_code dotted\" id='trMarket'>" + convMarket(watchList.mark) + "</td>";            // Market
									watchStr += "	<td style=\"text-align: center !important; width:10px;\"><a onclick=\"openBuyTab('" + watchList.rcod + "');\" class=\"btn_watch_list buy\" style=\"cursor: pointer;\">" + "<%= (langCd.equals("en_US") ? "Buy" : "Mua") %>" + "</a></td>";									
									watchStr += "	<td style=\"text-align: center !important; width:10px;\"><a onclick=\"openSellTab('" + watchList.rcod + "');\" class=\"btn_watch_list sell\" style=\"cursor: pointer;\">" + "<%= (langCd.equals("en_US") ? "Sell" : "Bán") %>" + "</a></td>";									
									watchStr += "	<td style=\"cursor: pointer;\" class=\"upper\">" + zeroUpDownNumList(watchList.ceil) + "</td>";                    						// CE
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted lower\" id='trFL'>" + zeroUpDownNumList(watchList.floo) + "</td>";          				// FL
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted same1\" id='trRef'>" + zeroUpDownNumList(watchList.pcpr) + "</td>";             			// Ref
									
									//buy price 1,2,3
									watchStr += "	<td style=\"cursor: pointer;\" id='trBidPri3' class=\"hide " + cssColorB3 + "\">" + zeroUpDownNumList(watchList.buye3.substring(1)) + "</td>";               	// Pri.1
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted hide "+cssColorB3+"\" id='trBidVol3'>" + zeroUpDownNumList(watchList.bvol3) + "</td>";         	// Vol.1
									watchStr += "	<td style=\"cursor: pointer;\" id='trBidPri2' class=\"hide " + cssColorB2 + "\">" + zeroUpDownNumList(watchList.buye2.substring(1)) + "</td>";               	// Pri.1
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted hide "+cssColorB2+"\" id='trBidVol2'>" + zeroUpDownNumList(watchList.bvol2) + "</td>";         	// Vol.1
									
									var trBPri1 = zeroUpDownNumList(watchList.buye.substring(1));
									var trBVol1 = zeroUpDownNumList(watchList.bvol);
									var trSPri1 = zeroUpDownNumList(watchList.sell.substring(1));
									var trSVol1 = zeroUpDownNumList(watchList.svol);
									if (trBPri1 == '' && trBVol1 != '') {
										watchStr += "	<td style=\"cursor: pointer;\" id='trBidPri1' class=' " + cssColorB + "'>" + flagT + "</td>";               	// Pri.1
										watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted right "+cssColorB+"\" id='trBidVol1'>" + trBVol1 + "</td>";         	// Vol.1
									} else {
										watchStr += "	<td style=\"cursor: pointer;\" id='trBidPri1' class=' " + cssColorB + "'>" + trBPri1 + "</td>";               	// Pri.1
										watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted right "+cssColorB+"\" id='trBidVol1'>" + trBVol1 + "</td>";         	// Vol.1
									}
									
									//Matching price
									if ((trBPri1 == '' && trBVol1 != '') || (trSPri1 == '' && trSVol1 != '')) {
										if (watchList.eprc.substring(1) == '' || watchList.eprc.substring(1) == 0 || watchList.eprc == 0) {
											watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"matching " + cssColor + "\" id='trPrice'>" + zeroUpDownNumList(watchList.mpic.substring(1)) + "</td>";   // Price
											watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor +"\" id='trVol'>" + zeroUpDownNumList(watchList.mvol) + "</td>";             // Vol
											watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor + "\" id='trUpDown'>" + zeroUpDownNumList(watchList.mdif.substring(1)) + "</td>";       // +/-
											watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor + "\" id='trPer'>" + zeroUpDownNumList(watchList.rate.substring(1)) + "</td>";          // %
											watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching right " + cssColor + "\" id='trTotalVol'>" + zeroUpDownNumList(watchList.avol) + "</td>";        // Total Vol.
										} else {
										var cssColorE = displayColorWatch(watchList.eprc.substring(0, 1));
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"matching " + cssColorE + "\" id='trPrice'>" + zeroUpDownNumList(watchList.eprc.substring(1)) + "</td>";   // Price
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColorE +"\" id='trVol'>" + zeroUpDownNumList(watchList.evol) + "</td>";             // Vol
										var updown = Math.abs(parseInt(numDotComma(watchList.eprc.substring(1))) - parseInt(numDotComma(watchList.pcpr)));
										if (updown != 0) {
											watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColorE + "\" id='trUpDown'>" + numIntFormat(updown) + "</td>";       // +/-
										} else {
											watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColorE + "\" id='trUpDown'>" + "" + "</td>";       // +/-
										}
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColorE + "\" id='trPer'>" + "" + "</td>";          // %
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching right " + cssColorE + "\" id='trTotalVol'>" + zeroUpDownNumList(watchList.avol) + "</td>";        // Total Vol.
										}
									} else {
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"matching " + cssColor + "\" id='trPrice'>" + zeroUpDownNumList(watchList.mpic.substring(1)) + "</td>";   // Price
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor +"\" id='trVol'>" + zeroUpDownNumList(watchList.mvol) + "</td>";             // Vol
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor + "\" id='trUpDown'>" + zeroUpDownNumList(watchList.mdif.substring(1)) + "</td>";       // +/-
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor + "\" id='trPer'>" + zeroUpDownNumList(watchList.rate.substring(1)) + "</td>";          // %
										watchStr += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching right " + cssColor + "\" id='trTotalVol'>" + zeroUpDownNumList(watchList.avol) + "</td>";        // Total Vol.
									}									
									
									//sell price 1,2,3
									if (trSPri1 == '' && trSVol1 != '') {
										watchStr += "	<td style=\"cursor: pointer;\" id='trAskPri1' class=' " + cssColorS + "'>" + flagT + "</td>";               // Pri.1
										watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted  " + cssColorS + "\" id='trAskVol1'>" + trSVol1 + "</td>";         // Vol.1
									} else {									
										watchStr += "	<td style=\"cursor: pointer;\" id='trAskPri1' class=' " + cssColorS + "'>" + trSPri1 + "</td>";               // Pri.1
										watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted  " + cssColorS + "\" id='trAskVol1'>" + trSVol1 + "</td>";         // Vol.1
									}
									watchStr += "	<td style=\"cursor: pointer;\" id='trAskPri2' class=\"hide " + cssColorS2 + "\">" + zeroUpDownNumList(watchList.sell2.substring(1)) + "</td>";               // Pri.1
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted hide " + cssColorS2 + "\" id='trAskVol2'>" + zeroUpDownNumList(watchList.svol2) + "</td>";         // Vol.1
									watchStr += "	<td style=\"cursor: pointer;\" id='trAskPri3' class=\"hide " + cssColorS3 + "\">" + zeroUpDownNumList(watchList.sell3.substring(1)) + "</td>";               // Pri.1
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted hide " + cssColorS3 + "\" id='trAskVol3'>" + zeroUpDownNumList(watchList.svol3) + "</td>";         // Vol.1
									
									watchStr += "	<td style=\"cursor: pointer;\" id='trOpen' class='" + displayColorWatch(watchList.open.substring(0, 1)) + "'>" + diffNumWatch(watchList.open) + "</td>";                  // Open
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted " + displayColorWatch(watchList.high.substring(0, 1)) + "\" id='trHigh'>" + diffNumWatch(watchList.high) + "</td>";         // High
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted " + displayColorWatch(watchList.lowe.substring(0, 1)) + "\" id='trLow'>" + diffNumWatch(watchList.lowe) + "</td>";          // Low
									watchStr += "	<td style=\"cursor: pointer;\" id='trFBuy' class=''>" + zeroUpDownNumList(watchList.buyf) + "</td>";                  // F.Buy
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted\" id='trFSell'>" + zeroUpDownNumList(watchList.self) + "</td>";        // F.Sell
									watchStr += "	<td style=\"cursor: pointer;\" class=\"dotted hide\" id='trRoom'>" + zeroUpDownNumList(watchList.trom) + "</td>";         // Room
									watchStr += "</tr>";
									my(watchList.rcod, i);
									stockcodeArray.push(watchList.rcod);
									//TempmyStock();
								}
								
								$("#trWatchList").html(watchStr);
								if(sortList.length != 0) {
									selItem(sortList[0].rcod);
								}
								
								var timer1 = setTimeout(function (){
									//console.log("소켓 확인======================>");
									//console.log(nexClient.socketConnection);
									if(!nexClient.socketConnection) {
										nexClient.webSocketDisconnect();
										nexClient.webSocketConnect(window.RTS_IP);
									
										var timer2 = setTimeout(function (){
											for(var i=0; i < sortList.length; i++) {
												var watchList = sortList[i];
												my(watchList.rcod, i);
												//TempmyStock();
											}
										}, 1000);
									} else {
										for(var i=0; i < sortList.length; i++) {
											var watchList = sortList[i];
											my(watchList.rcod, i);
											//TempmyStock();
										}
									}
									
									
								}, 1000);
							}
							//실시간 시세 호출
							//@TODO : TMEP PROC
							//myStock();
							
							
							$('#watchlst').floatThead({
							    //position: 'absolute',
							    position: 'absolute',
							    zIndex: function($table){
							        return 0;
							    },
							    scrollContainer: true
							    , autoReflow:true
							});
							
							
							
							$('#watchlst').floatThead('reflow');
						}
					},
					error     :function(e) {
						console.log(e);
						$("#grdWat").unblock();
						//$('#watchlst').floatThead('reflow');
						$('#watchlst').floatThead('destroy');
						$('#watchlst').floatThead({
						    position: 'absolute',
						    zIndex: function($table){
						        return 0;
						    },
						    scrollContainer: true
						    , autoReflow:true
						});
					}
				});
				
				var existOn=$('.left_content01').hasClass('on');
				if (existOn) {
				$('.left_content01').removeClass('on');
				$('.wrap_left button.wts_expand').text('+ EXPAND');
				var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
				/*if(tabId == "buytab") {
					$("#tab41").find("#bid_rcod").show();
					$("#tab41").find("#ent_sch_stock").hide();
				} else {
					$("#tab49").find("#bid_rcod").show();
					$("#tab49").find("#ent_sch_stock").hide();
				}*/
				}
				hide3Price();
			}
			
			function openTechChart(rcod) {
				var vW;
			    switch ("<%= session.getAttribute("LanguageCookie") %>") {
			        case "vi_VN":
			            vW = window.open('http://data.masvn.com/vi/ta/' + rcod, '_blank');
			            break;
			        case "en_US":
			            vW = window.open('http://data.masvn.com/en/ta/' + rcod, '_blank');
			            break;
			        default:
			            vW = window.open('http://data.masvn.com/vi/ta/' + rcod, '_blank');
			            break;
			    }
			    vW.focus();
			    return false;
			}
			
			/* Quick add stock to watch list : START */
			function removeStockCode (rcod) {
				var strTemp = "";
				for (var j = 0; j < stockcodeArray.length; j++) {
					if(stockcodeArray[j] != rcod) {
						strTemp += rpadStr(stockcodeArray[j], 12, " ");
					}
				}
				var param = {
						  usid  :  $("#watUsid").val()
						, func  :  "U"
						, grpn  :  $("#watchGrp").val()
						, dscr  :  $("#watchGrp option:selected").text()
						, nrec  :  stockcodeArray.length - 1
						, code  :  strTemp
				};

				$.ajax({
					url      : "/trading/data/getGrpList.do",
					data     : param,
					async	: true, 
					dataType : 'json',
					success  : function(data){
						$("#grdWat").unblock();
						getWatchList($("#watchGrp").val());
					},
					error     :function(e) {
						console.log(e);
					}
				});
			}
			
			function quickAddStockEvents(evt) {
				$("#stkCode").val(xoa_dau($("#stkCode").val().toUpperCase()));
				if ($("#stkCode").val().trim() != "") {
					$('#quickAddStock').prop('disabled', false);
					if(evt.keyCode == 13) {	
						
						//delay enter key
						clearTimeout(keyup_timeout); // Clear the previous timeout so that it won't be executed any more. It will be overwritten by a new one below.
				        keyup_timeout = setTimeout(function() {
				            // Perform your magic here.
				        }, timeout_delay_in_ms);
						
						
						checkValidStockCode();
					}
				} else {
					$('#quickAddStock').prop('disabled', true);
				}				
			}
			
			function checkValidStockCode() {
				var param	=	{
						stockCd	:	$("#stkCode").val()
						, marketId	:	"ALL"
				};
				
				$.ajax({
					url      : "/trading/data/getMarketStockList.do",
					data     : param,
					dataType : 'json',
					success  : function(data){
						if(data.stockList.length != null) {
							if (data.stockList.length > 0) {
								if (checkExistedStock()) {
									if ("<%= langCd %>" == "en_US") {
										alert($("#stkCode").val() + " is existed in watch list.");	
									} else {
										alert($("#stkCode").val() + " đã tồn tại trong danh mục.");
									}
									$("#stkCode").val("");
									$("#stkCode").focus();
									$('#quickAddStock').prop('disabled', true);
								} else {
									quickAddStock();	
								}								
							} else {
								if ("<%= langCd %>" == "en_US") {
									alert($("#stkCode").val() + " is not exist,please enter again!");	
								} else {
									alert($("#stkCode").val() + " không tồn tại, vui lòng nhập lại!");
								}
								$("#stkCode").val("");
								$("#stkCode").focus();
								$('#quickAddStock').prop('disabled', true);
							}
						}
					},
					error     :function(e) {
						console.log(e);
					}
				});
			}
			
			function checkExistedStock() {
				for (var i = 0; i < stockcodeArray.length; i++) {
					if (stockcodeArray[i] == $("#stkCode").val().trim()) {						
						return true;						
					}
				}
				return false;
			}
			
			function quickAddStock() {
				var strTemp = "";
				strTemp += rpadStr($("#stkCode").val(), 12, " ");
				for (var j = 0; j < stockcodeArray.length; j++) {
					strTemp += rpadStr(stockcodeArray[j], 12, " ");
				}
				var param = {
						  usid  :  $("#watUsid").val()
						, func  :  "U"
						, grpn  :  $("#watchGrp").val()
						, dscr  :  $("#watchGrp option:selected").text()
						, nrec  :  stockcodeArray.length + 1
						, code  :  strTemp
				};

				$.ajax({
					url      : "/trading/data/getGrpList.do",
					data     : param,
					async	: true, 
					dataType : 'json',
					success  : function(data){							
						getWatchList($("#watchGrp").val());
						$("#stkCode").val("");
						$('#quickAddStock').prop('disabled', true);
					},
					error     :function(e) {
						console.log(e);
					}
				});
			}
			/* Quick add stock to watch list : END */
			
			function getEstimateData(str, rcod) {
				var param = {
						  symb  : rcod
						, lang  : ("<%= langCd %>" == "en_US" ? "1" : "0")
					};

					$.ajax({
						url      : "/trading/data/getEstimatePrice.do",
						contentType	:	"application/json; charset=utf-8",
						data     : param,
						dataType : "json",
						success  : function(data) {
							//console.log("Data current price for estimate");
							//console.log(data);
							var est = data.curr;
							var cssColor  = displayColorWatch(est.eprc.substring(0, 1));
							str += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"matching " + cssColor + "\" id='trPrice'>" + zeroUpDownNumList(est.eprc.substring(1)) + "</td>";   // Price
							str += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor +"\" id='trVol'>" + zeroUpDownNumList(est.evol) + "</td>";             // Vol
							str += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor + "\" id='trUpDown'>" + "" + "</td>";       // +/-
							str += "	<td style=\"cursor: pointer;background-color:#484848\" class=\"dotted matching " + cssColor + "\" id='trPer'>" + "" + "</td>";          // %							
						}
					});
					return str;
			}
			
			function addGroup() {
				$("#grpId").val($("#watchGrp").val());
				$.ajax({
					type     : "POST",
					url      : "/trading/popup/watchListGroup.do",
					data     : $("#frmAddGroup").serialize(),
					dataType : "html",
					success  : function(data){
						$("#divAddStockPop").fadeIn();
						$("#divAddStockPop").html(data);
					},
					error     :function(e) {
						console.log(e);
					}
				});
			}
			
			function openBuyTab(rcod) {				
				$('#buytab a[href="/trading/view/enterorder.do"]').trigger('click');
				$("#tab31").find("span[name='bid_rcod']").html(rcod);
				trdSelItem(rcod, "");
			}

			function openSellTab(rcod) {								
				$('#selltab a[href="/trading/view/entersell.do"]').trigger('click');
				$("#tab31").find("span[name='bid_rcod']").html(rcod);
				trdSelItem(rcod, "");
			}
			
			function convMarket(mark) {
				switch(mark){
					case "HOSE":
						mark	=	"HO";
						break;
					case "HNX":
						mark	=	"HA";
						break;
					case "UPCOM":
						mark	=	"OTC";
				}
				return mark;
			}
			
		</script>
	</head>
	
<style>
/* 2017.05.29 추가 김정순*/
td.hide{
display: none
}
th.hide{
display: none
}
</style>

	<body class="mdi" >
		<form id="frmAddGroup">
			<input type="hidden" id="watUsid" 	name="watUsid" 	value="<%= session.getAttribute("ClientV") %>">
			<input type="hidden" id="divId" 	name="divId" 	value="divAddStockPop">
			<input type="hidden" id="grpId" 	name="grpId" 	value="">
		</form>
		<div class="tab_content">
			<div role="tabpanel" class="tab_pane" id="tab1">
				<div style="float: right;padding-bottom: 5px;">
					<label><%= (langCd.equals("en_US") ? "Add to Watch list " : "Thêm vào danh mục") %></label>
					<input style="width:100px;" type="text" name="stkCode" id="stkCode" onkeyup="quickAddStockEvents(event)"></input>
					<button disabled="disabled" class="btn" type="button" id="quickAddStock" name="quickAddStock" onclick="checkValidStockCode()"><%= (langCd.equals("en_US") ? "Add" : "Thêm") %></button>
					<select id="watchGrp" name="watchGrp" onchange="getWatchList('')">
					</select>
					<button class="btn" type="button" id="addGroup" name="addGroup" onclick="addGroup()"><%= (langCd.equals("en_US") ? "Group Mng." : "Q.Lý Nhóm") %></button>
					<button class="wts_expand" type="button">+ EXPAND</button>
				</div>
				<div id="grdWat" class="grid_area" style="height:224px;">
					<div class="group_table dark new_wtsTable">
						<table class="table" id="watchlst">
							<thead>
								<tr>
									<th rowspan="2" class="bd_bt2"></th>
									<th class="bd_bt2" colspan="2"><%= (langCd.equals("en_US") ? "Name" : "Tên CK") %></th>
									<th rowspan="2" class="bd_bt2" colspan="2"><%= (langCd.equals("en_US") ? "Order" : "Đặt lệnh") %></th>
									<th class="bd_bt2" colspan="3"><%= (langCd.equals("en_US") ? "Reference" : "Tham chiếu") %></th>
									<th id="thBuyHeader" class="bd_bt2"><%= (langCd.equals("en_US") ? "Best Bid" : "Dư mua") %></th>
									<th class="bd_bt2" colspan="5"><%= (langCd.equals("en_US") ? "Matching" : "Khớp lệnh") %></th>
									<th id="thSellHeader" class="bd_bt2"><%= (langCd.equals("en_US") ? "Best Ask" : "Dư bán") %></th>
									<th class="bd_bt2" colspan="3"><%= (langCd.equals("en_US") ? "Price history" : "Lịch sử giá") %></th>
									<th id="thForeignHeader" class="bd_bt2" colspan="3"><%= (langCd.equals("en_US") ? "Foreign Investment" : "Giao dịch NN") %></th>
								</tr>
								<tr>
									<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
									<!--  <th><%= (langCd.equals("en_US") ? "Buy" : "Mua") %></th>
									<th><%= (langCd.equals("en_US") ? "Sell" : "Bán") %></th>-->
									<th><%= (langCd.equals("en_US") ? "Mk" : "Sàn") %></th>
									<th><%= (langCd.equals("en_US") ? "CE" : "Trần") %></th>
									<th><%= (langCd.equals("en_US") ? "FL" : "Sàn") %></th>
									<th><%= (langCd.equals("en_US") ? "Ref" : "TC") %></th>
									
									<th id="thBuyPrice3" class="hide"><%= (langCd.equals("en_US") ? "Pri.3" : "Giá 3") %></th>
									<th id="thBuyVol3" class="hide"><%= (langCd.equals("en_US") ? "Vol.3" : "KL 3") %></th>
									<th id="thBuyPrice2" class="hide"><%= (langCd.equals("en_US") ? "Pri.2" : "Giá 2") %></th>
									<th id="thBuyVol2" class="hide"><%= (langCd.equals("en_US") ? "Vol.2" : "KL 2") %></th>
									
									<th><%= (langCd.equals("en_US") ? "Pri.1" : "Giá 1") %></th>
									<th><%= (langCd.equals("en_US") ? "Vol.1" : "KL 1") %></th>
									<th><%= (langCd.equals("en_US") ? "Price" : "Giá") %></th>
									<th><%= (langCd.equals("en_US") ? "Vol" : "KL") %></th>
									<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
									<th><%= (langCd.equals("en_US") ? "%" : "%") %></th>
									<th><%= (langCd.equals("en_US") ? "Total Vol." : "Tổng KL") %></th>
									<th><%= (langCd.equals("en_US") ? "Pri.1" : "Giá 1") %></th>
									<th><%= (langCd.equals("en_US") ? "Vol.1" : "KL 1") %></th>
									
									<th id="thSellPrice2" class="hide"><%= (langCd.equals("en_US") ? "Pri.2" : "Giá 2") %></th>
									<th id="thSellVol2" class="hide"><%= (langCd.equals("en_US") ? "Vol.2" : "KL 2") %></th>
									<th id="thSellPrice3" class="hide"><%= (langCd.equals("en_US") ? "Pri.3" : "Giá 3") %></th>
									<th id="thSellVol3" class="hide"><%= (langCd.equals("en_US") ? "Vol.3" : "KL 3") %></th>
									
									<th><%= (langCd.equals("en_US") ? "Open" : "Mở") %></th>
									<th><%= (langCd.equals("en_US") ? "High" : "Cao") %></th>
									<th><%= (langCd.equals("en_US") ? "Low" : "Thấp") %></th>
									<th><%= (langCd.equals("en_US") ? "F.Buy" : "NN Mua") %></th>
									<th><%= (langCd.equals("en_US") ? "F.Sell" : "NN bán") %></th>
									<th id="thRoom" class="hide"><%= (langCd.equals("en_US") ? "Room" : "Room") %></th>
								</tr>
							</thead>
							<tbody id="trWatchList">
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- //WATCH LIST GROUP -->
		<div id="divAddStockPop" class="modal_wrap"></div>
		<!-- //WATCH LIST GROUP -->
	</body>
</HTML>