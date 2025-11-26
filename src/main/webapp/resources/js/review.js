document.addEventListener("DOMContentLoaded", function() {

    // JSP에 정의된 데이터 속성에서 주요 변수 가져오기
    const reviewSection = document.querySelector(".review-section");
    // 리뷰 섹션이 없으면(다른 페이지면) 실행 중지
    if (!reviewSection) return;

    // [수정 핵심!] data- 속성 대신, <head>의 meta 태그에서 CSRF 토큰을 가져옵니다.
    const csrfTokenNode = document.querySelector("meta[name='_csrf']");
    const csrfHeaderNode = document.querySelector("meta[name='_csrf_header']");

    const csrfToken = csrfTokenNode ? csrfTokenNode.getAttribute("content") : "";
    const csrfHeaderName = csrfHeaderNode ? csrfHeaderNode.getAttribute("content") : "X-CSRF-TOKEN";

    const bno = reviewSection.dataset.bno || '';
    const loginUser = reviewSection.dataset.loginUser || '';

    // 로그로 토큰이 잘 잡히는지 확인 (개발자 도구 콘솔에서 확인 가능)
    console.log("JS Loaded - CSRF Header:", csrfHeaderName);
    console.log("JS Loaded - CSRF Token:", csrfToken);

    // 자주 사용하는 UI 요소들을 객체로 관리
    const reviewElements = {
        summary: {
            stars: document.getElementById('summaryStars'),
            avg: document.getElementById('summaryAvg'),
            count: document.getElementById('summaryCount')
        },
        distribution: document.getElementById('ratingDistribution'),
        form: {
            container: document.getElementById('reviewFormContainer'),
            starArea: document.querySelector('.star-input-area'),
            stars: document.querySelectorAll('.star-input-area .fa-star'),
            content: document.getElementById('reviewContent')
        },
        buttons: {
            showForm: document.getElementById('showReviewFormBtn'),
            cancel: document.getElementById('cancelReviewBtn'),
            add: document.getElementById('addReviewBtn')
        },
        list: document.getElementById('reviewList')
    };

    // 서버와 통신하는 모든 API 호출을 객체로 묶어 관리
    const reviewService = {
        add: function(review, callback, errorCallback) {
            fetch('/reviews/new', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json', 
                    [csrfHeaderName]: csrfToken // 여기서 메타 태그 값을 사용
                },
                body: JSON.stringify(review)
            })
            .then(response => response.ok ? callback() : Promise.reject(response))
            .catch(errorCallback);
        },
        getList: function(param, callback, errorCallback) {
            fetch('/reviews/pages/' + param.bno + '/' + param.page)
            .then(r => r.ok ? r.json() : Promise.reject(r))
            .then(callback).catch(errorCallback);
        },
        remove: function(rno, userid, callback, errorCallback) {
             fetch('/reviews/' + rno, {
                method: 'DELETE',
                headers: { 
                    'Content-Type': 'application/json', 
                    [csrfHeaderName]: csrfToken // 삭제 시에도 토큰 필요
                },
                body: JSON.stringify({userid: userid})
             })
             .then(response => response.ok ? callback() : Promise.reject(response))
             .catch(errorCallback);
        },
        getStats: function(bno, callback, errorCallback) {
            fetch('/reviews/stats/' + bno)
            .then(r => r.ok ? r.json() : Promise.reject(r))
            .then(callback).catch(errorCallback);
        }
    };

    // 리뷰 목록을 화면에 표시하는 주 함수
    function showList(page) {
        reviewService.getList({ bno: bno, page: page || 1 }, 
        data => {
            // 리뷰 개수 업데이트
            if(reviewElements.summary.count) {
                reviewElements.summary.count.textContent = '(' + data.reviewCnt + ')';
            }

            // 리뷰 목록 렌더링
            if (!data.list || data.list.length === 0) {
                reviewElements.list.innerHTML = "<li>등록된 이용평이 없습니다.</li>";
            } else {
                let str = "";
                data.list.forEach(review => {
                    str += '<li class="review-item" data-rno="' + review.rno + '">';
                    str += '  <div class="review-item-header">';
                    str += '    <span class="stars">' + getStarsHtml(review.rating) + '</span>';
                    str += '    <strong class="review-item-writer">' + review.userid + '</strong>';
                    str += '    <span class="review-item-date">' + new Date(review.regdate).toLocaleDateString() + '</span>';
                    if(loginUser === review.userid || loginUser === 'admin') {
                        str += '  <div class="review-item-actions"><button type="button" class="action-btn remove">삭제</button></div>';
                    }
                    str += '  </div>';
                    str += '  <p class="review-item-content">' + review.content.replace(/\n/g, '<br>') + '</p>';
                    str += '</li>';
                });
                reviewElements.list.innerHTML = str;
            }
            
            // 평점 분포도 및 요약 정보 업데이트
            reviewService.getStats(bno, stats => {
                 const totalCount = stats.reduce((acc, s) => acc + (s.CNT || s.cnt), 0);
                 const totalRating = stats.reduce((acc, s) => acc + ((s.RATING || s.rating) * (s.CNT || s.cnt)), 0);
                 const avg = totalCount > 0 ? (totalRating / totalCount) : 0;

                 if(reviewElements.summary.avg) reviewElements.summary.avg.textContent = avg.toFixed(1);
                 if(reviewElements.summary.stars) reviewElements.summary.stars.innerHTML = getStarsHtml(avg);
                 if(reviewElements.summary.count) reviewElements.summary.count.textContent = '(' + totalCount + ')';
                 
                 renderRatingChart(stats, totalCount);
            });
        }, 
        err => {
            console.error(err);
            reviewElements.list.innerHTML = "<li>리뷰를 불러오는 중 오류가 발생했습니다.</li>";
        });
    }
    
    // 평점 분포도 막대 그래프를 그리는 함수
    function renderRatingChart(stats, totalCount) {
        if(!reviewElements.distribution) return; // 요소 없으면 중단

        const statsMap = new Map();
        if(stats) {
            stats.forEach(s => statsMap.set((s.RATING || s.rating), (s.CNT || s.cnt)));
        }

        let chartHtml = "";
        for (let i = 5; i >= 1; i--) {
            const count = statsMap.get(i) || 0;
            const percentage = totalCount > 0 ? (count / totalCount) * 100 : 0;
            chartHtml += '<div class="dist-row">';
            chartHtml += '  <div class="star-label">' + i + '점</div>';
            chartHtml += '  <div class="dist-bar-bg"><div class="dist-bar" style="width: ' + percentage + '%;"></div></div>';
            chartHtml += '  <div class="count">' + count + '</div>';
            chartHtml += '</div>';
        }
        reviewElements.distribution.innerHTML = chartHtml;
    }

    // 평점(숫자)을 별 아이콘 HTML로 변환하는 함수
    function getStarsHtml(rating) {
        let html = "";
        const fullStars = Math.floor(rating);
        const halfStar = rating % 1 >= 0.5;
        for (let i = 1; i <= 5; i++) {
            if (i <= fullStars) html += '<i class="fa-solid fa-star"></i>';
            else if (i === fullStars + 1 && halfStar) html += '<i class="fa-solid fa-star-half-stroke"></i>';
            else html += '<i class="fa-regular fa-star"></i>';
        }
        return html;
    }

    // --- 이벤트 리스너 설정 ---

    // 별점 입력 이벤트
    if(reviewElements.form.stars) {
        reviewElements.form.stars.forEach(star => {
            star.addEventListener('click', e => {
                const rating = e.target.dataset.value;
                reviewElements.form.starArea.dataset.rating = rating;
                reviewElements.form.stars.forEach((s, i) => {
                    s.classList.toggle('is-active', i < rating);
                    s.classList.toggle('fa-solid', i < rating);
                    s.classList.toggle('fa-regular', i >= rating);
                    
                    // [추가] 사용자가 확실히 알 수 있게 색상 강제 적용
                    if(i < rating) s.style.color = '#fcc419';
                    else s.style.color = '#e9ecef';
                });
            });
        });
    }

    // '이용평 작성' 버튼 클릭 시 폼 보이기
    if (reviewElements.buttons.showForm) {
        reviewElements.buttons.showForm.addEventListener('click', () => { 
            reviewElements.form.container.style.display = 'block'; 
            reviewElements.buttons.showForm.style.display='none';
        });
    }

    // '취소' 버튼 클릭 시 폼 숨기기
    if (reviewElements.buttons.cancel) {
        reviewElements.buttons.cancel.addEventListener('click', () => { 
            reviewElements.form.container.style.display = 'none'; 
            if(reviewElements.buttons.showForm) {
                reviewElements.buttons.showForm.style.display='inline-flex';
            }
        });
    }

    // '등록' 버튼 클릭 이벤트
    if (reviewElements.buttons.add) {
        reviewElements.buttons.add.addEventListener('click', () => {
            const rating = reviewElements.form.starArea.dataset.rating;
            if (rating === "0" || !rating) { alert("별점을 선택해주세요."); return; }
            const content = reviewElements.form.content.value;
            if (content.trim() === "") { alert("이용평을 작성해주세요."); reviewElements.form.content.focus(); return; }
            
            reviewService.add({ bno: bno, userid: loginUser, rating: rating, content: content }, 
            () => {
                alert("이용평이 등록되었습니다.");
                reviewElements.form.container.style.display = 'none';
                if(reviewElements.buttons.showForm) reviewElements.buttons.showForm.style.display='inline-flex';
                reviewElements.form.content.value = '';
                // 별점 초기화
                reviewElements.form.starArea.dataset.rating = "0";
                reviewElements.form.stars.forEach(s => {
                    s.classList.remove('fa-solid');
                    s.classList.add('fa-regular');
                    s.style.color = '#e9ecef';
                });
                showList(1); // 목록 및 통계 새로고침
            },
            () => alert('리뷰 등록에 실패했습니다. (로그인 여부 확인 필요)'));
        });
    }
    
    // 리뷰 목록에서 '삭제' 버튼 클릭 이벤트 (이벤트 위임)
    if (reviewElements.list) {
        reviewElements.list.addEventListener("click", function(e){
           const target = e.target;
           if(target.classList.contains("remove")){
               const rno = target.closest(".review-item").dataset.rno;
               const userid = target.closest(".review-item").querySelector(".review-item-writer").innerText;
               if(confirm("이 이용평을 삭제하시겠습니까?")){
                   reviewService.remove(rno, userid, 
                   () => { alert("삭제되었습니다."); showList(1); },
                   () => alert("삭제에 실패했습니다."));
               }
           }
        });
    }

    // 페이지 최초 로드 시, 리뷰 목록과 통계 데이터 불러오기
    showList(1);
});