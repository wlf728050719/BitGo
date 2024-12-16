package service;

import domain.info.Result;
import domain.info.impl.service.UserServiceInfo;

public interface UserService {
    Result login(String account, String password);

    UserServiceInfo logout(int id);

    UserServiceInfo register(String account, String username, String password, String email);

    Result getUserById(int id);
}
