<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

<main class="main-content" id="mainContent">
    <div class="container mt-4">
        <h2 class="mb-4">Danh sách Kho</h2>

        <!-- Search Form -->
        <form method="get" action="warehouses" class="row mb-3">
            <div class="col-md-4">
                <input type="text" name="search" value="${search}" class="form-control"
                       placeholder="Nhập tên hoặc địa điểm kho...">
            </div>
            <div class="col-md-2">
                <select name="size" class="form-select" onchange="this.form.submit()">
                    <option value="4" ${size==4 ? "selected" : ""}>4</option>
                    <option value="8" ${size==8 ? "selected" : ""}>8</option>
                    <option value="12" ${size==12 ? "selected" : ""}>12</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            </div>
        </form>

        <!-- Warehouses List -->
        <div class="row">
            <c:forEach var="wh" items="${result.items}">
                <div class="col-md-3 mb-3">
                    <div class="card shadow-sm h-100">
                        <img src="https://media.istockphoto.com/id/1138429558/vi/anh/h%C3%A0ng-k%E1%BB%87.jpg?s=612x612&w=0&k=20&c=PgMrFYOrgjbd3p0oOCvcKAwwkzSyl2Kle4bVjnhaWRg="
                             class="card-img-top" alt="warehouse image"
                             style="height:150px;object-fit:cover;">
                        <div class="card-body text-center">
                            <h5 class="card-title">${wh.name}</h5>
                            <p class="card-text text-muted">${wh.location}</p>
                            <a href="warehouse-products?wid=${wh.id}" class="btn btn-primary btn-sm">
                                Xem kho
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <div class="d-flex justify-content-between align-items-center mt-3">
            <div>Hiển thị ${result.from} - ${result.to} / ${result.total}</div>
            <div class="pagination">
                <c:forEach var="i" begin="1" end="${result.totalPages}">
                    <a href="warehouses?page=${i}&size=${size}&search=${search}"
                       class="btn btn-sm ${i == result.page ? 'btn-primary' : 'btn-outline-primary'}">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"></jsp:include>
