<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*, java.util.*, java.text.*" %>
<% request.setCharacterEncoding("EUC-KR"); %> <!--  한글 처리 -->
 
<%@include file = "db_connection_oracle.jsp"%> <!-- 서버에서 읽어들여야 하므로 오라크 커넥션 구문 작성 --> 
 
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>컬럼의 특정 레코드를 읽는 페이지</title>
</head>
<body>


<%
	String sql = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	int id = Integer.parseInt(request.getParameter("id"));

	/*
	-----변수값 잘 넘어가는지 체크하는 코드 시작
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	out.println(id + "<p>");
	out.println(name + "<p>");
	out.println(email);
	if(true) return; // 프로그램을 여기에서 멈춤. 보통 이렇게 짜면 이 위쪽 코드만 체크가 가능하기 때문에 디버깅에 많이 씀.
	----- 변수값 잘 넘어가는지 체크하는 코드 종료
	 */
	try{
		
		sql = "SELECT * FROM freeboard WHERE id = ?";
		pstmt =conn.prepareStatement(sql);
		pstmt.setInt(1, id);
		rs = pstmt.executeQuery();
		
		if(!(rs.next())){	//값이 존재하지 않는 경우
			out.println("데이터베이스에 해당 내용이 없습니다. ");
		}else{				//값이 존재하는 경우, rs의 값들을 화면에 출력
			//out.println("데이터베이스에 값이 존재 합니다. ");
		
			String em = rs.getString("email");
			if((em != null) && (!(em.equals("")))){ //DB의 email 컬럼의 값이 존재하면
				em = "<A href = mailto:"+ em + ">"+rs.getString("name")+"</A>";
				// 이 구문은 이 형태 그대로 넣어야함. 그렇지 않으면 오류 바로 떠버림
			}else{	//메일 주소의 값이 비어있을때 이름만 출력 
				em = rs.getString("name");
			}
			
			//out.println(em);
			
			//서블릿 출력, 서블릿 : JAVA에서 웹페이지를 출력 할수 있는 Java 페이지
			out.println("<table width='600' cellspacing='0' cellpadding='2' align='center'>");
			out.println("<tr>");
			   out.println("<td height='22'>&nbsp;</td></tr>");
			   out.println("<tr align='center'>");
			   out.println("<td height='1' bgcolor='#1F4F8F'></td>");
			   out.println("</tr>");
			   out.println("<tr align='center' bgcolor='#DFEDFF'>");
			   out.println("<td class='button' bgcolor='#DFEDFF'>"); 
			   out.println("<div align='left'><font size='2'>"+rs.getString("subject") + "</div> </td>");
			   out.println("</tr>");
			   out.println("<tr align='center' bgcolor='#FFFFFF'>");
			   out.println("<td align='center' bgcolor='#F4F4F4'>"); 
			   out.println("<table width='100%' border='0' cellpadding='0' cellspacing='4' height='1'>");
			   out.println("<tr bgcolor='#F4F4F4'>");
			   out.println("<td width='13%' height='7'></td>");
			   out.println("<td width='51%' height='7'>글쓴이 : "+ em +"</td>");
			   out.println("<td width='25%' height='7'></td>");
			   out.println("<td width='11%' height='7'></td>");
			   out.println("</tr>");
			   out.println("<tr bgcolor='#F4F4F4'>");
			   out.println("<td width='13%'></td>");
			   out.println("<td width='51%'>작성일 : " + rs.getString("inputdate") + "</td>");
			   out.println("<td width='25%'>조회 : "+(rs.getInt("readcount")+1)+"</td>");
			   out.println("<td width='11%'></td>");
			   out.println("</tr>");
			   out.println("</table>");
			   out.println("</td>");
			   out.println("</tr>");
			   out.println("<tr align='center'>");
			   out.println("<td bgcolor='#1F4F8F' height='1'></td>");
			   out.println("</tr>");
			   out.println("<tr align='center'>");
			   out.println("<td style='padding:10 0 0 0'>");
			   out.println("<div align='left'><br>");
			   out.println("<font size='3' color='#333333'><PRE>"+rs.getString("content") + "</PRE></div>");
			   out.println("<br>");
			   out.println("</td>");
			   out.println("</tr>");
			   out.println("<tr align='center'>");
			   out.println("<td class='button' height='1'></td>");
			   out.println("</tr>");
			   out.println("<tr align='center'>");
			   out.println("<td bgcolor='#1F4F8F' height='1'></td>");
			   out.println("</tr>");
			   out.println("</table>");
			  %>
		
	  <table width="600" border="0" cellpadding="0" cellspacing="5" align="center">
	  <tr> 
	  <td align="right" width="450"><A href="freeboard_list.jsp?go=<%=request.getParameter("page") %>"> 
	  <img src="image/list.jpg" border=0></a></td>
	  <td width="70" align="right"><A href="freeboard_rwrite.jsp?id=<%= request.getParameter("id")%>&page=<%=request.getParameter("page")%>"> <img src="image/reply.jpg" border=0></A></td>
	  <td width="70" align="right"><A href="freeboard_upd.jsp?id=<%=id%>&page=1"><img src="image/edit.jpg" border=0></A></td>
	  <td width="70" align="right"><A href="freeboard_del.jsp?id=<%=id%>&page=1"><img src="image/del.jpg"  border=0></A></td>
	  </tr>
	  </table>
	  <%    
 	  sql = "update freeboard set readcount= readcount + 1 where id= ?" ;
	  // 조회수 카운터 부분, 새로고침할 때마다, 자동으로 이 쿼리문이 실행되므로 계속해서 1씩 올라감
	  pstmt = conn.prepareStatement(sql);
 	  pstmt.setInt(1, id);
 	  pstmt.executeUpdate();
 	  }
		rs.close();
		pstmt.close();
		conn.close();
	} catch (SQLException e) {
		out.println(e);
	} 
%>
</body>
</html>
