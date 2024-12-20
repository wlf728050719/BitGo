package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.Result;
import domain.info.impl.service.ProductServiceInfo;
import service.ProductService;
import service.impl.ProductServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/productSet")
public class ProductSetServlet extends HttpServlet {
    ProductService productService = new ProductServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
       try {
           Map<String,String> map = HttpUtil.parseRequestBody(req);
           resp.setContentType("application/json;charset=utf-8");
           String method = map.get("method");
           switch (method){
               case "publishProduct":publishProduct(map,req,resp);break;
               default:resp.getWriter().write(new ObjectMapper().writeValueAsString(new Result(ProductServiceInfo.OTHER_ERROR,null)));
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }
    private void publishProduct(Map<String,String> map,HttpServletRequest req,HttpServletResponse resp) throws IOException {
        String name = map.get("name");
        double price = Double.parseDouble(map.get("price"));
        String description = map.get("description");
        String location = map.get("location");
        int typeId = Integer.parseInt(map.get("typeId"));
        String sellerId = (String) req.getAttribute("userId");
        Result result = productService.publishProduct(name,description,price,location,typeId, Integer.parseInt(sellerId));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
