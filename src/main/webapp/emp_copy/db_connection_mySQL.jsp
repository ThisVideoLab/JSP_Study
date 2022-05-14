<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MySQL BD Connection </title>
</head>
<body>

<%
	// 변수 초기화
	Connection conn = null;	// DB를 연결하는 객체
	String driver = "com.mysql.jdbc.Driver";	// SQL Server에 접속하는 구문
	String url = "jdbc:mysql://localhost:3306/myDB?autoReconnect=true"; // SQL Server에 접속하는 구문
	Boolean connect = false;
	conn = DriverManager.getConnection (url, "root", "1234");
	connect = true;

%>


</body>
</html>