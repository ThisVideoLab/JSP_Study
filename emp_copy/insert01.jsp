<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert Employee's infromation here</title>
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
	</form>
</body>
</html>