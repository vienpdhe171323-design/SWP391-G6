<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sản phẩm - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #4338ca;
            --sidebar-bg: #1e293b;
            --sidebar-hover: #334155;
            --card-bg: #ffffff;
            --text: #1e293b;
            --text-light: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius: 12px;
            --transition: all 0.3s ease;
        }

        [data-theme="dark"] {
            --card-bg: #1e293b;
            --text: #f1f5f9;
            --text-light: #94a3b8;
            --border: #334155;
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: #f8fafc;
            color: var(--text);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
            color: white;
            padding: 1.5rem 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .sidebar-header {
            padding: 0 1.5rem 1.5rem;
            border-bottom: 1px solid #334155;
        }

        .sidebar-header h1 {
            font-size: 1.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-menu {
            padding: 1rem 0;
        }

        .sidebar-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            color: #cbd5e1;
            text-decoration: none;
            transition: var(--transition);
            font-weight: 500;
        }

        .sidebar-item i {
            width: 20px;
            margin-right: 12px;
            font-size: 1.1rem;
        }

        .sidebar-item:hover,
        .sidebar-item.active {
            background: var(--sidebar-hover);
            color: white;
        }

        .sidebar-item.active {
            border-left: 4px solid var(--primary);
            padding-left: 1.3rem;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 2rem;
            transition: var(--transition);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text);
            margin: 0;
        }

        .theme-toggle {
            background: none;
            border: 1px solid var(--border);
            color: var(--text-light);
            padding: 0.5rem;
            border-radius: 8px;
            cursor: pointer;
            transition: var(--transition);
        }

        .theme-toggle:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        /* Search & Filter */
        .search-filter {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid var(--border);
            padding: 0.65rem 1rem;
            font-size: 0.95rem;
        }

        /* Product Table */
        .table-container {
            background: var(--card-bg);
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .table {
            margin: 0;
        }

        .table thead {
            background: var(--primary);
            color: white;
        }

        .table thead th {
            font-weight: 600;
            border: none;
            padding: 1rem;
            font-size: 0.95rem;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-color: var(--border);
            font-size: 0.95rem;
        }

        .table tbody tr:hover {
            background-color: rgba(79, 70, 229, 0.05);
        }

        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid var(--border);
        }

        .status-badge {
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-active { background: #dcfce7; color: #166534; }
        .status-inactive { background: #fee2e2; color: #991b1b; }

        .action-btn {
            padding: 0.4rem 0.7rem;
            font-size: 0.85rem;
            border-radius: 6px;
            margin: 0 2px;
            transition: var(--transition);
        }

        .btn-view { background: #dbeafe; color: #1e40af; border: none; }
        .btn-view:hover { background: #bfdbfe; }

        .btn-edit { background: #fef3c7; color: #92400e; border: none; }
        .btn-edit:hover { background: #fde68a; }

        .btn-delete { background: #fee2e2; color: #991b1b; border: none; }
        .btn-delete:hover { background: #fecaca; }

        /* Pagination */
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 3px;
            color: var(--primary);
            border: 1px solid var(--border);
            padding: 0.5rem 0.85rem;
            font-weight: 500;
        }

        .pagination .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 80px;
                padding: 1rem 0;
            }
            .sidebar-header h1, .sidebar-item span {
                display: none;
            }
            .sidebar-item {
                justify-content: center;
            }
            .main-content {
                margin-left: 80px;
            }
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: stretch;
            }
            .search-filter {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h1>Admin</h1>
        </div>
        <div class="sidebar-menu">
            <a href="dashboard" class="sidebar-item">
                <i class="fa-solid fa-gauge-high"></i> <span>Tổng quan</span>
            </a>
            <a href="user" class="sidebar-item">
                <i class="fa-solid fa-users"></i> <span>Người dùng</span>
            </a>
            <a href="product" class="sidebar-item active">
                <i class="fa-solid fa-boxes-stacked"></i> <span>Sản phẩm</span>
            </a>
            <a href="order-report" class="sidebar-item">
                <i class="fa-solid fa-receipt"></i> <span>Đơn hàng</span>
            </a>
            <a href="logout" class="sidebar-item">
                <i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="page-header">
            <h2 class="page-title">Danh sách sản phẩm</h2>
            <button class="theme-toggle" onclick="toggleTheme()">
                <i class="fas fa-moon"></i>
            </button>
        </div>

        <!-- Search & Filter -->
        <div class="search-filter">
            <div class="flex-grow-1" style="max-width: 400px;">
                <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm..." id="searchInput">
            </div>
            <select class="form-select" style="width: auto;">
                <option>Danh mục</option>
                <option>Điện tử</option>
                <option>Thời trang</option>
            </select>
            <a href="product?action=add" class="btn btn-success">
                <i class="fa-solid fa-plus"></i> Thêm mới
            </a>
        </div>

        <!-- Product Table -->
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Hình ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Cửa hàng</th>
                            <th>Danh mục</th>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="productTable">
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td class="text-center fw-medium">${p.id}</td>
                                <td class="text-center">
                                    <img src="${pageContext.request.contextPath}/${p.imageUrl.replace('img','images')}" 
                                         alt="${p.productName}" class="product-img"
                                         onerror="this.src='${pageContext.request.contextPath}/images/no-image.png';">
                                </td>
                                <td>
                                    <div class="fw-semibold">${p.productName}</div>
                                </td>
                                <td><span class="text-muted">${p.storeName}</span></td>
                                <td><span class="text-muted">${p.categoryName}</span></td>
                                <td class="fw-bold text-danger">${p.price}₫</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.stock > 10}">
                                            <span class="text-success">${p.stock}</span>
                                        </c:when>
                                        <c:when test="${p.stock > 0}">
                                            <span class="text-warning">${p.stock}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger">Hết hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status-badge ${p.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                        ${p.status}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="product?action=detail&id=${p.id}" class="btn action-btn btn-view" title="Xem">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <a href="product?action=edit&id=${p.id}" class="btn action-btn btn-edit" title="Sửa">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <a href="product?action=delete&id=${p.id}" class="btn action-btn btn-delete" title="Xóa"
                                       onclick="return confirm('Xóa sản phẩm này?');">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <nav class="mt-4 d-flex justify-content-center">
            <ul class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == pageIndex ? 'active' : ''}">
                        <a class="page-link" href="product?action=list&page=${i}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dark mode toggle
        function toggleTheme() {
            const body = document.body;
            const current = body.getAttribute('data-theme');
            const newTheme = current === 'dark' ? 'light' : 'dark';
            body.setAttribute('data-theme', newTheme);
            localStorage.setItem('admin-theme', newTheme);
        }

        // Load theme
        window.addEventListener('DOMContentLoaded', () => {
            const saved = localStorage.getItem('admin-theme');
            if (saved) document.body.setAttribute('data-theme', saved);
            else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.body.setAttribute('data-theme', 'dark');
            }
        });

        // Search filter
        document.getElementById('searchInput')?.addEventListener('input', function(e) {
            const term = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('#productTable tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(term) ? '' : 'none';
            });
        });
    </script>
</body>
</html>