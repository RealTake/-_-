<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<head>
	<title>게시판</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, user-scalable=no">

	<link rel="icon" href="data:;base64,iVBORw0KGgo=">
	<link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
	<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
	<link rel="stylesheet" href="<c:url value='/resources/css/mainTest.css'/>">

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="http://malsup.github.io/min/jquery.form.min.js"></script>
	<script src="<c:url value='/resources/js/bootstrap.min.js'/>"></script>
	<script src="<c:url value='/resources/ckeditor/ckeditor.js'/>"></script>
    <script src="<c:url value='/resources/js/checkByte.js'/>"></script>

	<script type="text/javascript">
		var pageNum = 1;
		var col = ["BID", "WDATE", "TITLE", "WRITER"];

		function getSearchedPost() {
		    pageNum = 1;
			$.ajax({
				url: '<c:url value="/searchPost.json/1?content="/>' + encodeURIComponent(document.getElementById("searchContent").value),
				type: 'get',
				dataType: 'json',
				success: function (response) {
					searchProcess(response);
				},
				fail: function (error) {
					alert('로드 실패');
				},
			});
		}

		function searchProcess(response) {
			var table = $("#postList")[0];
				var result = response.result;
				var limit;

				if (result.length > 0) {
                    table.innerHTML = "";
					$("#pageN").text(pageNum);
					$("#pageB").css("display", "block");

                    if(result.length <= 10)
                    	$("#next").css("visibility", "hidden");
                    else
						$("#next").css("visibility", "visible");

                    if(pageNum <= 1)
						$("#prev").css("visibility", "hidden");
                    else
						$("#prev").css("visibility", "visible");

                    if(result.length >= 10)
                    	limit = 10 - 1;
                    else
                    	limit = result.length - 1;

					for (var i = limit; i >= 0; i--) {
						var row = table.insertRow(0);
						for (var j = 0; j < 5; j++) {
							var cell = row.insertCell(j);
							var delB = '<button class="btn btn-danger btn-sm" name="delB" bid="' + result[i].BID + '">삭제</button>';
							var upB = '<a class="btn btn-success btn-sm"  href="<c:url value="/modifyPage/"/>' + result[i].BID + '">수정</a>';

							if (col[j] == "TITLE" && j < 4)
								cell.innerHTML = "<a class='viewLink' href='./viewPost/" + result[i].BID + "'>"
										+ result[i][col[j]] + "</a>";
							else if (j < 4)
								cell.innerHTML = result[i][col[j]];
							else if (j >= 4) {
								cell.className = "etc";
								cell.innerHTML = upB + "&nbsp;" + delB;
							}
						}
					}
				}
				else {
                    $("#pageB").css("display", "none");
                    $("#postList")[0].innerHTML = "";
					movePage('prev');
				}
		}

		<%--function searchProcess2(response) {--%>
		<%--	var table = $("#postTable2")[0];--%>
		<%--	var result = response.result;--%>
		<%--	var limit;--%>

		<%--	if (result.length > 0) {--%>
		<%--		table.innerHTML = "";--%>
		<%--		$("#pageN").text(pageNum);--%>
		<%--		$("#pageB").css("display", "block");--%>

		<%--		if(result.length <= 10)--%>
		<%--			$("#next").css("visibility", "hidden");--%>
		<%--		else--%>
		<%--			$("#next").css("visibility", "visible");--%>

		<%--		if(pageNum <= 1)--%>
		<%--			$("#prev").css("visibility", "hidden");--%>
		<%--		else--%>
		<%--			$("#prev").css("visibility", "visible");--%>

		<%--		if(result.length >= 10)--%>
		<%--			limit = 10 - 1;--%>
		<%--		else--%>
		<%--			limit = result.length - 1;--%>

		<%--		for (var i = limit; i >= 0; i--) {--%>
		<%--				var upB = '<a class="btn btn-success btn-sm"  href="<c:url value="/modifyPage/"/>' + result[i].BID + '">수정</a>';--%>
		<%--				var title = "<p>" + result[i].TITLE + "</p>";--%>
		<%--				var bid = result[i].BID;--%>
		<%--				var date = "<p>" + result[i].WDATE + "</p>";--%>
		<%--				var writer = "<p>" + result[i].WRITER + "</p>";--%>
		<%--				var div = $("<div class='contentBox' bid=" + bid + ">" + title + date + writer + "</div>");--%>
		<%--				$("#postTable2").append(div);--%>
		<%--		}--%>
		<%--	}--%>
		<%--	else {--%>
		<%--		$("#pageB").css("display", "none");--%>
		<%--		$("#postTable2")[0].innerHTML = "";--%>
		<%--		movePage('prev');--%>
		<%--	}--%>
		<%--}--%>


		function writePost() {
			var title = $("#TITLE").val();
			var content = CKEDITOR.instances.editor1.getData();
            var fileList = $("#returnFileList").val();
			if(content.getBytes() > 4000){
				alert('제한된 크기에 내용을 작성해주세요');
			}
			else{
				$.ajax({
					url: '<c:url value="/writePost"/>',
					type: 'post',
					contentType: 'application/x-www-form-urlencoded; charset=utf-8',
					headers: {'${_csrf.headerName}' : '${_csrf.token}'},
					data: 'TITLE=' + title + '&' + 'CONTENT=' + content + '&' + 'FILE_LIST=' + fileList,
					dataType: 'text',
					success: function () {
						writeB(false);
						getSearchedPost();
					},
					error: function () {
						alert('등록을 실패하였습니다.');
					},
				});
			}
		}

		function deletePost(bid) {
			$.ajax({
				url: '<c:url value="/deletePost/"/>' + bid,
				type: 'get',
				dataType: 'json',
				success: function () {
					getSearchedPost();
				},
				fail: function () {
					alert('삭제 실패하였습니다.');
				},
			});
		}

		function movePage(mode) {
		    var flag = 0;
                if (mode == 'next' && pageNum >= 1) {
                    pageNum++;
                    flag = 1;
                }
                else if (mode == 'prev' && pageNum > 1) {
                    pageNum--;
                    flag = 1;
                }

            if(flag == 1){
				$.ajax({
					url: '<c:url value="/searchPost.json/"/>' + pageNum + '?' + 'content=' + encodeURIComponent($("#searchContent").val(), true),
					type: 'get',
					dataType: 'json',
					success: function (response) {
						searchProcess(response);
					},
					error: function () {
					},
				});
            }
		}


		//작성글 화면에서 글쓰기, 취소 버튼을 눌렀을때 작성화면을 비운다.
		function writeB(mode) {
			if (mode)
			{
				$('#writeB').css('display', 'none');
				$('#writeTable').css('display', 'block');
			}
			else {
				CKEDITOR.instances.editor1.setData('');
				$('#fileList').val("");
				$('#returnFileList').val("");
				$('#TITLE').val("");
				$('#writeB').css('display', 'block');
				$('#writeTable').css('display', 'none');
				$('#showFiles')[0].innerHTML = "";
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

        //Dom로드후 만들어진 삭제 버튼 요소에대한 클릭 이벤트를 가능하게한다.
		$(document).on("click","button[name=delB]",function() {
			var bid	= $(this).attr("bid");
			deletePost(bid);
		});

		$(document).on("click",".contentBox",function() {
			var bid	= $(this).attr("bid");
			location.href = "./viewPost/" + bid;
		});

		$().ready( function() {
            //파일 업로드시 업로드 파일 이름을 알려줌
            $("#fileList").change(function () {
                showName();
            });

			//페이지 로드후 리스트를 출력하기 위함.
			getSearchedPost();

			//검색공간에 키보드 입력시 즉각 검색한다.
			$("#searchContent").keyup(function () {
				var content = $("#searchContent").val();
				getSearchedPost(content);
			});

			//검색버튼 클릭시 검색한다.
			$("#searchB").click(function () {
				var content = $("#searchContent").val();
				getSearchedPost(content);
			});

			//클릭시 파일을 서버에 업로드한다.
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

			//제목 바이트 확인
			$("#TITLE").keyup( function() {
				checkByte("TITLE");
			});

			//게시글 전송시 작성화면 숨김
			$("#send").click( function() {
				writePost();
			});

			//글 작성 취소시 에디터 초기화 및 숨김
			$("#cancel").click( function() {
				writeB(false);
			});

			//글쓰기 창을 활성화
			$("#writeB").click( function() {
				writeB(true);
			});

			//페이지 이전으로 전환
			$("#prev").click( function() {
				movePage($(this).attr("id"));
			});

			//다음 페이지로 전환
			$("#next").click( function() {
				movePage($(this).attr("id"));
			});

			//로그아웃 버튼
            $("#logoutB").click( function (){
                $("#logout").submit();
            });

		});
	</script>

	<style>
		@media screen and ( max-width: 750px) {
			#sidebar {
				width: 100%;
				margin-left: 10px;
				margin-right: 10px;
			}

			#sidebar a:link { color: black; text-decoration: none;}
			#sidebar a:visited { color: black; text-decoration: none;}

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

			#postTable {
				margin-top: 5px;
			}

			.etc {
				display: none;
			}

			#ajaxTable {
				font-size:0.8em;
			}
		}

		@media screen and ( min-width: 751px) {
			.container-fluid {
				border-radius: 15px 15px;
				background-color: #5e91f8;
				background: white;
				width: 1000px;
			}

			#logoutB {
				color: white;
				margin: 1%;
			}

			#sidebar a:link { color: black; text-decoration: none;}
			#sidebar a:visited { color: black; text-decoration: none;}

			.etc {
				width: 100px;
				padding: 0px;
			}
		}

		#writeB {
			color: white;
			position: fixed;
			right: 10%;
			bottom: 5%;
		}

		#writeTable P {
			color: black;
		}

		.jumbotron {
			margin-top: 10px;
			background-image: url('<c:url value="/resources/image/strawberry-backgroundImage.jpg"/>');
			background-size: cover;
			background-position: center;
			background-repeat: no-repeat;
			text-shadow: 0.1em 0.1em 0.1em dimgray;
			color: white;
		}

		table, th, td {
			box-shadow: 0em 0.1em gray;
			padding: 5px;
			padding-right: 0px;
			table-layout: fixed;
		}

		#searchContent {
			width: 150px;
			margin-left: auto;
		}

		#searchB {
			margin-right: 1%;
		}

		.viewLink:link { color: red; text-decoration: none;}
		.viewLink:visited { color: black; text-decoration: none;}

		#pageB {
			margin-left: auto;
			margin-right: auto;
            display: flex;
		}

        #prev, #next, #pageN {
            margin-left: 3px;
            margin-right: 3px;
        }

		body {
			height: 100%;
			margin-top: 0px;
			padding: 0px;
			/*background-color: #5e91f8;*/
		}

        #showFiles {
            overflow: hidden;
        }

	</style>

