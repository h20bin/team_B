<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 대기예약 현황</title>
<style>
    body { background:#f8f9fa; font-family:-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Malgun Gothic",sans-serif; }
    .wrap { max-width:900px; margin:60px auto; background:#fff; padding:30px 40px; border-radius:16px;
            box-shadow:0 4px 16px rgba(0,0,0,0.05); }
    h1 { font-size:24px; font-weight:800; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; font-size:14px; }
    th,td { padding:10px; border-bottom:1px solid #f1f3f5; text-align:center; }
    th { background:#f8f9fa; font-weight:700; }
    .badge-wait { color:#fff; background:#339af0; padding:4px 10px; border-radius:999px; font-size:12px; }
    .btn-back { margin-top:20px; padding:8px 18px; border-radius:8px; border:none; background:#495057; color:#fff; cursor:pointer; }
</style>
</head>
<body>
<div class="wrap">
    <h1>내 대기 예약 현황</h1>

    <table>
        <thead>
        <tr>
            <th>대기번호</th>
            <th>시설/물품 번호</th>
            <th>예약 날짜</th>
            <th>대기 순번</th>
            <th>상태</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${waitList}" var="w">
            <tr>
                <td>${w.waitId}</td>
                <td>${w.bno}</td>
                <td><fmt:formatDate value="${w.resDate}" pattern="yyyy-MM-dd"/></td>
                <td>${w.priority}</td>
                <td>
                    <c:choose>
                        <c:when test="${w.status eq 'WAIT'}"><span class="badge-wait">대기중</span></c:when>
                        <c:when test="${w.status eq 'MOVED'}">예약 승계됨</c:when>
                        <c:otherwise>${w.status}</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <button class="btn-back" onclick="location.href='/reservation/my'">예약 목록으로</button>
</div>
</body>
</html>
