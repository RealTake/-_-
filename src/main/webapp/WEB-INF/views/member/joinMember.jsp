<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인 페이지</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no">

    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
    <link rel="stylesheet" href="<c:url value="/resources/css/bootstrap.css"/>">

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="<c:url value="/resources/js/bootstrap.js"/>"></script>
    <script>
        var validateId = 0;
        var validatePwd = 0;
        var validateName = 0;
        var validatePwdv = 0;
        var validateEmail = 0;

        function checkID() {
            var id = encodeURIComponent($("#ID").val(), true);
            $.ajax({
                url: '<c:url value="/checkOverlap/"/>' + id,
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

            if (length < 5 || length > 16) {
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
                node.css("borderColor", "#CED4DA");
                tip.css("color","blue");
                tip[0].innerText = "You can use.";
            }
        }

        function checkPwd() {
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
                pwdvNode.css("borderColor", "#CED4DA");
                tip.css("color", "blue");
                tip[0].innerText = "It's match";
            }

        }

        //유효성 검사 함수로 ID는 전용함수가 있다.
        function checkValidate(s, m, check){
            var node = $('#' + check);
            var tip = $('#' + check + "Tip");
            var length = node.val().length;

            if(length < s || length > m){
                validates(check, 0);
                node.css("borderColor", "red");
                tip.css("color", "red");
            }
            else {
                validates(check, 1);
                node.css("borderColor", "#CED4DA");
                tip.css("color", "grey");
            }

            if(check == "PASSWORD")
                checkPwd();
        }

        //checkValidate()를 이용할 경우 유효성 검사 대상의 유효성을 설정할수 있도록함
        function validates(check, value) {
            switch (check) {
                case 'PASSWORD' :
                    validatePwd = value;
                    break;
                case 'NAME' :
                    validateName = value;
                    break;
                case 'EMAIL' :
                    validateEmail = value;
                    break;
            }

        }

        //회원가입 버튼 클릭시 최종 검사
        function submitForm(value) {
            if( (validatePwd == 1) && (validateId == 1) && (validatePwdv == 1) && (validateName == 1) && (validateEmail ==1))
                value.submit();
            else {
                alert("입력칸을 확인해주세요");
            }
        }

        $().ready(function () {
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
                checkPwd();
            });

            $("#joinB").click(function () {
                submitForm(this.form);
            });
        })
    </script>
    <style>
        @media screen and ( max-width: 750px) {
            .loginBody {
                border: 1px solid #CED4DA;
                border-radius: 10px 10px;
                width: 90%;
                height: auto;
                margin-left: auto;
                margin-right: auto;
                margin-top: 10%;
                padding: 10px;
                box-shadow: 0px 1px 10px #434e9a;
                background-color: white;
            }
        }

        @media screen and ( min-width: 751px) {
            .loginBody {
                border: 1px solid #CED4DA;
                border-radius: 10px 10px;
                width: 700px;
                height: auto;
                margin-left: auto;
                margin-right: auto;
                margin-top: 10%;
                padding: 70px;
                box-shadow: 0px 1px 10px #434e9a;
                background-color: white;
            }
        }
        tip {
            margin-left: 1px;
            font-size: 0.9em;
            color: grey;
        }

        body{
            font-family: "맑은 고딕";
            background-color: #5e91f8;
        }

        .floor {
            height: 700px;
            overflow: visible;
            background-color: yellow;
            padding-top: 5px;
            box-shadow: 0px 1px 10px #434e9a inset;
        }

        .form-control {
            font-size: 20px;
            margin-top: 15px;
            padding-top: 20px;
            padding-bottom: 20px;
        }

        @media all and (-ms-high-contrast:none)
        {
            *::-ms-backdrop, .form-control {
                font-size: 20px;
                margin-bottom: 20px;
                padding-top: 0;
                padding-bottom: 0;
            }
            *::-ms-backdrop, .loginBody {
                border: 1px solid #CED4DA;
                border-radius: 10px 10px;
                width: 700px;
                height: auto;
                margin: auto;
                margin-top: 5%;
                padding: 70px;
                box-shadow: 0px 1px 10px #434e9a;
                background-color: white;
            }
        }
        #joinB {
            margin-top: 30px;
            border: none;
            height: 59px;
            background-color: #5e91f8;
        }

    </style>

    <s:authorize access="isAuthenticated()">
        <c:redirect url="/"/>
    </s:authorize>

</head>
<body>
<div class="floor">
    <div class="loginBody">
        <form action="<c:url value="/join"/>" method="POST">
            <label for="NAME" class="sr-only">Name</label>
            <input name="NAME" id="NAME" class="form-control" type="text" placeholder="Name" required autofocus/>
            <tip id="NAMETip">Name: 1-10</tip>

            <label for="EMAIL" class="sr-only">Email</label>
            <input name="EMAIL" id="EMAIL" class="form-control" type="email" placeholder="Email address" required autofocus/>
            <tip>Email: 일부 이메일은 지원이 안될수도있습니다.</tip>

            <label for="ID" class="sr-only">Id</label>
            <input name="ID" id="ID" class="form-control" type="text" placeholder="Id" required autofocus/>
            <tip id="IDTip">Id: 5-16</tip>

            <label for="PASSWORD" class="sr-only">Password</label>
            <input name="PASSWORD" id="PASSWORD" class="form-control" type="password" placeholder="Password" required autofocus/>
            <tip id="PASSWORDTip">Password: 8-16</tip>

            <label for="PASSWORDV" class="sr-only">Password Valid</label>
            <input name="PASSWORDV" id="PASSWORDV" class="form-control" type="password" placeholder="Password Valid" required autofocus/>
            <tip id="PWDTip">팁: 비밀번호를 다시 써주세요.</tip>

            <input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
            <input type="button" id="joinB" class="btn btn-lg btn-primary btn-block" value="Join"/>
        </form>
    </div>
</div>

</body>
</html>