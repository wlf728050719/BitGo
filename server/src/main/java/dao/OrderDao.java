package dao;

import domain.Order;
import domain.info.Result;
import domain.info.impl.dao.OrderDaoInfo;

public interface OrderDao {
    OrderDaoInfo createOrder(int buyerId, int productId, int amount, String phone, String shippingAddress, String recipientName);
    Result getOrderById(int id);
    Result getOrdersByBuyerId(int buyerId);
    Result getOrdersBySellerId(int sellerId);
    OrderDaoInfo changeOrderStatus(int id, Order.Status status);
    OrderDaoInfo changeOrderBaseInfo(int id,int amount,String phone,String shippingAddress,String recipientName);
}
