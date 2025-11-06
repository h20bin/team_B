<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board</title>
</head>
<body>

<h1>Board</h1>

<table border="1">
  <tr>
    <th>BNO</th>
    <td><c:out value="${board.bno}"/></td>
  </tr>
  <tr>
    <th>Title</th>
    <td><c:out value="${board.title}"/></td>
  </tr>
  <tr>
    <th>Content</th>
    <td><textarea rows="5" cols="30" readonly><c:out value="${board.content}"/></textarea></td>
  </tr>
  <tr>
    <th>Writer</th>
    <td><c:out value="${board.writer}"/></td>
  </tr>
  <tr>
    <th>Regdate</th>
    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
  </tr>
</table>
<br>

<a href="/board/modify?bno=<c:out value='${board.bno}'/>&page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>">Modify</a>
<form id="removeForm" action="/board/remove" method="post">
    <input type="hidden" name="bno" value="<c:out value='${board.bno}'/>">
    <input type="hidden" name="page" value="<c:out value='${cri.page}'/>">
    <input type="hidden" name="perPageNum" value="<c:out value='${cri.perPageNum}'/>">
</form>
<button id="removeBtn">Remove</button>

<a href="/board/list?page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>">List</a>

<script>
    document.getElementById("removeBtn").addEventListener("click", function(){
        if(confirm("Are you sure you want to remove this post?")){
            document.getElementById("removeForm").submit();
        }
    });
</script>

</body>
</html>
