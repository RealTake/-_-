<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    <link rel="shortcut icon" href="<c:url value="/resources/ui-ux-logo.ico"/>">
    <meta name="viewport" content="width=device-width, user-scalable=no">

    <title>로그인 페이지</title>

    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.css'/>">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="<c:url value='/resources/js/bootstrap.js'/>"></script>

<style>
    @media screen and ( max-width: 750px) {
        .loginBody {
            border: 1px solid #CED4DA;
            border-radius: 10px 10px;
            width: 90%;
            height: 400px;
            margin: auto;
            margin-top: 2%;
            padding-left: 40px;
            padding-right: 40px;
            padding-bottom: 40px;
            box-shadow: 0px 1px 10px #434e9a;
            background-color: white;
        }
    }

    @media screen and ( min-width: 751px) {
        .loginBody {
            border: 1px solid #CED4DA;
            border-radius: 10px 10px;
            width: 700px;
            height: 400px;
            margin: auto;
            margin-top: 2%;
            padding-left: 80px;
            padding-right: 80px;
            padding-bottom: 40px;
            box-shadow: 0px 1px 10px #434e9a;
            background-color: white;
        }
    }
    body{
		font-family: "맑은 고딕";
		background-color: yellow;
    }

   .blur {
      -webkit-filter: blur(5px); 
      -moz-filter: blur(5px); 
      -o-filter: blur(5px); 
      -ms-filter: blur(5px); 
      filter: blur(5px); 
   }
   
   .footer {
       bottom:0;
       width:100%;
       height: 100%;   
       background-color: yellow;
   }

   .floor {
       background-color: #5e91f8;
       padding-top: 5px;
       padding-bottom: 100px;
       box-shadow: 0px 1px 10px #434e9a;
   }

   .form-signin {
	   margin-top: auto;
	   margin-bottom: auto;
   }

   .form-control {
	   font-size: 20px;
	   margin-bottom: 20px;
	   padding-top: 30px;
       padding-bottom: 30px;
   }

    @media all and (-ms-high-contrast:none)
    {
        *::-ms-backdrop, .form-control {
            font-size: 20px;
            margin-bottom: 20px;
            padding-top: 0;
            padding-bottom: 0;
            height: 60px;
        }
    }

	.form-heading {
		margin-top: 10%;
		color: white;
		text-align: center;
	}

	#login {
		margin-top: 30px;
		border: none;
		height: 59px;
		background-color: #5e91f8;
	}

    #msg {
        margin-top: 75px;
        margin-bottom: 30px;
    }

    #tool {
        margin-top: 20px;
    }
    /*#tool a {*/
    /*    color: white;*/
    /*}*/

</style>

<s:authorize access="isAuthenticated()">
	 <c:redirect url="/"/>
</s:authorize>

</head>
<body>
    <div class="floor">
        <div class="form-heading">
            <h1>Welcome back!</h1>
        </div>

        <div class="loginBody">
            <div id="msg"></div>
            <form action="<c:url value="/login"/>" method="POST" class="form-signin" >
                <p>
                    <label for="id" class="sr-only">Id</label>
                    <input name="id" class="form-control" type="text" placeholder="Id" required autofocus/>
                    <label for="password" class="sr-only">Password</label>
                    <input name="password" class="form-control" type="password" placeholder="Password" required/>
                </p>

                <input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" >
                <input type="submit" id="login" class="btn btn-lg btn-primary btn-block" value="Login"/>
            </form>
            <div id="tool">
                <a href="./joinMember" class="float-left">Sign up</a>
<%--                <a href="#" class="float-right">Find account</a>--%>
            </div>
        </div>
    </div>
    <c:if test="${null != param.error}">
        <script>
            var msg = document.getElementById('msg');
            msg.innerHTML = '<strong>Login failed. Please try again</strong>';
            msg.style.color = 'red';
            msg.style.marginTop = '30px';
            msg.style.marginBottom = '20px';
        </script>
    </c:if>
</body>
</html>