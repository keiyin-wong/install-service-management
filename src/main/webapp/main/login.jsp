<%@ page pageEncoding="UTF-8" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Staff Login</title>
</head>
<body>
    <div style="text-align: center">
        <h1>Staff Login</h1>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <label for="userName">User Name:</label>
            <input name="userName" size="30" />
            <br><br>
            <label for="password">Password:</label>
            <input type="password" name="password" size="30" />
             <!-- <input hidden="password" name="currentPage" value="1" /> -->
            <br>
            <br><br>           
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>