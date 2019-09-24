<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인 페이지</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no">

    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap/bootstrap.css'/>">
    <link rel="stylesheet" type="text/css" href="./resources/css/page/login.css">

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="<c:url value='/resources/js/bootstrap/bootstrap.js'/>"></script>

<s:authorize access="isAuthenticated()">
	 <c:redirect url="/"/>
</s:authorize>

</head>
<body>
<div class = "body">
    <form action="<c:url value="/login"/>" method="POST" class = "center">
        <div id="msg"></div>
        <input name="id" class="underline" type="text" placeholder="ID" required autofocus/>
        <input name="password" class="underline" type="password" placeholder="PASSWORD" required/>
        <input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
        <button type="submit" id="loginB" value="Login">Login</button>
        <a id="joinB" href="<c:url value='/joinMember'/>">Sign Up</a>
    </form>
</div>
    <c:if test="${null != param.error}">
        <script>
            var msg = $('#msg');
            msg[0].innerHTML = '<strong>Login failed. Please try again</strong>';
            msg.css('color', 'gray');
            msg.css('marginTop', '30px');
            msg.css('marginBottom', '20px');
        </script>
    </c:if>
</body>
</html>