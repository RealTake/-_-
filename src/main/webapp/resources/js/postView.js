var header = "";
var files = "";

function modifyPost(bid) {
    var title = $("#TITLE").val();
    var content = CKEDITOR.instances.editor1.getData();
    if(content.getBytes() > 4000){
        alert('제한된 크기에 내용을 작성해주세요');
    }
    else{
        $.ajax({
            url: '../modifyPost/' + bid,
            type: 'post',
            contentType: 'application/x-www-form-urlencoded; charset=utf-8',
            headers: csrf,
            data: 'TITLE=' + title + '&' + 'CONTENT=' + content + '&' + 'FILE_LIST=' + files + '&' + 'HEADER_IMG=' + header,
            dataType: 'text',
            success: function () {
                location.reload(true);
            },
            error: function () {
                alert('등록을 실패하였습니다.');
            },
        });
    }
}

function upload_HeaderImg(){
    $("form[name=headerForm]").ajaxForm({
        url : "../imageUpload.do",
        headers : csrf,
        dataType : "json",
        error : function(){
            alert("업로드 실패");
        },
        success : function(responseText){
            if(responseText.result == null){
                header = responseText.fileName;
                alert("업로드 성공");
            }
           else
               alert(responseText.result);
        }
    });
    $("form[name=headerForm]").submit();
}

function uploadFile(){
    $("form[name=fileForm]").ajaxForm({
        url : "../fileUpload.do",
        headers : csrf,
        enctype : "multipart/form-data",
        dataType : "json",
        error : function(){
            alert("업로드 실패") ;
        },
        success : function(responseText){
            if(responseText.result == null){
                files = responseText.fileName;
                alert('업로드 성공');
            }
            else
                alert(responseText.result);
        }
    });
    $("form[name=fileForm]").submit();
}


function deletePost(bid) {
    $.ajax({
        url: '../deletePost/' + bid,
        type: 'get',
        dataType: 'json',
        success: function () {
            location.href = "../board2"
        },
        fail: function () {
            alert('삭제 실패하였습니다.');
        },
    });
}

function withdrawal() {
    $.ajax({
        url : "../withdrawal",
        type : "post",
        headers: csrf,
        success : function (response) {
            if(response == 1)
                $("#logout").submit();
        },
        error : function () {
            alert("탈퇴 오류");
        }
    });
}

function getPost(bid) {
    $.ajax({
        url : "../Post/" + bid,
        type : "get",
        dataType : "json",
        success : function (response) {
            $("#TITLE").val(response.TITLE);
            CKEDITOR.instances.editor1.setData(response.CONTENT);
            if(response.FILE_LIST != null || response.FILE_LIST != undefined){
                $("#showFiles")[0].innerHTML = response.FILE_LIST.substring(1 ,response.FILE_LIST.length - 1);
                files = response.FILE_LIST;
            }
            else
                $("#showFiles")[0].innerHTML = "Choose files";
            if(response.HEADER_IMG != null) {
                $("#showHeader")[0].innerHTML = response.HEADER_IMG;
                header = response.HEADER_IMG;
            }
            else
                $("#showHeader")[0].innerHTML = "Choose header image";

        },
        error : function () {
            alert("세션 오류");
        }
    });
}

$().ready( function() {

    //getPost(bid);

    //게시글 삭제
    $("button[name=delB]").click(function () {
        deletePost(bid);
    });

    //로그아웃 버튼
    $("#logoutB").click(function () {
        $("#logout").submit();
    });

    //회원 탈퇴
    $("#dropB").click( function (){
        withdrawal();
    });

    //수정 버튼 클릭시
    $("#modifyB").click( function (){
        getPost(bid);
        $(".container-fluid").css("filter", "blur(5px)");// 배경 블러처리
        $("#writeTable").css("display", "block");// 에디터 활성화
    });

    //게시글 전송시 작성화면 숨김
    $("#send").click( function() {
        modifyPost(bid);
        $("#writeTable").css("display", "none");
        $(".container-fluid").css("filter", "none");
    });

    //글 작성 취소시 에디터 초기화 및 숨김
    $("#cancel").click( function() {
        $("#writeTable").css("display", "none");
        $(".container-fluid").css("filter", "none");
    });

    //클릭시 파일을 서버에 업로드한다.
    $("#sendFile").click( function() {
        uploadFile();
    });

    //클릭시 파일을 서버에 업로드한다.
    $("#sendHeader").click( function() {
        upload_HeaderImg();
    });

    //파일 업로드시 업로드 파일 이름을 알려줌
    $("#fileList").change(function () {
        var files = $(this)[0].files;
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
    });

    //파일 업로드시 업로드 파일 이름을 알려줌
    $("#headerList").change(function () {
        var files = $(this)[0].files;
        var filelist = '';

        for(var i =0; i < files.length; i++){
            var temp = files[i].name.split(".");
            var valid;

            switch (temp[temp.length-1]) {
                case "jpg" :
                    break;
                case "jpeg" :
                    break;
                case "png" :
                    break;
                case "gif" :
                    break;
                default :
                    alert("지원하지 않는 파일 형식입니다.\n\n지원되는 형식(jpg, jpeg, png, gif)");
                    $("form[name=headerForm]").get(0).reset();
                    valid = true;
                    break;
            }

            if(valid)
                break;
            else {

                if ((files.length - 1) == i) {
                    filelist += files[i].name
                } else {
                    filelist += files[i].name + ',&nbsp;&nbsp;&nbsp;&nbsp;'
                }

                console.log(filelist);
                $('.custom-file-label')[1].innerHTML = filelist;
            }
        }
    });
});