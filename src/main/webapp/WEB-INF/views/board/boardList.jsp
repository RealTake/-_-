<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>

<head>
<title>게시판</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}" />

<link rel="stylesheet" href="./resources/css/bootstrap.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="./resources/js/bootstrap.js"></script>

<script type="text/javascript">
	var request = new XMLHttpRequest();
	var col = new Array("BID", "WDATE", "TITLE", "WRITER");

	function getSearchedPost() {
		request.open('GET',
				'./searchPost.json?content='
						+ encodeURIComponent(document
								.getElementById("searchContent").value), true);
		request.onreadystatechange = searchProcess;
		request.send(null);
	}

	function searchProcess() {
		var table = document.getElementById("postList");
		table.innerHTML = "";

		if (request.status == 200 && request.readyState == 4) {
			var object = eval('(' + request.responseText + ')');
			var result = object.result;

			for (var i = 0; i < result.length; i++) {
				var row = table.insertRow(0);
				for (var j = 0; j < 5; j++) {
					var cell = row.insertCell(j);
					var delB = '<a class="btn btn-danger btn-sm" " href="#top" onclick="deletePost('
							+ result[i].BID + ');">삭제</a>';
					var upB = '<a class="btn btn-outline-success btn-sm" " href="#top" onclick="deletePost('
							+ result[i].BID + ');">수정</a>';

					if (col[j] == "TITLE" && j < 4)
						cell.innerHTML = "<a href='viewPost/" + result[i].BID + "'>"
								+ result[i][col[j]] + "</a>";
					else if (j < 4)
						cell.innerHTML = result[i][col[j]];
					else if (j >= 4)
						cell.innerHTML = upB + "&nbsp;" + delB;
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function writePost() {
		var title = document.getElementById("TITLE").value;
		var content = document.getElementById("CONTENT").value;
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		request.open('POST', './writePost', true);
		request.setRequestHeader(header, token);
		request.setRequestHeader('Content-type',
				'application/x-www-form-urlencoded; charset=utf-8');
		request.onreadystatechange = writeProcess;
		request.send("TITLE=" + title + "&" + "CONTENT=" + content);
	}

	function writeProcess() {
		var result = request.responseText;

		if (request.status == 200 && request.readyState == 4) {
			if (result) {
				writeB(false);
				getSearchedPost();
			} else {
				alert('등록을 실패하였습니다.');
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	function deletePost(bid) {
		request.open('GET', './deletePost/' + bid, true);
		request.onreadystatechange = deleteProcess;
		request.send(null);
	}

	function deleteProcess() {
		var result = request.setRequestHeader

		if (request.status == 200 && request.readyState == 4) {
			if (result)
				getSearchedPost();
			else {
				alert('삭제 실패하였습니다.');
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////			  

	//작성글 화면에서 전송, 취소 버튼을 눌렀을때 작성화면을 비운다. 
	function writeB(mode) {
		if (mode)
			document.getElementById("writeTable").style.display = 'block';
		else {
			document.getElementById("TITLE").value = "";
			document.getElementById("CONTENT").value = "";
			document.getElementById("writeTable").style.display = 'none';
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	window.onload = function() {
		getSearchedPost();
	}
</script>


<style>

@media ( max-width : 1070px) {
	#sidebar {
		position: static;
		width: 100%;
	}
}

@media ( min-width : 1070px) {
	#postTable {
		margin-left: auto;
	}
}

table, th, td {
	box-shadow: 0em 0.1em gray;
	padding: 5px;
	table-layout: fixed;
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
	background-image: url('./resources/image/memo-jumbotron-backgorund.jpg');
	background-size: cover;
	background-repeat: no-repeat;
	text-shadow: 0.1em 0.1em 0.1em dimgray;
	color: white;
}

.container-fluid {
	padding-right: 20%;
	padding-left: 20%;
	margin-right: auto;
	margin-left: auto;
}

#postTable {
	margin-left: auto;
}
</style>
</head>

<body>

	<div class="container-fluid">
		<header>
			<div id="id" class="jumbotron">
				<div>
					<h1 class="text-center">Choi's 게시판</h1>
					<p class="text-center">자유롭게 글을 작성해보세요!</p>
					<p class="text-center">
						<a class="btn btn-warning btn-md"
							onclick="document.getElementById('logout').submit();">로그아웃</a>
					</p>
				</div>

				<div class="row">
					<input id="searchContent" class="form-control col-md-2" type="text"
						onkeyup="getSearchedPost();"> &nbsp;&nbsp;&nbsp;
					<button class="btn btn-primary btn-md" onclick="getSearchedPost();"
						type="button">검색</button>
				</div>

			</div>
		</header>

		<div id="writeTable" style="display: none" class="container">
			<p>
			<h3>글을 작성해보세요</h3>
			</p>

			<p>제목:</p>
			<p>
				<input class="form-control" size="10%" width="100%" id="TITLE">
			<p>
				내용:
				<textarea rows="15" class="form-control" id="CONTENT"></textarea>
			</p>

			<div class="text-center">
				<p>
					<a id="send" class="btn btn-primary btn-md" style="color: white;"
						onclick="writePost();">제출</a> &nbsp;&nbsp;&nbsp; <a id="cancel"
						class="btn btn-primary btn-md" style="color: white;"
						onclick="writeB(false);">취소</a>
				</p>
			</div>
		</div>

		<div class="row">

			<table id="sidebar" class="col-md-2">

				<thead class="text-center">
					<td>카테고리 목록</td>
				</thead>

				<tbody class="text-center">
					<tr>
						<td><a href="">카테고리1</a></td>
					</tr>
					<tr>
						<td><a href="">카테고리2</a></td>
					</tr>
					<tr>
						<td><a href="">카테고리3</a></td>
					</tr>
				</tbody>

			</table>

			<div id="postTable" class="col-md-10">

				<table id="ajaxTable" class="table table-hover">

					<thead align="center">
						<tr>
							<td width="10%">번호</td>
							<td width="15%">작성날짜</td>
							<td width="35%">제목</td>
							<td width="15%">작성자</td>
							<td width="13%"></td>
						</tr>
					</thead>

					<tbody align="center" id="postList"></tbody>

				</table>

			</div>
		</div>

		<a id="writeB" class="float-right btn btn-primary" href="#top"
			onclick="writeB(true);">글쓰기</a>

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