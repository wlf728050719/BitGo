package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.impl.service.UserServiceInfo;
import service.UserService;
import service.impl.UserServiceImpl;
import util.HttpUtil;
import util.JedisUtil;
import util.Md5Util;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    UserService service = new UserServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            Map<String,String> map = HttpUtil.parseRequestBody(req);
            String account = map.get("account");
            String password = map.get("password");
            String username = map.get("username");
            String email = map.get("email");
            String code = map.get("code");

            String md5_password = Md5Util.encodeByMd5(password);
            String checkCode = JedisUtil.getJedis().get(email);
            UserServiceInfo info;
            if(checkCode==null){
                info = UserServiceInfo.CHECK_CODE_EXPIRED;
            }else
            {
                if(code.equals(checkCode)){
                    req.getSession().removeAttribute("checkCode");
                    info =service.register(account,username,md5_password,email);
                    if(info==UserServiceInfo.SUCCESS)
                        JedisUtil.getJedis().del(email);
                }else
                {
                    info=UserServiceInfo.CHECK_CODE_ERROR;
                }
            }
            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(info);
            resp.setContentType("application/json;charset=utf-8");
            resp.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }
}
