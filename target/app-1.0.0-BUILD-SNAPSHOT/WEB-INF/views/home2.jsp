<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!  
</h1>

camplist<BR>
<c:forEach var="camplist" items="${list1}">
	${camplist.tableName } <BR>
</c:forEach><BR><BR>

adultlist<BR>
<c:forEach var="adultlist" items="${list2}">
	${adultlist.tableName } <BR>
</c:forEach>
</html>
