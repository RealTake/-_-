String.prototype.getBytes = function() {
    var contents = this;
    var str_character;
    var int_char_count;
    var int_contents_length;

    int_char_count = 0;
    int_contents_length = contents.length;

    for (k = 0; k < int_contents_length; k++) {
        str_character = contents.charAt(k);
        if (escape(str_character).length > 4)
            int_char_count += 3;// utf-8의 경우 한글이 3바이트
        else
            int_char_count++;
    }
    return int_char_count;
}

function checkByte(caller) {
    var dom = document.getElementById(caller);
    var byte = dom.value.getBytes();
    if(byte > 30){
        alert('제한된 크기에 제목을 작성해주세요');
        dom.value = dom.value.substring(0,10);
        console.log(dom.value.getBytes());
    }
}