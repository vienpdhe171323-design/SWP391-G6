/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class Shipment {

    private int shipmentId;
    private int orderId;
    private String carrier;
    private String trackingNumber;
    private String status;  // PENDING, PICKED, DELIVERED
    private Timestamp shippedAt;

    public Shipment() {
    }

    public Shipment(int shipmentId, int orderId, String carrier, String trackingNumber, String status, Timestamp shippedAt) {
        this.shipmentId = shipmentId;
        this.orderId = orderId;
        this.carrier = carrier;
        this.trackingNumber = trackingNumber;
        this.status = status;
        this.shippedAt = shippedAt;
    }

    public int getShipmentId() {
        return shipmentId;
    }

    public void setShipmentId(int shipmentId) {
        this.shipmentId = shipmentId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getCarrier() {
        return carrier;
    }

    public void setCarrier(String carrier) {
        this.carrier = carrier;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getShippedAt() {
        return shippedAt;
    }

    public void setShippedAt(Timestamp shippedAt) {
        this.shippedAt = shippedAt;
    }

}
