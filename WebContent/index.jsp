<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="model.User"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Online Art Gallery</title>
<link rel="stylesheet" type="text/css" href="DataTables-1.10.6/media/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8" src="DataTables-1.10.6/media/js/jquery.js"></script>

 <script src="jquery-ui-1.11.4.custom/jquery-ui.js"></script>
    <link rel="stylesheet" href="jquery-ui-1.11.4.custom/jquery-ui.css">
    
   		<link rel="stylesheet" type="text/css" href="GridGallery/GridGallery/css/demo.css" />
		<link rel="stylesheet" type="text/css" href="GridGallery/GridGallery/css/component.css" />
		<script src="GridGallery/GridGallery/js/modernizr.custom.js"></script> 
    
<script type="text/javascript">
/* var allow = false;
if(typeof(Storage) !== "undefined") {
    console.log("aaaaaaaa")
    window.sessionStorage.setItem("allow", allow);
} else {
    // Sorry! No Web Storage support..
}

window.onbeforeunload = function() { 
	  
	  console.log("=============="+allow)
	  if(allow == "true"){
		  window.sessionStorage.setItem("allow",false);
	  }else{
	  	return "Are you sure you want to back? All your progress will be lost!"; 
	  }
	 }; */
function logout(){
	if(document.getElementById("logout").innerHTML == "Logout")
		window.location.href = "logout.jsp?message=Loggedout successfully !";
	else
		window.location.href = "login.jsp";
}

function checkProperty(){ // check if the user is logged in successfully
	var isLoginSuccessful = document.getElementById("loggedIn").value; // getting property from a hidden field

	var isManager = $("#checkIsManager").val();
	if(isManager == 1){
		$("#tabs3idli").remove();
		$("#tabs4idli").remove();
		$("#tabs5idli").remove();
		$("#tabs7idli").remove();
		$("#tabs-3").remove();
		$("#tabs-4").remove();
		$("#tabs-5").remove();
		$("#tabs-7").remove();
	}else if(isManager == 0){
		$("#tabs1id").removeAttr("onclick");
		$("#tabs4id").removeAttr("onclick");

		$("#tabs2idli").remove();
		$("#tabs6idli").remove();
		$("#tabs-2").remove();
		$("#tabs-6").remove();
	}else if(isManager == 2){
		$("#tabs1id").removeAttr("onclick");
		$("#tabs3idli").remove();
		$("#tabs5idli").remove();
		$("#tabs-3").remove();
		$("#tabs-5").remove();
	}
	
	if(isLoginSuccessful == "false"){
		document.getElementById("error").style.color = "red";
		document.getElementById("logout").value = "Try Again?";
	}
}
$(document).ready( function () {    
	try{
		$('#table1').DataTable({  "columns": [  null,    
		                                        null,    
		                                        null,    
		                                        null,  
		                                        null, 
		                                        null, 
		                                        { "width": "20%" },
		                                        null
		]});
		$('#table2').DataTable();
	}catch(e){
		console.log("err ===>"+e)
	}
} );

$(function() {
    $( "#tabs" ).tabs();
  });
  
function cancelOrder(ele){
	var eleId = $(ele).attr("action");

	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { id: eleId, action: 18 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    
		    getOrderHistory();
		  });
} 
  
function saveOrder(ele){
	var eleId = $(ele).attr("action");
	try{
		var status = $( "#"+eleId+"_status" ).text();
		var review = $( "#"+eleId+"_review" ).text();
	}catch(e){
		console.log("----"+e)
	}
	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { id: eleId, status: status, review: review, action: 17 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		  });
}
  
function deleteUser(ele){
	var eleId = $(ele).attr("action");

	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { userId: eleId, action: 15 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    
		    getUsers();
		  });
}
  
function updatePermissions(ele){
	var eleId = $(ele).attr("action");
	//alert(eleId+"_check")
	try{
	var isChecked = $( "#"+eleId+"_check" ).prop('checked');
	if(isChecked){
		isChecked = 1;
	}else{
		isChecked = 0;
	}
	}catch(e){
		console.log("----"+e)
	}
	//alert(isChecked);
	makeRequest(isChecked,eleId);
}

function makeRequest(isChecked,userId){
	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { isManager: isChecked, userId: userId, action: 1 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		  });
}

