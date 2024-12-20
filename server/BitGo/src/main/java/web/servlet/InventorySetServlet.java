package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Product;
import domain.info.impl.service.InventoryServiceInfo;
import service.InventoryService;
import service.ProductService;
import service.impl.InventoryServiceImpl;
import service.impl.ProductServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/inventorySet")
public class InventorySetServlet extends HttpServlet {
    private final InventoryService inventoryService= new InventoryServiceImpl();
    private final ProductService productService= new ProductServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
       try {
           Map<String,String> map = HttpUtil.parseRequestBody(req);
           resp.setContentType("application/json;charset=utf-8");
           String method = map.get("method");
           switch (method){
               case "setStockByProductId":setStockByProductId(map,req,resp);break;
               default:resp.getWriter().write(new ObjectMapper().writeValueAsString(InventoryServiceInfo.OTHER_ERROR));
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }

    private void setStockByProductId(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException{
        String sellerId = (String) req.getAttribute("userId");
        int productId = Integer.parseInt(map.get("productId"));
        int stock = Integer.parseInt(map.get("stock"));
        Product product = (Product)productService.getProductById(productId).getValue();
        if(Integer.parseInt(sellerId)==product.getSellerId()){
            InventoryServiceInfo info = inventoryService.setStockByProductId(productId,stock);
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(InventoryServiceInfo.OTHER_ERROR));
    }

}
