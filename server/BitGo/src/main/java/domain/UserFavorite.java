package domain;

import java.util.Date;

public class UserFavorite {
    private int id;
    private int userId;
    private int productId;
    private Date date;

    public UserFavorite() {}
    public UserFavorite(int id, int userId, int productId, Date date) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.date = date;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
