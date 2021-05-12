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
	var page;
	var domain;
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Về chúng tôi";
		sid = "<%=request.getParameter("sid")%>";
		from = "<%=request.getParameter("from")%>";
		to = "<%=request.getParameter("to")%>";
		page = "<%=request.getParameter("page")%>";
		getJobTitle();
		//Change URL
		var currentUrl = window.location.href;
		var idx = currentUrl.indexOf("&from");
		var newUrl = currentUrl.substring(0, idx);
		window.history.replaceState("", "", newUrl);
		
		//Get domain
		var idx1 = currentUrl.indexOf("//");
		var tmp = currentUrl.substring(idx1 + 2);
		var idx2 = tmp.indexOf("/");
		domain = tmp.substring(0, idx2);
	});

	function getJobTitle() {
		$("body").block({message: "<span>LOADING...</span>"});
		var param = {
			  sid  : sid
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/home/aboutUs/getJobTitleDetail.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.jsonObj != null) {
					$("#tdJobTitl").html(data.jsonObj.list[0].title);
					$("#tdLocation").html(data.jsonObj.list[0].location);
					$("#tdDate").html(data.jsonObj.list[0].lastdate);
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

	function vacanciesView() {
		$("#fromS").val(from);
		$("#toS").val(to);
		$("#pageS").val(page);
		$("#sid").val(sid);
		$("#frmVacanciesView").serialize();
		var action = $("#frmVacanciesView").attr('action');
		if (action === 'null') {
			$("#typeS").val('');
			$("#pageS").val(1);
			$('#frmVacanciesView').attr('action', 'http://' + domain + '/home/aboutUs/vacancies.do');
		}
		$("#frmVacanciesView").submit();
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmVacanciesView" action="<%= request.getHeader("referer") %>" method="post">
		<input type="hidden" id="typeS" name="type" value="All"/>
		<input type="hidden" id="sid" name="sid" value=""/>
		<input type="hidden" id="fromS" name="from" value=""/>
		<input type="hidden" id="toS" name="to" value=""/>
		<input type="hidden" id="pageS" name="page" value=""/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Về chúng tôi</h2>
            <ul>
            	<li><a href="/home/aboutUs/philosophy.do">Tầm nhìn và</br>Triết lý</a></li>
            	<li><a href="/home/aboutUs/why.do">Chúng tôi làm gì</a></li>
            	<li><a href="/home/aboutUs/history.do">Lịch sử</a></li>
                <li>
                    <a href="/home/aboutUs/career.do" class="on">Nghề nghiệp</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/aboutUs/vacancies.do" class="on">Vị trí tuyển dụng</a></li>
                        <li><a href="/home/aboutUs/applyonline.do">Nộp hồ sơ trực tuyến</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Vị trí tuyển dụng</h3>
            <div class="board_view">
                <div class="header">
                    <h4 id="tdJobTitl"></h4>
                    <p class="date" id="tdLocation"></p>
                    <p class="time" id="tdDate"></p>
                </div>
                <textarea id="tdText" cols="30" rows="10" readonly="readonly" style="display: none;"></textarea>
                <div class="body" id="divText">
                </div>
            </div>
            <!--  
            <div class="bottom_btns">
                <input type="button" class="btn" value="Quay lại" onclick="vacanciesView()"/>
            </div>
            -->
            <div style="padding-left:30px;">
            	<a style="cursor: pointer;" onclick="vacanciesView()"><img src="/resources/US/images/icon_back.png" alt="Quay lại"></a>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>