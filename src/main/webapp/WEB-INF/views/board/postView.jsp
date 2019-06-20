<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
	<title>게시판</title>
    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
	<meta name="viewport" content="width=device-width, user-scalable=no">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<!-- default header name is X-CSRF-TOKEN -->
	<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
	<meta id="_csrf" name="_csrf" content="${_csrf.token}" />

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="<c:url value='/resources/js/bootstrap.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

	<script>
		var request = new XMLHttpRequest();
		function deletePost(bid) {
			request.open('GET', '<c:url value='/deletePost/'/>' + bid, true);
			request.onreadystatechange = deleteProcess;
			request.send(null);
		}

		function deleteProcess() {
			var result = request.setRequestHeader

			if (request.status == 200 && request.readyState == 4) {
				if (result)
					location.href='<c:url value='/' />';
				else {
					alert('삭제 실패하였습니다.');
				}
			}
		}
	</script>
	<style>
		@media ( max-width : 1070px) {

			#tools {
				padding-left: 180px;
				padding-bottom: 30px;
			}
		}

		@media ( min-width : 1070px) {
			#postTable {
				margin-left: auto;
			}

			.container-fluid {
				width: 1000px;
			}

			#tools {
				margin-top: auto;
			}
		}
		.jumbotron {
			background-image: url('<c:url value="/resources/image/memo-jumbotron-backgorund.jpg"/>');
			background-size: cover;
			background-repeat: no-repeat;
			text-shadow: 0.1em 0.1em 0.1em dimgray;
			color: white;
		}

		#logoutB {
			color: white;
			margin: 1%;
		}

		#viewBody {
			width: 100%;
			min-height: 50%;
			padding: 4px;
			padding-left: 20px;
			padding-right: 20px;
			border: 1px solid #CED4DA;
			border-radius: 15px 15px;
		}

        #fileBody {
			width: 100%;
			padding-top: 20px;
			padding-left: 20px;
			padding-right: 20px;
            float: left;
            border: 1px solid #CED4DA;
            border-radius: 15px 15px;
        }

        #subTitle {
            overflow-x: hidden;
            overflow-y: hidden;
			color: gray;
			border-bottom: 1px solid #CED4DA;
			padding-bottom: 3%;
		}

		#contentBody {
			min-height: 40%;
			border-color: white;
			word-break: break-all;
		}

		img {
			max-width: 100%;
			height: auto !important;
		}
	</style>

	<c:if test="${!possibility}">
		<script>
			location.href='/';
		</script>
	</c:if>
</head>

<body>

	<div class="container-fluid">
		<header>
			<p><a id="logoutB" class="btn btn-warning btn-sm float-right" onclick="document.getElementById('logout').submit();">로그아웃</a></p>
			<div id="id" class="jumbotron">
				<div>
					<p><h1 class="text-center">Choi's 게시판</h1></p>
					<p class="text-center">자유롭게 글을 작성해보세요!</p>
				</div>
			</div>
		</header>
		
		<div id="viewBody">
			<h1 class="text-center">${dto.TITLE}</h1>
			<p id="subTitle" class="text-center">작성자: ${dto.WRITER} 작성일: ${dto.WDATE}</p>
			<div id="contentBody">
				${dto.CONTENT}
			</div>
		</div>

		<br>
		<c:if test="${!empty dto.FILE_ARRAY}">
			<div id="fileBody">
				<c:forEach var="dto" items="${dto.FILE_ARRAY}" varStatus="status">
					<p><a class="fa fa-download" href="<c:url value="/fileDownload/${dto}"/>"> ${dto}</a></p>
				</c:forEach>
			</div>
			<br><br><br>
		</c:if>
		
		<div id="tools" class="float-right">
			<a class="btn btn-danger btn-sm" style="color: white" onclick="deletePost('${dto.BID}');">삭제</a>
			<a class="btn btn-outline-success btn-sm" href="<c:url value="/modifyPage/"/>/${dto.BID}">수정</a>
			<a class="btn btn-primary active btn-sm" href='<c:url value="/" />'>목록</a>
		</div>

	</div><!-- 최상위 container 태그 -->
    <div style="display: none">
        <c:url value="/logout" var="logout" />
        <form action="${logout}" method="POST" id="logout">
            <input type="hidden" name="${_csrf.parameterName}"
                   value="${_csrf.token}" />
            <button type="submit">로그아웃</button>
        </form>
    </div>
</body>
</html>