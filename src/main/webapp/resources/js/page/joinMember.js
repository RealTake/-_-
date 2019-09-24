 var validateId = 0;
        var validatePwd = 0;
        var validateName = 0;
        var validatePwdv = 0;
        var validateEmail = 0;
        var pattern_kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/; // 한글체크

        $().ready(function () {
        	
            function checkID() {
                var id = encodeURIComponent($("#ID").val(), true);
                $.ajax({
                    url: CONTEXT + '/checkOverlap/' + id,
                    type: 'get',
                    dataType: 'text',
                    success: function (response) {
                        checkProcess(response);
                    },
                    error: function () {
                    },
                });
            }

            function checkProcess(result) {
                var node = $("#ID");
                var tip = $("#IDTip");
                var length = node.val().length;

                if(pattern_kor.test(node.val())){
                	validateId = 0;
        			node.css("borderColor", "red");
        			tip.css("color","red");
        			tip[0].innerText = "영문, 숫자, 특수기호만 사용 가능합니다.";
        		}
                else if (length < 5 || length > 16) {
                    validateId = 0;
                    node.css("borderColor", "red");
                    tip.css("color","red");
                    tip[0].innerText = "Id: 5-16";
                }
                else if (result == 0) {
                    validateId = 0;
                    node.css("borderColor", "red");
                    tip.css("color","red");
                    tip[0].innerText = "Already exist.";
                }
                else if ((result == 1) && (length >= 5 && length <= 16)) {
                    validateId = 1;
                    node.css("borderColor", "blue");
                    tip.css("color","blue");
                    tip[0].innerText = "You can use.";
                }
                checkFinalForm
            }

            function isPwdMatch() {
                var pwd = $("#PASSWORD").val();
                var pwdv = $("#PASSWORDV").val();
                var pwdvNode = $("#PASSWORDV");
                var tip = $("#PWDTip");

                if(pwd != pwdv) {
                    validatePwdv = 0;
                    pwdvNode.css("borderColor", "red");
                    tip.css("color", "red");
                    tip[0].innerText = 'Not same';
                }
                else {
                    validatePwdv = 1;
                    pwdvNode.css("borderColor", "grey");
                    tip.css("color", "blue");
                    tip[0].innerText = "It's match";
                }

            }

            //유효성 검사 함수로
            function checkValidate(s, m, check){
                var node = $('#' + check);
                var tip = $('#' + check + "Tip");
                var length = node.val().length;

                if(pattern_kor.test(node.val()) & check != "NAME"){
                	validates(check, 0);
        			node.css("borderColor", "red");
        			tip[0].innerText = "영문, 숫자, 특수기호만 사용 가능합니다.";
        			tip.css("color","red");
        		}
                else if(length < s || length > m){
                    validates(check, 0);
                    node.css("borderColor", "red");
                    tip.css("color", "red");
                }
                else {
                    validates(check, 1);
                    node.css("borderColor", "grey");
                    tip.css("color", "grey");
                }

                if(check == "PASSWORD")
                    isPwdMatch();
                else if(check == "PASSWORDV")
                    isPwdMatch();

                checkFinalForm();//회원가입의 최종 유효성을 체크하기위해 호출
            }

            //checkValidate()를 이용할 경우 유효성 검사 대상의 유효성을 설정할수 있도록함
            function validates(check, value) {
                switch (check) {
                    case 'PASSWORD' :
                        validatePwd = value;
                        $("#" + check + "Tip")[0].innerText = "Password: 8-16"
                        break;
                    case 'NAME' :
                        validateName = value;
                        break;
                    case 'EMAIL' :
                        validateEmail = value;
                        $("#" + check + "Tip")[0].innerText = "Email: 일부 이메일은 지원이 안될수도있습니다."
                        break;
                }

            }
            	
            $("#NAME").keyup(function () {
                checkValidate(1, 10, $(this).attr("id"));
            });

            $("#EMAIL").keyup(function () {
                checkValidate(6, 40, $(this).attr("id"));
            });

            $("#ID").keyup(function () {
                checkID();
            });

            $("#PASSWORD").keyup(function () {
                checkValidate(8, 16, $(this).attr("id"));
            });

            $("#PASSWORDV").keyup(function () {
                checkValidate(0, 999, $(this).attr("id"));
            });

            //회원가입 버튼 클릭시 최종 검사
            function checkFinalForm() {
                if( (validatePwd == 1) && (validateId == 1) && (validatePwdv == 1) && (validateName == 1) && (validateEmail ==1)) {
                    $("#joinB")[0].disabled = false;
                    $("#joinB").css("borderColor", "blue");
                }
                else{
                    $("#joinB")[0].disabled = true;
                    $("#joinB").css("borderColor", "red");
                }
            }
        });