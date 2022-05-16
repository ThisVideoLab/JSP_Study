<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">

<SCRIPT language = "javascript" type="text/javascript">
	function check(){
		with(document.msgdel){
			if(password.value.length ==0){
				alert ("비밀번호를 입력해 주세요!!");
				password.focus();
				return false;
			}
			document.msgdel.submit();	
		}
	}
</SCRIPT>
<link href = "freeboard.css" rel="stylesheet" type = "text/css">

<title>글 삭제 페이지</title>
</head>
<body>
	<center>
		<form name = "msgdel" method = post action = "freeboard_deldb.jsp">
		<!-- HTML 페이지에 출력은 하지 않으나 변수의 값을 다른 페이지로 넘길 때 사용함. id 변수와 page 변수를 넘겨줌-->
		<input type = "hidden" name = "id" value = "<%= request.getParameter("id") %>">
		<input type = "hidden" name = "page" value = "<%= request.getParameter("page") %>">
		
		<table with = "70%" cellspacing = "0" cellapdding = "2">
			<tr><td colspan = "2" bgcolor = "#1f4f8f" height = "1"></td>
			</tr>
			<tr><td colspan = "2" bgcolor = "#DFEDFF" height = "20" class = "notice">
				<b> 글 삭제하기</b> </td>
			</tr>
			<tr><td colspan = "2" bgcolor = "#1f4f8f" height = "1"></td>
			</tr>
			<tr>
				<td width = "124" height = "30" align = "center" class = "input_style1">
				비밀 번호  </td>
				<td width = "494"><input type = "password" name = password class = "input_style1">
			</tr>
			<tr><td colspan = "2" heghit = "1" class = "button"></td></td>
			</tr>
			<tr><td colspan = "2" heghit = "1" bgcolor = "#1F4F8F"></td></td>
			</tr>
			<tr><td colspan = "2" height = "10"></td>
			</tr>
			<tr><td colspan = "2" align ="right">
					<table width ="100%" border = "0" cellspacing = "4" cellapdding = "4">
						<tr>                                                                             <td width = "84%"> &nbsp; </td>
							<td width = "8%">
								<a href = "freeboard_list.jsp?go=<%= request.getParameter("page") %>">
									<img src = "image/list.jpg" width="48" height="19" border = 0>
								</a> 
							</td>
							<td width = "8%">
								<a href = "#" onClick = "check();">
									<img src = "image/del.jpg" width="46" height="19" border = "0">
								</a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
					
		</form>
	</center>
</body>
</html>