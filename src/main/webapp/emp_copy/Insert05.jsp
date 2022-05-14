<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PreparedStatement를 사용한 Data Insert</title>
</head>
<body>
	<form method = "post" action = insert01_process.jsp>  
	
		<p> eno: <input type = "text" name = "eno">
		<p> ename: <input type = "text" name = "ename">
		<p> job: <input type = "text" name = "job">
		<p> manager: <input type = "text" name = "manager">
		<p> hiredate: <input type = "text" name = "hiredate">
		<p> salary: <input type = "text" name = "salary">
		<p> commission: <input type = "text" name = "commission">
		<p> dno: <input type = "text" name = "dno">
		<p> <input type = "submit" values = "submit">
		
	</from>
</body>
</html>

<!--  

method = "post"
	-- http 헤더 앞에 값을 넣어서 전송, 보안이 강하다, 전송용량에 제한이 없음.
	
method = "get"
	-- http 헤더 뒤에 붙여서 값을 전송, 보안에 취약함, 전송량에 제한을 가지고 있음
	-- 게시판에서 사용함	
 


 -->