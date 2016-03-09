<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Art Gallery</title>
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
<link rel="stylesheet" type="text/css" href="style.css">
<%
String myId = ""+request.getSession().getAttribute("userId");

if(myId.equals("null")){
	myId = "0";
}

String fileName = request.getParameter("fileName");
if(fileName == null){
	fileName = "";
}else{
	fileName = "images/"+fileName;
}

String status = request.getParameter("status");
int statusVal = 0; 

if(status == null){
	statusVal = 0;
}else{
	statusVal = Integer.parseInt(request.getParameter("status"));	
}

String message = "";
if(statusVal>0){
	message = "<span style=\"color:green\">Item Uploaded Successfully!</span>";
}else if(statusVal == 0){
	message = "";
}else{
	message = "<span style=\"color:red\">Item Uploading Failed!</span>";
}

if(message == null)
	message = "";

String isLoginSuccessful = (String) request.getSession().getAttribute("isLoginSuccessful");
if(isLoginSuccessful == null){
	isLoginSuccessful = "false";
}
%>
<script type="text/javascript">

function home(){
	window.location.href = "login.jsp";
}

var submit = "";
function clicked(ele){
	submit = ele;
}

function validate(){ // Client side form validation

	if(submit.value == "Upload"){
		$( "form#vendorUpload" )
	    .attr( "enctype", "multipart/form-data" );
	}
}
</script>
</head>
<body style="font-family: Arial;">

<div style="text-align: center;padding: 10px; display: none;">
<jsp:include page="nav.jsp"/>
</div>
<div id="error" style="font-family: arial;text-align: center;"><%=message%></div>
<form method="post" id="vendorUpload" name="vendorUpload" onsubmit="return validate()" action="VendorUpload">
<%
out.println("<input type=\"hidden\" name=\"myId\" id=\"myId\" value="+myId+" /> ");
%>
<table class="form" align="center">
<tr>
<td><div>Item Name</div></td>
<td><input type="text" name="name" /></td>
</tr>
<tr>
<td><div>Item Category</div></td>
<td><input type="text" name="type" /></td>
</tr>
<tr>
<td><div>Artist</div></td>
<td><input type="text" name="artist" /></td>
</tr>
<tr>
<td><div>Price</div></td>
<td><input type="text" name="price" /></td>
</tr>
<tr>
<td><div>Stock</div></td>
<td><input type="text" name="stock" /></td>
</tr>
<tr>
<td><div>Image Upload</div></td>
<td><input type="file" name="dataFile" id="fileChooser"/><input type="submit"  class="button" onclick="clicked(this)" value="Upload" /></td>
</tr>
<tr>
<td></td>
<td>
<!-- src="/selab3/images/dbz.jpg"  -->
<img id="imgUploaded" alt="no image uploaded" height="100px" width="100px" src="<%=fileName %>"/>
<input type="hidden" name="imgURL" value="<%=fileName %>">
</td>
</tr>
<tr>
<td><div>Item Description</div></td>
<td><textarea id="desc" name="desc" rows="4" cols="50"></textarea></td>
</tr>
<tr>
<td></td>
<td><input type="submit" class="button" name="upload" value="Finish" /></td>
</tr>
</table>
</form>
</body>
</html>