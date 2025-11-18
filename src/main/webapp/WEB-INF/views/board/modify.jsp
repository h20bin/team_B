<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 수정 - 체육시설 조회</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. 기본 설정 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; color: #212529; background-color: #fff; }
        a { text-decoration: none; color: inherit; transition: 0.2s; }
        
        /* 2. 헤더 (디자인 통일) */
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
            width: 100%; max-width: 800px; 
            padding: 40px 20px; 
            padding-bottom: 80px; 
        }
        
        h1 { 
            font-size: 32px; font-weight: 800; margin-bottom: 40px; 
            text-align: center; color: #212529; letter-spacing: -1px;
        }

        /* 4. 폼 디자인 (테이블 대신 블록 레이아웃 사용) */
        .form-group { margin-bottom: 25px; }
        
        .form-label {
            display: block; font-size: 15px; font-weight: 700; margin-bottom: 10px; color: #495057;
        }
        .form-label i { margin-right: 5px; color: #339af0; }

        /* 입력 필드 공통 스타일 */
        .form-input, .form-textarea {
            width: 100%; padding: 14px;
            border: 1px solid #dee2e6; border-radius: 8px;
            font-size: 16px; color: #212529;
            transition: 0.2s; outline: none; background-color: #fff;
        }
        
        .form-input:focus, .form-textarea:focus {
            border-color: #339af0; box-shadow: 0 0 0 3px rgba(51, 154, 240, 0.1);
        }

        .form-textarea { resize: none; line-height: 1.6; min-height: 300px; }

        /* 읽기 전용 필드 스타일 (작성자 등) */
        .form-input[readonly] {
            background-color: #f8f9fa; color: #868e96; border-color: #f1f3f5; cursor: not-allowed;
        }

        /* 5. 버튼 영역 */
        .btn-area {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 40px; padding-top: 20px; border-top: 1px solid #e9ecef;
        }
        
        .btn-right { display: flex; gap: 10px; }

        .btn {
            display: inline-flex; justify-content: center; align-items: center; gap: 6px;
            padding: 12px 24px; border-radius: 8px;
            font-size: 16px; font-weight: 700; cursor: pointer; border: none;
            transition: all 0.2s;
        }

        /* 목록 버튼 */
        .btn-list { background-color: #f1f3f5; color: #495057; }
        .btn-list:hover { background-color: #e9ecef; }

        /* 취소 버튼 */
        .btn-cancel { background-color: white; border: 1px solid #dee2e6; color: #495057; }
        .btn-cancel:hover { background-color: #f8f9fa; border-color: #adb5bd; }

        /* 저장(수정완료) 버튼 - 메인 강조 */
        .btn-save { 
            background: linear-gradient(135deg, #339af0 0%, #228be6 100%); 
            color: white; 
        }
        .btn-save:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 4px 10px rgba(34, 139, 230, 0.3); 
        }

    </style>
</head>
<body>

    <header>
        <div class="logo">
            <i class="fa-solid fa-dumbbell"></i> 체육시설 조회
        </div>
    </header>

    <div class="main-container">
        <h1>게시글 수정</h1>

        <form action="/board/modify" method="post">
            <input type="hidden" name="page" value="<c:out value='${cri.page}'/>">
            <input type="hidden" name="perPageNum" value="<c:out value='${cri.perPageNum}'/>">
            <input type="hidden" name="bno" value="<c:out value='${board.bno}'/>">

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-heading"></i> 제목</label>
                <input type="text" name="title" class="form-input" value="<c:out value='${board.title}'/>" placeholder="제목을 입력하세요">
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-user"></i> 작성자</label>
                <input type="text" name="writer" class="form-input" value="<c:out value='${board.writer}'/>" readonly>
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-align-left"></i> 내용</label>
                <textarea name="content" class="form-textarea" placeholder="내용을 입력하세요"><c:out value='${board.content}'/></textarea>
            </div>

            <div class="btn-area">
                <a href="/board/list?page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>" class="btn btn-list">
                    <i class="fa-solid fa-list"></i> 목록
                </a>

                <div class="btn-right">
                    <a href="/board/get?bno=<c:out value='${board.bno}'/>&page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>" class="btn btn-cancel">
                        취소
                    </a>
                    <button type="submit" class="btn btn-save">
                        <i class="fa-solid fa-check"></i> 수정 완료
                    </button>
                </div>
            </div>
        </form>

    </div>

</body>
</html>