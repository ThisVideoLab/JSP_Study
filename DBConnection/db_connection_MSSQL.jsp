<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Oracle BD Connection </title>
</head>
<body>

<%
	// 변수 초기화
	Connection conn = null;	// DB를 연결하는 객체
	// String driver = "oracle.jdbc.driver.OracleDriver";	// Oracle Driver에 접속하는 구문
	String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";	// SQL Server에 접속하는 구문
	// String url = "jdbc:oracle:thin:@localhost:1521:XE"; 	// Oracle Driver에 접속하는 구문
	String url = "jdbc:sqlserver://localhost:1433;DatabaseName=myDB"; // SQL Server에 접속하는 구문
	Boolean connect = false;
	
	try{
		Class.forName (driver);	// oracle driver loaded
		conn = DriverManager.getConnection (url, "sa", "1234");
		connect = true;
		conn.close();
		
	}catch(Exception e){
		connect = false;
		e.printStackTrace();		
	}	

%>

<%
	if (connect == true){
		out.println("MS SQL DB에 오신 걸 환영합니다.");
	}else{
		out.println("MS SQL DB에 연결하지 못하였습니다.");
	}
%>

</body>
</html>