<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
 
 <%@ page import= "java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert�� ��� ������ </title>
<link href = "filegb.css" rel="stylesheet" type="text/css">

</head>
<body>
	<%@ include file = "db_connection_oracle.jsp" %>

<%
	//Vector �÷����� �����ؼ� DB���� ������ �����͸� �����ϴ� Vector ��ü ���� 
	Vector name = new Vector(); 	//�̸� �÷��� �����ϴ� ���� 
	Vector email = new Vector(); 
	Vector inputdate= new Vector(); 
	Vector subject = new Vector(); 
	Vector content = new Vector(); 
	
	//����¡ ó���� ���� ���� 
	int where = 1; 				//���� ��ġ�� page ��ȣ 
	int totalgroup = 0; 		//������ �׷��� ���� 
	int maxpage = 5 ;  			//����� ������ ���� 
	int startpage = 1; 			//����� �������� ù��° ���ڵ� 
	int endpage = startpage + maxpage - 1; //��� �������� ������ ���ڵ� 
	int wheregroup = 1; 		//���� ��ġ�� pagegroup 
	
	//Get ������� �������� ���� ������ go (���� ������), 
			//gogroup(���� ������ �׷�) ������ �޾ ó���� ��. 
	
	if (request.getParameter("go") != null){  //���� ������ ��ȣ�� �Ѿ�ö�
		where = Integer.parseInt(request.getParameter("go")); 
		wheregroup = (where-1)/maxpage +1; 
		startpage = (wheregroup - 1) * maxpage +1;
		endpage = startpage + maxpage -1; 
		
	}else if (request.getParameter("gogroup") != null){ //���� ������ �׷��� ��ȣ�� �Ѿ�ö�
		wheregroup = Integer.parseInt(request.getParameter("gogroup"));
		startpage = (wheregroup - 1) * maxpage +1 ; 
		where = startpage; 
		endpage = startpage + maxpage -1; 
	}
	
	int nextgroup  = wheregroup + 1 ; // [����]   ��ũ�ɸ� ����  <== pagegroup
	int priorgroup = wheregroup -1 ;  // [����]	 ��ũ�ɸ� ����  <== pagegroup
	
	int nextpage = where +1;   //���� ������    
	int priorpage = where -1;  //���� ������
	
	int startrow = 0;    //Ư�� ���������� ���� ���ڵ� ��ȣ
	int endrow = 0;      //Ư�� ���������� ������ ���ڵ� ��ȣ
	
	int maxrows = 5;     //��½� 2���� ���ڵ常 ��� 
	int totalrows = 0; 		//�� ���ڵ� ���� (DB)
	int totalpages = 0 ;
	

	String sql = null; 
	Statement st = null; 
	ResultSet rs = null; 		//Select �� ��� ���ڵ� ���� ��� ��ü 
		
	try {
		sql = "select * from guestboard order by inputdate desc"; 
		st = conn.createStatement(); 
		rs = st.executeQuery(sql);
		
	if ( !(rs.next())){   //DB�� ���� �������� ������ 
		out.println ("���α׿� �ø� ���� �����ϴ�. "); 
	}else {     // DB���� ������ ���� ��� ���� 
		do {        //DB���� ������ ���� Vector�� ���� �� ���ϴ� ��������ȣ�� ������ ���Ϳ��� 
					//������ �´�. 
			name.addElement(rs.getString("name")); 
			email.addElement(rs.getString("email")); 
			inputdate.addElement(rs.getString("inputdate")); 
			subject.addElement(rs.getString("subject")); 
			content.addElement(rs.getString("content")); 					
					
		}while (rs.next());   //rs�� ���� �����ϴµ��� ��� ��ȯ�ϸ鼭 ���.
		
		//����� ������ ������ ���� 
		totalrows = name.size();  //���Ϳ� ����� �� �� (DB�� �� ���ڵ� ���� )
		totalpages = (totalrows - 1) / maxrows + 1; 
		startrow = (where -1) * maxrows ; 			//Ư�� ���������� ���� row 
		endrow = startrow + maxrows -1; 			//Ư�� ���������� ������ row 
		
		
		if (endrow >= totalrows)
			endrow = totalrows - 1; 
		
		totalgroup = (totalpages - 1) / maxpage + 1;   //totalgroup �� �����ϴ� ����  
		if (endpage > totalpages)
			endpage = totalpages; 
		
		for (int j=startrow ; j <= endrow ; j++){   //for�� ����
			//���Ϳ� ����� ���� �����ͼ� ���. 
			%>
		<table width ="600" border ="1"> 
		<tr><td colspan = "2" align="center"> <h3><%= subject.elementAt(j) %><h3></h3> </td> </tr>
		<tr><td>�۾��� : <%= name.elementAt(j) %></td>
			<td>email : <%= email.elementAt(j) %></td> </tr>		
		<tr><td colspan ="2"> �۾���¥ : <%= inputdate.elementAt(j) %></td> </tr>
		<tr><td colspan = "2" width="600"><%= content.elementAt(j) %></td> </tr>
		</table> <p><p>
			
			
		<% 
		}  //for �� �� 
		
		// out.println ("startrow : " + startrow + "<p>"); 
		// out.println ("endrow : " + endrow + "<p>");
		
		//����¡ ��� �κ� ó�� 
		
		if (wheregroup > 1){    //wheregroup > 1 �̻��϶� 
			out.println ("[ <A href= \"blog_show.jsp?go=1\"> ó�� </A> ]"); 
			out.println ("[ <A href= \"blog_show.jsp?gogroup=" + priorgroup + "\"> ���� </A> ]"); 
		}else {  
			out.println ("[ó��]");
			out.println ("[����]"); 
		}
		
		//����¡ ��� 
		for (int jj=startpage; jj <= endpage; jj++){
			if (jj==where)
				out.println("[" + jj + "]"); 
			else 
				out.println ("[<A href= \"blog_show.jsp?go="+jj+"\">" + jj + "</A>]"); 		
		}
		
		if (wheregroup < totalgroup){
			out.println ("[ <A href= \"blog_show.jsp?gogroup=" + nextgroup + "\"> ���� </A> ]"); 
			out.println ("[ <A href= \"blog_show.jsp?gogroup=" + totalgroup + "\"> ������ </A> ]");
		} else {
			out.println ("[����]");
			out.println ("[������]"); 
		}
		out.println (where + "/" + totalpages); 
		

	}      // DB���� ������ ���� ��� ��  
		
	}catch (Exception ex){
		out.println(ex.getMessage()); 
	}finally {
		if (rs != null)
			rs.close(); 
		if (st != null)
			st.close(); 
		if (conn != null)
			conn.close(); 
		
	}
		
%>	
	
	
</body>
</html>