package dao;

import domain.info.Result;
import domain.info.impl.dao.CommentDaoInfo;

public interface CommentDao {
    Result createOriginalComment(int orderId, String description, int score);
    Result createFollowComment(int orderId, int lastId,String description);
    Result createReplyComment(int orderId, int lastId,String description);
    CommentDaoInfo deleteComment(int id);
    Result getOriginalComments(int productId);
    Result getCommentById(int id);
    Result getAllComments(int id);

    Result getAvgScoreByProductId(int id);

    Result getOriginalCommentByOrderId(int id);

    CommentDaoInfo changeScoreByOrderId(int id, int score);
}