function deleteItem(ele){
	var isManager = $("#checkIsManager").val();
	var eleId = $(ele).attr("action");
	console.log(eleId);
	
	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { id: eleId, action: 14 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    
		    if(isManager == 1){
		    	getProductsByManagerId();
		    }else{
		    	reloadSearchItems();
		    }
		  });
}

function updateItem(ele){
	var eleId = $(ele).attr("action");

	try{
		var name = $("#name_"+eleId).html();
		var type = $("#type_"+eleId).html();
		var artist = $("#artist_"+eleId).html();
		var price = $("#price_"+eleId).html();
		var stock = $("#stock_"+eleId).html();
		var desc = escape($("#desc_"+eleId).html());
	}catch(e){
		console.log("----"+e)
	}
	console.log(desc);
	makeRequestUpdateItem(eleId,name,type,artist,price,stock,desc);
}

function makeRequestUpdateItem(id,name,type,artist,price,stock,desc){
	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {id: id, name: name, type: type, artist: artist, price: price, stock: stock, desc: desc, action: 2 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		  });
}

function addtoCart(ele){
var eleId = $(ele).attr("action");
	
	try{
		var name = $("#name_"+eleId).html();
		
		var type = $("#type_"+eleId).html();
		var artist = $("#artist_"+eleId).html();
		var price = $("#price_"+eleId).html();
		var image = escape($("#img_"+eleId).attr("src"));
		var desc = escape($("#desc_"+eleId).html());
	}catch(e){
		console.log("----"+e)
	}
	var userId = $("#myId").val();
 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {id: eleId, name: name, type: type, artist: artist, price: price, image: image, desc: desc, customer: userId, action: 7 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		  }); 
}


function addtoWishList(ele){
	var eleId = $(ele).attr("action");
	
	try{
		var name = $("#name_"+eleId).html();
		
		var type = $("#type_"+eleId).html();
		var artist = $("#artist_"+eleId).html();
		var price = $("#price_"+eleId).html();
		var image = escape($("#img_"+eleId).attr("src"));
		var desc = escape($("#desc_"+eleId).html());
	}catch(e){
		console.log("----"+e)
	}
	var userId = $("#myId").val();
 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {id: eleId, name: name, type: type, artist: artist, price: price, image: image, desc: desc, customer: userId, action: 4 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		  }); 
}

function removeFromWishList(ele){
	var eleId = $(ele).attr("action");
	var userId = $("#myId").val();
 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {id: eleId, customer: userId, action: 5 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    if(msg == 1){
		    	console.log("---B4 calling---")
		    	getWishList();
		    	console.log("---Aftr calling---")
		    }
		  }); 
}

function removeFromCart(ele){
	var eleId = $(ele).attr("action");
	var userId = $("#myId").val();
 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {id: eleId, customer: userId, action: 9 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    if(msg == 1){
		    	console.log("---B4 calling---")
		    	showCart();
		    	console.log("---Aftr calling---")
		    }
		  }); 
}

function showCart(){

	var userId = $("#myId").val();
 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {customer: userId, action: 8 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    var text = "";
		    console.log(msg.length)
		     if(msg == "" || msg == null || msg.length == 0){
		    	text = "<center>No Items in your Cart!</center>";
		    }else{
		    	text = '<table id="table5" align="center" class="display" border="1" >';
		    	text += '<thead><tr><th>Name</th><th>Type</th><th>Artist</th><th>Price</th><th>image</th><th>Description</th><th>Action</th></tr></thead>';
		    	text += '<tbody>'
		    	for(var i=0;i<msg.length;i++){
		    		console.log( "Data Saved:---- " + msg[i].item_id );
		    		var desc = unescape(msg[i].item_description);
		    		var img = unescape(msg[i].image_url);
		    		text += '<tr  id="'+msg[i].item_id+'" >';
		    		text += '<td>'+msg[i].item_name+'</td>';
		    		text += '<td>'+msg[i].item_type+'</td>';
		    		text += '<td>'+msg[i].artist+'</td>';
		    		text += '<td>'+msg[i].price+'</td>';
		    		text += '<td><img src="'+img+'" alt=\"oops\" style=\"width:200px;height:200px\"></td>';
		    		text += '<td>'+desc+'</td>';
		    		text += '<td><button class="button" action='+msg[i].item_id+' onclick="removeFromCart(this)" id="cbutton_'+msg[i].item_id+'">delete</button></td>';
		    		text += '</tr>';
		    	}
		    	text += '</tbody>';
		    	text += '</table>';
		    	text += '<button align="center" class="button" onclick="proceedToCheckout()">Proceed to Checkout</button>';
		    }
		    
		    $("#tabs-5").html(text);
			$('#table5').DataTable({  "columns": [  null,    
			                                        null,    
			                                        null,    
			                                        null,  
			                                        null,  
			                                        { "width": "20%" },
			                                        null
			]});
		  }); 	
}

