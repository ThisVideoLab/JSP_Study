<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
    
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee table의 내용을 가져와서 출력하기</title>
</head>
<body>

<%@ include file = "db_connection_mySQL.jsp"  %>

<table width = "1000" border = "1">
<tr>
	<th>eno</th>
	<th>ename</th>
	<th>job</th>
	<th>manager</th>
	<th>hiredate</th>
	<th>salary</th>
	<th>commission</th>
	<th>dno</th>
</tr>

<%
	ResultSet rs = null; // ResultSet 객체는 db의 테이블을 select 해서 나온 결과 레코드들을 모아 담는 객체 
	Statement stmt = null; // sql 쿼리를 담아서 실행하는 객체
	try{
		String sql = "select * from emp_copy";
		stmt = conn.createStatement(); // connection 객체에서 createStatement()로 stmt를 활성화 
		rs = stmt.executeQuery(sql);
		while(rs.next()){
			Integer eno = rs.getInt("eno");
			String ename = rs.getString("ename");
			String job = rs.getString("job");
			Integer manager = rs.getInt("manager");
			Date hiredate = rs.getDate("hiredate");
			Double salary = rs.getDouble("salary");
			Double commission = rs.getDouble("commission");
			Integer dno = rs.getInt("dno");
			%>
			<tr>
			<td><%= eno %></td>
			<td><%= ename %></td>
			<td><%= job %></td>
			<td><%= manager %></td>
			<td><%= hiredate %></td>
			<td><%= salary %></td>
			<td><%= commission %></td>
			<td><%= dno %></td>
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
		if ( stmt != null){
			stmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}

	
	
	
%>

</table>

</body>
</html>