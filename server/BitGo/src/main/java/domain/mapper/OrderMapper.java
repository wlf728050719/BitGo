package domain.mapper;

import domain.Order;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderMapper implements RowMapper<Order> {
    @Override
    public Order mapRow(ResultSet rs, int rowNum) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setBuyerId(rs.getInt("buyer_id"));
        order.setProductId(rs.getInt("product_id"));
        order.setAmount(rs.getInt("amount"));
        order.setPhone(rs.getString("phone"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setRecipientName(rs.getString("recipient_name"));
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            order.setStatus(Order.Status.valueOf(statusStr.toUpperCase())); // 转换为大写以匹配枚举
        }
        order.setDate(rs.getDate("date"));
        return order;
    }
}
