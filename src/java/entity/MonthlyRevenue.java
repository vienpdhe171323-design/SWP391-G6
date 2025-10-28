package entity;

public class MonthlyRevenue {

    private int month;
    private double revenue;

    public MonthlyRevenue() {
    }

    public MonthlyRevenue(int month, double revenue) {
        this.month = month;
        this.revenue = revenue;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
