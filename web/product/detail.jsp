<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Chi tiết sản phẩm</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            .detail-img {
                width: 280px;
                height: 280px;
                object-fit: cover;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            .card {
                border-radius: 16px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.08);
                border: none;
                overflow: hidden;
            }
            .badge {
                font-size: 0.85rem;
                padding: 0.4em 0.8em;
            }
            .table {
                font-size: 0.95rem;
            }
            .btn-back {
                border-radius: 50px;
                padding: 0.65rem 1.5rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }
            .btn-back:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }

            /* Review Styles */
            .review-section {
                margin-top: 3rem;
                padding-top: 2rem;
                border-top: 2px solid #e2e8f0;
            }
            .review-card {
                background: #f8f9fa;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1rem;
                transition: all 0.3s ease;
            }
            .review-card:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            .review-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
            }
            .review-user {
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }
            .review-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
            }
            .star-rating {
                color: #fbbf24;
            }
            .star-rating i {
                font-size: 1.1rem;
            }
            .review-actions {
                display: flex;
                gap: 0.5rem;
            }
            .btn-review-action {
                padding: 0.25rem 0.75rem;
                font-size: 0.875rem;
                border-radius: 6px;
            }
            .rating-summary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 1.5rem;
                border-radius: 12px;
                text-align: center;
                margin-bottom: 2rem;
            }
            .avg-rating {
                font-size: 3rem;
                font-weight: 700;
            }
            .rating-stars {
                font-size: 1.5rem;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-5 mb-5">
            <div class="card p-4 p-md-5">
                <h2 class="text-center mb-4 fw-bold text-primary">Chi tiết sản phẩm</h2>

           <div class="row g-4">
    <div class="col-md-5 text-center">
        <img src="${productBox.imageUrl}" 
             alt="${productBox.productName}" 
             class="detail-img"
             onerror="this.src='${pageContext.request.contextPath}/images/no-image.png';">
    </div>

 <div class="col-md-7">
    <h4 class="fw-bold text-dark">${productBox.productName}</h4>

    <p class="fs-5"><strong>Giá:</strong> 
        <span class="text-danger fw-bold">${productBox.price}₫</span>
    </p>

    <p><strong>Trạng thái:</strong>
        <span class="badge ${productBox.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
            ${productBox.status}
        </span>
    </p>

    <p><strong>Tồn kho:</strong> 
        <span class="${productBox.stock > 0 ? 'text-success' : 'text-danger'} fw-bold">
            ${productBox.stock}
        </span>
    </p>

    <hr>

    <p><strong>Danh mục:</strong> ${productBox.categoryName}
        <c:if test="${not empty productBox.parentCategoryName}">
            <small class="text-muted">(Cha: ${productBox.parentCategoryName})</small>
        </c:if>
    </p>

    <p><strong>Cửa hàng:</strong> <span class="text-primary">${productBox.storeName}</span></p>
    <p><strong>Ngày tạo cửa hàng:</strong> ${productBox.storeCreatedAt}</p>

    <c:choose>

        <c:when test="${sessionScope.user != null}">

            <c:if test="${isFavorited}">
                <form action="${pageContext.request.contextPath}/wishlist" method="post" class="mt-3">
                    <input type="hidden" name="productId" value="${productBox.productId}">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-heart"></i> Đã yêu thích (Bấm để bỏ)
                    </button>
                </form>
            </c:if>

            <c:if test="${!isFavorited}">
                <form action="${pageContext.request.contextPath}/wishlist" method="post" class="mt-3">
                    <input type="hidden" name="productId" value="${productBox.productId}">
                    <button type="submit" class="btn btn-outline-danger">
                        <i class="far fa-heart"></i> Thêm vào yêu thích
                    </button>
                </form>
            </c:if>

        </c:when>

        <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-danger mt-3">
                <i class="fas fa-heart"></i> Đăng nhập để yêu thích
            </a>
        </c:otherwise>

    </c:choose>

</div>

</div>


                <hr class="my-4">
                <h5 class="mt-3 fw-semibold text-secondary">Thuộc tính sản phẩm</h5>
                <div class="table-responsive">
                    <table class="table table-bordered table-sm align-middle">
                        <thead class="table-light">
                            <tr>
                                <th width="40%">Tên thuộc tính</th>
                                <th>Giá trị</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${productBox.attributes}">
                                <tr>
                                    <td class="fw-medium">${a.attributeName}</td>
                                    <td>${a.value}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty productBox.attributes}">
                                <tr>
                                    <td colspan="2" class="text-center text-muted py-3">
                                        Không có thuộc tính nào
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- ============ PHẦN REVIEW ============ -->
                <div class="review-section">
                    <h4 class="mb-4 fw-bold"><i class="fas fa-star text-warning me-2"></i>Đánh giá sản phẩm</h4>

                    <!-- Rating Summary -->
                    <c:if test="${reviewCount > 0}">
                        <div class="rating-summary">
                            <div class="avg-rating mb-2">
                                <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
                            </div>
                            <div class="rating-stars mb-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star ${i <= avgRating ? '' : 'text-white-50'}"></i>
                                </c:forEach>
                            </div>
                            <div>${reviewCount} đánh giá</div>
                        </div>
                    </c:if>

                    <!-- Add Review Button (chỉ hiện nếu đã login) -->
                    <c:if test="${sessionScope.user != null}">
                        <div class="mb-4">
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#reviewModal">
                                <i class="fas fa-plus me-2"></i>Viết đánh giá
                            </button>
                        </div>
                    </c:if>

                    <!-- Reviews List -->
                    <div id="reviewsList">
                        <c:if test="${empty reviews}">
                            <div class="text-center text-muted py-4">
                                <i class="fas fa-comments fa-3x mb-3 opacity-50"></i>
                                <p>Chưa có đánh giá nào cho sản phẩm này</p>
                            </div>
                        </c:if>

                        <c:forEach var="review" items="${reviews}">
                            <div class="review-card" id="review-${review.reviewId}">
                                <div class="review-header">
                                    <div class="review-user">
                                        <div class="review-avatar">
                                            ${review.userName.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="fw-bold">${review.userName}</div>
                                            <div class="star-rating">
                                                <c:forEach begin="1" end="${review.rating}">
                                                    <i class="fas fa-star"></i>
                                                </c:forEach>
                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                    <i class="far fa-star"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="review-actions">
                                        <small class="text-muted">
                                            <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>

                                        <!-- Edit/Delete buttons (chỉ user tạo mới thấy) -->
                                        <c:if test="${sessionScope.user != null && sessionScope.user.id == review.userId}">
                                            <button class="btn btn-sm btn-outline-primary btn-review-action" 
                                                    onclick="editReview(${review.reviewId}, ${review.rating}, '${review.comment}')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger btn-review-action" 
                                                    onclick="deleteReview(${review.reviewId})">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </c:if>

                                        <!-- Report button (user khác mới thấy) -->
                                        <c:if test="${sessionScope.user != null && sessionScope.user.id != review.userId}">
                                            <button class="btn btn-sm btn-outline-warning btn-review-action" 
                                                    onclick="reportReview(${review.reviewId})">
                                                <i class="fas fa-flag"></i> Báo cáo
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="review-comment">
                                    ${review.comment}
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <c:choose>
                        <c:when test="${sessionScope.user != null && sessionScope.user.role == 'SELLER'}">
                            <a href="product?action=list" class="btn btn-outline-primary btn-back">
                                Quay lại danh sách
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.user != null && sessionScope.user.role == 'ADMIN'}">
                            <a href="product?action=list" class="btn btn-outline-primary btn-back">
                                Quay lại danh sách
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="home" class="btn btn-outline-primary btn-back">
                                Quay lại trang chủ
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Review Modal -->
        <div class="modal fade" id="reviewModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewModalTitle">Viết đánh giá</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="reviewForm">
                            <input type="hidden" id="reviewId" name="reviewId" value="">
                            <input type="hidden" id="productId" name="productId" value="${productBox.productId}">
                            <input type="hidden" id="reviewAction" name="action" value="add">

                            <div class="mb-3">
                                <label class="form-label">Đánh giá:</label>
                                <div class="star-input" id="starRating">
                                    <i class="far fa-star" data-rating="1"></i>
                                    <i class="far fa-star" data-rating="2"></i>
                                    <i class="far fa-star" data-rating="3"></i>
                                    <i class="far fa-star" data-rating="4"></i>
                                    <i class="far fa-star" data-rating="5"></i>
                                </div>
                                <input type="hidden" id="ratingValue" name="rating" value="5">
                            </div>

                            <div class="mb-3">
                                <label for="reviewComment" class="form-label">Nhận xét:</label>
                                <textarea class="form-control" id="reviewComment" name="comment" rows="4" 
                                          placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm..." required></textarea>
                            </div>
                        </form>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" onclick="submitReview()">Gửi đánh giá</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Modal -->
        <div class="modal fade" id="reportModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Báo cáo đánh giá</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="reportForm">
                            <input type="hidden" id="reportReviewId" name="reviewId" value="">
                            <input type="hidden" id="reportAction" name="action" value="report">

                            <div class="mb-3">
                                <label for="reportReason" class="form-label">Lý do báo cáo:</label>
                                <textarea class="form-control" id="reportReason" name="reportReason" rows="3"
                                          placeholder="Vui lòng cho biết lý do bạn báo cáo đánh giá này..." required></textarea>
                            </div>
                        </form>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-warning" onclick="submitReport()">Gửi báo cáo</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Toast Notification -->
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
            <div id="toastMessage" class="toast align-items-center text-white bg-primary border-0" role="alert">
                <div class="d-flex">
                    <div class="toast-body" id="toastText">Message here</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto"
                            data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            // Star Rating System
                            document.querySelectorAll('#starRating i').forEach(star => {
                                star.addEventListener('click', function () {
                                    const rating = this.getAttribute('data-rating');
                                    document.getElementById('ratingValue').value = rating;

                                    document.querySelectorAll('#starRating i').forEach((s, index) => {
                                        if (index < rating) {
                                            s.classList.remove('far');
                                            s.classList.add('fas');
                                        } else {
                                            s.classList.remove('fas');
                                            s.classList.add('far');
                                        }
                                    });
                                });
                            });

                            // Submit Review
                            function submitReview() {
                                const reviewId = document.getElementById('reviewId').value;
                                const productId = document.getElementById('productId').value;
                                const rating = document.getElementById('ratingValue').value;
                                const comment = document.getElementById('reviewComment').value.trim();

                                if (!comment) {
                                    alert('Vui lòng nhập nội dung đánh giá');
                                    return;
                                }

                                const form = document.getElementById('reviewForm');
                                const formData = new FormData(form);

                                formData.set('action', reviewId ? 'edit' : 'add');
                                formData.set('productId', productId);
                                formData.set('rating', rating);
                                formData.set('comment', comment);
                                if (reviewId)
                                    formData.set('reviewId', reviewId);

                                fetch('${pageContext.request.contextPath}/review', {
                                    method: 'POST',
                                    body: formData
                                })
                                        .then(res => res.json())
                                        .then(data => {
                                            showToast(data.message, data.success);
                                            if (data.success)
                                                setTimeout(() => location.reload(), 1500);
                                        })
                                        .catch(err => {
                                            console.error(err);
                                            alert('Lỗi khi gửi đánh giá');
                                        });
                            }



                            // Edit Review
                            function editReview(reviewId, rating, comment) {
                                document.getElementById('reviewModalTitle').textContent = 'Chỉnh sửa đánh giá';
                                document.getElementById('reviewId').value = reviewId;
                                document.getElementById('ratingValue').value = rating;
                                document.getElementById('reviewComment').value = comment;

                                // Set stars
                                document.querySelectorAll('#starRating i').forEach((s, index) => {
                                    if (index < rating) {
                                        s.classList.remove('far');
                                        s.classList.add('fas');
                                    } else {
                                        s.classList.remove('fas');
                                        s.classList.add('far');
                                    }
                                });

                                new bootstrap.Modal(document.getElementById('reviewModal')).show();
                            }

                            // Delete Review
                            function deleteReview(reviewId) {
                                if (!confirm('Bạn có chắc muốn xóa đánh giá này?'))
                                    return;

                                const formData = new FormData();
                                formData.append('action', 'delete');
                                formData.append('reviewId', reviewId);

                                fetch('review', {
                                    method: 'POST',
                                    body: formData
                                })
                                        .then(res => res.json())
                                        .then(data => {
                                            if (data.success) {
                                                showToast(data.message, data.success);
                                                location.reload();
                                            } else {
                                                showToast(data.message, data.success);
                                            }
                                        })
                                        .catch(err => {
                                            console.error(err);
                                            alert('Có lỗi xảy ra');
                                        });
                            }

                            // Report Review
                            function reportReview(reviewId) {
                                document.getElementById('reportReviewId').value = reviewId;
                                document.getElementById('reportReason').value = '';
                                new bootstrap.Modal(document.getElementById('reportModal')).show();
                            }

                            // Submit Report
                            function submitReport() {
                                const reviewId = document.getElementById('reportReviewId').value;
                                const reportReason = document.getElementById('reportReason').value.trim();

                                if (!reportReason) {
                                    alert('Vui lòng nhập lý do báo cáo');
                                    return;
                                }

                                const formData = new FormData();
                                formData.append('action', 'report');
                                formData.append('reviewId', reviewId);
                                formData.append('reportReason', reportReason);

                                fetch('review', {
                                    method: 'POST',
                                    body: formData
                                })
                                        .then(res => res.json())
                                        .then(data => {
                                            showToast(data.message, data.success);
                                            if (data.success)
                                                setTimeout(() => location.reload(), 1500);
                                            if (data.success) {
                                                bootstrap.Modal.getInstance(document.getElementById('reportModal')).hide();
                                            }
                                        })
                                        .catch(err => {
                                            console.error(err);
                                            alert('Có lỗi xảy ra');
                                        });
                            }

                            // Reset modal when closed
                            document.getElementById('reviewModal').addEventListener('hidden.bs.modal', function () {
                                document.getElementById('reviewModalTitle').textContent = 'Viết đánh giá';
                                document.getElementById('reviewId').value = '';
                                document.getElementById('reviewComment').value = '';
                                document.getElementById('ratingValue').value = '5';
                                document.querySelectorAll('#starRating i').forEach(s => {
                                    s.classList.remove('far');
                                    s.classList.add('fas');
                                });
                            });
                            function showToast(message, isSuccess = true) {
                                const toast = document.getElementById('toastMessage');
                                const toastText = document.getElementById('toastText');

                                toastText.textContent = message;

                                // Đổi màu theo trạng thái
                                if (isSuccess) {
                                    toast.classList.remove('bg-danger');
                                    toast.classList.add('bg-success');
                                } else {
                                    toast.classList.remove('bg-success');
                                    toast.classList.add('bg-danger');
                                }

                                const bsToast = new bootstrap.Toast(toast);
                                bsToast.show();
                            }

        </script>
    </body>
</html>