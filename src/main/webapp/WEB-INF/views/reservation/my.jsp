<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 예약 현황</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Malgun Gothic",sans-serif; }
        body { background:#f8f9fa; }
        .wrap {
            max-width: 1000px;
            margin: 60px auto;
            background:#fff;
            padding:30px 40px 40px;
            border-radius:16px;
            box-shadow:0 4px 16px rgba(0,0,0,0.05);
        }
        h1 { font-size:24px; font-weight:800; margin-bottom:8px; }
        .sub { font-size:13px; color:#868e96; margin-bottom:4px; }
        .msg { font-size:13px; color:#2b8a3e; margin-bottom:20px; }

        table { width:100%; border-collapse:collapse; margin-top:10px; font-size:14px; }
        th, td { padding:10px; border-bottom:1px solid #f1f3f5; text-align:center; }
        th { background:#f8f9fa; font-weight:700; }

        .badge-reserved {
            display:inline-block;
            padding:3px 10px;
            border-radius:999px;
            background:#e7f5ff;
            color:#1c7ed6;
            font-size:12px;
            font-weight:700;
        }
        .badge-cancelled {
            display:inline-block;
            padding:3px 10px;
            border-radius:999px;
            background:#ffe3e3;
            color:#f03e3e;
            font-size:12px;
            font-weight:700;
        }

        .btn {
            border:none;
            border-radius:8px;
            padding:8px 16px;
            font-size:13px;
            font-weight:700;
            cursor:pointer;
        }
        .btn-cancel {
            background:#ff6b6b;
            color:#fff;
        }
        .btn-cancel:hover { background:#fa5252; }

        .btn-bottom {
            margin-top:24px;
            display:flex;
            gap:10px;
        }
        .btn-list {
            background:#339af0;
            color:#fff;
        }
        .btn-list:hover { background:#228be6; }
        .btn-wait {
            background:#495057;
            color:#fff;
        }
        .btn-wait:hover { background:#343a40; }

        .empty { padding:40px 0; text-align:center; color:#868e96; font-size:14px; }
    </style>
</head>
<body>
<div class="wrap">
    <h1>내 예약 현황</h1>
    <p class="sub">예약이 완료되었거나 취소된 내역을 확인할 수 있습니다.</p>

    <c:if test="${not empty msg}">
        <p class="msg"><c:out value="${msg}"/></p>
    </c:if>

    <c:choose>
        <c:when test="${empty list}">
            <div class="empty">등록된 예약이 없습니다.</div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                <tr>
                    <th>예약번호</th>
                    <th>시설/물품 번호(BNO)</th>
                    <th>예약 날짜</th>
                    <th>시작 시간</th>
                    <th>종료 시간</th>
                    <th>상태</th>
                    <th>취소</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${list}" var="r">
                    <tr>
                        <td>${r.resId}</td>
                        <td>${r.bno}</td>
                        <td><fmt:formatDate value="${r.resDate}" pattern="yyyy-MM-dd"/></td>
                        <td><c:out value="${r.startTime}"/></td>
                        <td><c:out value="${r.endTime}"/></td>

                        <td>
                            <c:choose>
                                <c:when test="${r.status eq 'RESERVED'}">
                                    <span class="badge-reserved">RESERVED</span>
                                </c:when>
                                <c:when test="${r.status eq 'CANCELLED'}">
                                    <span class="badge-cancelled">CANCELLED</span>
                                </c:when>
                                <c:otherwise>${r.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${r.status eq 'RESERVED'}">
                                <form action="${pageContext.request.contextPath}/reservation/cancel"
                                      method="post"
                                      style="margin:0;"
                                      onsubmit="return confirm('해당 예약을 취소하시겠습니까?');">
                                    <!-- CSRF 토큰 -->
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="hidden" name="resId" value="${r.resId}"/>
                                    <button type="submit" class="btn btn-cancel">취소</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <div class="btn-bottom">
        <!-- 게시판 목록으로 -->
        <button type="button"
                class="btn btn-list"
                onclick="location.href='${pageContext.request.contextPath}/board/list'">
            목록으로
        </button>

        <!-- 대기 예약 현황으로 -->
        <button type="button"
                class="btn btn-wait"
                onclick="location.href='${pageContext.request.contextPath}/reservation/wait'">
            대기 예약 보기
        </button>
    </div>
</div>
</body>
</html>