</head>

<body>&nbsp;&nbsp;&nbsp;
	<div class="container-fluid">
		<header>
			<p><button id="logoutB" class="btn btn-warning btn-sm float-right">로그아웃</button></p>
			<div id="id" class="jumbotron">
				<div>
					<p><h1 class="text-center">Choi's 게시판</h1></p>
					<p class="text-center">자유롭게 글을 작성해보세요!</p>
				</div>
				<s:authorize access="hasRole('ROLE_ADMIN')"><p><h3>관리자 모드</h3></p></s:authorize>

<%--				<div class="row">--%>
<%--					<input id="searchContent" class="col-md-3 form-control" type="text" onkeyup="getSearchedPost();" placeholder="내용+제목"> &nbsp;&nbsp;&nbsp;--%>
<%--					<button id="searchB" class="btn btn-primary btn-md" style="width:60px" onclick="getSearchedPost();" type="button">검색</button>--%>
<%--				</div>--%>
			</div>
		</header>

		<div id="writeTable" style="display: none">
			<p>
			<h3>글을 작성해보세요</h3>
			</p>

			<p>제목:</p>
			<p><input class="form-control" size="10%" width="100%" id="TITLE" placeholder="30byte 제한(한글 2byte, 영어 1byte)" required autofocus></p>
			<p>내용:</p>
			<p><textarea name="editor1" rows="10" cols="80" placeholder="4000byte 제한(한글 2byte, 영어 1byte)" required></textarea></p>

            <script>
					CKEDITOR.replace("editor1",{
						extraPlugins : 'confighelper',
                        filebrowserImageUploadUrl:'<c:url value="/imageUpload.do"/>?${_csrf.parameterName}=${_csrf.token}'
					});
                    CKEDITOR.addCss('img{max-width: 100%; height: auto !important;}');
            </script>
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
			<div class="text-center">
				<p>
					<a id="send" class="btn btn-primary btn-md" style="color: white;">제출</a> &nbsp;&nbsp;&nbsp;
					<a id="cancel" class="btn btn-primary btn-md" style="color: white;">취소</a>
				</p>
			</div>
		</div>
		<div style="display: flex">
			<input id="searchContent" class="form-control" type="text" style="width: 100%" placeholder="내용+제목"> &nbsp;&nbsp;&nbsp;
			<button id="searchB" class="btn btn-primary btn-md" style="min-width: 60px" type="button">검색</button>
		</div>
		<br>
		<div class="row">

