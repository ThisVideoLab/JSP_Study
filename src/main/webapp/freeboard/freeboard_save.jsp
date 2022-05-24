<%@ page language="java" contentType="text/html; charset=EUC-KR"
		pageEncoding="EUC-KR"%>
    
<%@ page import = "java.sql.*, java.util.*, java.text.*" %>
<% request.setCharacterEncoding("EUC-KR"); %> <!--  한글 처리 -->

<%@include file = "db_connection_oracle.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>폼 값을 받아서 DataBase에 값을 넣어주는 파일</title>
</head>
<body>

<%
	// 폼에서 넘긴 변수를 받아서 저장하는 부분
	String na = request.getParameter("name");
	String em = request.getParameter("email");
	String sub = request.getParameter("subject");
	String cont = request.getParameter("content");
	String pw = request.getParameter("password");
	
	int id = 1; // db에 id컬럼에 저장할 값
	int pos = 0; //
	if (cont.length()==1) 
		cont = cont + " ";
	
	
	//content (Text Area)에 엔터를 처리해줘야 함. 엔터값을 db에 저장했다가 다시 불러오기 위한 처리과정
	
	while((pos = cont.indexOf("\'",pos)) != -1){
		String left = cont.substring (0, pos);
		String right = cont.substring(pos,cont.length());
		cont = left + "\'" + right;
		pos += 2;
	}
		
	// 오늘의 날짜를 처리하는 코드 (다양한 포멧이 있음. 이것은 그 중 하나)
	java.util.Date yymmdd = new java.util.Date(); 
	SimpleDateFormat myformat = new SimpleDateFormat("yy-mm-d h:mm a"); 
	String ymd = myformat.format(yymmdd);
	
	String sql = null;
	Statement st = null;
	ResultSet rs = null;
	int cnt = 0; // insert가 잘 되었는지 확인하는 변수
	
	try{
		
		// 값을 저장하기 전에 최신 글번호를 가져와서 +1을 적용한다. 시퀀스 장착해도 되고, 변수를 넣어서 점증시켜도 됨.
		// 이 쿼리문에서는 max(id) 값을 가져와서 +1을 적용함. 
		// connection 객체인 conn에 오토 커밋이 적용되어 있음. 고로 커밋을 명시하지 않아도 자동으로 변경사항이 반영됨.
		st = conn.createStatement();
		sql = "select max (id) from freeboard";
		rs = st.executeQuery(sql); // sql 구문이 선언과 값 할당 동시에 들어가는 preparedStatement 구문에서는 executeQuery() 코드에
								   // sql 값이 들어가지 않아야 작동한다는 것을 염두해두자.
			if (!(rs.next())){ // rs의 값이 비어있다면, rs는 실행되면 항상 값을 가지게 됨. 즉 값이없다는건 첫번째 글이 작성되지 않았다는 것
				id = 1; // 아무 글도 없으니까, 이제 막 작성하는 글에 대해 1번을 달아줌
			}else{ // rs 값이 비어있지 않다면, 즉 한개라도 글을 써놓았다면
				id = rs.getInt(1) + 1; // 최대값 + 1
			}
		
		sql = "insert into freeboard (id,name,password,email,subject, "; 
		sql = sql + "content, inputdate, masterid, readcount, replynum, step)";
		sql = sql + "values (" + id + ", '" + na + "', '" + pw + "', '" + em;
		sql = sql + "','" + sub + "','" + cont + "','" + ymd  + "'," + id + ",";
		sql = sql + "0,0,0)";
		
		// out.println(sql); // 이 코드로 출력되는 쿼리문을 그대로 sql에 넣어서 정상 작동하는지 체크할 때 사용함
		
		cnt = st.executeUpdate(sql); // insert가 잘 되었는지 확인하는 구문, cnt가 0 이상이면 성공(하나라도 바뀌었다는 뜻이므로)
		if(cnt>0)
			out.println("data가 성공적으로 입력되었습니다");
		else
			out.println("data가 입력되지 않았습니다.");
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

<jsp:forward page="freeboard_list.jsp" /> <!-- 이 코드가 실행되면 뒤에 있는 페이지 중에서 해당 이름을 가진 파일로 이동해서 실행을 이어나감  
											   원래는 /제이에스피:포워드를 써서 닫아줘야하나 저렇게 약식으로 마지막 /로 생략가능함
											   오류가 나서 한글로만 써놨으니 참고할 것-->

-->

<!-- 주석에서 스크립트 충돌이 나서 한글로만 작성함 대충 알아들을 것
	제이에스피:포워드: 서버단에서 페이지를 이동시킴, 클라이언트의 기존의 URL 정보가 바뀌지 않는다.
	respond.sendRedirect:  클라이언트에서 페이지를 재요청해서 페이지를 이동시킴. 이 때 이동하는 페이지로 URL이 변경됨.
	respond.sendRedirect("freeboard_list.jsp?go=" + request.getParametor("page")
	그래서 지금 만드는 게시판 내에서도 서버단의 페이지 이동인지, 클라이언트의 요청에 의한 이동인지에 따라 주소 바뀌는 패턴이 나뉨
 -->

</body>
</html>