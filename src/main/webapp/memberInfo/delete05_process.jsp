<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete를 통한 정보 삭제</title>
</head>
<body>

<%@ include file = "db_connection_oracle.jsp" %>

<%  
	request.setCharacterEncoding("UTF-8");
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	
	PreparedStatement pstmt = null; //
	ResultSet rs = null;
	String sql = null; // 원래 작성은 try 문 안에 지역변수로 적어줬지만, 이렇게 전역 변수로 꺼내줄 수도 있음.
	
	
	try{
		// 레코드 삭제, 폼에서 넘긴 ID와 PASSWORD와 DB에 있는 ID와 PASSWORD가 일치할 때 레코드 제거, id(Primary key 컬럼)
		sql = "select id, pass from mbTbl where id = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1,id);
		rs = pstmt.executeQuery();
		
		if (rs.next()){ // ID가 존재할 때
			//rs 결과의 레코드를 변수에 할당함
			String rs_id = rs.getString ("id");
			String rs_pass = rs.getString ("pass");
			
			// 할당된 변수값들을 가지고 패스워드가 일치하는지 확인
			if(pass.equals(rs_pass)){ // 폼에서 받은 password와 DB에 담긴 password가 일치한다면
				sql = "delete mbTbl where id = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,id);
				pstmt.executeUpdate(); // stmt.executeQuery(sql); 
				
				out.println("테이블에서 " + id + " ID가 성공적으로 삭제되었습니다.");
				out.println("<BR><BR>");
				out.println("SQL CODE: " + sql);
				
			}else{
				out.println("패스워드가 일치하지 않습니다.");
				out.println("SQL CODE: " + sql);
			}
			
		}
	}catch(Exception e){
		out.println("mbTbl 테이블에 데이터 삽입을 하지 못하였습니다. SDFG");
		out.println(e.getMessage());
		out.println("<br><p>"); // 이러한 식으로  html 태그 또한 찍어줄 수 있음.
		out.println("실행된 SQL CODE: " + sql); 
	}finally{
		if ( pstmt != null){
			pstmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}
	out.println("<br><p>");
	out.println("--------------------------");
	out.println("<br><p>");
%>

ID: <%= id %> <p>
PASSWORD: <%= pass %> <p>

<!--
SQL CODE:<%=sql %> <p> : html 블락에서 출력할 때. 아래 스크립트와 이 스크립트는 같은 내용임. 
SQL CODE: <% out.println(sql); %> : jsp 블락에서 출력할 때, '='과 'out.println'이 같은 기능을 함. 
-->



</body>
</html>