<%@ page contentType = "text/html;charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<link rel="shortcut icon" href="https://www.masvn.com/docs/image/favicon.ico">
</head>
<body>
<script>
	var sid;
	var page;
	var domain;
	$(document).ready(function() {
		document.title = "MIRAE ASSET VN | Sản phẩm & Dịch vụ";
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
			url      : "/home/productsAndServices/getFundInfoDetail.do",
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
			$('#frmInformationView').attr('action', 'http://' + domain + '/home/productsAndServices/ofInfoDisclosures.do');
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
            <h2>Sản phẩm<br />&amp; Dịch vụ</h2>
            <ul>
                <li><a href="/home/productsAndServices/individual.do">Môi giới Khách hàng cá nhân</a></li>
                <li><a href="/home/productsAndServices/institutional.do">Môi giới Khách hàng tổ chức</a></li>
                <li><a href="/home/productsAndServices/wealth.do">Quản lý tài sản</a></li>
                <li><a href="/home/productsAndServices/investment.do">Ngân hàng đầu tư</a></li>
                <li>
                	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Quỹ</a>
                	<ul class="lnb_sub">
                        <li>
                        	<a href="/home/productsAndServices/ofIntroduction.do" class="on">Quỹ MAGEF</a>
                        	<ul class="lnb_sub1">
	                        	<li>
			                    	<a href="/home/productsAndServices/ofIntroduction.do">Thông tin quỹ</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInvesInstruction.do">Hướng dẫn đầu tư</a>
			                    			                    	
			                    </li>
			                    <li>
			                    	<a href="/home/productsAndServices/ofInfoDisclosures.do" class="on">Công bố thông tin</a>			                    	
			                    </li>                        
		                    </ul>
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/ofbIntroduction.do">VFMVFB</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/ofcIntroduction.do">VFMVFC</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/of1Introduction.do">VFMVF1</a>                        	
                        </li>
                        <li>
                        	<a href="/home/productsAndServices/of4Introduction.do">VFMVF4</a>                        	
                        </li>                        
                    </ul>
                </li>
            </ul>
        </div>
        <!-- // lnb -->

        <div id="contents">
            <h3 class="cont_title">Công bố thông tin</h3>
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
            <div style="padding-left:30px;">
            	<a style="cursor: pointer;" onclick="informationView()"><img src="/resources/US/images/icon_back.png" alt="Quay lại"></a>
            </div>
        </div>
    </div>
</div>
<!-- // container 서브페이지 컨텐츠-->

</body>
</html>