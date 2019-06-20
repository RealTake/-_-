<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>

<!DOCTYPE html>
		<head>
			<title>수정 페이지</title>
			<link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<meta name="viewport" content="width=device-width, user-scalable=no">

			<!-- default header name is X-CSRF-TOKEN -->
			<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
			<meta id="_csrf" name="_csrf" content="${_csrf.token}" />

			<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
			<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
			<script src="http://malsup.github.io/min/jquery.form.min.js"></script>
			<script src="<c:url value='/resources/js/bootstrap.js'/>"></script>
			<script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script>
			<script type="text/javascript"> //바이트 크기를 구해주는 함수
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
				}

				function checkByte(caller) {
					var check = document.getElementById(caller).value;
					if(check.getBytes() > 30){
						alert('제한된 크기에 제목을 작성해주세요');
					}
				}
			</script>
			<script type="text/javascript">
				var request = new XMLHttpRequest();

				function modifyPost(bid) {
					var title = document.getElementById("TITLE").value;
					var content = CKEDITOR.instances.editor1.getData();
					var token = $("meta[name='_csrf']").attr("content");
					var header = $("meta[name='_csrf_header']").attr("content");
					var fileList = $("#returnFileList").val();

					if(content.getBytes() > 4000){
						alert('제한된 크기에 내용을 작성해주세요');
					}
					else{
						request.open('POST', '<c:url value="/modifyPost/"/>' + bid, true);
						request.setRequestHeader(header, token);
						request.setRequestHeader('Content-type',
								'application/x-www-form-urlencoded; charset=utf-8');
						request.onreadystatechange = modifyProcess;
						request.send("TITLE=" + title + "&" + "CONTENT=" + content + "&" + "FILE_LIST=" + fileList);
					}
				}

				function modifyProcess() {
					var result = request.responseText;
					if (request.status == 200 && request.readyState == 4) {
						if (result == 1)
							location.href = '<c:url value="/viewPost/${dto.BID}"/>'
					}
				}

				$().ready( function() {
					$('#sendFile').click(
							function uploadFile(){
								$("form[name=fileForm]").ajaxForm({
									url : "<c:url value='/fileUpload.do?'/>${_csrf.parameterName}=${_csrf.token}",
									enctype : "multipart/form-data",
									dataType : "text",
									error : function(){
										alert("에러") ;
									},
									success : function(responseText){
										$("#returnFileList").val(responseText);
										alert( $("#returnFileList").val());
									}
								});

								$("form[name=fileForm]").submit() ;
							}
					);
				});

				function showName(){
					var files = document.getElementsByName('fileList')[0].files;
					var filelist = '';


					for(var i =0; i < files.length; i++){
						if((files.length - 1) == i) {
							filelist += files[i].name
						} else {
							filelist += files[i].name + ',&nbsp;&nbsp;&nbsp;&nbsp;'
						}
					}

					console.log(filelist);

					document.getElementsByClassName('custom-file-label')[0].innerHTML = filelist
				}
			</script>

			<style>
			@media ( max-width : 1070px) {
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
			}

			@media ( min-width : 1070px) {
				.container-fluid {
					width: 1000px;
				}

				.jumbotron {
					background-image: url('<c:url value="/resources/image/memo-jumbotron-backgorund.jpg"/>');
					background-size: cover;
					background-repeat: no-repeat;
					text-shadow: 0.1em 0.1em 0.1em dimgray;
					color: white;
				}

				#logoutB {
					color: white;
					margin: 1%;
				}

				img {
					max-width: 100%;
					height: auto !important;
				}
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
					</div>
				</header>
					<div id="writeTable">
						<p><h3>수정하기</h3></p>

						<p>제목:</p>
						<p><input class="form-control" size="10%" width="100%" id="TITLE" value="${dto.TITLE}" onkeyup="checkByte('TITLE');" placeholder="30byte 제한(한글 2byte, 영어 1byte)" required autofocus></p>

						<p>내용:</p>
						<p><textarea  name="editor1" id="editor1" rows="10" cols="80" placeholder="4000byte 제한(한글 2byte, 영어 1byte)" required>${dto.CONTENT}</textarea></p>

						<script>
							CKEDITOR.replace("editor1",{
								extraPlugins : 'confighelper',
								filebrowserUploadUrl:'<c:url value="/imageUpload.do"/>?${_csrf.parameterName}=${_csrf.token}'
							});
						</script>
						<br>
						<input type="hidden" id="returnFileList" value="${dto.FILE_LIST}"/>
						<form name="fileForm" method="post" enctype="multipart/form-data">
							<div class="input-group">
								<div class="input-group-prepend">
									<button type="button" class="input-group-text" id="sendFile">Upload</button>
								</div>
								<div class="custom-file">
									<input multiple="multiple" class="custom-file-input" type="file" id="fileList" name="fileList" onchange="showName();">
									<label class="custom-file-label" id="showFiles" for="fileList">${dto.FILE_LIST}</label>
								</div>
							</div>
						</form>
						<br>
						<div class="text-center">
							<p>
								<a id="send" class="btn btn-primary btn-md" style="color: white;" onclick="modifyPost('${dto.BID}');">수정</a>
								&nbsp;&nbsp;&nbsp;
								<a id="cancel" class="btn btn-primary btn-md" style="color: white;" href="<c:url value="/viewPost/"/>${dto.BID}">취소</a>
							</p>
						</div>
					</div>
			</div><!-- 최상위 container 태그 -->

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