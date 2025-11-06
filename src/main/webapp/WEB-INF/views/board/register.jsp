<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register Board</title>
</head>
<body>

<h1>Register Board</h1>

<form action="/board/register" method="post">
  <table border="1">
    <tr>
      <th>Title</th>
      <td><input type="text" name="title"></td>
    </tr>
    <tr>
      <th>Content</th>
      <td><textarea rows="5" cols="30" name="content"></textarea></td>
    </tr>
    <tr>
      <th>Writer</th>
      <td><input type="text" name="writer"></td>
    </tr>
  </table>
  <br>
  <button type="submit">Submit</button>
  <button type="reset">Reset</button>
  <a href="/board/list">List</a>
</form>

</body>
</html>
