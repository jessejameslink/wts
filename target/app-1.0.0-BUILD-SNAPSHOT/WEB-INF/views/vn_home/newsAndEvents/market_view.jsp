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
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Tin tức & Sự kiện";
		sid = "<%=request.getParameter("sid")%>";
		from = "<%=request.getParameter("from")%>";
		to = "<%=request.getParameter("to")%>";
		key = "<%=request.getParameter("key")%>";
		page = "<%=request.getParameter("page")%>";
		
		getMiraeView();
		
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

	function getMiraeView() {
		$("body").block({message: "<span>LOADING...</span>"});
		var param = {
			  skey  : sid
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getNewsDetail.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.newsDetail != null) {
					$("#tdTitl").html(data.newsDetail.titl);
					$("#tdDate").html(data.newsDetail.date);
					$("#tdTime").html(data.newsDetail.time);
					$("#tdText").html(data.newsDetail.text);
					$("#divText").html($("#tdText").text());
				}
				$("body").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("body").unblock();
			}
		});
	}

	function marketGo() {
		$("#frmMarketGo").serialize();
		$("#frmMarketGo").submit();
	}

	function marketView() {
		$("#fromS").val(from);
		$("#toS").val(to);
		$("#searchkeyS").val(key);
		$("#trPageS").val(page);
		$("#sid").val(sid);		
		$("#frmMarketView").serialize();
		
		var action = $("#frmMarketView").attr('action');
		if (action === 'null') {
			$("#typeS").val('');
			$("#trPageS").val(1);
			$('#frmMarketView').attr('action', 'http://' + domain + '/home/newsAndEvents/market.do');
		}
		$("#frmMarketView").submit();
	}
</script>
<!--container : 서브페이지 컨텐츠 -->
<div id="container" class="sub">
	<form id="frmMarketGo" action="/home/newsAndEvents/market.do" method="post">
		<input type="hidden" id="type" name="type" value=""/>
		<input type="hidden" id="seqn" name="seqn" value=""/>
		<input type="hidden" id="from" name="from" value=""/>
		<input type="hidden" id="to" name="to" value=""/>
		<input type="hidden" id="schSkey" name="schSkey" value=""/>
		<input type="hidden" id="nxtSkey" name="nxtSkey" value=""/>
	</form>
	<form id="frmMarketView" action="<%= request.getHeader("referer") %>" method="post">
		<input type="hidden" id="typeS" name="type" value="All"/>
		<input type="hidden" id="sid" name="sid" value=""/>
		<input type="hidden" id="fromS" name="from" value=""/>
		<input type="hidden" id="toS" name="to" value=""/>
		<input type="hidden" id="searchkeyS" name="searchkey" value=""/>
		<input type="hidden" id="trPageS" name="trPage" value=""/>
	</form>
    <div class="sub_container">
        <!-- lnb -->
        <div id="lnb" class="lnb">
            <h2>Tin tức<br />&amp; Sự kiện</h2>
            <ul>
                <li>
                    <a href="/home/newsAndEvents/mirae.do" class="on">Tin tức</a>
                    <ul class="lnb_sub">
                        <li><a href="/home/newsAndEvents/mirae.do">Tin Mirae Asset</a></li>
                        <li><a style="cursor: pointer;" onclick="marketView()" class="on">Tin thị trường</a></li>
                    </ul>
                </li>
                <li><a href="/home/investorRelations/financial.do">Công bố thông tin</a></li>
                <li><a href="http://data.masvn.com/vi/events">Sự kiện</a></li>
                <li><a href="/home/newsAndEvents/investmentedu.do">Đào Tạo Nhà đầu tư</a></li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Tin Thị Trường</h3>
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
                <input type="button" class="btn" value="Quay lại" onclick="marketView()"/>
            </div>
            -->
            <div style="padding-left:30px;">
            	<a style="cursor: pointer;" onclick="marketView()"><img src="/resources/US/images/icon_back.png" alt="Quay lại"></a>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>