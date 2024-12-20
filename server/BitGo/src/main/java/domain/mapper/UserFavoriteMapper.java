package domain.mapper;

import domain.UserFavorite;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UserFavoriteMapper implements RowMapper<UserFavorite> {

    @Override
    public UserFavorite mapRow(ResultSet resultSet, int i) throws SQLException {
        UserFavorite userFavorite = new UserFavorite();
        userFavorite.setId(resultSet.getInt("id"));
        userFavorite.setProductId(resultSet.getInt("product_id"));
        userFavorite.setUserId(resultSet.getInt("user_id"));
        userFavorite.setDate(resultSet.getDate("date"));
        return userFavorite;
    }
}
