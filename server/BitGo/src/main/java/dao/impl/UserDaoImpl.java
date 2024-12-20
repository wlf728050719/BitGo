package dao.impl;

import dao.UserDao;
import domain.User;
import domain.info.Result;
import domain.info.impl.dao.UserDaoInfo;
import domain.mapper.UserRowMapper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtil;

public class UserDaoImpl implements UserDao {
    private static final JdbcTemplate jdbcTemplate = new JdbcTemplate(JDBCUtil.getDataSource());

    private UserDaoInfo executeUpdate(String sql, Object... args) {
        try {
            jdbcTemplate.update(sql, args);
        } catch (DuplicateKeyException e) {
            return UserDaoInfo.DUPLICATE_KEY;
        } catch (NullPointerException e) {
            return UserDaoInfo.INFO_MISSING;
        } catch (Exception e) {
            e.printStackTrace();
            return UserDaoInfo.OTHER_ERROR;
        }
        return UserDaoInfo.SUCCESS;
    }

    private Result executeQuery(String sql, Object... args) {
        try {
            User user = jdbcTemplate.queryForObject(sql, new UserRowMapper(), args);
            return new Result(UserDaoInfo.SUCCESS, user);
        } catch (EmptyResultDataAccessException e) {
            return new Result(UserDaoInfo.EMPTY_RESULT, null);
        } catch (NullPointerException e) {
            return new Result(UserDaoInfo.INFO_MISSING, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(UserDaoInfo.OTHER_ERROR, null);
        }
    }

    @Override
    public UserDaoInfo createUser(String account, String userName, String password, String email) {
        String sql = "insert into users(account,username,password,email) values(?,?,?,?)";
        return executeUpdate(sql, account, userName, password, email);
    }

    @Override
    public Result getUserById(int id) {
        String sql = "select * from users where id = ?";
        return executeQuery(sql, id);
    }

    @Override
    public Result getUserByAccountAndPassword(String account, String password) {
        String sql = "select * from users where account=? and password=?";
        return executeQuery(sql, account, password);
    }

    @Override
    public Result getUserByUserName(String userName) {
        String sql = "select * from users where username=?";
        return executeQuery(sql, userName);
    }

    @Override
    public Result getUserByEmail(String email) {
        String sql = "select * from users where email=?";
        return executeQuery(sql, email);
    }

    @Override
    public UserDaoInfo changePassword(int id, String newPassword) {
        String sql = "update users set password=? where id=?";
        return executeUpdate(sql, newPassword, id);
    }

    @Override
    public UserDaoInfo changeState(int id, User.UserState state) {
        String sql = "update users set state=? where id=?";
        return executeUpdate(sql, state.toString().toLowerCase(), id);
    }

    @Override
    public UserDaoInfo changeEmail(int id, String newEmail) {
        String sql = "update users set email=? where id=?";
        return executeUpdate(sql, newEmail, id);
    }

    @Override
    public UserDaoInfo changeUserName(int id, String newUserName) {
        String sql = "update users set username=? where id=?";
        return executeUpdate(sql, newUserName, id);
    }

    @Override
    public UserDaoInfo deleteUser(int id) {
        String sql = "delete from users where id=?";
        return jdbcTemplate.update(sql, id) > 0 ? UserDaoInfo.SUCCESS : UserDaoInfo.EMPTY_RESULT;
    }

}
