<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>체육시설 조회 - 게시판</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. 기본 및 폰트 설정 (메인 페이지와 동일) */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; color: #212529; background-color: #fff; }
        a { text-decoration: none; color: inherit; }
        
        /* 2. 헤더 디자인 (메인 페이지와 동일하게 중앙 정렬) */
        header { 
            width: 100%; height: 64px; 
            display: flex; justify-content: center; align-items: center; 
            position: fixed; top: 0; left: 0; background: white; 
            z-index: 100; border-bottom: 1px solid #f1f3f5; 
        }
        .logo { color: #212529; font-size: 22px; font-weight: 800; display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; }
        .logo i { color: #339af0; font-size: 24px; }

        /* 3. 게시판 컨테이너 */
        .main-container { margin-top: 120px; width: 100%; max-width: 900px; padding: 0 20px; padding-bottom: 60px; }
        
        h1 { font-size: 32px; font-weight: 700; margin-bottom: 30px; text-align: center; color: #212529; }

        /* 4. 테이블 디자인 */
        .board-table { width: 100%; border-collapse: collapse; margin-bottom: 40px; font-size: 15px; }
        
        .board-table th { 
            padding: 16px 10px; 
            border-top: 1px solid #212529; 
            border-bottom: 1px solid #212529; 
            background-color: #f8f9fa; 
            font-weight: 600; 
            text-align: center; 
        }
        
        .board-table td { 
            padding: 16px 10px; 
            border-bottom: 1px solid #f1f3f5; 
            text-align: center; 
            color: #495057; 
        }
        
        /* 제목 열은 왼쪽 정렬 */
        .board-table td.title-col { text-align: left; padding-left: 20px; }
        .board-table td.title-col a { color: #212529; font-weight: 500; transition: 0.2s; }
        .board-table td.title-col a:hover { color: #339af0; text-decoration: underline; }
        
        .board-table tr:hover td { background-color: #f8f9fa; }

        /* 5. 페이지네이션 디자인 */
        .pagination { display: flex; justify-content: center; gap: 6px; margin-bottom: 40px; }
        
        .pagination a {
            display: flex; justify-content: center; align-items: center;
            min-width: 36px; height: 36px; padding: 0 10px;
            border: 1px solid #dee2e6; border-radius: 6px;
            color: #495057; font-size: 14px; 
            transition: 0.2s; background-color: #fff;
        }
        
        .pagination a:hover { background-color: #f1f3f5; }
        
        .pagination a.active {
            background-color: #339af0; /* 메인 포인트 컬러 사용 */
            border-color: #339af0; 
            color: white; 
            font-weight: 700;
        }

        /* 6. 글쓰기 버튼 디자인 */
        .btn-wrap { display: flex; justify-content: flex-end; }
        .btn-write {
            background-color: #339af0; 
            color: white; 
            padding: 12px 24px; 
            border-radius: 6px; 
            font-weight: 700; font-size: 15px; 
            transition: 0.2s;
        }
        .btn-write:hover { background-color: #228be6; }
        
        /* 사용자 정보 패널 */
        .user-panel {
        	display: flex;
        	justify-content: flex-end;
        	align-items: center;
        	gap: 15px;
        	margin-bottom: 25px;
        	padding: 15px;
        	background-color: #f8f9fa;
        	border-radius: 8px;
        }
        .user-panel .user-info { font-size: 15px; font-weight: 700; color: #495057; }
        .user-panel .user-info .user-name { color: #339af0; }
        
        .user-panel .btn {
        	padding: 8px 15px;
        	font-size: 14px;
        	border-radius: 6px;
        	border: 1px solid #dee2e6;
        	background-color: #fff;
        }
        .user-panel .btn-admin { border-color: #be4bdb; color: #be4bdb; }
        .user-panel .btn-logout { border-color: #fa5252; color: #fa5252; }


    </style>
</head>
<body>

    <header>
        <div class="logo">
            <a href="/" style="display: flex; align-items: center;"><i class="fa-solid fa-dumbbell"></i> 체육시설 조회</a>
        </div>
    </header>

    <div class="main-container">
    
    	<!-- 사용자 정보 패널 -->
    	<div class="user-panel">
    		<c:choose>
    			<c:when test="${empty loginUser}">
    				<div class="user-info">로그인하고 더 많은 기능을 이용해보세요.</div>
    				<a href="/member/login" class="btn">로그인</a>
    				<a href="/member/register" class="btn">회원가입</a>
    			</c:when>
    			<c:otherwise>
    				    					<div class="user-info">
    				    						<span class="user-name">${loginUser.name}</span>님, 환영합니다!
    				    						<br>
    				    						<small>보유 권한: ${loginUser.auth}</small>
    				    					</div>    				<sec:authorize access="hasRole('ADMIN')">
    					<a href="/admin/main" class="btn btn-admin">관리자 페이지</a>
    				</sec:authorize>
    				<a href="/member/logout" class="btn btn-logout">로그아웃</a>
    			</c:otherwise>
    		</c:choose>
    	</div>
    
        <h1>이용 후기 게시판</h1> 
        <table class="board-table">
            <colgroup>
                <col style="width: 10%;">
                <col style="width: 50%;">
                <col style="width: 15%;">
                <col style="width: 15%;">
                <col style="width: 10%;">
            </colgroup>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="board">
                    <tr>
                        <td><c:out value="${board.bno}"/></td>
                        <td class="title-col">
                            <a href='/board/get?bno=<c:out value="${board.bno}"/>&page=<c:out value="${pageMaker.cri.page}"/>&perPageNum=<c:out value="${pageMaker.cri.perPageNum}"/>'>
                                <c:out value="${board.title}"/>
                            </a>
                        </td>
                        <td><c:out value="${board.writer}"/></td>
                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                        <td><c:out value="${board.viewcnt}"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="pagination">
            <c:if test="${pageMaker.prev}">
                <a href="/board/list?page=${pageMaker.startPage - 1}"><i class="fa-solid fa-chevron-left"></i></a>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <a href="/board/list?page=${num}" class="${pageMaker.cri.page == num ? 'active' : ''}">${num}</a>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <a href="/board/list?page=${pageMaker.endPage + 1}"><i class="fa-solid fa-chevron-right"></i></a>
            </c:if>
        </div>

    </div>

    <script>
        var result = '${result}';
        if (result && !isNaN(result)) {
            alert(result + "번 글이 등록되었습니다.");
        }
    </script>

</body>
</html>