<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>체육시설 조회</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. 기본 설정 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; background-color: #fff; color: #212529; }
        a { text-decoration: none; color: inherit; }
        
        /* 2. 헤더 (중앙 정렬 유지) */
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

        /* 3. 메인 레이아웃 */
        .main { margin-top: 180px; text-align: center; width: 100%; max-width: 500px; padding: 20px; }
        
        h1 { 
            font-size: 42px; margin-bottom: 50px; font-weight: 800; line-height: 1.3; color: #212529; 
            letter-spacing: -1px;
        }
        
        /* 로그인 후 환영 문구 스타일 */
        .welcome-text { font-size: 24px; margin-bottom: 10px; color: #495057; font-weight: 600; }
        .user-name { color: #339af0; font-weight: 800; }

        /* 4. 버튼 디자인 */
        .btn-group {
            display: flex; flex-direction: column; gap: 15px;
            width: 100%; align-items: center;
        }

        .btn {
            display: flex; justify-content: center; align-items: center; gap: 10px;
            width: 100%; max-width: 380px; height: 60px;
            border-radius: 16px;
            font-size: 18px; font-weight: 700;
            cursor: pointer; transition: all 0.2s ease;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05); 
        }

        /* 주요 버튼 (로그인/입장) */
        .btn-primary {
            background: linear-gradient(135deg, #339af0 0%, #228be6 100%); 
            color: white; border: none;
        }
        .btn-primary:hover {
            transform: translateY(-3px); 
            box-shadow: 0 8px 15px rgba(34, 139, 230, 0.3); 
        }

        /* 보조 버튼 (회원가입/로그아웃) */
        .btn-secondary {
            background-color: #fff;
            color: #495057;
            border: 2px solid #f1f3f5;
        }
        .btn-secondary:hover {
            background-color: #f8f9fa;
            border-color: #dee2e6;
            transform: translateY(-3px);
        }
        
        /* 관리자 버튼 (보라색) */
        .btn-admin {
            background-color: #7950f2;
            color: white;
            border: none;
        }
        .btn-admin:hover {
        	background-color: #6741d9;
        	transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(121, 80, 242, 0.3);
        }

        .btn i { font-size: 18px; }

        /* 결과 메시지 박스 (성공) */
        .result-box {
            position: fixed;
            top: 80px; /* 헤더 아래 */
            left: 50%;
            transform: translateX(-50%);
            width: auto;
            max-width: 90%;
            padding: 12px 25px;
            border-radius: 10px;
            background-color: #28a745; /* 초록색 배경 */
            color: white;
            font-size: 16px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            z-index: 200;
            opacity: 0;
            animation: fade-in-out 4s ease-in-out forwards;
        }

        @keyframes fade-in-out {
            0% { opacity: 0; top: 60px; }
            20% { opacity: 1; top: 80px; }
            80% { opacity: 1; top: 80px; }
            100% { opacity: 0; top: 60px; }
        }

    </style>
</head>
<body>
    <header>
        <div class="logo">
            <i class="fa-solid fa-dumbbell"></i> 체육시설 조회
        </div>
    </header>
    
    <c:if test="${not empty result}">
        <div class="result-box">${result}</div>
    </c:if>

    <div class="main">
        
        <c:choose>
            
            <%-- 1. 로그인이 안 된 상태 (loginUser 세션이 비어있음) --%>
            <c:when test="${empty loginUser}">
                <h1>간편하게 예약하고<br>하루를 시작하세요</h1>
                <div class="btn-group">
                    <a href="/member/login" class="btn btn-primary">
                        <i class="fa-solid fa-arrow-right-to-bracket"></i> 로그인 하러가기
                    </a>
                    
                    <a href="/member/register" class="btn btn-secondary">
                        <i class="fa-regular fa-user"></i> 회원가입
                    </a>
                </div>
            </c:when>

            <%-- 2. 로그인 된 상태 (loginUser 세션이 존재함) --%>
            <c:otherwise>
                <p class="welcome-text">반갑습니다, <span class="user-name">${loginUser.name}</span>님!</p>
                <h1>오늘도 힘내세요!</h1>
                
                <div class="btn-group">
                    <a href="/board/list" class="btn btn-primary">
                        <i class="fa-solid fa-list-check"></i> 시설 조회하러 가기
                    </a>
                    
                    <sec:authorize access="hasRole('ADMIN')">
	                    <a href="/admin/main" class="btn btn-admin">
	                        <i class="fa-solid fa-user-shield"></i> 관리자 페이지
	                    </a>
                    </sec:authorize>
                    
                    <a href="/member/logout" class="btn btn-secondary">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> 로그아웃
                    </a>
                </div>
            </c:otherwise>
            
        </c:choose>

    </div>
</body>
</html>