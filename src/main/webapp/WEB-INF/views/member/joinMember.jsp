<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
    <meta name="viewport" content="width=device-width, user-scalable=no">

    <title>로그인 페이지</title>

    <link rel="stylesheet" href="<c:url value="/resources/css/bootstrap.css"/>">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="<c:url value="/resources/js/bootstrap.js"/>"></script>
    <script>
        var request = new XMLHttpRequest();
        var result;
        var validateId = 0;
        var validatePwd = 0;
        var validateName = 0;
        var validatePwdv = 0;

        function checkID() {
            request.open('GET', '<c:url value="/checkOverlap/"/>' + encodeURIComponent(document.getElementById('ID').value, true));
            request.onreadystatechange = checkProcess;
            request.send(null);
        }

        function checkProcess() {
            result = request.responseText;
            var node = document.getElementById('ID');
            var length = node.value.length;

            if (request.status == 200 && request.readyState == 4) {
                if(length < 5 || length > 16){
                    validateId = 0;
                    node.style.borderColor = 'red';
                    document.getElementById("IDTip").style.color = 'red';
                    document.getElementById("IDTip").innerText = "Id: 5-16";
                }
                else if (result == 0) {
                    validateId = 0;
                    node.style.borderColor = 'red';
                    document.getElementById("IDTip").style.color = 'red';
                    document.getElementById("IDTip").innerText = "Already exist.";

                }
                else if((result == 1) && (length >= 5 && length <= 16)){
                    validateId = 1;
                    node.style.borderColor = '#CED4DA';
                    document.getElementById("IDTip").innerText = "You can use";
                    document.getElementById("IDTip").style.color = 'blue';
                }
            }
        }

        function checkPwd() {
            var pwd = document.getElementById('PASSWORD');
            var pwdv = document.getElementById('PASSWORDV');

            if(pwd.value != pwdv.value) {
                validatePwdv = 0;
                pwdv.style.borderColor = 'red';
                document.getElementById('PWDTip').style.color = 'red';
                document.getElementById('PWDTip').innerText = 'Not same';
            }
            else {
                validatePwdv = 1;
                pwdv.style.borderColor = '#CED4DA';
                document.getElementById('PWDTip').style.color = 'blue';
                document.getElementById('PWDTip').innerText = "It's match";
            }

        }

        function checkValidate(s, m, check){
            var node = document.getElementById(check);
            if(node.value.length < s || node.value.length > m){
               finalValidate(check, 0);
                node.style.borderColor = 'red';
                document.getElementById(check + 'Tip').style.color = 'red';
            }
            else {
                finalValidate(check, 1);
                node.style.borderColor = '#CED4DA';
                document.getElementById(check + 'Tip').style.color = 'grey';
            }

            if(check == "PASSWORD")
                checkPwd();
        }

        function finalValidate(check, value) {
            switch (check) {
                case 'PASSWORD' :
                    validatePwd = value;
                    break;
                case 'NAME' :
                    validateName = value;
                    break;
            }

        }

        function submitForm(value) {
            if( (validatePwd == 1) && (validateId == 1) && (validatePwdv == 1) && (validateName == 1) ) {
                document.getElementById(value).submit();
            }
        }
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
        <form action="<c:url value="/join"/>" method="POST" class="form-signin" id="form">
            <label for="NAME" class="sr-only">Name</label>
            <input name="NAME" id="NAME" class="form-control" type="text" onkeyup="checkValidate(1, 10, 'NAME');" placeholder="Name" required autofocus/>
            <tip id="NAMETip">Name: 1-10</tip>

            <label for="EMAIL" class="sr-only">Email</label>
            <input name="EMAIL" id="EMAIL" class="form-control" type="email" placeholder="Email address" required autofocus/>
            <tip>Email: 일부 이메일은 지원이 안될수도있습니다.</tip>

            <label for="ID" class="sr-only">Id</label>
            <input name="ID" id="ID" class="form-control" type="text" onkeyup="checkID();" placeholder="Id" required autofocus/>
            <tip id="IDTip">Id: 5-16</tip>

            <label for="PASSWORD" class="sr-only">Password</label>
            <input name="PASSWORD" id="PASSWORD" class="form-control" type="password" onkeyup="checkValidate(8, 16, 'PASSWORD')" placeholder="Password" required autofocus/>
            <tip id="PASSWORDTip">Password: 8-16</tip>

            <label for="PASSWORDV" class="sr-only">Password Valid</label>
            <input name="PASSWORDV" id="PASSWORDV" class="form-control" type="password" onkeyup="checkPwd()" placeholder="Password Valid" required autofocus/>
            <tip id="PWDTip">팁: 비밀번호를 다시 써주세요.</tip>

            <input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
        </form>
        <input type="submit" id="joinB" class="btn btn-lg btn-primary btn-block" value="Join" onclick="submitForm('form');"/>
    </div>
</div>

</body>
</html>