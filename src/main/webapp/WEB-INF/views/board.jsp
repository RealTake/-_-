<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
	<html>
		<head>
			<meta charset="UTF-8">
			<title>Insert title here</title>
			
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
		
			<table id="ajaxTable" style="width:100% bo">
			
				<thead align="center" >
					<td>번호</td>
					<td>작성날짜</td>
					<td>제목</td>
					<td>작성자</td>
				</thead>
				
				<c:forEach var="dto" items="${list}">
				<tbody align="center">
					<td>${dto.BID}</td>
					<td>${dto.WDATE}</td>
					<td><a href="<c:url value="/viewContent?BID=${dto.BID}"/>">${dto.TITLE}</a></td>
					<td>${dto.WRITER}</td>
				</tbody>
				</c:forEach>
				
			</table>
		
	</body>
</html>