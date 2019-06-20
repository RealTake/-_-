<%--
  Created by IntelliJ IDEA.
  User: RealTake
  Date: 2019-06-15
  Time: 오후 4:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form name="fileForm" action="/fileUpload.do?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
    <input multiple="multiple" type="file" name="fileList" />
    <input type="submit" value="전송" />
</form>
</body>
</html>
