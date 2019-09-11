function replaceOriginUrl(content) {
    var getImages = new RegExp('src="' + CONTEXT + '/temp/(.*?)"', 'g');
    var change = new RegExp('src="' + CONTEXT + '/temp', 'g');
    temp_images = content.match(getImages);
    for(image in temp_images){
        temp_images[image] = temp_images[image].substring(11 + CONTEXT.length, temp_images[image].length - 1);
    }
    console.log('임시파일로 저장된 파일들: ' + temp_images);

    return content.replace(change, 'src="' + CONTEXT + '/uploadImage');
}

function clearInputFile(select) {
    $("form[name=" + select + "]").get(0).reset();
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