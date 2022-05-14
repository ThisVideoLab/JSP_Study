<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert with oracle</title>
</head>
<body>

<%@ include file = "db_connection_oracle.jsp" %>  <!--dbconn_oracle.jsp   파일의 코드를 그대로 내포 -->

<%  
	request.setCharacterEncoding("UTF-8"); // 폼에서 넘긴 한글을 처리하기 위한 구문
	
	String eno = request.getParameter("eno");
	String ename = request.getParameter("ename");
	String job = request.getParameter("job"); 
	String manager = request.getParameter("manager");
	String hiredate= request.getParameter("hiredate");
	String salary = request.getParameter("salary");
	String commission = request.getParameter("commission");
	String dno = request.getParameter("dno");
		
	Statement stmt = null; // Statement 객체: SQL 쿼리 구문을 담아서 실행하는 객체 
	
	try{
		String sql = "insert into emp_copy(eno, ename, job, manager, hiredate, salary, commission, dno) values("+ eno +",'"+ ename + "','" + job + "'," + manager + ",'" + hiredate + "'," + salary + "," + commission + "," + dno + ")";
		stmt = conn.createStatement(); // connection 객체를 통해 Statement 객체를 생성함
		stmt.executeUpdate(sql);	// Statement를 통해서 SQL을 실행함
			// stmt.executeUpdate(sql) : sql <== insert, update, delete
			// stmt.executeQuery(sql) : sql <== select 문이 오면서 결과값을 Resultset 객체로 반환함.
			
		out.println(" successfull data insulting into table");
		out.println("<p><p>");
			
	}catch(Exception e){
		out.println("data insulting failure");
		out.println("<p><p>");
		out.println(e.getMessage());
		out.println("<p><p>");
				
	}finally{
		if ( stmt != null){
			stmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}
%>

employee number: <%= eno %> <p>
employee name: <%= ename %> <p>
job: <%= job %> <p>
manager: <%= manager %> <p>
hiredate: <%= hiredate %> <p>
salary: <%= salary %> <p>
commission: <%= commission %> <p>
dno: <%= dno %> <p>

</body>
</html>