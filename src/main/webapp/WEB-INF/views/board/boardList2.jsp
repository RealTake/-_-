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

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script><%--제이쿼리--%>
    <script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script><%--드래그가 가능하게 하는 lib--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jQuery-ui-Slider-Pips/1.11.4/jquery-ui-slider-pips.js"></script>
    <script src="http://malsup.github.io/min/jquery.form.min.js"></script><%--폼태그 ajax 변환--%>

    <script type="text/javascript">
       var csrf = {};
       csrf["${_csrf.headerName}"] = "${_csrf.token}";

       $().ready( function () {
               CKEDITOR.replace("editor1",{
                   extraPlugins : 'confighelper',
                   filebrowserImageUploadUrl:'<c:url value="/imageUpload.do/image"/>?${_csrf.parameterName}=${_csrf.token}'
               });
               CKEDITOR.addCss('img{max-width: 100%; height: auto !important;}');
               
           }
       
       );
       var name = "${pageContext.request.userPrincipal.name}";
       var auth = "${AccountInfo.AUTHORITY}";
       var CONTEXT = "${pageContext.request.contextPath}";
    </script>
    	
    <script defer src="https://use.fontawesome.com/releases/v5.0.8/js/solid.js" integrity="sha384-+Ga2s7YBbhOD6nie0DzrZpJes+b2K1xkpKxTFFcx59QmVPaSA8c7pycsNaFwUK6l" crossorigin="anonymous"></script>
	<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/fontawesome.js" integrity="sha384-7ox8Q2yzO/uWircfojVuCQOZl+ZZBg2D2J5nkpLqzH1HY0C1dHlTKIbpRz/LG23c" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.6/umd/popper.min.js"></script>
    <script src="<c:url value='/resources/js/bootstrap/bootstrap.min.js'/>"></script><%--부트스트랩--%>

    <script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script><%--웹 에디터--%>
    <script src="<c:url value='/resources/js/lib/checkByte.js'/>"></script> <%--바이트 체크 함수--%>
    <script src="<c:url value='/resources/js/page/boardList2.js'/>"></script> <%-- 기능(Ajax) 함수--%>
    <script src="<c:url value='/resources/js/page/boardList2UI.js'/>"></script> <%--유저 인터페이스 컨트롤 함수--%>
    <script src="<c:url value='/resources/js/page/combinFunction.js'/>"></script><%--뷰, 메인 화면 공동 기능--%>
</head>
<body>
	<div class="background"></div>
    <div class="container-fluid">

        <nav class="main-header">
	        <div class="intro">
	        	<h1>Choi's 게시판</h1>
	            <p>Developed by 최원상</p>
	            <p>PH: 010-9327-2497</p>
	            <p>EMAIL: chldnjstkd2@naver.com</p>
	        </div>
           
            <form class="form-inline my-2 my-lg-0">
                    <input id="searchContent" class="form-control mr-sm-2" type="search" placeholder="Search" >
            </form>

        </nav>

        <!-- <div id="pageN" class="text-center"></div> -->
        
        <div id="category">
				
			<div class="category-list list-group">
				<a href="#boards-contentBody" class="list-group-item list-group-item-action">Boards</a>
				<a href="#free_boards-contentBody" class="list-group-item list-group-item-action">Free_Borads</a>
			</div>
			
			<div class="deleteBox">
	            <i class="fas fa-trash-alt" ></i>
	        </div>
	        
		</div>
        
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
    
    <%@ include file="../etc/writeTable.jspf" %>
	<%@ include file="../etc/sidebar.jspf" %>
	
	<!-- <button id="writeB" class="btn btn-dark">글쓰기</button> -->
    <button id="prev">prev</button>
    <button id="next">next</button>
	
<%--                    보이지 않는 기능                     --%>
    <div style="display: none">
        <form action="<c:url value="/logout"/>" method="POST" id="logout">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </div>
</body>
</html>