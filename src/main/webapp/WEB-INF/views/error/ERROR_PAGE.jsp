<%--
  Created by IntelliJ IDEA.
  User: RealTake
  Date: 2019-07-11
  Time: 오후 6:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<html>
<head>
    <title>${requestScope['javax.servlet.error.status_code']}오류</title>
    <link rel="stylesheet" href="<c:url value="/resources/css/errorPage.css"/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
</head>
    <body>
        <div class="container-fluid">
            <div class="jumbotron">
                <p><h1 id="errorCode">${requestScope['javax.servlet.error.status_code']}오류</h1></p>
                <div>
                    <p>Developed by 최원상</p>
                    <p>PH: 010-9327-2497</p>
                    <p>EMAIL: chldnjstkd2@naver.com</p>
                </div>
            </div>
            <div id="errorBody">
                <p>에러 타입: ${requestScope['javax.servlet.error.exception_type']}</p>
                <p>에러 메세지: ${requestScope['javax.servlet.error.message']}</p>
                <s:authorize access="hasRole('ROLE_ADMIN')">
                    <p>에러 타입: ${requestScope['javax.servlet.error.exception_type']}</p>
                    <p>에러 메세지: ${requestScope['javax.servlet.error.message']}</p>
                </s:authorize>
            </div>
        </div>
    </body>
</html>
