<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
 
 <%@ page import = "java.sql.*, java.util.*" %> 
 
 <% request.setCharacterEncoding("EUC-KR"); %>   <!-- Form���� �Ѱ��ִ� �ѱ� ó��  -->
      
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>form���� �Ѱ� ���� ���� DB�� insert �ϴ� ������ </title>
</head>
<body>
<%@ include file = "db_connection_oracle.jsp" %>   <!-- Connection ��ü  -->
<%
	String na = request.getParameter("name"); 
	String em = request.getParameter("email"); 
	String sub = request.getParameter("subject"); 
	String cont = request.getParameter("content"); 
	String ymd = (new java.util.Date()).toLocaleString();  //���� �ý����� ������(�ѱ�)

	//������ �ѱ� ������ �� �Ѿ������ Ȯ�� 
	
	/* 
	out.println (na + "<p>"); 
	out.println (em + "<p>"); 
	out.println (sub + "<p>"); 
	out.println (cont + "<p>"); 
	out.println (ymd + "<p>"); 
	*/
	
	String sql = null; 
	Statement st = null;    //Statement : sql ������ �����ϴ� ��ü
			//conn ��ü���� �ڵ����� Ŀ�� ������ ����Ǿ� ����. 
	int cnt = 0 ; 	//insert, update, delete �� �� ����Ǿ����� Ȯ�� 
					// cnt > 0  : insert, update, delete �� �� ����Ǿ����� Ȯ��
	
	try{
		sql = "insert into guestboard (name, email,inputdate, subject, content)"; 
		sql = sql + " values('" + na + "','" + em + "','" + ymd  ;
		sql = sql + "','" + sub + "','" +  cont + "')"; 
		
		st = conn.createStatement();    //st : Statement ��ü Ȱ��ȭ  (XE, hr2, 1234)
		
		cnt = st.executeUpdate(sql); //insert, update, delete�� UPDATE ���, QUERY�� SLECT ���� 
		
	}catch (Exception ex) {
		out.println (ex.getMessage()); 
	}finally{
		if (st !=null)
			st.close(); 
		if (conn != null)
			conn.close(); 
	}
	
%>

<jsp:forward page = "blog_show.jsp" /> 

</body>
</html>