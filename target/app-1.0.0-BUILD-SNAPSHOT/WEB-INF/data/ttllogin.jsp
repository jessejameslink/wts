<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.io.*"%>
<%@ page import="com.itrade.client.TTLLogin"%>
<%
TTLLogin outResult = new TTLLogin();
JSONObject newObj = new JSONObject();
System.out.println(request.getParameter("mvClientID"));
newObj =outResult.login(request);
out.print(newObj);
%>