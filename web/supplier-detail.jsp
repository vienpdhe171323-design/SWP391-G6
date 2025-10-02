<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Supplier Detail</title>
</head>
<body>
<h2>Supplier Detail</h2>

<form action="suppliers?action=update" method="post">
    <input type="hidden" name="id" value="${supplier.supplierId}">
    Name: <input type="text" name="name" value="${supplier.supplierName}"><br>
    Contact: <input type="text" name="contact" value="${supplier.contactInfo}"><br>
    <input type="submit" value="Update">
</form>

<a href="suppliers?action=list">Back to list</a>
</body>
</html>
