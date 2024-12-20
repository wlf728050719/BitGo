package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.User;
import domain.info.Result;
import domain.info.impl.service.UserServiceInfo;
import service.UserService;
import service.impl.UserServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/userInfoGet")
public class UserInfoGetServlet extends HttpServlet {
    private final UserService userService=new UserServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String, String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method) {
                case "getUsernameById":getUsernameById(map,resp);break;
                case "getEmailById":getEmailById(map,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(new Result(UserServiceInfo.OTHER_ERROR,null)));
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }
    private void getUsernameById(Map<String,String> map, HttpServletResponse resp) throws IOException {
        int id=Integer.parseInt(map.get("id"));
        Result result = userService.getUserById(id);
        User user = (User) result.getValue();
        String username=user.getUsername();
        resp.getWriter().write(new ObjectMapper().writeValueAsString(username));
    }
    private void getEmailById(Map<String,String> map, HttpServletResponse resp) throws IOException {
        int id=Integer.parseInt(map.get("id"));
        Result result = userService.getUserById(id);
        User user = (User) result.getValue();
        String email=user.getEmail();
        resp.getWriter().write(new ObjectMapper().writeValueAsString(email));
    }
}
