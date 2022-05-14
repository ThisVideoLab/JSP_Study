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

<%@ include file = "db_connection_oracle.jsp" %>  <!--dbconn_oracle.jsp   파일의 코드를 그대로 내포 -->

<%  
	request.setCharacterEncoding("UTF-8"); // 폼에서 넘긴 한글을 처리하기 위한 구문
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	String name = request.getParameter("name"); 
	String email = request.getParameter("email");
	String city = request.getParameter("city");
	String phone = request.getParameter("phone");
	
	Statement stmt = null; // Statement 객체: SQL 쿼리 구문을 담아서 실행하는 객체 
	String sql = null; // 원래 작성은 try 문 안에 지역변수로 적어줬지만, 이렇게 전역 변수로 꺼내줄 수도 있음.
	
	try{
		sql = "insert into mbTbl(idx, id, pass, name, email, city, phone) values(seq_mbTbl_idx.nextval, '"+ id +"','"+ pass + "','" + name + "','" + email + "','" + city + "','" + phone + "')";
		stmt = conn.createStatement(); // connection 객체를 통해 Statement 객체를 생성함
		stmt.executeUpdate(sql);	// Statement를 통해서 SQL을 실행함
			// stmt.executeUpdate(sql) : sql <== insert, update, delete
			// stmt.executeQuery(sql) : sql <== select 문이 오면서 결과값을 Resultset 객체로 반환함.
			
		out.println("테이블 삽입에 성공했습니다.");
		out.println("<p><p>");
		//out.println(sql);
		out.println("<p><p>");
		
	}catch(Exception e){
		out.println("mbTbl 테이블에 데이터 삽입을 하지 못하였습니다. SDFG");
		out.println(e.getMessage());
		out.println("<br><p>"); // 이러한 식으로  html 태그 또한 찍어줄 수 있음.
		// out.println(sql); 
	}finally{
		if ( stmt != null){
			stmt.close();
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

SQL CODE:<%=sql %> <p> <!-- html 블락에서 출력할 때. 아래 스크립트와 이 스크립트는 같은 내용임. -->
SQL CODE: <% out.println(sql); %> <!-- jsp 블락에서 출력할 때, '='과 'out.println'이 같은 기능을 함. -->



</body>
</html>