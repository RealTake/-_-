<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인 페이지</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no">

    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
    <link rel="stylesheet" href="<c:url value="/resources/css/bootstrap/bootstrap.css"/>">
    <link rel="stylesheet" type="text/css" href="./resources/css/page/joinMember.css">

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="<c:url value="/resources/js/bootstrap/bootstrap.js"/>"></script>
    <script>
   	 	var CONTEXT = "${pageContext.request.contextPath}";
    </script> 
    <script src="<c:url value="/resources/js/page/joinMember.js"/>"></script>
 
    <s:authorize access="isAuthenticated()">
        <c:redirect url="/"/>
    </s:authorize>

</head>
<body>
<div class = "body">
    <form action="<c:url value="/join"/>" method="POST" class="center" id="joinForm">
        <input name="NAME" id="NAME" class="underline" type="text" placeholder="NAME" required autofocus/>
        <tip id="NAMETip">Name: 1-10</tip>

        <input name="EMAIL" id="EMAIL" class="underline noen" type="email" placeholder="EMAIL" required autofocus/>
        <tip id="EMAILTip">Email: 일부 이메일은 지원이 안될수도있습니다.</tip>

        <input name="ID" id="ID" class="underline noen" type="text" placeholder="ID" required autofocus/>
        <tip id="IDTip">Id: 5-16</tip>

        <input name="PASSWORD" id="PASSWORD" class="underline noen" type="password" placeholder="PASSWORD" required autofocus/>
        <tip id="PASSWORDTip">Password: 8-16</tip>

        <input name="PASSWORDV" id="PASSWORDV" class="underline noen" type="password" placeholder="PASSWORD VALID" required autofocus/>
        <tip id="PWDTip">팁: 비밀번호를 한번 더 입력해주세요.</tip>

        <input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
        <button type="submit" id="joinB" disabled>Join</button>
    </form>
</div>
</body>
</html>