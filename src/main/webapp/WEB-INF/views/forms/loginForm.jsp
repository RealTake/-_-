<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, user-scalable=no">

<title>로그인 페이지</title>

<link rel="stylesheet" href="./resources/css/bootstrap.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="./resources/js/bootstrap.js"></script>

<style>
 
    body{
      overflow-x: hidden;
      overflow-y: hidden;
      background: url('./resources/image/pier-569314.jpg') no-repeat center fixed;
      background-size: cover;
    }

    @media screen and (min-width: 1081px){
    
	   .tableL {
	      border: 1px solid #CED4DA;
	      border-radius: 15px 15px;
	      width: 400px;
	      height: 300px;  
	      margin-left: auto;
	      margin-right: auto;
	      margin-bottom: 100%;
	      margin-top: 15%;
	      padding-left: 50px;
	      padding-right: 50px;
	      padding-top: 40px;
	      box-shadow: 0.1em 0.1em dimgray;
	      background-color: white;
	   }
   
   }
    
    @media screen and (max-width: 1080px){
    
	   .tableL {
	      border: 1px solid #CED4DA;
	      border-radius: 15px 15px;
	      width: 300px;
	      height: 300px;  
	      margin-left: auto;
	      margin-right: auto;
	      margin-bottom: 100%;
	      margin-top: 15%;
	      padding-left: 50px;
	      padding-right: 50px;
	      padding-top: 40px;
	      box-shadow: 0.1em 0.1em dimgray;
	      background-color: white;
	   }
   
   }
   .blur {
      -webkit-filter: blur(5px); 
      -moz-filter: blur(5px); 
      -o-filter: blur(5px); 
      -ms-filter: blur(5px); 
      filter: blur(5px); 
   }
   
   .footer {
       bottom:0;
       width:100%;
       height: 100%;   
       background-color: yellow;
   }
  

</style>


</head>
<body>
			<div class="tableL">
				<form action="<c:url value="/login"/>" method="POST" class="form-signin" >
					<h2 class="form-signin-heading">Please Login</h2><br>
					<p><label for="id" class="sr-only">아이디</label>
					<input name="id" class="form-control" type="text" placeholder="Email address" required autofocus/>
					
					<label for="password" class="sr-only">패스워드</label>
					<input name="password" class="form-control" type="password" placeholder="Password" required/></p>
					
					<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
					<input type="submit" class="btn btn-lg btn-primary btn-block" value="로그인"/>
				</form>
			</div>
			
</body>
</html>