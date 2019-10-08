<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
    <title>게시판</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width">

    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap/bootstrap.css'/>">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jQuery-ui-Slider-Pips/1.11.4/jquery-ui-slider-pips.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/etc/sideBar.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/etc/mainTemplate.css'/>">
	<link rel="stylesheet" href="<c:url value='/resources/css/page/main.css'/>">
	<link rel="stylesheet" href="<c:url value='/resources/css/page/myPage.css'/>">

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script><%--제이쿼리--%>
	<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script><%--드래그가 가능하게 하는 lib--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jQuery-ui-Slider-Pips/1.11.4/jquery-ui-slider-pips.js"></script>

    <script type="text/javascript">
	    var csrf = {};
	    csrf["${_csrf.headerName}"] = "${_csrf.token}";
	    var CONTEXT = "${pageContext.request.contextPath}";
    </script>
    	
    <script defer src="https://use.fontawesome.com/releases/v5.0.8/js/solid.js" integrity="sha384-+Ga2s7YBbhOD6nie0DzrZpJes+b2K1xkpKxTFFcx59QmVPaSA8c7pycsNaFwUK6l" crossorigin="anonymous"></script>
	<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/fontawesome.js" integrity="sha384-7ox8Q2yzO/uWircfojVuCQOZl+ZZBg2D2J5nkpLqzH1HY0C1dHlTKIbpRz/LG23c" crossorigin="anonymous"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.6/umd/popper.min.js"></script>
    <script src="<c:url value='/resources/js/bootstrap/bootstrap.min.js'/>"></script><%--부트스트랩--%>
     <script src="<c:url value='/resources/js/page/myPage.js'/>"></script>

</head>
<body>
	<div class="background"></div>
	
    <div class="container-fluid">

		<br>

        <div class="myProfile">
        	<p><div id="myProfile-image"></div></p>
	        <div class="intro">
	        
		         <form id="myProfile-update">
			        <p>NAME : </p>
			        <p><input id="NAME" class="form-control" type="name" value="${AccountInfo.NAME}" placeholder="${AccountInfo.NAME}" autofocus></p>
		        	<p>EMAIL : </p>
		        	<p><input id="EMAIL" class="form-control" type="email" value="${AccountInfo.EMAIL}" placeholder="${AccountInfo.EMAIL}"  autofocus></p>
		        	<p>NEW PASSWORD : </p>
			        <p><input id="PWD" class="form-control" type="password" autofocus></p>
		        	
		        	<p>PASSWORD : </p>
			        <p><input id="PWD" class="form-control" type="password" required autofocus></p>
			        
		        	<button id="send-myProfile" type="submit" class="btn btn-success" disabled="disabled">수정</button>&nbsp;<button id="cancel-update" type="button" class="btn btn-danger">취소</button>
		        </form>
		        
		        <div id="myProfile-view">
		        	<p>ID : ${AccountInfo.ID}</p>
	               	<p>NAME : ${AccountInfo.NAME}</p>
	                <p>EMAIL : ${AccountInfo.EMAIL}</p>
	                <p><button id="update-myProfile" class="btn btn-success">수정</button>&nbsp;<button id="delete-Account" class="btn btn-danger">계정 삭제</button></p>
                </div>
             
	        </div>
        </div>

		<br>

		<form class="form-inline my-2 my-lg-0">
        	<input id="searchContent" class="form-control mr-sm-2" type="search" placeholder="Search" >
        </form>

        <section class="board-container">
	
			<h1>Boards</h1>
	
	        <div id="boards-contentBody" class="contentBody"></div>
	        
	        <div id="boards-slider" class="custom-slider"></div>
	        
		</section>
		
		<br><br>
		
		<section class="board-container">
	
			<h1>Free_Borads</h1>
	
	        <div id="free_boards-contentBody" class="contentBody"></div>
	  
	        <div id="free_boards-slider" class="custom-slider"></div>
	        
		</section>
        
        <br>
        
    </div> <%--컨테이너--%>

	<%@ include file="../etc/sidebar.jspf" %>
	

<%--                    보이지 않는 기능                     --%>
    <div style="display: none">
        <form action="<c:url value="/logout"/>" method="POST" id="logout">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </div>
</body>
</html>