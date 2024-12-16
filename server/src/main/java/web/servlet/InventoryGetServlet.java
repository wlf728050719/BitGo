package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.Result;
import domain.info.impl.service.InventoryServiceInfo;

import service.InventoryService;
import service.impl.InventoryServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/inventoryGet")
public class InventoryGetServlet extends HttpServlet {
    private final InventoryService inventoryService=new InventoryServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String, String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method) {
                case "getStockByProductId":
                    getStockByProductId(map,resp);break;
                case "getSaleAmountByProductId":
                    getSaleAmountByProductId(map,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(new Result(InventoryServiceInfo.OTHER_ERROR,null)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }

    public void getStockByProductId(Map<String,String> map, HttpServletResponse resp) throws IOException {
        Result result = inventoryService.getStockByProductId(Integer.parseInt(map.get("productId")));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
    public void getSaleAmountByProductId(Map<String,String> map, HttpServletResponse resp) throws IOException {
        Result result = inventoryService.getSaleAmountByProductId(Integer.parseInt(map.get("productId")));
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}

