package domain.mapper;

import domain.Comment;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class CommentMapper implements RowMapper<Comment>{
    @Override
    public Comment mapRow(ResultSet rs, int rowNum) throws SQLException {
        Comment comment = new Comment();
        comment.setId(rs.getInt("id"));
        comment.setOrderId(rs.getInt("order_id"));
        comment.setDescription(rs.getString("description"));
        comment.setScore(rs.getInt("score"));
        comment.setDate(rs.getDate("date"));
        comment.setNextId(rs.getInt("next_id"));
        String typeStr = rs.getString("type");
        if(typeStr!=null){
            comment.setType(Comment.Type.valueOf(typeStr.toUpperCase()));
        }
       return comment;
    }
}
