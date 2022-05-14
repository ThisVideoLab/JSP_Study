<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PreparedStatement를 사용한 Data Insert</title>
</head>
<body>

<%@ include file = "db_connection_oracle.jsp" %>

<%  
	request.setCharacterEncoding("UTF-8");
	
	String eno = request.getParameter("eno");
	String ename = request.getParameter("ename");
	String job = request.getParameter("job"); 
	String manager = request.getParameter("manager");
	String hiredate= request.getParameter("hiredate");
	String salary = request.getParameter("salary");
	String commission = request.getParameter("commission");
	String dno = request.getParameter("dno");
	
	PreparedStatement pstmt = null; 
	String sql = null;
	
	try{
		sql = "insert into emp_copy(eno, ename, job, manager, hiredate, salary, commission, dno) values(?,?,?,?,?,?,?,?)";
		// preparedStatement는 쿼리 내에서 ? 인자를 통해서 사용해서 변수를 처리할 수 있음.
		pstmt = conn.prepareStatement(sql); // preparedStatement는 항상 sql을 바로 집어넣어서 실행해야 함.
		
		pstmt.setString(1,eno);
		pstmt.setString(2,ename);
		pstmt.setString(3,job);
		pstmt.setString(4,manager);
		pstmt.setString(5,hiredate);
		pstmt.setString(6,salary);
		pstmt.setString(7,commission);
		pstmt.setString(8,dno);
		
		pstmt.executeUpdate(); 
		out.println("테이블 삽입에 성공했습니다.");
		out.println("<p><p>");
		out.println(sql);
		out.println("<p><p>");
		
	}catch(Exception e){
		out.println("emp_copy 테이블에 데이터 삽입을 하지 못하였습니다.");
		out.println(e.getMessage());
		out.println("<br><p>");
		out.println(sql); 
	}finally{
		if ( pstmt != null){
			pstmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}
%>

ENO: <%= eno %> <p>
ENAME: <%= ename %> <p>
JOB: <%= job %> <p>
MANAGER: <%= manager %> <p>
HIREDATE: <%= hiredate %> <p>
SALARY: <%= salary %> <p>
COMMISSION: <%= commission %> <p>
DNO: <%= dno %> <p>

<!--
SQL CODE:<%=sql %> <p> : html 블락에서 출력할 때. 아래 스크립트와 이 스크립트는 같은 내용임. 
SQL CODE: <% out.println(sql); %> : jsp 블락에서 출력할 때, '='과 'out.println'이 같은 기능을 함. 

-->



</body>
</html>