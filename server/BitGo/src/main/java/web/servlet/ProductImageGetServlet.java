package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ProductImage;
import service.ProductImageService;
import service.impl.ProductImageServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/productImageGet")
public class ProductImageGetServlet extends HttpServlet {

    private final ProductImageService productImageService = new ProductImageServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            Map<String, String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            int id = Integer.parseInt(map.get("id"));
            List<?> images = (List<?>) productImageService.getImagesByProductId(id).getValue();
            List<String> urls = new ArrayList<>();
            for (Object obj : images) {
                if (obj instanceof ProductImage) {
                    ProductImage image = (ProductImage) obj; // 安全转换
                    urls.add(image.getImageUrl());
                }
            }
            resp.getWriter().write(new ObjectMapper().writeValueAsString(urls));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        doPost(req, resp);
    }
}
