<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        
        /* 서브 텍스트 스타일 삭제됨 */

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

        /* 로그인 버튼 */
        .btn-login {
            background: linear-gradient(135deg, #339af0 0%, #228be6 100%); 
            color: white; border: none;
        }
        .btn-login:hover {
            transform: translateY(-3px); 
            box-shadow: 0 8px 15px rgba(34, 139, 230, 0.3); 
        }

        /* 회원가입 버튼 */
        .btn-join {
            background-color: #fff;
            color: #495057;
            border: 2px solid #f1f3f5;
        }
        .btn-join:hover {
            background-color: #f8f9fa;
            border-color: #dee2e6;
            transform: translateY(-3px);
        }

        .btn i { font-size: 18px; }

    </style>
</head>
<body>
    <header>
        <div class="logo">
            <i class="fa-solid fa-dumbbell"></i> 체육시설 조회
        </div>
    </header>

    <div class="main">
        <h1>간편하게 예약하고</h1>
        <h1>하루를 시작하세요</h1>
        <div class="btn-group">
            <a href="/board/list" class="btn btn-login">
                <i class="fa-solid fa-arrow-right-to-bracket"></i> 로그인 하러가기
            </a>
            
            <a href="/member/register" class="btn btn-join">
                <i class="fa-regular fa-user"></i> 회원가입
            </a>
        </div>
    </div>
</body>
</html>