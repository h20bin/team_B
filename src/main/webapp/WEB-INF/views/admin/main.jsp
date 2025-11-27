<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지 - 게시물 관리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; background-color: #f8f9fa; color: #212529; }
        a { text-decoration: none; color: inherit; }
        
        header { 
            width: 100%; height: 64px; display: flex; justify-content: center; align-items: center; 
            position: fixed; top: 0; left: 0; background: #fff; z-index: 100; border-bottom: 1px solid #dee2e6;
        }
        .logo { color: #212529; font-size: 22px; font-weight: 800; display: flex; align-items: center; gap: 8px; }
        .logo i { color: #7950f2; }

        .main-container { margin-top: 100px; width: 100%; max-width: 1000px; padding: 40px 20px; background-color: #fff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .main-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .main-header h2 { font-size: 24px; font-weight: 800; }
        .main-header .btn-group { display: flex; gap: 10px; }

        .btn { display: inline-flex; justify-content: center; align-items: center; gap: 6px; padding: 10px 18px; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; border: none; transition: all 0.2s; }
        .btn-home { background-color: #f1f3f5; color: #495057; }
        .btn-home:hover { background-color: #e9ecef; }
        .btn-primary { background-color: #7950f2; color: white; }
        .btn-primary:hover { background-color: #6741d9; }
        .btn-modify { background-color: #e7f5ff; color: #339af0; font-size: 13px; padding: 8px 12px; }
        .btn-modify:hover { background-color: #d0ebff; }
        .btn-remove { background-color: #fff5f5; color: #fa5252; font-size: 13px; padding: 8px 12px; }
        .btn-remove:hover { background-color: #ffe3e3; }

        .board-table { width: 100%; border-collapse: collapse; text-align: center; }
        .board-table th, .board-table td { padding: 15px 10px; border-bottom: 1px solid #f1f3f5; }
        .board-table th { background-color: #f8f9fa; font-size: 14px; color: #495057; font-weight: 700; }
        .board-table td { font-size: 15px; color: #495057; }
        .board-table .col-bno { width: 8%; }
        .board-table .col-title { text-align: left; width: 45%; }
        .board-table .col-title a:hover { text-decoration: underline; }
        .board-table .col-writer { width: 12%; }
        .board-table .col-date { width: 15%; }
        .board-table .col-actions { width: 20%; }
        
        .pagination { display: flex; justify-content: center; margin-top: 40px; gap: 5px; }
        .pagination a, .pagination span { display: inline-block; padding: 10px 15px; border-radius: 8px; color: #495057; font-weight: 700; font-size: 14px; }
        .pagination a { background-color: #f1f3f5; }
        .pagination a:hover { background-color: #e9ecef; }
        .pagination .active { background-color: #7950f2; color: white; }
    </style>
</head>
<body>
    <header>
        <div class="logo"><i class="fa-solid fa-user-shield"></i> 관리자 페이지</div>
    </header>

    <div class="main-container">
        <div class="main-header">
            <h2>게시물 관리</h2>
            <div class="btn-group">
                <a href="/board/register" class="btn btn-primary"><i class="fa-solid fa-pen"></i> 새 게시물 작성</a>
                <a href="/" class="btn btn-home"><i class="fa-solid fa-house"></i> 메인으로</a>
            </div>
        </div>

        <table class="board-table">
            <thead>
                <tr>
                    <th class="col-bno">번호</th>
                    <th class="col-title">제목</th>
                    <th class="col-writer">작성자</th>
                    <th class="col-date">작성일</th>
                    <th class="col-actions">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="board">
                    <tr>
                        <td><c:out value="${board.bno}" /></td>
                        <td class="col-title">
                            <a href="/board/get?bno=${board.bno}&page=${pageMaker.cri.page}&perPageNum=${pageMaker.cri.perPageNum}">
                                <c:out value="${board.title}" />
                            </a>
                        </td>
                        <td><c:out value="${board.writer}" /></td>
                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                        <td>
                            <a href="/board/modify?bno=${board.bno}" class="btn btn-modify">수정</a>
                            <form action="/board/remove" method="post" style="display:inline;" onsubmit="return confirm('정말로 이 게시글을 삭제하시겠습니까?');">
                            	<input type="hidden" name="bno" value="${board.bno}">
                            	<input type="hidden" name="from" value="admin"> <!-- 추가된 파라미터 -->
                            	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            	<button type="submit" class="btn btn-remove">삭제</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <!-- Pagination -->
        <div class="pagination">
            <c:if test="${pageMaker.prev}">
                <a href="/admin/main?page=${pageMaker.startPage - 1}&perPageNum=${pageMaker.cri.perPageNum}">&laquo;</a>
            </c:if>
            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <a href="/admin/main?page=${num}&perPageNum=${pageMaker.cri.perPageNum}" class="${pageMaker.cri.page == num ? 'active' : ''}">${num}</a>
            </c:forEach>
            <c:if test="${pageMaker.next}">
                <a href="/admin/main?page=${pageMaker.endPage + 1}&perPageNum=${pageMaker.cri.perPageNum}">&raquo;</a>
            </c:if>
        </div>
    </div>
</body>
</html>
