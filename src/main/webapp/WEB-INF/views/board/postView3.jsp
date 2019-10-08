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
	<link rel="stylesheet" href="<c:url value='/resources/css/page/postView3.css'/>">

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script><%--제이쿼리--%>
    <script src="http://malsup.github.io/min/jquery.form.min.js"></script><%--폼태그 ajax 변환--%>

    <script type="text/javascript">
	    var csrf = {};
	    csrf["${_csrf.headerName}"] = "${_csrf.token}";
	    var bid = "${dto.BID}";
	    var CONTEXT = "${pageContext.request.contextPath}";
	
	    $().ready( function () {
	            CKEDITOR.replace("editor1",{
	                extraPlugins : 'confighelper',
	                filebrowserImageUploadUrl:'<c:url value="/imageUpload.do/image"/>?${_csrf.parameterName}=${_csrf.token}'
	            });
	            CKEDITOR.addCss('img{max-width: 100%; height: auto !important;}');
	        }
	    );
    </script>
    	
    <script defer src="https://use.fontawesome.com/releases/v5.0.8/js/solid.js" integrity="sha384-+Ga2s7YBbhOD6nie0DzrZpJes+b2K1xkpKxTFFcx59QmVPaSA8c7pycsNaFwUK6l" crossorigin="anonymous"></script>
	<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/fontawesome.js" integrity="sha384-7ox8Q2yzO/uWircfojVuCQOZl+ZZBg2D2J5nkpLqzH1HY0C1dHlTKIbpRz/LG23c" crossorigin="anonymous"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.6/umd/popper.min.js"></script>
    <script src="<c:url value='/resources/js/bootstrap/bootstrap.min.js'/>"></script><%--부트스트랩--%>
    <script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script><%--웹 에디터--%>
    <script src="<c:url value='/resources/js/lib/checkByte.js'/>"></script> <%--바이트 체크 함수--%>
    <script src="<c:url value='/resources/js/page/combinFunction.js'/>"></script><%--뷰, 메인 화면 공동 기능--%>
    <script src="<c:url value='/resources/js/page/postView.js'/>"></script>
    
    <c:if test="${dto == null}">
	    <script>
	        location.href="<c:url value='/board2'/>";
	    </script>
	</c:if>
	
</head>
<body>
	<div class="background"></div>
	
    <div class="container-fluid">

        <div class="main-header">
	        <div class="intro text-center">
	        	<p><h1>${dto.TITLE}</h1></p>
		        <p id="writer">Writer: ${dto.WRITER}</p>
		        <p id="date">Date : ${dto.WDATE}</p>
	        </div>
        </div>

        <div id="postBody">${dto.CONTENT}</div>
    
    <c:if test="${!empty dto.FILE_ARRAY}">
        <div id="fileBody">
            <c:forEach var="file" items="${dto.FILE_ARRAY}" varStatus="status">
                <p><a href="<c:url value="/fileDownload/${file}"/>"><i class="fa fa-download"></i> ${file}</a></p>
            </c:forEach>
        </div>
    </c:if>

	<div id="etcButton" class="btn-group" role="group" >
	
		<s:authorize access="hasRole('ROLE_ADMIN') or ${pageContext.request.userPrincipal.name eq dto.WRITER}">
        	<button class="btn btn-secondary" style="color: white" id="delB">삭제</button>
            <button class="btn btn-secondary" id="modifyB">수정</button>
        </s:authorize>
        
        <a class="btn btn-secondary" href='<c:url value="/board2" />'>목록</a>
        
	</div>
        
    </div> <%--컨테이너--%>
    
    <%@ include file="../etc/writeTable.jspf" %>
	<%@ include file="../etc/sidebar.jspf" %>
	

<%--                    보이지 않는 기능                     --%>
    <div style="display: none">
        <form action="<c:url value="/logout"/>" method="POST" id="logout">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </div>
</body>
</html>