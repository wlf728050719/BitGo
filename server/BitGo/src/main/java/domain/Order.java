package domain;

import java.util.Date;

public class Order {
    private int id;
    private int buyerId;
    private int productId;
    private int amount;
    private String phone;
    private String shippingAddress;
    private String recipientName;
    private Status status;
    private Date date;
    public enum Status {
        PENDING,
        PREPARED,
        SHIPPED,
        DELIVERED,
        CANCELED
    }
    public Order() {}

    public Order(Date date, Status status, String recipientName, String shippingAddress, String phone, int amount, int productId, int buyerId, int id) {
        this.date = date;
        this.status = status;
        this.recipientName = recipientName;
        this.shippingAddress = shippingAddress;
        this.phone = phone;
        this.amount = amount;
        this.productId = productId;
        this.buyerId = buyerId;
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(int buyerId) {
        this.buyerId = buyerId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
