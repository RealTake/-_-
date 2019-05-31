<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
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
		font-family: "맑은 고딕";
		background-color: #5e91f8;
    }

	.loginBody {
		border: 1px solid #CED4DA;
		border-radius: 10px 10px;
		width: 700px;
		height: 400px;
		margin: auto;
		margin-top: 2%;
		padding-left: 80px;
		padding-right: 80px;
		padding-top: 80px;
		padding-bottom: 40px;
		box-shadow: 0px 1px 10px #434e9a;
		background-color: white;
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

   .form-signin {
	   margin-top: auto;
	   margin-bottom: auto;
   }

   .form-control {
	   font-size: 20px;
	   margin-bottom: 20px;
	   padding-top: 30px;
	   padding-bottom: 30px;
   }

	.form-heading {
		margin-top: 7%;
		color: white;
		text-align: center;
	}

	#login {

		margin-top: 30px;
		border: none;
		height: 59px;
		background-color: #5e91f8;
	}

</style>

<s:authorize access="isAuthenticated()">
	 <c:redirect url="/"/>
</s:authorize>

</head>
<body>

	<div class="form-heading">
		<h1>Welcome back!</h1>
	</div>

	<div class="loginBody">
		<form action="<c:url value="/login"/>" method="POST" class="form-signin" >
			<p>
				<label for="id" class="sr-only">Id</label>
				<input name="id" class="form-control" type="text" placeholder="Email address" required autofocus/>
				<label for="password" class="sr-only">Password</label>
				<input name="password" class="form-control" type="password" placeholder="Password" required/>
			</p>

			<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
			<input type="submit" id="login" class="btn btn-lg btn-primary btn-block" value="Login"/>
		</form>
	</div>
</body>
</html>