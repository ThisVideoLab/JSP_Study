<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.sql.*,java.util.*" %> 
<HTML>
<HEAD><TITLE>�Խ���</TITLE>
<link href="freeboard.css" rel="stylesheet" type="text/css">
<SCRIPT language="javascript">
 function check(){
  with(document.msgsearch){
   if(sval.value.length == 0){
    alert("�˻�� �Է��� �ּ���!!");
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
<P align=center><FONT color=#0000ff face=���� size=3><STRONG>���� �Խ���</STRONG></FONT></P> 
<P>
<CENTER>
 <TABLE border=0 width=600 cellpadding=4 cellspacing=0>
  <tr align="center"> 
   <td colspan="5" height="1" bgcolor="#1F4F8F"></td>
  </tr>
  <tr align="center" bgcolor="#87E8FF"> 
   <td width="42" bgcolor="#DFEDFF"><font size="2">��ȣ</font></td>
   <td width="340" bgcolor="#DFEDFF"><font size="2">����</font></td>
   <td width="84" bgcolor="#DFEDFF"><font size="2">�����</font></td>
   <td width="78" bgcolor="#DFEDFF"><font size="2">��¥</font></td>
   <td width="49" bgcolor="#DFEDFF"><font size="2">��ȸ</font></td>
  </tr>
  <tr align="center"> 
   <td colspan="5" bgcolor="#1F4F8F" height="1"></td>
  </tr>
 <% 	//vector : ��Ƽ������ ȯ�濡�� �����, ��� �޼ҵ尡 ����ȭ ó���Ǿ� ����.
 		
  Vector name=new Vector();
  Vector inputdate=new Vector();
  Vector email=new Vector();
  Vector subject=new Vector();
  Vector rcount=new Vector();
  
  Vector stepvec=new Vector();		//DB�� step �÷��� �����ϴ� ����
  Vector keyid=new Vector();		//DB�� ID�÷��� ���� �����ϴ� ����
  
  //-----------------------------------------����¡ ó�� ���� �κ� ------------------------------------------------------
  
  
  
  
  int where=1;
  int totalgroup=0;		//���������¡�� �׷����� �ִ� ����
  int maxpages=2;		//�ִ� ������ ���� �ϴ� ó��~ ������ �ؼ� �ѱ�� �������� �ߴ� ������ ���� �������� �߽����� �յڷ� �ִ� ���
  							// �������� ǥ���� �������� ������ �� ����. 
  int startpage=2;		// ó�� ����Ʈ �ּҷ� �⺻������ �������� ��, ������ �Ǵ� �������� �ѹ�, �� ���ڴ� ó�� ��ư �ٷ� �� ���� ���ʿ� ǥ�õ� 
  int endpage=startpage+maxpages-1;	//������ ������
  int wheregroup=1;		//���� ��ġ�ϴ� �׷�
	
  
  	//go : �ش� ������ ��ȣ�� �̵�.
  	//freeboard_list.jsp?go=3
  	
  	//gogroup : ����� �������� �׷���
	//freeboard_list.jsp?gogroup=2
	
	//go ������ (������ ��ȣ) �� �Ѱ� �޾Ƽ� wheregroup, startpage, endpage ������ ���� �˾Ƴ���
  if (request.getParameter("go") != null) {	//go ������ ���� ������ ������
   where = Integer.parseInt(request.getParameter("go"));	//���� ������ ��ȣ�� ���� ����
   wheregroup = (where-1)/maxpages + 1;						//���� ��ġ�� �������� �׷�
   startpage=(wheregroup-1) * maxpages+1;  
   endpage=startpage+maxpages-1; 
   
 	//gogroup ������ �Ѱ� �޾Ƽ� startpage, endpage , where(������ �׷��� ù��° ������)
  } else if (request.getParameter("gogroup") != null) {	//gogroup ������ ���� ������ �ö�
   wheregroup = Integer.parseInt(request.getParameter("gogroup"));
   startpage=(wheregroup-1) * maxpages+1;  
   where = startpage ; 
   endpage=startpage+maxpages-1; 
  }
  int nextgroup=wheregroup+1;	//���� �׷�	: ���� �׷� + 1
  int priorgroup= wheregroup-1;	//���� �׷�: ���� �׷� - 1
  int nextpage=where+1;			//���������� : ���������� +1
  int priorpage = where-1;		//���������� : ���������� -1
  int startrow=0;				//�ش��������� SELECT �� ���ڵ� ���� ��ȣ
  int endrow=0;					//�ش��������� SELECT �� ���ڵ� ������ ��ȣ
  int maxrows=5; //����� ���ڵ� �� : �� �������� ��� �۵��� ǥ������ ���ΰ��� ������. ���� 10�̸� �� �������� 10���� ���� ��
  int totalrows=0;
  int totalpages=0;
  
  
  
  //---------------------------------����¡ ó�� ������ �κ�------------------------------------------------------
  int id=0;
  String em=null;
  //Connection con= null;
  Statement st =null;
  ResultSet rs =null;
 try {
  st = conn.createStatement();
   
//�亯���� �����ϴ� ���̺��� ��� �Ҷ��� ������ ���� ������� ������ �ؾ� �亯���� ������ ������ �ʰ� ���´�.
 String sql = "select * from freeboard order by" ;
 sql = sql + " masterid desc, replynum, step, id" ;
  
  /* �� ���� ���� ������ ����� �ϴ°��� ���� ���.
  
  ���� �ڵ带 �����ϱ� �ռ� ���� �亯�� ����� �ִ� �Խ����� ������ ���� �ʿ��� 3����� masterid, replynum, step 3�ű⿡ ���� ���ذ� �䱸�ȴ�. 
   
  id�÷� : ���ο� ���� ��ϵɶ� ������ id�÷��� �ִ밪�� �����ͼ� +1 �Ŀ� ���� �Ҵ�, ���� ��ȣ�� �ѹ�������. ���� �츮�� �ƴ� �۹�ȣ.
  	      �ٸ� �ƹ��͵� ������, �� �ƹ� �۵� ���� ���ǿ����� �׳� 1�� �ο�����. �׷��� �Խð� �Ǵϱ�. �̰� ���� �������� �Խ��� ���� ����.
  
  masterid	: ������id��, �ϳ��� �ۿ� ���� ���,���۵��� �������� �޸� ��쿡, ������ ���̵� �Ʒ���۵��� �Ȱ��� �ο��޴µ�,
  			  �̸� ���þ� ������ID��� Ī��. ������ID�� �� �� ����� �� ��Ʈ�� ��� ���ϰ� �����ϵ��� ������.
  			  ���� 6������ �ٸ� �� �ؿ� ���� �ʰ� ������ �׳� �ۼ��� ���̶�� �غ���. �̳༮�� ��ü���� �༮�̱� ������
  			  �Ҵ���� ID �ѹ� 6���� �� �ڽ��� ���̵� �ȴ�. �׷��� �� 6���ۿ� �������� �亯���� �޸�, ǥ�������δ� �亯����
  			  ID�� 7�� �Ҵ��� ������, ������ID�� ���Ӱ����� ���� ��ü�� 6���� ID�� �����޴� ���̴�. ���������� �ٷ� �ؿ� �޸���
  			  ������ ID 8���� �ο��ް� �ǰ�, MASTER ID�� �̷��� ������ �ֻ�ܿ� �ִ� ID 6���� ID�� �״�� �޴´ٴ� ��.
  
  step: �亯���� ����, ���� �Խ��ǿ��� �亯���� �鿩���⸦ �ؼ� ǥ���ϴµ�, �̸� ������ step�̶�� ǥ����.
  		�� ���캸�� ��ġ ���ó�� ���, ����, ����۸��� ���ó�� �鿩���Ⱑ �ݺ����� �߰��� �� �ִ�.
		step 0 :ó���� (�ڽ��� ��, �亯x)
		step 1 :���
		step 2 :����
		step 3 :�����
  			  
  replyNum	: ���� step level�� �ش��ϴ� �۵��� �ۼ� ������ �����ִ� ����̴�. ���� ���� �ۼ��� ���� 1�̸�, �ֽű��ϼ��� �� ū���� ����. 
  			 
  step�� relpynum�� ����: ���� ���� �� ���� �������� �� �Ŀ�, Ÿ���� ��۰� ������ �޾Ҵٰ� �غ���. �׷��ٸ� ������ step 0, ����� step1,
  					   ������ step2�� ���� ������ �ȴ�. �̶� �ٽñ� ���� ���ۿ� ����� �޷����ϸ� ���� ����� ���� step 0�� +1�� �� ������
  					   step 1�� ���Ѵ�. ���� ����� Ÿ���� ��ۺ��� �ʰ� �ۼ��Ǿ����Ƿ�, �ļ����� �з����ϴµ�, �� �ļ����� replynum����
  					   Ȯ���� �� �ִ�. �������� �� �ֽſ� �ۼ��� ���̴�.
  	
  �亯�� ó�� ������: �亯���� ó���ϴ� �÷��� 3�� �ʿ��ϴ�.(masterid, replynum, step))
 				 masterid �÷��� �ߺ��� ���� ���� ���, replynum�÷��� asc
				 replynum�� �ߺ��� ���� �����Ҷ� step asc
				 step�� �ߺ��� ���� �����Ҷ� id asc
   				 ��� �������ּ����� �ᱹ masterid�� desc�� ��� �����ϵ��� ������ �Ŀ�, step�� replynum���� ������ ������ ������ ����
   				 �������ָ� �ȴ�. �׷� �� masterid�� desc�İ�? �׷��� �ֽ� ���� ���� ���� ���� �����̴�
  				  
  				
  */
  				
  rs = st.executeQuery(sql);
  
  // out.println(sql);
  // if(true) return;	//���α׷� ����
  if (!(rs.next()))  {
   out.println("�Խ��ǿ� �ø� ���� �����ϴ�");
  } else {
   do {
	 //DB�� ���� �����ͼ� ������ vector�� ����
    keyid.addElement(new Integer(rs.getInt("id")));
  		//rs�� ID�÷��� ���� �����ͼ� vecotr�� ����
    name.addElement(rs.getString("name"));
    email.addElement(rs.getString("email"));
    String idate = rs.getString("inputdate");
    idate = idate.substring(0,8);
    inputdate.addElement(idate);
    subject.addElement(rs.getString("subject"));
    rcount.addElement(new Integer(rs.getInt("readcount")));
    stepvec.addElement(new Integer(rs.getInt("step")));
    
   }while(rs.next());
   totalrows = name.size();	//name vector�� ����� ���� ���� ,�� ���ڵ��
   totalpages = (totalrows-1)/maxrows +1;
   startrow = (where-1) * maxrows;		//���� ���������� ���� ���ڵ� ��ȣ
   endrow = startrow+maxrows-1  ;		//���� �������� ������ ���ڵ� ��ȣ
   
   
   
   if (endrow >= totalrows)
    endrow=totalrows-1;
  
   
   
   totalgroup = (totalpages-1)/maxpages +1;
   if (endpage > totalpages) 
    endpage=totalpages;
/*
   out.println("=== maxpage : 5 �϶� =====" + "<p>");
   out.println ("���� ������ : " + where + "<p>");
   out.println ("���� ������ �׷� : " + wheregroup + "<p>");
   out.println ("���� ������ : " + startpage + "<p>");
   out.println ("�� ������ : " + endpage + "<p>");
   
   out.println("=====maxrow : 5�϶�=========="+"<p>");
   out.println("�� ���ڵ�� : " + totalrows +"<p>");
   out.println("���� ������ : " + where +"<p>");
   out.println("���� ���ڵ� : " + startrow +"<p>");
   out.println("������ ���ڵ� : " + endrow +"<p>");
   out.println("��Ż ������ �׷� : " + totalpages +"<p>");
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
   
 //----------------------------------------for ��� ��------------------------------------------------------
   rs.close();
  }
  out.println("</TABLE>");
  st.close();
  conn.close();
 } catch (java.sql.SQLException e) {
  out.println(e);
 } 
 if (wheregroup > 1) {	//���� ���� �׷��� 1 �̻��϶���
  out.println("[<A href=freeboard_list.jsp?gogroup=1>ó��</A>]"); 
  out.println("[<A href=freeboard_list.jsp?gogroup="+priorgroup +">����</A>]");
  
 } else {				//���� ���� �׷��� 1 �̻��� �ƴҶ�
  out.println("[ó��]") ;
  out.println("[����]") ;
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
   out.println("[<A href=freeboard_list.jsp?gogroup="+ nextgroup+ ">����</A>]");
   out.println("[<A href=freeboard_list.jsp?gogroup="+ totalgroup + ">������</A>]");
  } else {
   out.println("[����]");
   out.println("[������]");
  }
  out.println ("��ü �ۼ� :"+totalrows); 
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
    <OPTION value=1 >�̸�
    <OPTION value=2 >����
    <OPTION value=3 >����
    <OPTION value=4 >�̸�+����
    <OPTION value=5 >�̸�+����
    <OPTION value=6 >����+����
    <OPTION value=7 >�̸�+����+����
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