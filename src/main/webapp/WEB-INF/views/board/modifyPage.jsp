<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>

<!DOCTYPE html>
		<head>
			<title>수정 페이지</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<meta name="viewport" content="width=device-width, user-scalable=no">

			<link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
			<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">

			<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
			<script src="http://malsup.github.io/min/jquery.form.min.js"></script>
			<script src="<c:url value='/resources/js/bootstrap.js'/>"></script>
			<script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script>
			<script src="<c:url value='/resources/js/checkByte.js'/>"></script>//바이트 크기를 구해주는 함수
			<script type="text/javascript">
				function modifyPost(bid) {
					var title = $("#TITLE").val();
					var content = CKEDITOR.instances.editor1.getData();
					var fileList = $("#returnFileList").val();
					if(content.getBytes() > 4000){
						alert('제한된 크기에 내용을 작성해주세요');
					}
					else{
						$.ajax({
							url: '<c:url value="/modifyPost/"/>' + bid,
							type: 'post',
							contentType: 'application/x-www-form-urlencoded; charset=utf-8',
							headers: {'${_csrf.headerName}' : '${_csrf.token}'},
							data: 'TITLE=' + title + '&' + 'CONTENT=' + content + '&' + 'FILE_LIST=' + fileList,
							dataType: 'text',
							success: function () {
								location.href = '<c:url value="/viewPost/${dto.BID}"/>'
							},
							error: function () {
								alert('등록을 실패하였습니다.');
							},
						});
					}
				}

				//파일 등록후 등록한 파일의 이름을 보여준다.
				function showName(){
					var files = $('input[name=fileList]')[0].files;
					var filelist = '';

					for(var i =0; i < files.length; i++){
						if((files.length - 1) == i) {
							filelist += files[i].name
						} else {
							filelist += files[i].name + ',&nbsp;&nbsp;&nbsp;&nbsp;'
						}
					}
					console.log(filelist);
					$('.custom-file-label')[0].innerHTML = filelist;
				}

				$().ready( function() {
					//제목 바이트 확인
					$("#TITLE").keyup( function() {
						checkByte("TITLE");
					});

					//게시글 전송
					$("#send").click( function() {
						var bid = $(this).attr("bid");
						modifyPost(bid);
					});

					//글 작성 취소시 에디터 초기화 및 숨김
					$("#cancel").click( function() {
						location.href = '<c:url value="/viewPost/${dto.BID}"/>'
					});

					//파일 업로드시 업로드 파일 이름을 알려줌
					$("#fileList").change(function () {
						showName();
					});

					//로그아웃 버튼
					$("#logoutB").click(function () {
						$("#logout").submit();
					});

					//파일업로드 하기
					$('#sendFile').click(
							function uploadFile(){
								$("form[name=fileForm]").ajaxForm({
									url : "<c:url value='/fileUpload.do?'/>${_csrf.parameterName}=${_csrf.token}",
									enctype : "multipart/form-data",
									dataType : "text",
									error : function(){
										alert("업로드 실패") ;
									},
									success : function(responseText){
										$("#returnFileList").val(responseText);
										alert('업로드 성공');
									}
								});

								$("form[name=fileForm]").submit() ;
							}
					);
				});

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
			}
			</style>

		</head>

		<body>
			<div class="container-fluid">

				<header>
					<p><a id="logoutB" class="btn btn-warning btn-sm float-right">로그아웃</a></p>
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
						<p><input class="form-control" size="10%" width="100%" id="TITLE" value="${dto.TITLE}" placeholder="30byte 제한(한글 2byte, 영어 1byte)" required autofocus></p>

						<p>내용:</p>
						<p><textarea  name="editor1" id="editor1" rows="10" cols="80" placeholder="4000byte 제한(한글 2byte, 영어 1byte)" required>${dto.CONTENT}</textarea></p>

						<script>
							CKEDITOR.replace("editor1",{
								extraPlugins : 'confighelper',
                                filebrowserImageUploadUrl:'<c:url value="/imageUpload.do"/>?${_csrf.parameterName}=${_csrf.token}'
							});
                            CKEDITOR.addCss('img{max-width: 100%; height: auto !important;}');
						</script>
						<br>
						<input type="hidden" id="returnFileList" value="${dto.FILE_LIST}"/>
						<form name="fileForm" method="post" enctype="multipart/form-data">
							<div class="input-group">
								<div class="input-group-prepend">
									<button type="button" class="input-group-text" id="sendFile">Upload</button>
								</div>
								<div class="custom-file">
									<input multiple="multiple" class="custom-file-input" type="file" id="fileList" name="fileList">
									<label class="custom-file-label" id="showFiles" for="fileList">${dto.FILE_LIST}</label>
								</div>
							</div>
						</form>
						<br>
						<div class="text-center">
							<p>
								<a id="send" class="btn btn-primary btn-md" style="color: white;" bid="${dto.BID}">수정</a>
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