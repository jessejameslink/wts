<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/js/function_comm.js?600"></script>
<!-- <script type="text/javascript" src="/resources/js/common.js"></script> -->
<script type="text/javascript" src="/resources/js/ajaxCommon.js?600"></script>
<script type="text/javascript" src="/resources/js/utils.js?600"></script>
<!-- <script type="text/javascript" src="/resources/js/commet.js"></script> -->
<script type="text/javascript" src="/resources/js/pqgrid.min.js"></script>

<link rel="stylesheet" type="text/css" href="/resources/css/common.css" />


<%
response.setHeader("Cache-Control","no-cache");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);
String id = (String)session.getAttribute("ClientV");
System.out.println("id : "+id);
if("".equals(id) || id==null){
	response.sendRedirect("/wts/US/login.jsp");
}
%>
