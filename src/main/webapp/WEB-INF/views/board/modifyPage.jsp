<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>

<head>
<title>수정하기</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
<meta name="viewport" content="width=device-width, user-scalable=no">

<link rel="stylesheet" href="../../resources/css/bootstrap.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="../../resources/js/bootstrap.js"></script>

<style>
	#logout {
		color: white;
		margin: 1%;
	}
	#writeB {
		color: white;
		position: fixed;
		right: 10%;
		bottom: 5%;
	}

	#writeTable P {
		color: black;
	}
	
	.jumbotron {
		background-image: url('../../resources/image/memo-jumbotron-backgorund.jpg');
		background-size: cover;
		background-repeat: no-repeat;
		text-shadow: 0.1em 0.1em 0.1em dimgray;
		color: white;
}
	
</style>

</head>

<body>

	<div class="container-fluid">

		<header>
			<p><a id="logout" class="btn btn-warning btn-sm float-right" onclick="document.getElementById('logout').submit();">로그아웃</a></p>
			<div id="id" class="jumbotron">
				<div>
					<p><h1 class="text-center">Choi's 게시판</h1></p>
					<p class="text-center">자유롭게 글을 작성해보세요!</p>
				</div>
			</div>
		</header>

		<div id="writeTable">
			<p>
			<h3>글을 작성해보세요</h3>
			</p>

			<p>제목:</p>
			<p><input class="form-control" size="10%" width="100%" id="TITLE"></p>
			<p>내용:</p>
			<p><textarea rows="15" class="form-control" id="CONTENT"></textarea></p>

			<div class="text-center">
				<p>
					<a id="send" class="btn btn-primary btn-md" style="color: white;"
						href="../../modifyPost/${bid}">제출</a> &nbsp;&nbsp;&nbsp; <a id="cancel"
						class="btn btn-primary btn-md" style="color: white;"
						onclick="writeB(false);">취소</a>
				</p>
			</div>
		</div>


	</div>
	<!-- 최상위 container 태그 -->


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