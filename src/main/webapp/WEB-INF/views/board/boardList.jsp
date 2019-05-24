<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>

<head>
<title>게시판</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
<meta name="viewport" content="width=device-width, user-scalable=no">

<link rel="stylesheet" href="./resources/css/bootstrap.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="./resources/js/bootstrap.js"></script>
<script src="./resources/ckeditor/ckeditor.js"></script>

<script type="text/javascript">
	var editor;
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
					var delB = '<a class="btn btn-danger btn-sm"  href="#top" onclick="deletePost('
							+ result[i].BID + ');">삭제</a>';
					var upB = '<a class="btn btn-outline-success btn-sm"  href="./board/modifyPage/' + result[i].BID + '">수정</a>';

					if (col[j] == "TITLE" && j < 4)
						cell.innerHTML = "<a class='viewLink' href='viewPost/" + result[i].BID + "'>"
								+ result[i][col[j]] + "</a>";
					else if (j < 4)
						cell.innerHTML = result[i][col[j]];
					else if (j >= 4){
						cell.className = "etc";
						cell.innerHTML = upB + "&nbsp;" + delB;
					}
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function writePost() {
		var title = document.getElementById("TITLE").value;
		var content = CKEDITOR.instances.editor1.getData();
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		console.log(content);

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
			document.getElementById("writeTable").style.display = 'none';
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
		background-image: url('./resources/image/memo-jumbotron-backgorund.jpg');
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
		padding-right: 10%;
		padding-left: 10%;
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
	background-image: url('./resources/image/memo-jumbotron-backgorund.jpg');
	background-size: cover;
	background-repeat: no-repeat;
	text-shadow: 0.1em 0.1em 0.1em dimgray;
	color: white;
}

table, th, td {
	box-shadow: 0em 0.1em gray;
	padding: 5px;
	padding-right: 0px;
	table-layout: fixed;
	vertical-align: middlle;
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
						<input id="searchContent" class="col-md-3 form-control" type="text" onkeyup="getSearchedPost();"> &nbsp;&nbsp;&nbsp;
						<button id="searchB" class="btn btn-primary btn-md" style="width:60px" onclick="getSearchedPost();" type="button">검색</button>
				</div>
			</div>
		</header>

		<div id="writeTable" style="display: none">
			<p>
			<h3>글을 작성해보세요</h3>
			</p>
			
			<p>제목:</p>
			<p><input class="form-control" size="10%" width="100%" id="TITLE"></p>
			<p>내용:</p>
			<p><textarea  name="editor1" id="editor1" rows="10" cols="80"></textarea></p>
				<script>
					CKEDITOR.replace("editor1",{filebrowserUploadUrl:'<c:url value="/fileUpload.do" />?${_csrf.parameterName}=${_csrf.token}'});		    	
				</script>
			<div class="text-center">
				<p>
					<a id="send" class="btn btn-primary btn-md" style="color: white;" onclick="writePost();">제출</a> &nbsp;&nbsp;&nbsp; 
					<a id="cancel" class="btn btn-primary btn-md" style="color: white;" onclick="writeB(false);">취소</a>
				</p>
			</div>
		</div>

		<div class="row">

			<table id="sidebar" class="col-md-2">
				<thead class="table table-hover">

					<th>카테고리 목록</th>
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
		</div>

		<a id="writeB" class="float-right btn btn-primary" href="#writeTable"
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