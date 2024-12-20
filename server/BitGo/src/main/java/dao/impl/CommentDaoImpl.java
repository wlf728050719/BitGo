package dao.impl;

import com.mysql.jdbc.Statement;
import dao.CommentDao;
import domain.Comment;

import domain.info.Result;
import domain.info.impl.dao.CommentDaoInfo;
import domain.mapper.CommentMapper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import util.JDBCUtil;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

public class CommentDaoImpl implements CommentDao {
    private static final JdbcTemplate jdbcTemplate = new JdbcTemplate(JDBCUtil.getDataSource());

    private CommentDaoInfo executeUpdate(String sql, Object... args) {
        try {
            jdbcTemplate.update(sql, args);
        } catch (DuplicateKeyException e) {
            return CommentDaoInfo.DUPLICATE_KEY;
        } catch (NullPointerException e) {
            return CommentDaoInfo.INFO_MISSING;
        } catch (Exception e) {
            e.printStackTrace();
            return CommentDaoInfo.OTHER_ERROR;
        }
        return CommentDaoInfo.SUCCESS;
    }

    private Result executeQuery(String sql, boolean isList, Object... args) {
        try {
            if (isList) {
                List<Comment> comments = jdbcTemplate.query(sql, new CommentMapper(), args);
                return new Result(CommentDaoInfo.SUCCESS, comments);
            } else {
                Comment comment = jdbcTemplate.queryForObject(sql, new CommentMapper(), args);
                return new Result(CommentDaoInfo.SUCCESS, comment);
            }
        } catch (EmptyResultDataAccessException e) {
            return new Result(CommentDaoInfo.EMPTY_RESULT, null);
        } catch (NullPointerException e) {
            return new Result(CommentDaoInfo.INFO_MISSING, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(CommentDaoInfo.OTHER_ERROR, null);
        }
    }

    public Result createOriginalComment(int orderId, String description, int score) {
        try {
            String sql = "INSERT INTO comments(order_id,description,score,type) VALUES (?, ?, ?, ?)";
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, orderId);
                ps.setString(2, description);
                ps.setInt(3, score);
                ps.setString(4,Comment.Type.ORIGINAL.name().toLowerCase());
                return ps;
            }, keyHolder);
            int id = keyHolder.getKey().intValue();

            return new Result(CommentDaoInfo.SUCCESS, id);
        }catch (DuplicateKeyException e) {
            return new Result(CommentDaoInfo.DUPLICATE_KEY, null);
        }catch (NullPointerException e) {
            return new Result(CommentDaoInfo.INFO_MISSING, null);
        }catch (Exception e) {
            e.printStackTrace();
            return new Result(CommentDaoInfo.OTHER_ERROR, null);
        }

    }

    @Override
    public Result createFollowComment(int orderId, int lastId, String description) {
        try {
            String sql = "INSERT INTO comments(order_id,description,type) VALUES (?, ?, ?)";
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, orderId);
                ps.setString(2, description);
                ps.setString(3,Comment.Type.FOLLOW.name().toLowerCase());
                return ps;
            }, keyHolder);
            int id = keyHolder.getKey().intValue();
            String _sql = "update comments set next_id=? where id=?";
            return new Result(executeUpdate(_sql,id,lastId),id);
        }catch (DuplicateKeyException e) {
            return new Result(CommentDaoInfo.DUPLICATE_KEY, null);
        }catch (NullPointerException e) {
            return new Result(CommentDaoInfo.INFO_MISSING, null);
        }catch (Exception e) {
            e.printStackTrace();
            return new Result(CommentDaoInfo.OTHER_ERROR, null);
        }
    }

    @Override
    public Result createReplyComment(int orderId, int lastId, String description) {
        try {
            String sql = "INSERT INTO comments(order_id,description,type) VALUES (?, ?, ?)";
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, orderId);
                ps.setString(2, description);
                ps.setString(3,Comment.Type.REPLY.name().toLowerCase());
                return ps;
            }, keyHolder);
            int id = keyHolder.getKey().intValue();
            String _sql = "update comments set next_id=? where id=?";
            return new Result(executeUpdate(_sql,id,lastId),id);
        }catch (DuplicateKeyException e) {
            return new Result(CommentDaoInfo.DUPLICATE_KEY, null);
        }catch (NullPointerException e) {
            return new Result(CommentDaoInfo.INFO_MISSING, null);
        }catch (Exception e) {
            e.printStackTrace();
            return new Result(CommentDaoInfo.OTHER_ERROR, null);
        }
    }

    @Override
    public CommentDaoInfo deleteComment(int id) {
        try {
            if(id==-1)
                return CommentDaoInfo.SUCCESS;
            else {
                String sql = "select next_id from comments where id=?";
                int nextId = jdbcTemplate.queryForObject(sql,Integer.class,id);
                String _sql = "delete from comments where id=?";
                jdbcTemplate.update(_sql,id);
                return deleteComment(nextId);
            }
        }catch (Exception e){
            e.printStackTrace();
            return CommentDaoInfo.OTHER_ERROR;
        }
    }

    @Override
    public Result getOriginalComments(int productId) {
        String sql ="SELECT *FROM comments c\n" +
                "JOIN orders o ON c.order_id = o.id\n" +
                "WHERE o.product_id = ? AND c.TYPE = ?;\n";
        return executeQuery(sql,true,productId,Comment.Type.ORIGINAL.name().toLowerCase());
    }

    @Override
    public Result getCommentById(int id) {
        String sql="select * from comments where id=?";
        return executeQuery(sql,false,id);
    }

    @Override
    public Result getAllComments(int id) {
        try {
            List<Comment> comments=new ArrayList<>();
            int _id=id;
            while (_id != -1) {
                String sql = "select * from comments where id=?";
                Comment comment = (Comment) executeQuery(sql, false, _id).getValue();
                _id = comment.getNextId();
                comments.add(comment);
            }
            return new Result(CommentDaoInfo.SUCCESS, comments);
        }catch (Exception e){
            e.printStackTrace();
            return new Result(CommentDaoInfo.OTHER_ERROR,null);
        }
    }

    @Override
    public Result getAvgScoreByProductId(int id) {
        try {
            String sql = "SELECT AVG(score) AS average_score\n" +
                    "FROM comments\n" +
                    "WHERE order_id IN (\n" +
                    "    SELECT id\n" +
                    "    FROM orders\n" +
                    "    WHERE product_id = ?\n" +
                    ");\n";
            double avgScore = jdbcTemplate.queryForObject(sql,Double.class,id);
            return new Result(CommentDaoInfo.SUCCESS, avgScore);
        }catch (DuplicateKeyException e) {
            return new Result(CommentDaoInfo.DUPLICATE_KEY, null);
        }catch (NullPointerException e) {
            return new Result(CommentDaoInfo.INFO_MISSING, null);
        }catch (Exception e) {
            e.printStackTrace();
            return new Result(CommentDaoInfo.OTHER_ERROR, null);
        }
    }

    @Override
    public Result getOriginalCommentByOrderId(int id)
    {
        String sql="select * from comments where order_id=? and type=?";
        return executeQuery(sql,false,id,Comment.Type.ORIGINAL.name().toLowerCase());
    }

    @Override
    public CommentDaoInfo changeScoreByOrderId(int id, int score)
    {
        String sql="update comments set score=? where order_id=? and type=?";
        return executeUpdate(sql,score,id,Comment.Type.ORIGINAL.name().toLowerCase());
    }
}
