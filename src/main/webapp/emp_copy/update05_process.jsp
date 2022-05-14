<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ page import = "java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PreparedStatement를 통한 Data Update</title>
</head>
<body>

<%@ include file = 'db_connection_oracle.jsp'%>

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
	ResultSet rs = null;
	String sql = null;
	
	try{
		sql = "select eno, ename from emp_copy where eno = ?";
		pstmt = conn.prepareStatement(sql); // 변수 선언 및 값 할당 단계에서 SQL을 넣어줘야 함.
		pstmt.setString(1,eno);
		rs = pstmt.executeQuery(); // pstmt 선언 단계에서 sql을 넣어줬기 때문에 다시 sql을 넣지 말아야 함. 
				
		if(rs.next()){
			String rs_eno = rs.getString("eno");
			String rs_ename = rs.getString("ename");
			
			if(eno.equals(rs_eno)&&ename.equals(rs_ename)){ 
				sql = "update emp_copy set ename = ?, job = ?, manager = ?, hiredate = ?, salary = ?, commission = ?, dno = ? where eno =" + eno;
				pstmt = conn.prepareStatement(sql); // 변수 선언 및 값 할당 단계에서 SQL을 넣어줘야 함.
				
				pstmt.setString(1,ename);
				pstmt.setString(2,job);
				pstmt.setString(3,manager);
				pstmt.setString(4,hiredate);
				pstmt.setString(5,salary);
				pstmt.setString(6,commission);
				pstmt.setString(7,dno);
				
				pstmt.executeUpdate();
				out.println("업데이트에 성공하였습니다.");
				out.println("<br><p>");
				out.println(sql);
			}else{
				out.println("사번 " + eno + "과(와) 사원명 " + ename + " 이 일치하지 않습니다.");
			}
		}else{
			out.println(eno + "에 해당하는 사번이 존재하지 않습니다.");
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
