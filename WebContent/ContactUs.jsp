<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Art Gallery</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">
.contactus_form_text{
    font-size: 12px;
    width: 430px;
    margin-top: 3px;
    height: 25px;
    background-color: #f2f2f2;
    padding-left: 5px;
 	border: medium none; 
}

.contactus_form_textarea{
font-family: "Proxima Nova";
font-size: 13px;
overflow: auto;
padding-left: 5px;
background-color: #f2f2f2;
height: 160px;
margin-top: 3px;
border: medium none;
width: 426px;
resize: none;
padding-top: 4px;
}

.form_title{
font-size: 16px;
color: #ED2E24;
text-decoration: none;
line-height: 10px;
}

</style>
<%
String status = request.getParameter("status");
int isSubmitted = 0;
if(status == null)
	status = "";
else
	isSubmitted = Integer.parseInt(status);

String isLoginSuccessful = (String) request.getSession().getAttribute("isLoginSuccessful");
if(isLoginSuccessful == null){
	isLoginSuccessful = "false";
}
%>
</head>
<body style="font-family: Arial;">
<div style="text-align: center;padding: 10px;z-index: 99;position:relative;">
<jsp:include page="nav.jsp" />
</div>
<%if(isLoginSuccessful.equals("false")){ %>
<div class='body'></div>
<div style="text-align: center;z-index: 99;position:relative;color: #47A3DA">You must be logged-in to view this page!</div>
<%}else{ %>
<h3 align="center">Contact Us</h3>
<table width="100%">
<tr>
    <td width="430" valign="top" height="40"></td>
    <td width="90" valign="top"></td>
    <td width="430" valign="top"></td>
</tr>
<tr>
<td valign="top" style="border-top: 1px solid black;">
<br><br>
<span  style="margin-left: 20px;" class="form_title">CUSTOMER SUPPORT</span>
<br><br>
<div style="margin-left: 20px;">
UNITED STATES<br><br>
Mon-Fri:<br>
9:30am - 6:00pm<br>
1-800-000-0000<br><br>

Office Address:<br>
1400 Washington Avenue<br>
Albany<br>
NY 12222<br>
</div>
</td>
<td>
</td>
<td valign="top" style="border-top: 1px solid black;">
<br><br>
<% if(isSubmitted>0){ %>
<div style="text-align: center;" class="form_title">Query Submitted Successfully !</div>
<%}else{ %>
<div class="form_title">ENQUIRY FORM</div>
<br>
<form method="post" name="contactus" action="EnquiryServlet">
<div>Name</div>
<div><input class="contactus_form_text" type="text" name="name" /></div>
<div>Email Address</div>
<div><input class="contactus_form_text" type="text" name="email" /></div>
<div>Enquiry</div>
<textarea class="contactus_form_textarea" name="query" rows="2" cols="10"></textarea>
<br><br>
<div><input class="button2" type="submit" name="contactSubmit" value="SEND" /></div>
</form> 
<%}%>
</td>
</tr>
</table>
<%} %>
</body>
</html>