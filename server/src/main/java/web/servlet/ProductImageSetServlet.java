package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Product;
import domain.info.Result;
import domain.info.impl.service.ProductImageServiceInfo;
import service.ProductImageService;
import service.ProductService;
import service.impl.ProductImageServiceImpl;
import service.impl.ProductServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/productImageSet")
public class ProductImageSetServlet extends HttpServlet {
    private final ProductImageService productImageService = new ProductImageServiceImpl();
    private final ProductService productService = new ProductServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method)
            {
                case "createProductImages":createProductImages(map,req,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(new Result(ProductImageServiceInfo.OTHER_ERROR,null)));
            }

        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }

    public void createProductImages(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String[] images = map.get("images").split(",");
        int productId = Integer.parseInt(map.get("productId"));
        String sellerId = (String) req.getAttribute("userId");
        Product product = (Product) productService.getProductById(productId).getValue();
        if(product!=null&&Integer.parseInt(sellerId)==product.getSellerId())
        {
            ProductImageServiceInfo info = productImageService.createProductImages(productId, images);
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }
        else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(ProductImageServiceInfo.OTHER_ERROR));
    }
}
