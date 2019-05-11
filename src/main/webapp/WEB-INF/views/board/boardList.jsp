<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
	<html>
		<head>
			<meta charset="UTF-8">
			<meat name="viewport" content="width-device-width, initial-scale=1">
			
			<link rel="stylesheet" href="./resources/bootstrap.css">
			<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
			<script src="./resources/bootstrap.js"></script>
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
				 
				 if(true){
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


 


			<title>게시판</title>
			<style>
			
			table, th, td {
			  border: 1px solid black;
			  padding: 5px;
			}
			
			table {
			  width: 100%
			}
			
			</style>
		</head>
		
		<body>
		
		<div>
			<s:authorize access="isAuthenticated()">
			
				<h2>환영합니다 ${name}님</h2>
				<c:url value="/logout" var="logout"/>
			    <form action="${logout}" method="POST">
			        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			        <button type="submit">로그아웃</button>
			    </form>
    
			</s:authorize>
			
		</div>
		<input id="searchContent" type="text" onkeyup="getSearchedPost();">
		<button onclick="getSearchedPost();" type="button">검색</button>
			<table id="ajaxTable">
			
				<thead align="center" >
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
		
	</body>
</html>