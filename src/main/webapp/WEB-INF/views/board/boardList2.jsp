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
    <link rel="stylesheet" href="<c:url value='/resources/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/css/arrow.css'/>">

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <script src="http://malsup.github.io/min/jquery.form.min.js"></script>

    <script type="text/javascript">
       var csrf = {};
       csrf["${_csrf.headerName}"] = "${_csrf.token}";
    </script>
    <script src="<c:url value='/resources/js/bootstrap.min.js'/>"></script>
    <script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script>
    <script src="<c:url value='/resources/js/checkByte.js'/>"></script> <%--바이트 체크 함수--%>
    <script src="<c:url value='/resources/js/boardUI.js'/>"></script> <%--유저 인터페이스 컨트롤 함수--%>
    <script src="<c:url value='/resources/js/boardList2.js'/>"></script> <%-- 기능(Ajax) 함수--%>

</head>
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
                <form class="form-inline my-2 my-lg-0">
                    <input id="searchContent" class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
                    <button id="searchB" class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                </form>
            </div>
        </nav>

        <div class="jumbotron">
           <p><h1>Choi's 게시판</h1></p>
            <p>Developed by 최원상</p>
            <p>PH: 010-9327-2497</p>
            <p>EMAIL: chldnjstkd2@naver.com</p>
        </div>

        <div id="pageN" class="text-center"></div>

        <div class="contentBody"></div>

        <div class="deleteBox">
            <h1 class="text-center" style="margin-top: 100px;">Delete Here!</h1>
        </div>
        <button id="writeB" class="btn btn-dark">글쓰기</button>
        <button id="prev">Prev</button>
        <button id="next">Next</button>
    </div> <%--컨테이너--%>

    <div id="writeTable" >
        <p>제목:</p>
        <p><input class="form-control" id="TITLE" placeholder="30byte 제한(한글 2byte, 영어 1byte)" required autofocus></p>
        <p>내용:</p>
        <textarea name="editor1" placeholder="4000byte 제한(한글 2byte, 영어 1byte)" required autofocus></textarea>

        <script>
            CKEDITOR.replace("editor1",{
                extraPlugins : 'confighelper',
                filebrowserImageUploadUrl:'<c:url value="/imageUpload.do"/>?${_csrf.parameterName}=${_csrf.token}'
            });
            CKEDITOR.addCss('img{max-width: 100%; height: auto !important;}');
        </script>
        <br>
        <input type="hidden" id="returnFileList" value=""/>
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
        <input type="hidden" id="returnHeader" value=""/>
        <form name="headerForm" method="post">
            <div class="input-group">
                <div class="input-group-prepend">
                    <button type="button" class="input-group-text" id="sendHeader">Upload</button>
                </div>
                <div class="custom-file">
                    <input class="custom-file-input" type="file" id="headerList" name="upload" accept="image/png, image/jpg, image/jpeg, image/gif">
                    <label class="custom-file-label" id="showHeader" for="headerList">Choose header image</label>
                </div>
            </div>
        </form>
        <br>
        <div class="text-center">
            <p>
                <a id="send" class="btn btn-primary btn-md" style="color: white">제출</a> &nbsp;&nbsp;&nbsp;
                <a id="cancel" class="btn btn-warning btn-md" style="color: white">취소</a>
            </p>
        </div>
    </div>

<%--                    보이지 않는 기능                     --%>
    <div style="display: none">
        <form action="<c:url value="/logout"/>" method="POST" id="logout">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </div>
</body>
</html>