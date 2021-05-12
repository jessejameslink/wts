<%@ page contentType = "text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/HOME/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/HOME/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/HOME/jquery/jquery.slides.min.js"></script>
<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
<script type="text/javascript" src="/resources/HOME/js/mireaasset.js?600"></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>

<script type="text/javascript" src="/resources/js/nexClient.js"></script>
<script type="text/javascript" src="/resources/js/socket.io.js"></script>


<script src="/resources/js/pdfobject.min.js"></script>

<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
<title>MIRAE ASSET VN</title>
<!--
<style>
.pdfobject-container {
    width: 100%;
    max-width: 100%;
    height: 800px;
    margin: 2em 0;
}

.pdfobject { border: solid 1px #666; }
</style>
 -->

<script>
  var isMobile = {
      Android: function() {
          return navigator.userAgent.match(/Android/i);
      },
      BlackBerry: function() {
          return navigator.userAgent.match(/BlackBerry/i);
      },
      iOS: function() {
          return navigator.userAgent.match(/iPhone|iPad|iPod/i);
      },
      Opera: function() {
          return navigator.userAgent.match(/Opera Mini/i);
      },
      Windows: function() {
          return navigator.userAgent.match(/IEMobile/i);
      },
      any: function() {
          return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
      }
     };
  if( isMobile.any() ) window.location.href = "http://m.masvn.com:8080/mobile";
  if( isMobile.Android() ) window.location.href = "http://m.masvn.com:8080/mobile";
  if( isMobile.BlackBerry() ) window.location.href = "http://m.masvn.com:8080/mobile";
  if( isMobile.Opera() ) window.location.href = "http://m.masvn.com:8080/mobile";
  if( isMobile.Windows() ) window.location.href = "http://m.masvn.com:8080/mobile";
  if( isMobile.iOS() ) window.location.href = "http://m.masvn.com:8080/mobile";
  
 	var currentUrl = window.location.href;
	var idx = currentUrl.indexOf("http://wts.masvn.com");
	var idx1 = currentUrl.indexOf("wts.masvn.com");
	var idx2 = currentUrl.indexOf("https://wts.masvn.com");
	if (idx >= 0 || idx1 >= 0 || idx2 >= 0) {
		window.location.href = "https://wts.masvn.com/wts/view/trading.do";		
	}

</script>

<script>
	function downloadFile(nkind) {
		$("body").block({message: "<span>LOADING...</span>"});
		location.href="/downloadFile.do?ids=" + nkind;
		$("body").unblock();
	}
</script>

<script>
$(document).ready(function() {
	$("body").attr("class", ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "L_EN" : "L_VI"));
	getMarketNewsList();
	getResearchTopList();
	getMiraeAssetNews();
	homeJisu();
	//mainSlid();
	setInterval(homeJisu, 15000);	
	setInterval(getMarketNewsList, 120000);
	
	
	var rollingHeight	=	$("#mainImg > div").height();
	var width			=	$("#mainImg > div").width();
	$('#mainImg').slidesjs({
		width : width,			//가로
		height : 300,	//세로
		play: {
		  active: false,			//이전,다음 버튼 생성(true & false)
		  auto: true,			//자동start(true & false)
		  effect: "fade",		//효과(slide & false)
		  interval: 6000,		//다음걸로 넘어가는 시간
		  swap: false,			//플레이,정지버튼 생성(true	& false)
		  pauseOnHover: true,	//마우스올라갔을때 정지(true & false)
		  restartDelay: 1000	//비활성후 다시 시작시간
		},pagination: { 		//동그라미 아이콘, 페이지
		  active: true			//아이콘버튼생성(true & false)
		  ,effect: "fade"		//효과(slide & fade)
		},
		effect: {
		  fade: {				//페이드되는 속도
			speed: 1000,
			crossfade: true
		  }
		}
	});
	
	var rollingHeight02	=	$("#divJisu > dl").height();
	var width02			=	$("#divJisu > dl").width();

	$('#divJisu').slidesjs({
		width : width02,			//가로
		height : 300,	//세로
		play: {
		  active: false,			//이전,다음 버튼 생성(true & false)
		  auto: true,			//자동start(true & false)
		  effect: "slide",		//효과(slide & false)
		  interval: 3000,		//다음걸로 넘어가는 시간
		  swap: false,			//플레이,정지버튼 생성(true	& false)
		  pauseOnHover: true,	//마우스올라갔을때 정지(true & false)
		  restartDelay: 1000	//비활성후 다시 시작시간
		},pagination: { 		//동그라미 아이콘, 페이지
		  active: true			//아이콘버튼생성(true & false)
		  ,effect: "slide"		//효과(slide & fade)
		},
		effect: {
		  fade: {				//페이드되는 속도
			speed: 1000,
			crossfade: true
		  }
		}
	}).removeAttr("style");
});


function pdfReading(type, ids){
	if(type == "newWin"){
		/*$("#pdfIds").val(ids);
		$("#pdfScreen").val('research');

		$("#frmPDFIds").attr("target", "pdfV");
		$("#frmPDFIds").submit();*/
		window.open("/pdfViewer.do?screen=research&ids=" + ids, "_blank");
	} else if(type == "layerPop"){
//		var options = {
//			    pdfOpenParams: {
//			        navpanes: 1,
//			        toolbar: 1,
//			        statusbar: 1,
//			        view: "FitV",
//			        pagemode: "thumbs",
//			        page: 1
//			    },
//			    forcePDFJS: true,
//			    PDFJS_URL: "/resources/pdfjs-1.6.210-dist/web/viewer.html"
//			};

//		PDFObject.embed("/researchDown2.do?ids=" + ids, "#pdf", options);

//		$("#divLayerPopContainer").css({top: "auto", bottom: "25px"});
//		$("#divLayerPop").css({height: $(document).height()}).show();

//		$("html").css("overflow-y", "hidden");

//	//	$('html').on('scroll touchmove mousewheel', function(e) {
//	//		e.preventDefault();
//	//		e.stopPropagation();
//	//		return false;
//	//	});

//		$('#divLayerPopContainer').each(function(){
//			this.scrollIntoView(true);
//		});
	}
}

