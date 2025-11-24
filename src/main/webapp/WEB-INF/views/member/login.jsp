<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - 체육시설 조회</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* home.jsp와 동일한 기본 스타일 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; background-color: #fff; color: #212529; }
        a { text-decoration: none; color: inherit; }
        
        /* 헤더 스타일 */
        header { 
            width: 100%; height: 64px; 
            display: flex; justify-content: center; align-items: center; 
            position: fixed; top: 0; left: 0; 
            background: rgba(255, 255, 255, 0.95); 
            backdrop-filter: blur(10px); 
            z-index: 100; 
            border-bottom: 1px solid #f1f3f5; 
        }
        .logo { color: #212529; font-size: 22px; font-weight: 800; display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; }
        .logo i { color: #339af0; font-size: 24px; } 

        /* 로그인 폼 레이아웃 */
        .main { margin-top: 160px; text-align: center; width: 100%; max-width: 400px; padding: 20px; }
        
        h2 { font-size: 32px; margin-bottom: 40px; font-weight: 800; color: #212529; }
        
        .login-form { display: flex; flex-direction: column; gap: 15px; width: 100%; }
        
        /* 입력창 디자인 */
        .input-group { position: relative; width: 100%; }
        .input-group input {
            width: 100%; height: 55px;
            padding: 0 15px 0 45px; /* 아이콘 공간 확보 */
            border: 2px solid #f1f3f5;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.2s;
            outline: none;
        }
        .input-group input:focus { border-color: #339af0; }
        .input-group i {
            position: absolute; left: 15px; top: 50%; transform: translateY(-50%);
            color: #adb5bd; font-size: 18px;
        }

        /* 버튼 디자인 (home.jsp 스타일 계승) */
        .btn-login {
            width: 100%; height: 55px;
            background: linear-gradient(135deg, #339af0 0%, #228be6 100%);
            color: white; border: none;
            border-radius: 12px;
            font-size: 18px; font-weight: 700;
            cursor: pointer; margin-top: 10px;
            transition: transform 0.2s;
        }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(34, 139, 230, 0.3); }
        
        .links { margin-top: 20px; font-size: 14px; color: #868e96; display: flex; gap: 15px; justify-content: center; }
        .links a:hover { text-decoration: underline; color: #339af0; }
    </style>
</head>
<body>
    
    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

    <header>
        <div class="logo">
            <a href="/"> <i class="fa-solid fa-dumbbell"></i> 체육시설 조회 </a>
        </div>
    </header>

    <div class="main">
        <h2>로그인</h2>
        
        <form action="/login" method="post" class="login-form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="input-group">
                <i class="fa-regular fa-user"></i>
                <input type="text" name="userid" placeholder="아이디를 입력하세요" required autofocus>
            </div>

            <div class="input-group">
                <i class="fa-solid fa-lock"></i>
                <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>

            <button type="submit" class="btn-login">로그인</button>
        </form>

        <div class="links">
            <a href="/member/register">회원가입</a>
            <span>|</span>
            <a href="/">홈으로 돌아가기</a>
        </div>
    </div>
</body>
</html>