function getWishList(){

	var userId = $("#myId").val();
 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {customer: userId, action: 6 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    var text = "";
		    console.log(msg.length)
		     if(msg == "" || msg == null || msg.length == 0){
		    	text = "<center>No Items in your WishList!</center>";
		    }else{
		    	text = '<table id="table4" align="center" class="display" border="1" >';
		    	text += '<thead><tr><th>Name</th><th>Type</th><th>Artist</th><th>Price</th><th>image</th><th>Description</th><th>Action</th></tr></thead>';
		    	text += '<tbody>'
		    	for(var i=0;i<msg.length;i++){
		    		console.log( "Data Saved:---- " + msg[i].item_id );
		    		text += '<tr  id="'+msg[i].item_id+'" >';
		    		text += '<td>'+msg[i].item_name+'</td>';
		    		text += '<td>'+msg[i].item_type+'</td>';
		    		text += '<td>'+msg[i].artist+'</td>';
		    		text += '<td>'+msg[i].price+'</td>';
		    		text += '<td><img src="'+msg[i].image_url+'" alt=\"oops\" style=\"width:200px;height:200px\"></td>';
		    		text += '<td>'+msg[i].item_description+'</td>';
		    		text += '<td><button class="button" action='+msg[i].item_id+' onclick="removeFromWishList(this)" id="3button_'+msg[i].item_id+'">delete</button></td>';
		    		text += '</tr>';
		    	}
		    	text += '</tbody>';
		    	text += '</table>';
		    }
		    
		    $("#tabs-3").html(text);
			$('#table4').DataTable({  "columns": [  null,    
			                                        null,    
			                                        null,    
			                                        null,  
			                                        null,  
			                                        { "width": "20%" },
			                                        null
			]});
		  }); 
}

function getAccountDetails(){ // from contactUs
	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { action: 3 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg[0].email_id );
		    var text = "";
		    console.log(msg.length)
		    if(msg == "" || msg == null || msg.length == 0){
		    	text = "Oops... Something went wrong! :(";
		    }else{
		    	text = '<table id="table3" align="center" class="display" border="1" >';
		    	text += '<thead><tr><th>Name</th><th>email Id</th><th>Query</th></tr></thead>';
		    	text += '<tbody>'
		    	for(var i=0;i<msg.length;i++){
		    		console.log( "Data Saved:---- " + msg[i].contact_id );
		    		text += '<tr  id="'+msg[i].contact_id+'" >';
		    		text += '<td>'+msg[i].contact_name+'</td>';
		    		text += '<td>'+msg[i].email_id+'</td>';
		    		text += '<td>'+msg[i].query+'</td>';
		    		text += '</tr>';
		    	}
		    	text += '</tbody>';
		    	text += '</table>';
		    }
		    
		    $("#tabs-2").html(text);
		    $('#table3').DataTable();
		  });
}

function proceedToCheckout(){
	window.location.href = "checkout.jsp"
}

