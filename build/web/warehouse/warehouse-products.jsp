<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

<main class="main-content" id="mainContent">
    <div class="container mt-4">
        <h2>Sản phẩm trong kho: ${warehouse.name}</h2>
        <p class="text-muted">Địa điểm: ${warehouse.location}</p>

        <!-- Flash message -->
        <c:if test="${not empty sessionScope.msg}">
            <div class="alert alert-${sessionScope.msgType} alert-dismissible fade show text-center" role="alert">
                ${sessionScope.msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="msg" scope="session"/>
            <c:remove var="msgType" scope="session"/>
        </c:if>

        <!-- Search -->
        <form method="get" action="warehouse-products" class="row g-3 mb-3">
            <input type="hidden" name="wid" value="${warehouse.id}"/>
            <div class="col-md-4">
                <input type="text" name="search" value="${search}" class="form-control"
                       placeholder="Nhập tên sản phẩm...">
            </div>
            <div class="col-md-2">
                <select name="size" class="form-select" onchange="this.form.submit()">
                    <option value="5" ${size==5?"selected":""}>5</option>
                    <option value="10" ${size==10?"selected":""}>10</option>
                    <option value="20" ${size==20?"selected":""}>20</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            </div>
        </form>

        <!-- Table -->
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Tồn kho</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${result.items}">
                    <tr>
                        <td>${p.id}</td>
                        <td>${p.productName}</td>
                        <td>${p.price}</td>
                        <td>${p.stock}</td>
                        <td>
                            <!-- Nhập -->
                            <form method="post" action="stock-action" class="d-inline">
                                <input type="hidden" name="action" value="in"/>
                                <input type="hidden" name="productId" value="${p.id}"/>
                                <input type="hidden" name="warehouseId" value="${warehouse.id}"/>
                                <input type="number" name="quantity" min="1" style="width:70px" required/>
                                <button type="submit" class="btn btn-success btn-sm">Nhập</button>
                            </form>

                            <!-- Xuất -->
                            <form method="post" action="stock-action" class="d-inline">
                                <input type="hidden" name="action" value="out"/>
                                <input type="hidden" name="productId" value="${p.id}"/>
                                <input type="hidden" name="warehouseId" value="${warehouse.id}"/>
                                <input type="number" name="quantity" min="1" style="width:70px" required/>
                                <button type="submit" class="btn btn-danger btn-sm">Xuất</button>
                            </form>

                            <!-- Chuyển -->
                            <form method="post" action="stock-action" class="d-inline">
                                <input type="hidden" name="action" value="transfer"/>
                                <input type="hidden" name="productId" value="${p.id}"/>
                                <input type="hidden" name="warehouseId" value="${warehouse.id}"/>
                                <input type="number" name="quantity" min="1" style="width:70px" required/>
                                <select name="toWarehouseId" class="form-select d-inline" style="width:auto;display:inline-block">
                                    <c:forEach var="wh2" items="${allWarehouses}">
                                        <c:if test="${wh2.id ne warehouse.id}">
                                            <option value="${wh2.id}">${wh2.name}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-warning btn-sm">Chuyển</button>
                            </form>
                        </td>
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
                    <a href="warehouse-products?wid=${warehouse.id}&page=${i}&search=${search}&size=${size}"
                       class="btn btn-sm ${i==result.page?'btn-primary':'btn-outline-primary'}">${i}</a>
                </c:forEach>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"></jsp:include>
