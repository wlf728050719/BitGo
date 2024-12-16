package domain;

import java.util.Date;

public class Comment {
    private int id;
    private int orderId;
    private String description;
    private int score;
    private Date date;
    private int nextId;
    private Type type;
    public enum Type
    {
        ORIGINAL,
        FOLLOW,
        REPLY
    }
    public Comment(){}
    public Comment(int id, int orderId, String description, int score, Date date, int nextId, Type type) {
        this.id = id;
        this.orderId = orderId;
        this.description = description;
        this.score = score;
        this.date = date;
        this.nextId = nextId;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getNextId() {
        return nextId;
    }

    public void setNextId(int nextId) {
        this.nextId = nextId;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }
}