function unlockScroll(){
// 	$('html').off('scroll touchmove mousewheel');
	$("html").css("overflow-y", "visible");
}

function homeJisu() {
	$.ajax({
		url      : "/home/homeJisu.do",
		dataType : "json",
		success  : function(data){
			if(data.homejisu.list1 != null) {
				for(var i=0; i < data.homejisu.list1.length; i++) {
					var homejisu = data.homejisu.list1[i];
					var rcod     = homejisu.rcod;
					if(rcod == "VN-INDEX") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pHOSE' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdHOSE").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "VN30") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pVN30' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdVN30").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "HNXIndex") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pHNX' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdHNX").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "HNXUpcomIndex") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pUPCOM' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdUPCOM").attr("class", upDownColor(homejisu.indx) + " r_line").html(htmlStr);
					} else if(rcod == "DJI") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pDOW' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdDOW").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "GSPC") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pSNP' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdSNP").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "IXIC") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pNAS' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdNAS").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "KS11") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pKOS' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdKOS").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "HSI") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pHAN' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdHAN").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} else if(rcod == "N225") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pNIK' class='arrow " + upDownColor(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdNIK").attr("class", upDownColor(homejisu.indx)).html(htmlStr);
					} 
				}
			}
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function getMarketNewsList() {
	var param = {
		  symb  : ""
		, skey  : ""
		, fdat  : ""
		, tdat  : ""
		, word  : ""
		, mark	: "0"
		, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
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
					htmlStr += "<li>";
					htmlStr += "	<a onclick=\"miraeView('"+stockNewsLst.articleId+"');\" style=\"cursor: pointer; height: 63px;\">";
					if (stockNewsLst.headImage != null && stockNewsLst.headImage != "") {
						var temp = stockNewsLst.headImage.replace("http://", "https://").replace(/ /g,'%20');
						htmlStr += "		<img src=" + temp +" style=\"float: left; padding-top: 10px; padding-right: 10px;\" border=\"0\" width=\"83\" height=\"63\">"; // Date
					}
					htmlStr += "		<span>" + stockNewsLst.createDate + "</span>"; // Date
					htmlStr += "		<p>" + stockNewsLst.title + "</p>"; // Title
					htmlStr += "	</a>";
					htmlStr += "</li>";
				}
				$("#newsList").html(htmlStr);
			}
			
			
			/*
			if(data.stockNewsList != null) {
				if(data.stockNewsList.list1 != null) {
					var htmlStr = "";
					for(var i=0; i < 3; i++) {
						var stockNewsList = data.stockNewsList.list1[i];
						htmlStr += "<li>";
						htmlStr += "	<a onclick=\"miraeView('"+stockNewsList.seqn+"');\" style=\"cursor: pointer;\">";
						htmlStr += "		<span>" + stockNewsList.date + "</span>"; // Date
						htmlStr += "		<p>" + stockNewsList.titl + "</p>"; // Title
						htmlStr += "	</a>";
						htmlStr += "</li>";
					}
					$("#newsList").html(htmlStr);
				}
			}
			*/
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function miraeView(seqn) {
	var param = {
		  seqn  : seqn
		, divId : "divMarketViewPop"
	};

	$.ajax({
		type     : "POST",
		url      : "/newsAndEvents/popup/marketView.do",
		data     : param,
		dataType : "html",
		success  : function(data){
			$("#divMarketViewPop").fadeIn();
			$("#divMarketViewPop").html(data);
			$("#divMarketViewPop").css({height: $(document).height()}).show();
			$('body').addClass('nscroll');
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function miraeAssetView(sid) {
	var param = {
		  sid  : sid
		, divId : "divMarketViewPop"
	};

	$.ajax({
		type     : "POST",
		url      : "/newsAndEvents/popup/miraeView.do",
		data     : param,
		dataType : "html",
		success  : function(data){
			$("#divMarketViewPop").fadeIn();
			$("#divMarketViewPop").html(data);
			$("#divMarketViewPop").css({height: $(document).height()}).show();
			$('body').addClass('nscroll');
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function getResearchTopList(){
	var param = {
			nType : 1,
			lang  : "<%= session.getAttribute("LanguageCookie") %>"
		};

	$.ajax({
		dataType  : "json",
		url       : "/getResearchTopList.do",
		data     : param,
		success   : function(data) {
			var researchListStr = "";
			if(data.jsonObj != null){
				researchListStr += "";
				for(var i=0; i < data.jsonObj.list.length; i++){
					researchListStr += "	<li>";
					researchListStr += "		<a class=\"layer_link\" href=\"/pdfViewer.do?screen=research&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('newWin', '" + data.jsonObj.list[i].id + "');return false;\">";
					researchListStr += "		<p>" + data.jsonObj.list[i].code + "</p>";
					researchListStr += "		<span>" + data.jsonObj.list[i].created + "</span>";
					researchListStr += "		</a>";
					researchListStr += "		<a class=\"new_link\" title=\"Read Detail\" href=\"/pdfViewer.do?screen=research&ids=" + data.jsonObj.list[i].id + "\" onclick=\"pdfReading('newWin', '" + data.jsonObj.list[i].id + "');return false;\">read detail</a>"
					researchListStr += "	</li>";
				}
			}
			// 리스트 세팅
	 		$("#researchTopList").html(researchListStr);
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function getMiraeAssetNews() {
	var param = {
			lang  : "<%= session.getAttribute("LanguageCookie") %>"
		};
	
	$.ajax({
		dataType  : "json",
		url       : "/getMiraeAssetNews.do",
		data     : param,
		success   : function(data) {
			var miraeAssetNewsStr = "";
			if(data.jsonObj != null){
				miraeAssetNewsStr += "";
				for(var i=0; i < data.jsonObj.list.length; i++){
					miraeAssetNewsStr += "	<li>";
					miraeAssetNewsStr += "	<a onclick=\"miraeAssetView('"+data.jsonObj.list[i].id+"');\" style=\"cursor: pointer;\">";
					miraeAssetNewsStr += "		<p>" + data.jsonObj.list[i].title + "</p>"; // Title
					miraeAssetNewsStr += "		<span>" + data.jsonObj.list[i].created + "</span></a>"; // Date
					miraeAssetNewsStr += "	</li>";
				}
			}
			// 리스트 세팅
	 		$("#miraeAssetNews").html(miraeAssetNewsStr);
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function researchFileDown(id){
	location.href="/researchDown2.do?ids=" + id;
}
</script>

</head>

<%@include file="/US/home/include/home_header.jsp"%>
<body>
<%--
<form id="frmPDFIds" action="/pdfViewer.do" method="post">
	<input type="hidden" id="pdfIds" name="pdfIds" value="" />
	<input type="hidden" id="pdfScreen" name="pdfScreen" value="" />
</form>
 --%>
<!--container-->
<div id="container">
    <!-- main image -->
     
    <div id="mainImg">
    	<% if(langCd.equals("en_US")) { %>
        	<a href="https://www.masvn.com/home/support/mobileinstall.do" class="main_img_01_en">
		        
		    </a>
		    
		    <a href="https://www.masvn.com/home/support/mobileinstall.do" class="main_img_02_en">
		        
		    </a>
		     
		    <a href="https://www.masvn.com/home/support/mobileinstall.do" class="main_img_03_en">
		        
		    </a>
	    <% } else { %>
	    	<a href="https://www.masvn.com/home/newsAndEvents/mirae_view.do?lang=vi&sid=32CC710F-7254-411E-A544-9EF1E9094B28" class="main_img_01">
		        
		    </a>
		    
		    <a href="https://www.masvn.com/home/newsAndEvents/mirae_view.do?lang=vi&sid=32CC710F-7254-411E-A544-9EF1E9094B28" class="main_img_02">
		        
		    </a>
		     
		    <a href="https://www.masvn.com/home/newsAndEvents/mirae_view.do?lang=vi&sid=32CC710F-7254-411E-A544-9EF1E9094B28" class="main_img_03">
		        
		    </a>
	    <% } %>
	    
    </div>
    <!-- main image -->

    <!--dashboard-->
    <div class="dashboard">
		<div class="get_wrap">
			<ul>
				<li class="get1"><a href="#open_account" class="open_layer"><%= (langCd.equals("en_US") ? "Open An Account" : "Mở tài khoản") %></a></li>
                <%-- 
                <li class="get2"><a href="/wts/view/trading.do" target="_blank"><%= (langCd.equals("en_US") ? "Web trading" : "Giao dịch trực tuyến") %></a></li>
                 --%>
                <li class="get2"><a href="https://mi-trade.masvn.com/login.action" class="" target="_blank"><%= (langCd.equals("en_US") ? "Web trading" : "Giao dịch trực tuyến") %></a></li>
                <li class="get3"><a href="/home/support/mobile.do"><%= (langCd.equals("en_US") ? "Mobile trading" : "Giao dịch qua điện thoại") %></a></li>
                <li class="get4"><a href="http://price.masvn.com/hsx.html" target="_blank">HSX</a></li>
                <li class="get5"><a href="http://price.masvn.com/hnx.html" target="_blank">HNX</a></li>
                <li class="get6"><a href="http://price.masvn.com/upcom.html" target="_blank">UPCOM</a></li>
            </ul>
        </div>
        <!--왼쪽 WRAP-->
        <!--MARKET NEWS-->
        <div class="marketNews">
            <h2><%= (langCd.equals("en_US") ? "Market News" : "Tin thị trường") %></h2>
             <ul id="newsList" class="news_list add">
            </ul>
            <a href="javascript:marketGo('/home/newsAndEvents/market.do');" class="read_more top">+</a>
        </div>
        <!--MARKET NEWS /-->
        <div  class="marketIndex">
        	<h2><%= (langCd.equals("en_US") ? "Market Index" : "Chỉ số index") %></h2>
        	<!-- <div class="page_top"><a class="page01" href="javascript:overTAB(1);"></a><a class="page02" href="javascript:overTAB(2);"></a><a class="page03" href="javascript:overTAB(3);"></a></div> -->
        	<div id="divJisu" class="data add">
        	<!-- 
        		<dl id="jisu01">
        			<dt>HOSE-INDEX</dt>
        			<dd id="tdHOSE" class="same">0.00<p id="pHOSE" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>HNX-INDEX</dt>
        			<dd id="tdHNX" class="same">0.00<p id="pHNX" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>UPCOM-INDEX</dt>
        			<dd id="tdUPCOM" class="same">0.00<p id="pUPCOM" class="arrow same">0.000(0.00%)</p></dd>
        		</dl>
        		<dl id="jisu02">
        			<dt>DOW</dt>
        			<dd id="tdDOW" class="same">0.00<p id="pDOW" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>S&P500</dt>
        			<dd id="tdSNP" class="same">0.00<p id="pSNP" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>NASDAQ</dt>
        			<dd id="tdNAS" class="same">0.00<p id="pNAS" class="arrow same">0.000(0.00%)</p></dd>
        		</dl>
        		<dl id="jisu03">
        			<dt>KOSPI</dt>
        			<dd id="tdKOS" class="same">0.00<p id="pKOS" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>Hang Seng</dt>
        			<dd id="tdHAN" class="same">0.00<p id="pHAN" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>Nikkei225</dt>
        			<dd id="tdNIK" class="same">0.00<p id="pNIK" class="arrow same">0.000(0.00%)</p></dd>
        		</dl>
        	 -->
        	 	<dl id="jisu01">
        			<dt>HOSE-INDEX</dt>
        			<dd id="tdHOSE" class="">&nbsp;<p id="pHOSE" class="">Loading..</p></dd>
        			<dt>HNX-INDEX</dt>
        			<dd id="tdHNX" class="">&nbsp;<p id="pHNX" class="">Loading..</p></dd>
        			<dt>UPCOM-INDEX</dt>
        			<dd id="tdUPCOM" class="">&nbsp;<p id="pUPCOM" class="">Loading..</p></dd>
        		</dl>
        		<dl id="jisu02">
        			<dt>DOW</dt>
        			<dd id="tdDOW" class="">&nbsp;<p id="pDOW" class="">Loading..</p></dd>
        			<dt>S&P500</dt>
        			<dd id="tdSNP" class="">&nbsp;<p id="pSNP" class="">Loading..</p></dd>
        			<dt>NASDAQ</dt>
        			<dd id="tdNAS" class="">&nbsp;<p id="pNAS" class="">Loading..</p></dd>
        		</dl>
        		<dl id="jisu03">
        			<dt>KOSPI</dt>
        			<dd id="tdKOS" class="">&nbsp;<p id="pKOS" class="">Loading..</p></dd>
        			<dt>Hang Seng</dt>
        			<dd id="tdHAN" class="">&nbsp;<p id="pHAN" class="">Loading..</p></dd>
        			<dt>Nikkei225</dt>
        			<dd id="tdNIK" class="">&nbsp;<p id="pNIK" class="">Loading..</p></dd>
        		</dl>
            </div>
            
            <!-- backup
            	<div id="divJisu" class="data">
        		<dl id="jisu01">
        			<dt>HOSE-INDEX</dt>
        			<dd id="tdHOSE" class="same">0.00<p id="pHOSE" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>VN-INDEX</dt>
        			<dd id="tdVN30" class="same">0.00<p id="pVN30" class="arrow same">0.000(0.00%)</p></dd>
        		</dl>
        		<dl id="jisu02">
        			<dt>HNX-INDEX</dt>
        			<dd id="tdHNX" class="same">0.00<p id="pHNX" class="arrow same">0.000(0.00%)</p></dd>
        			<dt>UPCOM-INDEX</dt>
        			<dd id="tdUPCOM" class="same">0.00<p id="pUPCOM" class="arrow same">0.000(0.00%)</p></dd>
        		</dl>
        		<div class="page"><a class="page01" href="javascript:overTAB(1);"></a><a class="page02" href="javascript:overTAB(2);"></a></div>
            </div>
             -->
        </div>
        <!--왼쪽 WRAP /-->
        <!--News Event-->
		<div class="news_event">
			<% if(langCd.equals("en_US")) { %>			
			<a href="https://wts.masvn.com" target="_blank"><img src="/resources/HOME/images/events_en.png" />
			</a>
			<% } else { %>
			<a href="https://wts.masvn.com" target="_blank"><img src="/resources/HOME/images/events.png" />
			</a>
			<% } %>
		</div>
        <!--SUPPORT-->
        <div class="support">
        	<h2><%= (langCd.equals("en_US") ? "Support" : "Hỗ trợ") %></h2>
            <div class="links">
            	<a href="/home/support/account.do"><%= (langCd.equals("en_US") ? "Open cash account in ACB" : "Mở tài khoản tiền tại ngân hàng ACB") %></a>
                <a href="/home/support/marginGuideline.do"><%= (langCd.equals("en_US") ? "Margin trading" : "Giao dịch ký quỹ") %></a>
                <a href="/home/support/securities.do"><%= (langCd.equals("en_US") ? "Securities trading regulation" : "Quy định giao dịch chứng khoán") %></a>
            </div>
        </div>
    </div>
    <!-- // .dashboard -->

    <div class="main_banner">
        <div class="">
            <div class="">
            	<a href="/home/support/mobile.do?link=3">
                <img src="/resources/HOME/images/main_banner1.jpg" alt="TRADING GUIDE Solution for a busy life MASVn trading means that every order is executed in real-time and that news, analysis and upgrades are instantly available to you" />
                </a>
            </div>
        </div>
    </div>
     <!-- 
    <div class="main_banner">
        <div class="main_banner_wrap">
            <div class="main_banner_item">
                <img src="/resources/HOME/images/main_banner1.jpg" alt="TRADING GUIDE Solution for a busy life MASVn trading means that every order is executed in real-time and that news, analysis and upgrades are instantly available to you" />
            </div>
            <div class="main_banner_item">
                <img src="/resources/HOME/images/main_banner2.jpg" alt="Trading easy and speed with WTS& MTS" />
            </div>
            <div class="main_banner_item">
                <img src="/resources/HOME/images/main_banner3.jpg" alt="low Cost for Trading and Margin" />
            </div>
        </div>
    </div>
  -->
    <!-- main_contents -->
    <div class="main_contents">
        <div class="reports">
            <!--GLOBAL NETWORK-->
            <div class="global">
                <h2><%= (langCd.equals("en_US") ? "Global Network" : "Mạng lưới toàn cầu") %></h2>
                <ul class="links">
                    <li class="link_au">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAsia01.do"><%= (langCd.equals("en_US") ? "Australia<span>Go!</span>" : "Úc<span>Go!</span>") %></a>
                    </li>
                    <li class="link_ch">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAsia02.do"><%= (langCd.equals("en_US") ? "China<span>Go!</span>" : "Trung Quốc<span>Go!</span>") %></a>
                    </li>
                    <li class="link_ho">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAsia03.do"><%= (langCd.equals("en_US") ? "Hong Kong<span>Go!</span>" : "Hồng Kông<span>Go!</span>") %></a>
                    </li>
                    <li class="link_in">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAsia04.do"><%= (langCd.equals("en_US") ? "India<span>Go!</span>" : "Ấn Độ<span>Go!</span>") %></a>
                    </li>
                    <li class="link_ko">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAsia05.do"><%= (langCd.equals("en_US") ? "Korea<span>Go!</span>" : "Hàn Quốc<span>Go!") %></a>
                    </li>
                    <li class="link_ta">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAsia06.do"><%= (langCd.equals("en_US") ? "Taiwan<span>Go!</span>" : "Đài Loan<span>Go!</span>") %></a>
                    </li>
                    <li class="link_vi">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAsia07.do"><%= (langCd.equals("en_US") ? "Vietnam<span>Go!</span>" : "Việt Nam<span>Go!</span>") %></a>
                    </li>
                    <li class="link_br">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAmerica01.do"><%= (langCd.equals("en_US") ? "Brazil<span>Go!</span>" : "Brazil<span>Go!</span>") %></a>
                    </li>
                    <li class="link_ca">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAmerica02.do"><%= (langCd.equals("en_US") ? "Canada<span>Go!</span>" : "Cananda<span>Go!</span>") %></a>
                    </li>
                    <li class="link_co">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAmerica03.do"><%= (langCd.equals("en_US") ? "Colombia<span>Go!</span>" : "Colombia<span>Go!</span>") %></a>
                    </li>
                    <li class="link_us">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalAmerica04.do"><%= (langCd.equals("en_US") ? "USA<span>Go!</span>" : "Mỹ<span>Go!</span>") %></a>
                    </li>
                    <li class="link_uk">
                        <i class="dot"></i>
                        <a href="/home/globalNetwork/globalEu01.do"><%= (langCd.equals("en_US") ? "United Kingdom<span>Go!</span>" : "Vương quốc Anh<span>Go!</span>") %></a>
                    </li>
                    
                    
                    
                    <!-- 2017/02/27 추가 -->
                    <li class="link_in">
                        <i class="dot"></i>
                        <a href="#"><%= (langCd.equals("en_US") ? "Indonesia<span>Go!</span>" : "Indonesia<span>Go!</span>") %></a>
                    </li>
                    <li class="link_mo">
                        <i class="dot"></i>
                        <a href="#"><%= (langCd.equals("en_US") ? "Mongolia<span>Go!</span>" : "Mongolia<span>Go!</span>") %></a>
                    </li>
                    <li class="link_sing">
                        <i class="dot"></i>
                        <a href="#"><%= (langCd.equals("en_US") ? "Singapore<span>Go!</span>" : "Singapore<span>Go!</span>") %></a>
                    </li>
                    <li class="link_la">
                        <i class="dot"></i>
                        <a href="#"><%= (langCd.equals("en_US") ? "USA LA <span>Go!</span>" : "USA LA<span>Go!</span>") %></a>
                    </li>
                </ul>
                <!--  
                <h3><%= (langCd.equals("en_US") ? "The Globe" : "Toàn cầu") %></h3>
                -->
                </br>
                </br>
                </br>
                <p><%= (langCd.equals("en_US") ? "We are a global organization with an on-the-ground presence in the markets in which we invest. Explore the regions of our different office locations to view what we may offer to our clients." : "Mirae Asset vinh dự là một tổ chức toàn cầu với sự hiện diện tại hầu hết các thị trường mà chúng tôi tham gia đầu tư. Cùng khám phá các khu vực có sự hiện diện các văn phòng của chúng tôi để trải nghiệm những sản phẩm, dịch vụ mà chúng tôi cung cấp cho các khách hàng của mình.") %></p>
            </div>
        </div>

        <div class="news">
        	<!--RESEARCH REPORT-->
            <div class="research">
                <h2><%= (langCd.equals("en_US") ? "Mirae Asset News" : "Tin Mirae Asset") %></h2>
                <ul class="research_list" id="miraeAssetNews">
                </ul>
                <a href="/home/newsAndEvents/mirae.do" class="read_more"><%= (langCd.equals("en_US") ? "Read More" : "Xem Thêm") %></a>
            </div>
            <!--MIRAE ASSET DAEWOO NEWS-->
            <div class="mirae_news">
                <h2><%= (langCd.equals("en_US") ? "Research Report" : "Báo cáo phân tích") %></h2>
                <ul id="researchTopList">
                </ul>
                <a href="/home/subpage/research.do" class="read_more"><%= (langCd.equals("en_US") ? "Read More" : "Xem Thêm") %></a>
            </div>
        </div>
    </div>
    <!-- // .main_contents -->
</div>
<!--container/-->

<div id="open_account" class="layer_pop">
    <div class="layer_pop_container">
        <h2 class="cont_title"><%= (langCd.equals("en_US") ? "Open an account" : "Mở tài khoản") %></h2>
        <h3 class="cont_subtitle"><%= (langCd.equals("en_US") ? "GUIDELINE TO OPEN SECURITIES TRADING ACCOUNTS" : "HƯỚNG DẪN HỒ SƠ MỞ TÀI KHOẢN GIAO DỊCH CHỨNG KHOÁN") %></h3>

        <div class="tab_container">
            <div class="tab">
                <div>
                    <a href="#dom_indi" class="on"><%= (langCd.equals("en_US") ? "Customers are<br />domestic individuals" : "Khách hàng cá<br />nhân trong nước") %></a>
                    <a href="#fore_indi"><%= (langCd.equals("en_US") ? "Customers are<br />foreign individuals" : "Khách hàng cá<br />nhân nước ngoài") %></a>
                    <a href="#dom_inst"><%= (langCd.equals("en_US") ? "Customers are<br />domestic institutions" : "Khách hàng tổ<br />chức trong nước") %></a>
                    <a href="#fore_inst"><%= (langCd.equals("en_US") ? "Customers are<br />foreign institutions" : "Khách hàng tổ<br />chức nước ngoài") %></a>
                </div>
            </div>

            <div class="tab_conts">
                <div id="dom_indi" class="on">
                <% if(langCd.equals("en_US")) { %>
                    <table class="table_style_01">
                        <caption>Customers are domestic individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Dossiers for<br />domestic individual</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Account opening request (1 copy);
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li>
                                         <li>A copy of ID card (not exceeding 15 years);</li>
                                         <li>A letter of attorney must be certified by the notary / state agencies in accordance with the law and a copy of ID of the authorized person (if any);</li>
                                         <li>Agreement on using securities transaction utilities (if any) (2 copies).</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% } else { %>
                    <table class="table_style_01">
                        <caption>Customers are domestic individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Hồ sơ mở tài khoản cho Khách hàng cá nhân trong nước bao gồm</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
                                        </li>
                                        <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
                                        </li>
                                        <li>Bản sao CMND (1 bản, không quá 15 năm)</li>
                                        <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND của người được ủy quyền (nếu có) (1 bản)</li>
                                        <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% }%>
                </div>
                <!-- // #dons_indi -->

                <div id="fore_indi">
                <% if(langCd.equals("en_US")) { %>
                    <h3 class="sec_title">I. <span class="em">Open securities trading account at the Company.</span> Dossiers include :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Customers haven’t got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Account opening request (1 copy);
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                         </li>
                                         <li>A notarized copy of passport;</li>
                                         <li>A letter of attorney must be certified by the notary/ state agencies and a copy of identity card or passport of the authorized person (if any);</li>
                                         <li>Agreement on using securities transaction utilities (if any) (2 copies)</li>
                                         <li>Application for securities trading code (1 copy).</li>
                                         <li>A power of attorney to the Company to apply for trading code;</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Notes</em>
                                        <p>* Files and documents specified are in foreign language, they must be translated into Vietnamese and certified translations of contents by the Vietnamese public notary (Except for documents in English or English translation version which has been notarized, authenticated in accordance with foreign law).</p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Customers already got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Account opening request (1 copy);
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                        </li>
                                        <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Download</a>
                                        </li>
                                        <li>A notarized copy of passport;</li>
                                        <li>A letter of attorney must be certified by the notary/ state agencies and a copy of identity card or passport of the authorized person (if any);</li>
                                        <li>Agreement on using securities transaction utilities (if any) (2 copies);</li>
                                        <li>A copy of securities trading code certificate.</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">In case Customer closed account at the old depository member, submit more :</p>
                                        <p>* Request for closing account at the old depository member (1 copy);</p>
                                        <p>* Request for some changes of foreign investor (1 copy);</p>
                                        <p>* A power of attorney for depository member to change information;</p>
                                    </div>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Open indirect investment capital account at ACB bank (for non-residence foreign customers) :</span> Please refer procedure at menu SUPPORT</h3>
                <% } else { %>
                    <h3 class="sec_title">I. <span class="em">Mở tài khoản giao dịch chứng khoán tại Công ty.</span> Hồ sơ bao gồm :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign individuals : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Khách hàng chưa có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
                                         </li>
                                         <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
                                         </li>
                                         <li>Bản sao công chứng hộ chiếu (1 bản)</li>
                                         <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND hoặc hộ chiếu của người được ủy quyền (nếu có) (1 bản)</li>
                                         <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                         <li>Giấy đăng ký mã số giao dịch (1 bản)</li>
                                         <li>Giấy ủy quyền cho Công ty thực hiện đăng ký mã số giao dịch</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Ghi chú</em>
                                        <p>* Ngoại trừ tài liệu bằng tiếng Anh hoặc bản dịch tiếng Anh đã được công chứng hoặc chứng thực theo pháp luật nước ngoài, tài liệu bằng các tiếng nước ngoài khác phải được dịch ra tiếng Việt bởi tổ chức dịch thuật hoạt động hợp pháp tại Việt Nam</p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Khách hàng đã có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
                                        </li>
                                        <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(6);return false;">Tải về</a>
                                        </li>
                                        <li>Bản sao công chứng hộ chiếu (1 bản)</li>
                                        <li>Giấy ủy quyền có xác nhận của chính quyền địa phương hoặc công chứng theo quy định của pháp luật và bản sao CMND hoặc hộ chiếu của người được ủy quyền (nếu có) (1 bản)</li>
                                        <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                        <li>Bản sao Giấy chứng nhận đăng ký mã số giao dịch chứng khoán (1 bản)</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">Trường hợp tất toán tài khoản tại thành viên lưu ký cũ: cần nộp thêm:</p>
                                        <p>* Giấy đề nghị tất toán tài khoản tại thành viên lưu ký cũ (1 bản)</p>
                                        <p>* Báo cáo về một số thay đổi của nhà đầu tư nước ngoài (1 bản)</p>
                                        <p>* Giấy ủy quyền cho Công ty báo cáo các thay đổi có liên quan (1 bản)</p>
                                    </div>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Mở tài khoản vốn đầu tư gián tiếp tại Ngân hàng ACB (đối với khách hàng nước ngoài không cư trú): </span> Tham khảo thủ tục tại mục HỖ TRỢ</h3>
                <% }%>
                </div>
                <!-- // #fore_indi -->

                <div id="dom_inst">
                <% if(langCd.equals("en_US")) { %>
                    <table class="table_style_01">
                        <caption>Customers are domestic institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Dossiers for<br />domestic institution</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Account opening request (1 copy);
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(7);return false;">Download</a>
                                         </li>
                                         <li>A notarized copy of Establishment Decision or Business Registration Certificate;</li>
                                         <li>A notarized copy of Appointing Decision for General Director / Director, Chief Accountant (if any);</li>
                                         <li>A copy of ID card or passport of the representative, the authorized person (if any);</li>
                                         <li>Agreement on using securities transaction utilities (if any) (2 copies)</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% } else { %>
                    <table class="table_style_01">
                        <caption>Customers are domestic institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Hồ sơ mở tài khoản cho Khách hàng tổ chức trong nước bao gồm</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
                                         </li>
                                         <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(7);return false;">Tải về</a>
                                         </li>
                                         <li>Bản sao công chứng quyết định thành lập hoặc giấy chứng nhận đăng ký kinh doanh (1 bản);</li>
                                         <li>Bản sao công chứng Quyết định bổ nhiệm Tổng giám đốc / Giám đốc, Kế toán trưởng (nếu có);</li>
                                         <li>Bản sao CMND hoặc hộ chiếu của người đại diện, người được ủy quyền (nếu có) (1 bản);</li>
                                         <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                <% }%>
                </div>
                <!-- // #dom_inst -->

                <div id="fore_inst">
                <% if(langCd.equals("en_US")) { %>
                    <h3 class="sec_title">I. <span class="em">Open securities trading account at the Company.</span> Dossiers include :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Customers haven’t got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Account opening request (1 copy);
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                         </li>
                                         <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(7);return false;">Download</a>
                                         </li>
                                         <li>A valid copy of the Establishment Decision or Business Registration Certificate or equivalent document issued by the competent administrative body of the country of domicile which ensures the completion of business registration; License for Establishment of the organization and its branch in Vietnam (for branches of foreign institution locating in Vietnam); or Tax Registration from the national tax authority of the country of domicile, or Other documents as guided by Vietnam Securities Depository ;</li>
                                         <li>An appointment letter of the legal representative;</li>
                                         <li>A notarized copy of passport of the legal representative;</li>
                                         <li>Agreement on using securities transaction utilities (if any) (2 copies);</li>
                                         <li>Application for securities trading code made by foreign investors (1 copy);</li>
                                         <li>A power of attorney to the Company to apply for trading code;</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Notes</em>
                                        <p>* The files are made in two (02) sets, one (01) original and one (01) copy.</p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Customers already got securities trading code</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Account opening request (1 copy);
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Download</a>
                                        </li>
                                        <li>
                                            Contract for securities account opening (2 copies);
                                            <a href="#" class="btn_attach" onclick="downloadFile(7);return false;">Download</a>
                                        </li>
                                        <li>A notarized copy of license for establishment and operation or the certificate of business registration;</li>
                                        <li>A copy of passport of the legal representative;</li>
                                        <li>A power of attorney  and 01 copy of passport of authorized person (if any);</li>
                                        <li>Agreement on using securities transaction utilities (if any) (2 copies);</li>
                                        <li>A copy of certificate of securities trading code.</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">In case Customer closed account at the old depository member, submit more :</p>
                                        <p>* Request for closing account at the old depository member (1 copy);</p>
                                        <p>* Request for some changes of foreign investor (1 copy);</p>
                                        <p>* A power of attorney for depository member to change information;</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Open indirect investment capital account at ACB bank (for non-residence foreign customers) :</span> Please refer procedure at menu SUPPORT</h3>
                <% } else { %>
                    <h3 class="sec_title">I. <span class="em">Mở tài khoản giao dịch chứng khoán tại Công ty.</span> Hồ sơ bao gồm :</h3>
                    <table class="table_style_01">
                        <caption>Customers are foreign institutions : table</caption>
                        <colgroup>
                            <col width="25%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Khách hàng chưa có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                         <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
                                         </li>
                                         <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(7);return false;">Tải về</a>
                                         </li>
                                         <li>Bản sao hợp lệ giấy phép thành lập và hoạt động hoặc giấy chứng nhận đăng ký kinh doanh hoặc tài liệu tương đương do cơ quan quản lý có thẩm quyền nước ngoài cấp, xác nhận đã hoàn tất việc đăng ký kinh doanh; giấy phép thành lập tổ chức và chi nhánh tại Việt Nam (đối với chi nhánh của tổ chức nước ngoài tại Việt Nam); hoặc Giấy đăng ký thuế của cơ quan thuế nước nơi tổ chức đó thành lập hoặc đăng ký kinh doanh hoặc Tài liệu khác theo hướng dẫn của TTLKCK;</li>
                                         <li>Giấy chỉ định người đại diện theo pháp luật;</li>
                                         <li>Bản sao hộ chiếu của người đại diện theo pháp luật (1 bản).</li>
                                         <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                         <li>Giấy đăng ký mã số giao dịch chứng khoán (1 bản);</li>
                                         <li>Giấy ủy quyền cho Công ty thực hiện đăng ký mã số giao dịch</li>
                                    </ul>

                                    <div class="support_note">
                                        <em>Lưu ý</em>
                                        <p>* Hồ sơ được lập thành hai (02) bộ: một (01) bộ gốc và một (01) bộ sao. </p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Khách hàng đã có mã số giao dịch chứng khoán</th>
                                <td>
                                    <ul class="data_list type_02">
                                        <li>
                                            Giấy đề nghị mở tài khoản giao dịch chứng khoán (1 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(5);return false;">Tải về</a>
                                        </li>
                                        <li>
                                            Hợp đồng mở tài khoản giao dịch chứng khoán (2 bản)
                                            <a href="#" class="btn_attach" onclick="downloadFile(7);return false;">Tải về</a>
                                        </li>
                                        <li>Bản sao công chứng Giấy phép thành lập và hoạt động hoặc Giấy chứng nhận đăng ký kinh doanh</li>
                                        <li>Bản sao hộ chiếu của người đại diện theo pháp luật (1 bản)</li>
                                        <li>Giấy ủy quyền và bản sao Hộ chiếu của người được ủy quyền (nếu có) (1 bản).</li>
                                        <li>Thỏa thuận sử dụng tiện ích giao dịch chứng khoán (nếu có) (2 bản)</li>
                                        <li>Bản sao Giấy chứng nhận đăng ký mã số giao dịch chứng khoán (1 bản)</li>
                                    </ul>

                                    <div class="support_note">
                                        <p class="title">Trường hợp tất toán tài khoản tại thành viên lưu ký cũ: cần nộp thêm</p>
                                        <p>* Giấy đề nghị tất toán tài khoản tại thành viên lưu ký cũ (1 bản);</p>
                                        <p>* Báo cáo về một số thay đổi của nhà đầu tư nước ngoài (1 bản);</p>
                                        <p>* Giấy ủy quyền cho Công ty báo cáo các thay đổi có liên quan (1 bản)</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="sec_title">II. <span class="em">Mở tài khoản vốn đầu tư gián tiếp tại một ngân hàng lưu ký hoặc tại ngân hàng ACB (đối với khách hàng nước ngoài không cư trú) :</span> Tham khảo thủ tục tại mục HỖ TRỢ</h3>
                <% }%>
                </div>
                <!-- // #fore_inst -->
            </div>
        </div>

        <button type="button" class="btn_close_pop">close layerpopup</button>
    </div>
</div>
<!-- // .layer_pop -->

<div id="divMarketViewPop" class="layer_pop">
</div>

<!-- pdf Viewer -->
<div id="divLayerPop" class="layer_pop">
	<div id="divLayerPopContainer" class="layer_pop_container">
	  	<div id="pdf"></div>
	  	<button type="button" class="btn_close_pop" onclick="unlockScroll();">close layerpopup</button>
  	</div>
</div>

<%@include file="/US/home/include/home_footer.jsp"%>

<script>
$(".page01").addClass("active");
$("#jisu01").css({"position":"absolute" , "left":"0px"});
$("#jisu02").css({"position":"absolute" , "left":"310px"});
$("#jisu03").css({"position":"absolute" , "left":"620px"});

var tab_num = 0;
function overTAB(no) {
	tab_num = no;
	if(no == 1) {
		$("#jisu01").animate({"left":"0px"},"fast");
		$("#jisu02").animate({"left":"310px"},"fast");
		$("#jisu03").animate({"left":"620px"},"fast");
		$(".page01").addClass("active");
		$(".page02").removeClass("active");
		$(".page03").removeClass("active");
	}
	if(no == 2) {
		$("#jisu01").animate({"left":"-310px"},"fast");
		$("#jisu02").animate({"left":"0px"},"fast");
		$("#jisu03").animate({"left":"310px"},"fast");
		$(".page02").addClass("active");
		$(".page01").removeClass("active");
		$(".page03").removeClass("active");
	}
	if(no == 3) {
		$("#jisu01").animate({"left":"-620px"},"fast");
		$("#jisu02").animate({"left":"-310px"},"fast");
		$("#jisu03").animate({"left":"0px"},"fast");
		$(".page03").addClass("active");
		$(".page02").removeClass("active");
		$(".page01").removeClass("active");
	}
}

</script>

</body>
</html>