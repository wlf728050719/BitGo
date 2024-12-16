package service.impl;

import dao.OrderDao;
import dao.impl.OrderDaoImpl;
import domain.Order;
import domain.info.Info;
import domain.info.Result;
import domain.info.impl.dao.OrderDaoInfo;
import domain.info.impl.service.OrderServiceInfo;
import service.OrderService;

public class OrderServiceImpl implements OrderService {
    private final OrderDao orderDao = new OrderDaoImpl();
    private Result changeToOrderServiceResult(Result result) {
        switch ((OrderDaoInfo)result.getInfo())
        {
            case SUCCESS:return new Result(OrderServiceInfo.SUCCESS,result.getValue());
            case EMPTY_RESULT:return new Result(OrderServiceInfo.EMPTY_RESULT,null);
            default:return new Result(OrderServiceInfo.OTHER_ERROR,null);
        }
    }
    private OrderServiceInfo changeToOrderServiceInfo(Info info) {
        switch ((OrderDaoInfo)info)
        {
            case SUCCESS:return OrderServiceInfo.SUCCESS;
            case EMPTY_RESULT:return OrderServiceInfo.EMPTY_RESULT;
            default:return OrderServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public OrderServiceInfo createOrder(int buyerId, int productId, int amount, String phone, String shippingAddress, String recipientName) {
        return changeToOrderServiceInfo(orderDao.createOrder(buyerId,productId,amount,phone,shippingAddress,recipientName));
    }

    @Override
    public OrderServiceInfo changeOrderBaseInfo(int id, int amount, String phone, String shippingAddress, String recipientName) {
        return changeToOrderServiceInfo(orderDao.changeOrderBaseInfo(id,amount,phone,shippingAddress,recipientName));
    }

    @Override
    public OrderServiceInfo changeOrderStatus(int id, Order.Status status) {
        return changeToOrderServiceInfo(orderDao.changeOrderStatus(id,status));
    }

    @Override
    public Result getOrdersByBuyerId(int buyerId) {
        return changeToOrderServiceResult(orderDao.getOrdersByBuyerId(buyerId));
    }

    @Override
    public Result getOrdersBySellerId(int sellerId) {
        return changeToOrderServiceResult(orderDao.getOrdersBySellerId(sellerId));
    }
    @Override
    public Result getOrderById(int id) {
        return changeToOrderServiceResult(orderDao.getOrderById(id));
    }
}
