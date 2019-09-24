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
