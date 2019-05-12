<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
	<html>
		<head>
			<title>게시판</title>
			<meta charset="UTF-8">
			<meat name="viewport" content="width-device-width, initial-scale=1">
			<link rel="stylesheet" href="./resources/css/bootstrap.css">
			<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
			<script src="./resources/js/bootstrap.js"></script>
			
			<script type="text/javascript">
			 var request = new XMLHttpRequest();
			 var col = new Array("BID", "WDATE", "TITLE", "WRITER");
			 function getSearchedPost() {
				 request.open('GET', './searchPost.json?content=' + encodeURIComponent(document.getElementById("searchContent").value),true);
				 request.onreadystatechange = searchProcess;
				 request.send(null);
			 }
			 	
			 function searchProcess() {
				 var table = document.getElementById("postList");
				 table.innerHTML="";
				 
				 if(request.status == 200 && request.readyState == 4){
					 var object = eval('(' + request.responseText + ')');
					 var result = object.result;
					 for(var i = 0; i < result.length; i++){
						 var row = table.insertRow(0);
						 for(var j = 0; j < 4; j++){
							 var cell = row.insertCell(j);
							 if(col[j] == "TITLE")
							 	cell.innerHTML = "<a href='viewPost/" + result[i].BID + "'>" + result[i][col[j]] + "</a>";
							 else
							 	cell.innerHTML =  result[i][col[j]];
						 } 
					 }
				 }
			 }
			 
			 window.onload = function() {
				 getSearchedPost();
			 }
			</script>
			
			<style>
				table, th, td {
				  border: 1px solid black;
				  padding: 5px;
				}

				#writeB{
					color: white;
				}
				
				table {
				  width: 100%
				}
				
				.jumbotron{
					background-image: url('./resources/image/memo-backgorund.jpg');
					background-size: 100% 100%;
					background-repeat: no-repeat;
					text-shadow: 0.1em 0.1em 0.1em dimgray;
					color: white;
				}
				
			</style>
		</head>
		
		<body>
			<header>
				<div class="container">
					<div class="jumbotron">
							<div>
								<h1 class="text-center">Choi's 게시판</h1>
								<p class="text-center">자유롭게 글을 작성해보세요!</p>
								<p class="text-center"><a class="btn btn-primary btn-lg" onclick="document.getElementById('logout').submit();">로그아웃</a></p>
							</div>

							<div>
								<input id="searchContent" type="text" onkeyup="getSearchedPost();">
								<button class="btn btn-primary btn-lg" onclick="getSearchedPost();" type="button">검색</button>
							</div>
					</div>
				</div>
			</header>
			
			<div style="display:none">
						<c:url value="/logout" var="logout"/>
						<form action="${logout}" method="POST" id="logout">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<button type="submit">로그아웃</button>
					</form>
			</div>
			
			
			<div class="container" id="ajaxTable">
				<table id="ajaxTable" class="table table-hover">
				
					<thead align="center">
						<tr>
							<td>번호</td>
							<td>작성날짜</td>
							<td>제목</td>
							<td>작성자</td>
						</tr>
					</thead>
					
					
					<tbody align="center" id="postList">
						<tr>
							<td>${dto.BID}</td>
							<td>${dto.WDATE}</td>
							<td><a href="<c:url value="/viewContent?BID=${dto.BID}"/>">${dto.TITLE}</a></td>
							<td>${dto.WRITER}</td>
						</tr>
					</tbody>
					
				</table>
			</div>
			<a id="writeB" class="btn btn-primary btn-lg">글쓰기</a>
	</body>
</html>