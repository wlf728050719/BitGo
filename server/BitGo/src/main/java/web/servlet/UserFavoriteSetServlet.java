package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
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
@WebServlet("/userFavoriteSet")
public class UserFavoriteSetServlet extends HttpServlet {
    private final UserFavoriteService userFavoriteService = new UserFavoriteServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method) {
                case "addUserFavorite":addUserFavorite(map,req,resp);break;
                case "removeUserFavorite":removeUserFavorite(map,req,resp);break;
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
    private void addUserFavorite(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = (String) req.getAttribute("userId");
        int userId = Integer.parseInt(map.get("userId"));
        int productId = Integer.parseInt(map.get("productId"));
        if(id!=null&&userId==Integer.parseInt(id))
        {
            UserFavoriteServiceInfo info = userFavoriteService.addUserFavorite(userId, productId);
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }
        else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(UserFavoriteServiceInfo.OTHER_ERROR));
    }
    private void removeUserFavorite(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = (String) req.getAttribute("userId");
        int userId = Integer.parseInt(map.get("userId"));
        int productId = Integer.parseInt(map.get("productId"));
        if(id!=null&&userId==Integer.parseInt(id))
        {
            UserFavoriteServiceInfo info = userFavoriteService.removeUserFavorite(userId, productId);
            resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
        }
        else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(UserFavoriteServiceInfo.OTHER_ERROR));
    }
}
