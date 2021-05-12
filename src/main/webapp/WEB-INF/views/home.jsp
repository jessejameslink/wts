<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<script type="text/javascript" src="/resources/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
	<script type="text/javascript" src="/resources/js/nexClient.js"></script>
	<script type="text/javascript" src="/resources/js/socket.io.js"></script>
	
	<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>
	
	<title>Home</title>
	<script>
	$(document).ready(function(){
		//var pdfPath = 'data:application/octet-stream;base64,' +	"${pdfCon}";
		//window.location.href	=	pdfPath;
	});
	</script>
	<script>
	//var pdf = 'data:application/octet-stream;base64,' +	"${pdfCon}";
	/*
	window.downloadPDF = function downloadPDF() {
	    var dlnk = document.getElementById('dwnldLnk');
	    dlnk.href = pdf;
	    dlnk.click();
	}
	//console.log("222=======================");
	//console.log("${pdfCon}");
	*/
	
	function getResearch(symbol) {
		//console.log("GET RESEARCH CLLL");
		var param = {
			symb	:	""
		};

		param.symb	=	symbol;

		$.ajax({
			url:'/researchDown2.do',
			data:param,
		  	dataType: 'json',
		  	success: function(data){
			 	//console.log(data);
			 	//setBID(data);
			 	//console.log(data.downPath);
			 	location.href=data.downPath;
		  	}
		});
	}
	
	
	
	
	
	</script>
</head>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>

<P>  The time on the server is ${serverTime2}. </P>

<p>
	<a id='dwnldLnk' download='o ficheirinho de tostas.pdf' style="display:none;" /> 
    <a href="#" onclick="downloadPDF();" title='o ficheirinho de tostas.pdf'>clica</a>
</p>


<p>
	<button id='reschDown' onclick="getResearch('A');">RESEARCH</button>
</p>
</body>
</html>
