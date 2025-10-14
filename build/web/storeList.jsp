<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="common/header.jsp"/>

<style>
    /* ==================================== */
    /* STORE MANAGEMENT STYLES */
    /* ==================================== */
    .main-content {
        flex-grow: 1;
        padding: 40px 20px;
        max-width: 1400px;
        margin: 0 auto;
        width: 100%;
    }

    .table-wrapper {
        background: #fff;
        padding: 30px; 
        border-radius: 12px; 
        box-shadow: 0 5px 20px rgba(0,0,0,0.08); /* Sử dụng card-shadow đồng bộ */
    }

    .table-title h2 {
        font-weight: 700;
        color: #1f2937; /* text-dark đồng bộ */
    }
    
    .table > :not(caption) > * > * {
        padding: 12px 15px; 
    }
    .table-light th {
        background-color: #e9ecef !important;
        color: #495057;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 14px;
    }
    .table-hover tbody tr:hover {
        background-color: #eef4ff; 
    }

    .action-buttons a {
        transition: transform 0.2s ease;
        margin: 0 4px;
    }
    .action-buttons a:hover {
        transform: translateY(-2px);
    }
    
    /* Đồng bộ phân trang Bootstrap */
    .pagination .page-item .page-link {
        border-radius: 8px; 
        margin: 0 4px;
        transition: all 0.3s;
    }
    .pagination .page-item.active .page-link {
        background-color: #0d6efd;
        border-color: #0d6efd;
        box-shadow: 0 2px 5px rgba(13, 110, 253, 0.2);
    }
</style>

<div class="container main-content">
    <div class="table-wrapper">
        
        <div class="table-title d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fa-solid fa-store me-2 text-primary"></i> Danh sách Cửa hàng</h2>
            
            <div class="d-flex align-items-center gap-3">
                <form action="store" method="get" class="d-flex align-items-center">
                    <input type="hidden" name="action" value="search"/>
                    <select name="keyword" class="form-select form-select-sm" onchange="this.form.submit()">
                        <option value="">-- Lọc theo Tên cửa hàng --</option>
                        <c:forEach var="s" items="${stores}">
                            <option value="${fn:escapeXml(s.storeName)}" 
                                    ${fn:escapeXml(param.keyword) eq fn:escapeXml(s.storeName) ? 'selected' : ''}>
                                ${s.storeName}
                            </option>
                        </c:forEach>
                    </select>
                </form>

                <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                    <button class="btn btn-success btn-icon-text" data-bs-toggle="modal" data-bs-target="#createStoreModal">
                        <i class="fa-solid fa-square-plus"></i> Tạo cửa hàng mới
                    </button>
                </c:if>
            </div>
        </div>
        
        <c:if test="${not empty message}">
            <div class="alert alert-success" role="alert"><i class="fa-solid fa-check-circle me-2"></i> ${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert"><i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}</div>
        </c:if>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Tên cửa hàng</th>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                            <th>Chủ cửa hàng</th>
                        </c:if>
                        <th>Ngày tạo</th>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                            <th class="text-center">Hành động</th>
                        </c:if>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${stores}">
                        <tr>
                            <td>${s.storeId}</td>
                            <td><i class="fa-solid fa-shop me-2"></i> ${s.storeName}</td>
                            <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                                <td>${s.ownerName}</td>
                            </c:if>
                            <td>${s.createdAt}</td>
                            <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                                <td class="text-center action-buttons">
                                    <a class="btn btn-sm btn-outline-warning" 
                                       href="store?action=edit&id=${s.storeId}" title="Chỉnh sửa">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <a class="btn btn-sm btn-outline-danger" 
                                       href="store?action=delete&id=${s.storeId}" title="Xóa"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa cửa hàng [${s.storeName}]?');">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </a>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center mt-4">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="store?action=list&page=${i}&keyword=${fn:escapeXml(param.keyword)}">${i}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:if>
        
    </div>
</div>

<c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
    <div class="modal fade" id="createStoreModal" tabindex="-1" aria-labelledby="createStoreModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="createStoreModalLabel"><i class="fa-solid fa-square-plus me-2"></i> Tạo cửa hàng mới</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="store" method="post" class="needs-validation" novalidate>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create"/>

                        <div class="mb-3">
                            <label for="storeName" class="form-label">Tên cửa hàng <span class="text-danger">*</span>:</label>
                            <input type="text" class="form-control" id="storeName" name="storeName" required/>
                            <div class="invalid-feedback">Vui lòng nhập tên cửa hàng.</div>
                        </div>

                        <div class="mb-3">
                            <label for="userId" class="form-label">Chọn người bán (Owner) <span class="text-danger">*</span>:</label>
                            <select class="form-select" id="userId" name="userId" required>
                                <option value="" disabled selected>-- Chọn người bán --</option>
                                <c:forEach var="u" items="${sellers}">
                                    <option value="${u.id}">${u.fullName} (${u.email})</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn người bán.</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success"><i class="fa-solid fa-save me-2"></i> Tạo cửa hàng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>

<script>
    // Kích hoạt tính năng validation của Bootstrap (nếu cần)
    (function () {
      'use strict'
      var forms = document.querySelectorAll('.needs-validation')
      Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
          if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
          }
          form.classList.add('was-validated')
        }, false)
      })
    })()
</script>

<jsp:include page="common/footer.jsp"/>