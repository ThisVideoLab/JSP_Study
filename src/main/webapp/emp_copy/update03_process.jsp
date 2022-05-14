<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update with MSSQL</title>
</head>
<body>

<%@ include file = "db_connection_MSSQL.jsp"%> <!--  오라클 데이터 서버에 접속하는 파일 불러오기 -->

<%
	// form에서 Request 객체의 getParameter 값으로 폼에서 넘긴 변수의 값을 받음.
	request.setCharacterEncoding("UTF-8"); //한글이 깨지지 않도록 알맞은 인코딩 값으로 처리
	
	String eno = request.getParameter("eno");
	String ename = request.getParameter("ename");
	String job = request.getParameter("job"); 
	String manager = request.getParameter("manager");
	String hiredate= request.getParameter("hiredate");
	String salary = request.getParameter("salary");
	String commission = request.getParameter("commission");
	String dno = request.getParameter("dno");
		
	Statement stmt = null;
	ResultSet rs = null;
	String sql = null;

	// 폼에서 넘겨받은 id와 password를 DB의 id와 password를 비교해서 같으면 업데이트를 실행하는 구문
	try{
		// 폼에서 넘겨받은 ID를 조건으로 해서 DB의 값(ID에 해당하는 컬럼)을 받아옴
		sql = "select eno, ename from emp_copy where eno = " + eno;
		stmt = conn.createStatement(); // conn 객체의 createStatement() 를 사용해서 stmt 객체를 활성화시킴.
		rs = stmt.executeQuery(sql); // DML 문에서 select 문만 특별하게 executeQuery문만을 사용함. 나머지는 그냥 실행만하면 되는데
									 // select는 결과 값을 다시 리턴해줘야하기 때문에 다르게 쓰이는 것임.
		 							 //stmt.excteUdate(sdl): insert, update, delete
				
		if(rs.next()){ // DB에 해당 폼에서 넘긴 ID가 존재한다면 ==> 폼에서 넘긴 패스워드와 DB의 패스워드가 일치되는지 확인해야 함
			//out.println("ID: " + id + "가 존재합니다.");

			//DB에서 값을 가지고 온 ID와 일치하는 DB내의 password를 변수에 할당함.
			String rs_eno = rs.getString("eno");
			String rs_ename = rs.getString("ename");
			
			//폼에서 넘겨준 값과 DB에서 가져온 값의 일치 여부를 확인하는 부분
			// SQL 변수의 재사용
						
			if(eno.equals(rs_eno)&&ename.equals(rs_ename)){ // ID 존재 여부는 이미 확인했기 때문에, 비밀번호만 조건으로 체크함 
				//DB에서 가져온 패스워드와 폼에서 넘겨받은 PASS값이 일치할 경우에 업데이트를 실행함
				
				sql = "update emp_copy set job = '" + job + "', manager = '" + manager + "', hiredate = '" + hiredate + "', salary = '" + salary + "', commission = '" + commission + "', dno = '" + dno + "' where eno = " + eno;
				stmt.executeUpdate(sql);
				out.println("업데이트에 성공하였습니다.");
				out.println("<br>");
				out.println(sql);
			}else{ // 패스워드가 일치하지 않을 때
				out.println("사원 번호와 사원명이 일치하지 않습니다.");
			}
				
		}else{ // DB에 해당 폼에서 넘긴 ID가 존재하지 않는다면,
			out.println(eno + " 에 해당하는 사원 번호가 존재하지 않습니다.");
		}
		
	}catch(Exception ex){
		out.println(ex.getMessage());
	}finally{
		if ( stmt != null){
			stmt.close();
		}
		if ( conn != null){
			conn.close();
		}
	}
%>

</body>
</html>