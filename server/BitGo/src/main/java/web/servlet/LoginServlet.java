package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.User;
import domain.info.Result;
import domain.info.impl.service.UserServiceInfo;
import service.UserService;
import service.impl.UserServiceImpl;
import util.HttpUtil;
import util.JwtUtil;
import util.Md5Util;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    UserService service = new UserServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
       try {
           Map<String,String> map = HttpUtil.parseRequestBody(req);
           String account = map.get("account");
           String password = Md5Util.encodeByMd5(map.get("password"));
           Result result = service.login(account, password);
           resp.setContentType("application/json;charset=utf-8");
           ObjectMapper mapper = new ObjectMapper();
           if (result.getInfo().equals(UserServiceInfo.SUCCESS)) {
               int id = ((User)result.getValue()).getId();
               String token = JwtUtil.generateToken(String.valueOf(id));
               Map<String, Object> responseMap = new HashMap<>();
               responseMap.put("token", token);
               responseMap.put("result", result);
               mapper.writeValue(resp.getWriter(),responseMap);
           } else {
               String json = mapper.writeValueAsString(result);
               resp.getWriter().write(json);
           }
       }catch (Exception e){
            e.printStackTrace();
       }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        doPost(req, resp);
    }
}
