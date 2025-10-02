<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="common/header.jsp"></jsp:include>
    <html>
        <head>
            <title>Chỉnh sửa cửa hàng</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #f5f7fa;
                }
                .container {
                    width: 500px;
                    margin: 40px auto;
                    background: #fff;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                }
                h2 {
                    text-align: center;
                    margin-bottom: 20px;
                }
                label {
                    font-weight: bold;
                    display: block;
                    margin-top: 10px;
                }
                input[type="text"], select {
                    width: 100%;
                    padding: 8px;
                    margin-top: 5px;
                    border: 1px solid #ccc;
                    border-radius: 5px;
                }
                button {
                    margin-top: 20px;
                    padding: 10px;
                    width: 100%;
                    background: #007bff;
                    border: none;
                    color: white;
                    border-radius: 5px;
                    cursor: pointer;
                    font-weight: bold;
                }
                button:hover {
                    background: #0056b3;
                }
                .back-link {
                    display: block;
                    margin-top: 15px;
                    text-align: center;
                    text-decoration: none;
                    color: #333;
                }
                .back-link:hover {
                    text-decoration: underline;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h2>Chỉnh sửa cửa hàng</h2>

                <form action="store" method="post">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="storeId" value="${store.storeId}"/>

                <label for="storeName">Tên cửa hàng:</label>
                <input type="text" id="storeName" name="storeName" 
                       value="${store.storeName}" required/>

                <label for="userId">Chủ cửa hàng:</label>
                <select id="userId" name="userId" required>
                    <c:forEach var="u" items="${sellers}">
                        <option value="${u.id}" 
                                <c:if test="${u.id == store.userId}">selected</c:if>>
                            ${u.fullName} (${u.email})
                        </option>
                    </c:forEach>
                </select>

                <button type="submit">Cập nhật</button>
            </form>

            <a href="store?action=list" class="back-link">⬅ Quay lại danh sách</a>
        </div>
    </body>
</html>

<jsp:include page="common/footer.jsp"></jsp:include>
