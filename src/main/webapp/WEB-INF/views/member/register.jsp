<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>회원가입</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #f2f2f2;
            font-family: "Noto Sans KR", sans-serif;
        }
        .container {
            width: 400px;
            background: white;
            padding: 30px;
            margin: 80px auto;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
        }
        label {
            display: inline-block;
            width: 80px;
            font-weight: bold;
        }
        input {
            width: 250px;
            padding: 8px;
            margin-bottom: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            outline: none;
        }
        input:focus {
            border-color: #4a76f7;
        }
        button {
            width: 100%;
            padding: 10px;
            background: #4a76f7;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background: #3a5fd0;
        }
        .error {
            text-align: center;
            color: red;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .row {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>회원가입</h2>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <form action="<c:url value='/member/register' />" method="post">
        <div class="row">
            <label>아이디</label>
            <input type="text" name="userid" required/>
        </div>
        <div class="row">
            <label>비밀번호</label>
            <input type="password" name="password" required/>
        </div>
        <div class="row">
            <label>이메일</label>
            <input type="email" name="email" required/>
        </div>
        <div class="row">
            <label>이름</label>
            <input type="text" name="name" required/>
        </div>

        <button type="submit">회원가입</button>
    </form>
</div>

</body>
</html>
