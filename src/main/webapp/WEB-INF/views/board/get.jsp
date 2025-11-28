<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>물품 상세 - 체육시설 조회</title>
    <sec:csrfMetaTags />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --main-color: #339af0; --star-active-color: #fcc419; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { display: flex; flex-direction: column; align-items: center; color: #212529; background-color: #f8f9fa; }
        a { text-decoration: none; color: inherit; transition: 0.2s; }
        button { font-family: inherit; }

        header { width: 100%; height: 64px; display: flex; justify-content: center; align-items: center; position: fixed; top: 0; left: 0; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); z-index: 1000; border-bottom: 1px solid #f1f3f5; }
        .logo { color: #212529; font-size: 22px; font-weight: 800; display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; }
        .logo i { color: var(--main-color); }

        .page-container { margin-top: 80px; width: 100%; max-width: 1100px; padding: 20px; }
        .main-content { display: flex; gap: 60px; justify-content: center; background-color: #fff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .left-column { width: 500px; flex: 0 0 500px; display: flex; flex-direction: column; gap: 15px; }
        .info-section { flex: 1; display: flex; flex-direction: column; padding-top: 10px; min-width: 0; }

        .image-section { width: 100%; height: 500px; border-radius: 16px; overflow: hidden; background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; border: 1px solid #e9ecef; }
        .image-section img { width: 100%; height: 100%; object-fit: cover; cursor: zoom-in; }
        .no-image { color: #adb5bd; font-size: 16px; display: flex; flex-direction: column; align-items: center; gap: 10px; }
        .thumbnail-gallery { display: flex; gap: 10px; flex-wrap: wrap; }
        .thumbnail-item { width: 80px; height: 80px; border-radius: 8px; overflow: hidden; cursor: pointer; border: 2px solid transparent; transition: border-color 0.2s; }
        .thumbnail-item:hover { border-color: var(--main-color); }
        .thumbnail-item.active { border-color: var(--main-color); box-shadow: 0 0 10px rgba(51, 154, 240, 0.5); }
        .thumbnail-item img { width: 100%; height: 100%; object-fit: cover; }

        .profile-section { display: flex; align-items: center; gap: 12px; padding-top: 10px; }
        .profile-icon { font-size: 46px; color: #dee2e6; }
        .profile-info { display: flex; flex-direction: column; justify-content: center; }
        .profile-name { font-size: 18px; font-weight: 700; color: #212529; }
        .title { font-size: 32px; font-weight: 800; line-height: 1.3; margin-bottom: 15px; }
        .meta-info { font-size: 14px; color: #868e96; margin-bottom: 30px; display:flex; align-items: center; gap: 8px; }
        .content-text { font-size: 18px; line-height: 1.6; margin-bottom: 40px; white-space: pre-wrap; min-height: 100px; }
        .location-text { font-size: 16px; font-weight: 600; display: flex; align-items: center; gap: 8px; margin-bottom: 40px; }
        .location-text i { color: var(--main-color); }

        .btn-area { margin-top: auto; display: flex; justify-content: flex-end; }
        .btn-list { background-color: var(--main-color); color: white; padding: 12px 24px; border-radius: 8px; font-size: 16px; font-weight: 700; transition: 0.2s; border: none; cursor: pointer; }
        .btn-list:hover { background-color: #228be6; box-shadow: 0 4px 10px rgba(51, 154, 240, 0.3); }

        .modal { display: none; position: fixed; z-index: 1001; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.85); backdrop-filter: blur(5px); }
        .modal-content { margin: auto; display: block; max-width: 90%; max-height: 90%; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
        .close-modal { position: absolute; top: 20px; right: 35px; color: #f1f1f1; font-size: 40px; font-weight: bold; cursor: pointer; }

        .review-section { margin-top: 40px; background-color: #fff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .review-title { font-size: 24px; font-weight: 800; margin-bottom: 30px; }
    </style>
</head>
<body>

<header>
    <div class="logo">
        <a href="/"> <i class="fa-solid fa-dumbbell"></i> 체육시설 조회 </a>
    </div>
</header>

<div class="page-container">
    <div class="main-content">
        <div class="left-column">
            <div class="image-section" id="mainImageSection">
                <div class="no-image">
                    <i class="fa-solid fa-spinner fa-spin fa-2x"></i><span>이미지 로딩중...</span>
                </div>
            </div>
            <div class="thumbnail-gallery" id="thumbnailGallery"></div>
            <div class="profile-section">
                <i class="fa-solid fa-circle-user profile-icon"></i>
                <div class="profile-info">
                    <span class="profile-name"><c:out value='${board.writer}'/></span>
                </div>
            </div>
        </div>

        <div class="info-section">
            <h1 class="title"><c:out value='${board.title}'/></h1>
            <div class="meta-info">
                <span><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></span>
                <span>·</span> <span>조회 <c:out value='${board.viewcnt}'/></span>
            </div>
            <div class="content-text"><c:out value='${board.content}'/></div>
            <div class="location-text">
                <i class="fa-solid fa-location-dot"></i>
                <c:out value='${board.location}' default="(위치 정보 없음)"/>
            </div>

            <div class="btn-area">
                <a href="/board/list?page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>"
                   class="btn-list">목록으로</a>

                <!-- 예약하기 버튼 -->
                <a href="${pageContext.request.contextPath}/reservation/form?bno=${board.bno}"
                   class="btn-list" style="margin-left:10px; background:#51cf66;">
                    예약하기
                </a>
            </div>
        </div>
    </div>

    <!-- 기존 리뷰 영역 그대로 유지 -->
    <div class="review-section"
         data-bno="<c:out value='${board.bno}'/>"
         data-login-user="<sec:authorize access='isAuthenticated()'><sec:authentication property='principal.username'/></sec:authorize>"
         data-csrf-header="${_csrf.headerName}"
         data-csrf-token="${_csrf.token}">
        <h3 class="review-title">이용 후기</h3>
    </div>
</div>

</body>
</html>
