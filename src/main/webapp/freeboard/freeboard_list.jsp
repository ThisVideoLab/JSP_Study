<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.sql.*,java.util.*" %> 
<HTML>
<HEAD><TITLE>게시판</TITLE>
<link href="freeboard.css" rel="stylesheet" type="text/css">
<SCRIPT language="javascript">
 function check(){
  with(document.msgsearch){
   if(sval.value.length == 0){
    alert("검색어를 입력해 주세요!!");
    sval.focus();
    return false;
   }	
   document.msgsearch.submit();
  }
 }
 function rimgchg(p1,p2) {
  if (p2==1) 
   document.images[p1].src= "image/open.gif";
  else
   document.images[p1].src= "image/arrow.gif";
  }
 function imgchg(p1,p2) {
  if (p2==1) 
   document.images[p1].src= "image/open.gif";
  else
   document.images[p1].src= "image/close.gif";
 }
</SCRIPT>
</HEAD>
<BODY>
<%@ include file = "db_connection_oracle.jsp" %>
<P>
<P align=center><FONT color=#0000ff face=굴림 size=3><STRONG>자유 게시판</STRONG></FONT></P> 
<P>
<CENTER>
 <TABLE border=0 width=600 cellpadding=4 cellspacing=0>
  <tr align="center"> 
   <td colspan="5" height="1" bgcolor="#1F4F8F"></td>
  </tr>
  <tr align="center" bgcolor="#87E8FF"> 
   <td width="42" bgcolor="#DFEDFF"><font size="2">번호</font></td>
   <td width="340" bgcolor="#DFEDFF"><font size="2">제목</font></td>
   <td width="84" bgcolor="#DFEDFF"><font size="2">등록자</font></td>
   <td width="78" bgcolor="#DFEDFF"><font size="2">날짜</font></td>
   <td width="49" bgcolor="#DFEDFF"><font size="2">조회</font></td>
  </tr>
  <tr align="center"> 
   <td colspan="5" bgcolor="#1F4F8F" height="1"></td>
  </tr>
 <% 	//vector : 멀티쓰레드 환경에서 사용함, 모든 메소드가 동기화 처리되어 있음.
 		
  Vector name=new Vector();
  Vector inputdate=new Vector();
  Vector email=new Vector();
  Vector subject=new Vector();
  Vector rcount=new Vector();
  
  Vector stepvec=new Vector();		//DB의 step 컬럼만 저장하는 벡터
  Vector keyid=new Vector();		//DB의 ID컬럼의 값을 저장하는 벡터
  
  //-----------------------------------------페이징 처리 시작 부분 ------------------------------------------------------
  
  
  
  
  int where=1;
  int totalgroup=0;		//출력할페이징의 그룹핑의 최대 갯수
  int maxpages=2;		//최대 페이지 갯수 하단 처음~ 마지막 해서 넘기는 페이지들 뜨는 곳에서 현재 페이지를 중심으로 앞뒤로 최대 몇개의
  							// 페이지를 표시할 것인지를 결정할 수 있음. 
  int startpage=2;		// 처음 리스트 주소로 기본적으로 접속했을 때, 기준이 되는 페이지의 넘버, 이 숫자는 처음 버튼 바로 옆 가장 왼쪽에 표시됨 
  int endpage=startpage+maxpages-1;	//마지막 페이지
  int wheregroup=1;		//현재 위치하는 그룹
	
  
  	//go : 해당 페이지 번호로 이동.
  	//freeboard_list.jsp?go=3
  	
  	//gogroup : 출력할 페이지의 그룹핑
	//freeboard_list.jsp?gogroup=2
	
	//go 변수를 (페이지 번호) 를 넘겨 받아서 wheregroup, startpage, endpage 정보의 값을 알아낸다
  if (request.getParameter("go") != null) {	//go 변수의 값을 가지고 있을때
   where = Integer.parseInt(request.getParameter("go"));	//현재 페이지 번호를 담은 변수
   wheregroup = (where-1)/maxpages + 1;						//현재 위치한 페이지의 그룹
   startpage=(wheregroup-1) * maxpages+1;  
   endpage=startpage+maxpages-1; 
   
 	//gogroup 변수를 넘겨 받아서 startpage, endpage , where(페이지 그룹의 첫번째 페이지)
  } else if (request.getParameter("gogroup") != null) {	//gogroup 변수의 값을 가지고 올때
   wheregroup = Integer.parseInt(request.getParameter("gogroup"));
   startpage=(wheregroup-1) * maxpages+1;  
   where = startpage ; 
   endpage=startpage+maxpages-1; 
  }
  int nextgroup=wheregroup+1;	//다음 그룹	: 현재 그룹 + 1
  int priorgroup= wheregroup-1;	//이전 그룹: 현재 그룹 - 1
  int nextpage=where+1;			//다음페이지 : 현재페이지 +1
  int priorpage = where-1;		//이전페이지 : 현재페이지 -1
  int startrow=0;				//해당페이지에 SELECT 한 레코드 시작 번호
  int endrow=0;					//해당페이지에 SELECT 한 레코드 마지막 번호
  int maxrows=5; //출력할 레코드 수 : 한 페이지당 몇개의 글들을 표시해줄 것인가를 결정함. 만약 10이면 한 페이지당 10개의 글이 뜸
  int totalrows=0;
  int totalpages=0;
  
  
  
  //---------------------------------페이징 처리 마지막 부분------------------------------------------------------
  int id=0;
  String em=null;
  //Connection con= null;
  Statement st =null;
  ResultSet rs =null;
 try {
  st = conn.createStatement();
   
//답변글이 존재하는 테이블을 출력 할때는 다음과 같은 방식으로 정렬을 해야 답변글의 순서가 꼬이지 않고 나온다.
 String sql = "select * from freeboard order by" ;
 sql = sql + " masterid desc, replynum, step, id" ;
  
  /* 왜 위의 정렬 순서를 따라야 하는가에 대한 답번.
  
  위의 코드를 이해하기 앞서 먼저 답변글 기능이 있는 게시판의 정렬을 위해 필요한 3요소인 masterid, replynum, step 3신기에 대한 이해가 요구된다. 
   
  id컬럼 : 새로운 글이 등록될때 기존의 id컬럼의 최대값을 가져와서 +1 후에 값을 할당, 새글 번호에 넘버링해줌. 보통 우리가 아는 글번호.
  	      다만 아무것도 없을때, 즉 아무 글도 없는 조건에서는 그냥 1을 부여해줌. 그래야 게시가 되니까. 이게 가장 기초적인 게시판 글의 변수.
  
  masterid	: 마스터id는, 하나의 글에 대한 답글,답답글들이 연속으로 달릴 경우에, 원글의 아이디를 아래답글들이 똑같이 부여받는데,
  			  이를 일컬어 마스터ID라고 칭함. 마스터ID는 글 및 답글을 한 세트로 묶어서 편하게 관리하도록 도와줌.
  			  가령 6번글을 다른 글 밑에 달지 않고 오롯이 그냥 작성한 글이라고 해보자. 이녀석은 주체적인 녀석이기 때문에
  			  할당받은 ID 넘버 6번이 곧 자신의 아이디가 된다. 그런데 이 6번글에 연속으로 답변글을 달면, 표면적으로는 답변글의
  			  ID는 7로 할당이 되지만, 마스터ID는 종속관계의 상위 개체인 6번의 ID를 물려받는 것이다. 마찬가지로 바로 밑에 달리는
  			  답답글은 ID 8번을 부여받게 되고, MASTER ID는 이러한 구조의 최상단에 있는 ID 6번의 ID를 그대로 받는다는 것.
  
  step: 답변글의 깊이, 보통 게시판에선 답변글은 들여쓰기를 해서 표시하는데, 이를 착안해 step이라고 표현함.
  		잘 살펴보면 마치 계단처럼 답글, 답답글, 답답답글마다 계단처럼 들여쓰기가 반복됨을 발견할 수 있다.
		step 0 :처음글 (자신의 글, 답변x)
		step 1 :답글
		step 2 :답답글
		step 3 :답답답글
  			  
  replyNum	: 같은 step level에 해당하는 글들의 작성 순서를 보여주는 기능이다. 가장 먼저 작성된 글이 1이며, 최신글일수록 더 큰값을 지님. 
  			 
  step과 relpynum의 관계: 가령 예를 들어서 내가 정보글을 쓴 후에, 타인이 답글과 답답글이 달았다고 해보자. 그렇다면 원글은 step 0, 답글은 step1,
  					   답답글은 step2의 값을 가지게 된다. 이때 다시금 내가 원글에 답글을 달려고하면 나의 답글은 원글 step 0에 +1을 한 값으로
  					   step 1을 지닌다. 나의 답글은 타인의 답글보다 늦게 작성되었으므로, 후순위로 밀려야하는데, 이 후순위를 replynum으로
  					   확인할 수 있다. 높을수록 더 최신에 작성된 글이다.
  	
  답변글 처리 주의점: 답변글을 처리하는 컬럼이 3개 필요하다.(masterid, replynum, step))
 				 masterid 컬럼에 중복된 값이 있을 경우, replynum컬럼을 asc
				 replynum이 중복된 값이 존재할때 step asc
				 step이 중복된 값이 존재할때 id asc
   				 라고 설명해주셨지만 결국 masterid를 desc로 묶어서 인접하도록 정렬한 후에, step과 replynum으로 위에서 설명한 목적을 위해
   				 정렬해주면 된다. 그럼 왜 masterid는 desc냐고? 그래야 최신 글이 가장 위로 오기 때문이다
  				  
  				
  */
  				
  rs = st.executeQuery(sql);
  
  // out.println(sql);
  // if(true) return;	//프로그램 종료
  if (!(rs.next()))  {
   out.println("게시판에 올린 글이 없습니다");
  } else {
   do {
	 //DB의 값을 가져와서 각각의 vector에 저장
    keyid.addElement(new Integer(rs.getInt("id")));
  		//rs에 ID컬럼의 값을 가져와서 vecotr에 저장
    name.addElement(rs.getString("name"));
    email.addElement(rs.getString("email"));
    String idate = rs.getString("inputdate");
    idate = idate.substring(0,8);
    inputdate.addElement(idate);
    subject.addElement(rs.getString("subject"));
    rcount.addElement(new Integer(rs.getInt("readcount")));
    stepvec.addElement(new Integer(rs.getInt("step")));
    
   }while(rs.next());
   totalrows = name.size();	//name vector에 저장된 값의 갯수 ,총 레코드수
   totalpages = (totalrows-1)/maxrows +1;
   startrow = (where-1) * maxrows;		//현재 페이지에서 시작 레코드 번호
   endrow = startrow+maxrows-1  ;		//현재 페이지의 마지막 레코드 번호
   
   
   
   if (endrow >= totalrows)
    endrow=totalrows-1;
  
   
   
   totalgroup = (totalpages-1)/maxpages +1;
   if (endpage > totalpages) 
    endpage=totalpages;
/*
   out.println("=== maxpage : 5 일때 =====" + "<p>");
   out.println ("현재 페이지 : " + where + "<p>");
   out.println ("현재 페이지 그룹 : " + wheregroup + "<p>");
   out.println ("시작 페이지 : " + startpage + "<p>");
   out.println ("끝 페이지 : " + endpage + "<p>");
   
   out.println("=====maxrow : 5일때=========="+"<p>");
   out.println("총 레코드수 : " + totalrows +"<p>");
   out.println("현재 페이지 : " + where +"<p>");
   out.println("시작 레코드 : " + startrow +"<p>");
   out.println("마지막 레코드 : " + endrow +"<p>");
   out.println("토탈 페이지 그룹 : " + totalpages +"<p>");
*/
   for(int j=startrow;j<=endrow;j++) {
    String temp=(String)email.elementAt(j);
    if ((temp == null) || (temp.equals("")) ) 
     em= (String)name.elementAt(j); 
    else
     em = "<A href=mailto:" + temp + ">" + name.elementAt(j) + "</A>";
    id= totalrows-j;
    if(j%2 == 0){
     out.println("<TR bgcolor='#FFFFFF' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor=''\">");	
    } else {
     out.println("<TR bgcolor='#F4F4F4' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor='#F4F4F4'\">");
    } 
    out.println("<TD align=center>");
    out.println(id+"</TD>");
    out.println("<TD>");
    int stepi= ((Integer)stepvec.elementAt(j)).intValue();
    int imgcount = j-startrow; 
    if (stepi > 0 ) {
     for(int count=0; count < stepi; count++)
      out.print("&nbsp;&nbsp;");
     out.println("<IMG name=icon"+imgcount+ " src=image/arrow.gif>");
     out.print("<A href=freeboard_read.jsp?id=");
     out.print(keyid.elementAt(j) + "&page=" + where );
     out.print(" onmouseover=\"rimgchg(" + imgcount + ",1)\"");
     out.print(" onmouseout=\"rimgchg(" + imgcount + ",2)\">");
    } else {
     out.println("<IMG name=icon"+imgcount+ " src=image/close.gif>");
     out.print("<A href=freeboard_read.jsp?id=");
     out.print(keyid.elementAt(j) + "&page=" + where );
     out.print(" onmouseover=\"imgchg(" + imgcount + ",1)\"");
     out.print(" onmouseout=\"imgchg(" + imgcount + ",2)\">");
    }
    out.println(subject.elementAt(j) + "</TD>");
    out.println("<TD align=center>");
    out.println(em+ "</TD>");
    out.println("<TD align=center>");
    out.println(inputdate.elementAt(j)+ "</TD>");
    out.println("<TD align=center>");
    out.println(rcount.elementAt(j)+ "</TD>");
    out.println("</TR>"); 
    
    /*
    out.println("j: " + j + "<p>");
    out.println("ID" + keyid.elementAt(j) +"<p>");
    out.println("Subject :" + subject.elementAt(j)+"<p>");
    */
   }
   
 //----------------------------------------for 블락 끝------------------------------------------------------
   rs.close();
  }
  out.println("</TABLE>");
  st.close();
  conn.close();
 } catch (java.sql.SQLException e) {
  out.println(e);
 } 
 if (wheregroup > 1) {	//현재 나의 그룹이 1 이상일때는
  out.println("[<A href=freeboard_list.jsp?gogroup=1>처음</A>]"); 
  out.println("[<A href=freeboard_list.jsp?gogroup="+priorgroup +">이전</A>]");
  
 } else {				//현재 나의 그룹이 1 이상이 아닐때
  out.println("[처음]") ;
  out.println("[이전]") ;
 }
 if (name.size() !=0) { 
  for(int jj=startpage; jj<=endpage; jj++) {
   if (jj==where) 
    out.println("["+jj+"]") ;
   else
    out.println("[<A href=freeboard_list.jsp?go="+jj+">" + jj + "</A>]") ;
   } 
  }
  if (wheregroup < totalgroup) {
   out.println("[<A href=freeboard_list.jsp?gogroup="+ nextgroup+ ">다음</A>]");
   out.println("[<A href=freeboard_list.jsp?gogroup="+ totalgroup + ">마지막</A>]");
  } else {
   out.println("[다음]");
   out.println("[마지막]");
  }
  out.println ("전체 글수 :"+totalrows); 
 %>
