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
var isSelectedTab;
var cookie = function() { 
	checkCookie();
}
cookie();
$(document).ready(function() {
	// Check if the current URL contains '#'
	if (location.protocol !== 'https:') {
    	location.replace(`https:${location.href.substring(location.protocol.length)}`);
	}
    if(document.URL.indexOf("#")==-1)
    {
        // Set the URL to whatever it was plus "#".
        url = document.URL+"#";
        location = "#";

        //Reload the page
         location.reload(true);
    }	  
	
	$("body").attr("class", ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "L_EN" : "L_VI"));
	
	//main upgrade version 6
	upgradeVersion6();
	
	//getMarketNewsList();
	getResearchTopList();
	getSectorTopList();
	getMiraeAssetNews();
	homeJisu();
	//mainSlid();
	setInterval(homeJisu, 15000);	
	//setInterval(getMarketNewsList, 120000);
	setInterval(getSelectedTabData, 120000);
	
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
	
	//show default selected tabs
	document.getElementById("defaultSelected").click();
	
	//video control
	$(document).on('click', '#video-id', function (e) {
	    var video = $(this).get(0);
	    if (video.paused === false) {
	        video.pause();
	    } else {
	        //video.play();
	    }

	    return false;
	});
	
	//showPopupVersion6();
});

function upgradeVersion6(){
	var mess = "";
	var mess1 = "";
	if ("<%= langCd %>" == "en_US") {
		mess1 = 'Please come back after';
		mess = '<h3 style = "color: blue"> MAS is pleased to announce the official launch of an upgraded version of the securities trading system from May 1 2020. <br> </h3> <h3 style = "color: blue"> <br> <br> Dear Customer, please sign the related contract annex before the above time, through The following channels: <br> </h3> <p style = "color: red"> <br><br><br><br><br><br><br><br><br>+ Directly from the MAS office <br> </p> <p style = "color: red"> <br> + Contact a brokers specialist </p> <p style = "color: blue" > <br> Sincerely thank you. <br> </p>';
	} else {
		mess1 = 'Xin vui long tro lai sao';
		mess = '<h3 style="color:blue">MAS trân trọng thông báo chính thức đưa vào vận hành hệ thống giao dịch chứng khoán phiên bản nâng cấp từ ngày 11/May/2020.<br></h3><h3 style="color:blue"><br><br>Kính đề nghị Quý Khách hàng vui lòng thực hiện ký phụ lục hợp đồng liên quan trước thời gian nêu trên, thông qua các kênh sau:<br></h3><p style="color:red"><br><br><br><br><br><br><br><br><br>+ Đến trực tiếp văn phòng MAS<br></p><p style="color:red"><br>+ Liên hệ chuyên viên môi giới phục vụ<br></p><p style="color:blue"><br>Trân trọng cảm ơn.<br></p>';
	}
		$.blockUI({ 
            message: $('#displayBox'), 
            css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 600) /2 + 'px', 
                width: '600px',
                heigth:'400px'               
            },
          	message: '<img src="https://www.masvn.com/docs/image/1-OTP.jpg" width="200px" height="400px">',
			//message: mess,
    		//timeout:   10000 
	
    	}); 
		$('.blockOverlay').attr('title', mess1 ).click($.unblockUI);
}

