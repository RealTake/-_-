<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
    <title>게시판</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=no">

    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/postView.css'/>">
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">


    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <script src="http://malsup.github.io/min/jquery.form.min.js"></script>
    <script type="text/javascript">
        var csrf = {};
        csrf["${_csrf.headerName}"] = "${_csrf.token}";
        var bid = "${dto.BID}";
        var ctx = "${pageContext.request.contextPath}";

        $().ready( function () {
                CKEDITOR.replace("editor1",{
                    extraPlugins : 'confighelper',
                    filebrowserImageUploadUrl:'<c:url value="/imageUpload.do"/>?${_csrf.parameterName}=${_csrf.token}'
                });
                CKEDITOR.addCss('img{max-width: 100%; height: auto !important;}');
            }
        );
    </script>
    <script src="<c:url value='/resources/js/bootstrap.min.js'/>"></script>
    <script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script>
    <script src="<c:url value='/resources/js/checkByte.js'/>"></script> <%--바이트 체크 함수--%>
    <script src="<c:url value='/resources/js/postView.js'/>"></script>
</head>
<c:if test="${!possibility}">
    <script>
        location.href="<c:url value='/board2'/>";
    </script>
</c:if>
<body>
<div class="container-fluid">

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="<c:url value='/board2'/>">Home</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        My Account
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="#">Id : ${AccountInfo.ID}</a>
                        <a class="dropdown-item" href="#">Name : ${AccountInfo.NAME}</a>
                        <a class="dropdown-item" href="#">Email : ${AccountInfo.EMAIL}</a>
                        <div class="dropdown-divider"></div>
                        <button class="dropdown-item" id="logoutB">Logout</button>
                        <button class="dropdown-item" id="dropB">Withdrawal(회원 탈퇴)</button>
                    </div>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/board'/>">Old Page</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link disabled" href="#">Disabled</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="jumbotron text-center">
        <p><h1>${dto.TITLE}</h1></p>
        <p>Writer: ${dto.WRITER}</p>
        <p>Date : ${dto.WDATE}</p>
    </div>
    <div id="postContainer">
        <div class="upDan">
            <div class="l">┏</div>
            <div class="r">┓</div>
        </div>
        <div id="postBody">${dto.CONTENT}</div>
        <div class="downDan">
            <div class="l">┗</div>
            <div class="r">┛</div>
        </div>
    </div>
    <br>
    <c:if test="${!empty dto.FILE_ARRAY}">
        <div id="fileBody">
            <c:forEach var="file" items="${dto.FILE_ARRAY}" varStatus="status">
                <p><i class="fa fa-download"></i><a href="<c:url value="/fileDownload/${file}"/>"> ${file}</a></p>
            </c:forEach>
        </div>
    </c:if>

    <div id="tools" class="float-right">
        <button class="btn btn-danger btn-sm" style="color: white" name="delB">삭제</button>
        <a class="btn btn-success btn-sm" id="modifyB">수정</a>
        <a class="btn btn-primary btn-sm" href='<c:url value="/board2" />'>목록</a>
    </div>

</div> <%--컨테이너--%>
<%--                    보이지 않는 기능                     --%>

<div id="writeTable">
    <div class="top">
        <p>제목:</p>
        <p><input class="form-control" id="TITLE" placeholder="30byte 제한(한글 2byte, 영어 1byte)" required autofocus></p>
        <p>내용:</p>
        <textarea name="editor1" placeholder="4000byte 제한(한글 2byte, 영어 1byte)" required autofocus></textarea>
    </div>
    <br>
    <div class="uploads">
        <form name="fileForm" method="post" enctype="multipart/form-data">
            <div class="input-group">
                <div class="input-group-prepend">
                    <button type="button" class="input-group-text" id="sendFile">Upload</button>
                </div>
                <div class="custom-file">
                    <input multiple="multiple" class="custom-file-input" type="file" id="fileList" name="fileList">
                    <label class="custom-file-label" id="showFiles" for="fileList">Choose file</label>
                </div>
            </div>
        </form>
        <br>
        <form name="headerForm" method="post">
            <div class="input-group">
                <div class="input-group-prepend">
                    <button type="button" class="input-group-text" id="sendHeader">Upload</button>
                </div>
                <div class="custom-file">
                    <input class="custom-file-input" type="file" id="headerList" name="upload" accept="image/*">
                    <label class="custom-file-label" id="showHeader" for="headerList">Choose header image</label>
                </div>
            </div>
        </form>
    </div>
    <br>
    <div class="text-center">
        <p>
            <a id="send" class="btn btn-primary btn-md" style="color: white">제출</a> &nbsp;&nbsp;&nbsp;
            <a id="cancel" class="btn btn-warning btn-md" style="color: white">취소</a>
        </p>
    </div>
</div>

    <form action="<c:url value="/logout"/>" method="POST" id="logout" style="display: none">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
</body>
</html>