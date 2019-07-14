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
        header_img = "";
        $('#fileList').val("");
        $('#returnFileList').val("");
        $('#TITLE').val("");
        $('#writeB').css('display', 'block');
        $('#writeTable').css('display', 'none');
        $('#showFiles')[0].innerHTML = "";
    }
}

$().ready( function() {
    //페이지 로드후 리스트를 출력하기 위함.
    getSearchedPost();

    //드레그 허용
    $(".contentBox").draggable({revert:true });

    //삭제 드레그시
    $(".deleteBox").droppable({
        over : function(){
            $(this).css("background-color", "red");
        },
        out : function(){
            $(this).css("background-color", "black");
        },
        drop : function(){
            deletePost(temp_bid);
            $(".deleteBox").css("display", "none");
            $(this).css("background-color", "black");
        }
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
            if((files.length - 1) == i) {
                filelist += files[i].name
            } else {
                filelist += files[i].name + ',&nbsp;&nbsp;&nbsp;&nbsp;'
            }
        }
        console.log(filelist);
        $('.custom-file-label')[1].innerHTML = filelist;
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

    //클릭시 파일을 서버에 업로드한다.
    $("#sendFile").click( function() {
        uploadFile();
    });

    //클릭시 파일을 서버에 업로드한다.
    $("#sendHeader").click( function() {
        upload_HeaderImg();
    });

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

    //회원 탈퇴
    $("#dropB").click( function (){
        withdrawal();
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
    location.href = "/viewPost2/" + bid;
});

//게시글 목록중 드레그 시
$( document ).on("dragstart",".contentBox",function(e){
    $(".deleteBox").css("display", "block");
    temp_bid = $(this).attr("bid");
});

//게시글 목록중 드레그 멈추면
$( document ).on("dragstop",".contentBox",function(){
    $(".deleteBox").css("display", "none");
});