function showPopupVersion6() {
	var mess = "";
	var mess1 = "";
	if ("<%= langCd %>" == "en_US") {
		mess1 = 'Click to continue';
		mess = '<h3 style = "color: blue"> MAS is pleased to announce the official launch of an upgraded version of the securities trading system, which changes the margin trading service from March 23 2020. <br> </h3> <h3 style = "color: blue"> <br> <br> Dear Customer, please sign the related contract annex before the above time, through The following channels: <br> </h3> <p style = "color: red"> <br><br><br><br><br><br><br><br><br>+ Directly from the MAS office <br> </p> <p style = "color: red"> <br> + Contact a brokers specialist </p> <p style = "color: blue" > <br> Sincerely thank you. <br> </p>';
	} else {
		mess1 = 'Nhấn vào đây để tiếp tục';
		mess = '<h3 style="color:blue">MAS trân trọng thông báo chính thức đưa vào vận hành hệ thống giao dịch chứng khoán phiên bản nâng cấp có thay đổi về dịch vụ giao dịch ký quỹ từ ngày 23/03/2020.<br></h3><h3 style="color:blue"><br><br>Kính đề nghị Quý Khách hàng vui lòng thực hiện ký phụ lục hợp đồng liên quan trước thời gian nêu trên, thông qua các kênh sau:<br></h3><p style="color:red"><br><br><br><br><br><br><br><br><br>+ Đến trực tiếp văn phòng MAS<br></p><p style="color:red"><br>+ Liên hệ chuyên viên môi giới phục vụ<br></p><p style="color:blue"><br>Trân trọng cảm ơn.<br></p>';
	}
		$.blockUI({ 
            message: $('#displayBox'), 
            css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 600) /2 + 'px', 
                width: '600px',
                heigth:'400px'               
            },
          	message: '<img src="https://www.masvn.com/docs/image/1-OTP.jpg" width="200px" height="400px">',
			//message: mess,
    		//timeout:   10000 
	
    	}); 
		$('.blockOverlay').attr('title', mess1 ).click($.unblockUI);	
}
function AAAAAA() {
	
}


function tabSelected(evt, tabName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
    isSelectedTab = tabName;
    getSelectedTabData();
}

function getSelectedTabData() {
	if (isSelectedTab == "Volume") {
    	getTopVolume();
    } else if (isSelectedTab == "Up") {
    	getTopUp5Days();
    } else if (isSelectedTab == "Down") {
    	getTopDown5Days();
    } else if (isSelectedTab == "High") {
    	getTopHigh5Days();
    } else if (isSelectedTab == "Low") {
    	getTopLow5Days();
    }
}

function getTopVolume() {
	//alert("Vol");
	$("#grdVolume").find("tr").remove();
	var param = {
			  fymd  : ""
			, tymd  : ""
			, mark  : "ALL"
			, updn  : ""
			, skey  : ""
		};

		$.ajax({
			url      : "/trading/data/getSectorList.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.sectorList != null) {
					if(data.sectorList.list1 != null) {
						if (data.sectorList.list1.length == 0) {
							return;
						}
						var htmlStr = "";
						for(var i=0; i < 7; i++) {
							var sectorList = data.sectorList.list1[i];
							var cssColor  = displayColorHomeIndex(sectorList.diff.substring(0, 1));
							var cssArrow  = displayArrowHomeIndex(sectorList.diff.substring(0, 1));
							htmlStr += "<tr onclick=\"viewStockInfoDetail('" + sectorList.symb + "');\" style=\"cursor: pointer;\">";
							htmlStr += "	<td class=\"text_left c_code\">" + sectorList.symb + "</td>";                       // Stock
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(sectorList.curr.substring(1))+ "</td>"; // Current							
							htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(sectorList.diff.substring(1)) + "</td>"; // +/-
							htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(sectorList.rate.substring(1)) + "</td>"; // %Change
							htmlStr += "	<td>" + numIntFormat(sectorList.avol) + "</td>"; // Volume
							htmlStr += "</tr>";
							
						}
						$("#grdVolume").append(htmlStr);
					}	
				}				
			},
			error     :function(e) {
				console.log(e);
			}
		});
}

