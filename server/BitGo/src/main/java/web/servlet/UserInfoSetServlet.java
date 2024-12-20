package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.Info;
import domain.info.Result;
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
import java.io.IOException;
import java.util.Map;

@WebServlet("/userInfoSet")
public class UserInfoSetServlet extends HttpServlet {
    private final UserService userService=new UserServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            Map<String, String> map = HttpUtil.parseRequestBody(req);
            resp.setContentType("application/json;charset=utf-8");
            String method = map.get("method");
            switch (method) {
                case "changeUsername": changeUsername(map,req,resp);break;
                case "changePassword":changePassword(map,req,resp);break;
                case "changeEmail":changeEmail(map,req,resp);break;
                default:resp.getWriter().write(new ObjectMapper().writeValueAsString(new Result(UserServiceInfo.OTHER_ERROR,null)));
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        doPost(req,resp);
    }
    private void changeUsername(Map<String,String> map, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username=map.get("username");
        String id= (String) req.getAttribute("userId");
        UserServiceInfo userServiceInfo = userService.changeUsername(Integer.parseInt(id),username);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(userServiceInfo));
    }
    private void changePassword(Map<String,String> map, HttpServletRequest req,HttpServletResponse resp) throws Exception {
        String password=map.get("password");
        String md5_password = Md5Util.encodeByMd5(password);
        String id= (String) req.getAttribute("userId");
        UserServiceInfo userServiceInfo = userService.changePassword(Integer.parseInt(id),md5_password);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(userServiceInfo));
    }
    private void changeEmail(Map<String,String> map, HttpServletRequest req,HttpServletResponse resp) throws Exception {
        String id= (String) req.getAttribute("userId");
        String oldEmail=map.get("oldEmail");
        String newEmail=map.get("newEmail");
        String oldEmailCheckCode=map.get("oldEmailCheckCode");
        String newEmailCheckCode=map.get("newEmailCheckCode");
        if(oldEmail==null||newEmail==null||oldEmailCheckCode==null||newEmailCheckCode==null){
            resp.getWriter().write(new ObjectMapper().writeValueAsString(UserServiceInfo.INFO_MISSING));
            return;
        }
        String checkCode_old = JedisUtil.getJedis().get(oldEmail);
        String checkCode_new = JedisUtil.getJedis().get(newEmail);
        Info info;
        if(checkCode_old==null&&checkCode_new==null){
            info = UserServiceInfo.CHECK_CODE_EXPIRED;
        }
        else
        {
            if(oldEmailCheckCode.equals(checkCode_old)&&newEmailCheckCode.equals(checkCode_new)){
                info = userService.changeEmail(Integer.parseInt(id),newEmail);
            }
            else
                info = UserServiceInfo.CHECK_CODE_ERROR;
        }
        resp.getWriter().write(new ObjectMapper().writeValueAsString(info));
    }
}
