var pageNum = 1;
var col = ["BID", "WDATE", "TITLE", "WRITER"];

function getSearchedPost() {
    pageNum = 1;
    $.ajax({
        url: './searchPost.json/1?content=' + encodeURIComponent($("#searchContent").val()),
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
            var box = $("<div class='contentBox' bid='" + result[i].BID + "'></div>");
            var header = $("<img class='header' src='" + result[i].HEADER_IMG + "'/>");
            var body = $("<div class='body'><p>" + result[i].TITLE + "</p></div>");
            var etc = $("<div class='etc'><p class='date'>" + result[i].WDATE + "</p><p class='writer'>" + result[i].WRITER + "</p></div>");
            box.append(header);
            body.append(etc);
            box.append(body);

            $(".contentBody").append(box);
            $(".contentBox").draggable({revert:true });
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
    var content = CKEDITOR.instances.editor1.getData();
    var fileList = $("#returnFileList").val();
    var header_img = $("#returnHeader").val();
    if(content.getBytes() > 4000){
        alert('제한된 크기에 내용을 작성해주세요');
    }
    else{
        $.ajax({
            url: './writePost',
            type: 'post',
            contentType: 'application/x-www-form-urlencoded; charset=utf-8',
            headers: csrf,
            data: 'TITLE=' + title + '&' + 'CONTENT=' + content + '&' + 'FILE_LIST=' + fileList + '&' + 'HEADER_IMG=' + header_img,
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
        url: './deletePost/' + bid,
        type: 'get',
        dataType: 'json',
        success: function () {
            $.ajax({
                url: './searchPost.json/' + pageNum + '?' + 'content=' + encodeURIComponent($("#searchContent").val(), true),
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
            url: './searchPost.json/' + pageNum + '?' + 'content=' + encodeURIComponent($("#searchContent").val(), true),
            type: 'get',
            dataType: 'json',
            success: function (response) {
                searchProcess(response);
            }
        });
    }
}

function upload_HeaderImg(){
    $("form[name=headerForm]").ajaxForm({
        url : "./imageUpload.do",
        headers : csrf,
        dataType : "json",
        error : function(){
            alert("업로드 실패");
        },
        success : function(responseText){
            alert("업로드 성공");
            $("#returnHeader").val(responseText.url);
        }
    });
    $("form[name=headerForm]").submit() ;
}

function uploadFile(){
    $("form[name=fileForm]").ajaxForm({
        url : "./fileUpload.do",
        headers : csrf,
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

function withdrawal() {
    $.ajax({
        url : "./withdrawal",
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
