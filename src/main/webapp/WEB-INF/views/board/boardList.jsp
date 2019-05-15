<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>

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
			 
			 function writeB(mode) {
				 if(mode)
				 	document.getElementById("writeTable").style.display='block';
				 else
					 document.getElementById("writeTable").style.display='none';
			}
			 
			 var currentPosition = parseInt($("#sidebox").css("top")); 
			 $(window).scroll(function() { 
				 
				 var position = $(window).scrollTop(); 
				 $("#sidebox").stop().animate({"top":position+currentPosition+"px"},1000); 
				 
				 });

			 
			 window.onload = function() {
				 getSearchedPost();
			 }
			</script>
			
			
			<style>
				table, th, td {
				  border: 1px solid black;
				  padding: 5px;
				  style="table-layout:fixed;"
				}

				#writeB{
					color: white;
					position: relative; left: 10%;
				}
				
				#writeTable P{
				color: black;
				}
				
				.jumbotron{
					background-image: url('./resources/image/memo-backgorund.jpg');
					background-size: 100% 100%;
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
				
				#sidebar {
				   position:fixed;	
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
							<p class="text-center"><a class="btn btn-primary btn-md" onclick="document.getElementById('logout').submit();">로그아웃</a></p>
						</div>
	
						<div class="row">
							<input id="searchContent" class="form-control col-md-2" type="text" onkeyup="getSearchedPost();">
							&nbsp;&nbsp;&nbsp;
							<button class="btn btn-primary btn-md" onclick="getSearchedPost();" type="button">검색</button>
						</div>
						
					</div>
				</header>
				
				<form action='<c:url value="/write"/>' method='post' id="writeTable" style="display:none" class="container">
					<p><h3>글을 작성해보세요</h3></p>
					<p>제목:</p>
					<p><input class="form-control" size="10%" width="100%" name="TITLE" >
						<p>내용: <textarea rows="15" class="form-control" name="CONTENT"></textarea></p>
						<div class="text-center">
							<p><input type="submit" id="send" class="btn btn-primary btn-md" style="color: white;" onclick="writeB(false)">&nbsp;&nbsp;&nbsp;
							<a id="cancel" class="btn btn-primary btn-md" style="color: white;" onclick="writeB(false)">취소</a></p>
						</div>
				</form>			
				
					<div class="row">
					
						<div id="sidebar" class="col-lg-2">				
						       <table style="width: 60%;">
						           <thead class="text-center">
						            <td>카테고리 목록</td>
						            </thead>
						            
						           <tbody class="text-center">
						               <tr><td><a href="">카테고리1</a></td></tr>
						               <tr><td><a href="">카테고리2</a></td></tr>
						               <tr><td><a href="">카테고리3</a></td></tr>
						           </tbody>                                   
						       </table>
						</div>
							
							<div  class="col-md-2"></div>	
							
						<div class="col-md-10">
						
							<table id="ajaxTable" class="table table-hover">
								<thead align="center">
									<tr>
										<td width="15%">번호</td>
										<td width="15%">작성날짜</td>
										<td width="50%">제목</td>
										<td width="20%">작성자</td>
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
				</div>
				
				<a id="writeB" class="btn btn-primary" href="#top" onclick="writeB(true);">글쓰기</a>
				
			</div> <!-- 최상위 container 태그 -->

				
			<div style="display:none">
						<c:url value="/logout" var="logout"/>
							<form action="${logout}" method="POST" id="logout">
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
							<button type="submit">로그아웃</button>
						</form>
					</div>
	</body>
</html>