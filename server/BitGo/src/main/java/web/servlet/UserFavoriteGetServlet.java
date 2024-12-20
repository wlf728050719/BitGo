package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.Result;
import domain.info.impl.service.UserFavoriteServiceInfo;
import service.UserFavoriteService;
import service.impl.UserFavoriteServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
@WebServlet("/userFavoriteGet")
public class UserFavoriteGetServlet extends HttpServlet {
    private final UserFavoriteService userFavoriteService = new UserFavoriteServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method) {
                case "getUserFavoritesByUserId":getUserFavoritesByUserId(map,resp);break;
                case "getUserFavoriteByUserIdAndProductId":getUserFavoriteByUserIdAndProductId(map,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(UserFavoriteServiceInfo.OTHER_ERROR));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }
    private void getUserFavoritesByUserId(Map<String,String> map, HttpServletResponse resp) throws IOException {
        int userId = Integer.parseInt(map.get("userId"));
        Result result = userFavoriteService.getUserFavoritesByUserId(userId);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
    private void getUserFavoriteByUserIdAndProductId(Map<String,String> map, HttpServletResponse resp) throws IOException {
        int userId = Integer.parseInt(map.get("userId"));
        int productId = Integer.parseInt(map.get("productId"));
        Result result = userFavoriteService.getUserFavoriteByUserIdAndProductId(userId, productId);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
