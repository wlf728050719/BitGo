package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Order;
import domain.Product;
import domain.info.Info;
import domain.info.impl.service.CommentServiceInfo;
import service.CommentService;
import service.OrderService;
import service.ProductService;
import service.impl.CommentServiceImpl;
import service.impl.OrderServiceImpl;
import service.impl.ProductServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/commentSet")
public class CommentSetServlet extends HttpServlet {
    private final CommentService commentService = new CommentServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();
    private final ProductService productService = new ProductServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method){
                case "createOriginalComment":createOriginalComment(map,req,resp);break;
                case "createFollowComment":createFollowComment(map,req,resp);break;
                case "createReplyComment":createReplyComment(map,req,resp);break;
                case "changeScoreByOrderId":changeScoreByOrderId(map,req,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(CommentServiceInfo.OTHER_ERROR));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }
    private void createOriginalComment(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId = (String) req.getAttribute("userId");
        int orderId = Integer.parseInt(map.get("orderId"));
        String description = map.get("description");
        int score = Integer.parseInt(map.get("score"));
        Order order= (Order) orderService.getOrderById(orderId).getValue();
        if(Integer.parseInt(userId)==order.getBuyerId())
        {
            Info info=commentService.createOriginalComment(orderId,description,score).getInfo();
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(CommentServiceInfo.OTHER_ERROR));
    }
    private void createFollowComment(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId = (String) req.getAttribute("userId");
        int orderId = Integer.parseInt(map.get("orderId"));
        int lastId = Integer.parseInt(map.get("lastId"));
        String description = map.get("description");
        Order order= (Order) orderService.getOrderById(orderId).getValue();
        if(Integer.parseInt(userId)==order.getBuyerId())
        {
            Info info=commentService.createFollowComment(orderId,lastId,description).getInfo();
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(CommentServiceInfo.OTHER_ERROR));
    }
    private void createReplyComment(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId = (String) req.getAttribute("userId");
        int orderId = Integer.parseInt(map.get("orderId"));
        int lastId = Integer.parseInt(map.get("lastId"));
        String description = map.get("description");
        Order order= (Order) orderService.getOrderById(orderId).getValue();
        Product product = (Product) productService.getProductById(order.getProductId()).getValue();
        if(Integer.parseInt(userId)==product.getSellerId())
        {
            Info info=commentService.createReplyComment(orderId,lastId,description).getInfo();
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(CommentServiceInfo.OTHER_ERROR));
    }
    private void changeScoreByOrderId(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId = (String) req.getAttribute("userId");
        int orderId = Integer.parseInt(map.get("orderId"));
        int score = Integer.parseInt(map.get("score"));
        Order order= (Order) orderService.getOrderById(orderId).getValue();
        if(Integer.parseInt(userId)==order.getBuyerId())
        {
            Info info=commentService.changeScoreByOrderId(orderId,score);
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(CommentServiceInfo.OTHER_ERROR));
    }
}
