<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="cache-control" content="no-store">

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

<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>


<decorator:head></decorator:head>
<script>

</script>


</head>
<body>

<%@ include file="/US/home/include/home_header.jsp"%>

<!-- content -->
<decorator:body></decorator:body>
<!--footer-->

<%@ include file="/US/home/include/home_footer.jsp"%>

<!--footer-->

</body>
</html>