package entity;

import java.sql.Timestamp;

public class ReviewReport {
    private int reportId;
    private int reviewId;
    private int reportedBy;
    private String reportReason;
    private Timestamp reportedAt;
    private String status; // PENDING, REVIEWED, RESOLVED

    public ReviewReport() {
    }

    public ReviewReport(int reportId, int reviewId, int reportedBy, String reportReason, Timestamp reportedAt, String status) {
        this.reportId = reportId;
        this.reviewId = reviewId;
        this.reportedBy = reportedBy;
        this.reportReason = reportReason;
        this.reportedAt = reportedAt;
        this.status = status;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(int reportedBy) {
        this.reportedBy = reportedBy;
    }

    public String getReportReason() {
        return reportReason;
    }

    public void setReportReason(String reportReason) {
        this.reportReason = reportReason;
    }

    public Timestamp getReportedAt() {
        return reportedAt;
    }

    public void setReportedAt(Timestamp reportedAt) {
        this.reportedAt = reportedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ReviewReport{" +
                "reportId=" + reportId +
                ", reviewId=" + reviewId +
                ", reportedBy=" + reportedBy +
                ", reportReason='" + reportReason + '\'' +
                ", reportedAt=" + reportedAt +
                ", status='" + status + '\'' +
                '}';
    }
}
