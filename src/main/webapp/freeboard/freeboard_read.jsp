<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*, java.util.*, java.text.*" %>
<% request.setCharacterEncoding("EUC-KR"); %> <!--  �ѱ� ó�� -->
 
<%@include file = "db_connection_oracle.jsp"%> <!-- �������� �о�鿩�� �ϹǷ� ����ũ Ŀ�ؼ� ���� �ۼ� --> 
 
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>�÷��� Ư�� ���ڵ带 �д� ������</title>
</head>
<body>


<%
	String sql = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	int id = Integer.parseInt(request.getParameter("id"));

	/*
	-----������ �� �Ѿ���� üũ�ϴ� �ڵ� ����
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	out.println(id + "<p>");
	out.println(name + "<p>");
	out.println(email);
	if(true) return; // ���α׷��� ���⿡�� ����. ���� �̷��� ¥�� �� ���� �ڵ常 üũ�� �����ϱ� ������ ����뿡 ���� ��.
	----- ������ �� �Ѿ���� üũ�ϴ� �ڵ� ����
	 */
	try{
		
		sql = "SELECT * FROM freeboard WHERE id = ?";
		pstmt =conn.prepareStatement(sql);
		pstmt.setInt(1, id);
		rs = pstmt.executeQuery();
		
		if(!(rs.next())){	//���� �������� �ʴ� ���
			out.println("�����ͺ��̽��� �ش� ������ �����ϴ�. ");
		}else{				//���� �����ϴ� ���, rs�� ������ ȭ�鿡 ���
			//out.println("�����ͺ��̽��� ���� ���� �մϴ�. ");
		
			String em = rs.getString("email");
			if((em != null) && (!(em.equals("")))){ //DB�� email �÷��� ���� �����ϸ�
				em = "<A href = mailto:"+ em + ">"+rs.getString("name")+"</A>";
				// �� ������ �� ���� �״�� �־����. �׷��� ������ ���� �ٷ� ������
			}else{	//���� �ּ��� ���� ��������� �̸��� ��� 
				em = rs.getString("name");
			}
			
			//out.println(em);
			
			//���� ���, ���� : JAVA���� ���������� ��� �Ҽ� �ִ� Java ������
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
			   out.println("<td width='51%' height='7'>�۾��� : "+ em +"</td>");
			   out.println("<td width='25%' height='7'></td>");
			   out.println("<td width='11%' height='7'></td>");
			   out.println("</tr>");
			   out.println("<tr bgcolor='#F4F4F4'>");
			   out.println("<td width='13%'></td>");
			   out.println("<td width='51%'>�ۼ��� : " + rs.getString("inputdate") + "</td>");
			   out.println("<td width='25%'>��ȸ : "+(rs.getInt("readcount")+1)+"</td>");
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
	  // ��ȸ�� ī���� �κ�, ���ΰ�ħ�� ������, �ڵ����� �� �������� ����ǹǷ� ����ؼ� 1�� �ö�
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
