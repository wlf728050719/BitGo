package service;

import domain.Order;
import domain.info.Result;
import domain.info.impl.service.OrderServiceInfo;

public interface OrderService {
    OrderServiceInfo createOrder(int buyerId, int productId, int amount, String phone, String shippingAddress, String recipientName);
    OrderServiceInfo changeOrderBaseInfo(int id,int amount,String phone,String shippingAddress,String recipientName);
    OrderServiceInfo changeOrderStatus(int id, Order.Status status);
    Result getOrdersByBuyerIdAndSearchWord(int buyerId, String searchWord);
    Result getOrdersBySellerIdAndSearchWord(int sellerId,String searchWord);
    Result getOrderById(int id);
}
