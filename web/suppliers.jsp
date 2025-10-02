<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="common/header.jsp"></jsp:include>


<main class="main-content" id="mainContent">

    <!-- Header Section -->
    <div class="table-header">
        <h3 class="table-title">Danh sách Suppliers</h3>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModal">
            <i class="fas fa-plus"></i> Thêm mới
        </button>
    </div>
    
    <form method="get" action="suppliers" class="mb-3">
    <div class="input-group" style="width: 300px;">
        <input type="text" name="search" class="form-control"
               placeholder="Nhập tên supplier..."
               value="${search}">
        <button class="btn btn-primary" type="submit">
            <i class="fas fa-search"></i> Tìm kiếm
        </button>
    </div>
</form>

    <!-- Table Section -->
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Tên Supplier</th>
                <th>Thông tin liên hệ</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="s" items="${suppliers}">
                <tr>
                    <td>${s.supplierId}</td>
                    <td>${s.supplierName}</td>
                    <td>${s.contactInfo}</td>
                    <td class="action-buttons">
                        <!-- Update -->
                        <button class="btn btn-primary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#updateModal${s.supplierId}">
                            <i class="fas fa-edit"></i>
                        </button>

                        <!-- Modal Update -->
                        <div class="modal fade" id="updateModal${s.supplierId}" tabindex="-1">
                            <div class="modal-dialog">
                                <form action="suppliers?action=update" method="post" class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Cập nhật Supplier</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="id" value="${s.supplierId}">
                                        <div class="mb-3">
                                            <label class="form-label">Tên</label>
                                            <input type="text" name="name" class="form-control" value="${s.supplierName}">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Liên hệ</label>
                                            <input type="text" name="contact" class="form-control" value="${s.contactInfo}">
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-primary">Lưu</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Delete -->
                        <a href="suppliers?action=delete&id=${s.supplierId}"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Xóa supplier này?')">
                            <i class="fas fa-trash"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <div class="pagination-wrapper d-flex justify-content-between align-items-center">
        <div class="pagination-info">
            Trang ${currentPage} / ${totalPages}
        </div>
        <ul class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="suppliers?action=list&page=${i}">${i}</a>
                </li>
            </c:forEach>
        </ul>
    </div>

</main>

<!-- Modal Add -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="suppliers?action=create" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm Supplier mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Tên</label>
                    <input type="text" name="name" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Liên hệ</label>
                    <input type="text" name="contact" class="form-control">
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Thêm</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap + FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<jsp:include page="common/footer.jsp"></jsp:include>
