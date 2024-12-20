package service.impl;

import dao.UserFavoriteDao;
import dao.impl.UserFavoriteDaoImpl;
import domain.info.Info;
import domain.info.Result;
import domain.info.impl.dao.UserFavoriteDaoInfo;
import domain.info.impl.service.UserFavoriteServiceInfo;
import service.UserFavoriteService;

public class UserFavoriteServiceImpl implements UserFavoriteService {

    private final UserFavoriteDao userFavoriteDao=new UserFavoriteDaoImpl();
    private Result changeToUserFavoriteServiceResult(Result result) {
        switch ((UserFavoriteDaoInfo)result.getInfo())
        {
            case SUCCESS:return new Result(UserFavoriteServiceInfo.SUCCESS,result.getValue());
            case EMPTY_RESULT:return new Result(UserFavoriteServiceInfo.EMPTY_RESULT,null);
            default:return new Result(UserFavoriteServiceInfo.OTHER_ERROR,null);
        }
    }
    private UserFavoriteServiceInfo changeToUserFavoriteServiceInfo(Info info) {
        switch ((UserFavoriteDaoInfo)info)
        {
            case SUCCESS:return UserFavoriteServiceInfo.SUCCESS;
            case EMPTY_RESULT:return UserFavoriteServiceInfo.EMPTY_RESULT;
            default:return UserFavoriteServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public UserFavoriteServiceInfo addUserFavorite(int userId, int productId) {
        return changeToUserFavoriteServiceInfo(userFavoriteDao.addUserFavorite(userId,productId));
    }

    @Override
    public Result getUserFavoritesByUserId(int userId) {
        return changeToUserFavoriteServiceResult(userFavoriteDao.getUserFavoritesByUserId(userId));
    }

    @Override
    public UserFavoriteServiceInfo removeUserFavorite(int userId, int productId) {
        return changeToUserFavoriteServiceInfo(userFavoriteDao.removeUserFavorite(userId,productId));
    }

    @Override
    public Result getUserFavoriteByUserIdAndProductId(int userId, int productId) {
        return changeToUserFavoriteServiceResult(userFavoriteDao.getUserFavoriteByUserIdAndProductId(userId,productId));
    }
}
