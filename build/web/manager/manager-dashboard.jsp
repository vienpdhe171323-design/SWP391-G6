<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

    <!-- Main Content -->
    <main class="main-content" id="mainContent">
        <!-- Filters & Search Section -->
        <div class="filters-section">
            <h3 style="margin-bottom: 1rem; color: #333;">Tìm kiếm & Lọc dữ liệu</h3>
            <form method="GET" action="admin-servlet">
                <div class="filters-row">
                    <div class="filter-group">
                        <label>Tìm kiếm</label>
                        <input type="text" name="search" class="form-input" placeholder="Nhập từ khóa..." style="width: 300px;">
                    </div>
                    <div class="filter-group">
                        <label>Trạng thái</label>
                        <select name="status" class="form-input">
                            <option value="">Tất cả</option>
                            <option value="active">Hoạt động</option>
                            <option value="inactive">Không hoạt động</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>Loại</label>
                        <select name="category" class="form-input">
                            <option value="">Tất cả</option>
                            <option value="user">Người dùng</option>
                            <option value="admin">Quản trị</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>Từ ngày</label>
                        <input type="date" name="from_date" class="form-input">
                    </div>
                    <div class="filter-group">
                        <label>&nbsp;</label>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                            Tìm kiếm
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Table Section -->
        <div class="table-section">
            <div class="table-header">
                <h3 class="table-title">Danh sách Users</h3>
                <a href="#" class="btn btn-success">
                    <i class="fas fa-plus"></i>
                    Thêm mới
                </a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>Nguyễn Văn An</td>
                            <td>vanan@email.com</td>
                            <td>0123456789</td>
                            <td><span class="status-badge status-active">Hoạt động</span></td>
                            <td>15/01/2024</td>
                            <td class="action-buttons">
                                <a href="#" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="#" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>Trần Thị Bình</td>
                            <td>thibinh@email.com</td>
                            <td>0987654321</td>
                            <td><span class="status-badge status-inactive">Không hoạt động</span></td>
                            <td>16/01/2024</td>
                            <td class="action-buttons">
                                <a href="#" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="#" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td>Lê Hoàng Cường</td>
                            <td>hoangcuong@email.com</td>
                            <td>0567891234</td>
                            <td><span class="status-badge status-active">Hoạt động</span></td>
                            <td>17/01/2024</td>
                            <td class="action-buttons">
                                <a href="#" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="#" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td>Phạm Minh Đức</td>
                            <td>minhduc@email.com</td>
                            <td>0345678912</td>
                            <td><span class="status-badge status-active">Hoạt động</span></td>
                            <td>18/01/2024</td>
                            <td class="action-buttons">
                                <a href="#" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="#" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td>5</td>
                            <td>Võ Thị Em</td>
                            <td>thiem@email.com</td>
                            <td>0789123456</td>
                            <td><span class="status-badge status-inactive">Không hoạt động</span></td>
                            <td>19/01/2024</td>
                            <td class="action-buttons">
                                <a href="#" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="#" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="pagination-wrapper">
                <div class="pagination-info">
                    Hiển thị 1-5 của 50 kết quả
                </div>
                <div class="pagination">
                    <a href="#" class="page-btn" disabled>
                        <i class="fas fa-angle-left"></i>
                    </a>
                    <a href="#" class="page-btn active">1</a>
                    <a href="#" class="page-btn">2</a>
                    <a href="#" class="page-btn">3</a>
                    <a href="#" class="page-btn">...</a>
                    <a href="#" class="page-btn">10</a>
                    <a href="#" class="page-btn">
                        <i class="fas fa-angle-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp"></jsp:include>

    
</body>
</html>
