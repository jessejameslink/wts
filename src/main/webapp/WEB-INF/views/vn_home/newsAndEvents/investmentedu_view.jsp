<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
</head>
<body>
<script>
	var sid;
	var from;
	var to;
	var key;
	var page;
	var domain;
	/*
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
		     };*/
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Tin tức & Sự kiện";
		sid = "<%=request.getParameter("sid")%>";
		from = "<%=request.getParameter("from")%>";
		to = "<%=request.getParameter("to")%>";
		key = "<%=request.getParameter("key")%>";
		page = "<%=request.getParameter("page")%>";
		/*
		if( isMobile.any() || isMobile.Android() || isMobile.BlackBerry() || isMobile.Opera() || isMobile.Windows() || isMobile.iOS()) 
			window.location.href = "http://m.masvn.com:8080/mobile/mobile/newsView.do?sid=" + sid;
		else {*/
		getMiraeView();
		
		//Change URL
		var currentUrl = window.location.href;
		var idx = currentUrl.indexOf("&from");
		var newUrl = currentUrl.substring(0, idx);
		window.history.replaceState("", "", newUrl);
		
		//Share button
		var fbLink = "http://www.facebook.com/sharer.php?u=" + encodeURIComponent(window.location.href);
		$('#fbLink').attr('href', fbLink).attr('target', '_blank');
		
		var googleLink = "https://plus.google.com/share?url=" + encodeURIComponent(window.location.href);
		$('#googleLink').attr('href', googleLink).attr('target', '_blank');
		
		var liLink = "http://www.linkedin.com/shareArticle?mini=true&amp;url=" + encodeURIComponent(window.location.href);
		$('#liLink').attr('href', liLink).attr('target', '_blank');
		
		var twLink = "https://twitter.com/share?url=" + encodeURIComponent(window.location.href);
		$('#twLink').attr('href', twLink).attr('target', '_blank');
		
		//Get domain
		var idx1 = currentUrl.indexOf("//");
		var tmp = currentUrl.substring(idx1 + 2);
		var idx2 = tmp.indexOf("/");
		domain = tmp.substring(0, idx2);
		
	});

	function getMiraeView() {
		$("body").block({message: "<span>LOADING...</span>"});
		var param = {
			  sid   : sid
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getInvestmentEduDetail.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.jsonObj != null) {
					var datetime = data.jsonObj.list[0].created;
					var idx = datetime.indexOf(" ");
					var date = datetime.substring(0, idx);
					var time = datetime.substring(idx + 1);
					var idx1 = time.indexOf(".");
					if (idx1 >= 0) {
						time = time.substring(0, idx1);
					}
					$("#tdTitl").html(data.jsonObj.list[0].title);
					$("#tdDate").html(date);
					$("#tdTime").html(time);
					var htmlText = formatHTMLContent(data.jsonObj.list[0].data);
					$("#divText").html(htmlText);
				}
				$("body").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("body").unblock();
			}
		});
	}
	
	function formatHTMLContent(html) {
		var sR = this;
		sR 	= 	html.substring(html.indexOf("<Content>"), html.indexOf("</Content>"));
		sR				=	sR.replace("<Content>", "");
		sR				=	sR.replace("</Content>", "");
		sR = sR.replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&quot;/g,'"');
		return sR;
	}
	
	
	function miraeView() {
		$("#fromS").val(from);
		$("#toS").val(to);
		$("#searchkeyS").val(key);
		$("#pageS").val(page);
		$("#sid").val(sid);
		$("#frmMiraeView").serialize();
		var action = $("#frmMiraeView").attr('action');
		if (action === 'null') {
			$("#typeS").val('');
			$("#pageS").val(1);
			$('#frmMiraeView').attr('action', 'http://' + domain + '/home/newsAndEvents/investmentedu.do');
		}
		$("#frmMiraeView").submit();
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">	
	<form id="frmMiraeView" action="<%= request.getHeader("referer") %>" method="post">
		<input type="hidden" id="typeS" name="type" value="All"/>
		<input type="hidden" id="sid" name="sid" value=""/>
		<input type="hidden" id="fromS" name="from" value=""/>
		<input type="hidden" id="toS" name="to" value=""/>
		<input type="hidden" id="searchkeyS" name="searchkey" value=""/>
		<input type="hidden" id="pageS" name="page" value=""/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Tin tức<br />&amp; Sự kiện</h2>
            <ul>
                <li>
                    <a href="/home/newsAndEvents/mirae.do">Tin tức</a>
                </li>
                <li><a href="/home/investorRelations/financial.do">Công bố thông tin</a></li>
                <li><a href="http://data.masvn.com/vi/events">Sự kiện</a></li>
                <li><a href="/home/newsAndEvents/investmentedu.do" class="on">Đào Tạo Nhà đầu tư</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Đào tạo Nhà đầu tư</h3>
            <div class="board_view">
                <div class="header">
                    <p class="date" id="tdDate"></p>
                    <p class="time" id="tdTime"></p>
                    <h4 id="tdTitl"></h4>
                </div>
                <textarea id="tdText" cols="30" rows="10" readonly="readonly" style="display: none;"></textarea>
                <div class="body" id="divText">
                </div>
            </div>
            <!--  
            <div class="bottom_btns">
                <input type="button" class="btn" value="Quay lại" onclick="miraeView()"/>
            </div>
            -->
            <div style="padding-left:30px;">
            	<a style="cursor: pointer;" onclick="miraeView()"><img src="/resources/US/images/icon_back.png" alt="Quay lại"></a>
            </div>
            
            <div id="share-buttons">
			    <!-- Facebook -->
			    <a id="fbLink">
			        <img src="https://simplesharebuttons.com/images/somacro/facebook.png" alt="Facebook" />
			    </a>
			    
			    <!-- Google+ -->
			    <a id="googleLink">
			        <img src="https://simplesharebuttons.com/images/somacro/google.png" alt="Google" />
			    </a>
			    
			    <!-- LinkedIn -->
			    <a id="liLink">
			        <img src="https://simplesharebuttons.com/images/somacro/linkedin.png" alt="LinkedIn" />
			    </a>
			     
			    <!-- Twitter -->
			    <a id="twLink">
			        <img src="https://simplesharebuttons.com/images/somacro/twitter.png" alt="Twitter" />
			    </a>
			</div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>