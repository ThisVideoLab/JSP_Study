<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert를 통한 정보 삽입</title>
</head>
<body>

<%@ include file = "db_connection_oracle.jsp" %>

<%  
	request.setCharacterEncoding("UTF-8");
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	String name = request.getParameter("name"); 
	String email = request.getParameter("email");
	String city = request.getParameter("city");
	String phone = request.getParameter("phone");
	
	PreparedStatement pstmt = null; 
	String sql = null;
	
	try{
		sql = "insert into mbTbl(idx, id, pass, name, email, city, phone) values(seq_mbTbl_idx.nextval,?,?,?,?,?,?)";
		// preparedStatement는 쿼리 내에서 ? 인자를 통해서 사용해서 변수를 처리할 수 있음.
		pstmt = conn.prepareStatement(sql); // preparedStatement는 항상 sql을 바로 집어넣어서 실행해야 함.
		
		pstmt.setString(1,id); // ? 인자 숫자에 맞춰서, getParameter로 가져온 원하는 변수 값을 넣어서 변수를 지정함.
		pstmt.setString(2,pass);
		pstmt.setString(3,name);
		pstmt.setString(4,email);
		pstmt.setString(5,city);
		pstmt.setString(6,phone);
		
		pstmt.executeUpdate(); // 그냥 statement에서는 괄호 안에 sql을 넣어줬지만 preparedStatement에서는 빼고 실행함. 
		out.println("테이블 삽입에 성공했습니다.");
		out.println("<p><p>");
		//out.println(sql);
		out.println("<p><p>");
		
	}catch(Exception e){
		out.println("mbTbl 테이블에 데이터 삽입을 하지 못하였습니다. SDFG");
		out.println(e.getMessage());
		out.println("<br><p>");
		// out.println(sql); 
	}finally{
		if ( pstmt != null){
			pstmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}
%>

ID: <%= id %> <p>
PASSWORD: <%= pass %> <p>
NAME: <%= name %> <p>
E-MAIL: <%= email %> <p>

<!--
SQL CODE:<%=sql %> <p> : html 블락에서 출력할 때. 아래 스크립트와 이 스크립트는 같은 내용임. 
SQL CODE: <% out.println(sql); %> : jsp 블락에서 출력할 때, '='과 'out.println'이 같은 기능을 함. 

-->



</body>
</html>