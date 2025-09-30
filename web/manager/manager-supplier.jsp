<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

    <main class="main-content" id="mainContent">
        <!-- Filters & Search -->
        <h1 style="margin-bottom: 1rem; color: #333; text-align: center">Quản lý Nhà cung cấp</h1>
        <div class="filters-section">
            <h3 style="margin-bottom: 1rem; color: #333;">Tìm kiếm & Lọc dữ liệu</h3>
            <form method="GET" action="${pageContext.request.contextPath}/manager/manager-supplier">
            <div class="filters-row">
                <div class="filter-group">
                    <label>Tìm kiếm</label>
                    <input type="text" name="search" class="form-input" placeholder="Nhập từ khóa..."
                           style="width: 300px;" value="${fn:escapeXml(search)}">
                </div>
                <div class="filter-group">
                    <label>Kích thước trang</label>
                    <select name="size" class="form-input">
                        <c:forEach var="s" items="${fn:split('5,10,20,50',',')}">
                            <option value="${s}" <c:if test="${size == s}">selected</c:if>>${s}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-group">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Table -->
    <div class="table-section">
        <div class="table-header">
            <h3 class="table-title">Danh sách Nhà cung cấp</h3>
            <!-- MỞ MODAL ADD -->
            <button class="btn btn-success" id="btnAddOpen"
                    data-bs-toggle="modal" data-bs-target="#supplierAddModal">
                <i class="fas fa-plus"></i> Thêm mới
            </button>
        </div>
        <c:if test="${not empty sessionScope.alert_success}">
            <div style="text-align: center" class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.alert_success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="alert_success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.alert_error}">
            <div style="text-align: center"  class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.alert_error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="alert_error" scope="session"/>
        </c:if>

        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Contact Info</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${result.total == 0}">
                            <tr><td colspan="4" class="text-center">Không có dữ liệu</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="x" items="${result.items}">
                                <tr>
                                    <td>${x.id}</td>
                                    <td>${x.name}</td>
                                    <td>${x.contactInfo}</td>
                                    <td>
                                        <!-- MỞ MODAL EDIT -->
                                        <button class="btn btn-primary btn-sm btn-edit-open"
                                                data-bs-toggle="modal" data-bs-target="#supplierEditModal"
                                                data-id="${x.id}"
                                                data-name="${fn:escapeXml(x.name)}"
                                                data-contact="${fn:escapeXml(x.contactInfo)}">
                                            <i class="fas fa-edit"></i>
                                        </button>

                                        <a href="manager/manager-supplier?action=delete&id=${x.id}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Xóa nhà cung cấp này?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="pagination-wrapper">
            <div class="pagination-info">
                Hiển thị ${result.from}-${result.to} của ${total} kết quả
            </div>
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- Prev -->
                    <c:if test="${page > 1}">
                        <c:url var="prevUrl" value="/manager/manager-supplier">
                            <c:param name="search" value="${search}"/>
                            <c:param name="size" value="${size}"/>
                            <c:param name="page" value="${page-1}"/>
                        </c:url>
                        <a class="page-btn" href="${prevUrl}"><i class="fas fa-angle-left"></i></a>
                        </c:if>
                        <c:if test="${page == 1}">
                        <a class="page-btn disabled" href="#"><i class="fas fa-angle-left"></i></a>
                        </c:if>

                    <!-- Pages -->
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <c:if test="${p==1 || p==totalPages || (p>=page-2 && p<=page+2)}">
                            <c:url var="pageUrl" value="/manager/manager-supplier">
                                <c:param name="search" value="${search}"/>
                                <c:param name="size" value="${size}"/>
                                <c:param name="page" value="${p}"/>
                            </c:url>
                            <a class="page-btn ${p==page?'active':''}" href="${pageUrl}">${p}</a>
                        </c:if>
                        <c:if test="${(p==2 && page>4) || (p==totalPages-1 && page<totalPages-3)}">
                            <span class="page-btn">...</span>
                        </c:if>
                    </c:forEach>

                    <!-- Next -->
                    <c:if test="${page < totalPages}">
                        <c:url var="nextUrl" value="/manager/manager-supplier">
                            <c:param name="search" value="${search}"/>
                            <c:param name="size" value="${size}"/>
                            <c:param name="page" value="${page+1}"/>
                        </c:url>
                        <a class="page-btn" href="${nextUrl}"><i class="fas fa-angle-right"></i></a>
                        </c:if>
                        <c:if test="${page == totalPages}">
                        <a class="page-btn disabled" href="#"><i class="fas fa-angle-right"></i></a>
                        </c:if>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- MODAL: ADD -->
