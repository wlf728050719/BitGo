package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.impl.service.UserServiceInfo;
import service.UserService;
import service.impl.UserServiceImpl;
import util.HttpUtil;


import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    UserService service = new UserServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)  {
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            int id = Integer.parseInt(map.get("id"));
            ObjectMapper mapper = new ObjectMapper();
            UserServiceInfo info = service.logout(id);
            String json = mapper.writeValueAsString(info);
            resp.setContentType("application/json;charset=utf-8");
            resp.getWriter().write(json);
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)  {
        doPost(req, resp);
    }
}
