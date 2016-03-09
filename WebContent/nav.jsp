<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Art Gallery</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script type="text/javascript" charset="utf8" src="DataTables-1.10.6/media/js/jquery.js"></script>
 <script src="jquery-ui-1.11.4.custom/jquery-ui.js"></script>
    <link rel="stylesheet" href="jquery-ui-1.11.4.custom/jquery-ui.css">
      <script>
/*   $(function() {
    $( "a" )
      .button();
  }); */

  //var allow = window.sessionStorage.getItem("allow");
  function redirect(){
/* 	  window.sessionStorage.setItem("allow",true);
	  console.log("set true") */
  }
  
  </script>
</head>
<body>
<%
ServletContext sc = getServletContext();
String path = sc.getContextPath();
%>
<a href="<%= path %>/login.jsp" onclick="redirect()" class="button">Login</a>
<a href="<%= path %>/signup.jsp" onclick="redirect()" class="button">Sign-Up</a>
<a href="<%= path %>/index.jsp" onclick="redirect()" class="button">Home</a>
<a href="<%= path %>/ContactUs.jsp" onclick="redirect()" class="button">Contact Us</a>
</body>
</html>