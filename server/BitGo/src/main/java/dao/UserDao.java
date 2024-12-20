package dao;

import domain.User;
import domain.info.Result;
import domain.info.impl.dao.UserDaoInfo;

public interface UserDao {
    UserDaoInfo createUser(String account, String userName, String password, String email);
    Result getUserById(int id);
    Result getUserByAccountAndPassword(String account, String password);
    Result getUserByUserName(String userName);
    Result getUserByEmail(String email);
    UserDaoInfo changePassword(int id, String newPassword);
    UserDaoInfo changeState(int id, User.UserState state);
    UserDaoInfo changeEmail(int id, String newEmail);
    UserDaoInfo changeUserName(int id, String newUserName);
    UserDaoInfo deleteUser(int id);

}
