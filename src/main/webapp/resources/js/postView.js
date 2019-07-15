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

$().ready( function() {
    //게시글 삭제
    $("button[name=delB]").click(function () {
        var bid = $(this).attr("bid");
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
});