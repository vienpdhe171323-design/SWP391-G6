<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

    <style>
        .table-section{
            padding: 10px 20px 30px 10px;
        }
    </style>
    <main class="main-content" id="mainContent">

        <!-- Filters & Search -->
        <div class="filters-section">
            <h3 style="margin-bottom: 1rem; color: #333;">Tìm kiếm & Lọc kho</h3>
            <form method="GET" action="manager-warehouse" class="d-flex gap-3">
                <div class="filter-group">
                    <label>Tìm kiếm</label>
                    <input type="text" name="search" value="${search}" class="form-control"
                       placeholder="Nhập tên kho hoặc địa điểm..." style="width: 300px;">
            </div>
            <div class="filter-group">
                <label>Số bản ghi / trang</label>
                <select name="size" class="form-select" onchange="this.form.submit()">
                    <option value="5"  ${size==5 ? "selected" : ""}>5</option>
                    <option value="10" ${size==10 ? "selected" : ""}>10</option>
                    <option value="20" ${size==20 ? "selected" : ""}>20</option>
                    <option value="50" ${size==50 ? "selected" : ""}>50</option>
                </select>
            </div>
            <div class="filter-group d-flex align-items-end">
                <button type="submit" class="btn btn-primary" style="margin-top: 22px">
                    <i class="fas fa-search"></i> Tìm kiếm
                </button>
            </div>
        </form>
    </div>

    <!-- Table Section -->
    <div class="table-section">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <h3 class="table-title">Danh sách Kho</h3>
            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addWarehouseModal">
                <i class="fas fa-plus"></i> Thêm kho
            </button>
        </div>

        <div class="table-responsive">
            <c:if test="${not empty sessionScope.msg}">
                <div class="alert alert-${sessionScope.msgType} alert-dismissible fade show text-center" role="alert">
                    ${sessionScope.msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="msg" scope="session"/>
                <c:remove var="msgType" scope="session"/>
            </c:if>

            <table class="table table-bordered table-striped">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Tên kho</th>
                        <th>Địa điểm</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="wh" items="${result.items}">
                        <tr>
                            <td>${wh.id}</td>
                            <td>${wh.name}</td>
                            <td>${wh.location}</td>
                            <td class="action-buttons">
                                <button type="button" class="btn btn-primary btn-sm"
                                        data-bs-toggle="modal" data-bs-target="#editWarehouseModal${wh.id}">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <form method="post" action="manager-warehouse" style="display:inline;">
                                    <input type="hidden" name="action" value="toggle-status"/>
                                    <input type="hidden" name="id" value="${wh.id}"/>
                                    <button type="submit"
                                            class="btn btn-${wh.status=='ACTIVE' ? 'danger' : 'success'} btn-sm"
                                            onclick="return confirm('Bạn có chắc muốn đổi trạng thái kho này?')">
                                        <i class="fas ${wh.status=='ACTIVE' ? 'fa-lock' : 'fa-unlock'}"></i>
                                    </button>
                                </form>
                                <a href="stock-history" class="btn btn-outline-secondary">
                                    <i class="fas fa-history"></i> Xem lịch sử kho
                                </a>

                            </td>
                        </tr>

                        <!-- Edit Modal -->
                    <div class="modal fade" id="editWarehouseModal${wh.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form method="post" action="manager-warehouse">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Sửa kho</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="edit"/>
                                        <input type="hidden" name="id" value="${wh.id}"/>
                                        <label>Tên kho</label>
                                        <input type="text" name="name" value="${wh.name}" class="form-control"/>
                                        <label>Địa điểm</label>
                                        <input type="text" name="location" value="${wh.location}" class="form-control"/>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-primary">Lưu</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>



                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="d-flex justify-content-between align-items-center mt-3">
            <div class="pagination-info">
                Hiển thị ${result.from}-${result.to} của ${result.total} kết quả
            </div>
            <div class="pagination">
                <c:forEach var="i" begin="1" end="${result.totalPages}">
                    <a href="manager-warehouse?page=${i}&search=${search}&size=${size}"
                       class="btn btn-sm ${i == result.page ? 'btn-primary' : 'btn-outline-primary'}">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>
</main>

<!-- Add Modal -->
<div class="modal fade" id="addWarehouseModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="manager-warehouse">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm kho</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add"/>
                    <label>Tên kho</label>
                    <input type="text" name="name" class="form-control"/>
                    <label>Địa điểm</label>
                    <input type="text" name="location" class="form-control"/>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Thêm</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp"></jsp:include>
