<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ page import = "java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update를 통한 수정</title>
</head>
<body>

<%@ include file = 'db_connection_oracle.jsp'%>

<%
	request.setCharacterEncoding("UTF-8");
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String city = request.getParameter("city");
	String phone = request.getParameter("phone");

	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = null;
	
	try{
		sql = "select id, pass from mbTbl where id = ?";
		pstmt = conn.prepareStatement(sql); // 변수 선언 및 값 할당 단계에서 SQL을 넣어줘야 함.
		pstmt.setString(1,id);
		rs = pstmt.executeQuery(); // pstmt 선언 단계에서 sql을 넣어줬기 때문에 다시 sql을 넣지 말아야 함. 
				
		if(rs.next()){
			String rs_id = rs.getString("id");
			String rs_pass = rs.getString("pass");
			
			if(id.equals(rs_id)&&pass.equals(rs_pass)){ 
				sql = "update mbTbl set name = ?, email = ?, city = ?, phone = ? where id = ?";
				pstmt = conn.prepareStatement(sql); // 변수 선언 및 값 할당 단계에서 SQL을 넣어줘야 함.
				pstmt.setString(1, name);
				pstmt.setString(2, email);
				pstmt.setString(3, city);
				pstmt.setString(4, phone);
				pstmt.setString(5, id);
				pstmt.executeUpdate();
				out.println("업데이트에 성공하였습니다.");
				out.println("<br><p>");
				out.println(sql);
			}else{
				out.println("패스워드가 일치하지 않습니다");
			}
		}else{
			out.println("ID: " + id + "가 존재하지 않습니다.");
		}
	}catch(Exception ex){
		out.println(ex.getMessage());
	}finally{
		if ( pstmt != null){
			pstmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}
%>

</body>
</html>
