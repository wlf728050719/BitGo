package service.impl;

import dao.CommentDao;
import dao.impl.CommentDaoImpl;
import domain.info.Info;
import domain.info.Result;
import domain.info.impl.dao.CommentDaoInfo;
import domain.info.impl.service.CommentServiceInfo;
import service.CommentService;

public class CommentServiceImpl implements CommentService {
    private final CommentDao commentDao=new CommentDaoImpl();

    private Result changeToCommentServiceResult(Result result) {
        switch ((CommentDaoInfo)result.getInfo())
        {
            case SUCCESS:return new Result(CommentServiceInfo.SUCCESS,result.getValue());
            case EMPTY_RESULT:return new Result(CommentServiceInfo.EMPTY_RESULT,null);
            default:return new Result(CommentServiceInfo.OTHER_ERROR,null);
        }
    }
    private CommentServiceInfo changeToCommentServiceInfo(Info info) {
        switch ((CommentDaoInfo)info)
        {
            case SUCCESS:return CommentServiceInfo.SUCCESS;
            case EMPTY_RESULT:return CommentServiceInfo.EMPTY_RESULT;
            default:return CommentServiceInfo.OTHER_ERROR;
        }
    }

    @Override
    public Result createOriginalComment(int orderId, String description, int score) {
        return changeToCommentServiceResult(commentDao.createOriginalComment(orderId, description, score));
    }

    @Override
    public Result createFollowComment(int orderId, int lastId, String description) {
        return changeToCommentServiceResult(commentDao.createFollowComment(orderId, lastId, description));
    }

    @Override
    public Result createReplyComment(int orderId, int lastId, String description) {
        return changeToCommentServiceResult(commentDao.createReplyComment(orderId, lastId, description));
    }

    @Override
    public CommentServiceInfo deleteComment(int id) {
        return changeToCommentServiceInfo(commentDao.deleteComment(id));
    }

    @Override
    public Result getOriginalComments(int productId) {
        return changeToCommentServiceResult(commentDao.getOriginalComments(productId));
    }

    @Override
    public Result getCommentById(int id) {
        return changeToCommentServiceResult(commentDao.getCommentById(id));
    }

    @Override
    public Result getAllComments(int id) {
        return changeToCommentServiceResult(commentDao.getAllComments(id));
    }

    @Override
    public Result getAvgScoreByProductId(int id) {
        return changeToCommentServiceResult(commentDao.getAvgScoreByProductId(id));
    }

    @Override
    public Result getOriginalCommentByOrderId(int id)
    {
        return changeToCommentServiceResult(commentDao.getOriginalCommentByOrderId(id));
    }
    @Override
    public CommentServiceInfo changeScoreByOrderId(int id, int score)
    {
        return changeToCommentServiceInfo(commentDao.changeScoreByOrderId(id,score));
    }
}
