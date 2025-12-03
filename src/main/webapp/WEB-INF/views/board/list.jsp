<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>체육시설 조회 - 갤러리형</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 1. 기본 설정 */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; }
        body { color: #212529; background-color: #f8f9fa; }
        a { text-decoration: none; color: inherit; }
        
        /* 2. 헤더 (고정) */
        header { 
            width: 100%; height: 64px; 
            display: flex; justify-content: center; align-items: center; 
            position: fixed; top: 0; left: 0; background: white; 
            z-index: 100; border-bottom: 1px solid #e9ecef; 
        }
        .logo { color: #339af0; font-size: 20px; font-weight: 800; display: flex; align-items: center; gap: 8px; }
        .logo i { font-size: 22px; }

        /* 3. 메인 레이아웃 */
        .layout-container {
            display: flex;
            width: 100%; max-width: 1200px;
            margin: 100px auto 60px;
            padding: 0 20px;
            gap: 40px;
        }

        /* --- 좌측 사이드바 (필터) --- */
        .sidebar { width: 220px; flex-shrink: 0; }
        .sidebar h3 { font-size: 18px; font-weight: 700; margin-bottom: 20px; }
        
        .filter-group { margin-bottom: 30px; }
        .filter-title { font-size: 15px; font-weight: 600; margin-bottom: 12px; display: flex; justify-content: space-between; }
        .filter-title a { font-size: 12px; color: #868e96; font-weight: 400; text-decoration: underline; cursor: pointer; }
        
        .filter-list { list-style: none; }
        .filter-list li { margin-bottom: 10px; }
        .filter-list label { 
            display: flex; align-items: center; gap: 8px; font-size: 14px; color: #495057; cursor: pointer; 
        }
        .filter-list input[type="radio"], .filter-list input[type="checkbox"] { accent-color: #339af0; }

        /* 지역 선택 셀렉트박스 스타일 */
        .location-select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            color: #495057;
            outline: none;
        }
        .location-select:focus { border-color: #339af0; }

        /* --- 우측 콘텐츠 영역 --- */
        .content-area { flex-grow: 1; }
        .content-header { margin-bottom: 24px; }
        .content-header h2 { font-size: 24px; font-weight: 700; margin-bottom: 16px; }

        /* 검색바 디자인 */
        .search-bar-styled {
            display: flex; gap: 10px; padding: 10px;
            background: white; border: 1px solid #dee2e6; border-radius: 8px;
            margin-bottom: 30px;
        }
        .search-bar-styled select { border: none; outline: none; font-size: 14px; color: #495057; }
        .search-bar-styled input { flex-grow: 1; border: none; outline: none; font-size: 14px; }
        .search-bar-styled button { 
            background: none; border: none; color: #212529; font-weight: 600; cursor: pointer; 
        }

        /* 그리드 카드 리스트 */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 30px 20px;
            margin-bottom: 50px;
        }
        .card {
            display: block;       /* 링크 전체 클릭 가능 */
            background: transparent;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .card:hover { transform: translateY(-5px); }
        .card-img-wrap {
            width: 100%; height: 200px;
            background-color: #e9ecef;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 12px;
            position: relative;
        }
        .card-img-wrap img { width: 100%; height: 100%; object-fit: cover; }
        .card-title { font-size: 16px; font-weight: 800; margin-bottom: 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #212529; }
        .card-info { font-size: 13px; font-weight: 600; color: #495057; margin-bottom: 10px; }
        .card-meta { font-size: 12px; color: #868e96; display: flex; gap: 5px; align-items:center; }

        /* 페이지네이션 */
        .pagination { display: flex; justify-content: center; gap: 6px; }
        .pagination a {
            display: flex; justify-content: center; align-items: center;
            min-width: 32px; height: 32px; padding: 0 8px;
            border-radius: 4px; color: #868e96; font-size: 14px; background: white; border: 1px solid #dee2e6;
        }
        .pagination a.active { background-color: #339af0; border-color: #339af0; color: white; font-weight: 700; }

        /* 글쓰기 버튼 */
        .btn-write-float {
            position: fixed; bottom: 40px; right: 40px;
            background-color: #339af0; color: white;
            padding: 15px 25px; border-radius: 50px;
            font-weight: 700; box-shadow: 0 4px 12px rgba(51, 154, 240, 0.3);
            display: flex; align-items: center; gap: 8px;
            transition: 0.2s;
        }
        .btn-write-float:hover { background-color: #228be6; transform: scale(1.05); }

        /* 예약 가능 뱃지 */
        .badge-available {
            display:inline-flex;
            align-items:center;
            padding:2px 8px;
            border-radius:999px;
            background:#e7f5ff;
            color:#1c7ed6;
            font-size:11px;
            font-weight:700;
            margin-left:4px;
        }

    </style>
</head>
<body>

    <header>
        <div class="logo">
            <a href="/" style="display: flex; align-items: center;"><i class="fa-solid fa-dumbbell"></i> 짐빌려</a>
        </div>
        <div style="position: absolute; right: 40px; font-size: 14px; display: flex; align-items: center; gap: 15px;">
    <sec:authorize access="isAuthenticated()">
        <span><sec:authentication property="principal.member.name"/>님</span>

        <!-- 내 예약 바로가기 -->
        <a href="/reservation/my" style="color:#495057;">내 예약</a>

        <!-- 관리자 전용 메뉴들 -->
        <sec:authorize access="hasRole('ROLE_ADMIN')">
            <a href="/admin/reservation/status" style="font-weight:700; color:#339af0;">
                예약 현황
            </a>
            <a href="/admin/main" style="color:#339af0;">관리자 메인</a>
        </sec:authorize>

        <form action="/member/logout" method="post" style="display:inline;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button style="background:none; border:none; cursor:pointer; color:#868e96;">로그아웃</button>
        </form>
    </sec:authorize>

    <sec:authorize access="isAnonymous()">
        <a href="/member/login">로그인</a>
    </sec:authorize>
</div>

    </header>

    <div class="layout-container">
        
        <aside class="sidebar">
            <h3>필터</h3>

            <div class="filter-group">
                <div class="filter-title">카테고리 <a onclick="resetCategory()">초기화</a></div>
                <ul class="filter-list">
                    <li><label><input type="radio" name="cat" value="" checked> 전체보기</label></li>
                    <li><label><input type="radio" name="cat" value="facility"> 체육시설</label></li>
                    <li><label><input type="radio" name="cat" value="goods"> 체육용품</label></li>
                </ul>
            </div>

            <div class="filter-group">
                <div class="filter-title">지역 선택 <a onclick="resetLocation()">초기화</a></div>
                <select id="sido" class="location-select" onchange="categoryChange(this)">
                    <option value="">시/도 선택</option>
                    <option value="서울">서울</option>
                    <option value="부산">부산</option>
                    <option value="대구">대구</option>
                    <option value="인천">인천</option>
                    <option value="광주">광주</option>
                    <option value="대전">대전</option>
                    <option value="울산">울산</option>
                    <option value="세종">세종</option>
                    <option value="경기도">경기도</option>
                    <option value="강원도">강원도</option>
                    <option value="충청북도">충청북도</option>
                    <option value="충청남도">충청남도</option>
                    <option value="전라북도">전라북도</option>
                    <option value="전라남도">전라남도</option>
                    <option value="경상북도">경상북도</option>
                    <option value="경상남도">경상남도</option>
                    <option value="제주">제주도</option>
                </select>
                
                <select id="gugun" class="location-select">
                    <option value="">시/군/구 선택</option>
                </select>
            </div>
            
            <button type="button" id="btnApplyFilter" style="width:100%; padding:10px; background:#212529; color:white; border:none; border-radius:6px; cursor:pointer; font-weight:700;">필터 적용</button>
        </aside>

        <main class="content-area">
            
            <div class="content-header">
                <h2>체육물품 및 시설 목록</h2>
            </div>

            <form id="searchForm" action="/board/list" method="get">
                <div class="search-bar-styled">
                    <select name="type">
                        <option value="T" ${pageMaker.cri.type eq 'T' ? 'selected' : ''}>제목</option>
                        <option value="C" ${pageMaker.cri.type eq 'C' ? 'selected' : ''}>내용</option>
                        <option value="W" ${pageMaker.cri.type eq 'W' ? 'selected' : ''}>작성자</option>
                        <option value="TC" ${pageMaker.cri.type eq 'TC' ? 'selected' : ''}>제목+내용</option>
                    </select>
                    <input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>' placeholder="검색어를 입력해주세요">
                    
                    <input type="hidden" name="page" value='1'>
                    <input type="hidden" name="perPageNum" value='<c:out value="${pageMaker.cri.perPageNum}"/>'>
                    
                    <input type="hidden" name="category" id="hiddenCat" value='<c:out value="${pageMaker.cri.category}"/>'>
                    <input type="hidden" name="sido" id="hiddenSido" value='<c:out value="${pageMaker.cri.sido}"/>'>
                    <input type="hidden" name="gugun" id="hiddenGugun" value='<c:out value="${pageMaker.cri.gugun}"/>'>

                    <button>검색</button>
                </div>
            </form>

            <div class="gallery-grid">
                <c:forEach items="${list}" var="board">
                    <!-- 카드 전체를 상세보기 링크로 -->
                    <a class="card" href="/board/get?bno=${board.bno}">
                        <div class="card-img-wrap">
                            <c:choose>
                                <c:when test="${board.uuid != null}">
                                    <c:set var="thumbPath" value="${board.uploadPath}/${board.uuid}_${board.fileName}" />
                                    <img src="/board/display?fileName=<c:out value='${thumbPath}'/>" alt="${board.title}" 
                                         onerror="this.parentNode.innerHTML='<div style=\'width:100%;height:100%;background:#e9ecef;display:flex;justify-content:center;align-items:center;color:#adb5bd;\'><i class=\'fa-regular fa-image fa-2x\'></i></div>'">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%; height:100%; background-color:#e9ecef; display:flex; align-items:center; justify-content:center; color:#868e96; font-size:14px;">
                                        <i class="fa-regular fa-image" style="font-size:40px; margin-bottom:10px;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-title">
                            <c:out value="${board.title}"/>
                        </div>
                        <div class="card-info">
                            <c:out value="${board.writer}"/>
                        </div>
                        <div class="card-meta">
                            <c:set var="locParts" value="${fn:split(board.location, ' ')}" />
                            <span>
                                <c:choose>
                                    <c:when test="${fn:length(locParts) >= 2}">
                                        <c:out value="${locParts[0]} ${locParts[1]}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${board.location}"/>
                                    </c:otherwise>
                                </c:choose>
                            </span> 
                            <span>·</span>
                            <span><fmt:formatDate pattern="MM-dd" value="${board.regdate}"/></span>
                            <span>·</span>
                            <span>조회 <c:out value="${board.viewcnt}"/></span>

                            <!-- 예약 가능 뱃지 -->
                            <span class="badge-available">예약 가능</span>
                        </div>
                    </a>
                </c:forEach>
            </div>

            <div class="pagination">
                <c:if test="${pageMaker.prev}">
                    <a href="${pageMaker.startPage - 1}" class="page-link"><i class="fa-solid fa-chevron-left"></i></a>
                </c:if>
                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <a href="${num}" class="page-link ${pageMaker.cri.page == num ? 'active' : ''}">${num}</a>
                </c:forEach>
                <c:if test="${pageMaker.next}">
                    <a href="${pageMaker.endPage + 1}" class="page-link"><i class="fa-solid fa-chevron-right"></i></a>
                </c:if>
            </div>

        </main>
    </div>

    <sec:authorize access="hasRole('ROLE_ADMIN')">
        <a href="/board/register" class="btn-write-float">
            <i class="fa-solid fa-pen"></i> 글쓰기
        </a>
    </sec:authorize>

    <form id="actionForm" action="/board/list" method="get">
        <input type="hidden" name="page" value='${pageMaker.cri.page}'>
        <input type="hidden" name="perPageNum" value='${pageMaker.cri.perPageNum}'>
        <input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'>
        <input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
        <input type="hidden" name="category" value='<c:out value="${pageMaker.cri.category}"/>'>
        <input type="hidden" name="sido" value='<c:out value="${pageMaker.cri.sido}"/>'>
        <input type="hidden" name="gugun" value='<c:out value="${pageMaker.cri.gugun}"/>'>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const areaData = {
            "전라남도": ["강진군","고흥군","곡성군","광양시","구례군","나주시","담양군","목포시","무안군","보성군","순천시","신안군","여수시","영광군","영암군","완도군","장성군","장흥군","진도군","함평군","해남군","화순군"],
            "서울": ["강남구","강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","중랑구"],
            "경기도": ["수원시","성남시","의정부시","안양시","부천시","광명시","평택시","동두천시","안산시","고양시","과천시","구리시","남양주시","오산시","시흥시","군포시","의왕시","하남시","용인시","파주시","이천시","안성시","김포시","화성시","광주시","양주시","포천시","여주시","연천군","가평군","양평군"],
            "부산": ["강서구","금정구","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","영도구","중구","해운대구","기장군"],
            "대구": ["중구","동구","서구","남구","북구","수성구","달서구","달성군"],
            "인천": ["중구","동구","미추홀구","연수구","남동구","부평구","계양구","서구","강화군","옹진군"],
            "광주": ["동구","서구","남구","북구","광산구"],
            "대전": ["동구","중구","서구","유성구","대덕구"],
            "울산": ["중구","남구","동구","북구","울주군"],
            "세종": ["세종특별자치시"],
            "강원도": ["춘천시","원주시","강릉시","동해시","태백시","속초시","삼척시","홍천군","횡성군","영월군","평창군","정선군","철원군","화천군","양구군","인제군","고성군","양양군"],
            "충청북도": ["청주시","충주시","제천시","보은군","옥천군","영동군","증평군","진천군","괴산군","음성군","단양군"],
            "충청남도": ["천안시","공주시","보령시","아산시","서산시","논산시","계룡시","당진시","금산군","부여군","서천군","청양군","홍성군","예산군","태안군"],
            "전라북도": ["전주시","군산시","익산시","정읍시","남원시","김제시","완주군","진안군","무주군","장수군","임실군","순창군","고창군","부안군"],
            "경상북도": ["포항시","경주시","김천시","안동시","구미시","영주시","영천시","상주시","문경시","경산시","군위군","의성군","청송군","영양군","영덕군","청도군","고령군","성주군","칠곡군","예천군","봉화군","울진군","울릉군"],
            "경상남도": ["창원시","진주시","통영시","사천시","김해시","밀양시","거제시","양산시","의령군","함안군","창녕군","고성군","남해군","하동군","산청군","함양군","거창군","합천군"],
            "제주": ["제주시","서귀포시"]
        };

        function categoryChange(e) {
            const selectedSido = e.value;
            const target = document.getElementById("gugun");
            target.options.length = 0;

            const defaultOpt = document.createElement("option");
            defaultOpt.value = "";
            defaultOpt.innerHTML = "시/군/구 선택";
            target.appendChild(defaultOpt);

            if(areaData[selectedSido]) {
                const cities = areaData[selectedSido];
                for (let i = 0; i < cities.length; i++) {
                    const opt = document.createElement("option");
                    opt.value = cities[i];
                    opt.innerHTML = cities[i];
                    target.appendChild(opt);
                }
            }
        }

        $(document).ready(function() {
            var actionForm = $("#actionForm");
            var searchForm = $("#searchForm");

            const savedSido = "${pageMaker.cri.sido}";
            const savedGugun = "${pageMaker.cri.gugun}";
            const savedCat = "${pageMaker.cri.category}";

            if(savedCat) {
                $(`input[name='cat'][value='${savedCat}']`).prop("checked", true);
            }
            
            if(savedSido) {
                $("#sido").val(savedSido).trigger("change");
                if(savedGugun) {
                    setTimeout(function(){
                         $("#gugun").val(savedGugun);
                    }, 100);
                }
            }

            $("#sido").on("change", function(){
                categoryChange(this);
            });

            $("#btnApplyFilter, #searchForm button").on("click", function(e){
                e.preventDefault();

                let selectedCat = $("input[name='cat']:checked").val();
                let selectedSido = $("#sido").val();
                let selectedGugun = $("#gugun").val();

                $("#hiddenCat").val(selectedCat);
                $("#hiddenSido").val(selectedSido);
                $("#hiddenGugun").val(selectedGugun);
                
                searchForm.find("input[name='page']").val("1");
                searchForm.submit();
            });

            $(".page-link").on("click", function(e) {
                e.preventDefault();
                actionForm.find("input[name='page']").val($(this).attr("href"));
                actionForm.submit();
            });
        });

        function resetCategory() {
            $("input[name='cat'][value='']").prop("checked", true);
        }
        function resetLocation() {
            $("#sido").val("");
            categoryChange(document.getElementById("sido"));
        }
    </script>

</body>
</html>
