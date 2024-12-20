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

@WebServlet("/productGet")
public class ProductGetServlet extends HttpServlet {
    ProductService productService = new ProductServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method){
                case "getRandomProducts":getRandomProducts(map,resp);break;
                case "getProductById":getProductById(map,resp);break;
                case "getProductsByTypeId":getProductsByTypeId(map,resp);break;
                case "getProductsBySellerId":getProductsBySellerId(map,resp);break;
                case "getProductsByKeyword":getProductsByKeyword(map,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(new Result(ProductServiceInfo.OTHER_ERROR,null)));
            }

        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }

    private void getRandomProducts(Map<String,String> map,HttpServletResponse resp) throws IOException {
        Result result = productService.getRandomProducts(Integer.parseInt(map.get("number")));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }

    private void getProductById(Map<String,String> map,HttpServletResponse resp) throws IOException {
        Result result = productService.getProductById(Integer.parseInt(map.get("id")));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }

    private void getProductsBySellerId(Map<String,String> map,HttpServletResponse resp) throws IOException {
        Result result = productService.getProductsBySellerId(Integer.parseInt(map.get("sellerId")));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }

    private void getProductsByTypeId(Map<String,String> map,HttpServletResponse resp) throws IOException {
        Result result = productService.getProductsByTypeId(Integer.parseInt(map.get("typeId")), Integer.parseInt(map.get("number")));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
    public void getProductsByKeyword(Map<String,String> map,HttpServletResponse resp) throws IOException {
        Result result = productService.getProductByKeyword(map.get("keyword"), Integer.parseInt(map.get("number")));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
