<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Product List</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .product-img {
                width: 70px;
                height: 70px;
                object-fit: cover;
                border-radius: 6px;
                border: 1px solid #ccc;
            }
            .table td, .table th {
                vertical-align: middle;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-4">
            <h2 class="text-center mb-4">📦 Product List</h2>

            <div class="text-end mb-3">
                <a href="product?action=add" class="btn btn-success">+ Add New Product</a>
            </div>

            <table class="table table-bordered table-hover bg-white shadow-sm">
                <thead class="table-primary text-center">
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Store</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th width="180">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td class="text-center">${p.id}</td>
                            <td class="text-center">
                                <img src="${pageContext.request.contextPath}/${p.imageUrl.replace('img','images')}" 
                                     alt="${p.productName}" class="product-img"
                                     onerror="this.src='${pageContext.request.contextPath}/images/no-image.png';">

                            </td>
                            <td>${p.productName}</td>
                            <td>${p.storeName}</td>
                            <td>${p.categoryName}</td>
                            <td>${p.price}</td>
                            <td>${p.stock}</td>
                            <td>${p.status}</td>
                            <td class="text-center">
                                <a href="product?action=detail&id=${p.id}" class="btn btn-sm btn-info">View</a>
                                <a href="product?action=edit&id=${p.id}" class="btn btn-sm btn-warning">Edit</a>
                                <a href="product?action=delete&id=${p.id}" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Are you sure to delete this product?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Pagination -->
            <nav aria-label="Page navigation" class="d-flex justify-content-center">
                <ul class="pagination">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == pageIndex ? 'active' : ''}">
                            <a class="page-link" href="product?action=list&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </div>
    </body>
</html>
