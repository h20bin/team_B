<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예약하기</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
            background:#f8f9fa;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            background:#fff;
            padding:30px;
            border-radius:12px;
            box-shadow:0 4px 15px rgba(0,0,0,0.08);
        }
        h2 { margin-bottom:20px; }
        label { display:block; margin-top:10px; margin-bottom:4px; }
        input[type="date"],
        input[type="time"] {
            width:100%;
            padding:8px;
            box-sizing:border-box;
        }
        .btn-area {
            margin-top:20px;
            text-align:right;
        }
        button {
            padding:10px 20px;
            border-radius:8px;
            border:none;
            background:#339af0;
            color:#fff;
            font-weight:700;
            cursor:pointer;
        }
        button:hover { background:#228be6; }
    </style>
</head>
<body>
<div class="container">
    <h2>예약하기</h2>

    <form action="${pageContext.request.contextPath}/reservation/do" method="post">
        <sec:csrfInput/>

        <!-- 어떤 시설(게시글) 예약인지 -->
        <input type="hidden" name="bno" value="${bno}" />

        <label>예약 날짜</label>
        <input type="date" name="resDate" required />

        <label>시작 시간</label>
        <input type="time" name="startTime" required />

        <label>종료 시간</label>
        <input type="time" name="endTime" required />

        <div class="btn-area">
            <button type="submit">예약하기</button>
        </div>
    </form>
</div>
</body>
</html>