function getProductsByManagerId(){

	var userId = $("#myId").val();
 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {customer: userId, action: 11 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    var text = "";
		    console.log(msg.length)
		     if(msg == "" || msg == null || msg.length == 0){
		    	text = "<center>No Items in your Cart!</center>";
		    }else{
		    	text = '<table id="table1" align="center" class="display" border="1" >';
		    	text += '<thead><tr><th>Item Name</th><th>Item Type</th><th>Artist</th><th>Price</th><th>Stock</th><th>Item</th><th>Description</th><th></th></tr></thead>';
		    	text += '<tbody>'
		    	for(var i=0;i<msg.length;i++){
		    		console.log( "Data Saved:---- " + msg[i].item_id );
		    		var desc = unescape(msg[i].description);
		    		var img = unescape(msg[i].image_url);
		    		text += '<tr  id="'+msg[i].itemId+'" >';
		    		text += '<td>'+msg[i].itemName+'</td>';
		    		text += '<td>'+msg[i].itemType+'</td>';
		    		text += '<td>'+msg[i].artist+'</td>';
		    		text += '<td>'+msg[i].price+'</td>';
		    		text += '<td>'+msg[i].stock+'</td>';
		    		text += '<td><img src="'+img+'" alt=\"oops\" style=\"width:200px;height:200px\"></td>';
		    		text += '<td>'+desc+'</td>';
		    		text += '<td><button class="button" action='+msg[i].item_id+' onclick="updateItem(this)" id="button_'+msg[i].item_id+'">Save</button>';
		    		text += '<br/><br/><button class="button" action='+msg[i].item_id+' onclick="deleteItem(this)" id="dbutton_'+msg[i].item_id+'">Delete</button></td>';
		    		text += '</tr>';
		    	}
		    	text += '</tbody>';
		    	text += '</table>';
		    }
		    
		    $('#table1').DataTable().destroy();
		    $("#tabs-1").html("");
		    $("#tabs-1").html(text);
			$('#table1').DataTable({  "columns": [  null,    
			                                        null,    
			                                        null,    
			                                        null,  
			                                        null, 
			                                        null, 
			                                        { "width": "20%" },
			                                        null
			]});
		  }); 	
}

function reloadSearchItems(){

 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { action: 12 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    var text = "";
		    console.log(msg.length)
		     if(msg == "" || msg == null || msg.length == 0){
		    	text = "<center>Looks like something went wrong there..!</center>";
		    }else{
		    	text = '<table id="table1" align="center" class="display" border="1" >';
		    	text += '<thead><tr><th>Item Name</th><th>Item Type</th><th>Artist</th><th>Price</th><th>Stock</th><th>Item</th><th>Description</th><th></th></tr></thead>';
		    	text += '<tbody>'
		    	for(var i=0;i<msg.length;i++){
		    		console.log( "Data Saved:---- " + msg[i].itemId );
		    		var desc = unescape(msg[i].description);
		    		var img = unescape(msg[i].image_url);
		    		text += '<tr  id="'+msg[i].itemId+'" >';
		    		text += '<td>'+msg[i].itemName+'</td>';
		    		text += '<td>'+msg[i].itemType+'</td>';
		    		text += '<td>'+msg[i].artist+'</td>';
		    		text += '<td>'+msg[i].price+'</td>';
		    		text += '<td>'+msg[i].stock+'</td>';
		    		text += '<td><img src="'+img+'" alt=\"oops\" style=\"width:200px;height:200px\"></td>';
		    		text += '<td>'+desc+'</td>';
		    		text += '<td><button class="button" action='+msg[i].itemId+' onclick="updateItem(this)" id="button_'+msg[i].itemId+'">Save</button>';
		    		text += '<button class="button" action='+msg[i].itemId+' onclick="deleteItem(this)" id="dbutton_'+msg[i].itemId+'">Delete</button></td>';
		    		text += '</tr>';
		    	}
		    	text += '</tbody>';
		    	text += '</table>';
		    }
		    
		    $('#table1').DataTable().destroy();
		    $("#tabs-4").html("");
		    $("#tabs-4").html(text);
			$('#table1').DataTable({  "columns": [  null,    
			                                        null,    
			                                        null,    
			                                        null,  
			                                        null, 
			                                        null, 
			                                        { "width": "20%" },
			                                        null
			]});
		  }); 	
}

