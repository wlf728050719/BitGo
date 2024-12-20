package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Order;
import domain.Product;
import domain.info.impl.service.OrderServiceInfo;
import service.InventoryService;
import service.OrderService;
import service.ProductService;
import service.impl.InventoryServiceImpl;
import service.impl.OrderServiceImpl;
import service.impl.ProductServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/orderSet")
public class OrderSetServlet extends HttpServlet {
    private final OrderService orderService=new OrderServiceImpl();
    private final ProductService productService=new ProductServiceImpl();
    private final InventoryService inventoryService=new InventoryServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method){
                case "createOrder":createOrder(map,req,resp);break;
                case "changeOrderStatus":changeOrderStatus(map,req,resp);break;
                case "changeOrderBaseInfo":changeOrderBaseInfo(map,req,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(OrderServiceInfo.OTHER_ERROR));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }
    private void createOrder(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException{
        String buyerId = (String) req.getAttribute("userId");
        int productId = Integer.parseInt(map.get("productId"));
        int amount = Integer.parseInt(map.get("amount"));
        String phone = map.get("phone");
        String shippingAddress = map.get("shippingAddress");
        String recipientName = map.get("recipientName");
        OrderServiceInfo info = orderService.createOrder(Integer.parseInt(buyerId),productId,amount,phone,shippingAddress,recipientName);
        if(info==OrderServiceInfo.SUCCESS)
            resp.getWriter().write(new ObjectMapper().writeValueAsString(inventoryService.addStockAndSubSaleAmount(productId,-amount)));
        else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
    }

    private void changeOrderStatus(Map<String,String> map,HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userIdStr = (String) req.getAttribute("userId");
        int userId = Integer.parseInt(userIdStr);
        int id = Integer.parseInt(map.get("id"));
        String status = map.get("status");
        Order order = (Order) orderService.getOrderById(id).getValue();
        Product product = (Product) productService.getProductById(order.getProductId()).getValue();
        if(order.getBuyerId()==userId||product.getSellerId()==userId)
        {
            OrderServiceInfo info = orderService.changeOrderStatus(id,Order.Status.valueOf(status));
            if(info==OrderServiceInfo.SUCCESS&&Order.Status.valueOf(status)== Order.Status.CANCELED)
                resp.getWriter().write(new ObjectMapper().writeValueAsString(inventoryService.addStockAndSubSaleAmount(order.getProductId(),order.getAmount())));
            else
                resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }
        else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(OrderServiceInfo.OTHER_ERROR));
    }
    private void changeOrderBaseInfo(Map<String,String> map,HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userIdStr = (String) req.getAttribute("userId");
        int userId = Integer.parseInt(userIdStr);
        int id = Integer.parseInt(map.get("id"));
        int amount = Integer.parseInt(map.get("amount"));
        String phone = map.get("phone");
        String shippingAddress = map.get("shippingAddress");
        String recipientName = map.get("recipientName");
        Order order = (Order) orderService.getOrderById(id).getValue();
        if(order.getBuyerId()==userId)
        {
            OrderServiceInfo info = orderService.changeOrderBaseInfo(id,amount,phone,shippingAddress,recipientName);
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }
        else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(OrderServiceInfo.OTHER_ERROR));
    }
}
