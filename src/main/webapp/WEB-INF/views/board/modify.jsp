<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Modify Board</title>
</head>
<body>

<h1>Modify Board</h1>

<form action="/board/modify" method="post">
  <input type="hidden" name="page" value="<c:out value='${cri.page}'/>">
  <input type="hidden" name="perPageNum" value="<c:out value='${cri.perPageNum}'/>">
  <input type="hidden" name="bno" value="<c:out value='${board.bno}'/>">
  <table border="1">
    <tr>
      <th>Title</th>
      <td><input type="text" name="title" value="<c:out value='${board.title}'/>"></td>
    </tr>
    <tr>
      <th>Content</th>
      <td><textarea rows="5" cols="30" name="content"><c:out value='${board.content}'/></textarea></td>
    </tr>
    <tr>
      <th>Writer</th>
      <td><input type="text" name="writer" value="<c:out value='${board.writer}'/>" readonly></td>
    </tr>
  </table>
  <br>
  <button type="submit">Save</button>
  <a href="/board/get?bno=<c:out value='${board.bno}'/>&page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>">Cancel</a>
  <a href="/board/list?page=<c:out value='${cri.page}'/>&perPageNum=<c:out value='${cri.perPageNum}'/>">List</a>
</form>

</body>
</html>
