package service;

import domain.Comment;
import domain.info.Result;
import domain.info.impl.service.CommentServiceInfo;

public interface CommentService {
    Result createOriginalComment(int orderId, String description, int score);
    Result createFollowComment(int orderId, int lastId,String description);
    Result createReplyComment(int orderId, int lastId,String description);
    CommentServiceInfo deleteComment(int id);
    Result getOriginalComments(int productId);
    Result getCommentById(int id);
    Result getAllComments(int id);

    Result getAvgScoreByProductId(int id);

    Result getOriginalCommentByOrderId(int id);

    CommentServiceInfo changeScoreByOrderId(int id, int score);
}
