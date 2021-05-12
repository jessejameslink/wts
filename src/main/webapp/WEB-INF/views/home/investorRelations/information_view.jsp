<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
</head>
<body>
<script>
	var sid;
	var page;
	var domain;
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | News & Events";
		sid = "<%=request.getParameter("sid")%>";
		page = "<%=request.getParameter("page")%>";
		getInformationView();
		
		//Change URL
		var currentUrl = window.location.href;
		var idx = currentUrl.indexOf("&page");
		var newUrl = currentUrl.substring(0, idx);
		window.history.replaceState("", "", newUrl);
		//Get domain
		var idx1 = currentUrl.indexOf("//");
		var tmp = currentUrl.substring(idx1 + 2);
		var idx2 = tmp.indexOf("/");
		domain = tmp.substring(0, idx2);
	});

	function getInformationView() {
		$("body").block({message: "<span>LOADING...</span>"});
		var param = {
			  sid  : sid
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/home/investorRelations/getInvestorDetail.do",
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
	
	
	function informationView() {
		$("#pageS").val(page);
		$("#sid").val(sid);		
		$("#frmInformationView").serialize();
		
		var action = $("#frmInformationView").attr('action');
		if (action === 'null') {
			$("#typeS").val('');
			$("#pageS").val(1);
			$('#frmInformationView').attr('action', 'http://' + domain + '/home/investorRelations/information.do');
		}
		$("#frmInformationView").submit();
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">	
	<form id="frmInformationView" action="<%= request.getHeader("referer") %>" method="post">
		<input type="hidden" id="typeS" name="type" value="All"/>
		<input type="hidden" id="sid" name="sid" value=""/>
		<input type="hidden" id="pageS" name="page" value=""/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>News<br />&amp; Events</h2>
            <li><a href="/home/newsAndEvents/mirae.do">News</a></li>
            <li>
            	<a href="/home/newsAndEvents/mirae.do" class="on">Information Disclosure</a>
	            <ul class="lnb_sub">
	                <li><a href="/home/investorRelations/financial.do">Financial Statement /<br />Annual Report</a></li>
	                <li><a href="/home/investorRelations/information.do" class="on">Information Disclosure</a></li>
	                <li><a href="/home/investorRelations/company.do">Company's Charter</a></li>
	            </ul>
            </li>
            <li><a href="http://data.masvn.com/en/events">Events</a></li>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Information Disclosure</h3>
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
                <input type="button" class="btn" value="Back" onclick="informationView()"/>
            </div>
            -->
            <div style="padding-left:30px;">
            	<a style="cursor: pointer;" onclick="informationView()"><img src="/resources/US/images/icon_back.png" alt="Back"></a>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>