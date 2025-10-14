<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="common/header.jsp"/>

<style>
    /* ==================================== */
    /* GLOBAL STYLES (ĐỒNG BỘ VỚI DASHBOARD) */
    /* ==================================== */
    :root {
        --primary-color: #0d6efd;
        --secondary-dark: #1f2937; 
        --bg-light: #f3f4f6;
        --text-dark: #1f2937;
        --card-shadow: 0 5px 20px rgba(0,0,0,0.08);
    }

    /* ==================================== */
    /* FORM CONTAINER STYLES (Dùng lại từ Edit User) */
    /* ==================================== */
    .main-content {
        flex-grow: 1;
        padding: 40px 20px;
        display: flex;
        justify-content: center;
    }
    
    .form-container {
        width: 100%;
        max-width: 600px;
        background: #fff;
        padding: 40px; 
        border-radius: 12px; 
        box-shadow: var(--card-shadow); 
    }

    .form-header {
        margin-bottom: 30px;
        border-bottom: 1px solid #e9ecef;
        padding-bottom: 15px;
    }
    .form-header h2 {
        font-weight: 700;
        color: #ffc107; /* Màu vàng cảnh báo/chỉnh sửa */
    }
    
    .form-label {
        font-weight: 600;
        color: #495057;
    }

    /* Nút Actions */
    .form-actions {
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #f0f2f5; 
        display: flex;
        justify-content: flex-end; /* Căn nút về bên phải */
        gap: 10px;
    }
    .form-actions .btn {
        min-width: 120px;
        font-weight: 600;
    }
</style>

<div class="main-content">
    <div class="form-container">
        
        <div class="form-header">
            <h2><i class="fa-solid fa-store-slash me-2"></i> Chỉnh sửa Cửa hàng: ${store.storeName}</h2>
        </div>
        
        <form action="store" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="storeId" value="${store.storeId}"/>

            <div class="mb-3">
                <label for="storeName" class="form-label"><i class="fa-solid fa-shop"></i> Tên cửa hàng <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="storeName" name="storeName" 
                        value="${store.storeName}" required/>
                <div class="invalid-feedback">Vui lòng nhập tên cửa hàng.</div>
            </div>

            <div class="mb-3">
                <label for="userId" class="form-label"><i class="fa-solid fa-user-tie"></i> Chủ cửa hàng <span class="text-danger">*</span></label>
                <select class="form-select" id="userId" name="userId" required>
                    <c:forEach var="u" items="${sellers}">
                        <option value="${u.id}" 
                                <c:if test="${u.id == store.userId}">selected</c:if>>
                            ${u.fullName} (${u.email})
                        </option>
                    </c:forEach>
                </select>
                <div class="invalid-feedback">Vui lòng chọn chủ cửa hàng.</div>
            </div>

            <div class="form-actions">
                <a href="store?action=list" class="btn btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <button type="submit" class="btn btn-success">
                    <i class="fa-solid fa-cloud-arrow-up"></i> Cập nhật
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Kích hoạt tính năng validation của Bootstrap
    (function () {
      'use strict'
      var form = document.querySelector('form')
      form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }
        form.classList.add('was-validated')
      }, false)
    })()
</script>

<jsp:include page="common/footer.jsp"/>