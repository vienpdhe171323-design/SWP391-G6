package entity;

public class Attribute {

    private int attributeId;
    private String attributeName;

    public Attribute() {
    }

    public Attribute(int attributeId, String attributeName) {
        this.attributeId = attributeId;
        this.attributeName = attributeName;
    }

    public Attribute(String attributeName) {
        this.attributeName = attributeName;
    }

    public int getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(int attributeId) {
        this.attributeId = attributeId;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    @Override
    public String toString() {
        return "Attribute{"
                + "attributeId=" + attributeId
                + ", attributeName='" + attributeName + '\''
                + '}';
    }
}
