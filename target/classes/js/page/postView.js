var header_return = "";
var file_return = "";

jQuery.ajaxSettings.traditional = true;

function modifyPost(bid) {
    var title = $("#TITLE").val();
    var content = replaceOriginUrl(CKEDITOR.instances.editor1.getData());
    var path = window.location.pathname.substring(CONTEXT.length + 11);

    if(content.getBytes() > 4000){
        alert('제한된 크기에 내용을 작성해주세요');
    }
    else if(content.getBytes() <= 0 || title.getBytes() <= 0){
        alert('입력칸을 채워주세요.');
    }
    else{
        $.ajax({
            url: CONTEXT + '/modifyPost/' + path,
            type: 'post',
            contentType: 'application/x-www-form-urlencoded; charset=utf-8',
            headers: csrf,
            data: 'TITLE=' + title + '&' + 'CONTENT=' + content + '&' + 'FILE_LIST=' + file_return + '&' + 'HEADER_IMG=' + header_return + '&' + 'TEMP_IMGS=' + temp_images + '&' + 'IMGS=' + orginal_images,
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
    var form = $("#headerForm");
    if ($("#headerList")[0].files.length > 0) {
        form.ajaxForm({
            url: CONTEXT + "/imageUpload.do/header",
            headers: csrf,
            type : 'post',
            dataType: "json",
            error: function () {
                console.log("헤더 이미지 업로드 실패");
            },
            success: function (responseText) {
                if (responseText.result == null) {
                    header_return = responseText.fileName;
                    console.log('헤더업로드 성공');
                } else
                    console.log(responseText.result);
            },
            complete: function () {
                modifyPost(bid);
            }
        });
        form.submit();
    }
    else
        modifyPost(bid);
}

function uploadFile(){
    var form = $("#fileForm");
    if ($("#fileList")[0].files.length > 0){
        form.ajaxForm({
            url: CONTEXT + "/fileUpload.do",
            headers: csrf,
            type : 'post',
            enctype: "multipart/form-data",
            dataType: "json",
            error: function () {
                console.log("파일 업로드 실패");
            },
            success: function (responseText) {
                if (responseText.result == null) {
                    file_return = responseText.fileName;
                    console.log('파일 업로드 성공');
                } else
                    alert(responseText.result);
            },
            complete: function () {
                upload_HeaderImg();
            }
        });
        form.submit();
    }
    else
        upload_HeaderImg();
}


function deletePost(bid) {
	var path = window.location.pathname.substring(CONTEXT.length + 11);
	
    $.ajax({
        url: CONTEXT + '/deletePost/' + path,
        type: 'get',
        dataType: 'json',
        success: function () {
            location.href = "../../board2"
        },
        fail: function () {
            alert('삭제 실패하였습니다.');
        },
    });
}

function getPost(bid) {
	var path = window.location.pathname.substring(CONTEXT.length + 11);
	
    $.ajax({
        url : CONTEXT + "/Post/" + path,
        type : "get",
        dataType : "json",
        success : function (response) {
            $("#TITLE").val(response.TITLE);
            CKEDITOR.instances.editor1.setData(response.CONTENT);
            $("#byte")[0].innerText = "[" + CKEDITOR.instances.editor1.getData().getBytes() + "/4000bytes]"; // 수정모드의 경우 기존 게시물 내용에 대한 바이트도 가져와야하기 때문
            if(response.FILE_LIST != null || response.FILE_LIST != undefined){
                $("#showFiles")[0].innerHTML = response.FILE_LIST.substring(1 ,response.FILE_LIST.length - 1);
                file_return = response.FILE_LIST;
            }
            else
                $("#showFiles")[0].innerHTML = "Choose files";
            if(response.HEADER_IMG != null) {
                $("#showHeader")[0].innerHTML = response.HEADER_IMG;
                header_return = response.HEADER_IMG;
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

    //게시글 삭제
    $("#delB").click(function () {
        deletePost(bid);
    });

    //로그아웃 버튼
    $("#logoutB").click(function () {
        $("#logout").submit();
    });

    //수정 버튼 클릭시
    $("#modifyB").click( function (){
        getPost(bid);
        $(".container-fluid").css("filter", "blur(5px)");// 배경 블러처리
        $("#writeTable").css("display", "block");// 에디터 활성화
    });

    $("#TITLE").keyup( function() {
        checkByte("TITLE");
    });

    //게시글 전송시 작성화면 숨김
    $("#send").click( function() {
        uploadFile();
    });

    //글 작성 취소시 에디터 초기화 및 숨김
    $("#cancel").click( function() {
        $("#writeTable").css("display", "none");
        $(".container-fluid").css("filter", "none");
    });

    //클릭시 파일을 비운다
    $("#sendFile").click( function() {
        cleanInputFile("fileForm");
    });

    //클릭시 파일을 비운다
    $("#sendHeader").click( function() {
        cleanInputFile("headerForm")
    });

});