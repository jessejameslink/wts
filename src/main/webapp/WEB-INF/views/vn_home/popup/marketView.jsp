<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<html>
<head>
<script>
	$(document).ready(function() {
		getMarketView();
	});

	function getMarketView() {
		$("#divNews").block({message: "<span>LOADING...</span>"});
		var param = {
			  skey  : $("#newsSeqn").val()
			, lang  : ("<%= session.getAttribute("LanguageCookie") %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getNewsDetail.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.newsDetail != null) {
                    //console.log(data);
					$("#txtl").val(data.newsDetail.txtl);
					$("#tdTitl").html(data.newsDetail.titl);
					$("#tdDate").html(data.newsDetail.date);
					$("#tdTime").html(data.newsDetail.time);
					$("#tdText").html(data.newsDetail.text);
					$("#divText").html($("#tdText").text());
				}
				$("#divNews").unblock();
			},
			error     :function(e) {
				console.log(e);
				$("#divNews").unblock();
			}
		});
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
            <span id="tdTime"></span>
        </div>
        <div class="content">
            <textarea id="tdText" cols="30" rows="10" readonly="readonly" style="display: none;"></textarea>
            <div id="divText" style="width : 100%; height: 500px; overflow: auto;"></div>
        </div>
    </div>
    <button type="button" class="btn_close_pop" onclick="cancel()">close layerpopup</button>
</div>
</body>
</html>