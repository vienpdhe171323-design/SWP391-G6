<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Product Detail</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .detail-img {
                width: 280px;
                height: 280px;
                object-fit: cover;
                border-radius: 10px;
                border: 1px solid #ddd;
            }
            .card {
                border-radius: 10px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="card p-4">
                <h2 class="text-center mb-4">📦 Product Details</h2>

                <div class="row">
                    <div class="col-md-5 text-center">
                        <img src="${productBox.imageUrl}" alt="${productBox.productName}" class="detail-img"
                             onerror="this.src='${pageContext.request.contextPath}/images/no-image.png';">

                    </div>
                    <div class="col-md-7">
                        <h4>${productBox.productName}</h4>
                        <p><strong>Price:</strong> ${productBox.price} VND</p>
                        <p><strong>Status:</strong>
                            <span class="badge ${productBox.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                ${productBox.status}
                            </span>
                        </p>
                        <p><strong>Stock:</strong> ${productBox.stock}</p>
                        <hr>
                        <p><strong>Category:</strong> ${productBox.categoryName}
                            <c:if test="${not empty productBox.parentCategoryName}">
                                (Parent: ${productBox.parentCategoryName})
                            </c:if>
                        </p>
                        <p><strong>Store:</strong> ${productBox.storeName}</p>
                        <p><strong>Store Created At:</strong> ${productBox.storeCreatedAt}</p>
                    </div>
                </div>

                <hr>
                <h5 class="mt-3">🔖 Attributes</h5>
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr><th>Attribute</th><th>Value</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${productBox.attributes}">
                            <tr>
                                <td>${a.attributeName}</td>
                                <td>${a.value}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty productBox.attributes}">
                            <tr><td colspan="2" class="text-center text-muted">No attributes available</td></tr>
                        </c:if>
                    </tbody>
                </table>

                <div class="text-center">
                    <a href="product?action=list" class="btn btn-outline-primary mt-3">← Back to List</a>
                </div>
            </div>
        </div>
    </body>
</html>
