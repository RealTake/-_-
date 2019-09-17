function replaceOriginUrl(content) {
	var getOriginalImages = new RegExp('src="' + CONTEXT + '/uploadImage/(.*?)"', 'g');
    var getImages = new RegExp('src="' + CONTEXT + '/temp/(.*?)"', 'g');
    var change = new RegExp('src="' + CONTEXT + '/temp', 'g');
    temp_images = content.match(getImages);
    orginal_images = content.match(getOriginalImages);
    
    for(var image in temp_images){
    	console.log(temp_images[image]);
        temp_images[image] = temp_images[image].substring(CONTEXT.length + 11, temp_images[image].length - 1);
    }
    for(var image in orginal_images){
    	orginal_images[image] = orginal_images[image].substring(CONTEXT.length + 18, orginal_images[image].length - 1);
    }
    
    console.log("전" + temp_images);
    if(temp_images == null){
    	temp_images = "";
    	console.log("후" + temp_images);
    }
    
    console.log("전" + orginal_images);
    if(orginal_images == null){
    	orginal_images = "";
    	console.log("후" + orginal_images);
    }
    
    console.log('임시파일로 저장된 파일들: ' + temp_images);
    console.log('오리지날로 저장된 파일들: ' + orginal_images);
    
    return content.replace(change, 'src="' + CONTEXT + '/uploadImage');
}

function cleanInputFile(select) {
    $("#" + select).get(0).reset();
    switch (select) {
        case "headerForm" :
            header_return = "";
            $('.custom-file-label')[1].innerHTML = "Choose header images";
            break;
        case "fileForm" :
            file_return = "";
            $('.custom-file-label')[0].innerHTML = "Choose files";
            break;
    }

}

function checkFileValidate(form) {
	var files = form[0].files;
	var fileLength = files.length;
    var fileSize = 0;// 바이트로 가지고 온다
    var fileMaxLength = parseInt(10, form.attr('maxlength'));
    var fileMaxSize =  eval(form.attr('data-maxsize')); // 메가바이트로 가지고온다
    
    console.log("fileMaxLength: " + fileMaxLength);
    console.log("fileMaxSize: " + fileMaxSize);
    
    for(var i = 0; i < fileLength; i++){
    	fileSize += files[i].size * 0.001;// 바이트를 킬로 단위로 계산한다
    }
    
    if(fileSize > fileMaxSize * 1024){// 메가바이트를 킬로 바이트로 전환 하여 계산
    	alert("총 " + Math.round(fileSize) + "KB 입니다. \n" + fileMaxSize + "MB 이하로 맞춰주세요" );
    	return false;
    }
    
    if(fileMaxLength != null && fileLength > fileMaxLength){
    	alert("총" + fileLength + "개 입니다. \n" + fileMaxLength + "이하로 맞춰주세요" );
    	return false;
    }
    
    return true;
}

$().ready( function() {

	//파일 업로드시 업로드 파일 이름을 알려줌
	$("#fileList").change(function () {
	    var files = $(this)[0].files;
	    var filelist = '';
	
	    if(!checkFileValidate($(this))){
	    	$("#fileForm").get(0).reset();
	    	return;
	    }
	    
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
	    
	    if(!checkFileValidate($(this))){
	    	$("#headerForm").get(0).reset();
	    	return;
	    }
	    
	    for(var i =0; i < files.length; i++){
	        var temp = files[i].name.split(".");
	        var valid;
	
	        switch (temp[temp.length-1]) {
	            case "jpg" :
	                break;
	            case "jpeg" :
	                break;
	            case "png" :
	                break;
	            case "PNG" :
	                break;
	            case "gif" :
	                break;
	            default :
	                alert("지원하지 않는 파일 형식입니다.\n\n지원되는 형식(jpg, jpeg, png, gif)");
	                $("form[name=headerForm]").get(0).reset();
	                valid = true;
	                break;
	        }
	
	        if(valid)
	            break;
	        else {
	
	            if ((files.length - 1) == i) {
	                filelist += files[i].name
	            } else {
	                filelist += files[i].name + ',&nbsp;&nbsp;&nbsp;&nbsp;'
	            }
	
	            console.log(filelist);
	            $('.custom-file-label')[1].innerHTML = filelist;
	        }
	    }
	});
});