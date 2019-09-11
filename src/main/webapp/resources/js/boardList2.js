var pageNum = 1;
var col = ["BID", "WDATE", "TITLE", "WRITER"];
var header_return = "";
var file_return = "";
var temp_images = "";

jQuery.ajaxSettings.traditional = true;

function setPaging() {
    $.ajax({
        url: CONTEXT + '/count?content=' + encodeURIComponent($("#searchContent").val()),
        type: 'get',
        dataType: 'text',
        success: function (response) {
            $(".pagination")[0].innerHTML = "";
            for(var i=1; i<=response;i++) {
                if(i == pageNum)
                    pageBox = $("<li class='page-item active'><button class='page-link'>" + i +"</button></li>");
                else
                    pageBox = $("<li class='page-item'><button class='page-link'>" + i +"</button></li>");
                $(".pagination").append(pageBox);
            }
        },
        fail: function (error) {
            alert('로드 실패');
        },
    });
}

function getSearchedPost() {
    pageNum = 1;
    pageBox = "";
    $.ajax({
        url: CONTEXT + '/searchPost.json/1?content=' + encodeURIComponent($("#searchContent").val()),
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
    var table = $(".contentBody")[0];
    var result = response.result;
    var limit;
    setPaging();// 페이징 버튼 생성

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

        if(result.length > 10)
            limit = 10;
        else
            limit = result.length;

        for (var i = 0; limit > i; i++) {
            if(result[i].HEADER_IMG == null || result[i].HEADER_IMG == "")
                result[i].HEADER_IMG = "https://cdn.pixabay.com/photo/2017/06/09/23/23/background-2388586_960_720.jpg";
            else
                result[i].HEADER_IMG = CONTEXT + "/uploadImage/" + result[i].HEADER_IMG;
            var draggable = (auth == "ROLE_ADMIN") || (name == result[i].WRITER) ? " dragContent" : "";
            var box = $("<div class='contentBox" + draggable + "' bid='" + result[i].BID + "'></div>");
            var header = $("<img class='header' src='" + result[i].HEADER_IMG + "'/>");
            var body = $("<div class='body'><p>" + result[i].TITLE + "</p></div>");
            var etc = $("<div class='etc'><p class='date'>" + result[i].WDATE + "</p><p class='writer'>" + result[i].WRITER + "</p></div>");
            box.append(header);
            body.append(etc);
            box.append(body);

            $(".contentBody").append(box);
            $(".dragContent").draggable({revert:true });
        }
    }
    else {
        $("#pageB").css("display", "none");
        $(".contentBody")[0].innerHTML = "";// 마지막 하나남은 게시물을 삭제할시 화면에 게시글이 남는현상을 억제
        movePage('prev');
    }
}

function writePost() {
    var title = $("#TITLE").val();
    var content = replaceOriginUrl(CKEDITOR.instances.editor1.getData());
    console.log('서버에 전송될 요소');
    console.log('TITLE=' + title);
    console.log('FILE_LIST=' + file_return);
    console.log('HEADER_IMG=' + header_return);
    if(content.getBytes() > 4000){
        alert('제한된 크기에 내용을 작성해주세요.');
    }
    else if(content.getBytes() <= 0 || title.getBytes() <= 0){
        alert('입력칸을 채워주세요.');
    }
    else{
        $.ajax({
            url: CONTEXT + '/writePost',
            type: 'post',
            contentType: 'application/x-www-form-urlencoded; charset=utf-8',
            headers: csrf,
            data: 'TITLE=' + title + '&' + 'CONTENT=' + content + '&' + 'FILE_LIST=' + file_return + '&' + 'HEADER_IMG=' + header_return + '&' + 'TEMP_IMAGES=' + temp_images,
            dataType: 'text',
            success: function () {
                writeB(false);
                getSearchedPost();
            },
            error: function () {
                alert('등록을 실패하였습니다.');
            }
        });
    }
}

function deletePost(bid) {
    $.ajax({
        url: CONTEXT + '/deletePost/' + bid,
        type: 'get',
        dataType: 'json',
        success: function () {
            $.ajax({
                url: CONTEXT + '/searchPost.json/' + pageNum + '?' + 'content=' + encodeURIComponent($("#searchContent").val(), true),
                type: 'get',
                dataType: 'json',
                success: function (response) {
                    searchProcess(response);
                }
            });
        },
        fail: function () {
            alert('삭제 실패하였습니다.');
        },
    });
}

function getMovedPage(temp) {
    $.ajax({
        url: CONTEXT + '/searchPost.json/' + temp + '?' + 'content=' + encodeURIComponent($("#searchContent").val()),
        type: 'get',
        dataType: 'json',
        success: function (response) {
            searchProcess(response);
        }
    });
}

function movePage(mode) {
    if (mode == 'next' && pageNum >= 1) {
        getMovedPage(++pageNum);
    }
    else if (mode == 'prev' && pageNum > 1) {
        getMovedPage(--pageNum);
    }
}

function upload_HeaderImg(){
    if ($("#headerList")[0].files.length > 0) {
        $("form[name=headerForm]").ajaxForm({
            url: CONTEXT + "/imageUpload.do/header",
            headers: csrf,
            dataType: "json",
            error: function () {
                console.log("헤더 이미지 업로드 실패");
            },
            success: function (responseText) {
                if (responseText.result == null) {
                    header_return = responseText.fileName;
                    console.log('헤더업로드 성공');
                }
                else
                    console.log(responseText.result);
            },
            complete: function () {
                writePost();
            }
        });
        $("form[name=headerForm]").submit();
    }
    else
        writePost();
}

function uploadFile() {
    if ($("#fileList")[0].files.length > 0){
        $("form[name=fileForm]").ajaxForm({
            url: CONTEXT + "/fileUpload.do",
            headers: csrf,
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
        $("form[name=fileForm]").submit();
    }
    else
        upload_HeaderImg();
}

function withdrawal() {
    $.ajax({
        url : CONTEXT + "/withdrawal",
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

