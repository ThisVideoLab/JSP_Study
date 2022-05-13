<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>DB�� ������ �����ͼ� ����ϱ�</title>
</head>
<body>

<%@ include file = "db_connection_oracle.jsp"  %>

<table width = "500" border = "1">
<tr>
	<th>���̵�</th>
	<th>��й�ȣ</th>
	<th>�̸�</th>
	<th>email</th>
	<th>city</th>
	<th>phone</th>
</tr>

<%
	ResultSet rs = null; // ResultSet ��ü�� db�� ���̺��� select �ؼ� ���� ��� ���ڵ���� ��� ��� ��ü 
	Statement stmt = null; // sql ������ ��Ƽ� �����ϴ� ��ü
	try{
		String sql = "SELECT * FROM mbTbl";
		stmt = conn.createStatement(); // connection ��ü���� createStatement()�� stmt�� Ȱ��ȭ 
		rs = stmt.executeQuery(sql);
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