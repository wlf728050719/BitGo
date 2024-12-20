package service;

import domain.info.Result;
import domain.info.impl.service.UserFavoriteServiceInfo;

public interface UserFavoriteService {
    UserFavoriteServiceInfo addUserFavorite(int userId, int productId);
    Result getUserFavoritesByUserId(int userId);
    UserFavoriteServiceInfo removeUserFavorite(int userId, int productId);
    Result getUserFavoriteByUserIdAndProductId(int userId, int productId);
}
