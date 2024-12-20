package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;

import domain.info.Result;
import domain.info.impl.service.OrderServiceInfo;
import service.OrderService;
import service.impl.OrderServiceImpl;
import util.HttpUtil;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import java.util.Map;

@WebServlet("/orderGet")
public class OrderGetServlet extends HttpServlet {
    private final OrderService orderService=new OrderServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method){
                case "getBuyOrdersContainsSearchWord": getBuyOrdersContainsSearchWord(map,resp);break;
                case "getSellOrdersContainsSearchWord":getSellOrdersContainsSearchWord(map,resp);break;
                case "getOrderById":getOrderById(map,resp);break;
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
    private void getBuyOrdersContainsSearchWord(Map<String,String> map, HttpServletResponse resp) throws IOException{
        String buyerId = map.get("userId");
        String searchWord = map.get("searchWord");
        Result result = orderService.getOrdersByBuyerIdAndSearchWord(Integer.parseInt(buyerId),searchWord);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
    private void getSellOrdersContainsSearchWord(Map<String,String> map,HttpServletResponse resp) throws IOException {
        String sellerId = map.get("userId");
        String searchWord = map.get("searchWord");
        if(searchWord==null)
            searchWord="";
        Result result = orderService.getOrdersBySellerIdAndSearchWord(Integer.parseInt(sellerId),searchWord);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
    private void getOrderById(Map<String,String> map,HttpServletResponse resp) throws IOException {
        String id= map.get("id");
        Result result=orderService.getOrderById(Integer.parseInt(id));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
