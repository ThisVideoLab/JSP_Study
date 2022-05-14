<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete를 통한 정보 삭제</title>
</head>
<body>

	<form method = "post" action = delete05_process.jsp>  
	
		<p> 삭제할 ID의 정보를 입력하십시오.
		<p> 아이디: <input type = "text" name = "id">
		<p> 패스워드: <input type = "password" name = "pass">
		<p> <input type = "submit" value = "전송">
	
	</form>


</body>
</html>

<!--  

method = "post"
	-- http 헤더 앞에 값을 넣어서 전송, 보안이 강하다, 전송용량에 제한이 없음.
	
method = "get"
	-- http 헤더 뒤에 붙여서 값을 전송, 보안에 취약함, 전송량에 제한을 가지고 있음
	-- 게시판에서 사용함	
 


 -->