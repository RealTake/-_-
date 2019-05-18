<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>

<link rel="stylesheet" href="./resources/css/bootstrap.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="./resources/js/bootstrap.js"></script>

<style>

	
	.tableL {
		border: 1px solid #CED4DA;
		border-radius: 15px 15px;
		width: 400px;
		margin-left: auto;
		margin-right: auto;
		padding-left: 50px;
		padding-right: 50px;
		padding-top: 50px;
		padding-bottom: 50px;
		box-shadow: 0.1em 0.1em gray;
	}
	
	body {
		padding: 10%;
		
	}

</style>

</head>
<body>
	<div class="tableL">
			<form action="<c:url value="/login"/>" method="POST" class="form-signin" >
				<h2 class="form-signin-heading">로그인 해주세요</h2>
				
				<label for="id" class="sr-only">아이디</label>
				<input name="id" class="form-control type="text" placeholder="Email address" required autofocus/>
				
				<label for="password" class="sr-only">패스워드</label>
				<input name="password" class="form-control type="password" placeholder="Password" required/>
				
				<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
				<input type="submit" class="btn btn-lg btn-primary btn-block" value="로그인"/>
			</form>
	</div>
</body>
</html>