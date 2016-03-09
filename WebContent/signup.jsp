<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Art Gallery</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">
body {
	font-family: 'Lato', Calibri, Arial, sans-serif;
    background: #ddd url(images/bg.jpg) repeat top left;
    font-weight: 300;
    font-size: 15px;
    color: #333;
    -webkit-font-smoothing: antialiased;
    overflow-y: scroll;
    overflow-x: hidden;
}

</style>
<%
String status = request.getParameter("status");
if(status == null)
	status = "";

String message = request.getParameter("message");
if(message == null)
	message = "";

String isLoginSuccessful = (String) request.getSession().getAttribute("isLoginSuccessful");
if(isLoginSuccessful == null){
	isLoginSuccessful = "false";
}
%>
<script type="text/javascript">
function onPageLoad(){
	var status = document.getElementById("status").innerHTML;
	if(status == "true"){
		document.getElementById("status").innerHTML = "Username Available !";
		document.getElementById("status").style.color = "green";
	}else if(status == "false"){
		document.getElementById("status").innerHTML = "Username Already Taken !";
		document.getElementById("status").style.color = "red";
	}else if(status > 0){
		document.getElementById("error").innerHTML = "Account Successfully Created !";
		document.getElementById("status").innerHTML = "";
		document.getElementById("error").style.color = "green";
	}else if(status <= 0 && status != ""){
		document.getElementById("error").innerHTML = "Could not Create account !";
		document.getElementById("status").innerHTML = "";
		document.getElementById("error").style.color = "red";
	}
}
var submit = "";
function clicked(ele){
	submit = ele;
}

function validate(){ // Client side form validation
	var username = document.forms["signup"]["username"].value;
	var firstName = document.forms["signup"]["firstName"].value;
	var lastName = document.forms["signup"]["lastName"].value;
	var password = document.forms["signup"]["password"].value;
	var confirmPassword = document.forms["signup"]["confirmPassword"].value;
	
	if(submit.value == "Check"){
		if(username.trim().length == 0){
			document.getElementById("error").innerHTML = "Username cannot be blank !";
			return false;
		}
	}else{
		if(username.trim().length == 0){
			document.getElementById("error").innerHTML = "Username cannot be blank !";
			return false;
		}else if(firstName.trim().length == 0){
			document.getElementById("error").innerHTML = "First Name cannot be blank !";
			return false;
		}else if(lastName.trim().length == 0){
			document.getElementById("error").innerHTML = "Last Name cannot be blank !";
			return false;
		}else if(password.trim().length == 0){
			document.getElementById("error").innerHTML = "Password cannot be blank !";
			return false;
		}else if(confirmPassword.trim().length == 0){
			document.getElementById("error").innerHTML = "Confirm Password cannot be blank !";
			return false;
		}else if(confirmPassword != password){
			document.getElementById("error").innerHTML = "Password and Confirm Password donot match !";
			return false;
		}	
	}
}

function home(){
	window.location.href = "login.jsp";
}
</script>
</head>
<body style="font-family: Arial;" onload="onPageLoad()">
<div style="text-align: center;padding: 10px;">
<jsp:include page="nav.jsp" />
</div>
<div id="error" style="color: red;font-family: arial;text-align: center;"><%=message%></div>
<%if(isLoginSuccessful.equals("true")){ %>
<div style="text-align: center;">Already Logged In !</div>
<%}else{ %>
<h3 align="center">USER SIGNUP</h3>
<form method="post" name="signup" onsubmit="return validate()" action="SignupServlet">
<table class="form" align="center">
<tr>
<td class="div_text_shadow"><div>Username</div></td>
<td class="div_text_shadow"><input type="text" name="username" /></td>
</tr>
<tr>
<td class="div_text_shadow"><div>Check Username Availability?</div></td>
<td class="div_text_shadow"><input type="submit" name="checkUsername" onclick="clicked(this)" value="Check" />  <span id="status" style="color: red;font-family: arial;"><%=status%></span></td>
</tr>
<tr>
<td class="div_text_shadow"><div>First Name</div></td>
<td class="div_text_shadow"><input type="text" name="firstName" /></td>
</tr>
<tr>
<td class="div_text_shadow"><div>Last Name</div></td>
<td class="div_text_shadow"><input type="text" name="lastName" /></td>
</tr>
<tr>
<td class="div_text_shadow"><div>Password</div></td>
<td class="div_text_shadow"><input type="password" name="password" /></td>
</tr>
<tr>
<td class="div_text_shadow"><div>Confirm Password</div></td>
<td class="div_text_shadow"><input type="password" name="confirmPassword" /></td>
</tr>
<tr>
<td class="div_text_shadow"><div>Gender</div></td>
<td class="div_text_shadow"> <select id="gender" name="gender">
  <option value="notselected">--Select--</option>
  <option value="male">Male</option>
  <option value="female">Female</option>
  <option value="other">Other</option>
</select> </td>
</tr>
<tr>
<tr>
<td class="div_text_shadow"><div>Address</div></td>
<td class="div_text_shadow"><textarea id="address" name="address" rows="4" cols="50"></textarea></td>
</tr>
<tr>
<tr>
<td class="div_text_shadow"><div>Phone Number</div></td>
<td class="div_text_shadow"><input type="text" name="phone" /></td>
</tr>
<tr>
<tr>
<td class="div_text_shadow"><div>Signup</div></td>
<td class="div_text_shadow"><input type="submit" onclick="clicked(this)" name="signup" value="Proceed" /></td>
</tr>
</table>
</form>
<%} %>
</body>
</html>