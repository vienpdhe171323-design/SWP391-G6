<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Edit Product</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .preview-img {
                width: 150px;
                height: 150px;
                object-fit: cover;
                border: 1px solid #ccc;
                border-radius: 6px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-4">
            <h2 class="text-center mb-4">✏️ Edit Product</h2>

            <form action="product" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="${product.id}">
                <input type="hidden" name="oldImage" value="${product.imageUrl}">

                <!-- Store Dropdown -->
                <div class="mb-3">
                    <label class="form-label">Store</label>
                    <select class="form-select" name="storeId" required>
                        <c:forEach var="s" items="${stores}">
                            <option value="${s.storeId}" ${s.storeId == product.storeId ? 'selected' : ''}>${s.storeName}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Category Dropdown -->
                <div class="mb-3">
                    <label class="form-label">Category</label>
                    <select class="form-select" name="categoryId" required>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${c.categoryId == product.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Product Name -->
                <div class="mb-3">
                    <label class="form-label">Product Name</label>
                    <input type="text" class="form-control" name="productName" value="${product.productName}" required>
                </div>

                <!-- Price -->
                <div class="mb-3">
                    <label class="form-label">Price</label>
                    <input type="number" step="0.01" class="form-control" name="price" value="${product.price}" required>
                </div>

                <!-- Stock -->
                <div class="mb-3">
                    <label class="form-label">Stock</label>
                    <input type="number" class="form-control" name="stock" value="${product.stock}" required>
                </div>

                <!-- Status -->
                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select class="form-select" name="status">
                        <option value="Active" ${product.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${product.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <!-- Product Attributes -->
                <div class="mb-3">
                    <label class="form-label">Attributes</label>
                    <div class="border p-3 rounded bg-white">
                        <c:forEach var="a" items="${attributes}">
                            <div class="row mb-2">
                                <div class="col-4">
                                    <label>${a.attributeName}</label>
                                </div>
                                <div class="col-8">
                                    <input type="text"
                                           class="form-control"
                                           name="attr_${a.attributeId}"
                                           value="${productAttrs[a.attributeId]}"
                                           placeholder="Enter ${a.attributeName}">
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>


                <!-- Current Image -->
                <div class="mb-3 text-center">
                    <label class="form-label d-block">Current Image</label>
                    <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                         class="preview-img"
                         alt="Current Image"
                         onerror="this.src='${pageContext.request.contextPath}/images/no-image.png';">
                </div>

                <!-- Upload New Image -->
                <div class="mb-3">
                    <label class="form-label">Choose New Image (optional)</label>
                    <input type="file" class="form-control" name="imageFile" accept="image/*" onchange="previewNewImage(event)">
                    <div class="mt-2 text-center">
                        <img id="previewNew" class="preview-img" style="display:none;">
                    </div>
                </div>

                <!-- Buttons -->
                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Update Product</button>
                    <a href="product?action=list" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <script>
            function previewNewImage(event) {
                const [file] = event.target.files;
                const preview = document.getElementById("previewNew");
                if (file) {
                    preview.src = URL.createObjectURL(file);
                    preview.style.display = "block";
                }
            }
        </script>
    </body>
</html>
