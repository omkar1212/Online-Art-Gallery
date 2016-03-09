<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Art Gallery</title>
</head>
<body style="font-family: Arial;">
<div style="text-align: center;padding: 10px;">
<jsp:include page="nav.jsp" />
</div>
<%
String message = request.getParameter("message");
if(message == null)
	message = "";

String isLoginSuccessful = (String) request.getSession().getAttribute("isLoginSuccessful");
if(isLoginSuccessful == null){
	isLoginSuccessful = "false";
}
%>
<div id="error" style="color: red;font-family: arial; text-align: center;"><%=message%></div>
</body>
</html>