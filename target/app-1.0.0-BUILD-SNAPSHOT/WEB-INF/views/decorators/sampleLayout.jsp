<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><decorator:title default="JLStory" /></title>
<decorator:head />
</head>
<body>
 	<page:applyDecorator name="_wtsHeader"/>
	<!-- header -->
	<header style="width: 100%; text-align:center">
		<h2>This is header</h2>
	</header>
	
	<!-- content -->
	<decorator:body></decorator:body>

	<!-- FOOTER -->
	<footer style="width:100%; text-align:center;">
		<p>	This is footer</p>
	</footer>

</body>
</html>