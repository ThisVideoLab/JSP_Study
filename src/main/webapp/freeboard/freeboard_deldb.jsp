<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page import ="java.sql.*" %>
<%request.setCharacterEncoding("EUC-KR");%>
<%@ include file = "db_connection_oracle.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<link href = "filegb.css" rel = "stylesheet" type ="text/css">
<title>글 삭제 (실제 DataBase에 삭제를 처리하는 페이지)</title>
</head>
<body>
[<a href = "freeboard_list.jsp?go=<%= request.getParameter("page")%>"> 게시판 목록으로 이동</a>]
<p><p>

<%

	String sql = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int cnt = 0 ; // delete가 잘되었는지 확인하는 변수
	
	int id =Integer.parseInt(request.getParameter("id"));
	try{
		sql = "select * from freeboard where id = ?"; // DB의 비밀번호와 폼으로 넘겨받은 비밀번호를 비교하기 위한 정보를 확인
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,id);
		rs = pstmt.executeQuery();

		if(!(rs.next())){ // 존재하지 않는 경우
			out.println("해당 내용이 존재하지 않습니다");
		}else{ // 존재하는 경우 password가 서로 일치하면 삭제
			String pwd = rs.getString("password");
			if (pwd.equals(request.getParameter("password"))){
				sql = "delete freeboard where id = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,id);
				cnt = pstmt.executeUpdate();
				if (cnt > 0){
					out.println("해당 내용이 잘 삭제되었습니다.");
				}else{
					out.println("해당 내용이 존재하지 않습니다.");
				}
			}else{
				out.println("비밀번호가 일치하지 않습니다.");
			}
		}
		
	}catch(Exception ex){
		ex.getMessage();
	}finally{
		if(pstmt != null){
			pstmt.close();
		}
		if(rs != null){
			rs.close();
		}
		if(conn != null){
			conn.close();
		}
	}
	

%>
	
	
	
</body>
</html>