<!--<TABLE border=0 width=600 cellpadding=0 cellspacing=0>
 <TR>
  <TD align=right valign=bottom>
   <A href="freeboard_write.htm"><img src="image/write.gif" width="66" height="21" border="0"></A>
   </TD>
  </TR>
 </TABLE>-->

<FORM method="post" name="msgsearch" action="freeboard_search.jsp">
<TABLE border=0 width=600 cellpadding=0 cellspacing=0>
 <TR>
  <TD align=right width="241"> 
   <SELECT name=stype >
    <OPTION value=1 >이름
    <OPTION value=2 >제목
    <OPTION value=3 >내용
    <OPTION value=4 >이름+제목
    <OPTION value=5 >이름+내용
    <OPTION value=6 >제목+내용
    <OPTION value=7 >이름+제목+내용
   </SELECT>
  </TD>
  <TD width="127" align="center">
   <INPUT type=text size="17" name="sval" >
  </TD>
  <TD width="115">&nbsp;<a href="#" onClick="check();"><img src="image/serach.gif" border="0" align='absmiddle'></A></TD>
  <TD align=right valign=bottom width="117"><A href="freeboard_write.html"><img src="image/write.gif" border="0"></TD>
 </TR>
</TABLE>
</FORM>
</BODY>
</HTML>