<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세 - 체육시설 조회</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. 기본 설정 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; color: #212529; background-color: #fff; }
        a { text-decoration: none; color: inherit; transition: 0.2s; }
        
        /* 2. 헤더 (이전과 동일) */
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

        /* 3. 메인 컨테이너 */
        .main-container { 
            margin-top: 100px; 
            width: 100%; max-width: 800px; /* 읽기 편한 너비 */
            padding: 40px 20px; 
            padding-bottom: 80px; 
        }

        /* 4. 게시글 헤더 디자인 */
        .post-header {
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 20px; margin-bottom: 30px;
        }
        .post-category {
            font-size: 14px; color: #339af0; font-weight: 700; margin-bottom: 10px;
        }
        .post-title {
            font-size: 28px; font-weight: 800; color: #212529; margin-bottom: 20px; line-height: 1.4;
        }
        .post-meta {
            display: flex; gap: 15px; color: #868e96; font-size: 14px; align-items: center;
        }
        .post-meta span { display: flex; align-items: center; gap: 5px; }
        
        /* 5. 본문 디자인 (textarea 스타일링) */
        .post-content { margin-bottom: 50px; }
        .content-area {
            width: 100%; 
            min-height: 400px; /* 충분한 높이 */
            padding: 20px;
            border: 1px solid #f1f3f5;
            border-radius: 12px;
            background-color: #f8f9fa;
            font-size: 16px; line-height: 1.6; color: #495057;
            resize: none; /* 크기 조절 막기 */
            outline: none;
        }

        /* 6. 버튼 그룹 디자인 */
        .btn-area {
            display: flex; justify-content: space-between; align-items: center;
            padding-top: 20px; border-top: 1px solid #e9ecef;
        }
        
        .btn-right { display: flex; gap: 10px; }

        .btn {
            display: inline-flex; justify-content: center; align-items: center; gap: 6px;
            padding: 12px 20px; border-radius: 8px;
            font-size: 15px; font-weight: 700; cursor: pointer; border: none;
            transition: all 0.2s;
        }

        /* 목록 버튼 (회색) */
        .btn-list { background-color: #f1f3f5; color: #495057; }
        .btn-list:hover { background-color: #e9ecef; }

        /* 수정 버튼 (파란 그라데이션) */
        .btn-modify { background: linear-gradient(135deg, #339af0 0%, #228be6 100%); color: white; }
        .btn-modify:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(34, 139, 230, 0.3); }

        /* 삭제 버튼 (붉은색) */
        .btn-remove { background-color: #ffe3e3; color: #fa5252; }
        .btn-remove:hover { background-color: #ffc9c9; }

    </style>
</head>
<body>

    <header>
        <div class="logo">
            <i class="fa-solid fa-dumbbell"></i> 체육시설 조회
        </div>
    </header>

    <div class="main-container">
        
        <div class="post-header">
            <div class="post-category">NO. <c:out value="${board.bno}"/></div> <h1 class="post-title"><c:out value="${board.title}"/></h1>
            
            <div class="post-meta">
                <span><i class="fa-regular fa-user"></i> <c:out value="${board.writer}"/></span>
                <span style="color: #dee2e6;">|</span>
                <span><i class="fa-regular fa-calendar"></i> <fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></span>
            </div>
        </div>

        <div class="post-content">
            <textarea class="content-area" readonly><c:out value="${board.content}"/></textarea>
        </div>

        <div class="btn-area">
            <a href="/board/list?page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>" class="btn btn-list">
                <i class="fa-solid fa-list"></i> 목록
            </a>

            <div class="btn-right">
                <a href="/board/modify?bno=<c:out value='${board.bno}'/>&page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>" class="btn btn-modify">
                    <i class="fa-solid fa-pen-to-square"></i> 수정
                </a>
                
                <button id="removeBtn" class="btn btn-remove">
                    <i class="fa-solid fa-trash"></i> 삭제
                </button>
            </div>
        </div>

        <form id="removeForm" action="/board/remove" method="post">
            <input type="hidden" name="bno" value="<c:out value='${board.bno}'/>">
            <input type="hidden" name="page" value="<c:out value='${cri.page}'/>">
            <input type="hidden" name="perPageNum" value="<c:out value='${cri.perPageNum}'/>">
        </form>

    </div>

    <script>
        document.getElementById("removeBtn").addEventListener("click", function(){
            if(confirm("정말로 이 게시글을 삭제하시겠습니까?")){
                document.getElementById("removeForm").submit();
            }
        });
    </script>

</body>
</html>