<%--			<table id="sidebar" class="col-md-2">--%>
<%--				<thead class="table table-hover">--%>

<%--					<th class="text-center">카테고리 목록</th>--%>
<%--				</thead>--%>

<%--				<tbody class="text-center">--%>
<%--					<tr>--%>
<%--						<td style="background-color: gray;"><a href="">카테고리1</a></td>--%>
<%--					</tr>--%>
<%--					<tr>--%>
<%--						<td><a href="">카테고리2</a></td>--%>
<%--					</tr>--%>
<%--					<tr>--%>
<%--						<td><a href="">카테고리3</a></td>--%>
<%--					</tr>--%>
<%--				</tbody>--%>

<%--			</table>--%>

			<div id="postTable">

				<table id="ajaxTable" class="table table-hover">

					<thead align="center">
						<tr >
							<td width="10%">번호</td>
							<td width="15%" style="min-width: 72px;">작성날짜</td>
							<td width="30%">제목</td>
							<td width="15%">작성자</td>
							<td class="etc" ></td>
						</tr>
					</thead>

					<tbody align="center" id="postList"></tbody>

				</table>

			</div>

			<div id="pageB" style="display: none;">
				<button class="btn btn-outline-info" id="prev">이전</button>
                <button class="btn btn-outline-info" id="pageN"></button>
				<button class="btn btn-outline-info" id="next">다음</button>
			</div>

		</div>

		<a id="writeB" class="float-right btn btn-primary" href="#writeTable">글쓰기</a>

<%--		<div class="contentBody" id="postTable2"></div>--%>

	</div>
	<!-- 최상위 container 태그 -->

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