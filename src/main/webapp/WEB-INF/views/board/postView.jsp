<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
	<title>게시판</title>
	<meta name="viewport" content="width=device-width, user-scalable=no">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<!-- default header name is X-CSRF-TOKEN -->
	<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
	<meta id="_csrf" name="_csrf" content="${_csrf.token}" />

	<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="<c:url value='/resources/js/bootstrap.js'/>"></script>

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
			min-height: 50%;
			padding: 4px;
			padding-left: 20px;
			padding-right: 20px;
			border: 1px solid #CED4DA;
			border-radius: 15px 15px;
		}

		#subTitle {
			color: gray;
			border-bottom: 1px solid #CED4DA;
			margin-left: 1%;
			margin-right: 1%;
			padding-bottom: 3%;
		}

		#contentBody {
			min-height: 40%;
			border-color: white;
			width: 100%;
			word-break:break-all;
		}
	</style>

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
		
		<div id="tools" class="float-right">
			<a class="btn btn-danger btn-sm" style="color: white" onclick="deletePost('${dto.BID}');">삭제</a>
			<a class="btn btn-outline-success btn-sm" href="/modifyPage/${dto.BID}">수정</a>
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