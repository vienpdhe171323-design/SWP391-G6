<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="common/header.jsp"></jsp:include>
    <html>
        <head>
            <title>Danh sách cửa hàng</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #f5f7fa;
                }
                h2 {
                    text-align: center;
                    margin-top: 20px;
                }
                .action-bar {
                    width: 80%;
                    margin: 10px auto;
                    text-align: right;
                }
                .add-btn {
                    display: inline-block;
                    padding: 8px 16px;
                    background: #28a745;
                    color: white;
                    border-radius: 5px;
                    text-decoration: none;
                    font-weight: bold;
                    cursor: pointer;
                }
                .add-btn:hover {
                    background: #218838;
                }

                table {
                    border-collapse: collapse;
                    width: 80%;
                    margin: 20px auto;
                    background: #fff;
                    border-radius: 8px;
                    overflow: hidden;
                }
                th, td {
                    border: 1px solid #ddd;
                    padding: 10px;
                    text-align: center;
                }
                th {
                    background-color: #f4f4f4;
                }

                .pagination {
                    text-align: center;
                    margin-top: 20px;
                }
                .pagination a, .pagination b {
                    margin: 0 5px;
                    padding: 6px 12px;
                    text-decoration: none;
                    border: 1px solid #ccc;
                    color: #333;
                }
                .pagination b {
                    background-color: #007bff;
                    color: white;
                    border-color: #007bff;
                }

                /* Modal styles */
                .modal {
                    display: none;
                    position: fixed;
                    z-index: 1000;
                    left: 0;
                    top: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0,0,0,0.5);
                }
                .modal-content {
                    background-color: #fff;
                    margin: 8% auto;
                    padding: 20px;
                    border: 1px solid #888;
                    width: 400px;
                    border-radius: 8px;
                }
                .modal-header {
                    font-size: 18px;
                    font-weight: bold;
                    margin-bottom: 15px;
                }
                .close {
                    float: right;
                    font-size: 20px;
                    font-weight: bold;
                    cursor: pointer;
                    color: #aaa;
                }
                .close:hover {
                    color: #000;
                }
                input[type="text"], select {
                    width: 100%;
                    padding: 8px;
                    margin-bottom: 15px;
                    border: 1px solid #ccc;
                    border-radius: 5px;
                }
                button {
                    padding: 10px;
                    width: 100%;
                    background: #28a745;
                    border: none;
                    color: white;
                    border-radius: 5px;
                    cursor: pointer;
                    font-weight: bold;
                }
                button:hover {
                    background: #218838;
                }

                .action-links a {
                    margin: 0 5px;
                    text-decoration: none;
                    font-weight: bold;
                }
                .edit-link {
                    color: #007bff;
                }
                .delete-link {
                    color: red;
                }
            </style>
        </head>
        <body>
            <h2>Danh sách cửa hàng</h2>

            <!-- Search bar -->
            <form action="store" method="get" style="display:inline-block; margin-right:20px;">
                <input type="hidden" name="action" value="search"/>
                <select name="keyword" onchange="this.form.submit()">
                    <option value="">-- Chọn cửa hàng --</option>
                <c:forEach var="s" items="${stores}">
                    <option value="${s.storeName}">${s.storeName}</option>
                </c:forEach>
            </select>
        </form>


        <!-- Nút Add chỉ cho admin -->
        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
            <div class="action-bar">
                <span class="add-btn" onclick="openModal()">+ Tạo cửa hàng mới</span>
            </div>
        </c:if>

        <!-- Bảng danh sách -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên cửa hàng</th>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                        <th>Chủ cửa hàng</th>
                        </c:if>
                    <th>Ngày tạo</th>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                        <th>Hành động</th>
                        </c:if>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${stores}">
                    <tr>
                        <td>${s.storeId}</td>
                        <td>${s.storeName}</td>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                            <td>${s.ownerName}</td>
                        </c:if>
                        <td>${s.createdAt}</td>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                            <td class="action-links">
                                <a class="edit-link" href="store?action=edit&id=${s.storeId}">✏️ Sửa</a>
                                <a class="delete-link" href="store?action=delete&id=${s.storeId}" 
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa cửa hàng này?');">🗑️ Xóa</a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Phân trang -->
        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <b>${i}</b>
                    </c:when>
                    <c:otherwise>
                        <a href="store?action=list&page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <!-- Modal Add Store (chỉ hiển thị cho admin) -->
        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
            <div id="createModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal()">&times;</span>
                    <div class="modal-header">Tạo cửa hàng mới</div>
                    <form action="store" method="post">
                        <input type="hidden" name="action" value="create"/>

                        <label for="storeName">Tên cửa hàng:</label>
                        <input type="text" id="storeName" name="storeName" required/>

                        <label for="userId">Chọn người bán:</label>
                        <select id="userId" name="userId" required>
                            <c:forEach var="u" items="${sellers}">
                                <option value="${u.id}">${u.fullName} (${u.email})</option>
                            </c:forEach>
                        </select>

                        <button type="submit">Tạo cửa hàng</button>
                    </form>
                </div>
            </div>
        </c:if>

        <jsp:include page="common/footer.jsp"></jsp:include>

        <script>
            function openModal() {
                document.getElementById("createModal").style.display = "block";
            }
            function closeModal() {
                document.getElementById("createModal").style.display = "none";
            }
            window.onclick = function (event) {
                let modal = document.getElementById("createModal");
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            }
        </script>
    </body>
</html>
