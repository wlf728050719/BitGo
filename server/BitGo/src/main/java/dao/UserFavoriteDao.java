package dao;

import domain.info.Result;
import domain.info.impl.dao.UserFavoriteDaoInfo;

public interface UserFavoriteDao {
    UserFavoriteDaoInfo addUserFavorite(int userId, int productId);
    Result getUserFavoritesByUserId(int userId);
    UserFavoriteDaoInfo removeUserFavorite(int userId, int productId);
    Result getUserFavoriteByUserIdAndProductId(int userId, int productId);
}
