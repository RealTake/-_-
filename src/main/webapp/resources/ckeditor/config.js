/**
 * @license Copyright (c) 2003-2019, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see https://ckeditor.com/legal/ckeditor-oss-license
 */


CKEDITOR.editorConfig = function( config ) {
	config.enterMode = CKEDITOR.ENTER_BR;
    config.height = 500;
    config.removeButtons = 'Flash,Table,Preview,ImageButton,HiddenField,Print,PageBreak';
	config.toolbarCanCollapse = true;
	config.font_names = '맑은 고딕/Malgun Gothic;굴림/Gulim;돋움/Dotum;바탕/Batang;궁서/Gungsuh;' + config.font_names;
};
