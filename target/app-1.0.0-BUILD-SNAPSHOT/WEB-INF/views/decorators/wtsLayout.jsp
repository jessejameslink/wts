
<%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");
	response.setHeader("P3P", "CP='CAO PSA CONi OTR OUR DEM ONL'");
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import="m.config.SystemConfig"%>

<%
	String langCd = (String) session.getAttribute("LanguageCookie");
	String loginId = (String) session.getAttribute("ClientV");
	String rtsServerIp = SystemConfig.get("SYSTEM.RTS.SERVER.IP");
	String rtsServerStatus = SystemConfig.get("SYSTEM.TTL.MATCHING.STATUS");
	String clientID = (String) session.getAttribute("clientID");
	String popup = (String) session.getAttribute("subAccountID");
	String sub = (String) session.getAttribute("subAccountID");
%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">

<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">

<link href="/resources/css/common.css" rel="stylesheet">
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
<script type="text/javascript" src="/resources/js/socket.io.js"></script>
<script type="text/javascript" src="/resources/js/nexClient.js"></script>

<script type="text/javascript" src="/resources/js/excel/excellentexport.min.js"></script>
<script type="text/javascript" src="/resources/js/chart_new/highstock.src.js"></script>
<script type="text/javascript" src="/resources/js/chart_new/highcharts-more.src.js"></script>


<script type="text/javascript" src="/resources/js/jquery.floatThead.js"></script>
<script type="text/javascript" src="/resources/js/perfect-scrollbar.min.js"></script>

<script type="text/javascript" src="/resources/js/application.js"></script>
<script type="text/javascript" src="/resources/js/atmosphere.js"></script>



