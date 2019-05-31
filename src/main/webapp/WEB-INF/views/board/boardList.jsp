<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<head>
	<title>게시판</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, user-scalable=no">

	<!-- default header name is X-CSRF-TOKEN -->
	<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
	<meta id="_csrf" name="_csrf" content="${_csrf.token}" />

	<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="<c:url value='/resources/js/bootstrap.js'/>"></script>
	<script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script>

	<script type="text/javascript">
		String.prototype.getBytes = function() {
			var contents = this;
			var str_character;
			var int_char_count;
			var int_contents_length;

			int_char_count = 0;
			int_contents_length = contents.length;

			for (k = 0; k < int_contents_length; k++) {
				str_character = contents.charAt(k);
				if (escape(str_character).length > 4)
					int_char_count += 2;
				else
					int_char_count++;
			}
			return int_char_count;
		};

		function checkByte(caller) {
			var check = document.getElementById(caller).value;
			if(check.getBytes() > 30){
				alert('제한된 크기에 제목을 작성해주세요');
			}
		}
	</script>

	<script type="text/javascript">
		var pageNum = 1;
		var request = new XMLHttpRequest();
		var col = ["BID", "WDATE", "TITLE", "WRITER"];

		function getSearchedPost() {
			pageNum = 1;
			request.open('GET',
					'<c:url value="/searchPost.json/1?content="/>'
							+ encodeURIComponent(document
									.getElementById("searchContent").value), true);
			request.onreadystatechange = searchProcess;
			request.send(null);
		}

		function searchProcess() {
			var table = document.getElementById("postList");

			if (request.status === 200 && request.readyState === 4) {
				var object = eval('(' + request.responseText + ')');
				var result = object.result;
				if (result.length > 0) {
					table.innerHTML = "";
                    document.getElementById('pageN').innerText = pageNum;

					for (var i = result.length - 1; i >= 0; i--) {
						var row = table.insertRow(0);
						for (var j = 0; j < 5; j++) {
							var cell = row.insertCell(j);
							var delB = '<a class="btn btn-danger btn-sm" style="color: white" onclick="deletePost(' + result[i].BID + ');">삭제</a>';
							var upB = '<a class="btn btn-outline-success btn-sm"  href="<c:url value="/modifyPage/"/>' + result[i].BID + '">수정</a>';

							if (col[j] == "TITLE" && j < 4)
								cell.innerHTML = "<a class='viewLink' href='viewPost/" + result[i].BID + "'>"
										+ result[i][col[j]] + "</a>";
							else if (j < 4)
								cell.innerHTML = result[i][col[j]];
							else if (j >= 4) {
								cell.className = "etc";
								cell.innerHTML = upB + "&nbsp;" + delB;
							}
						}
					}
				}
				else {
					movePage('prev');
				}
			}
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		function writePost() {
			var title = document.getElementById("TITLE").value;
			var content = CKEDITOR.instances.editor1.getData();
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			if(content.getBytes() > 4000){
				alert('제한된 크기에 내용을 작성해주세요');
			}
			else{
				request.open('POST', '<c:url value="/writePost"/> ', true);
				request.setRequestHeader(header, token);
				request.setRequestHeader('Content-type',
						'application/x-www-form-urlencoded; charset=utf-8');
				request.onreadystatechange = writeProcess;
				request.send("TITLE=" + title + "&" + "CONTENT=" + content);
			}
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
			request.open('GET', '<c:url value="/deletePost/"/>' + bid, true);
			request.onreadystatechange = deleteProcess;
			request.send(null);
		}

		function deleteProcess() {
			var result = request.setRequestHeader;

			if (request.status == 200 && request.readyState == 4) {
				if (result)
					getSearchedPost();
				else {
					alert('삭제 실패하였습니다.');
				}
			}
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		function movePage(mode) {
			if(mode == 'next')
				pageNum++;
			else if(mode == 'prev' && pageNum > 1)
				pageNum--;
			request.open('GET',
					'<c:url value="/searchPost.json/"/>' + pageNum + '?' +'content='
					+ encodeURIComponent(document
							.getElementById("searchContent").value), true);
			request.onreadystatechange = searchProcess;
			request.send(null);
		}


		//작성글 화면에서 전송, 취소 버튼을 눌렀을때 작성화면을 비운다.
		function writeB(mode) {
			if (mode)
			{
				document.getElementById("writeB").style.display = 'none';
				document.getElementById("writeTable").style.display = 'block';
			}
			else {
				CKEDITOR.instances.editor1.setData('');
				document.getElementById("editor1").value = "";
				document.getElementById("TITLE").value = "";
				document.getElementById("writeTable").style.display = 'none';
				document.getElementById("writeB").style.display = 'block';
			}
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		window.onload = function() {
			getSearchedPost();
		}
	</script>

	<style>
		@media screen and ( max-width: 750px) {
			#sidebar {
				width: 100%;
				margin-left: 10px;
				margin-right: 10px;
			}

			#sidebar a:link { color: black; text-decoration: none;}
			#sidebar a:visited { color: black; text-decoration: none;}

			.container-fluid {
				padding-right: 0px;
				padding-left: 0px;
				overflow: hidden;
			}
			.jumbotron {
				background-image: url('<c:url value="/resources/image/strawberry-backgroundImage.jpg"/>');
				background-size: cover;
				background-repeat: no-repeat;
				margin-bottom: 0px;
				text-shadow: 0.1em 0.1em 0.1em dimgray;
				color: white;
			}

			#logoutB {
				color: white;
				margin-top: 1%;
				margin-right: 1%;
			}

			#postTable {
				margin-top: 5px;
			}

			.etc {
				display: none;
			}

			#ajaxTable {
				font-size:0.8em;
			}
		}

		@media screen and ( min-width: 751px) {
			.container-fluid {
				border-radius: 15px 15px;
				background-color: #5e91f8;
				background: white;
				width: 1000px;
			}

			#logoutB {
				color: white;
				margin: 1%;
			}

			#sidebar a:link { color: black; text-decoration: none;}
			#sidebar a:visited { color: black; text-decoration: none;}

			.etc {
				width: 150px;
				padding: 0px;
			}
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
			margin-top: 10px;
			background-image: url('<c:url value="/resources/image/strawberry-backgroundImage.jpg"/>');
			background-size: cover;
			background-position: center;
			background-repeat: no-repeat;
			text-shadow: 0.1em 0.1em 0.1em dimgray;
			color: white;
		}

		table, th, td {
			box-shadow: 0em 0.1em gray;
			padding: 5px;
			padding-right: 0px;
			table-layout: fixed;
		}

		#searchContent {
			width: 150px;
			margin-left: auto;
		}

		#searchB {
			margin-right: 1%;
		}

		.viewLink:link { color: red; text-decoration: none;}
		.viewLink:visited { color: black; text-decoration: none;}

		#pageB {
			margin-left: auto;
			margin-right: auto;
		}

		body {
			height: 100%;
			margin-top: 0px;
			padding: 0px;
			/*background-color: #5e91f8;*/
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
				<s:authorize access="hasRole('ROLE_ADMIN')"><p><h3>관리자 모드</h3></p></s:authorize>

				<div class="row">
						<input id="searchContent" class="col-md-3 form-control" type="text" onkeyup="getSearchedPost();" placeholder="내용+제목"> &nbsp;&nbsp;&nbsp;
						<button id="searchB" class="btn btn-primary btn-md" style="width:60px" onclick="getSearchedPost();" type="button">검색</button>
				</div>
			</div>
		</header>

		<div id="writeTable" style="display: none">
			<p>
			<h3>글을 작성해보세요</h3>
			</p>

			<p>제목:</p>
			<p><input class="form-control" size="10%" width="100%" id="TITLE" onkeyup="checkByte('TITLE');" placeholder="30byte 제한(한글 2byte, 영어 1byte)" required autofocus></p>
			<p>내용:</p>
			<p><textarea name="editor1" id="editor1" rows="10" cols="80" onkeyup="checkEditorByte();" placeholder="4000byte 제한(한글 2byte, 영어 1byte)" required></textarea></p>
				<script>
					CKEDITOR.replace("editor1",{
						extraPlugins : 'confighelper',
						filebrowserUploadUrl:'<c:url value="/fileUpload.do" />?${_csrf.parameterName}=${_csrf.token}'
					});
				</script>
			<div class="text-center">
				<p>
					<a id="send" class="btn btn-primary btn-md" style="color: white;" onclick="writePost();">제출</a> &nbsp;&nbsp;&nbsp;
					<a id="cancel" class="btn btn-primary btn-md" style="color: white;" onclick="writeB(false);">취소</a>
				</p>
			</div>
		</div>

		<div class="row">

<%--			<table id="sidebar" class="col-md-2">--%>
<%--				<thead class="table table-hover">--%>

<%--					<th class="text-center">카테고리 목록</th>--%>
<%--				</thead>--%>

<%--				<tbody class="text-center">--%>
<%--					<tr>--%>
<%--						<td style="background-color: gray;"><a href="">카테고리1</a></td>--%>
<%--					</tr>--%>
<%--					<tr>--%>
<%--						<td><a href="">카테고리2</a></td>--%>
<%--					</tr>--%>
<%--					<tr>--%>
<%--						<td><a href="">카테고리3</a></td>--%>
<%--					</tr>--%>
<%--				</tbody>--%>

<%--			</table>--%>

			<div id="postTable">

				<table id="ajaxTable" class="table table-hover">

					<thead align="center">
						<tr >
							<td width="10%">번호</td>
							<td width="15%" style="min-width: 72px;">작성날짜</td>
							<td width="30%">제목</td>
							<td width="15%">작성자</td>
							<td class="etc" ></td>
						</tr>
					</thead>

					<tbody align="center" id="postList"></tbody>

				</table>

			</div>

			<div id="pageB">
				<button class="btn btn-outline-info" onclick="movePage('prev')">이전</button>
                <button class="btn btn-outline-info" id="pageN"></button>
				<button class="btn btn-outline-info" onclick="movePage('next')">다음</button>
			</div>

		</div>

		<a id="writeB" class="float-right btn btn-primary" href="#writeTable" onclick="writeB(true);">글쓰기</a>

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