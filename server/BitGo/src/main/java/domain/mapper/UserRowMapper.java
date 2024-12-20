package domain.mapper;

import domain.User;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UserRowMapper implements RowMapper<User> {
    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setAccount(rs.getString("account"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password")); // 注意大小写
        user.setEmail(rs.getString("email"));
        // 手动转换字符串到 UserState
        String stateStr = rs.getString("state");
        if (stateStr != null) {
            user.setState(User.UserState.valueOf(stateStr.toUpperCase())); // 转换为大写以匹配枚举
        }
        user.setLastLogin(rs.getTimestamp("last_login"));
        return user;
    }
}
