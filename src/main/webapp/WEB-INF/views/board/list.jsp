<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
<style>
    .pagination a {
        color: black;
        float: left;
        padding: 8px 16px;
        text-decoration: none;
        border: 1px solid #ddd;
    }
    .pagination a.active {
        background-color: #4CAF50;
        color: white;
        border: 1px solid #4CAF50;
    }
    .pagination a:hover:not(.active) {background-color: #ddd;}
</style>
</head>
<body>

<h1>Board List</h1>

<table border="1">
  <tr>
    <th>BNO</th>
    <th>Title</th>
    <th>Writer</th>
    <th>Regdate</th>
    <th>Viewcnt</th>
  </tr>

<c:forEach items="${list}" var="board">
  <tr>
    <td><c:out value="${board.bno}"/></td>
    <td><a href='/board/get?bno=<c:out value="${board.bno}"/>&page=<c:out value="${pageMaker.cri.page}"/>&perPageNum=<c:out value="${pageMaker.cri.perPageNum}"/>'><c:out value="${board.title}"/></a></td>
    <td><c:out value="${board.writer}"/></td>
    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
    <td><c:out value="${board.viewcnt}"/></td>
  </tr>
</c:forEach>

</table>

<div class="pagination">
    <c:if test="${pageMaker.prev}">
        <a href="/board/list?page=${pageMaker.startPage - 1}">&laquo;</a>
    </c:if>

    <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
        <a href="/board/list?page=${num}" class="${pageMaker.cri.page == num ? 'active' : ''}">${num}</a>
    </c:forEach>

    <c:if test="${pageMaker.next}">
        <a href="/board/list?page=${pageMaker.endPage + 1}">&raquo;</a>
    </c:if>
</div>

<br>
<a href="/board/register">Register New Board</a>

<script>
    var result = '${result}';
    if (result && !isNaN(result)) {
        alert(result + "번 글이 등록되었습니다.");
    }
</script>

</body>
</html>
