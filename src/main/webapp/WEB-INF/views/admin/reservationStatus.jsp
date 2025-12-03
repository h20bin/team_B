<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>시설/용품 예약 현황</title>

<style>
    body { background:#f8f9fa; font-family:-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Malgun Gothic",sans-serif; }

    .wrap {
        max-width:1100px; margin:40px auto;
        background:#fff; padding:30px 40px;
        border-radius:16px; box-shadow:0 4px 16px rgba(0,0,0,0.05);
    }

    h1 { font-size:24px; font-weight:800; margin-bottom:20px; }
    h2 { font-size:18px; font-weight:700; margin-top:30px; margin-bottom:10px; }

    table { width:100%; border-collapse:collapse; font-size:14px; margin-top:10px; }
    th,td { padding:8px 10px; border-bottom:1px solid #f1f3f5; text-align:center; }
    th { background:#f8f9fa; font-weight:700; }

    tr:hover { background:#f8f9fa; }

    .btn-link { border:none; background:none; color:#339af0; cursor:pointer; font-size:13px; }

    .badge { display:inline-block; padding:3px 8px; border-radius:999px; font-size:12px; }
    .badge-blue { background:#e7f5ff; color:#1c7ed6; }
    .badge-red { background:#ffe3e3; color:#f03e3e; }

    .top-btn {
        margin-top:20px;
        color:#495057; background:#e9ecef;
        padding:6px 14px; border-radius:8px;
        cursor:pointer; border:none; font-size:13px;
    }
    .top-btn:hover { background:#dee2e6; }
</style>

</head>
<body>
<div class="wrap">

    <h1>시설/용품 예약 현황</h1>

    <!-- =========================
         1. BNO별 통계
    ========================== -->
    <h2>시설/용품별 예약 통계</h2>

    <table>
        <thead>
        <tr>
            <th>BNO</th>
            <th>전체 예약 수</th>
            <th>RESERVED</th>
            <th>CANCELLED</th>
            <th>상세보기</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${stats}" var="s">
            <tr>
                <td>${s.bno}</td>
                <td>${s.totalCnt}</td>
                <td><span class="badge badge-blue">${s.reservedCnt}</span></td>
                <td><span class="badge badge-red">${s.cancelledCnt}</span></td>

                <td>
                    <form method="get"
                          action="${pageContext.request.contextPath}/admin/reservation/status">
                        <input type="hidden" name="bno" value="${s.bno}">
                        <button type="submit" class="btn-link">예약자 목록</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>


    <!-- =========================
         2. 특정 BNO 상세 예약자 목록
    ========================== -->
    <c:if test="${not empty list}">
        <h2>시설/물품 번호 ${selectedBno} 예약자 목록</h2>

        <table>
            <thead>
            <tr>
                <th>예약번호</th>
                <th>회원 ID</th>
                <th>예약 날짜</th>
                <th>시작 시간</th>
                <th>종료 시간</th>
                <th>상태</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${list}" var="r">
                <tr>
                    <td>${r.resId}</td>
                    <td>${r.userid}</td>
                    <td><fmt:formatDate value="${r.resDate}" pattern="yyyy-MM-dd"/></td>
                    <td>${r.startTime}</td>
                    <td>${r.endTime}</td>

                    <td>
                        <c:choose>
                            <c:when test="${r.status eq 'RESERVED'}">
                                <span class="badge badge-blue">RESERVED</span>
                            </c:when>
                            <c:when test="${r.status eq 'CANCELLED'}">
                                <span class="badge badge-red">CANCELLED</span>
                            </c:when>
                            <c:otherwise>${r.status}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <button class="top-btn"
                onclick="window.scrollTo({top:0, behavior:'smooth'});">
            ▲ 맨 위로
        </button>
    </c:if>

</div>
</body>
</html>