<script>
	window.LOGIN_ID	=	"<%=loginId%>";
	window.CLIENT_ID	=	"<%=clientID%>";
	window.RTS_IP	=	"<%=rtsServerIp%>";
	window.RTS_STATUS	=	"<%=rtsServerStatus%>";
	var sTradeTp = null;
	var errSessionCnt	=	0;
	var errCommCnt		=	0;
	var popup		=	"<%=popup%>";
	var popupone		=	0;
	var sub		=	"<%=sub%>";
	var lengOjSubAccount = 0;
	var linkCham = "";
	
	$(document).ready(function() {
		$("body").addClass("<%=langCd%>" == "en_US" ? "mdi L_EN" : "mdi L_VI");
		$(".wts_menu > li").removeClass("on").removeClass("wide");
		$(".wts_menu > li").addClass("wide");
		$("#"+"${TAB_INFO}").removeClass("wide").addClass("on");
		$("#"+"${TAB_INFO}").unbind('click');
		$("#"+"${TAB_INFO} > button").unbind('click');		
		
		getNodeJS();
		getCham();
		homeIdx();
		//homeNews();
		setInterval(setIdx, 15000);
		//setInterval(homeNews, 120000);
		getSubAccount();
		
		//console.log("popupversion6");
		//console.log("<%=popup%>");
		
		//var popuplogin = getCookieResign("loginSuccess");
		//var popupone = getCookieResign('<%=popup%>');
		
		//if (popuplogin) {
		//	if (popuplogin.includes("popupone") && popup.includes("C780112")){	
		//		resignContract();
		//	}
		//}
		//else if (popupone) {
		//	if ((popup.includes("C780112") && popupone.includes("popupone"))){	
		//		resignContract();
		//	}
		//}else {
		//	setCookieResign('<%=popup%>',"popupone",1);
		//}
		
		
	});
	
	//setCookieResign('ppkcookie','testcookie',5);

	//var x = getCookieResign('ppkcookie');
	//if (x) {
	    //alert('cookie');
	//}
	
	function setCookieResign(name,value,days) {
	    var expires = "";
	    if (days) {
	        var date = new Date();
	        date.setTime(date.getTime() + (days*24*60*60*1000));
	        //date.setTime(date.getTime() + (days*1000));
	        expires = "; expires=" + date.toUTCString();
	    }
	    document.cookie = name + "=" + (value || "")  + expires + "; path=/";
	}
	function getCookieResign(name) {
	    var nameEQ = name + "=";
	    var ca = document.cookie.split(';');
	    for(var i=0;i < ca.length;i++) {
	        var c = ca[i];
	        while (c.charAt(0)==' ') c = c.substring(1,c.length);
	        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	    }
	    return null;
	}
	function eraseCookie(name) {   
	    document.cookie = name+'=; Max-Age=-99999999;';  
	}
	
	function resignContract(){
		var mess = "";
		var mess1 = "";
		if ("<%= langCd %>" == "en_US") {
			mess1 = 'Click on outsite pop up to continue!';
			mess = '<img src="https://www.masvn.com/docs/image/upgradesystem_en.png" width="150%" height="100%" style="margin-top: 100px;">';
		} else {
			mess1 = 'Click ngoài thông báo để tiếp tục!';
			mess = '<img src="https://www.masvn.com/docs/image/upgradesystem.png" width="150%" height="100%" style="margin-top: 100px;">';
		}
		$.blockUI({ 
	           message: $('#displayBox'), 
	           css: { 
	                //width: 7707 + "px",
	                //height: 7706 + "px",
	                top: '2%',
	                left: '30%',
	                //margin: (-7706 / 10) + 'px 0 0 '+ (-7707/10) + 'px'
	    	     },
				//message: '<img src="https://www.masvn.com/docs/image/1week.png" width="150%" height="100%" style="margin-top: 100px;">',
				message: mess,
	    		timeout:   5000 
		}); 
		$('.blockOverlay').attr('title', mess1 ).click($.unblockUI);
		//document.getElementById("loginOn").disabled=true;
		setCookieResign('<%=popup%>',"popuptwo",1);
		setCookieResign('loginSuccess',"popuptwo",1);
		return;
	}
	
	function sendNotifycation(obj) {
		//console.log("obj: ", obj);
		if(obj.status === 'TOPIC_HKSFO_ORDER_ENQUIRY'){
			var mvStatusArr = ['FEX', 'PEX', 'FLL', 'FLC', 'ALF', 'FAK', 'BIX'];
			if(mvStatusArr.includes(obj.data.mvStatus) && parseInt(obj.data.mvFilledQty) > 0){
				var param = {
					mvClientID	:	"<%=session.getAttribute("clientID")%>",
					data: "MAS-KQKL " + obj.data.mvInputTime + " - TK " + obj.data.mvSubAccountID + " Mua " + obj.data.mvStockID + " " + obj.data.mvQty + "/"+ obj.data.mvPrice +" Khop " + obj.data.mvFilledQty +  "/"+ obj.data.mvPrice
					//data example:  MAS-KQKL 09:41:27 - TK C089237X1 Mua STB 200/22.0000 Khop 100/22.0000
				};
				console.log("notifycation: ", param.data);
				//console.log("khớp khớp khớp");
				$.ajax({
					url      : "/trading/data/sendNotifycation.do",
					data      : param,
					contentType	:	"application/json; charset=utf-8",
					dataType : "json",
					success  : function(data) {
						console.log("result sendNotifycation: ", data);
					},
					error     :function(e) {					
						console.log(e);
					}
				});
			}	
		}	
	}	
	
	function getNodeJS(type) {
		var bOrder = true;
		$.ajax({
			url      : "/trading/data/getNodeJS.do",
			contentType	:	"application/json; charset=utf-8",
			dataType : "json",
			success  : function(data) {
				//console.log("getNodeJS");
				//console.log(data.nodeJS.noden);
				window.RTS_IP = data.nodeJS.noden;
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
	
	function getCham(type) {
		//console.log("chamCheck 1");
		var param = {
				mvClientID	:	"<%=session.getAttribute("clientID")%>"
			};
		
		$.ajax({
			url      : "/trading/data/chamCheck.do",
			data      : param,
			contentType	:	"application/json; charset=utf-8",
			dataType : "json",
			success  : function(data) {
				//console.log("chamCheck");
				//console.log(data);
				if (data.jsonObj.st == 'N'){
					document.getElementById("champReg").style.display = "block";	
				}
				else if (data.jsonObj.st == 'Y'){
					document.getElementById("champResult").style.display = "block";
				}				
				linkCham = data.jsonObj.infoCham;
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
	
	function getSubAccount() {
		var param = {
				mvClientID	:	"<%=session.getAttribute("clientID")%>"
			};

			$.ajax({
				dataType  : "json",
				cache		: false,
				url       : "/trading/data/getSubAccount.do",
				data      : param,
				success   : function(data) {
					//console.log("Sub Account List");
					//console.log(data);
					$("#ojSubAccount option").remove();
					for (var i = 0; i < data.jsonObj.mainResult.length; i++) {
						$("#ojSubAccount").append("<option value='" + data.jsonObj.mainResult[i].tradingAccSeq + "'>"+ data.jsonObj.mainResult[i].subAccountID +"</option>");
					}
					$("#ojSubAccount").val(<%=session.getAttribute("defaultSubAccount")%>);
					lengOjSubAccount = $('#ojSubAccount').children('option').length;
				},
				error     :function(e) {					
					console.log(e);
				}
			});
	}
	
	function changeSubAccount() {
		var param = {
			mvSubAccountID	: $("#ojSubAccount option:selected").text(),
			mvTradingAccSeq	: $("#ojSubAccount").val()
		};
		
		//console.log(param);

		$.ajax({
			dataType  : "json",
			cache		: false,
			url       : "/trading/data/changeSubAccount.do",
			data      : param,
			success   : function(data) {
				location.reload();
			},
			error     :function(e) {					
				console.log(e);
			}
		});
	}
	
	function champainReg() {
		window.open("http://10.0.116.14:3001/champion-league/?info=" + linkCham);
	}
	
	function champainResult() {
		window.open("http://10.0.116.14:3001/champion-league/?info=" + linkCham);
	}
	
	function changeSubAccount1(sub, accseq) {
		var param = {
			mvSubAccountID	: sub,
			mvTradingAccSeq	: accseq
		};
		
		//console.log(param);

		$.ajax({
			dataType  : "json",
			cache		: false,
			url       : "/trading/data/changeSubAccount.do",
			data      : param,
			success   : function(data) {
				//location.reload(0);
				$("#ojSubAccount").val(accseq);
				$("#tabOrdGrp2").tabs({active : 0});
				try {
					enquiryorder("ALL", "", "", "", sub);
				} catch (e) {
					//console.log("NOT EXCUTE ENQUIRY ORDER");
				}
				
				try {
					var rcod	=	'';
					if($("#tab31").find("span[name='bid_rcod']").html().substring(0,3) != undefined) {
						rcod	=	$("#tab31").find("span[name='bid_rcod']").html().substring(0,3);
					}					
					Ext_SetOrderStock(rcod, sub);
				} catch(e) {
					console.log(e);
				}
				
			},
			error     :function(e) {					
				console.log(e);
			}
		});		
	}
	
	fucn
	 
	function homeNews() {
		var param = {
			  symb  : ""
			, skey  : ""
			, fdat  : ""
			, tdat  : ""
			, word  : ""
			, mark	: "0"
			, lang  : ("<%=langCd%>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/market/data/getMarketNewsTop3List.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				var marketLst	=	data.jsonObj.list;
				if(marketLst != null) {
					var htmlStr	=	"";
					for(var i = 0; i < marketLst.length; i++) {
						var stockNewsLst	=	marketLst[i];
						htmlStr += "<li class=\"group_item news_list\" tabindex='" + (i + 1) + "' style=\"display: " + (htmlStr == "" ? "block" : "none") + ";\">";
						htmlStr += "	<a onclick=\"newsView('"+stockNewsLst.articleId+"');\" style=\"cursor: pointer;font-size:13px;\">" + stockNewsLst.title + "</a>";
						htmlStr += "</li>";
					}
					$("#newsList").html(htmlStr);
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function homeIdx() {
		$.ajax({
			url      : "/home/homeJisu.do",
			dataType : "json",
			success  : function(data){
				//console.log("HOME IDX");
				//console.log(data)				
				var kospiCnt     = 0;
				var dowCnt       = 0;
				var htmlDowStr   = "";
				var htmlKospiStr = "";
				for(var i=0; i < data.homejisu.list1.length; i++) {
					var homejisu = data.homejisu.list1[i];
					var inam     = homejisu.inam;
					var rcod	=	homejisu.rcod;
					if(inam == "VN-INDEX" || inam == "VN30" || inam == "HNX Index" || inam == "UPCOM Index") {
						dowCnt++;
						htmlDowStr += "<div class=\"group_item Dow\" tabindex='" + dowCnt + "' style=\"display: " + (htmlDowStr == "" ? "block" : "none") + ";\">";
						htmlDowStr += "	<h4 onclick=\"marketIndex();\" style=\"cursor: pointer;font-size:13px;\">" + inam + "</h4>";
						htmlDowStr += "	<ul class=\"items\">";
						htmlDowStr += "		<li class=\"item1\"><span id=\"idx_"+rcod+"\" class='" + upDownColor(homejisu.indx) + "'>" + upDownNumZeroList(homejisu.indx) + "</span></li>";
						htmlDowStr += "		<li class=\"item2\"><span id=\"diff_"+rcod+"\" class='" + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "</span></li>";
						htmlDowStr += "		<li class=\"item3\"><span id=\"rate_"+rcod+"\" class='" + upDownColor(homejisu.diff) + "'>" + homejisu.rate + "%</span></li>";
						htmlDowStr += "	</ul>";
						htmlDowStr += "</div>";
					} else {
						kospiCnt++;
						htmlKospiStr += "<div class=\"group_item Kospi\" tabindex='" + kospiCnt + "' style=\"display: " + (htmlKospiStr == "" ? "block" : "none") + ";\">";
						htmlKospiStr += "	<h4 onclick=\"marketIndex();\" style=\"cursor: pointer;font-size:13px;\">" + inam + "</h4>";
						htmlKospiStr += "	<ul class=\"items\">";
						htmlKospiStr += "		<li class=\"item1\"><span id=\"idx_"+rcod+"\" class='" + upDownColor(homejisu.indx) + "'>" + upDownNumZeroList(homejisu.indx) + "</span></li>";
						htmlKospiStr += "		<li class=\"item2\"><span id=\"diff_"+rcod+"\" class='" + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "</span></li>";
						htmlKospiStr += "		<li class=\"item3\"><span id=\"rate_"+rcod+"\" class='" + upDownColor(homejisu.diff) + "'>" + homejisu.rate + "%</span></li>";
						htmlKospiStr += "	</ul>";
						htmlKospiStr += "</div>";
					}
					$("#divKospi").html(htmlKospiStr);
					$("#divDow").html(htmlDowStr);
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function setIdx() {
		$.ajax({
			url      : "/home/homeJisu.do",
			dataType : "json",
			success  : function(data){
				var kospiCnt     = 0;
				var dowCnt       = 0;
				var htmlDowStr   = "";
				var htmlKospiStr = "";
				for(var i=0; i < data.homejisu.list1.length; i++) {
					var homejisu = data.homejisu.list1[i];
					var inam     = homejisu.inam;
					var rcod	=	homejisu.rcod;
					$("#idx_"+rcod).removeClass("up").removeClass("upper").removeClass("low").removeClass("lower").removeClass("same").addClass(upDownColor(homejisu.indx)).html(upDownNumZeroList(homejisu.indx));
					$("#diff_"+rcod).removeClass("up").removeClass("upper").removeClass("low").removeClass("lower").removeClass("same").addClass(upDownColor(homejisu.diff)).html(upDownNumZeroList(homejisu.diff));
					$("#rate_"+rcod).removeClass("up").removeClass("upper").removeClass("low").removeClass("lower").removeClass("same").addClass(upDownColor(homejisu.diff)).html(upDownNumZeroList(homejisu.rate) + "%");
				}
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function logout() {
		location.href="/login/logout.do";
	}

	function changeLan(str) {
		setCookie("LanguageCookie", str, 30);
		if($('div[name=tabs]').length > 0) {
			if("${TAB_INFO}" == "TRD_TAB") {
				$("#tabOrdGrp1 > ul > li").each(function (i){
					if($(this).attr("class") == "ui-state-default ui-corner-top ui-tabs-active ui-state-active") {
						$("#TAB_IDX1").val(i);
					}
				});
				$("#tabOrdGrp2 > ul > li").each(function (i){
					if($(this).attr("class") == "ui-state-default ui-corner-top ui-tabs-active ui-state-active") {
						$("#TAB_IDX2").val(i);
					}
				});
				$("#tabOrdGrp3 > ul > li").each(function (i){
					if($(this).attr("class") == "ui-state-default ui-corner-top ui-tabs-active ui-state-active") {
						$("#TAB_IDX3").val(i);
					}
				});
				$("#tabOrdGrp4 > ul > li").each(function (i){
					if($(this).attr("class") == "ui-state-default ui-corner-top ui-tabs-active ui-state-active") {
						$("#TAB_IDX4").val(i);
					}
				});
			} else {
				$("div[name=tabs] > ul > li").each(function (i){
					if($(this).attr("class") == "ui-state-default ui-corner-top ui-tabs-active ui-state-active") {
						$("#TAB_IDX1").val(i);
					}
				});
			}
		} else {
			$("#TAB_IDX1").val("");
			$("#TAB_IDX2").val("");
			$("#TAB_IDX3").val("");
			$("#TAB_IDX4").val("");
		}

		var param = {
			mvCurrentLanguage : str
			, request_locale  : str
			, TAB_IDX1        : $("#TAB_IDX1").val()
			, TAB_IDX2        : $("#TAB_IDX2").val()
			, TAB_IDX3        : $("#TAB_IDX3").val()
			, TAB_IDX4		  : $("#TAB_IDX4").val()
		};
		$("body").block({message: "<span>LOADING...</span>"});

		$.ajax({
			dataType  : "json",
			cache		: false,
			url       : "/home/changelanguage.do",
			data      : param,
			success   : function(data) {
				$("body").unblock();
				if(data != null) {
					//@TODO : 파이어 폭스에서 작동하지 않음 임시로 reload 로 변경함.
					//history.go(0);			// page Refresh
					location.reload();
				}
			},
			error     :function(e) {
				$("body").unblock();
				console.log(e);
			}
		});
	}

	function moveWTS(mvTab, mvAction) {
		<%
		session.removeAttribute("TAB_IDX1");
		session.removeAttribute("TAB_IDX2");
		session.removeAttribute("TAB_IDX3");
		session.removeAttribute("TAB_IDX4");
		%>
		location.href = mvAction;
	}
	
	var vW;
	function redirectFUT() {				
		if (!vW || vW.closed) {
			vW = window.open('https://fut.masvn.com', '_blank');
		}
	    vW.focus();
	    return false;
	}

	function newsView(seqn) {
		var param = {
			  seqn  : seqn
			, divId : "divNewsViewPop"
		};

		$.ajax({
			type     : "POST",
			url      : "/trading/popup/newsDetail.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divNewsViewPop").fadeIn();
				$("#divNewsViewPop").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}
	
	function marketIndex() {
		var param = {
				divId : "divMarketIndexPop"
		};

		$.ajax({
			type     : "POST",
			url      : "/trading/popup/marketIndex.do",
			data     : param,
			dataType : "html",
			success  : function(data){
				$("#divMarketIndexPop").fadeIn();
				$("#divMarketIndexPop").html(data);
			},
			error     :function(e) {
				console.log(e);
			}
		});
	}

	function prevjisu(tagStr) {
		var prev = "";
		$(tagStr).each(function (){
			if($(this).css("display") == "block") {
				prev = $(this).attr("tabindex");
			}
		});

		if(prev != 1) {
			$(tagStr).each(function (){
				if($(this).attr("tabindex") == (parseInt(prev) - 1)) {
					$(this).css("display", "block");
				} else {
					$(this).css("display", "none");
				}
			});
		} else {
			$(tagStr).each(function (){
				if($(this).attr("tabindex") == $(tagStr).length) {
					$(this).css("display", "block");
				} else {
					$(this).css("display", "none");
				}
			});
		}
	}

	function nextjisu(tagStr) {
		var next = "";
		$(tagStr).each(function (){
			if($(this).css("display") == "block") {
				next = $(this).attr("tabindex");
			}
		});

		if(next < $(tagStr).length) {
			$(tagStr).each(function (){
				if($(this).attr("tabindex") == (parseInt(next) + 1)) {
					$(this).css("display", "block");
				} else {
					$(this).css("display", "none");
				}
			});
		} else {
			$(tagStr).each(function (){
				if($(this).attr("tabindex") == 1) {
					$(this).css("display", "block");
				} else {
					$(this).css("display", "none");
				}
			});
		}
	}
	
	function wtsHome() {
		location.href	=	"/wts/view/trading.do";
	}
	
	function display_c(){
		var refresh=1000; // Refresh rate in milli seconds
		mytime=setTimeout('display_ct()',refresh)
	}

	function display_ct() {
		var strcount
		var d = new Date()
		var datestring;
		if ("<%= langCd %>" == "en_US") {
			datestring = "Trandate " + ("0"+(d.getMonth()+1)).slice(-2) + "/" + ("0" + d.getDate()).slice(-2) + "/" + 
		    d.getFullYear() + " " + ("0" + d.getHours()).slice(-2) + ":" + ("0" + d.getMinutes()).slice(-2) + ":" + ("0" + d.getSeconds()).slice(-2);
		} else {
			datestring = "Ngày GD " + ("0" + d.getDate()).slice(-2) + "/" + ("0"+(d.getMonth()+1)).slice(-2) + "/" +
		    d.getFullYear() + " " + ("0" + d.getHours()).slice(-2) + ":" + ("0" + d.getMinutes()).slice(-2) + ":" + ("0" + d.getSeconds()).slice(-2);
		}
		document.getElementById('displayTime').innerHTML = datestring;
		document.getElementById("currentDate").value =  ("0"+(d.getMonth()+1)).slice(-2) + "/" + ("0" + d.getDate()).slice(-2) + "/" +  d.getFullYear();
	    
		tt=display_c();
		
	} 
	
	function display_view() {
		display_ct();
	}
	
	function getActiveSession() {
		countActiveSession();
		var refresh=30000; // Refresh rate in 30 seconds
		mytime=setTimeout('countActiveSession()',refresh)
	}
	
	function countActiveSession() {
		$.ajax({
			type	  : "GET",
			dataType  : "json",
			url       : "/login/activeSession.do",
			aync      : true,
			success   : function(data) {				
				if(data.trResult != null) {
					document.getElementById('activeSessions').innerHTML = data.trResult.toString();
				}
			},
			error     :function(e) {				
				console.log(e);
			}
		});	
	}
	
	
	function checkSession(){
		$.ajax({
			url:'/ttl/checkSession.do',
			dataType: 'json',
			cache: false,
			success: function(data){
				if(!data.chkSession.success) {		//success flag true is multi login					
					if (data.chkSession.mvResult_2.indexOf("SYSTEM_MAINTENANCE") >= 0) {
						if ("<%=langCd%>" == "en_US") {
							alert("The system auto logout when connection to the server is unstable.");	
						} else {
							alert("Hệ thống tự động đăng xuất khi kết nối không ổn định đến máy chủ.");
						}
					} else if (data.chkSession.mvResult_2.indexOf("MULTI_USERS_LOGIN") >= 0) {
						if ("<%=langCd%>" == "en_US") {
							alert("Your account is loginned by orther device.");	
						} else {
							alert("Tài khoản của bạn được đăng nhập bởi thiết bị khác.");
						}
					}
					location.href="/login/logout.do";
				}
			},
			error:function(e){
				errSessionCnt++;
				//console.log("eeeeeeeeeee"+e)
				if(errSessionCnt > 5) {
						errSessionCnt = 0
						clearInterval(checkSessions);
						//clearInterval(ttmRespone);
						location.href = "/";
					}
				}
			});
	}

	function showCardMatrixPopUp() {
		var param = {};
		$.ajax({
			dataType : "json",
			url : "/trading/data/showCardMatrixPopUp.do",
			data : param,
			success : function(data) {
			},
			error : function(e) {
				console.log(e);
			}
		});
	}

	function intervalJisu() {
		nextjisu(".Kospi");
		nextjisu(".Dow");
	}

	checkSessions = setInterval(checkSession, 7000);
	//index change inter 10 seconds
	indInter = setInterval(intervalJisu, 10000);
	//	TTL Relate END

	function setCookie(cname, cvalue, exdays) {
		var d = new Date();
		d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
		var expires = "expires=" + d.toGMTString();
		document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	}

	function subscribedCallback(data) {
		////console.log("DATA SUBCRIBED CALL BACK");
		//console.log(data);
		var obj = JSON.parse(data);
		//console.log(obj);
		if (obj.status == "TOPIC_HKSFO_ORDER_ENQUIRY") {				
			$("#tabOrdGrp2").tabs({active : 0});
			try {
				if(!getCookieStock('Seq1')){
					//set cookie Seq1
					setCookieStock('Seq1', obj.data.mvDNSeq, 100);
				}else if(!getCookieStock('Seq2')) {
					//set cookie Seq2
					setCookieStock('Seq2', obj.data.mvDNSeq, 100);
				} 
				if(getCookieStock('Seq1') && getCookieStock('Seq2') && (getCookieStock('Seq1') != getCookieStock('Seq2'))){
					sendNotifycation(obj);
					//remove coookie
					setCookieStock('Seq1', '', 100);
					setCookieStock('Seq2', '', 100);
				}
				
				enquiryorder("ALL", "", "", "", sub);
			} catch (e) {
				//console.log("NOT EXCUTE ENQUIRY ORDER");
			}

			var tabId = $("#tabOrdGrp4 ul li[class*=active]").attr("id");
			//console.log("SSSSSSSSSSS ===== " + tabId);
			if (tabId == "buytab") {
				try {
					var rcod	=	'';
					if($("#tab31").find("span[name='bid_rcod']").html().substring(0,3) != undefined) {
						rcod	=	$("#tab31").find("span[name='bid_rcod']").html().substring(0,3);
					}
					//console.log("AAAAAAA === " + rcod);
					Ext_SetOrderStock(rcod);
				} catch (e) {
					console.log(e);
				}
			}
		}
	}
</script>
<decorator:head />
</head>

<body class="flexible">
	<div class="wrapper">
		<input type="hidden" id="TAB_IDX1" name="TAB_IDX1" value=""/>
		<input type="hidden" id="TAB_IDX2" name="TAB_IDX2" value=""/>
		<input type="hidden" id="TAB_IDX3" name="TAB_IDX3" value=""/>
		<input type="hidden" id="TAB_IDX4" name="TAB_IDX4" value=""/>
		<!-- header -->
		<header>
			<div class="container">
				<h1>
				<img src="/resources/images/logo.png" alt="MIRAE ASSET WTS" onclick="wtsHome();" style="cursor:pointer;">
				</h1>
				<div class="right">
					<div class="side">
						<div class="buttons">
							<button type="button" onclick="javascript:logout();"><%=(langCd.equals("en_US") ? "Logout" : "Đăng xuất")%></button>
							<span class="language">
							<button type="button" onclick="changeLan('en_US');"<%= (langCd.equals("en_US") ? " class=\"on\"" : "") %>>
									<img src="/resources/images/icon_lang_en.gif" alt="English">
								</button>
							<button type="button" onclick="changeLan('vi_VN');"<%= (langCd.equals("en_US") ? "" : " class=\"on\"") %>>
									<img src="/resources/images/icon_lang_vi.gif" alt="vietnamese">
								</button>
							</span>
						</div>

						<div class="buttons">
							<button style="color: #f08200;" type="button" onclick="redirectFUT()"><%=(langCd.equals("en_US") ? "DERIVATIES" : "PHÁI SINH")%></button>
						</div>
						<!-- <div class="text">
							<select style="margin-top:-3px;color:blue;font-weight:600;" id="ojSubAccount" onchange="changeSubAccount();"></select>
							<span id="displayTime"></span><input id="currentDate" type="hidden"/>
						</div> -->

						<div class="wtsJisu">
							<div class="wrap_ticker">
								<div>
									<h3 class="screen_out">주요지수 (국내/해외)</h3>
									<div class="group_index">
										<!-- KOSPI -->
										<div class="index_area">
										<button style="float: left;margin-right: 5px;width: 27px;height: 20px;background: none;" class="btn" type="button" onclick="marketIndex()">
										<img src="/resources/HOME/images/add.png" />
										</button>
										<div id="divKospi" class="group_wrap">
										</div>									
										</div>
										<!-- //KOSPI -->
									</div>
								</div>
							</div>
						</div>
						<div class="wtsJisu">
							<div class="wrap_ticker">
								<div>
									<h3 class="screen_out">주요지수 (국내/해외)</h3>
									<div class="group_index">
										<!-- DOW -->
										<div class="index_area">
										<button style="float: left;margin-right: 5px;width: 27px;height: 20px;background: none;" class="btn" type="button" onclick="marketIndex()">
										<img src="/resources/HOME/images/add.png" />
										</button>
										<div id="divDow" class="group_wrap">
										</div>
										<!-- //DOW -->
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="text">
							<select style="margin-top: 1px;color: blue;font-weight: 800;height: 30px;width: auto;" id="ojSubAccount" onchange="changeSubAccount();">
							<span id="displayTime"></span><input id="currentDate" type="hidden"/>
						</div>
						
						<div class="text">
							<button	style="float: left; margin-right: 5px; width: 27px; height: 20px; background: none; display: none;" id="champReg" class="btn" type="button" onclick="champainReg()">
									<img src="/resources/HOME/images/add.png" />
							</button>
						</div>
						
						<div class="text">
							<button	style="float: left; margin-right: 5px; width: 27px; height: 20px; background: none; display: none;" id="champResult" class="btn" type="button" onclick="champainResult()">
									<img src="/resources/HOME/images/add.png" />
							</button>
						</div>
				</div>
			</div>

			<!-- gnb -->
			<div class="gnb">
				<ul class="wts_menu">
					<li id="TRD_TAB" class="wide">
						<button type="button" onclick="moveWTS('TRD_TAB', 'trading.do')"><%=(langCd.equals("en_US") ? "TRADING" : "GIAO DỊCH")%></button>
					</li>
					<li id="PTF_TAB">
						<button type="button" onclick="moveWTS('PTF_TAB', 'portfolio.do')"><%=(langCd.equals("en_US") ? "PORTFOLIO" : "DANH MỤC ĐẦU TƯ")%></button>
					</li>
					<li id="ONS_TAB" class="wide">
						<button type="button" onclick="moveWTS('ONS_TAB', 'online.do')"><%=(langCd.equals("en_US") ? "ONLINE SERVICES" : "DỊCH VỤ TRỰC TUYẾN")%></button>
					</li>
					<li id="CHT_TAB">
						<button type="button" onclick="moveWTS('CHT_TAB', 'chart.do')"><%=(langCd.equals("en_US") ? "CHART" : "BIỂU ĐỒ")%></button>
					</li>
					<li id="BNK_TAB">
						<button type="button" onclick="moveWTS('BNK_TAB', 'banking.do')"><%=(langCd.equals("en_US") ? "CASH / STOCK SERVICES" : "D.VỤ CHUYỂN TIỀN / CHỨNG KHOÁN")%></button>
					</li>
					<li id="MSL_TAB" class="wide">
						<button type="button" onclick="moveWTS('MSL_TAB', 'margin.do')"><%=(langCd.equals("en_US") ? "MARGIN STOCK LIST" : "DANH MỤC CK KÝ QUỸ")%></button>
					</li>
					<li id="ACC_TAB" class="wide">
						<button type="button" onclick="moveWTS('ACC_TAB', 'account.do')"><%=(langCd.equals("en_US") ? "ACCOUNT MANAGEMENT" : "QUẢN LÝ TÀI KHOẢN")%></button>
					</li>
				</ul>
			</div>
		<!-- //gnb --> </header>
		<!-- //header -->

		<!-- news Detail pop -->
		<div id="divNewsViewPop" class="modal_wrap"></div>
		<!-- news Detail pop -->

		<!-- Market Index pop -->
		<div id="divMarketIndexPop" class="modal_wrap"></div>
		<!-- Market Index pop -->

		<!-- 템플릿 사용부분 -->
		<!-- content -->
		<decorator:body></decorator:body>
		<!-- //템플릿 사용부분 -->

		<div class="footer">
			<div class="cb">
				<div class="news" style="display: none;">
					<ul id="newsList" class="group_wrap"></ul>
					<div class="move_area">
						<!-- e: 이미지를 텍스트로 교체 -->
						<button type="button" id="newsPrev" onclick="prevjisu('.news_list')" class="btn_prev" style="width: 15px;height: 15px;">prev</button>
						<button type="button" id="newsNext" onclick="nextjisu('.news_list')" class="btn_next" style="width: 15px;height: 15px;">next</button>
						<!-- // e: 이미지를 텍스트로 교체 -->
					</div>
				</div>
				<div class="copy"><%= (langCd.equals("en_US") ? "© Mirae Asset Securities (Vietnam) LLC" : "© Công ty Trách nhiệm Hữu hạn Chứng khoán Mirae Asset (Việt Nam)") %></div>				
			</div>
		</div>

		<div id="" class="noticePopup">
			<div class="noticeMessage">
	 		</div>
		</div>

	</div>
	<script>
		(function() {
			function setInitEvt() {
				$(".group_table").each(function() {
					var table = $(this).find("table"),
						tbody = table.find("tbody");

							if (!tbody.find("th").length) {
								tbody.find("tr:odd").addClass("even");
							}

							if (table.height() >= $(this).parent().height()) {
								table.addClass("no_bbt");
							}
						});
			}
			setInitEvt();

			$("div[name=tabs]").tabs();
			$("#tabOrdGrp2").tabs("destroy");

			window.showFullLoading = function() {
				$(".loading_cover").show();
			}
			window.hideFullLoading = function() {
				$(".loading_cover").hide();
			}
		}())
	</script>
</body>
</html>
