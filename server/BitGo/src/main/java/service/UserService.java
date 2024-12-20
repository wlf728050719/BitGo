package service;

import domain.info.Result;
import domain.info.impl.service.UserServiceInfo;

public interface UserService {
    Result login(String account, String password);

    UserServiceInfo logout(int id);

    UserServiceInfo register(String account, String username, String password, String email);

    Result getUserById(int id);

    UserServiceInfo changeUsername(int id, String username);

    UserServiceInfo changePassword(int id, String password);

    UserServiceInfo changeEmail(int id, String email);
}
