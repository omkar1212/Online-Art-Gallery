<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
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
<script type="text/javascript" charset="utf8" src="DataTables-1.10.6/media/js/jquery.js"></script>
<script type="text/javascript">
function checkout(){

		var userId = $("#myId").val();
		var total = $("#total").html();
		
		var cardNumber = $("#cardNumber").val();
		var fname = $("#fname").val();
		var lname = $("#lname").val();
		var address = $("#address").val();
		var phone = $("#phone").val();
		var payment = $("#payment").val();
		
		console.log("--payment--"+payment)
		
		if(payment == "select"){
			$("#paymentError").html("Please select proper Payment method!");
			return false;
		}else if(cardNumber == ""){
			$("#paymentError").html("Please enter card details!");
			return false;
		}else if(cardNumber == ""){
			$("#paymentError").html("Please enter card details!");
			return false;
		}else if(fname == ""){
			$("#paymentError").html("Please enter your First Name!");
			return false;
		}else if(lname == ""){
			$("#paymentError").html("Please enter Last Name!");
			return false;
		}else if(address == ""){
			$("#paymentError").html("Please enter Address!");
			return false;
		}else if(phone == ""){
			$("#paymentError").html("Please enter a valid phone number!");
			return false;
		}
		
		console.log("----"+total)
 	 	$.ajax({
			  method: "POST",
			  url: "TestServlet",
			  data: { customer: userId, total: total, payment: payment, cardNumber: cardNumber, fname: fname, lname: lname, address:address, phone: phone, action: 10 }
			})
			  .done(function( msg ) {
			    console.log( "Data Saved: " + msg );
			    if(msg > 0){
			    	window.location.href = "success.html";
			    }
			  });  
	}
</script>
</head>
<body style="font-family: arial;">
<h3 style="text-align: center;">Checkout Summary</h3>
<table style="width: 100%; border: 1px solid #565656;" cellpadding="10" cellspacing="10">
<tr>
<td style="width: 50%;">
<%
String myId = ""+session.getAttribute("userId");
out.println("<input type=\"hidden\" id=\"myId\" value="+myId+" /> ");
JSONArray ja = (JSONArray) session.getAttribute("cart");
StringBuilder sb = new StringBuilder();
int total = 0;
for (int i = 0; i < ja.length(); i++) {
    JSONObject jsonobject;
	try {
		jsonobject = ja.getJSONObject(i);
	    int itemId = jsonobject.getInt("item_id");
	    String artist = jsonobject.getString("artist");
	    String itemName = jsonobject.getString("item_name");
	    String type = jsonobject.getString("item_type");
	    String desc = java.net.URLDecoder.decode(jsonobject.getString("item_description"), "UTF-8");
	    int price = jsonobject.getInt("price");
	    total += price;
	    String img = java.net.URLDecoder.decode(jsonobject.getString("image_url"), "UTF-8");
	    System.out.println(itemId);
		sb.append("<div style=\"border: 1px solid #565656;\" >");
		sb.append("<table><tr><td>");
		sb.append("<div><img height=\"100px\" width=\"100px\" src="+img+"></div>");
		sb.append("</td><td>");
		sb.append("<div><span style=\"font-weight:bold\">Name:</span> "+itemName+"  <span style=\"font-weight:bold\">Artist:</span> "+artist+"</div>");
		sb.append("<div><span style=\"font-weight:bold\">Price:</span> "+price+" <span style=\"font-weight:bold\">Tags:</span> "+type+"</div>");
		sb.append("<div>"+desc+"</div>");
		sb.append("</td></tr></table>");
		sb.append("</div>");
		
	} catch (JSONException e) {
		e.printStackTrace();
	}
}
sb.append("<div><span style=\"font-weight:bold\">Total:</span> <span id=\"total\">"+total+"</span>$ </div>");
out.println(sb);
%>
</td>
<td valign="top">
<div style="border: 1px solid #565656;">
<table style="width: 100%;">
<tr>
<td style="text-align: center;font-weight: bold;">PAYMENT DETAILS <span id="paymentError" style="color: red;"></span></td>
</tr>
<tr>
<td>Card type</td>
<td>
<select id="payment">
<option value="select">--select--</option>
<option value="mastercard">Master Card</option>
<option value="visa">Visa</option>
<option value="amex">American Express</option>
<option value="paypal">Paypal</option>
</select>
</td>
</tr>
<tr>
<td>Card Number</td>
<td><input type="text" id="cardNumber" /></td>
</tr>
<tr>
<tr>
<td>Name on Card</td>
<td><input type="text" id="nameOnCard" /></td>
</tr>
<tr>
<td>Expiration Date</td>
<td><input type="text" id="date" /></td>
</tr>
<tr>
<td>Security Code</td>
<td><input type="text" id="code" /></td>
</tr>
<tr>
<td></td>
</tr>
<tr>
<td style="text-align: center;font-weight: bold;">SHIPPING DETAILS</td>
</tr>
<tr>
<td>First Name</td>
<td>
<input type="text" id="fname" />
</td>
</tr>
<tr>
<td>Last Name</td>
<td><input type="text" id="lname" /></td>
</tr>
<tr>
<td>Address</td>
<td><textarea id="address" rows="5" cols="20"></textarea></td>
</tr>
<tr>
<td>Phone Number</td>
<td><input type="text" id="phone" /></td>
</tr>
</table>
</div>
</td>
</tr>
<tr>
<td colspan="2" style="text-align: center">
<button class="button" onclick="checkout()">Complete Checkout</button>
</td>
</tr>
</table>
</body>
</html>