function getOrderHistory(){
	var userId = $("#myId").val();
	if(userId == null || userId == "null" || userId == "" || userId == undefined){
		userId = 0;
	}
	var isManager = $("#checkIsManager").val();
	
  	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: {customer: userId, action: 13 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    var text = "";
		    console.log(msg.length)
		     if(msg == "" || msg == null || msg.length == 0){
		    	text = "<center>No Order History found!</center>";
		    }else{
		    	text = '<table id="table7" style="width:100%" align="center" class="display" border="1" >';
		    	text += '<thead><tr><th>Transaction Id</th><th>Name</th><th>Surname</th><th>Payment Method</th><th>Price</th><th>Phone</th><th>Address</th><th>Date</th><th>Order Status</th><th>Reviews</th><th></th>';
		    	text += '</tr></thead>'
		    	text += '<tbody>'
		    	for(var i=0;i<msg.length;i++){
		    		console.log( "Data Saved:---- " + msg[i].purchase_id );
		    		text += '<tr  id="'+msg[i].purchase_id+'" >';
		    		text += '<td>'+msg[i].purchase_id+'</td>';
		    		text += '<td>'+msg[i].fname+'</td>';
		    		text += '<td>'+msg[i].lname+'</td>';
		    		text += '<td>'+msg[i].payment_method+'</td>';
		    		text += '<td>'+msg[i].price+'</td>';
		    		text += '<td>'+msg[i].phone+'</td>';
		    		text += '<td>'+msg[i].address+'</td>';
		    		text += '<td>'+msg[i].purchase_date+'</td>';

		    		if(isManager == 2){
		    			text += '<td contentEditable="true" id="'+msg[i].purchase_id+'_status">'+msg[i].order_status+'</td>';
		    			text += '<td id="'+msg[i].purchase_id+'_review">'+msg[i].purchase_review+'</td>';
		    			text += '<td><button class="button" action='+msg[i].purchase_id+' onclick="saveOrder(this)" id="pbutton_'+msg[i].purchase_id+'">Save</button>';
		    			text += '<br/><br/><button class="button" action='+msg[i].purchase_id+' onclick="cancelOrder(this)" id="pdbutton_'+msg[i].purchase_id+'">Cancel</button></td>';
		    		}else{
		    			text += '<td id="'+msg[i].purchase_id+'_status">'+msg[i].order_status+'</td>';
		    			text += '<td contentEditable="true" id="'+msg[i].purchase_id+'_review">'+msg[i].purchase_review+'</td>';
		    			text += '<td><button class="button" action='+msg[i].purchase_id+' onclick="saveOrder(this)" id="pbutton_'+msg[i].purchase_id+'">Save</button></td>';
		    		}
		    		
		    		text += '</tr>';
		    	}
		    	text += '</tbody>';
		    	text += '</table>';
		    }
		    
		    $("#tabs-7").html(text);
	    	$('#table7').DataTable({  "columns": [  null,null,null,null,null,null,{ "width": "20%" },null,null,null,null]});
	     
		  }); 	 
}

function getUsers(){

 	$.ajax({
		  method: "POST",
		  url: "TestServlet",
		  data: { action: 16 }
		})
		  .done(function( msg ) {
		    console.log( "Data Saved: " + msg );
		    var text = "";
		    console.log(msg.length)
		     if(msg == "" || msg == null || msg.length == 0){
		    	text = "<center>Looks like something went wrong there..!</center>";
		    }else{
		    	text = '<table id="table2" align="center" class="display" border="1" >';
		    	text += '<thead><tr><th>User Name</th><th>Is Manager</th><th></th></tr></thead>';
		    	text += '<tbody>'
		    	for(var i=0;i<msg.length;i++){
		    		console.log( "Data Saved:---- " + msg[i].userId );
		    		text += '<tr  id="'+msg[i].userId+'" >';
		    		text += '<td style="text-align:center">'+msg[i].username+'</td>';
		    		var isChecked = "";
				    if(msg[i].isManager == "1"){
				    	isChecked = "checked=\"checked\"";
				    }
		    		text += '<td style="text-align:center"><input '+isChecked+' onclick="updatePermissions(this)" type="checkbox" action='+msg[i].userId+' id="'+msg[i].userId+'_check" value='+msg[i].isManager+' /></td>';
		    		text += '<td style="text-align:center"><button onclick="deleteUser(this)" class="button" action='+msg[i].userId+' id="'+msg[i].userId+'"_btn">Delete</button></td>';
		    		text += '</tr>';
		    	}
		    	text += '</tbody>';
		    	text += '</table>';
		    }
		    
		    $('#table2').DataTable().destroy();
		    $("#tabs-1").html("");
		    $("#tabs-1").html(text);
			$('#table2').DataTable();
		  }); 	
}
</script>
</head>
<body style="font-family: Arial" onload="checkProperty()">
<%
String message = (String)request.getAttribute("message");
if(message == null)
	message = "";

String isLoginSuccessful = (String) request.getSession().getAttribute("isLoginSuccessful");
if(isLoginSuccessful == null){
	isLoginSuccessful = "false";
}
String myId = ""+request.getSession().getAttribute("userId");
User user = (User) request.getSession().getAttribute("userObject");
if(user == null){
	
}else if(user.getName() == null || user.getName().equals("")){
	
}else{
	message += user.getName();
}
if(user == null){
	
}else if(user.getLastName() == null || user.getLastName().equals("")){
	
}else{
	message += " "+user.getLastName();
}

