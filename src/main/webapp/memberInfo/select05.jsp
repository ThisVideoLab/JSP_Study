<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB의 내용을 가져와서 출력하기</title>
</head>
<body>
<!-- 
	Statement:
		- 단일로 한번만 실행할 때 빠른 속도를 가짐
		- 쿼리에 인자를 부여할 수 없음
		- 매번 컴파일을 수행해야 함. 캐쉬를 사용하지 않음.
		
	Prepared Statement: 
		- 쿼리에 인자를 부여할 수 있음. (?) 인자를 사용하고, 이 ?에 변수를 할당함.
		- 처음 컴파일 된 이후에는 캐쉬를 사용해 컴파일을 수행하지 않고 구동됨.
		- 따라서 여러번 실행할 때 빠른 속도를 보임.
 -->

<%@ include file = "db_connection_oracle.jsp"  %>

<table width = "1000" border = "1">
<tr>
	<th>아이디</th>
	<th>비밀번호</th>
	<th>이름</th>
	<th>email</th>
	<th>city</th>
	<th>phone</th>
</tr>

<%
	ResultSet rs = null; // ResultSet 객체는 db의 테이블을 select 해서 나온 결과 레코드들을 모아 담는 객체 
	// Statement stmt = null; // 일회용 객체
	PreparedStatement pstmt = null;
	try{
		String sql = "SELECT * FROM mbTbl";
		pstmt = conn.prepareStatement(sql); // preparedStatement 객체 생성시에는 바로 sql를 넣어줌. 이는 statement를
											// null로 생성할 수 있는 것과 대조됨.
					 
		rs = pstmt.executeQuery(sql);
		while(rs.next()){
			String id = rs.getString("id");
			String pw = rs.getString("name");
			String pass = rs.getString("pass");
			String email = rs.getString("email");
			String city = rs.getString("city");
			String phone = rs.getString("phone");
			%>
			<tr>
			<td><%= id %></td>
			<td><%= pw %></td>
			<td><%= pass %></td>
			<td><%= email %></td>
			<td><%= city %></td>
			<td><%= phone %></td>
		</tr>
		<%
		}
		
	}catch(Exception ex)   {
		
		out.println("테이블을 호출하지 못했습니다.");
		out.println(ex.getMessage());
		
	}finally{
		if ( rs != null){
			rs.close();
		}
		if ( pstmt != null){
			pstmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}

	
	
	
%>

</table>

</body>
</html>