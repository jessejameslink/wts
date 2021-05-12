<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String langCd = (String) session.getAttribute("LanguageCookie");	
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>MIRAE ASSET WTS</title>

	<script type="text/javascript">
		$(document).ready(function(){
				initChart();
		});
			
		function initChart() {
			//var symbol = $("#dailySymb").val();
			
			var lang = "vi";
			if ("<%= langCd %>" == "en_US") {
				lang = "en";	
			} else {
				lang = "vi";
			}
			var src = "https://ta.vietstock.vn/Customer?stockcode=" + "VNINDEX" + "&lang=" + lang + "&fstarget=http%3A%2F%2Fdata.masvn.com%2Fvi%2Fta%2F";			
			$("#chartFrameMain").attr('src', src);
		}
		
	</script>
	<style>	
	</style>
</head>		
	<body class="mdi" >
		<div style="padding-left: 0px;">               
	    	<iframe id="chartFrameMain" width="100%" height="800" scrolling="no" frameborder="0"></iframe>      
	    </div>
	</body>
</html>