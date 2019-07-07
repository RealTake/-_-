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
    <link rel="stylesheet" type="text/css" href="./resources/css/joinMember.css">

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
                node.css("borderColor", "#B8B8B8");
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
                pwdvNode.css("borderColor", "grey");
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
                node.css("borderColor", "grey");
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
    <s:authorize access="isAuthenticated()">
        <c:redirect url="/"/>
    </s:authorize>

</head>
<body>
<div class = "body">
    <form action="<c:url value="/join"/>" method="POST" class="center">
        <input name="NAME" id="NAME" class="underline" type="text" placeholder="NAME" required autofocus/>
        <tip id="NAMETip">Name: 1-10</tip>

        <input name="EMAIL" id="EMAIL" class="underline" type="email" placeholder="EMAIL" required autofocus/>
        <tip id="EMAILTip">Email: 일부 이메일은 지원이 안될수도있습니다.</tip>

        <input name="ID" id="ID" class="underline" type="text" placeholder="ID" required autofocus/>
        <tip id="IDTip">Id: 5-16</tip>

        <input name="PASSWORD" id="PASSWORD" class="underline" type="password" placeholder="PASSWORD" required autofocus/>
        <tip id="PASSWORDTip">Password: 8-16</tip>

        <input name="PASSWORDV" id="PASSWORDV" class="underline" type="password" placeholder="PASSWORD VALID" required autofocus/>
        <tip id="PWDTip">팁: 비밀번호를 다시 써주세요.</tip>

        <input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
        <button type="button" id="joinB">Join</button>
    </form>
</div>
</body>
</html>