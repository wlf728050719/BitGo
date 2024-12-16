package dao;

import dao.impl.CommentDaoImpl;
import domain.info.Result;
import domain.info.impl.dao.CommentDaoInfo;
import org.junit.Assert;
import org.junit.Test;

public class CommentDaoImplTest {
    private final CommentDao commentDao=new CommentDaoImpl();
    @Test
    public void testCreateOriginalComment() {
        Result result = commentDao.createOriginalComment(1,"差评",2);
        Assert.assertEquals(result.getInfo(),CommentDaoInfo.SUCCESS);
        Assert.assertEquals(CommentDaoInfo.SUCCESS,commentDao.deleteComment((int)result.getValue()));
    }
    @Test
    public void testCreateFollowComment() {
        int id1= (int) commentDao.createOriginalComment(1,"1",1).getValue();
        int id2= (int) commentDao.createFollowComment(1,id1,"2").getValue();
        int id3= (int) commentDao.createFollowComment(1,id2,"3").getValue();
        int id4= (int) commentDao.createFollowComment(1,id3,"4").getValue();
        Assert.assertEquals(CommentDaoInfo.SUCCESS,commentDao.deleteComment(id1));
        Assert.assertEquals(CommentDaoInfo.EMPTY_RESULT,commentDao.getCommentById(id4).getInfo());
    }
}
