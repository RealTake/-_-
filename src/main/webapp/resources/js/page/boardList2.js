var pageNum = 1;
var col = ["BID", "WDATE", "TITLE", "WRITER"];
var header_return = "";
var file_return = "";
var temp_images = "";

jQuery.ajaxSettings.traditional = true;

function setPaging2() {
    $.ajax({
        url: CONTEXT + '/count?content=' + encodeURIComponent($("#searchContent").val()),
        type: 'get',
        dataType: 'text',
        success: function (response) {
            $(".pagination")[0].innerHTML = "";
            for(var i=1; i<=response; i++) {
                if(i == pageNum)
                    pageBox = $("<li class='page-item active'><button class='page-link'>" + i +"</button></li>");
                else
                    pageBox = $("<li class='page-item'><button class='page-link'>" + i +"</button></li>");
                $(".pagination").append(pageBox);
            }
        },
        fail: function (error) {
        	alert('페이지 카운트 실패');
        },
    });
}

function setPaging(category) {
    $.ajax({
        url: CONTEXT + '/' + category + '/count?content=' + encodeURIComponent($("#searchContent").val()),
        type: 'get',
        dataType: 'text',
        success: function (response) {	
        	$("#" + category + "-slider").slider({
                value: pageNum,
                animate: "slow",
                min: 1,
                max: response,
                step: 1,
                change: function( event, ui ) {
                    if(ui.value > pageNum )
                    	movePage(category, "next");
                    else if(ui.value < pageNum )
                    	movePage(category, "prev");
                }
            }).slider("pips", {
            	rest: "label"
            });
            
        },
        fail: function (error) {
            alert('페이지 카운트 실패');
        },
    });
}

function getSearchedPost(category) {
    pageNum = 1;
    pageBox = "";
    $.ajax({
        url: CONTEXT + '/searchPost.json/' + category + '/1?content=' + encodeURIComponent($("#searchContent").val()),
        type: 'get',
        dataType: 'json',
        success: function (response) {
            searchProcess(response, category);
        },
        fail: function (error) {
            alert('로드 실패');
        },
    });
}

function searchProcess(response, category) {
	var selected = '#' + category + "-contentBody";
    var table = $(selected)[0];
    var result = response.result;
    var baseLimit = 10;
    var limit;

    if (result.length > 0) {
        table.innerHTML = "";
        setPaging(category);// 페이징 버튼 생성
        
        var writeBox = $("<div id='writeB' class='writeBox'> <i class='fas fa-plus'></i> </div>")
        $(selected).append(writeBox);
        
        $("#pageN").text(pageNum);
        $("#pageB").css("display", "block");

//        이전, 다음 페이징 버튼
//        if(result.length <= baseLimit)
//            $("#next").css("visibility", "hidden");
//        else
//            $("#next").css("visibility", "visible");
//
//        if(pageNum <= 1)
//            $("#prev").css("visibility", "hidden");
//        else
//            $("#prev").css("visibility", "visible");

        if(result.length > baseLimit)
            limit = baseLimit;
        else
            limit = result.length;

        
        for (var i = 0; limit > i; i++) {
            if(result[i].HEADER_IMG == null || result[i].HEADER_IMG == "")
                result[i].HEADER_IMG = "https://post-phinf.pstatic.net/MjAxNzExMThfMTU3/MDAxNTEwOTg1MjU0MDMw.UnE6KDZeDvuggh3tCZyAh1TnZdmvZQGLVZbT2nhBIAYg.9QvOIhmCZnSwa0BXJ8CVs3ROxovGtlVmRmglS2HE8esg.JPEG/20171118-006.jpg?type=w1200";
            else
                result[i].HEADER_IMG = CONTEXT + "/uploadImage/" + result[i].HEADER_IMG;
            var draggable = (auth == "ROLE_ADMIN") || (name == result[i].WRITER) ? " dragContent" : "";
            var box = $("<div class='contentBox" + draggable + "' bid='" + category + "/" + result[i].BID + "'></div>");
            var header = $("<div class='header'><img src='" + result[i].HEADER_IMG + "'/></div>");
            var body = $("<div class='body'><p>" + result[i].TITLE + "</p></div>");
            var etc = $("<div class='etc'><p class='date'>" + result[i].WDATE + "</p><p class='writer'>" + result[i].WRITER + "</p></div>");
            box.append(header);
            box.append(body);
            box.append(etc);

            $(selected).append(box);
            $(".dragContent").draggable({revert:true });
        }
    }
    else {
    	if($("#slider").get(0).innerText != "")
    		$("#slider").remove();
    	
        $("#pageB").css("display", "none");
        $(selected)[0].innerHTML = "";// 마지막 하나남은 게시물을 삭제할시 화면에 게시글이 남는현상을 억제
        movePage('prev');
    }
}

function writePost() {
    var title = $("#TITLE").val();
    var content = replaceOriginUrl(CKEDITOR.instances.editor1.getData());
    var category = $("#selectCategory").val();
    
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
            data: 'CATEGORY=' + category + '&' + 'TITLE=' + title + '&' + 'CONTENT=' + content + '&' + 'FILE_LIST=' + file_return + '&' + 'HEADER_IMG=' + header_return + '&' + 'TEMP_IMGS=' + temp_images,
            dataType: 'text',
            success: function () {
            	$(".container-fluid").css("filter", "none");
                writeB(false);
                getSearchedPost(category);
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

function getMovedPage(category, page) {
    $.ajax({
        url: CONTEXT + '/searchPost.json/' + category + '/' + page + '?' + 'content=' + encodeURIComponent($("#searchContent").val()),
        type: 'get',
        dataType: 'json',
        success: function (response) {
            searchProcess(response, category);
        }
    });
}

function movePage(category, mode) {
    if (mode == 'next' && pageNum >= 1) {
        getMovedPage(category, ++pageNum);
    }
    else if (mode == 'prev' && pageNum > 1) {
        getMovedPage(category, --pageNum);
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
                }
                else
                    console.log(responseText.result);
            },
            complete: function () {
                writePost();
            }
        });
        form.submit();
    }
    else
        writePost();
}

function uploadFile() {
    var form = $("#fileForm");
    if ($("#fileList")[0].files.length > 0){
        form.ajaxForm({
            url: CONTEXT + "/fileUpload.do",
            headers: csrf,
            enctype: "multipart/form-data",
            type : 'post',
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


