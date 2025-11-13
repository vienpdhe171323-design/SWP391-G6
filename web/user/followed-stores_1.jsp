<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cửa hàng đang theo dõi</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        body { background: #faf7ff; font-family: Inter; }
        .store-card {
            border-radius: 12px;
            padding: 20px;
            background: #fff;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            transition: 0.3s;
        }
        .store-card:hover { transform: translateY(-5px); }
        .btn-unfollow { border-radius: 8px; }
    </style>
</head>

<body>

<div class="container mt-4">
    <h2 class="text-center mb-4 text-primary fw-bold">
        <i class="fas fa-heart me-2"></i> Cửa hàng bạn đang theo dõi
    </h2>

    <c:choose>
        <c:when test="${empty stores}">
            <div class="text-center p-5 text-muted">
                <i class="fas fa-store-slash fa-3x mb-3"></i>
                <p>Bạn chưa theo dõi cửa hàng nào.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="row g-4">

                <c:forEach var="s" items="${stores}">
                    <div class="col-md-4">
                        <div class="store-card">

                            <h5 class="fw-bold">${s.storeName}</h5>
                            <p class="mb-1"><i class="fas fa-user"></i> Chủ shop: ${s.ownerName}</p>
                            <p class="mb-1"><i class="fas fa-calendar"></i> Ngày tạo: ${s.createdAt}</p>
                            <p class="mb-2"><i class="fas fa-circle text-success"></i> ${s.status}</p>

                            <div class="d-flex gap-2 mt-3">
                                <!-- Xem cửa hàng -->
                                <a href="${pageContext.request.contextPath}/store/detail?id=${s.storeId}"
                                   class="btn btn-primary flex-fill">
                                    Xem cửa hàng
                                </a>

                                <!-- Bỏ theo dõi -->
                                <a href="${pageContext.request.contextPath}/follow-store?action=unfollow&storeId=${s.storeId}"
                                   class="btn btn-outline-danger flex-fill btn-unfollow">
                                    Bỏ theo dõi
                                </a>
                            </div>

                        </div>
                    </div>
                </c:forEach>

            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
