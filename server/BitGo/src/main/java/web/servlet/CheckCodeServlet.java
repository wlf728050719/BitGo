package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.info.impl.util.MailUtilInfo;
import util.HttpUtil;
import util.JedisUtil;
import util.MailUtil;
import util.RandomUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import java.util.Map;


@WebServlet("/checkCode")
public class CheckCodeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        try {
            req.setCharacterEncoding("utf-8");
            Map<String,String> map= HttpUtil.parseRequestBody(req);
            String email = map.get("email");
            String checkCode = RandomUtil.getRandomNumberString(6);
            JedisUtil.getJedis().setex(email,1000*60*10,checkCode);
            MailUtilInfo info = MailUtil.sendMail(email, "[BitGo]您正在进行身份验证，请勿告知他人验证码,您的验证码是:"+checkCode+",验证码十分钟有效。", "[BitGo]验证码");
            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(info);
            resp.setContentType("application/json;charset=utf-8");
            resp.getWriter().write(json);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req,resp);
    }
}
