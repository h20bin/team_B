<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h2>나의 예약 현황</h2>

<table border="1">
    <tr>
        <th>시설번호</th>
        <th>날짜</th>
        <th>시작</th>
        <th>종료</th>
        <th>상태</th>
    </tr>

    <c:forEach items="${list}" var="r">
        <tr>
            <td>${r.bno}</td>
            <td>${r.resDate}</td>
            <td>${r.startTime}</td>
            <td>${r.endTime}</td>
            <td>${r.status}</td>
        </tr>
    </c:forEach>
</table>