function getTopUp5Days() {
	//alert("Up");
	$("#grdUp").find("tr").remove();
	var d 	= 	new Date();
	var fd	=	new Date();	
	fd.setDate(fd.getDate() - 5);
	var dmonth;
	var fdmonth;
	var dday;
	var fdday;
	
	if (d.getDate() < 10) {
		dday = "0" + d.getDate();
	} else {
		dday = d.getDate();
	}
	
	if (fd.getDate() < 10) {
		fdday = "0" + fd.getDate();
	} else {
		fdday = fd.getDate();
	}
	
	if (d.getMonth() + 1 < 10) {
		dmonth = "0" + (d.getMonth() + 1);
	} else {
		dmonth = (d.getMonth() + 1);
	}
	
	if (fd.getMonth() + 1 < 10) {
		fdmonth = "0" + (fd.getMonth() + 1);
	} else {
		fdmonth = (fd.getMonth() + 1);
	}
	var param = {
			  fymd  : fdday + "/" + fdmonth + "/" + fd.getFullYear()
			, tymd  : dday + "/" + dmonth + "/" + d.getFullYear()
			, mark  : "0"
			, updn  : "0"
			, skey  : ""
		};
		
	$.ajax({
		url      : "/trading/data/getRankingList.do",
		data     : param,
		dataType : "json",
		success  : function(data){
			if(data.rankingList != null) {
				if(data.rankingList.list1 != null) {
					if (data.rankingList.list1.length == 0) {
						return;
					}
					var htmlStr = "";
					for(var i=0; i < 7; i++) {
						var rankingList = data.rankingList.list1[i];
						var cssColor  = displayColorHomeIndex(rankingList.diff.substring(0, 1));
						var cssArrow  = displayArrowHomeIndex(rankingList.diff.substring(0, 1));
						htmlStr += "<tr onclick=\"viewStockInfoDetail('" + rankingList.symb + "');\" style=\"cursor: pointer;\">";
						htmlStr += "	<td class=\"text_left c_code\">" + rankingList.symb + "</td>";                       // Stock
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(rankingList.curr.substring(1)) + "</td>"; // Current						
						htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(rankingList.diff.substring(1)) + "</td>"; // +/-
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(rankingList.rate.substring(1)) + "</td>"; // %Change
						var ratioColor	=	upDownColorIndex(rankingList.advr);
						htmlStr += "	<td class='" + ratioColor + "'>" + upDownNumList(rankingList.advr) + "</td>"; // Advanced Ratio														
						
						htmlStr += "</tr>";
					}
					$("#grdUp").append(htmlStr);
				}
			}
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function getTopDown5Days() {
	//alert("Down");
	$("#grdDown").find("tr").remove();
	var d 	= 	new Date();
	var fd	=	new Date();	
	fd.setDate(fd.getDate() - 5);
	var dmonth;
	var fdmonth;
	var dday;
	var fdday;
	
	if (d.getDate() < 10) {
		dday = "0" + d.getDate();
	} else {
		dday = d.getDate();
	}
	
	if (fd.getDate() < 10) {
		fdday = "0" + fd.getDate();
	} else {
		fdday = fd.getDate();
	}
	if (d.getMonth() + 1 < 10) {
		dmonth = "0" + (d.getMonth() + 1);
	} else {
		dmonth = (d.getMonth() + 1);
	}
	
	if (fd.getMonth() + 1 < 10) {
		fdmonth = "0" + (fd.getMonth() + 1);
	} else {
		fdmonth = (fd.getMonth() + 1);
	}
	var param = {
			  fymd  : fdday + "/" + fdmonth + "/" + fd.getFullYear()
			, tymd  : dday + "/" + dmonth + "/" + d.getFullYear()
			, mark  : "0"
			, updn  : "1"
			, skey  : ""
		};
		
	$.ajax({
		url      : "/trading/data/getRankingList.do",
		data     : param,
		dataType : "json",
		success  : function(data){
			if(data.rankingList != null) {
				if(data.rankingList.list1 != null) {
					if (data.rankingList.list1.length == 0) {
						return;
					}
					var htmlStr = "";					
					for(var i=0; i < 7; i++) {
						var rankingList = data.rankingList.list1[i];
						var cssColor  = displayColorHomeIndex(rankingList.diff.substring(0, 1));
						var cssArrow  = displayArrowHomeIndex(rankingList.diff.substring(0, 1));
						htmlStr += "<tr onclick=\"viewStockInfoDetail('" + rankingList.symb + "');\" style=\"cursor: pointer;\">";
						htmlStr += "	<td class=\"text_left c_code\">" + rankingList.symb + "</td>";                       // Stock
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(rankingList.curr.substring(1)) + "</td>"; // Current						
						htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(rankingList.diff.substring(1)) + "</td>"; // +/-
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(rankingList.rate.substring(1)) + "</td>"; // %Change
						var ratioColor	=	upDownColorIndex(rankingList.advr);
						htmlStr += "	<td class='" + ratioColor + "'>" + upDownNumList(rankingList.advr) + "</td>"; // Advanced Ratio
						htmlStr += "</tr>";
					}
					$("#grdDown").append(htmlStr);
				}
			}
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function getTopHigh5Days() {
	//alert("High");
	$("#grdHigh").find("tr").remove();
	var param = {			  		
			  mark  : "0"
			, high  : "0"
			, days  : "0"
			, skey  : ""
		};
		
	$.ajax({
		url      : "/trading/data/getHighLowList.do",
		data     : param,
		dataType : "json",
		success  : function(data){
			if(data.highlowList != null) {
				if(data.highlowList.list1 != null) {
					if (data.highlowList.list1.length == 0) {
						return;
					}
					var htmlStr = "";
					for(var i=0; i < 7; i++) {
						var highlowList = data.highlowList.list1[i];
						var cssColor  = displayColorHomeIndex(highlowList.diff.substring(0, 1));
						var cssArrow  = displayArrowHomeIndex(highlowList.diff.substring(0, 1));
						htmlStr += "<tr onclick=\"viewStockInfoDetail('" + highlowList.symb + "');\" style=\"cursor: pointer;\">";
						htmlStr += "	<td class=\"text_left c_code\">" + highlowList.symb + "</td>";                       // Stock
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(highlowList.curr.substring(1)) + "</td>"; // Current							
						htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(highlowList.diff.substring(1)) + "</td>"; // +/-
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(highlowList.rate.substring(1)) + "</td>"; // %Change							
						htmlStr += "	<td>" + upDownNumList(highlowList.high) + "</td>"; // High
						htmlStr += "</tr>";
					}
					$("#grdHigh").append(htmlStr);
				}
			}
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function getTopLow5Days() {
	//alert("Low");
	$("#grdLow").find("tr").remove();
	var param = {			  		
			  mark  : "0"
			, high  : "1"
			, days  : "0"
			, skey  : ""
		};
		
	$.ajax({
		url      : "/trading/data/getHighLowList.do",
		data     : param,
		dataType : "json",
		success  : function(data){
			if(data.highlowList != null) {
				if(data.highlowList.list1 != null) {
					if (data.highlowList.list1.length == 0) {
						return;
					}
					var htmlStr = "";
					for(var i=0; i < 7; i++) {
						var highlowList = data.highlowList.list1[i];
						var cssColor  = displayColorHomeIndex(highlowList.diff.substring(0, 1));
						var cssArrow  = displayArrowHomeIndex(highlowList.diff.substring(0, 1));
						htmlStr += "<tr onclick=\"viewStockInfoDetail('" + highlowList.symb + "');\" style=\"cursor: pointer;\">";
						htmlStr += "	<td class=\"text_left c_code\">" + highlowList.symb + "</td>";                       // Stock
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(highlowList.curr.substring(1)) + "</td>"; // Current							
						htmlStr += "	<td class='" + cssArrow + cssColor + "'>" + upDownNumList(highlowList.diff.substring(1)) + "</td>"; // +/-
						htmlStr += "	<td class='" + cssColor + "'>" + upDownNumList(highlowList.rate.substring(1)) + "</td>"; // %Change							
						htmlStr += "	<td>" + upDownNumList(highlowList.high) + "</td>"; // High
						htmlStr += "</tr>";
					}
					$("#grdLow").append(htmlStr);
				}
			}
		},
		error     :function(e) {
			console.log(e);
		}
	});
}

function displayColorHomeIndex(a) {
	switch (a) {
		case "1":
			return "upper";
		case "2":
			return "upIndex";
		case "3":
			return "sameIndex";
		case "4":
			return "lower"
		case "5":
			return "lowIndex"
		default :
			return ""
	}
}

function displayArrowHomeIndex(a) {
	switch (a) {
	case "1":
		return "arrowI upper ";
	case "2":
		return "arrowI upIndex ";
	case "3":
		//return "arrow same ";
		return "sameIndex ";
	case "4":
		return "arrowI lower "
	case "5":
		return "arrowI lowIndex "
	default :
		return ""
	}
}

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
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pHOSE' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdHOSE").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "VN30") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pVN30' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdVN30").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "HNXIndex") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pHNX' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdHNX").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "HNXUpcomIndex") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pUPCOM' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdUPCOM").attr("class", upDownColorIndex(homejisu.indx) + " r_line").html(htmlStr);
					} else if(rcod == "DJI") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pDOW' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdDOW").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "GSPC") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pSNP' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdSNP").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "IXIC") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pNAS' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdNAS").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "KS11") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pKOS' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdKOS").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "HSI") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pHAN' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdHAN").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
					} else if(rcod == "N225") {
						var htmlStr = upDownNumZeroList(homejisu.indx) + "<p id='pNIK' class='arrowI " + upDownColorIndex(homejisu.diff) + "'>" + upDownNumZeroList(homejisu.diff) + "(" + homejisu.rate + "%)</p>";
						$("#tdNIK").attr("class", upDownColorIndex(homejisu.indx)).html(htmlStr);
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
					htmlStr += "	<a onclick=\"miraeView('"+stockNewsLst.articleId+"');\" style=\"cursor: pointer;\">";
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
	console.log("newsAndEvents pop up");
	$.ajax({
		type     : "POST",
		url      : "/newsAndEvents/popup/miraeView.do",
		data     : param,
		dataType : "html",
		success  : function(data){
			console.log(data);
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
			nType : 0,
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

function getSectorTopList(){
	var param = {
			nType : 2,
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
					researchListStr += "	</li>";
				}
			}
			// 리스트 세팅
	 		$("#sectorTopList").html(researchListStr);
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
			console.log(data);
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

function viewStockInfoDetail(stock) {
    var vW;
    switch ("<%= session.getAttribute("LanguageCookie") %>") {
        case "vi_VN":
            vW = window.open('http://data.masvn.com/vi/Stock/' + stock, '_blank');
            break;
        case "en_US":
            vW = window.open('http://data.masvn.com/en/Stock/' + stock, '_blank');
            break;
        default:
            vW = window.open('http://data.masvn.com/vi/Stock/' + stock, '_blank');
            break;
    }
    vW.focus();
    return false;
}

function gotoFullVideo() {
	var vW;
    vW = window.open('https://www.masvn.com/docs/video/Ban_tin_tai_chinh_20180109.mp4', '_blank');            
    vW.focus();
    return false;
}

function setCookie(cname,cvalue,exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

function checkCookie() {
    var lang = getCookie("LanguageCookie");
    if (lang != "") {
    } else {
    	lang = "vi_VN";               
    }
    setCookie("LanguageCookie", lang, 30);        
    
    var param = {
    		mvCurrentLanguage	:	lang
    	};
    
    console.log(param);
	
   	$.ajax({
   		dataType  : "json",
   		url       : "/home/setLanguageCookie.do",
   		data      : param,
   		cache	  : false,
   		success   : function(data) {
   			//console.log(data);   			
   		},
   		error     :function(e) {
   			console.log(e);
   		}
   	});   	
}

function clearSpecial() {
	//Change URL
	var currentUrl = window.location.href;
	var idx = currentUrl.indexOf("#");
	if (idx >= 0) {
		newUrl = currentUrl.substring(0, idx);
		window.history.replaceState("", "", newUrl);	
	}
}
</script>

</head>

<%@include file="/US/home/include/home_header.jsp"%>
<body onload="clearSpecial();">
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
        	<!--  
        	<a href="https://masvn.com/home/derivaties/feetable.do"class="main_img_02_en"></a>
        	<a class="main_img_04_en"></a>
        	<a class="main_img_01_en"></a>        			    		    		   
		    <a href="https://www.masvn.com/home/support/mobileinstall.do" class="main_img_03_en"></a>		    
		    -->
		    
		    <a href="https://masvn.com/home/newsAndEvents/mirae_view.do?lang=vi&sid=A0013C37-A8ED-4A33-B50B-39071688A24D" target="_blank" class="main_img_01_en"></a>
		    
		    <a href="https://masvn.com/home/productsAndServices/ofIntroduction.do" target="_blank" class="main_img_02_en"></a>
		    <a href="https://masvn.com/home/derivaties/feetable.do" class="main_img_03_en"></a>
	    <% } else { %>
	    	<!--  
	    	<a href="https://masvn.com/home/derivaties/feetable.do" class="main_img_02"></a>
	    	<a class="main_img_04"></a>
	    	<a class="main_img_01"></a>
		    <a href="https://www.masvn.com/home/support/mobileinstall.do" class="main_img_03"></a>
		    -->
		    <a href="https://masvn.com/home/newsAndEvents/mirae_view.do?lang=vi&sid=A0013C37-A8ED-4A33-B50B-39071688A24D" target="_blank" class="main_img_01"></a>
		    
		    <a href="https://masvn.com/home/productsAndServices/ofIntroduction.do" target="_blank" class="main_img_02"></a>
		    <a href="https://masvn.com/home/derivaties/feetable.do" class="main_img_03"></a>
	    <% } %>
	    
    </div>
    <!-- main image -->

    <!--dashboard-->
    <div class="dashboard">
		<div class="get_wrap_left">
			<ul>
						 
				<% if(langCd.equals("en_US")) { %>				
					<li class="stock_trading_en"><a href="https://wts.masvn.com" target="_blank"></a></li>
       				<li class="deri_trading_en"><a href="https://fut.masvn.com" target="_blank"></a></li>
       				<li class="price_board_en"><a href="http://price.masvn.com/hsx.html" target="_blank"></a></li>
					<li class="hotline_en"><a href="/home/subpage/contact.do"></a></li>
       			<% } else { %>
					<li class="stock_trading_vn"><a href="https://wts.masvn.com" target="_blank"></a></li>
       				<li class="deri_trading_vn"><a href="https://fut.masvn.com" target="_blank"></a></li>
       				<li class="price_board_vn"><a href="http://price.masvn.com/hsx.html" target="_blank"></a></li>
					<li class="hotline_vn"><a href="/home/subpage/contact.do"></a></li>
				<% } %>			
            </ul>
        </div>
        <!--  
        <div class="get_wrap_right">
        	<div class="upside">
        		<ul>
	                <li class="get1"><a href="http://price.masvn.com/hsx.html" target="_blank"></a></li>
	                <li class="get2"><a href="http://price.masvn.com/hnx.html" target="_blank"></a></li>
	                <li class="get3"><a href="http://price.masvn.com/upcom.html" target="_blank"></a></li>
	                <% if(langCd.equals("en_US")) { %>
	                <li class="get4_en"><a href="http://price.masvn.com/stockder.html" target="_blank"></a></li>
	                <% } else { %>
	                <li class="get4"><a href="http://price.masvn.com/stockder.html" target="_blank"></a></li>
	                <% } %>
	            </ul>
        	</div>
        	<div class="downside">
        		<ul>
        			<% if(langCd.equals("en_US")) { %>
        			<li class="get1_en"><a href="https://wts.masvn.com" target="_blank"></a></li>
        			<% } else { %>
	                <li class="get1"><a href="https://wts.masvn.com" target="_blank"></a></li>
	                <% } %>
	                <li class="get2"><a href="/home/subpage/contact.do"></a></li>
	            </ul>
        	</div>        	
        </div>
        -->
        <!--왼쪽 WRAP-->
        <!--MIRAE ASSET DAEWOO NEWS-->
        <div class="research">
            <h2><span><%= (langCd.equals("en_US") ? "RESEARCH" : "PHÂN TÍCH") %></span></h2>
            <ul id="researchTopList">
            </ul>
            <a href="/home/subpage/research.do" class="read_more top">+</a>
        </div>
        
        <!--MARKET NEWS-->
        <div class="marketNews">
            <h2><span><%= (langCd.equals("en_US") ? "MARKET NEWS" : "TIN THỊ TRƯỜNG") %></span></h2>
             <ul id="newsList" class="news_list add" style="display=none;">
            </ul>
            <a href="javascript:marketGo('/home/newsAndEvents/market.do');" class="read_more top">+</a>
        </div>
        <!--MARKET NEWS /-->
        <div  class="marketIndex">
        	<h2><span><%= (langCd.equals("en_US") ? "MARKET INDEX" : "CHỈ SỐ THỊ TRƯỜNG") %></span></h2>
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
        <!--왼쪽 WRAP-->        
        <!--SECTOR ANALYSIS-->
        <div class="research">
            <h2><span><%= (langCd.equals("en_US") ? "SECTOR - EQUITY REPORT" : "BÁO CÁO NGÀNH-DOANH NGHIỆP") %></span></h2>
            <ul id="sectorTopList">
            </ul>
            <a href="/home/subpage/sector.do" class="read_more top">+</a>
        </div>
        <!--MIRAE ASSET NEWS-->
        <div class="marketNews">
            <h2><span><%= (langCd.equals("en_US") ? "MIRAE ASSET NEWS" : "TIN MIRAE ASSET") %></span></h2>
             <ul id="miraeAssetNews" class="news_list add">
            </ul>
            <a href="javascript:marketGo('/home/newsAndEvents/mirae.do');" class="read_more top">+</a>
        </div>
        <!--MARKET NEWS /-->
        <div  class="marketRanking">
        	<h2><span><%= (langCd.equals("en_US") ? "TOP 7" : "THỐNG KÊ TOP 7") %></span></h2>
        	<button class="tablinks" onclick="tabSelected(event, 'Volume')" id="defaultSelected"><%= (langCd.equals("en_US") ? "VOLUME" : "KLGD") %></button>
			<button class="tablinks" onclick="tabSelected(event, 'Up')"><%= (langCd.equals("en_US") ? "UP(5D)" : "TĂNG(5N)") %></button>
			<button class="tablinks" onclick="tabSelected(event, 'Down')"><%= (langCd.equals("en_US") ? "DOWN(5D)" : "GIẢM(5N)") %></button>
			<button class="tablinks" onclick="tabSelected(event, 'High')"><%= (langCd.equals("en_US") ? "HIGH(5D)" : "CAO(5N)") %></button>
			<button class="tablinks" onclick="tabSelected(event, 'Low')"><%= (langCd.equals("en_US") ? "LOW(5D)" : "THẤP(5N)") %></button>
			
			<div class="data">
				<div id="Volume" class="tabcontent">
				  <table class="tblRanking">
						<colgroup>
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
								<th><%= (langCd.equals("en_US") ? "%Chg" : "%Thay đổi") %></th>
								<th><%= (langCd.equals("en_US") ? "Vol." : "K.Lượng") %></th>
							</tr>
						</thead>						
						<tbody id="grdVolume">
							
						</tbody>
					</table>
				</div>
				
				<div id="Up" class="tabcontent">
				  <table class="tblRanking">
						<colgroup>
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
								<th><%= (langCd.equals("en_US") ? "%Chg" : "%Thay đổi") %></th>
								<th><%= (langCd.equals("en_US") ? "Average Ratio" : "Tỷ lệ tăng") %></th>
							</tr>
						</thead>						
						<tbody id="grdUp">
							
						</tbody>
					</table> 
				</div>
				
				<div id="Down" class="tabcontent">
				  <table class="tblRanking">
						<colgroup>
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
								<th><%= (langCd.equals("en_US") ? "%Chg" : "%Thay đổi") %></th>
								<th><%= (langCd.equals("en_US") ? "Average Ratio" : "Tỷ lệ giảm") %></th>
							</tr>
						</thead>						
						<tbody id="grdDown">
							
						</tbody>
					</table>
				</div>
				
				<div id="High" class="tabcontent">
				  <table class="tblRanking">
						<colgroup>
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
								<th><%= (langCd.equals("en_US") ? "%Chg" : "%Thay đổi") %></th>
								<th><%= (langCd.equals("en_US") ? "Highest" : "Cao nhất") %></th>
							</tr>
						</thead>						
						<tbody id="grdHigh">
							
						</tbody>
					</table>
				</div>
				
				<div id="Low" class="tabcontent">
				  <table class="tblRanking">
						<colgroup>
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="20%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th><%= (langCd.equals("en_US") ? "Stock" : "Mã CK") %></th>
								<th><%= (langCd.equals("en_US") ? "Current" : "Giá hiện tại") %></th>
								<th><%= (langCd.equals("en_US") ? "+/-" : "+/-") %></th>
								<th><%= (langCd.equals("en_US") ? "%Chg" : "%Thay đổi") %></th>
								<th><%= (langCd.equals("en_US") ? "Lowest" : "Thấp nhất") %></th>
							</tr>
						</thead>						
						<tbody id="grdLow">
							
						</tbody>
					</table>
				</div>
			</div>
        </div>		
        <!--왼쪽 WRAP /-->
        	        
    </div>
    <div class="get_wrap">
			<ul>
				<li class="get1"><a href="/home/subpage/openAccount.do"><%= (langCd.equals("en_US") ? "OPEN AN ACCOUNT" : "MỞ TÀI KHOẢN") %></a></li>
                <!--  <li class="get2"><a href="<%= (langCd.equals("en_US") ? "http://data.masvn.com/en/technical_chart_analysis" : "http://data.masvn.com/vi/technical_chart_analysis") %>" class="" target="_blank"><%= (langCd.equals("en_US") ? "TECHNICAL CHART" : "BIỂU ĐỒ KỸ THUẬT") %></a></li>-->
                <li class="get2"><a href="<%= (langCd.equals("en_US") ? "http://data.masvn.com/en/ta/VNINDEX" : "http://data.masvn.com/vi/ta/VNINDEX") %>" class="" target="_blank"><%= (langCd.equals("en_US") ? "TECHNICAL CHART" : "BIỂU ĐỒ KỸ THUẬT") %></a></li>                
                <li class="get3"><a href="/home/support/mobile.do"><%= (langCd.equals("en_US") ? "MAS MOBILE APP" : "ỨNG DỤNG MOBILE") %></a></li>
                <li class="get5"><a href="/home/support/hometrading.do"><%= (langCd.equals("en_US") ? "HOME TRADING SYSTEM" : "ỨNG DỤNG PC") %></a></li>
                <li class="get4"><a href="/home/support/question.do"><%= (langCd.equals("en_US") ? "QUESTIONS" : "CÂU HỎI THƯỜNG GẶP") %></a></li>
            </ul>
        </div>		
    <!-- main_contents -->
    <% if(langCd.equals("en_US")) { %>
    	<div class="global_network_en"></div>
    <% } else { %>
    	<div class="global_network_vn"></div>
    <% } %>
    
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

<div id="dialog_popupversion6"></div>	

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