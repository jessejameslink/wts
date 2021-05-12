<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<html>
<head>
<script>
	$(document).ready(function() {
		getMiraeView();
	});

	function getMiraeView() {
		$("#divNews").block({message: "<span>LOADING...</span>"});
		var param = {
			  sid  : $("#newsSeqn").val()
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getMiraeAssetNewsDetail.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.jsonObj != null) {
                    //console.log(data);
					$("#tdTitl").html(data.jsonObj.list[0].title);
					$("#tdDate").html(data.jsonObj.list[0].created);
					var htmlText = formatHTMLContent(data.jsonObj.list[0].data);
					$("#tdText").html(htmlText);
				}
				$("#divNews").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divNews").unblock();
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

	function cancel() {
		$("#" + $("#newsDivId").val()).fadeOut();
	}
</script>

</head>
<body>
<div class="layer_pop_container">
	<input type="hidden" id="newsSeqn" name="newsSeqn" value="${newsSeqn}">
	<input type="hidden" id="newsDivId" name="newsDivId" value="${newsDivId}">
	<input type="hidden" id="txtl" name="txtl" value="">
    <div class="board_detail">
        <h2 id="tdTitl" class="cont_title"></h2>
        <div class="date">
            <span id="tdDate"></span>
        </div>
        <div class="content">
            <div id = "tdText" style="text-align: left; width:100%; height:500px; overflow-y: auto;" ></div>
        </div>
    </div>
    <button type="button" class="btn_close_pop" onclick="cancel()">close</button>
</div>
</body>
</html>