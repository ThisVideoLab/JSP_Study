<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page import = "java.sql.*, java.util.*, java.text.*" %>
<% request.setCharacterEncoding("EUC-KR"); %> <!--  �ѱ� ó�� -->

<%@include file = "db_connection_oracle.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>�� ���� �޾Ƽ� DataBase�� ���� �־��ִ� ����</title>
</head>
<body>

<%
	// ������ �ѱ� ������ �޾Ƽ� �����ϴ� �κ�
	String na = request.getParameter("name");
	String em = request.getParameter("email");
	String sub = request.getParameter("subject");
	String cont = request.getParameter("content");
	String pw = request.getParameter("password");
	
	int id = 1; // db�� id�÷��� ������ ��
	int pos = 0; //
	if (cont.length()==1) 
		cont = cont + " ";
	
	
	//content (Text Area)�� ���͸� ó������� ��. ���Ͱ��� db�� �����ߴٰ� �ٽ� �ҷ����� ���� ó������
	
	while((pos = cont.indexOf("\'",pos)) != -1){
		String left = cont.substring (0, pos);
		String right = cont.substring(pos,cont.length());
		cont = left + "\'" + right;
		pos += 2;
	}
		
	// ������ ��¥�� ó���ϴ� �ڵ� (�پ��� ������ ����. �̰��� �� �� �ϳ�)
	
	java.util.Date yymmdd = new java.util.Date(); 
	SimpleDateFormat myformat = new SimpleDateFormat("yy-mm-d h:mm a"); 
	String ymd = myformat.format(yymmdd);
	
	String sql = null;
	Statement st = null;
	ResultSet rs = null;
	int cnt = 0; // insert�� �� �Ǿ����� Ȯ���ϴ� ����
	
	try{
		
		// ���� �����ϱ� ���� �ֽ� �۹�ȣ�� �����ͼ� +1�� �����Ѵ�. ������ �����ص� �ǰ�, ������ �־ �������ѵ� ��.
		// �� ������������ max(id) ���� �����ͼ� +1�� ������. 
		// connection ��ü�� conn�� ���� Ŀ���� ����Ǿ� ����. ��� Ŀ���� ������� �ʾƵ� �ڵ����� ��������� �ݿ���.
		st = conn.createStatement();
		sql = "select max (id) from freeboard";
		rs = st.executeQuery(sql); // sql ������ ����� �� �Ҵ� ���ÿ� ���� preparedStatement ���������� executeQuery() �ڵ忡
								   // sql ���� ���� �ʾƾ� �۵��Ѵٴ� ���� �����ص���.
			if (!(rs.next())){ // rs�� ���� ����ִٸ�, rs�� ����Ǹ� �׻� ���� ������ ��. �� ���̾��ٴ°� ù��° ���� �ۼ����� �ʾҴٴ� ��
				id = 1; // �ƹ� �۵� �����ϱ�, ���� �� �ۼ��ϴ� �ۿ� ���� 1���� �޾���
			}else{ // rs ���� ������� �ʴٸ�, �� �Ѱ��� ���� ����Ҵٸ�
				id = rs.getInt(1) + 1; // �ִ밪 + 1
			}
		
		sql = "insert into freeboard (id,name,password,email,subject, "; 
		sql = sql + "content, inputdate, masterid, readcount, replynum, step)";
		sql = sql + "values (" + id + ", '" + na + "', '" + pw + "', '" + em;
		sql = sql + "','" + sub + "','" + cont + "','" + ymd  + "'," + id + ",";
		sql = sql + "0,0,0)";
		
		// out.println(sql); // �� �ڵ�� ��µǴ� �������� �״�� sql�� �־ ���� �۵��ϴ��� üũ�� �� �����
		
		cnt = st.executeUpdate(sql); // insert�� �� �Ǿ����� Ȯ���ϴ� ����, cnt�� 0 �̻��̸� ����(�ϳ��� �ٲ���ٴ� ���̹Ƿ�)
		if(cnt>0)
			out.println("data�� ���������� �ԷµǾ����ϴ�");
		else
			out.println("data�� �Էµ��� �ʾҽ��ϴ�.");
			st.close();
			conn.close();
		
		
	}catch(Exception ex){
		out.println(ex.getMessage());
	}finally{
		if (rs != null){
			rs.close();
		}
		if (conn != null){
			conn.close();
		}
	}

%>

<jsp:forward page="freeboard_list.jsp" />
<!--  jsp:forward : �� �ڵ尡 ����Ǹ� �ڿ� �ִ� ������ �߿��� �ش� �̸��� ���� ���Ϸ� �̵��ؼ� ������ �̾�� -->

</body>
</html>