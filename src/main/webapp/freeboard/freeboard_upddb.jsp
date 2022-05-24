<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.sql.*" %> 
<% request.setCharacterEncoding("euc-kr"); %>
<HTML>
<HEAD><TITLE>글 수정하기</TITLE></HEAD>
<BODY>
<%@ include file = "db_connection_oracle.jsp" %>
[<A href="freeboard_list.jsp?go=<%=request.getParameter("page")%>">게시판 목록으로 </A>]

<%
 String sql=null;
 //Connection con= null;
 PreparedStatement st =null;
 ResultSet rs =null;
 int cnt=0;
 int pos=0;
 String cont=request.getParameter("content");	//글내용
 if (cont.length()==1) 		//글내용이 한 글자라면 공백을 넣어서 처리
  cont = cont+" " ;
 
 
 // textarea 내에 ' 가들어가면 DB에 insert, update시 문제 발생
 // 그래서 ' 문제를 해결하기 위한 별도의 구문이 필요함
 
  while ((pos=cont.indexOf("\'", pos)) != -1) { // 여기서 역슬레쉬 \를 통해서 
   String left=cont.substring(0, pos);
   String right=cont.substring(pos, cont.length());
   cont = left + "\'" + right;
   pos += 2;
  }  
  int id = Integer.parseInt(request.getParameter("id"));
 
  try {
   sql = "select * from freeboard where id=? ";
   st = conn.prepareStatement(sql);
   st.setInt(1, id);
   rs = st.executeQuery();
   if (!(rs.next()))  {
    out.println("해당 내용이 없습니다");
   } else {
   String pwd= rs.getString("password"); 
   if (pwd.equals(request.getParameter("password"))) {
    sql = "update freeboard set name= ? ,email=?,";
    sql = sql + "subject=?,content=? where id=? " ;
    st = conn.prepareStatement(sql);
    st.setString(1, request.getParameter("name"));
    st.setString(2, request.getParameter("email"));
    st.setString(3, request.getParameter("subject"));
    st.setString(4, cont);
    st.setInt(5, id);
    cnt = st.executeUpdate(); 
    if (cnt >0) 
     out.println("정상적으로 수정되었습니다.");
    else
     out.println("수정되지 않았습니다.");
   } else 
    out.println("비밀번호가 틀립니다.");
  } 
  rs.close();
  st.close();
  conn.close();
 } catch (SQLException e) {
  out.println(e);
 } 
%>
</BODY>
</HTML> 