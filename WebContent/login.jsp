<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Art Gallery</title>
</head>
<link rel="stylesheet" type="text/css" href="css/style.css" />
<script src="GridGallery/GridGallery/js/modernizr.custom.js"></script>
<script type="text/javascript">

function validate(){ // Client side form validation
	var name = document.forms["login"]["name"].value;
	var pass = document.forms["login"]["pass"].value;

	if(name.trim().length == 0 || name == "username"){
		document.getElementById("error").innerHTML = "Username cannot be blank !";
		return false;
	}else if(pass.trim().length == 0 || pass == "password"){
		document.getElementById("error").innerHTML = "Password cannot be blank !";
		return false;
	}
}

</script>
<body>
<div style="text-align: center;padding: 10px;z-index: 99;position:relative;">
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
<div id="error" style="color: red;font-family: arial; text-align: center;z-index: 99;position:relative;"><%=message%></div>
<%if(isLoginSuccessful.equals("true")){ %>

<div class='body'></div>
<div style="text-align: center;z-index: 99;position:relative;">Already Logged In !</div>

<%}else{ %>

        <div class="container">
		

			<header>
			
				<h1>Online <strong>Art</strong> Gallery</h1>

				<div class="support-note">
					<span class="note-ie">Sorry, only modern browsers.</span>
				</div>
				
			</header>
			
			<section class="main">
				<form class="form-1" method="post" name="login" onsubmit="return validate()" action="LoginServlet">
					<p class="field">
						<input type="text" name="name" placeholder="Username or email">
						<i class="icon-user icon-large"></i>
					</p>
						<p class="field">
							<input type="password" name="pass" placeholder="Password">
							<i class="icon-lock icon-large"></i>
					</p>
					<p class="submit">
						<button type="submit" name="submit"><i class="icon-arrow-right icon-large"></i></button>
					</p>
				</form>
			</section>
			<section class="main">
				<form class="form-1" action="signup.jsp">
						<button type="submit" name="submit">Not a member?</button>
				</form>
			</section>
        </div>

<%}%>
</body>
</html>