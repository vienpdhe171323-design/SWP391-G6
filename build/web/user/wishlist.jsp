<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Sản phẩm yêu thích</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-4">
    <h2 class="fw-bold mb-4 text-primary">💖 Sản phẩm bạn yêu thích</h2>

    <c:if test="${empty wishlist}">
        <div class="alert alert-info">Bạn chưa yêu thích sản phẩm nào.</div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="p" items="${wishlist}">
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <img src="${p.imageUrl}" class="card-img-top" style="height:180px; object-fit:cover;">
                    <div class="card-body">
                        <h6 class="fw-bold">${p.productName}</h6>
                        <p class="text-danger fw-bold">${p.price}₫</p>

                        <a href="product?action=detail&id=${p.id}" class="btn btn-primary btn-sm w-100">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

</div>

</body>
</html>
