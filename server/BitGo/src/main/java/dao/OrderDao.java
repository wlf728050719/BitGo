package dao;

import domain.Order;
import domain.info.Result;
import domain.info.impl.dao.OrderDaoInfo;

public interface OrderDao {
    OrderDaoInfo createOrder(int buyerId, int productId, int amount, String phone, String shippingAddress, String recipientName);
    Result getOrderById(int id);
    Result getOrdersByBuyerIdAndSearchWord(int buyerId, String searchWord);
    Result getOrdersBySellerIdAndSearchWord(int sellerId,String searchWord);
    OrderDaoInfo changeOrderStatus(int id, Order.Status status);
    OrderDaoInfo changeOrderBaseInfo(int id,int amount,String phone,String shippingAddress,String recipientName);
}
