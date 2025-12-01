<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예약하기</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { background-color: #f8f9fa; display: flex; justify-content: center; align-items: flex-start; min-height: 100vh; }
        .container {
            width: 100%;
            max-width: 480px;
            margin-top: 80px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.05);
            padding: 32px 40px 40px;
        }
        .title {
            font-size: 26px;
            font-weight: 800;
            margin-bottom: 28px;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #495057;
        }
        .input {
            width: 100%;
            height: 40px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 0 10px;
            font-size: 14px;
            outline: none;
        }
        .input:focus {
            border-color: #339af0;
            box-shadow: 0 0 0 1px rgba(51,154,240,0.1);
        }
        .btn-area {
            margin-top: 24px;
            text-align: right;
        }
        .btn {
            border: none;
            border-radius: 8px;
            padding: 10px 22px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
        }
        .btn-primary {
            background-color: #339af0;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #228be6;
        }
        .msg {
            margin-bottom: 10px;
            font-size: 13px;
            color: #fa5252;
        }
    </style>
</head>
<body>

<div class="container">
    <h1 class="title">예약하기</h1>

    <!-- 오류 메시지 -->
    <c:if test="${not empty msg}">
        <div class="msg"><c:out value="${msg}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/reservation/do" method="post">
        <!-- 게시글 번호 -->
        <input type="hidden" name="bno" value="${bno}" />

        <div class="form-group">
            <label class="label" for="resDate">예약 날짜</label>
            <input type="date" id="resDate" name="resDate" class="input" required>
        </div>

        <div class="form-group">
            <label class="label" for="startTime">시작 시간</label>
            <input type="time" id="startTime" name="startTime" class="input" required>
        </div>

        <div class="form-group">
            <label class="label" for="endTime">종료 시간</label>
            <input type="time" id="endTime" name="endTime" class="input" required>
        </div>

        <div class="btn-area">
            <button type="submit" class="btn btn-primary">예약하기</button>
        </div>
    </form>
</div>

</body>
</html>
