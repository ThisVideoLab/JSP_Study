<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
    
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee table�� ������ �����ͼ� ����ϱ�</title>
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
	ResultSet rs = null; // ResultSet ��ü�� db�� ���̺��� select �ؼ� ���� ��� ���ڵ���� ��� ��� ��ü 
	Statement stmt = null; // sql ������ ��Ƽ� �����ϴ� ��ü
	try{
		String sql = "select * from emp_copy";
		stmt = conn.createStatement(); // connection ��ü���� createStatement()�� stmt�� Ȱ��ȭ 
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
		
		out.println("���̺��� ȣ������ ���߽��ϴ�.");
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