package web.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Comment;
import domain.info.Result;
import domain.info.impl.service.CommentServiceInfo;
import service.CommentService;
import service.impl.CommentServiceImpl;
import util.HttpUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/commentGet")
public class CommentGetServlet extends HttpServlet {
    private final CommentService commentService = new CommentServiceImpl();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
       try {
           Map<String,String> map = HttpUtil.parseRequestBody(req);
           resp.setContentType("application/json;charset=utf-8");
           String method = map.get("method");
           switch (method){
               case "getOriginalComments":getOriginalComments(map,resp);break;
               case "getAllComments":getAllComments(map,resp);break;
               case "getAvgScoreByProductId":getAvgScoreByProductId(map,resp);break;
               case "getAllCommentsByOrderId":getAllCommentsByOrderId(map,resp);break;
               default:resp.getWriter().write(new ObjectMapper().writeValueAsString(CommentServiceInfo.OTHER_ERROR));
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp){
        doPost(req, resp);
    }
    private void getOriginalComments(Map<String,String> map, HttpServletResponse resp) throws IOException {
        int productId = Integer.parseInt(map.get("productId"));
        Result result = commentService.getOriginalComments(productId);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
    private void getAllComments(Map<String,String> map, HttpServletResponse resp) throws IOException {
        int id=Integer.parseInt(map.get("id"));
        Result result = commentService.getAllComments(id);
        resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
    private void getAvgScoreByProductId(Map<String,String> map, HttpServletResponse resp) throws IOException {
        int id=Integer.parseInt(map.get("id"));
        Result result = commentService.getAvgScoreByProductId(id);
        double avgScore = 5;
        if(result.getValue()!=null){
            avgScore = (double) result.getValue();
        }
        resp.getWriter().write(new ObjectMapper().writeValueAsString(avgScore));
    }
    private void getAllCommentsByOrderId(Map<String,String> map, HttpServletResponse resp) throws IOException{
        int id=Integer.parseInt(map.get("id"));
        Result result = commentService.getOriginalCommentByOrderId(id);
        if(result.getValue()!=null){
            Comment comment = (Comment) result.getValue();
            resp.getWriter().write(new ObjectMapper().writeValueAsString(commentService.getAllComments(comment.getId())));
        }
        else
            resp.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
