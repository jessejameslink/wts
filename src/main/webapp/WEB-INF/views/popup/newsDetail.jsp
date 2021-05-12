<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");
%>

<%--
<%@ include file = "<c:url value='/include/header.jsp'/>" %>
 --%>
<html>
<head>
<script>
	$(document).ready(function() {
		getNewsDetail();
	});

	function getNewsDetail() {
		$("#divNews").block({message: "<span>LOADING...</span>"});
		var param = {
			  skey  : $("#newsSeqn").val()
			, lang  : ("<%= langCd %>" == "en_US" ? "1" : "0")
		};

		$.ajax({
			url      : "/trading/data/getNewsDetail.do",
			data     : param,
			dataType : "json",
			success  : function(data){
				if(data.newsDetail != null) {
					$("#txtl").val(data.newsDetail.txtl);
					$("#tdTitl").html(data.newsDetail.titl);
					$("#tdDate").html(data.newsDetail.date);
					$("#tdTime").html(data.newsDetail.time);
					$("#tdText").html(data.newsDetail.text);
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

	function closePop() {
		$("#" + $("#newsDivId").val()).fadeOut();
	}
</script>

</head>
<body>
	<input type="hidden" id="newsSeqn" name="newsSeqn" value="${newsSeqn}">
	<input type="hidden" id="newsDivId" name="newsDivId" value="${newsDivId}">
	<input type="hidden" id="txtl" name="txtl" value="">
	<div id="divNews" class="modal_layer pbo">
		<h2><%= (langCd.equals("en_US") ? "News detail" : "Tin tức chi tiết") %></h2>
		<div class="group_table">
			<table class="no_bbt">
				<colgroup>
					<col width="160">
					<col>
				</colgroup>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Title" : "Tiêu đề") %></th>
					<td id="tdTitl" class="text_left"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Date" : "Ngày") %></th>
					<td id="tdDate" class="text_left"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "Time" : "Thời gian") %></th>
					<td id="tdTime" class="text_left"></td>
				</tr>
				<tr>
					<th><%= (langCd.equals("en_US") ? "News" : "Tin tức") %></th>
					<td class="text_left">
						<textarea id="tdText" rows="30" cols="100%" readonly="readonly" style="display: none;"></textarea>
						<div id="divText" style="text-align: left; width : 100%; height: 400px; overflow-y: auto; overflow-x: hidden; padding: 3px; word-break: break-all;"></div>
					</td>
				</tr>
			</table>
		</div>
		<button class="close" type="button" onclick="closePop()">close</button>
	</div>
</body>
</html>