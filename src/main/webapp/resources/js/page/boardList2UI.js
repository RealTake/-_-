var temp_bid;

//작성글 화면에서 글쓰기, 취소 버튼을 눌렀을때 작성화면을 비운다.
function writeB(mode) {
    if (mode)
    {
        $('#writeB').css('display', 'none');
        $('#writeTable').css('display', 'block');
        var offset = $("#writeTable").offset().top;
        var winH = $(window).height();
        $('html, body').animate({scrollTop : (offset)}, 400);
    }
    else {
        CKEDITOR.instances.editor1.setData('');
        $('#fileList').val("");
        file_return = "";
        header_return = "";
        temp_files = "";
        $('#TITLE').val("");
        $('#writeB').css('display', 'block');
        $('#writeTable').css('display', 'none');
        $('#showFiles')[0].innerHTML = "Choose files";
        $('#showHeader')[0].innerHTML = "Choose header image";
    }
}

$().ready( function() {
    //페이지 로드후 리스트를 출력하기 위함.
	//카테고리는 무조건 소문자로 작성
	getSearchedPost("boards");
	getSearchedPost("free_boards");

    //드랍 할 요소 설정
    $(".deleteBox").droppable({
        over : function(){
            $(this).css("background-color", "red");
        },
        out : function(){
            $(this).css("background-color", "transparent");
        },
        drop : function(){
            deletePost(temp_bid);
            $(".deleteBox").css("display", "none");
            $(".category-list").css("display", "block");
            $(this).css("background-color", "transparent");
        }
    });

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

    //클릭시 파일을 비운다
    $("#sendFile").click( function() {
        cleanInputFile("fileForm");
    });

    //클릭시 파일을 비운다
    $("#sendHeader").click( function() {
        cleanInputFile("headerForm")
    });

    //제목 바이트 확인
    $("#TITLE").keyup( function() {
        checkByte("TITLE");
    });

    //게시글 전송시 작성화면 숨김
    $("#send").click( function() {
        uploadFile();
    });

    //글 작성 취소시 에디터 초기화 및 숨김
    $("#cancel").click( function() {
        $(".container-fluid").css("filter", "none");
        writeB(false);
    });

//    //페이지 이전으로 전환
//    $("#prev").click( function() {
//        movePage($(this).attr("id"));
//    });
//
//    //다음 페이지로 전환
//    $("#next").click( function() {
//        movePage($(this).attr("id"));
//    });

    //로그아웃 버튼
    $("#logoutB").click( function (){
        $("#logout").submit();
    });
    
});


//Dom로드후 만들어진 삭제 버튼 요소에대한 클릭 이벤트를 가능하게한다.
$(document).on("click","button[name=delB]",function() {
    var bid	= $(this).attr("bid");
    deletePost(bid);
});

//클릭시 게시글 보기
$(document).on("click",".contentBox",function() {
    var bid	= $(this).attr("bid");
    location.href = "./viewPost2/" + bid;
});

//게시글 목록중 드레그 시
$( document ).on("dragstart",".dragContent",function(e){
    $(".deleteBox").css("display", "block");
    $(".category-list").css("display", "none");
    temp_bid = $(this).attr("bid");
    $(this).css("z-index", "999");
});

//게시글 목록중 드레그 멈추면
$( document ).on("dragstop",".dragContent",function(){
    $(".deleteBox").css("display", "none");
    $(".category-list").css("display", "block");
    $(this).css("z-index", "500");
});

//페이지 이동
$( document ).on("click",".page-link", function () {
    var selectPage = $(this)[0].innerHTML;
    pageNum = selectPage;
    console.log(selectPage);
    getMovedPage(selectPage);
});

$( document ).on(function () {
    $(".dragContent").draggable({revert:true });
});

//글쓰기 창을 활성화
$( document ).on("click","#writeB", function() {
    $(".container-fluid").css("filter", "blur(5px)");
    writeB(true);
});