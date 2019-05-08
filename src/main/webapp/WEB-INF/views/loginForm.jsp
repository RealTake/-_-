<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>로그인 페이지</title>
</head>
<body>
	<h1>로그인 페이지입니다.</h1>
	<form action="<c:url value="/logout"/>" method="POST">
		<input name="id" type="text"/>
		<input name="password" type="password"/>
		<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
		<input type="submit" value="로그인"/>
	</form>
</body>
</html>