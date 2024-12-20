package dao.impl;

import dao.UserFavoriteDao;
import domain.UserFavorite;
import domain.info.Result;
import domain.info.impl.dao.UserFavoriteDaoInfo;
import domain.mapper.UserFavoriteMapper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtil;

import java.util.List;

public class UserFavoriteDaoImpl implements UserFavoriteDao {
    private static final JdbcTemplate jdbcTemplate = new JdbcTemplate(JDBCUtil.getDataSource());
    private UserFavoriteDaoInfo executeUpdate(String sql, Object... args) {
        try {
            jdbcTemplate.update(sql, args);
        } catch (DuplicateKeyException e) {
            return UserFavoriteDaoInfo.DUPLICATE_KEY;
        } catch (NullPointerException e) {
            return UserFavoriteDaoInfo.INFO_MISSING;
        } catch (Exception e) {
            e.printStackTrace();
            return UserFavoriteDaoInfo.OTHER_ERROR;
        }
        return UserFavoriteDaoInfo.SUCCESS;
    }

    private Result executeQuery(String sql,boolean isList,Object... args) {
        try {
            if(isList)
            {
                List<UserFavorite> userFavoriteList = jdbcTemplate.query(sql,new UserFavoriteMapper(),args);
                return new Result(UserFavoriteDaoInfo.SUCCESS, userFavoriteList);
            }
            else
            {
                UserFavorite userFavorite = jdbcTemplate.queryForObject(sql,new UserFavoriteMapper(),args);
                return new Result(UserFavoriteDaoInfo.SUCCESS, userFavorite);
            }
        } catch (EmptyResultDataAccessException e) {
            return new Result(UserFavoriteDaoInfo.EMPTY_RESULT, null);
        } catch (NullPointerException e) {
            return new Result(UserFavoriteDaoInfo.INFO_MISSING, null);
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(UserFavoriteDaoInfo.OTHER_ERROR, null);
        }
    }
    @Override
    public UserFavoriteDaoInfo addUserFavorite(int userId, int productId) {
        System.out.println("userId:"+userId+",productId:"+productId);
        String sql = "insert into user_favorites(user_id, product_id) values(?, ?)";
        return executeUpdate(sql, userId, productId);
    }

    @Override
    public Result getUserFavoritesByUserId(int userId) {
        String sql = "select * from user_favorites where user_id = ?";
        return executeQuery(sql,true,userId);
    }

    @Override
    public UserFavoriteDaoInfo removeUserFavorite(int userId, int productId) {
        String sql = "delete from user_favorites where user_id = ? and product_id = ?";
        return executeUpdate(sql, userId, productId);
    }

    @Override
    public Result getUserFavoriteByUserIdAndProductId(int userId, int productId) {
        String sql = "select * from user_favorites where user_id = ? and product_id = ?";
        return executeQuery(sql,false,userId,productId);
    }
}
