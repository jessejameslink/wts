<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd 	= 	(String) session.getAttribute("LanguageCookie");
	String loginId	=	(String) session.getAttribute("ClientV");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>MIRAE ASSET WTS</title>

	<script type="text/javascript">
		var	bidRcod =	"";
		var bidMark	=	"";
		var bidOpen	=	"";
		//console.log("$$$BID LIST PAGE$$$==>" + $("#dailySymb").val());
		$(document).ready(function(){
			//if ($("#dailySymb").val() != "") {
				//getEstimatePrice($("#dailySymb").val());	
			//}
			
		});
		
		function runGetEstimate() {
			getEstimatePrice();
			setInterval(getEstimatePrice, 10000);
		}
		/*
		function callEstimateProcess() {			
			var date1 = new Date();
			var date2 = new Date();
			var date2s = new Date();
			var date3 = new Date();
			var date3s = new Date();
			date2s.setHours(8);
			date2s.setMinutes(55);
			date2.setHours(9);
			date2.setMinutes(20);			
			date3s.setHours(14);
			date3s.setMinutes(25);
			date3.setHours(14);
			date3.setMinutes(50);
			
			var flagT = "";
			if (date1.getTime() < date2.getTime() && date1.getTime() > date2s.getTime()) {
				flagT = "ATO";
			}			
			if (date1.getTime() < date3.getTime() && date1.getTime() > date3s.getTime()) {
				flagT = "ATC";
			}
			
			if (flagT == "ATO" || flagT == "ATC") {
				//getEstimatePrice();
			} else {
				$("#tab31").find("td[name='t_estimate']").html("");
				return;
			}			
		}
		*/
		function getEstimatePrice() {
			var param = {
					  symb  : $("#bidStock").val()
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
						/*if (est.eprc != 0) {
							var cssColor  = displayColor(est.eprc.substring(0, 1));
							$("#tab31").find("td[name='t_estimate']").html("E:   " + zeroUpDownNumList(est.eprc.substring(1))).removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor);							
						} else {
							$("#tab31").find("td[name='t_estimate']").html("");
						}*/
						if(est.eprc == 0) {
							$("#tab31").find("td[name='t_estimate']").html("");
						}
					}
				});
		}
	
		function getData(symbol) {
			$("#tab31").block({message: "<span>LOADING...</span>"});
			if (symbol == "") {
				$("#tab31").unblock();
				return;
			}
			var param = {
				  symb  : symbol
				, lang  : ("<%= langCd %>" == "en_US" ? "1" : "0")
			};

			$.ajax({
				url      : "/trading/data/getBid10.do",
				contentType	:	"application/json; charset=utf-8",
				data     : param,
				dataType : "json",
				success  : function(data) {
					//console.log("Data current price");
					//console.log(data);
					setBID(data);
				}
			});			
		}

		function Ext_SetBID(rcod) {
			$("#bidStock").val(rcod);
			getData(rcod);
			//runGetEstimate();
			regRtsStock(rcod);
		}

		/*
			Current State Set Data
		*/
		function setBID(data) {
			$("._curval").each(function() {
				$(this).removeClass("lbd_red");
			});
		
			var tprc	=	data.tprc;
			var curr	=	data.curr;
			var dvdt 	= 	data.dvdt;
			
			if (curr.mark == 'HOSEM')
			{
				curr.mark = 'HOSE';
			}
			
			if (curr.mark == 'HNXOM')
			{
				curr.mark = 'HNX';
			}

			$("#tab31").find("th[name='htim']").html(v_time(tprc.htim));
			$("#tab31").find("span[name='bid_rcod']").html(curr.rcod);
			$("#tab31").find("span[name='bid_mark']").html("&nbsp;|&nbsp;&nbsp;" + curr.mark);
			$("#tab41").find("span[name='b_bid_mark']").html("&nbsp;|&nbsp;&nbsp;" + curr.mark);
			$("#tab49").find("span[name='s_bid_mark']").html("&nbsp;|&nbsp;&nbsp;" + curr.mark);
			if (dvdt.result == "1") {
				if ("<%= langCd %>" == "en_US") {
					$("#tab31").find("span[name='bid_divi']").html("&nbsp;|&nbsp;&nbsp;" + "Rights");
					$("#tab41").find("span[name='b_bid_divi']").html("&nbsp;|&nbsp;&nbsp;" + "Rights");
					$("#tab49").find("span[name='s_bid_divi']").html("&nbsp;|&nbsp;&nbsp;" + "Rights");
				} else {
					$("#tab31").find("span[name='bid_divi']").html("&nbsp;|&nbsp;&nbsp;" + "Quyền");
					$("#tab41").find("span[name='b_bid_divi']").html("&nbsp;|&nbsp;&nbsp;" + "Quyền");
					$("#tab49").find("span[name='s_bid_divi']").html("&nbsp;|&nbsp;&nbsp;" + "Quyền");
				}									
			} else {
				$("#tab31").find("span[name='bid_divi']").html("");
				$("#tab41").find("span[name='b_bid_divi']").html("");
				$("#tab49").find("span[name='s_bid_divi']").html("");
			}
			$("#tab31").find("span[name='bid_snam']").html(curr.snam);

			bidRcod =	curr.rcod;
			bidMark	=	curr.mark;
			bidOpen =   tprc.open;

			$("#tab31").find("input[name='bidRcod']").val(bidRcod);
			$("#tab31").find("input[name='bidMark']").val(bidMark);
			$("#tab31").find("input[name='bidOpen']").val(bidOpen);
			
			$("#tab31").find("td[name='open']").html(diffNum(tprc.open, $("#tab31").find("td[name='open']")));
			$("#tab31").find("td[name='high']").html(diffNum(tprc.high, $("#tab31").find("td[name='high']")));
			$("#tab31").find("td[name='lowe']").html(diffNum(tprc.lowe, $("#tab31").find("td[name='lowe']")));
			
			$("#tab31").find("td[name='open']").unbind('click');
			$("#tab31").find("td[name='high']").unbind('click');
			$("#tab31").find("td[name='lowe']").unbind('click');
			
			$("#tab31").find("td[name='open']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(tprc.open));
			});
			
			$("#tab31").find("td[name='high']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(tprc.high));
			});
			
			$("#tab31").find("td[name='lowe']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(tprc.lowe));
			});
			
			
			$("#tab31").find("td[name='selp1']").html(diffNum(tprc.selp1, $("#tab31").find("td[name='selp1']")));
			if(curr.curr == tprc.selp1) {
				$("#tab31").find("td[name='selp1']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='selp2']").html(diffNum(tprc.selp2, $("#tab31").find("td[name='selp2']")));
			if(curr.curr == tprc.selp2) {
				$("#tab31").find("td[name='selp2']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='selp3']").html(diffNum(tprc.selp3, $("#tab31").find("td[name='selp3']")));
			if(curr.curr == tprc.selp3) {
				$("#tab31").find("td[name='selp3']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='selp4']").html(diffNum(tprc.selp4, $("#tab31").find("td[name='selp4']")));
			if(curr.curr == tprc.selp4) {
				$("#tab31").find("td[name='selp4']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='selp5']").html(diffNum(tprc.selp5, $("#tab31").find("td[name='selp5']")));
			if(curr.curr == tprc.selp5) {
				$("#tab31").find("td[name='selp5']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='buyp1']").html(diffNum(tprc.buyp1, $("#tab31").find("td[name='buyp1']")));
			if(curr.curr == tprc.buyp1) {
				$("#tab31").find("td[name='buyp1']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='buyp2']").html(diffNum(tprc.buyp2, $("#tab31").find("td[name='buyp2']")));
			if(curr.curr == tprc.buyp2) {
				$("#tab31").find("td[name='buyp2']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='buyp3']").html(diffNum(tprc.buyp3, $("#tab31").find("td[name='buyp3']")));
			if(curr.curr == tprc.buyp3) {
				$("#tab31").find("td[name='buyp3']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='buyp4']").html(diffNum(tprc.buyp4, $("#tab31").find("td[name='buyp4']")));
			if(curr.curr == tprc.buyp4) {
				$("#tab31").find("td[name='buyp4']").addClass("lbd_red");
			}
			$("#tab31").find("td[name='buyp5']").html(diffNum(tprc.buyp5, $("#tab31").find("td[name='buyp5']")));
			if(curr.curr == tprc.buyp5) {
				$("#tab31").find("td[name='buyp5']").addClass("lbd_red");
			}
			
			$("#tab31").find("td[name='selp1']").unbind('click');
			$("#tab31").find("td[name='selp2']").unbind('click');
			$("#tab31").find("td[name='selp3']").unbind('click');
			$("#tab31").find("td[name='selp4']").unbind('click');
			$("#tab31").find("td[name='selp5']").unbind('click');
			$("#tab31").find("td[name='buyp1']").unbind('click');
			$("#tab31").find("td[name='buyp2']").unbind('click');
			$("#tab31").find("td[name='buyp3']").unbind('click');
			$("#tab31").find("td[name='buyp4']").unbind('click');
			$("#tab31").find("td[name='buyp5']").unbind('click');

			$("#tab31").find("td[name='selp1']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.selp1));
			});

			$("#tab31").find("td[name='selp2']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.selp2));
			});

			$("#tab31").find("td[name='selp3']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.selp3));
			});
			
			$("#tab31").find("td[name='selp4']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.selp4));
			});
			
			$("#tab31").find("td[name='selp5']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.selp5));
			});

			$("#tab31").find("td[name='buyp1']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.buyp1));
			});

			$("#tab31").find("td[name='buyp2']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.buyp2));
			});

			$("#tab31").find("td[name='buyp3']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.buyp3));
			});
			
			$("#tab31").find("td[name='buyp4']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.buyp4));
			});
			
			$("#tab31").find("td[name='buyp5']").click(function() {
				Ext_SetEnterOrder(curr.rcod, curr.mark, diffNum(tprc.buyp5));
			});


			$("#tab31").find("td[name='selv1']").html(zeroUpDownNum(tprc.selv1, $("#tab31").find("td[name='selv1']")));
			$("#tab31").find("td[name='selv2']").html(zeroUpDownNum(tprc.selv2, $("#tab31").find("td[name='selv2']")));
			$("#tab31").find("td[name='selv3']").html(zeroUpDownNum(tprc.selv3, $("#tab31").find("td[name='selv3']")));
			$("#tab31").find("td[name='selv4']").html(zeroUpDownNum(tprc.selv4, $("#tab31").find("td[name='selv4']")));
			$("#tab31").find("td[name='selv5']").html(zeroUpDownNum(tprc.selv5, $("#tab31").find("td[name='selv5']")));
			$("#tab31").find("td[name='buyv1']").html(zeroUpDownNum(tprc.buyv1, $("#tab31").find("td[name='buyv1']")));
			$("#tab31").find("td[name='buyv2']").html(zeroUpDownNum(tprc.buyv2, $("#tab31").find("td[name='buyv2']")));
			$("#tab31").find("td[name='buyv3']").html(zeroUpDownNum(tprc.buyv3, $("#tab31").find("td[name='buyv3']")));
			$("#tab31").find("td[name='buyv4']").html(zeroUpDownNum(tprc.buyv4, $("#tab31").find("td[name='buyv4']")));
			$("#tab31").find("td[name='buyv5']").html(zeroUpDownNum(tprc.buyv5, $("#tab31").find("td[name='buyv5']")));

			$("#tab31").find("td[name='curr']").html(diffNum(curr.curr, $("#tab31").find("td[name='curr']")));
			$("#tab31").find("td[name='diff']").html(diffNum(curr.diff, $("#tab31").find("td[name='diff']")) + " / " + diffNum(curr.rate, $("#tab31").find("td[name='rate']")) + "%");
			
			//@ 추가 로직
			$("#tab31").find("td[name='t_curr']").html(diffNum(curr.curr, $("#tab31").find("td[name='t_curr']")));
			var cssArrow  = displayArrow(curr.diff.substring(0, 1));
			$("#tab31").find("td[name='t_curr']").html(diffNum(curr.curr, $("#tab31").find("td[name='t_curr']")));			
			$("#tab31").find("td[name='t_diff']").removeClass("arrow").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssArrow).html(diffNum(curr.diff) + "(" + diffNum(curr.rate) + "%)");
			$("#tab31").find("td[name='t_vol']").html(zeroUpDownNumList(curr.avol));
			
			//Estimate price
			if (curr.eprc != 0) {
				$('#infoArea').attr('colspan',4);
				$("#t_estimate").removeClass('hide');
				var cssColorE  = displayColor(curr.eprc.substring(0, 1));
				$("#tab31").find("td[name='t_estimate']").html("E:   " + zeroUpDownNumList(curr.eprc.substring(1))).removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColorE);
			} else {
				$('#infoArea').attr('colspan',3);
				$("#t_estimate").addClass('hide');
				$("#tab31").find("td[name='t_estimate']").html("");
			}
			
			$("#tab31").find("td[name='ceil']").html(zeroUpDownNumList(tprc.ceil));
			$("#tab31").find("td[name='floo']").html(zeroUpDownNumList(tprc.floo));
			$("#tab31").find("td[name='trom']").html(zeroUpDownNumList(tprc.trom));
			
			

			$("#tab31").find("td[name='ceil']").unbind('click');
			$("#tab31").find("td[name='floo']").unbind('click');
			$("#tab31").find("td[name='trom']").unbind('click');
			
			$("#tab31").find("td[name='ceil']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, zeroUpDownNumList(tprc.ceil));
			});
			
			$("#tab31").find("td[name='floo']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, zeroUpDownNumList(tprc.floo));
			});
			
			$("#tab31").find("td[name='trom']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, zeroUpDownNumList(tprc.trom));
			});
			//console.log("BID DATA 확인++++++++++++++++");
			//console.log(tprc);
			//console.log(curr);
			
			//$("#tab31").find("td[name='rate']").html(diffNum(curr.rate, $("#tab31").find("td[name='rate']")));
			//var sbvol	=	Number(tprc.svol) - Number(tprc.bvol);
			var cssColor = displayColor(curr.curr.substring(0, 1));
			$("#tab31").find("td[name='tot_vol']").html(zeroUpDownNum(curr.avol, $("#tab31").find("td[name='tot_vol']"))).removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor);
			$("#tab31").find("td[name='f_room']").html(zeroUpDownNum(tprc.trom, $("#tab31").find("td[name='f_room']")));
			$("#tab31").find("td[name='f_btot']").html(zeroUpDownNum(tprc.buyf, $("#tab31").find("td[name='f_btot']")));
			$("#tab31").find("td[name='f_stot']").html(zeroUpDownNum(tprc.self, $("#tab31").find("td[name='f_stot']")));
			
			$("#tab31").find("td[name='svol']").html(zeroUpDownNum(tprc.svol, $("#tab31").find("td[name='svol']")));
			$("#tab31").find("td[name='bvol']").html(zeroUpDownNum(tprc.bvol, $("#tab31").find("td[name='bvol']")));
			
			//selc1+selc2+selc3
			//buyc1+buyc2+buyc3
			
			//	Current price setting
			//var currentPrice	=	$("#tab31").find("td[name='t_curr']").html();
			var bef_sname = $("#tab31").find("span[name='bid_snam']").html();
			var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
				
			if(tabId == "buytab") {
				//$("#tab41").find("input[name='priceView']").val(currentPrice);
				//$("#tab41").find("input[name='price']").val(currentPrice);
				$("#tab41").find("span[name='bid_snam']").html(bef_sname);
				maxVolumeBuy();
			} else {
				//$("#tab49").find("input[name='priceView']").val(currentPrice);
				//$("#tab49").find("input[name='price']").val(currentPrice);
				$("#tab49").find("span[name='bid_snam']").html(bef_sname);
			}
			$("#tab31").unblock();
			
			//@TODO :  Real Time Modiy.... TEMP Process
			//rtsConnect(curr.symb);
			
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
		
		function bindCurr(data) {
			//console.log("=====PIBO CURR CHECK");
			//console.log(data);
			//console.log(data.value["023"]);
			var cssColor = displayColor(data.value["023"].substring(0, 1));
			$("#tab31").find("th[name='htim']").html(v_time(data.value["034"]));
			$("#tab31").find("td[name='curr']").html(diffNum(data.value["023"], $("#tab31").find("td[name='curr']")));
			$("#tab31").find("td[name='diff']").html(diffNum(data.value["024"], $("#tab31").find("td[name='diff']")) + " / " + diffNum(data.value["033"], $("#tab31").find("td[name='rate']")) + "%");
			//$("#tab31").find("td[name='rate']").html(diffNum(data.value["033"], $("#tab31").find("td[name='rate']")));
			$("#tab31").find("td[name='open']").html(diffNum(data.value["029"], $("#tab31").find("td[name='open']")));
			$("#tab31").find("td[name='high']").html(diffNum(data.value["030"], $("#tab31").find("td[name='high']")));
			$("#tab31").find("td[name='lowe']").html(diffNum(data.value["031"], $("#tab31").find("td[name='lowe']")));
			

			$("#tab31").find("td[name='open']").unbind('click');
			$("#tab31").find("td[name='high']").unbind('click');
			$("#tab31").find("td[name='lowe']").unbind('click');
			
			$("#tab31").find("td[name='open']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, bidOpen);
			});
			
			$("#tab31").find("td[name='high']").click(function() {
				Ext_SetEnterOrder($("#bidRcod").val(), $("#bidMark").val(), diffNum(data.value["030"]));
			});
			
			$("#tab31").find("td[name='lowe']").click(function() {
				Ext_SetEnterOrder($("#bidRcod").val(), $("#bidMark").val(), diffNum(data.value["031"]));
			});
			
			$("#tab31").find("td[name='tot_vol']").html(zeroUpDownNum(data.value["027"], $("#tab31").find("td[name='tot_vol']"))).removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor);
			
			$("#tab31").find("td[name='t_diff']").html(data.value["024"].substring(1)+"("+data.value["033"].substring(1)+"%)").removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor);
			$("#tab31").find("td[name='t_curr']").html(diffNum(data.value["023"], $("#tab31").find("td[name='t_curr']")));
			$("#tab31").find("td[name='t_vol']").html(zeroUpDownNum(data.value["027"], $("#tab31").find("td[name='t_vol']")));
			//++++++++++++임시실행+++++++++++++++++++++++
			//alert("OP=>" + $("#tab31").find("td[name='open']").html() + ", data val=>" + data.value["030"]);
			//if($("#tab31").find("td[name='open']").html() == "" && data.value["030"] != "") {
			//	selItem($("#dailySymb").val());
			//}
			//++++++++++++++++++++++++++++++++++++++++
		}
		
		function bindForeigner(data) {
			//console.log(data.code);
			//console.log(data.value["122"]);
			//console.log(data.value["121"]);
			$("#tab31").find("td[name='f_btot']").html(zeroUpDownNum(data.value["122"], $("#tab31").find("td[name='f_btot']")));
			$("#tab31").find("td[name='f_stot']").html(zeroUpDownNum(data.value["121"], $("#tab31").find("td[name='f_stot']")));
			
		}
		
		function bindEstimatePrice(data) {
			//console.log(data.code);
			//console.log(data.value["122"]);
			//console.log(data.value["121"]);
			if (data.value["223"].substring(1) == 0 && data.value["227"] == 0) {
				$('#infoArea').attr('colspan',3);
				$("#t_estimate").addClass('hide');
				$("#tab31").find("td[name='t_estimate']").html("");
			} else {
				$('#infoArea').attr('colspan',4);
				$("#t_estimate").removeClass('hide');
				var cssColor  = displayColor(data.value["223"].substring(0, 1));
				$("#tab31").find("td[name='t_estimate']").html("E:   " + zeroUpDownNumList(data.value["223"].substring(1))).removeClass("upper").removeClass("up").removeClass("same").removeClass("low").removeClass("lower").addClass(cssColor);
			}
		}
		
		
		/*
		000	RTS-Type
		040	호가수신시간
		023	현재가
		030	고가
		031	저가
		051	매도 1호가
		052	매도 2호가
		053	매도 3호가
		041	매도 1호가 수량
		042	매도 2호가 수량
		043	매도 3호가 수량
		081	매도 1호가 직전대비수량
		082	매도 2호가 직전대비수량
		083	매도 3호가 직전대비수량
		071	매수 1호가
		072	매수 2호가
		073	매수 3호가
		061	매수 1호가 수량
		062	매수 2호가 수량
		063	매수 3호가 수량
		091	매수 1호가 직전대비수량
		092	매수 2호가 직전대비수량
		093	매수 3호가 직전대비수량
		101	매도 총수량
		106	매수 총수량		
		*/
		/*
		Object
			code: "HAG"
			gubn: "B"
			value: Object
				023: "25390"
				030: "25380"
				031: "35360"040: "091545"041: "22970"042: "40100"043: "2000"051: "25400"052: "25450"053: "25470"061: "4700"062: "27300"063: "11170"071: "25390"072: "25370"073: "35360"081: "22770"082: "35000"083: "-20970"091: "-22600"092: "16130"093: "-670"101: "65070"106: "43170"__proto__: Object__proto__: Object
		nexClient_test.js:220 [Object, Object]
		*/
		function bindTprc(data) {
			
			$("#tab31").find("th[name='htim']").html(v_time(data.value["040"]));
			
			$("#tab31").find("td[name='selv1']").html(zeroUpDownNum(data.value["041"], $("#tab31").find("td[name='selv1']")));
			$("#tab31").find("td[name='selv2']").html(zeroUpDownNum(data.value["042"], $("#tab31").find("td[name='selv2']")));
			$("#tab31").find("td[name='selv3']").html(zeroUpDownNum(data.value["043"], $("#tab31").find("td[name='selv3']")));
			$("#tab31").find("td[name='selv4']").html(zeroUpDownNum(data.value["044"], $("#tab31").find("td[name='selv4']")));
			$("#tab31").find("td[name='selv5']").html(zeroUpDownNum(data.value["045"], $("#tab31").find("td[name='selv5']")));
			
			$("#tab31").find("td[name='buyv1']").html(zeroUpDownNum(data.value["061"], $("#tab31").find("td[name='buyv1']")));
			$("#tab31").find("td[name='buyv2']").html(zeroUpDownNum(data.value["062"], $("#tab31").find("td[name='buyv2']")));
			$("#tab31").find("td[name='buyv3']").html(zeroUpDownNum(data.value["063"], $("#tab31").find("td[name='buyv3']")));
			$("#tab31").find("td[name='buyv4']").html(zeroUpDownNum(data.value["064"], $("#tab31").find("td[name='buyv4']")));
			$("#tab31").find("td[name='buyv5']").html(zeroUpDownNum(data.value["065"], $("#tab31").find("td[name='buyv5']")));
						
			var tsvol	=	Number(data.value["041"]) + Number(data.value["042"]) + Number(data.value["043"]) + Number(data.value["044"]) + Number(data.value["045"]);
			var tbvol	=	Number(data.value["061"]) + Number(data.value["062"]) + Number(data.value["063"]) + Number(data.value["064"]) + Number(data.value["065"]);
			
			$("#tab31").find("td[name='svol']").html(zeroUpDownNum(String(tsvol), $("#tab31").find("td[name='svol']")));
			$("#tab31").find("td[name='bvol']").html(zeroUpDownNum(String(tbvol), $("#tab31").find("td[name='bvol']")));
			
			$("#tab31").find("td[name='selp1']").html(diffNum(data.value["051"], $("#tab31").find("td[name='selp1']")));
			$("#tab31").find("td[name='selp2']").html(diffNum(data.value["052"], $("#tab31").find("td[name='selp2']")));
			$("#tab31").find("td[name='selp3']").html(diffNum(data.value["053"], $("#tab31").find("td[name='selp3']")));
			$("#tab31").find("td[name='selp4']").html(diffNum(data.value["054"], $("#tab31").find("td[name='selp4']")));
			$("#tab31").find("td[name='selp5']").html(diffNum(data.value["055"], $("#tab31").find("td[name='selp5']")));
			
			$("#tab31").find("td[name='buyp1']").html(diffNum(data.value["071"], $("#tab31").find("td[name='buyp1']")));
			$("#tab31").find("td[name='buyp2']").html(diffNum(data.value["072"], $("#tab31").find("td[name='buyp2']")));
			$("#tab31").find("td[name='buyp3']").html(diffNum(data.value["073"], $("#tab31").find("td[name='buyp3']")));
			$("#tab31").find("td[name='buyp4']").html(diffNum(data.value["074"], $("#tab31").find("td[name='buyp4']")));
			$("#tab31").find("td[name='buyp5']").html(diffNum(data.value["075"], $("#tab31").find("td[name='buyp5']")));
			

			$("#tab31").find("td[name='selp1']").unbind('click');
			$("#tab31").find("td[name='selp2']").unbind('click');
			$("#tab31").find("td[name='selp3']").unbind('click');
			$("#tab31").find("td[name='selp4']").unbind('click');
			$("#tab31").find("td[name='selp5']").unbind('click');
			
			$("#tab31").find("td[name='buyp1']").unbind('click');
			$("#tab31").find("td[name='buyp2']").unbind('click');
			$("#tab31").find("td[name='buyp3']").unbind('click');
			$("#tab31").find("td[name='buyp4']").unbind('click');
			$("#tab31").find("td[name='buyp5']").unbind('click');

			$("#tab31").find("td[name='selp1']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["051"], $("#tab31").find("td[name='selp1']")));
			});

			$("#tab31").find("td[name='selp2']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["052"], $("#tab31").find("td[name='selp2']")));
			});

			$("#tab31").find("td[name='selp3']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["053"], $("#tab31").find("td[name='selp3']")));
			});
			
			$("#tab31").find("td[name='selp4']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["054"], $("#tab31").find("td[name='selp4']")));
			});
			
			$("#tab31").find("td[name='selp5']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["055"], $("#tab31").find("td[name='selp5']")));
			});

			$("#tab31").find("td[name='buyp1']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["071"], $("#tab31").find("td[name='buyp1']")));
			});

			$("#tab31").find("td[name='buyp2']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["072"], $("#tab31").find("td[name='buyp2']")));
			});

			$("#tab31").find("td[name='buyp3']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["073"], $("#tab31").find("td[name='buyp3']")));
			});
			
			$("#tab31").find("td[name='buyp4']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["074"], $("#tab31").find("td[name='buyp4']")));
			});
			
			$("#tab31").find("td[name='buyp5']").click(function() {
				Ext_SetEnterOrder(bidRcod, bidMark, diffNum(data.value["075"], $("#tab31").find("td[name='buyp5']")));
			});


			$("._curval").each(function() {
				$(this).removeClass("lbd_red");
			});
			
			if(data.value["023"] == data.value["051"]) {
				$("#tab31").find("td[name='selp1']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["052"]) {
				$("#tab31").find("td[name='selp2']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["053"]) {
				$("#tab31").find("td[name='selp3']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["054"]) {
				$("#tab31").find("td[name='selp4']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["055"]) {
				$("#tab31").find("td[name='selp5']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["071"]) {
				$("#tab31").find("td[name='buyp1']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["072"]) {
				$("#tab31").find("td[name='buyp2']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["073"]) {
				$("#tab31").find("td[name='buyp3']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["074"]) {
				$("#tab31").find("td[name='buyp4']").addClass("lbd_red");
			}
			
			if(data.value["023"] == data.value["075"]) {
				$("#tab31").find("td[name='buyp5']").addClass("lbd_red");
			}			
		}
		
		function stockInfoPop() {
			$.ajax({
				type     : "POST",
				url      : "/trading/popup/stockInfo.do",
				data     : $("#frmAddGroup").serialize(),
				dataType : "html",
				success  : function(data){
					$("#divStockInfoPop").fadeIn();
					$("#divStockInfoPop").html(data);
				},
				error     :function(e) {
					console.log(e);
				}
			});
		}
		
		
	</script>
	<style>
	.wts_excla {position:absolute; top:4px; left:15px; width:22px; height:14px; background:url(/resources/images/wts_exclamation_bid.png) no-repeat 0 0; text-indent: 200%; overflow: hidden; white-space: nowrap; border: none;}
	.wts_up {display:inline-block; width:10px; height:9px; margin-right:5px; background:url(/resources/images/wts_rise.png) no-repeat 0 0; text-indent:200%; white-space:nowrap; overflow:hidden;}
	.tool-tip{
		color: #fff;
		background-color: rgba( 0, 0, 0, .7);
		text-shadow: none;
		font-size: 1.0em;
		visibility: hidden;
		-webkit-border-radius: 7px; 
		-moz-border-radius: 7px; 
		-o-border-radius: 7px; 
		border-radius: 7px;	
		text-align: center;	
		opacity: 0;
		z-index: 999;
		padding: 3px 8px;	
		position: absolute;
		cursor: default;
		-webkit-transition: all 240ms ease-in-out;
		-moz-transition: all 240ms ease-in-out;
		-ms-transition: all 240ms ease-in-out;
		-o-transition: all 240ms ease-in-out;
		transition: all 240ms ease-in-out;	
	}

	/* tool tip position bottom */
	
	.tool-tip.bottom{
		top: 115%;
		bottom: auto;
		left: 3%;
		margin-bottom: auto;	
	}
	
	.tool-tip.bottom:after{
		position: absolute;
		top: -12px;
		left: 15%;
		margin-left: -7px;
		content: ' ';
		height: 0px;
		width: 0px;
		border: 6px solid transparent;
	    border-top-color: transparent;	
	    border-bottom-color: rgba( 0, 0, 0, .6);	
	}

	/* on hover of element containing tooltip default*/
	
	*:not(.on-focus):hover > .tool-tip,
	.on-focus input:focus + .tool-tip{
		visibility: visible;
		opacity: 1;
		-webkit-transition: all 240ms ease-in-out;
		-moz-transition: all 240ms ease-in-out;
		-ms-transition: all 240ms ease-in-out;
		-o-transition: all 240ms ease-in-out;
		transition: all 240ms ease-in-out;		
	}
	</style>
</head>
		
<body class="mdi" >
		<!-- 2017.04.05 김정순 -->
		<!-- Bid -->
		<div class="tab_content margin_top_0">
		<div role="tabpanel" class="tab_pane" id="tab31">
		<input type="hidden" id="bidRcod" name="bidRcod"/>
		<input type="hidden" id="bidMark" name="bidMark"/>
		<input type="hidden" id="bidOpen" name="bidOpen"/>
		<!-- BID -->
		<div class="group_table bid_table radius_top" style="border:none;">
			
			<table class="biding_wts" id="tb_biding_wts">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col />
				</colgroup>
				<thead>
				
				</thead>
				<tbody  id="tbbody_biding_wts" >
					 
					<tr style="display:none;">
						<td id="infoArea" colspan="4" style="border-radius:3px 3px 0 0;">
							<button type="button" class="wts_excla" onclick="stockInfoPop();">exclamation</button>
							<div class="tool-tip bottom"><%= (langCd.equals("en_US") ? "Stock Infomation" : "Thông tin chứng khoán") %></div>
							<span class="code" name="bid_rcod"></span>
							<span class="code" name="bid_mark"></span>
							<span style="color:red!important;margin-left:20px;" name="bid_divi"></span>
							<span style="color:#000!important;" class="name" name="bid_snam"></span>
						</td>
					</tr>
					
					<tr>
						<td id="t_curr" name="t_curr" style="height:20px;font-size:20px;"></td>
						<td id="t_estimate" name="t_estimate" style="height:20px;font-size:20px;"></td>
						<td id="t_diff" name="t_diff" class="txt_org" style="height:20px;font-size:20px;"></td>						
						<td style="text-align:center;height:20px;font-size:20px;" id="t_vol" name="t_vol"></td>
					</tr>
				</tbody>
			</table>
			
			<table class="table no_bbt bidding_ask" style="margin-top:5px; border: 1px solid #d7d7d7; border-radius: 4px 4px 4px 4px;">				
				<colgroup>
					<col width="20%" />
					<col width="20%" />
					<col />
					<col width="20%" />
					<col width="20%" />					
				</colgroup>
				<thead>
					<tr>
					 	<!-- <th></th> -->
						<th style="border-radius:4px 0 0 0" colspan="2"><%= (langCd.equals("en_US") ? "BID" : "Dư mua") %></th>
						<th name="htim" style="border-left:none; border-right:none;"></th>
						<th style="border-radius:0 4px 0 0" colspan="2"><%= (langCd.equals("en_US") ? "ASK" : "Dư bán") %></th>
						<!-- <th></th> -->
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="no_bbt txt l"><%= (langCd.equals("en_US") ? "Open" : "Giá mở cửa") %></td> 
						<td name="open" class="no_lbd cur no_bbt r right" style="cursor:pointer;"></td>
						<td name="selp5" class="bg02 text_center _curval  "></td>
						<td name="selv5" class="bg02 l left" colspan="2"></td>						
					</tr>
					<tr>
						<td class="no_bbt txt l"><%= (langCd.equals("en_US") ? "High" : "Giá cao nhất") %></td>
						<td class="no_lbd no_bbt r  right" name="high" style="cursor:pointer;">							
						</td>
						<td name="selp4" class="bg02 text_center _curval "></td>
						<td name="selv4" class="bg02 l left" colspan="2"></td>
					</tr>
					<tr>
						<td class="txt  l"><%= (langCd.equals("en_US") ? "Low" : "Giá thấp nhất") %></td>
						<td name="lowe" class="no_lbd r  right" style="cursor:pointer;"></td>
						<td name="selp3" class="bg02 text_center _curval  "></td>
						<td name="selv3" class="bg02 l left" colspan="2"></td>
						<!-- <td name="selc3" class="bg02"></td> -->
					</tr>
					<tr>
						<td class="no_bbt txt l"></td>
						<td class="no_lbd no_bbt r  right">							
						</td>
						<td name="selp2" class="bg02 text_center _curval "></td>
						<td name="selv2" class="bg02 l left" colspan="2"></td>
						<!-- <td name="selc2" class="bg02"></td> -->
					</tr>
					<tr>
						<td class="txt bottom l"></td>
						<td class="no_lbd r bottom right"></td>
						<td name="selp1" class="bg02 text_center _curval  bottom"></td>
						<td name="selv1" class="bg02 l bottom left" colspan="2"></td>
						<!-- <td name="selc1" class="bg02"></td> -->
					</tr>

					<tr>
						<!-- <td name="buyc1" class="bg01"></td> -->
						<td name="buyv1" class="bg01 r right" colspan="2"></td>
						<td name="buyp1" class="bg01 text_center _curval  "></td>
						<td name="" class="no_bbt txt left l" style="color:#ff5bbc;"><%= (langCd.equals("en_US") ? "CE" : "Trần") %></td>
						<td name="ceil" class="r" style="color:#ff5bbc;cursor:pointer;"></td>
						<!-- <td name="open" id="open" class="pr no_lbd no_bbt"></td> -->
					</tr>
					<tr>
						<!-- <td name="buyc2" class="bg01"></td> -->
						<td name="buyv2" class="bg01 r right" colspan="2"></td>
						<td name="buyp2" class="bg01 text_center _curval  "></td>
						<td name="" class="no_bbt txt left l" style="color:#3b97fe;"><%= (langCd.equals("en_US") ? "FL" : "Sàn") %></td>
						<td name="floo" class="r"style="color:#3b97fe;cursor:pointer;"></td>
						<!-- <td name="high" class="pr no_lbd no_bbt"></td> -->
					</tr>
					<tr>
						<!-- <td name="buyc3" class="bg01"></td> -->
						<td name="buyv3" class="bg01 r  right" colspan="2"></td>
						<td name="buyp3" class="bg01 text_center _curval "></td>
						<td name="" class="txt  left l" style="color:#e7a912;"><%= (langCd.equals("en_US") ? "Ref" : "TC") %></td>
						<td name="trom" class=" r" style="color:#e7a912;cursor:pointer;"></td>
						<!-- <td name="lowe" class="pr no_lbd"></td> -->
					</tr>
					<tr>						
						<td name="buyv4" class="bg01 r right" colspan="2"></td>
						<td name="buyp4" class="bg01 text_center _curval "></td>
						<td class="txt  left l" style="color:#e7a912;"></td>
						<td class=" r" style="color:#e7a912;cursor:pointer;"></td>
					</tr>
					<tr>						
						<td name="buyv5" class="bg01 r bottom right" colspan="2"></td>
						<td name="buyp5" class="bg01 text_center _curval bottom"></td>
						<td class="txt bottom left l" style="color:#e7a912;"></td>
						<td class="bottom r" style="color:#e7a912;cursor:pointer;"></td>
					</tr>
					 
					<tr>
						<%-- <td class="txt"><%= (langCd.equals("en_US") ? "Total Volume Buy/Sell" : "Tổng KL Mua/Bán") %></td> --%>
						<td id="bvol" name="bvol" class="r bottom right" colspan="2"></td>
						<td name="sb_vol" class="sb_vol bottom" style="color:#7a7d82"><%= (langCd.equals("en_US") ? "Total" : "") %></td>
						<td id="svol" name="svol" class="l left bottom" colspan="2"></td>
						<!-- <td ></td> -->
					</tr>
					<tr>
						<!-- <td ></td> -->
						<td name="f_btot" style="border-radius:0 0 0 4px" class="c right" colspan="2"></td>
						<td class="text_center" style="color:#7a7d82; font-weight:normal;"><%= (langCd.equals("en_US") ? "Foreigner" : "GD NĐT NN") %></td>
						<td name="f_stot" style="border-radius:0 0 4px 0" class="c left" colspan="2"></td>
						<!-- <td ></td> -->
					</tr>
				</tbody>
			</table>
		</div>
		
		
		<!-- //Bid 2017.04.05 김정순-->
	</div>
</div>

<div id="divStockInfoPop" class="modal_wrap"></div>
</body>

</html>