if(message == null || message.equals("")){
	
}else{
	message = "Welcome "+message+" your login is successful !";
}

int isAManager = 0;
if(user == null){
	
}else{
	isAManager = user.getIsManager();
}

String prod = "";

%>
<div style="text-align: center;padding: 10px;">
<jsp:include page="nav.jsp" />
</div>
<%if(isLoginSuccessful.equals("true")){  %>
<form method="post" name="logout" action="LogoutServlet">
<input style="float: right;margin-right: 40px;" class="button" type="submit" id="logout" value="Logout" />
</form>
<div id="error" style="font-family: arial;color: green;text-align: center;"><%=message %></div>
<br>
<div id="tabs">
  <ul>
    <li id="tabs1idli"><a href="#tabs-1" id="tabs1id" onclick="getProductsByManagerId()">Home</a></li>
    <li id="tabs2idli"><a href="#tabs-2" id="tabs2id" onclick="getAccountDetails()">Notifications</a></li>
    <li id="tabs3idli"><a href="#tabs-3" id="tabs3id" onclick="getWishList()">Wish List</a></li>
    <li id="tabs5idli"><a href="#tabs-5" id="tabs5id" onclick="showCart()">Shopping Cart</a></li>
    <li id="tabs4idli"><a href="#tabs-4" id="tabs4id" onclick="reloadSearchItems()">Search</a></li>
    <li id="tabs6idli"><a href="#tabs-6" id="tabs6id">Vendor Upload</a></li>
    <li id="tabs7idli"><a href="#tabs-7" id="tabs7id" onclick="getOrderHistory()">Order History</a></li>
  </ul>
  <div id="tabs-1">
<div style="text-align: center;">
<%
	out.println("<input type=\"hidden\" id=\"myId\" value="+myId+" /> ");
	out.println("<input type=\"hidden\" id=\"checkIsManager\" value="+isAManager+" /> ");
	if(isAManager == 1){
		JSONArray json = (JSONArray) request.getSession().getAttribute("productList");
		StringBuilder sb = new StringBuilder();
		sb.append("<table id=\"table1\" style=\"width:100%\" align=\"center\" class=\"display\" border=\"1\">");
		sb.append("<thead>");
		sb.append("<tr>");
		sb.append("<th>Item Name</th>");
		sb.append("<th>Item Type</th>");
		sb.append("<th>Artist</th>");
		sb.append("<th>Price</th>");
		sb.append("<th>stock</th>");
		sb.append("<th>Item</th>");
		sb.append("<th>Description</th>");
		sb.append("<th></th>");
		sb.append("</tr>");
		sb.append("</thead>");
		sb.append("<tbody>");
		for (int i = 0; i < json.length(); i++) {
		    JSONObject jsonobject = json.getJSONObject(i);
		    String itemName = jsonobject.getString("itemName");
		    String artist = jsonobject.getString("artist");
		    String type = jsonobject.getString("itemType");
		    String price = jsonobject.getString("price");
		    String stock = jsonobject.getString("stock");
		    String image_url = jsonobject.getString("image_url");
		    String desc = jsonobject.getString("description");
		    String id = ""+jsonobject.getInt("itemId");
		    sb.append("<tr id="+id+">");
		    sb.append("<td contenteditable=\"true\" id='name_"+id+"'>"+itemName+"</td>");
		    sb.append("<td contenteditable=\"true\" id='type_"+id+"'>"+type+"</td>");
		    sb.append("<td contenteditable=\"true\" id='artist_"+id+"'>"+artist+"</td>");
		    sb.append("<td contenteditable=\"true\" id='price_"+id+"'>"+price+"</td>");
		    sb.append("<td contenteditable=\"true\" id='stock_"+id+"'>"+stock+"</td>");
		    
		    sb.append("<td><img id='img_"+id+"' src="+image_url+" alt=\"oops\" style=\"width:200px;height:200px\"></td>");
		    sb.append("<td contenteditable=\"true\" id='desc_"+id+"'>"+desc+"</td>");
		    sb.append("<td><button class='button' action="+id+" onclick='updateItem(this)' id='button_"+id+"'>Save</button>");
		    sb.append("<br/><br/><button class='button' action="+id+" onclick='deleteItem(this)' id='dbutton_"+id+"'>Delete</button></td>");
		    sb.append("</tr>");		
		}
		sb.append("</tbody>");
		sb.append("</table>");
		out.println(sb);
	}else if(isAManager == 2){ //admin
		JSONArray json = (JSONArray) request.getSession().getAttribute("userList");
		StringBuilder sb = new StringBuilder();
		sb.append("<table id=\"table2\" align=\"center\" class=\"display\" border=\"1\">");
		sb.append("<thead>");
		sb.append("<tr>");
		sb.append("<th>User Name</th>");
		sb.append("<th>Is Manager</th>");
		sb.append("<th></th>");
		sb.append("</tr>");
		sb.append("</thead>");
		sb.append("<tbody>");
		for (int i = 0; i < json.length(); i++) {
		    JSONObject jsonobject = json.getJSONObject(i);
		    String userId = ""+jsonobject.getInt("userId");
		    String username = jsonobject.getString("username");
		    String isManager = ""+jsonobject.getInt("isManager");		
		    sb.append("<tr id="+userId+">");
		    sb.append("<td>"+username+"</td>");
		    String isChecked = "";
		    if(isManager.equals("1")){
		    	isChecked = "checked=\"checked\"";
		    }
		    sb.append("<td><input "+isChecked+" onclick='updatePermissions(this)' type='checkbox' action="+userId+" id='"+userId+"_check' value="+isManager+" /></td>");
		    sb.append("<td><button onclick='deleteUser(this)' class=\"button\" action="+userId+" id='"+userId+"_btn'>Delete</button></td>");
		    sb.append("</tr>");			
		}
		sb.append("</tbody>");
		sb.append("</table>");
		out.println(sb);
	}else if(isAManager == 0){
		JSONArray json = (JSONArray) request.getSession().getAttribute("productList");
		
		StringBuilder sb = new StringBuilder();
		sb.append("<div class=\"container\"><div id=\"grid-gallery\" class=\"grid-gallery\"><section class=\"grid-wrap\"><ul class=\"grid\"><li class=\"grid-sizer\"></li>");
		
		StringBuilder list1 = new StringBuilder();
		StringBuilder list2 = new StringBuilder();
		for (int i = 0; i < json.length(); i++) {
		    JSONObject jsonobject = json.getJSONObject(i);
		    String itemName = jsonobject.getString("itemName");
		    String artist = jsonobject.getString("artist");
		    String type = jsonobject.getString("itemType");
		    String price = jsonobject.getString("price");
		    String stock = jsonobject.getString("stock");
		    String image_url = jsonobject.getString("image_url");
		    String desc = jsonobject.getString("description");
		    String id = ""+jsonobject.getInt("itemId");
		    
		    list1.append("<li><figure>");
		    list1.append("<img style=\"height: 200px;\" id='img_"+id+"' src="+image_url+" alt=\"oops\" />");
		    list1.append("<figcaption><h3 id='name_"+id+"'>"+itemName+"</h3><p id='artist_"+id+"'>"+artist+"</p><p id='type_"+id+"'>"+type+"</p></figcaption>");
		    list1.append("</figure></li>");
		    
		    list2.append("<li><figure style=\"overflow: scroll;\"><figcaption>");
		    list2.append("<img src="+image_url+" alt=\"oops\" />");
		    list2.append("<figcaption>");
		    list2.append("<p><b>"+itemName+"</b></p><p id=\"desc_"+id+"\">"+desc+"</p><p>By: <i>"+artist+"</i></p><p><span id=\"price_"+id+"\">"+price+"</span>$</p>");
		    list2.append("<button class='button' action="+id+" onclick='addtoWishList(this)' id='g2button_"+id+"'>Add to Wishlist</button>&nbsp;&nbsp;&nbsp;");
		    list2.append("<button class='button' action="+id+" onclick='addtoCart(this)' id='g1button_"+id+"'>Add to cart</button>");
		    list2.append("</figcaption>");
		    list2.append("</figure></li>");
		    
		}
			
		sb.append(list1);
		
		sb.append("</ul></section>");
		
		sb.append("<section class=\"slideshow\"><ul>");
		
		sb.append(list2);
		
		sb.append("</ul>");
		
		sb.append("<nav><span style=\"display: none;\" class=\"icon nav-prev\"></span><span style=\"display: none;\" class=\"icon nav-next\"></span><span class=\"icon nav-close\"></span></nav>");
		sb.append("<div class=\"info-keys icon\">Navigate with arrow keys</div>");
		sb.append("</section></div></div>");
		out.println(sb);
	}
	
%>
</div>
  </div>
  <div id="tabs-2">

  </div>
     <div id="tabs-5">

  </div>
  <div id="tabs-6">
<iframe style="height: 500px; width: 100%;" frameBorder="0" scrolling="no" src="VendorUpload.jsp"></iframe>
  </div>
     <div id="tabs-7">

  </div>
   <div id="tabs-3">

  </div>
     <div id="tabs-4">
<%
if(isAManager != 1){
	String editable = "";
	if(isAManager == 0){
		
	}else{
		editable = "contenteditable=\"true\"";
	}
	
	JSONArray json = (JSONArray) request.getSession().getAttribute("productList");
	StringBuilder sb = new StringBuilder();
	sb.append("<table id=\"table1\" style=\"width:100%\" align=\"center\" class=\"display\" border=\"1\">");
	sb.append("<thead>");
	sb.append("<tr>");
	sb.append("<th>Item Name</th>");
	sb.append("<th>Item Type</th>");
	sb.append("<th>Artist</th>");
	sb.append("<th>Price</th>");
	sb.append("<th>stock</th>");
	sb.append("<th>Item</th>");
	sb.append("<th>Description</th>");
	sb.append("<th></th>");
	sb.append("</tr>");
	sb.append("</thead>");
	sb.append("<tbody>");
	for (int i = 0; i < json.length(); i++) {
	    JSONObject jsonobject = json.getJSONObject(i);
	    String itemName = jsonobject.getString("itemName");
	    String artist = jsonobject.getString("artist");
	    String type = jsonobject.getString("itemType");
	    String price = jsonobject.getString("price");
	    String stock = jsonobject.getString("stock");
	    String image_url = jsonobject.getString("image_url");
	    String desc = jsonobject.getString("description");
	    String id = ""+jsonobject.getInt("itemId");
	    sb.append("<tr id="+id+">");
	    sb.append("<td "+editable+" id='name_"+id+"'>"+itemName+"</td>");
	    sb.append("<td "+editable+" id='type_"+id+"'>"+type+"</td>");
	    sb.append("<td "+editable+" id='artist_"+id+"'>"+artist+"</td>");
	    sb.append("<td "+editable+" id='price_"+id+"'>"+price+"</td>");
	    sb.append("<td "+editable+" id='stock_"+id+"'>"+stock+"</td>");
	    
	    sb.append("<td><img id='img_"+id+"' src="+image_url+" alt=\"oops\" style=\"width:200px;height:200px\"></td>");
	    sb.append("<td "+editable+" id='desc_"+id+"'>"+desc+"</td>");
	    sb.append("<td>");
	    if(isAManager != 0){
	    	sb.append("<button class='button' action="+id+" onclick='updateItem(this)' id='button_"+id+"'>Save</button>");
	    	sb.append("<br/><br/><button class='button' action="+id+" onclick='deleteItem(this)' id='dbutton_"+id+"'>Delete</button>");
	    }else{
	    	sb.append("<button class='button' action="+id+" onclick='addtoWishList(this)' id='2button_"+id+"'>Add to wishlist</button>");
	    	sb.append("<br/><br/><div style=\"text-align:center\"><button class='button' action="+id+" onclick='addtoCart(this)' id='3button_"+id+"'>Add to cart</button></div>");
	    }
	    sb.append("</td>");	
	    sb.append("</tr>");		
	}
	sb.append("</tbody>");
	sb.append("</table>");
	out.println(sb);
}

}else{ %>
<div style="text-align: center;">You must first login to access this page !</div>
<%} %>
  </div>
<input type="hidden" id="loggedIn" value=<%=isLoginSuccessful%>></input> <!-- storing property in hidden field -->
<script type="text/javascript" charset="utf8" src="DataTables-1.10.6/media/js/jquery.dataTables.js"></script>
		<script src="GridGallery/GridGallery/js/imagesloaded.pkgd.min.js"></script>
		<script src="GridGallery/GridGallery/js/masonry.pkgd.min.js"></script>
		<script src="GridGallery/GridGallery/js/classie.js"></script>
		<script src="GridGallery/GridGallery/js/cbpGridGallery.js"></script>
		<script>
			new CBPGridGallery( document.getElementById( 'grid-gallery' ) );
		</script>
</body>
</html>