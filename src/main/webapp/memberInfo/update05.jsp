<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update를 통한 수정</title>
</head>
<body>

	<form method = "post" action = update05_process.jsp>  
	
		<!-- 일치 여부 확인 항목 -->
		<p> 아이디: <input type = "text" name = "id"> 
		<p> 패스워드: <input type = "password" name = "pass">
		
		<!-- 일치 여부 확인시 정보 수정항목 -->
		<p> 이름: <input type = "text" name = "name">
		<p> 이메일: <input type = "text" name = "email">
		<p> 도시: <input type = "text" name = "city">
		<p> 전화번호: <input type = "text" name = "phone">
		<p> <input type = "submit" value = "전송">
	
	</form>

</body>
</html>