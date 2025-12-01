<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 - 예약 현황</title>
    <style>
        body { background:#f8f9fa; font-family:-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Malgun Gothic",sans-serif; }
        .wrap { max-width:1100px; margin:40px auto; background:#fff; padding:30px 40px; border-radius:16px;
                box-shadow:0 4px 16px rgba(0,0,0,0.05); }
        h1 { font-size:24px; font-weight:800; margin-bottom:20px; }
        h2 { font-size:18px; font-weight:700; margin:25px 0 10px; }

        table { width:100%; border-collapse:collapse; font-size:14px; }
        th,td { padding:10px; border-bottom:1px solid #f1f3f5; text-align:center; }
        th { background:#f8f9fa; font-weight:700; }
        .badge { display:inline-block; padding:3px 8px; border-radius:999px; font-size:12px; }
        .badge-r { background:#e7f5ff; color:#1c7ed6; }
        .badge-c { background:#ffe3e3; color:#e03131; }
        .btn { padding:8px 16px; border-radius:8px; border:none; cursor:pointer; font-size:14px; }
        .btn-back { margin-top:20px; background:#495057; color:#fff; }
        a { text-decoration:none; color:inherit; }
    </style>
</head>
<body>

<div class="wrap">
    <h1>시설/용품 예약 현황 (관리자)</h1>

    <!-- 1. 시설/용품별 예약 통계 -->
    <h2>시설/용품별 예약 통계</h2>
    <table>
        <thead>
        <tr>
            <th>BNO</th>
            <th>총 예약 수</th>
            <th>진행 중 (RESERVED)</th>
            <th>취소 (CANCELLED)</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${statList}" var="s">
            <tr>
                <td>${s.bno}</td>
                <td>${s.totalCnt}</td>
                <td><span class="badge badge-r">${s.reservedCnt}</span></td>
                <td><span class="badge badge-c">${s.cancelledCnt}</span></td>
            </tr>
        </c:forEach>
        <c:if test="${empty statList}">
            <tr><td colspan="4">예약 데이터가 없습니다.</td></tr>
        </c:if>
        </tbody>
    </table>

    <!-- 2. 전체 예약 목록 -->
    <h2>전체 예약 목록</h2>
    <table>
        <thead>
        <tr>
            <th>예약번호</th>
            <th>BNO</th>
            <th>예약자</th>
            <th>예약 날짜</th>
            <th>시작 시간</th>
            <th>종료 시간</th>
            <th>상태</th>
            <th>상세</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${resList}" var="r">
            <tr>
                <td>${r.resId}</td>
                <td>${r.bno}</td>
                <td>${r.userid}</td>
                <td><fmt:formatDate value="${r.resDate}" pattern="yyyy-MM-dd"/></td>
                <td>${r.startTime}</td>
                <td>${r.endTime}</td>
                <td>${r.status}</td>
                <td>
                    <!-- 해당 게시글 상세 + 후기/평점 확인 링크 -->
                    <a href="${pageContext.request.contextPath}/board/get?bno=${r.bno}" target="_blank">
                        상세 / 후기보기
                    </a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty resList}">
            <tr><td colspan="8">등록된 예약이 없습니다.</td></tr>
        </c:if>
        </tbody>
    </table>

    <button class="btn btn-back" onclick="location.href='${pageContext.request.contextPath}/admin/main'">
        관리자 메인으로
    </button>
</div>

</body>
</html>
