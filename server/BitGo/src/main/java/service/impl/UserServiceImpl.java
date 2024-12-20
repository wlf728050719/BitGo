package service.impl;

import dao.UserDao;
import dao.impl.UserDaoImpl;
import domain.User;
import domain.info.Info;
import domain.info.Result;
import domain.info.impl.dao.UserDaoInfo;
import domain.info.impl.service.UserServiceInfo;
import service.UserService;

public class UserServiceImpl implements UserService {
    private final UserDao userDao=new UserDaoImpl();

    private Result changeToUserServiceResult(Result result) {
        switch ((UserDaoInfo)result.getInfo())
        {
            case SUCCESS:return new Result(UserServiceInfo.SUCCESS,result.getValue());
            case EMPTY_RESULT:return new Result(UserServiceInfo.ERROR_INFO,null);
            case DUPLICATE_KEY:return new Result(UserServiceInfo.DUPLICATE_INFO,null);
            default:return new Result(UserServiceInfo.OTHER_ERROR,null);
        }
    }
    private UserServiceInfo changeToUserServiceInfo(Info info) {
        switch ((UserDaoInfo)info)
        {
            case SUCCESS:return UserServiceInfo.SUCCESS;
            case EMPTY_RESULT:return UserServiceInfo.ERROR_INFO;
            case DUPLICATE_KEY:return UserServiceInfo.DUPLICATE_INFO;
            default:return UserServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public Result login(String account, String password) {
        Result result = userDao.getUserByAccountAndPassword(account, password);
        switch ((UserDaoInfo)result.getInfo())
        {
            case SUCCESS:{
                User user=(User)result.getValue();
                switch (user.getState())
                {
                    case ACTIVE: {
                        user.setState(User.UserState.USING);
                        if(userDao.changeState(user.getId(), User.UserState.USING).equals(UserDaoInfo.SUCCESS))
                            return new Result(UserServiceInfo.SUCCESS, user);
                        else
                            return new Result(UserServiceInfo.OTHER_ERROR,null);
                    }
                    case USING:return  new Result(UserServiceInfo.IS_USING,null);
                    case BANNED:return new Result(UserServiceInfo.IS_BANNED,null);
                    case CANCELLED:return new Result(UserServiceInfo.IS_CANCELLED,null);
                    case FROZEN:return new Result(UserServiceInfo.IS_FROZEN,null);
                }
            }
            case EMPTY_RESULT:return new Result(UserServiceInfo.ERROR_INFO,null);
            case INFO_MISSING:return new Result(UserServiceInfo.INFO_MISSING,null);
            default:return new Result(UserServiceInfo.OTHER_ERROR,null);
        }
    }

    @Override
    public UserServiceInfo logout(int id) {
        switch (userDao.changeState(id, User.UserState.ACTIVE))
        {
            case SUCCESS:return UserServiceInfo.SUCCESS;
            case INFO_MISSING:return UserServiceInfo.INFO_MISSING;
            default:return UserServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public UserServiceInfo register(String account, String username, String password, String email) {
        switch (userDao.createUser(account, username, password, email))
        {
            case SUCCESS:return UserServiceInfo.SUCCESS;
            case INFO_MISSING:return UserServiceInfo.INFO_MISSING;
            case DUPLICATE_KEY:return UserServiceInfo.DUPLICATE_INFO;
            default:return UserServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public Result getUserById(int id) {
        return changeToUserServiceResult(userDao.getUserById(id));
    }
    @Override
    public UserServiceInfo changeUsername(int id, String username) {
        return changeToUserServiceInfo(userDao.changeUserName(id, username));
    }
    @Override
    public UserServiceInfo changePassword(int id, String password) {
        return changeToUserServiceInfo(userDao.changePassword(id, password));
    }
    @Override
    public UserServiceInfo changeEmail(int id, String email) {
        return changeToUserServiceInfo(userDao.changeEmail(id, email));
    }
}
