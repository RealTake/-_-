<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>
<title>게시판</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}" />
<meta name="viewport" content="width=device-width, user-scalable=no">

<link rel="stylesheet" href="../resources/css/bootstrap.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="../resources/js/bootstrap.js"></script>

<script>
function deletePost() {
	location.href = '../deletePost/' + ${dto.BID}
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
		padding-right: 10%;
		padding-left: 10%;
		margin-right: auto;
		margin-left: auto;
    }
	
	#tools {
		padding-left: 80%;
	}
	
	
}


.jumbotron {
	background-image: url('../resources/image/memo-jumbotron-backgorund.jpg');
	background-size: cover;
	background-repeat: no-repeat;
	text-shadow: 0.1em 0.1em 0.1em dimgray;
	color: white;
}

#logout {
	color: white;
	margin: 1%;
}

#viewBody {
	 min-height: 50%;
	 padding: 4px;
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
	resize: none;
	border-color: white;
	width: 100%;
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
		
		<div id="viewBody">
			<h1 class="text-center">${dto.TITLE}</h1>
			<p id="subTitle" class="text-center">작성자: ${dto.WRITER} 작성일: ${dto.WDATE}</p>
			<textarea id="contentBody" readonly>${dto.CONTENT}</textarea>
		</div>
		
		<br>
		
		<div id="tools">
			<a class="btn btn-danger btn-sm" style="color: white" onclick="deletePost();">삭제</a>
			<a class="btn btn-outline-success btn-sm" onclick="updatePost();">수정</a>
			<a class="btn btn-primary active btn-sm" href="../board">목록</a>
		</div>
		
	</div><!-- 최상위 container 태그 -->

</body>
</html>