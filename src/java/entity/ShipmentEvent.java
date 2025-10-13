// entity/ShipmentEvent.java
package entity;

import java.sql.Timestamp;

public class ShipmentEvent {

    private int eventId;
    private int shipmentId;
    private String status;
    private Timestamp eventTime;
    private String location;

    public ShipmentEvent() {
    }

    public ShipmentEvent(int eventId, int shipmentId, String status,
            Timestamp eventTime, String location) {
        this.eventId = eventId;
        this.shipmentId = shipmentId;
        this.status = status;
        this.eventTime = eventTime;
        this.location = location;
    }

    // Getters & Setters
    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public int getShipmentId() {
        return shipmentId;
    }

    public void setShipmentId(int shipmentId) {
        this.shipmentId = shipmentId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getEventTime() {
        return eventTime;
    }

    public void setEventTime(Timestamp eventTime) {
        this.eventTime = eventTime;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
