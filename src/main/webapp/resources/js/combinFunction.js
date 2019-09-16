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