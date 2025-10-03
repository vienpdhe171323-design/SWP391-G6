<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="common/header.jsp"></jsp:include>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management Dashboard</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <style>
        /* Custom Styles for a modern look */
        body {
            background-color: #f8f9fa; /* Light gray background for better contrast */
        }
        .main-container {
            margin-top: 30px;
            margin-bottom: 30px;
        }
        .table-wrapper {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.05);
        }
        .table-title h2 {
            font-weight: 600;
        }
        .search-filters {
            padding: 20px;
            background-color: #fdfdfd;
            border: 1px solid #eee;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .btn-icon-text .fa-solid {
            margin-right: 8px;
        }
        .action-buttons a, .action-buttons button {
            margin: 0 3px;
        }
        .pagination > li > a, .pagination > li > span {
            border-radius: 50% !important;
            margin: 0 5px;
        }
        .badge {
            font-size: 0.85em;
            font-weight: 600;
            padding: 0.5em 0.8em;
        }
    </style>
</head>
<body>
    <div class="container main-container">
        <div class="table-wrapper">
            <div class="table-title d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fa-solid fa-users me-2"></i> User Management</h2>
                <button class="btn btn-success btn-icon-text" data-bs-toggle="modal" data-bs-target="#userModal" onclick="openAddModal()">
                    <i class="fa-solid fa-plus"></i> Add New User
                </button>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="search-filters">
                <form action="${pageContext.request.contextPath}/user" method="get" class="row g-3 align-items-center">
                    <input type="hidden" name="action" value="search">
                    <div class="col-lg-3 col-md-6">
                        <input type="text" class="form-control" name="searchFullName" value="${fn:escapeXml(searchFullName)}" placeholder="Search by Full Name...">
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <input type="text" class="form-control" name="searchEmail" value="${fn:escapeXml(searchEmail)}" placeholder="Search by Email...">
                    </div>
                    <div class="col-lg-2 col-md-6">
                        <select class="form-select" name="searchRole">
                            <option value="">All Roles</option>
                            <option value="Admin" ${"Admin" == searchRole ? "selected" : ""}>Admin</option>
                            <option value="Seller" ${"Seller" == searchRole ? "selected" : ""}>Seller</option>
                            <option value="Buyer" ${"Buyer" == searchRole ? "selected" : ""}>Buyer</option>
                        </select>
                    </div>
                    <div class="col-lg-2 col-md-6">
                        <select class="form-select" name="searchStatus">
                            <option value="">All Statuses</option>
                            <option value="Active" ${"Active" == searchStatus ? "selected" : ""}>Active</option>
                            <option value="Deactive" ${"Deactive" == searchStatus ? "selected" : ""}>Deactive</option>
                        </select>
                    </div>
                    <div class="col-lg-2 col-md-12 text-end">
                        <button type="submit" class="btn btn-primary w-100 btn-icon-text">
                            <i class="fa-solid fa-search"></i> Search
                        </button>
                    </div>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Email</th>
                            <th>Full Name</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.email}</td>
                                <td>${user.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'Admin'}"><span class="badge bg-primary">${user.role}</span></c:when>
                                        <c:when test="${user.role == 'Seller'}"><span class="badge bg-info text-dark">${user.role}</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${user.role}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge ${user.status == 'Active' ? 'bg-success' : 'bg-danger'}">${user.status}</span>
                                </td>
                                <td>${user.createdAt}</td>
                                <td class="text-center action-buttons">
                                    <button class="btn btn-outline-warning btn-sm" data-bs-toggle="modal" data-bs-target="#userModal"
                                            onclick="openEditModal(${user.id}, '${user.email}', '${fn:escapeXml(user.fullName)}', '${user.role}', '${user.status}')"
                                            title="Edit">
                                        <i class="fa-solid fa-pencil-alt"></i>
                                    </button>
                                    <c:choose>
                                        <c:when test="${user.status == 'Active'}">
                                            <a href="${pageContext.request.contextPath}/user?action=deactive&id=${user.id}"
                                               class="btn btn-outline-secondary btn-sm" title="Deactivate"
                                               onclick="return confirm('Are you sure you want to deactivate this user?')">
                                               <i class="fa-solid fa-toggle-off"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/user?action=active&id=${user.id}"
                                               class="btn btn-outline-success btn-sm" title="Activate"
                                               onclick="return confirm('Are you sure you want to activate this user?')">
                                               <i class="fa-solid fa-toggle-on"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/user?action=delete&id=${user.id}"
                                       class="btn btn-outline-danger btn-sm" title="Delete"
                                       onclick="return confirm('Are you sure you want to delete this user?')">
                                       <i class="fa-solid fa-trash-alt"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mt-4">
                       <%-- Your pagination logic here (no changes needed to the logic itself) --%>
                       <c:if test="${currentPage > 1}">
                           <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/user?page=${currentPage-1}&searchFullName=${fn:escapeXml(searchFullName)}&searchEmail=${fn:escapeXml(searchEmail)}&searchRole=${fn:escapeXml(searchRole)}&searchStatus=${fn:escapeXml(searchStatus)}">Previous</a></li>
                       </c:if>
                       <c:forEach begin="1" end="${totalPages}" var="i">
                           <li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/user?page=${i}&searchFullName=${fn:escapeXml(searchFullName)}&searchEmail=${fn:escapeXml(searchEmail)}&searchRole=${fn:escapeXml(searchRole)}&searchStatus=${fn:escapeXml(searchStatus)}">${i}</a></li>
                       </c:forEach>
                       <c:if test="${currentPage < totalPages}">
                           <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/user?page=${currentPage+1}&searchFullName=${fn:escapeXml(searchFullName)}&searchEmail=${fn:escapeXml(searchEmail)}&searchRole=${fn:escapeXml(searchRole)}&searchStatus=${fn:escapeXml(searchStatus)}">Next</a></li>
                       </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

    <div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userModalLabel"><i class="fa-solid fa-user-edit me-2"></i> User Form</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <c:if test="${not empty validationErrors}">
                        <div class="alert alert-danger">
                            <ul>
                                <c:forEach var="err" items="${validationErrors}">
                                    <li>${err}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                    <jsp:include page="userForm.jsp"/>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize tooltips for icon-only buttons
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl)
        })

        function openAddModal() {
            document.getElementById('userForm').reset();
            document.getElementById('userForm').classList.remove('was-validated');
            document.getElementById('action').value = 'add';
            document.getElementById('id').value = '';
            document.getElementById('email').readOnly = false;
            document.getElementById('userModalLabel').innerHTML = '<i class="fa-solid fa-user-plus me-2"></i> Add New User';
            document.getElementById('status').value = 'Active';
        }

        function openEditModal(id, email, fullName, role, status) {
            document.getElementById('userForm').reset();
            document.getElementById('userForm').classList.remove('was-validated');
            document.getElementById('action').value = 'update';
            document.getElementById('id').value = id;
            document.getElementById('email').value = email;
            document.getElementById('email').readOnly = true;
            document.getElementById('fullName').value = fullName;
            document.getElementById('role').value = role;
            document.getElementById('status').value = status;
            document.getElementById('userModalLabel').innerHTML = '<i class="fa-solid fa-user-edit me-2"></i> Edit User';
        }

        // --- Client-side validation ---
        // (Your existing validation JS logic can be kept. 
        // Using Bootstrap's built-in validation would be an even better next step).
    </script>
    
    <jsp:include page="common/footer.jsp"></jsp:include>
</body>
</html>