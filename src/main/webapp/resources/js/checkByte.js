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
    var limit = 100;
    
    if(byte > limit){
    	var lastChar = dom.value[dom.value.length -1];
    	var range = byte - limit;
    	var cnt = 0;
    	
    	alert('제한된 크기에 제목을 작성해주세요');
    	while(range > 0){
    		var lastChar = dom.value[dom.value.length - (1 + cnt)];
    		range -= lastChar.getBytes();
    		cnt++;
    	}
    	
        dom.value = dom.value.substring(0, dom.value.length - cnt);
    }
}