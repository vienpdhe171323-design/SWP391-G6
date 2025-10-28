<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        .detail-img {
            width: 280px;
            height: 280px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .card {
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            border: none;
            overflow: hidden;
        }
        .badge {
            font-size: 0.85rem;
            padding: 0.4em 0.8em;
        }
        .table {
            font-size: 0.95rem;
        }
        .btn-back {
            border-radius: 50px;
            padding: 0.65rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
    </style>
</head>
<body class="bg-light">
    <div class="container mt-5 mb-5">
        <div class="card p-4 p-md-5">
            <h2 class="text-center mb-4 fw-bold text-primary">Chi tiết sản phẩm</h2>

            <div class="row g-4">
                <div class="col-md-5 text-center">
                    <img src="${productBox.imageUrl}" 
                         alt="${productBox.productName}" 
                         class="detail-img"
                         onerror="this.src='${pageContext.request.contextPath}/images/no-image.png';">
                </div>
                <div class="col-md-7">
                    <h4 class="fw-bold text-dark">${productBox.productName}</h4>
                    <p class="fs-5"><strong>Giá:</strong> 
                        <span class="text-danger fw-bold">${productBox.price}₫</span>
                    </p>
                    <p><strong>Trạng thái:</strong>
                        <span class="badge ${productBox.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                            ${productBox.status}
                        </span>
                    </p>
                    <p><strong>Tồn kho:</strong> 
                        <span class="${productBox.stock > 0 ? 'text-success' : 'text-danger'} fw-bold">
                            ${productBox.stock}
                        </span>
                    </p>
                    <hr>
                    <p><strong>Danh mục:</strong> ${productBox.categoryName}
                        <c:if test="${not empty productBox.parentCategoryName}">
                            <small class="text-muted">(Cha: ${productBox.parentCategoryName})</small>
                        </c:if>
                    </p>
                    <p><strong>Cửa hàng:</strong> <span class="text-primary">${productBox.storeName}</span></p>
                    <p><strong>Ngày tạo cửa hàng:</strong> ${productBox.storeCreatedAt}</p>
                </div>
            </div>

            <hr class="my-4">
            <h5 class="mt-3 fw-semibold text-secondary">Thuộc tính sản phẩm</h5>
            <div class="table-responsive">
                <table class="table table-bordered table-sm align-middle">
                    <thead class="table-light">
                        <tr>
                            <th width="40%">Tên thuộc tính</th>
                            <th>Giá trị</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${productBox.attributes}">
                            <tr>
                                <td class="fw-medium">${a.attributeName}</td>
                                <td>${a.value}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty productBox.attributes}">
                            <tr>
                                <td colspan="2" class="text-center text-muted py-3">
                                    Không có thuộc tính nào
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <div class="text-center mt-4">
                <!-- NÚT BACK THÔNG MINH -->
                <c:choose>
                    <c:when test="${sessionScope.user != null && sessionScope.user.role == 'SELLER'}">
                        <!-- Seller → quay về danh sách quản lý -->
                        <a href="product?action=list" class="btn btn-outline-primary btn-back">
                            Quay lại danh sách
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.user != null && sessionScope.user.role == 'ADMIN'}">
                        <!-- Admin → cũng về danh sách -->
                        <a href="product?action=list" class="btn btn-outline-primary btn-back">
                            Quay lại danh sách
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- User hoặc chưa đăng nhập → về trang chủ -->
                        <a href="home" class="btn btn-outline-primary btn-back">
                            Quay lại trang chủ
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>