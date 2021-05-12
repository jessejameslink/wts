<%@ page contentType = "text/html;charset=utf-8" %>
<head>
</head>

<%
	String chkSession = (String) session.getAttribute("ClientV");
	String   langCd   = (String) (session.getAttribute("LanguageCookie") == null ? "vi_VN" : session.getAttribute("LanguageCookie"));
	String flag		=	(String)request.getParameter("flag");
%>

<script>
	$(document).ready(function() {
		
	});
</script>
	
	
	
	
	<h2>About Us</h2>
	<ul>
		<li><a href="/home/aboutUs/philosophy.do">Vision and Philosophy</a></li>
		<li><a href="/home/aboutUs/why.do">What We Do</a></li>
		<li><a href="/home/aboutUs/history.do">History</a></li>
	    <li>
	        <a href="/home/aboutUs/career.do" class="on">Careers</a>
	        <ul class="lnb_sub">
	            <li><a href="/home/aboutUs/vacancies.do">Vacancies</a></li>
	            <li><a href="/home/aboutUs/applyonline.do" class="on">Apply Online</a></li>
	        </ul>
	    </li>
	</ul>
	