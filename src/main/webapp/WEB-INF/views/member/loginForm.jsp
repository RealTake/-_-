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
    <link rel="stylesheet" type="text/css" href="./resources/css/page/login.css?v=3">

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="<c:url value='/resources/js/bootstrap/bootstrap.js'/>"></script>

<s:authorize access="isAuthenticated()">
	 <c:redirect url="/"/>
</s:authorize>

</head>
	<body>	
		<div class = "body">
			<div class="jumbotron">
			<br>
			<br>
				<div class="content text-center">
					<div class="sideContent"><h1>Choi's 게시판</h1></div>
					<div class="sideContent">
						<p>자유롭게 글을 써보세요!</p>
						<p>다른 사람들과 글을 공유 해보세요!</p>
					</div>
				</div>
				<div class="footer">
			        <div>Developed by 최원상</div>
			        <div>PH: 010-9327-2497</div>
			        <div>EMAIL: chldnjstkd2@naver.com</div>
				</div>
		    </div>
		
		    <form action="<c:url value="/login"/>" method="POST" class = "center">
		    	
		    	<h1>Log in</h1>
		    	<br>
		    	<div>
		    		<div class="ls_line"></div>
		    		<div id="msg"></div>
		    	</div>
		        <input name="id" class="underline" type="text" placeholder="ID" required autofocus/>
		        <input name="password" class="underline" type="password" placeholder="PASSWORD" required/>
		        <input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
		        <button type="submit" id="loginB" value="Login">Login</button>
		        <p><a id="joinB" href="<c:url value='/joinMember'/>">Sign Up</a></p>
		    </form>
		    
		</div>
		
		    <c:if test="${null != param.error}">
		        <script>
		            var msg = $('#msg');
		            msg[0].innerHTML = '<strong>Login failed</strong><br><strong>Please try again</strong>';
		            msg.css('marginTop', '30px');
		        </script>
		    </c:if>
		    
	</body>
</html>