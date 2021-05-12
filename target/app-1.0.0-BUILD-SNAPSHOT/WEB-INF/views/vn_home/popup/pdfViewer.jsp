<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<html>
<head>
<style>
.pdfobject-container {
    width: 100%;
    max-width: 100%;
    height: 100%;
    margin: 0em 0;
}

.pdfobject { border: solid 1px #666; }
</style>

<link rel="stylesheet" type="text/css" href="/resources/HOME/css/miraeasset.css">
<script type="text/javascript" src="/resources/HOME/jquery/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="/resources/HOME/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/HOME/jquery/jquery.slides.min.js"></script>
<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
<script type="text/javascript" src="/resources/HOME/js/mireaasset.js?600"></script>
<script type="text/javascript" src="/resources/js/jquery.blockUI.min.js"></script>

<script type="text/javascript" src="/resources/js/nexClient.js"></script>
<script type="text/javascript" src="/resources/js/socket.io.js"></script>


<script src="/resources/js/pdfobject.min.js"></script>

<script>
	var ids = "<%=request.getParameter("pdfIds")%>";
	$(document).ready(function() {
		var options = {
			    pdfOpenParams: {
			        navpanes: 1,
			        toolbar: 1,
			        statusbar: 1,
			        view: "FitV",
			        pagemode: "thumbs",
			        page: 1
			    },
			    forcePDFJS: true,
			    PDFJS_URL: "/resources/pdfjs-1.6.210-dist/web/viewer.html"
			};
			
		PDFObject.embed("/researchDown2.do?ids=" + ids, "#PDFBody", options);
		
		$("#divPDFPopMsgContainer").css({top: "200px"});
		$("#divPDFPopMsg").css({height: $(document).height()}).show();
	});

</script>

</head>
<body>
	<div id="PDFBody"></div>
	<div id="divPDFPopMsg" class="layer_pop">
	<div id="divPDFPopMsgContainer" class="layer_pop_container">
		<h2 class="cont_title">Message</h2>
        <h3 class="cont_subtitle">Please Wait..</h3>
        
	  	<button type="button" class="btn_close_pop">close layerpopup</button>
  	</div>
</div>
</body>
</html>