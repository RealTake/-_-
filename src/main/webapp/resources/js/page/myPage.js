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
        
//        var writeBox = $("<div id='writeB' class='writeBox'> <i class='fas fa-plus'></i> </div>")
//        $(selected).append(writeBox);
        
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
//            var draggable = (auth == "ROLE_ADMIN") || (name == result[i].WRITER) ? " dragContent" : "";
            var draggable = "";
            var box = $("<div class='contentBox" + draggable + "' bid='" + category + "/" + result[i].BID + "'></div>");
            var header = $("<div class='header'><img src='" + result[i].HEADER_IMG + "'/></div>");
            var body = $("<div class='body'><p>" + result[i].TITLE + "</p></div>");
            var etc = $("<div class='etc'><p class='date'>" + result[i].WDATE + "</p><p class='writer'>" + result[i].WRITER + "</p></div>");
            box.append(header);
            box.append(body);
            box.append(etc);

            $(selected).append(box);
//            $(".dragContent").draggable({revert:true });
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

//function updateProfile(){
//	$.ajax({
//        url: CONTEXT + '/profile',
//        type: 'update',
//        dataType: 'json',
//        success: function (response) {
//            searchProcess(response, category);
//        }
//    });
//}

function movePage(category, mode) {
    if (mode == 'next' && pageNum >= 1) {
        getMovedPage(category, ++pageNum);
    }
    else if (mode == 'prev' && pageNum > 1) {
        getMovedPage(category, --pageNum);
    }
}

$().ready(function() {
	
	var IDvalid = false;
	var PWDvalid = false;
	var EMAILvalid = false;
	var pattern_kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/; // 한글체크
	
	//페이지 로드후 리스트를 출력하기 위함.
	//카테고리는 무조건 소문자로 작성
	getSearchedPost("boards");
	getSearchedPost("free_boards");
	
	$("#update-myProfile").click(function() {
		$("#myProfile-view").css("display", "none");
		$("#myProfile-update").css("display", "block");
	});
	
	$("#cancel-update").click(function() {
		$("#myProfile-view").css("display", "block");
		$("#myProfile-update").css("display", "none");
	});
	
	$("#PWD").keyup(function() {
		var min = 8;
		var max = 16;
		var length = $(this).val().length;
		
		if(length < min || length > max){
			$("#send-myProfile")[0].disabled = true;
			IDvalid = false;
		}
		else
			IDvalid = true;
	});
	
	$("#NAME").keyup(function() {
		var min = 1;
		var max = 10;
		var length = $(this).val().length;	
		
		if(length < min || length > max){
			$("#send-myProfile")[0].disabled = true;
			EMAILvalid = false;
		}
		else
			EMAILvalid = true;
	});
	
	$("#EMAIL").keyup(function() {
		var min = 6;
		var max = 40;
		var length = $(this).val().length;
		
		if(length < min || length > max){
			$("#send-myProfile")[0].disabled = true;
			EMAILvalid = false;
		}
		else
			EMAILvalid = true;
	});
	
	$("input").keyup(function() {
		if(EMAILvalid == true && EMAILvalid == true && IDvalid == true)
			$("#send-myProfile")[0].disabled = false;
		else
			$("#send-myProfile")[0].disabled = true;
	});
	
});

//클릭시 게시글 보기
$(document).on("click",".contentBox",function() {
    var bid	= $(this).attr("bid");
    location.href = "./viewPost3/" + bid;
});




