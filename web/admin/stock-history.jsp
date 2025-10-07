<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/sidebar.jsp"/>
<style>
    .table-section{
        padding: 10px 20px 30px 10px;
    }
</style>
<main class="main-content" id="mainContent">
    <div class="container mt-4">
        <h2>Lịch sử nhập / xuất kho</h2>

        <!-- Search -->
        <form method="get" action="stock-history" class="row g-3 mb-3">
            <div class="col-md-3">
                <input type="text" name="search" value="${search}" class="form-control"
                       placeholder="Tìm theo sản phẩm hoặc kho...">
            </div>
            <div class="col-md-2">
                <select name="type" class="form-select" onchange="this.form.submit()">
                    <option value="">Tất cả</option>
                    <option value="IN" ${type=="IN"?"selected":""}>Nhập kho</option>
                    <option value="OUT" ${type=="OUT"?"selected":""}>Xuất kho</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="size" class="form-select" onchange="this.form.submit()">
                    <option value="5" ${size==5?"selected":""}>5</option>
                    <option value="10" ${size==10?"selected":""}>10</option>
                    <option value="20" ${size==20?"selected":""}>20</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">Lọc</button>
            </div>
            <div class="col-md-2 text-end">
                <a href="manager-warehouse" class="btn btn-secondary">⬅ Quay lại</a>
            </div>
        </form>


        <!-- Table -->
        <div class="table-section">
            <table class="table table-bordered table-striped">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Kho</th>
                        <th>Số lượng</th>
                        <th>Loại</th>
                        <th>Thời gian</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${result.items}">
                        <tr>
                            <td>${m.id}</td>
                            <td>${m.productName}</td>
                            <td>${m.warehouseName}</td>
                            <td>${m.quantity}</td>
                            <td>
                                <span class="badge
                                      ${m.movementType=='IN'?'bg-success':
                                        m.movementType=='OUT'?'bg-danger':'bg-info'}">
                                          ${m.movementType}
                                      </span>
                                </td>
                                <td><fmt:formatDate value="${m.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Paging -->
            <div class="d-flex justify-content-between mt-3">
                <div>Hiển thị ${result.from}-${result.to} / ${result.total}</div>
                <div>
                    <c:forEach var="i" begin="1" end="${result.totalPages}">
                        <a href="stock-history?page=${i}&search=${search}&size=${size}"
                           class="btn btn-sm ${i==result.page?'btn-primary':'btn-outline-primary'}">${i}</a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp"/>
