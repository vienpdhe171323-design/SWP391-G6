/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.util.Date;
import java.math.BigDecimal;

public class PaymentTransaction {

    private int transactionId;
    private int orderId;
    private String vnpTxnRef;
    private BigDecimal amount;
    private String status;
    private Date createdAt;

    public PaymentTransaction() {
    }

    public PaymentTransaction(int transactionId, int orderId, String vnpTxnRef,
            BigDecimal amount, String status, Date createdAt) {
        this.transactionId = transactionId;
        this.orderId = orderId;
        this.vnpTxnRef = vnpTxnRef;
        this.amount = amount;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and setters
    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getVnpTxnRef() {
        return vnpTxnRef;
    }

    public void setVnpTxnRef(String vnpTxnRef) {
        this.vnpTxnRef = vnpTxnRef;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
