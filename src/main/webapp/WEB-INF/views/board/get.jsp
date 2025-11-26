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
        .review-header { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #f1f3f5; flex-wrap: wrap; }
        .review-summary { display: flex; align-items: center; }
        .review-summary .stars { font-size: 24px; color: var(--star-active-color); }
        .review-summary .avg-rating { font-size: 24px; font-weight: 800; margin-left: 8px; }
        .review-summary .review-count { font-size: 16px; color: #868e96; margin-left: 12px; }
        .review-write-btn-area { margin-left: auto; }
        .btn-write-review { background-color: var(--main-color); color: white; border: none; padding: 12px 24px; border-radius: 8px; font-weight: 700; cursor: pointer; }

        .rating-distribution { flex: 1; min-width: 250px; max-width: 300px; display: flex; flex-direction: column; gap: 4px; }
        .dist-row { display: flex; align-items: center; gap: 8px; }
        .dist-row .star-label { font-size: 13px; font-weight: 600; color: #868e96; width: 30px; }
        .dist-bar-bg { flex-grow: 1; height: 8px; background-color: #f1f3f5; border-radius: 4px; overflow: hidden; }
        .dist-bar { height: 100%; background-color: var(--star-active-color); border-radius: 4px; width: 0%; transition: width 0.5s; }
        .dist-row .count { font-size: 13px; font-weight: 600; color: #868e96; width: 30px; text-align: right; }

        .review-form-container { display: none; padding: 25px; background-color: #f8f9fa; border-radius: 8px; margin-bottom: 40px; }
        .star-input-area { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
        .star-input-area > span { font-weight: 700; color: #212529; }
        .star-input-area .stars i { font-size: 28px; color: #e9ecef; cursor: pointer; }
        .star-input-area i.hover,
		.star-input-area i.fa-solid { color: #fcc419 !important; /* 노란색 강제 적용 */ }
        .review-form-container textarea { width: 100%; min-height: 80px; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px; resize: vertical; }
        .review-form-actions { text-align: right; margin-top: 10px; display: flex; gap: 8px; justify-content: flex-end; }
        .review-btn { padding: 10px 20px; border-radius: 8px; font-size: 15px; font-weight: 700; cursor: pointer; border: none; }
        .review-btn.cancel { background-color: #f1f3f5; color: #495057; }
        .review-btn.submit { background-color: var(--main-color); color: white; }

        .review-list { list-style: none; }
        .review-item { padding: 25px 0; border-bottom: 1px solid #f1f3f5; }
        .review-item:last-child { border-bottom: none; }
        .review-item-header { display: flex; align-items: center; margin-bottom: 10px; gap: 10px; }
        .review-item .stars { font-size: 16px; color: var(--star-active-color); }
        .review-item-writer { font-weight: 700; font-size: 15px; }
        .review-item-date { margin-left: auto; font-size: 13px; color: #868e96; }
        .review-item-content { font-size: 16px; line-height: 1.6; color: #495057; padding-left: 5px; }
        .review-item-actions { margin-left: 15px; }
        .action-btn { background: none; border: none; cursor: pointer; color: #adb5bd; font-size: 13px; }
        .action-btn:hover { color: #fa5252; }
    </style>
</head>
<body>

    <header>
        <div class="logo"><a href="/"> <i class="fa-solid fa-dumbbell"></i> 체육시설 조회 </a></div>
    </header>

    <div class="page-container">
        <div class="main-content">
            <div class="left-column">
                <div class="image-section" id="mainImageSection"><div class="no-image"><i class="fa-solid fa-spinner fa-spin fa-2x"></i><span>이미지 로딩중...</span></div></div>
                <div class="thumbnail-gallery" id="thumbnailGallery"></div>
                <div class="profile-section">
                    <i class="fa-solid fa-circle-user profile-icon"></i>
                    <div class="profile-info"><span class="profile-name"><c:out value='${board.writer}'/></span></div>
                </div>
            </div>
            <div class="info-section">
                <h1 class="title"><c:out value='${board.title}'/></h1>
                <div class="meta-info">
                    <span><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></span>
                    <span>·</span> <span>조회 <c:out value='${board.viewcnt}'/></span>
                </div>
                <div class="content-text"><c:out value='${board.content}'/></div>
                <div class="location-text"><i class="fa-solid fa-location-dot"></i><c:out value='${board.location}' default="(위치 정보 없음)"/></div>
                <div class="btn-area">
                    <a href="/board/list?page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>" class="btn-list">목록으로</a>
                </div>
            </div>
        </div>

        <div class="review-section"
             data-bno="<c:out value='${board.bno}'/>"
             data-login-user="<sec:authorize access='isAuthenticated()'><sec:authentication property='principal.username'/></sec:authorize>"
             data-csrf-header="${_csrf.headerName}"
             data-csrf-token="${_csrf.token}">
            <h3 class="review-title">이용 후기</h3>
            <div class="review-header">
                <div class="review-summary">
                    <span class="stars" id="summaryStars"></span>
                    <span class="avg-rating" id="summaryAvg">0.0</span>
                    <span class="review-count" id="summaryCount">(0)</span>
                </div>
                <div class="rating-distribution" id="ratingDistribution"></div>
                <div class="review-write-btn-area">
                    <sec:authorize access="isAuthenticated()">
                        <button class="btn-write-review" id="showReviewFormBtn"><i class="fa-solid fa-pen-to-square"></i> 이용평 작성</button>
                    </sec:authorize>
                </div>
            </div>
            <div class="review-form-container" id="reviewFormContainer">
                <div class="star-input-area" data-rating="0">
                    <span>별점 선택</span>
                    <div class="stars">
                        <i class="fa-regular fa-star" data-value="1"></i><i class="fa-regular fa-star" data-value="2"></i><i class="fa-regular fa-star" data-value="3"></i><i class="fa-regular fa-star" data-value="4"></i><i class="fa-regular fa-star" data-value="5"></i>
                    </div>
                </div>
                <textarea id="reviewContent" class="review-textarea" placeholder="솔직한 이용 후기를 남겨주세요."></textarea>
                <div class="review-form-actions">
                    <button type="button" class="review-btn cancel" id="cancelReviewBtn">취소</button>
                    <button type="button" class="review-btn submit" id="addReviewBtn">등록</button>
                </div>
            </div>
            <ul class="review-list" id="reviewList"></ul>
        </div>
    </div>

    <div id="imageModal" class="modal">
      <span class="close-modal" id="closeModal">&times;</span>
      <img class="modal-content" id="modalImage">
    </div>

    <script>
    // --- 이미지 뷰어 로직 ---
    document.addEventListener("DOMContentLoaded", function() {
        const bnoValue = '<c:out value="${board.bno}"/>';
        const imageSection = document.getElementById("mainImageSection");
        const thumbnailGallery = document.getElementById("thumbnailGallery");
        const modal = document.getElementById('imageModal');
        const modalImage = document.getElementById('modalImage');
        const closeModalBtn = document.getElementById('closeModal');

        if (!imageSection) return;

        fetch('/board/getAttachList?bno=' + bnoValue)
            .then(r => r.ok ? r.json() : Promise.reject(new Error('Image list not found')))
            .then(setupImageViewer)
            .catch(err => {
                console.error("Image Viewer Error:", err);
                imageSection.innerHTML = '<div class="no-image"><i class="fa-regular fa-image fa-2x"></i><span>이미지가 없습니다.</span></div>';
            });

        function setupImageViewer(attachments) {
            if (!attachments || attachments.length === 0) {
                imageSection.innerHTML = '<div class="no-image"><i class="fa-regular fa-image fa-2x"></i><span>이미지가 없습니다.</span></div>';
                return;
            }
            imageSection.innerHTML = '';
            thumbnailGallery.innerHTML = '';

            attachments.forEach((attach, index) => {
                if (!attach || !attach.uploadPath) return;

                const uploadPath = attach.uploadPath.replace(/\\/g, "/");
                const thumbnailURL = '/board/display?fileName=' + encodeURIComponent(uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
                const originURL = '/board/display?fileName=' + encodeURIComponent(uploadPath + "/" + attach.uuid + "_" + attach.fileName);

                const thumbDiv = document.createElement('div');
                thumbDiv.className = 'thumbnail-item';
                thumbDiv.dataset.originalUrl = originURL;
                thumbDiv.innerHTML = '<img src="' + thumbnailURL + '" alt="썸네일 ' + (index + 1) + '">';

                thumbDiv.addEventListener('click', function() {
                    updateMainImage(originURL);
                    document.querySelector('.thumbnail-item.active')?.classList.remove('active');
                    this.classList.add('active');
                });
                thumbnailGallery.appendChild(thumbDiv);

                if (index === 0) {
                    updateMainImage(originURL);
                    thumbDiv.classList.add('active');
                }
            });
        }
        function updateMainImage(url) {
            let mainImg = imageSection.querySelector('img');
            if (!mainImg) {
                mainImg = document.createElement('img');
                imageSection.innerHTML = '';
                imageSection.appendChild(mainImg);
            }
            mainImg.src = url;
            mainImg.onclick = function() { openModal(url); };
        }
        function openModal(url) { modal.style.display = "block"; modalImage.src = url; }
        function hideModal() { modal.style.display = "none"; }

        if(closeModalBtn) closeModalBtn.onclick = hideModal;
        if(modal) modal.onclick = e => { if (e.target === modal) hideModal(); };
        document.addEventListener('keydown', e => { if (e.key === "Escape" && modal.style.display === "block") hideModal(); });
    });
    </script>
    <script src="/resources/js/review.js"></script> <script>
    document.addEventListener("DOMContentLoaded", function() {
        const addBtn = document.getElementById("addReviewBtn");

        if(addBtn) {
            // 기존 review.js의 이벤트와 충돌하지 않게 디버깅용으로 클릭 이벤트를 추가합니다.
            addBtn.addEventListener("click", function(e) {
                console.log("========== [디버깅 시작] 리뷰 등록 버튼 클릭됨 ==========");

                // 1. 기본 데이터 수집 확인
                const reviewSection = document.querySelector(".review-section");
                const bno = reviewSection.getAttribute("data-bno");
                const replyer = reviewSection.getAttribute("data-login-user");
                const content = document.getElementById("reviewContent").value;
                
                // 별점 가져오기 (review.js 내부 로직을 추정하여 값 확인)
                const starArea = document.querySelector(".star-input-area");
                const rating = starArea ? starArea.getAttribute("data-rating") : "찾을 수 없음";

                console.log("1. 게시글 번호 (bno):", bno);
                console.log("2. 작성자 (replyer):", replyer);
                console.log("3. 리뷰 내용 (content):", content);
                console.log("4. 별점 (rating):", rating);

                // 2. 유효성 검사 로그
                if (!replyer) console.error("❌ 오류: 로그인된 사용자 정보가 없습니다.");
                if (!content) console.warn("⚠️ 경고: 리뷰 내용이 비어있습니다.");
                if (rating == 0 || rating == "0") console.error("❌ 오류: 별점이 선택되지 않았습니다.");

                // 3. 보안(CSRF) 토큰 확인 (Spring Security 사용 시 필수)
                const csrfHeaderName = reviewSection.getAttribute("data-csrf-header");
                const csrfTokenValue = reviewSection.getAttribute("data-csrf-token");

                console.log("5. CSRF Header:", csrfHeaderName);
                console.log("6. CSRF Token:", csrfTokenValue);
                
                if (!csrfHeaderName || !csrfTokenValue) {
                    console.error("❌ 오류: CSRF 토큰이 없어서 전송이 차단될 수 있습니다.");
                }

                console.log("========== [디버깅 종료] ==========");
                console.log("이제 네트워크 탭(Network)을 확인하여 실제 요청의 응답 코드(400, 403, 500 등)를 확인하세요.");
            });
        }
    });
    </script>
</body>
</html>
</body>
</html>