<div class="modal fade" id="supplierAddModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post"
                  action="${pageContext.request.contextPath}/manager/manager-supplier"
                  onsubmit="return validateAddForm()">
                <input type="hidden" name="action" value="add"/>
                <div class="modal-header">
                    <h5 class="modal-title">Thêm mới Nhà cung cấp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên nhà cung cấp</label>
                        <input type="text" class="form-control" id="add_name" name="name">
                        <div class="invalid-feedback">Vui lòng nhập tên nhà cung cấp</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Liên hệ (Email/SĐT)</label>
                        <input type="text" class="form-control" id="add_contact" name="contactInfo">
                        <div class="invalid-feedback">Vui lòng nhập thông tin liên hệ hợp lệ</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL: EDIT -->
<div class="modal fade" id="supplierEditModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post"
                  action="${pageContext.request.contextPath}/manager/manager-supplier"
                  onsubmit="return validateEditForm()">
                <input type="hidden" name="action" value="edit"/>
                <input type="hidden" name="id" id="edit_id"/>
                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa Nhà cung cấp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên nhà cung cấp</label>
                        <input type="text" class="form-control" id="edit_name" name="name">
                        <div class="invalid-feedback">Vui lòng nhập tên nhà cung cấp</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Liên hệ (Email/SĐT)</label>
                        <input type="text" class="form-control" id="edit_contact" name="contactInfo">
                        <div class="invalid-feedback">Vui lòng nhập thông tin liên hệ hợp lệ</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp"></jsp:include>

<!-- JS: event delegation + validate (không addEventListener lên phần tử có thể null) -->
<script>
    /* BẮT CLICK TOÀN TRANG: không còn lỗi addEventListener null */
    document.addEventListener("click", function (e) {
        // Mở Add: reset form Add
        if (e.target.closest("#btnAddOpen")) {
            resetAddModal();
            return;
        }
        // Mở Edit: nút có data-*
        const editBtn = e.target.closest(".btn-edit-open");
        if (editBtn) {
            fillEditModal(editBtn.dataset.id, editBtn.dataset.name, editBtn.dataset.contact);
            return;
        }
    });

    function resetAddModal() {
        const name = document.getElementById("add_name");
        const contact = document.getElementById("add_contact");
        if (name)
            name.value = "";
        if (contact)
            contact.value = "";
        clearInvalid(name, contact);
    }

    function fillEditModal(id, name, contact) {
        const idEl = document.getElementById("edit_id");
        const nameEl = document.getElementById("edit_name");
        const contactEl = document.getElementById("edit_contact");
        if (idEl)
            idEl.value = id || "";
        if (nameEl)
            nameEl.value = name || "";
        if (contactEl)
            contactEl.value = contact || "";
        clearInvalid(nameEl, contactEl);
    }

    function clearInvalid() {
        Array.from(arguments).forEach(el => {
            if (el)
                el.classList.remove("is-invalid");
        });
    }

    /* VALIDATE: dùng regex literal đúng (không \\w), đặt '-' cuối class */
    const EMAIL_RE = /^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$/;
    const PHONE_RE = /^[0-9]{8,15}$/;

    function validateCommon(nameEl, contactEl) {
        let valid = true;

        if (!nameEl || nameEl.value.trim() === "") {
            if (nameEl)
                nameEl.classList.add("is-invalid");
            valid = false;
        } else {
            nameEl.classList.remove("is-invalid");
        }

        const v = contactEl ? contactEl.value.trim() : "";
        if (!v || (!EMAIL_RE.test(v) && !PHONE_RE.test(v))) {
            if (contactEl)
                contactEl.classList.add("is-invalid");
            valid = false;
        } else {
            contactEl.classList.remove("is-invalid");
        }
        return valid;
    }

    function validateAddForm() {
        return validateCommon(
                document.getElementById("add_name"),
                document.getElementById("add_contact")
                );
    }

    function validateEditForm() {
        return validateCommon(
                document.getElementById("edit_name"),
                document.getElementById("edit_contact")
                );
    }
</script>
