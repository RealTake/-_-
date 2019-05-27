<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>

<!DOCTYPE html>
		<head>
			<title>수정 페이지</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<meta name="viewport" content="width=device-width, user-scalable=no">

			<!-- default header name is X-CSRF-TOKEN -->
			<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
			<meta id="_csrf" name="_csrf" content="${_csrf.token}" />

			<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
			<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
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

			@media ( max-width : 1070px) {

			}

			@media ( min-width : 1070px) {
				#postTable {
					margin-left: auto;
				}

				.container-fluid {
					width: 1000px;
				}

				#tools {
					padding-left: 80%;
					margin-top: auto;
				}


			}


			.jumbotron {
				background-image: url('<C:url value="/resources/image/memo-jumbotron-backgorund.jpg"/>');
				background-size: cover;
				background-repeat: no-repeat;
				text-shadow: 0.1em 0.1em 0.1em dimgray;
				color: white;
			}

			#logout {
				color: white;
				margin: 1%;
			}

			#viewBody {
				 min-height: 50%;
				 padding: 4px;
				 padding-left: 30px;
				 padding-right: 30px;
				 border: 1px solid #CED4DA;
				 border-radius: 15px 15px;
			}

			#subTitle {
				 color: gray;
				 border-bottom: 1px solid #CED4DA;
				 margin-left: 1%;
				 margin-right: 1%;
				 padding-bottom: 3%;
			}

			#contentBody {
				min-height: 40%;
				border-color: white;
				width: 100%;
				word-break:break-all;
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
						<p><input class="form-control" size="10%" width="100%" id="TITLE" onkeyup="checkByte('TITLE');" placeholder="30byte 제한(한글 2byte, 영어 1byte)" required autofocus></p>

						<p>내용:</p>
						<p><textarea  name="editor1" id="editor1" rows="10" cols="80" onkeyup="checkEditorByte();" placeholder="4000byte 제한(한글 2byte, 영어 1byte)" required></textarea></p>

						<script>
							CKEDITOR.replace("editor1",{
								extraPlugins : 'confighelper',
								filebrowserUploadUrl:'<c:url value="/fileUpload.do" />?${_csrf.parameterName}=${_csrf.token}'
							});
						</script>

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